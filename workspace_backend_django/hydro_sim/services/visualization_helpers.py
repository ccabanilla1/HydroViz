import numpy as np
import matplotlib.pyplot as plt
from matplotlib.figure import Figure
from matplotlib.backends.backend_agg import FigureCanvasAgg
from io import BytesIO
import base64
from typing import Dict, Any, List, Tuple, Optional
import json
from ..services.simulation_engine import SimulationEngine

class SimulationVisualizer:
    def __init__(self, simulation_data: Dict[str, Any]):
        """
        Initialize visualizer with simulation data
        
        Args:
            simulation_data: Dictionary containing simulation results
        """
        self.data = simulation_data
        self.mesh_x = np.array(simulation_data['mesh_coordinates']['x'])
        self.mesh_y = np.array(simulation_data['mesh_coordinates']['y'])
        self.hydraulic_head = np.array(simulation_data['hydraulic_head'])
        self.wells = simulation_data.get('wells', [])
        
        if 'velocity_field' in simulation_data:
            self.vx = np.array(simulation_data['velocity_field']['vx'])
            self.vy = np.array(simulation_data['velocity_field']['vy'])
        else:
            self.vx = self.vy = None

    def create_head_contour(self, figsize: Tuple[int, int] = (10, 8)) -> str:
        """Create contour plot of hydraulic head"""
        fig = Figure(figsize=figsize)
        ax = fig.add_subplot(111)
        
        # Create contour plot
        contour = ax.contourf(self.mesh_x, self.mesh_y, self.hydraulic_head, 
                             levels=20, cmap='viridis')
        fig.colorbar(contour, ax=ax, label='Hydraulic Head (m)')
        
        # Plot wells
        for well in self.wells:
            marker = 'v' if well['type'] == 'pumping' else '^'
            color = 'red' if well['type'] == 'pumping' else 'blue'
            ax.plot(well['x'], well['y'], marker=marker, color=color, 
                   markersize=10, label=well['type'])
        
        ax.set_xlabel('X Distance (m)')
        ax.set_ylabel('Y Distance (m)')
        ax.set_title('Hydraulic Head Distribution')
        ax.legend()
        
        # Convert plot to base64 string
        return self._fig_to_base64(fig)

    def create_velocity_plot(self, figsize: Tuple[int, int] = (10, 8)) -> str:
        """Create velocity vector plot"""
        if self.vx is None or self.vy is None:
            return None
            
        fig = Figure(figsize=figsize)
        ax = fig.add_subplot(111)
        
        # Subsample velocity vectors for clarity
        skip = 2
        ax.quiver(self.mesh_x[::skip, ::skip], self.mesh_y[::skip, ::skip],
                 self.vx[::skip, ::skip], self.vy[::skip, ::skip],
                 scale=50, width=0.002)
        
        # Plot wells
        for well in self.wells:
            marker = 'v' if well['type'] == 'pumping' else '^'
            color = 'red' if well['type'] == 'pumping' else 'blue'
            ax.plot(well['x'], well['y'], marker=marker, color=color, 
                   markersize=10, label=well['type'])
        
        ax.set_xlabel('X Distance (m)')
        ax.set_ylabel('Y Distance (m)')
        ax.set_title('Groundwater Velocity Field')
        ax.legend()
        
        return self._fig_to_base64(fig)

    def create_well_hydrograph(self, well_coords: Tuple[float, float], 
                             time_steps: List[float], heads: List[float],
                             figsize: Tuple[int, int] = (10, 6)) -> str:
        """Create hydrograph for a specific well"""
        fig = Figure(figsize=figsize)
        ax = fig.add_subplot(111)
        
        ax.plot(time_steps, heads, 'b-', marker='o')
        ax.set_xlabel('Time (days)')
        ax.set_ylabel('Hydraulic Head (m)')
        ax.set_title(f'Well Hydrograph at ({well_coords[0]}, {well_coords[1]})')
        ax.grid(True)
        
        return self._fig_to_base64(fig)

    def create_parameter_plot(self, parameter: str, 
                            figsize: Tuple[int, int] = (10, 8)) -> str:
        """Create plot of hydraulic parameters"""
        if parameter not in self.data['parameters']:
            return None
            
        fig = Figure(figsize=figsize)
        ax = fig.add_subplot(111)
        
        param_data = np.array(self.data['parameters'][parameter])
        contour = ax.contourf(self.mesh_x, self.mesh_y, param_data, 
                            levels=20, cmap='viridis')
        fig.colorbar(contour, ax=ax, label=parameter)
        
        ax.set_xlabel('X Distance (m)')
        ax.set_ylabel('Y Distance (m)')
        ax.set_title(f'{parameter} Distribution')
        
        return self._fig_to_base64(fig)

    @staticmethod
    def _fig_to_base64(fig: Figure) -> str:
        """Convert matplotlib figure to base64 string"""
        canvas = FigureCanvasAgg(fig)
        buffer = BytesIO()
        canvas.print_png(buffer)
        return base64.b64encode(buffer.getvalue()).decode('utf-8')

    def get_flutter_visualization_data(self) -> Dict[str, Any]:
        """Prepare data for Flutter frontend visualization"""
        return {
            'mesh': {
                'x': self.mesh_x.tolist(),
                'y': self.mesh_y.tolist(),
            },
            'hydraulic_head': self.hydraulic_head.tolist(),
            'velocity_field': {
                'vx': self.vx.tolist() if self.vx is not None else None,
                'vy': self.vy.tolist() if self.vy is not None else None
            },
            'wells': self.wells,
            'parameters': self.data['parameters'],
            'contours': {
                'min_head': float(np.min(self.hydraulic_head)),
                'max_head': float(np.max(self.hydraulic_head)),
                'contour_levels': 20
            }
        }

    def export_results(self, filename: str) -> None:
        """Export simulation results to JSON file"""
        export_data = {
            'mesh_coordinates': {
                'x': self.mesh_x.tolist(),
                'y': self.mesh_y.tolist()
            },
            'hydraulic_head': self.hydraulic_head.tolist(),
            'velocity_field': {
                'vx': self.vx.tolist() if self.vx is not None else None,
                'vy': self.vy.tolist() if self.vy is not None else None
            },
            'wells': self.wells,
            'parameters': self.data['parameters']
        }
        
        with open(filename, 'w') as f:
            json.dump(export_data, f, indent=2)
