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
    SimulationResultViewSet,
    # Add Components view
    ComponentViewSet  # Make sure to import this
)

# Create a single router for all endpoints
router = DefaultRouter()

# Register physical data endpoints
router.register(r'projects', ProjectViewSet, basename='project')
router.register(r'wells', WellViewSet, basename='well')
router.register(r'aquifer-properties', AquiferPropertiesViewSet, basename='aquifer')
router.register(r'measurements', FieldMeasurementViewSet, basename='measurement')

# Register simulation endpoints
router.register(r'simulation-projects', SimulationProjectViewSet, basename='simulation-project')
router.register(r'simulation-models', SimulationModelViewSet, basename='simulation-model')
router.register(r'simulation-results', SimulationResultViewSet, basename='simulation-result')

# Register components endpoint
router.register(r'components', ComponentViewSet, basename='component')

urlpatterns = [
    # Django admin
    path('admin/', admin.site.urls),
    
    # API endpoints - all under /api/
    path('api/', include(router.urls)),
    
    # Authentication
    path('api-auth/', include('rest_framework.urls')),
    
    # Include hydro_sim URLs
    path('', include('hydro_sim.urls')),
]