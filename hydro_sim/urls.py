from django.urls import path
from rest_framework.routers import DefaultRouter
from .views import (
    # Views for physical data
    ProjectViewSet,
    WellViewSet,
    AquiferPropertiesViewSet,
    FieldMeasurementViewSet,
    # Views for simulation data
    SimulationProjectViewSet,
    SimulationModelViewSet,
    SimulationResultViewSet
)

# Namespace for the hydro_sim app URLs
app_name = 'hydro_sim'

# Router for handling model viewsets
router = DefaultRouter()

# Custom URL patterns (if needed beyond viewsets)
urlpatterns = [
    # Add specific URLs here
]

# Combine router URLs with custom URLs
urlpatterns += router.urls