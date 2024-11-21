# Main URL configuration for HydroViz app
from django.contrib import admin
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from hydro_sim.views import (
    # Physical data views
    ProjectViewSet,
    WellViewSet,
    AquiferPropertiesViewSet,
    FieldMeasurementViewSet,
    # Simulation views
    SimulationProjectViewSet,
    SimulationModelViewSet,
    SimulationResultViewSet
)

# Router for physical data (wells, measurements, etc.)
physical_router = DefaultRouter()
physical_router.register(r'projects', ProjectViewSet, basename='project')
physical_router.register(r'wells', WellViewSet, basename='well')
physical_router.register(r'aquifer-properties', AquiferPropertiesViewSet, basename='aquifer')
physical_router.register(r'measurements', FieldMeasurementViewSet, basename='measurement')

# Router for simulation data
simulation_router = DefaultRouter()
simulation_router.register(r'simulation-projects', SimulationProjectViewSet, basename='simulation-project')
simulation_router.register(r'simulation-models', SimulationModelViewSet, basename='simulation-model')
simulation_router.register(r'simulation-results', SimulationResultViewSet, basename='simulation-result')

urlpatterns = [
    # Django admin interface
    path('admin/', admin.site.urls),
    
    # API endpoints
    path('api/physical/', include(physical_router.urls)),
    path('api/simulation/', include(simulation_router.urls)),
    
    # Authentication for browsable API
    path('api-auth/', include('rest_framework.urls')),
]