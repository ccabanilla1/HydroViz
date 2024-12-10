from typing import Dict, Any, List, Optional, Tuple
import numpy as np
from scipy.sparse import lil_matrix, csr_matrix
from scipy.sparse.linalg import spsolve
from dataclasses import dataclass
from enum import Enum

class WellType(Enum):
    PUMPING = "pumping"
    INJECTION = "injection"
    OBSERVATION = "observation"

@dataclass
class Well:
    """Well configuration for simulation"""
    x: float  # x-coordinate [m]
    y: float  # y-coordinate [m]
    well_type: WellType
    rate: float = 0.0  # pumping/injection rate [m³/day], positive for injection
    radius: float = 0.15  # well radius [m]
    screen_top: float = 0.0  # screen top elevation [m]
    screen_bottom: float = 0.0  # screen bottom elevation [m]
    
    def is_active(self) -> bool:
        """Check if well is actively pumping or injecting"""
        return self.well_type in [WellType.PUMPING, WellType.INJECTION] and abs(self.rate) > 0

@dataclass
class HydraulicParameters:
    """Physical parameters for groundwater simulation"""
    hydraulic_conductivity: np.ndarray  # K [m/day], can be 2D array for heterogeneity
    specific_storage: np.ndarray       # Ss [1/m]
    porosity: np.ndarray              # η [-]
    aquifer_thickness: float          # b [m]
    anisotropy_ratio: float = 1.0     # Kz/Kh ratio
    
    @classmethod
    def create_homogeneous(cls, nx: int, ny: int, k: float = 10.0, 
                          ss: float = 1e-5, n: float = 0.3, b: float = 50.0):
        """Create homogeneous parameter set"""
        return cls(
            hydraulic_conductivity=np.full((ny, nx), k),
            specific_storage=np.full((ny, nx), ss),
            porosity=np.full((ny, nx), n),
            aquifer_thickness=b
        )
    
    @classmethod
    def create_layered(cls, nx: int, ny: int, k_layers: List[float], 
                      layer_heights: List[int]):
        """Create layered aquifer parameters"""
        k = np.zeros((ny, nx))
        for k_val, height in zip(k_layers, layer_heights):
            k[:height, :] = k_val
        return cls(
            hydraulic_conductivity=k,
            specific_storage=np.full((ny, nx), 1e-5),
            porosity=np.full((ny, nx), 0.3),
            aquifer_thickness=sum(layer_heights)
        )

class SimulationEngine:
    def __init__(self, project):
        self.project = project
        self.mesh = None
        self.solver = None
        self.boundary_conditions = {}
        self.hydraulic_head = None
        self.velocity_field = None
        self.parameters = None
        self.dx = None
        self.dy = None
        self.dt = 1.0  # Time step [days]
        self.wells: List[Well] = []
        self.stress_period = 0
        
    def add_well(self, well: Well) -> None:
        """Add a well to the simulation"""
        self.wells.append(well)
        
    def remove_well(self, x: float, y: float) -> bool:
        """Remove a well at the specified location"""
        initial_length = len(self.wells)
        self.wells = [w for w in self.wells if not (np.isclose(w.x, x) and np.isclose(w.y, y))]
        return len(self.wells) < initial_length
    
    def get_well_cell_indices(self, well: Well) -> Tuple[int, int]:
        """Convert well coordinates to grid indices"""
        j = int(np.clip(well.x / self.dx, 0, self.mesh[0].shape[1] - 1))
        i = int(np.clip(well.y / self.dy, 0, self.mesh[0].shape[0] - 1))
        return i, j

    def initialize_simulation(self, params: Optional[HydraulicParameters] = None,
                            nx: int = 50, ny: int = 50) -> Dict[str, Any]:
        """Initialize the simulation components with physical parameters."""
        try:
            # Set default parameters if none provided
            self.parameters = params or HydraulicParameters.create_homogeneous(nx, ny)
            
            # Initialize mesh
            self.mesh = self.create_mesh(nx, ny)
            # Set up boundary conditions
            self.setup_boundaries()
            # Initialize solver
            self.solver = self.initialize_solver()
            # Initialize hydraulic head array
            self.hydraulic_head = np.zeros((ny, nx))
            # Apply initial conditions
            self.apply_initial_conditions()
            
            return {
                'mesh_elements': self.mesh[0].size,
                'status': 'initialized',
                'dx': self.dx,
                'dy': self.dy,
                'dt': self.dt,
                'project_id': self.project.id if hasattr(self.project, 'id') else None,
                'wells': len(self.wells)
            }
        except Exception as e:
            return {
                'status': 'error',
                'error_message': str(e)
            }

    def assemble_system_matrix(self) -> Tuple[csr_matrix, np.ndarray]:
        """Assemble the system matrix and RHS vector including wells."""
        nx, ny = self.mesh[0].shape
        n = nx * ny
        
        # Create sparse matrix
        A = lil_matrix((n, n))
        b = np.zeros(n)
        
        # Get hydraulic parameters
        K = self.parameters.hydraulic_conductivity
        Ss = self.parameters.specific_storage
        b_aquifer = self.parameters.aquifer_thickness
        
        for i in range(ny):
            for j in range(nx):
                idx = i * nx + j
                
                # Interior nodes
                if 0 < i < ny-1 and 0 < j < nx-1:
                    # Transmissivity at cell interfaces
                    tx_left = 0.5 * (K[i,j-1] + K[i,j]) * b_aquifer / (self.dx ** 2)
                    tx_right = 0.5 * (K[i,j+1] + K[i,j]) * b_aquifer / (self.dx ** 2)
                    ty_bottom = 0.5 * (K[i-1,j] + K[i,j]) * b_aquifer / (self.dy ** 2)
                    ty_top = 0.5 * (K[i+1,j] + K[i,j]) * b_aquifer / (self.dy ** 2)
                    
                    A[idx, idx] = -(tx_left + tx_right + ty_bottom + ty_top + Ss[i,j]/self.dt)
                    A[idx, idx+1] = tx_right
                    A[idx, idx-1] = tx_left
                    A[idx, idx+nx] = ty_top
                    A[idx, idx-nx] = ty_bottom
                    b[idx] = -Ss[i,j] * self.hydraulic_head[i,j] / self.dt
                    
                    # Add well terms
                    for well in self.wells:
                        if well.is_active():
                            well_i, well_j = self.get_well_cell_indices(well)
                            if i == well_i and j == well_j:
                                b[idx] -= well.rate / (self.dx * self.dy)  # Convert to flux
                
                # Boundary conditions
                else:
                    if i == 0:  # North boundary
                        A[idx, idx] = 1
                        b[idx] = self.boundary_conditions['north']['value']
                    elif i == ny-1:  # South boundary
                        A[idx, idx] = 1
                        b[idx] = self.boundary_conditions['south']['value']
                    elif j == 0:  # West boundary
                        if self.boundary_conditions['west']['type'] == 'neumann':
                            tx = K[i,j] * b_aquifer / (self.dx ** 2)
                            ty = K[i,j] * b_aquifer / (self.dy ** 2)
                            A[idx, idx] = -(2*tx + 2*ty + Ss[i,j]/self.dt)
                            A[idx, idx+1] = 2*tx
                            A[idx, idx+nx] = ty
                            A[idx, idx-nx] = ty
                    elif j == nx-1:  # East boundary
                        if self.boundary_conditions['east']['type'] == 'neumann':
                            tx = K[i,j] * b_aquifer / (self.dx ** 2)
                            ty = K[i,j] * b_aquifer / (self.dy ** 2)
                            A[idx, idx] = -(2*tx + 2*ty + Ss[i,j]/self.dt)
                            A[idx, idx-1] = 2*tx
                            A[idx, idx+nx] = ty
                            A[idx, idx-nx] = ty
        
        return A.tocsr(), b

    def get_results(self) -> Dict[str, Any]:
        """Return current simulation results including well data."""
        well_data = []
        for well in self.wells:
            i, j = self.get_well_cell_indices(well)
            well_data.append({
                'x': well.x,
                'y': well.y,
                'type': well.well_type.value,
                'rate': well.rate,
                'head': float(self.hydraulic_head[i, j]) if self.hydraulic_head is not None else None
            })
        
        return {
            'hydraulic_head': self.hydraulic_head.tolist(),
            'velocity_field': {
                'vx': self.velocity_field[0].tolist() if self.velocity_field else None,
                'vy': self.velocity_field[1].tolist() if self.velocity_field else None
            },
            'mesh_coordinates': {
                'x': self.mesh[0].tolist(),
                'y': self.mesh[1].tolist()
            },
            'wells': well_data,
            'stress_period': self.stress_period,
            'parameters': {
                'hydraulic_conductivity': self.parameters.hydraulic_conductivity.tolist(),
                'specific_storage': self.parameters.specific_storage.tolist(),
                'porosity': self.parameters.porosity.tolist(),
                'aquifer_thickness': self.parameters.aquifer_thickness
            }
        }