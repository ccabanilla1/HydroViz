from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from django.shortcuts import get_object_or_404
from ..models import Project, SimulationModel, SimulationResult
from ..services.simulation_engine import SimulationEngine, HydraulicParameters, WellType
from ..serializers.simulation_serializers import (
    SimulationModelSerializer,
    SimulationResultSerializer
)
from ..services.visualization_helpers import SimulationVisualizer

class SimulationProjectViewSet(viewsets.ModelViewSet):
    serializer_class = SimulationModelSerializer
    
    def get_queryset(self):
        return Project.objects.filter(owner=self.request.user)
    
    @action(detail=True, methods=['post'])
    def start_simulation(self, request, pk=None):
        project = self.get_object()
        engine = SimulationEngine(project)
        
        try:
            # Get project's aquifer properties
            aquifer_props = project.aquiferproperties_set.first()
            if not aquifer_props:
                return Response({
                    'status': 'error',
                    'message': 'Aquifer properties not defined for this project'
                }, status=status.HTTP_400_BAD_REQUEST)

            # Create hydraulic parameters
            params = HydraulicParameters.create_homogeneous(
                nx=50, ny=50,
                k=aquifer_props.hydraulic_conductivity,
                ss=aquifer_props.specific_storage,
                n=aquifer_props.porosity,
                b=aquifer_props.aquifer_thickness
            )
            
            # Initialize simulation with parameters
            init_result = engine.initialize_simulation(params=params)
            
            # Add project wells to simulation
            for well in project.well_set.all():
                engine.add_well(Well(
                    x=well.x_coordinate,
                    y=well.y_coordinate,
                    well_type=WellType(well.well_type),
                    rate=well.pumping_rate
                ))
            
            # Create simulation model
            sim_model = SimulationModel.objects.create(
                project=project,
                name=f"Simulation for {project.project_name}",
                mesh_data=init_result.get('mesh_elements'),
                boundary_conditions=engine.boundary_conditions
            )
            
            return Response({
                'status': 'success',
                'simulation_id': sim_model.id,
                'initialization': init_result
            })
            
        except Exception as e:
            return Response({
                'status': 'error',
                'message': str(e)
            }, status=status.HTTP_400_BAD_REQUEST)

class SimulationModelViewSet(viewsets.ModelViewSet):
    serializer_class = SimulationModelSerializer
    
    def get_queryset(self):
        return SimulationModel.objects.filter(project__owner=self.request.user)

    @action(detail=True, methods=['post'])
    def run_step(self, request, pk=None):
        """Run a single simulation step"""
        simulation = self.get_object()
        engine = SimulationEngine(simulation.project)
        
        try:
            # Retrieve the latest result to get current state
            latest_result = simulation.simulationresult_set.latest('created_at')
            
            # Run simulation step
            step_result = engine.run_simulation_step()
            
            # Create new result
            result = SimulationResult.objects.create(
                model=simulation,
                head_data=step_result.get('step_results', {}).get('hydraulic_head'),
                velocity_data=step_result.get('step_results', {}).get('velocity_field')
            )
            
            return Response({
                'status': 'success',
                'result': SimulationResultSerializer(result).data,
                'step_details': step_result
            })
            
        except SimulationResult.DoesNotExist:
            # If no previous results, initialize simulation
            try:
                engine.initialize_simulation()
                step_result = engine.run_simulation_step()
                result = SimulationResult.objects.create(
                    model=simulation,
                    head_data=step_result.get('step_results', {}).get('hydraulic_head'),
                    velocity_data=step_result.get('step_results', {}).get('velocity_field')
                )
                return Response({
                    'status': 'success',
                    'result': SimulationResultSerializer(result).data,
                    'step_details': step_result
                })
            except Exception as e:
                return Response({
                    'status': 'error',
                    'message': f'Error initializing simulation: {str(e)}'
                }, status=status.HTTP_400_BAD_REQUEST)
        except Exception as e:
            return Response({
                'status': 'error',
                'message': str(e)
            }, status=status.HTTP_400_BAD_REQUEST)

class SimulationResultViewSet(viewsets.ModelViewSet):
    serializer_class = SimulationResultSerializer
    
    def get_queryset(self):
        return SimulationResult.objects.filter(model__project__owner=self.request.user)

    @action(detail=True, methods=['GET'])
    def visualize(self, request, pk=None):
        """Generate visualization for simulation results"""
        result = self.get_object()
        
        try:
            # Get simulation data
            engine = SimulationEngine(result.model.project)
            simulation_data = engine.get_results()
            
            # Create visualizer
            visualizer = SimulationVisualizer(simulation_data)
            
            # Generate plots
            head_plot = visualizer.create_head_contour()
            velocity_plot = visualizer.create_velocity_plot()
            
            # Prepare data for Flutter frontend
            flutter_data = visualizer.get_flutter_visualization_data()
            
            return Response({
                'head_contour': head_plot,
                'velocity_plot': velocity_plot,
                'flutter_data': flutter_data
            })
            
        except Exception as e:
            return Response({
                'error': str(e)
            }, status=status.HTTP_400_BAD_REQUEST)