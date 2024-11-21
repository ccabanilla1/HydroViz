from rest_framework import viewsets
from rest_framework.decorators import action
from rest_framework.response import Response
from ..models import Project, Well, AquiferProperties, FieldMeasurement
from ..services.simulation_engine import SimulationEngine
from ..serializers.physical_serializers import (
    ProjectSerializer, 
    WellSerializer,
    AquiferPropertiesSerializer,
    FieldMeasurementSerializer
)

class ProjectViewSet(viewsets.ModelViewSet):
    serializer_class = ProjectSerializer
    
    # Filter projects by current user
    def get_queryset(self):
        return Project.objects.filter(owner=self.request.user)

    # Endpoint to initiate a simulation for a project
    @action(detail=True, methods=['post'])
    def start_simulation(self, request, pk=None):
        project = self.get_object()
        engine = SimulationEngine(project)
        try:
            result = engine.initialize_simulation()
            return Response({'status': 'simulation started', 'result': result})
        except Exception as e:
            return Response({'error': str(e)}, status=400)

class WellViewSet(viewsets.ModelViewSet):
    serializer_class = WellSerializer
    
    # Only show wells from user's projects
    def get_queryset(self):
        return Well.objects.filter(project__owner=self.request.user)

class AquiferPropertiesViewSet(viewsets.ModelViewSet):
    serializer_class = AquiferPropertiesSerializer
    
    # Only show aquifer data from user's projects
    def get_queryset(self):
        return AquiferProperties.objects.filter(project__owner=self.request.user)

class FieldMeasurementViewSet(viewsets.ModelViewSet):
    serializer_class = FieldMeasurementSerializer
    
    # Only show measurements from wells in user's projects
    def get_queryset(self):
        return FieldMeasurement.objects.filter(well__project__owner=self.request.user)