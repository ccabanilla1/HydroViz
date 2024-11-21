from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from django.shortcuts import get_object_or_404
from ..models import Project, SimulationModel, SimulationResult
from ..services.simulation_engine import SimulationEngine
from ..serializers.simulation_serializers import (
    SimulationModelSerializer,
    SimulationResultSerializer
)

class SimulationProjectViewSet(viewsets.ModelViewSet):
    serializer_class = SimulationModelSerializer
    
    # Only return projects owned by current user
    def get_queryset(self):
        return Project.objects.filter(owner=self.request.user)
    
    # Custom endpoint to start a new simulation
    @action(detail=True, methods=['post'])
    def start_simulation(self, request, pk=None):
        project = self.get_object()
        engine = SimulationEngine(project)
        
        try:
            # Set up initial simulation parameters
            init_result = engine.initialize_simulation()
            
            # Create a new simulation model instance
            sim_model = SimulationModel.objects.create(
                project=project,
                name=f"Simulation for {project.project_name}",
                mesh_data=init_result.get('mesh_data'),
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
    
    # Only return simulations from user's projects
    def get_queryset(self):
        return SimulationModel.objects.filter(project__owner=self.request.user)

class SimulationResultViewSet(viewsets.ModelViewSet):
    serializer_class = SimulationResultSerializer
    
    # Only return results from user's simulation models
    def get_queryset(self):
        return SimulationResult.objects.filter(model__project__owner=self.request.user)