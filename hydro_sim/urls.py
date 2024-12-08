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
    SimulationResultViewSet,
    # Add any additional views here
)

# Namespace for the hydro_sim app URLs
app_name = 'hydro_sim'

# Router for handling model viewsets
router = DefaultRouter()

# Add any app-specific routing
# router.register(r'custom-endpoint', CustomViewSet, basename='custom')

urlpatterns = [
    # Add specific URLs here if needed
    # path('custom-path/', custom_view, name='custom-view'),
]

# Include router URLs
urlpatterns += router.urls