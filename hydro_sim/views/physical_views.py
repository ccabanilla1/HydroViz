from rest_framework import viewsets
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import AllowAny
from django.shortcuts import get_object_or_404 
from ..models import Project, Well, AquiferProperties, FieldMeasurement, Component
from ..services.simulation_engine import SimulationEngine
from ..serializers.physical_serializers import (
    ProjectSerializer, 
    WellSerializer,
    AquiferPropertiesSerializer,
    FieldMeasurementSerializer,
    ComponentSerializer
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

class ComponentViewSet(viewsets.ModelViewSet):
    serializer_class = ComponentSerializer
    permission_classes = [AllowAny]
    
    def get_queryset(self):
        return Component.objects.all()  # For testing, remove the filter
    
    def create(self, request, *args, **kwargs):
        try:
            print("Received data:", request.data)  # Debug log
            data = {
                'type': request.data.get('type'),
                'location_x': request.data.get('location_x'),  # Note the change from x to location_x
                'location_y': request.data.get('location_y'),  # Note the change from y to location_y
                'properties': request.data.get('properties', {}),
                'project': request.data.get('project')
            }
            print("Processed data:", data)  # Debug log
            
            if not data['project']:
                project = Project.objects.first()
                if not project:
                    from django.contrib.auth.models import User
                    user, _ = User.objects.get_or_create(
                        username='default_user',
                        defaults={'is_staff': True}
                    )
                    project = Project.objects.create(
                        project_name='Default Project',
                        description='Default project for development',
                        status='ACTIVE',
                        model_type='DEFAULT',
                        owner=user
                    )
                data['project'] = project.project_id
            
            serializer = self.get_serializer(data=data)
            print("Is valid:", serializer.is_valid())  # Debug log
            if not serializer.is_valid():
                print("Validation errors:", serializer.errors)  # Debug log
                return Response(serializer.errors, status=400)
                
            self.perform_create(serializer)
            return Response(serializer.data, status=201)
        except Exception as e:
            print("Error:", str(e))  # Debug log
            return Response({'error': str(e)}, status=400)