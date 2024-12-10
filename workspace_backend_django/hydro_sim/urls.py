from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views.physical_views import (
    ProjectViewSet,
    WellViewSet,
    AquiferPropertiesViewSet,
    FieldMeasurementViewSet,
    ComponentViewSet,
    HydroFileViewSet
)
from .views.simulation_views import (
    SimulationProjectViewSet,
    SimulationModelViewSet,
    SimulationResultViewSet
)

router = DefaultRouter()

# Register all viewsets
router.register(r'projects', ProjectViewSet, basename='project')
router.register(r'wells', WellViewSet, basename='well')
router.register(r'aquifer-properties', AquiferPropertiesViewSet, basename='aquifer-properties')
router.register(r'field-measurements', FieldMeasurementViewSet, basename='field-measurement')
router.register(r'components', ComponentViewSet, basename='component')
router.register(r'files', HydroFileViewSet, basename='file')
router.register(r'simulation-projects', SimulationProjectViewSet, basename='simulation-project')
router.register(r'simulation-models', SimulationModelViewSet, basename='simulation-model')
router.register(r'simulation-results', SimulationResultViewSet, basename='simulation-result')

urlpatterns = router.urls