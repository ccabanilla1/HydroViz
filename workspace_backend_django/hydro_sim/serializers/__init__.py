from .physical_serializers import (
    ProjectSerializer,
    WellSerializer,
    AquiferPropertiesSerializer,
    FieldMeasurementSerializer,
    ProjectDetailSerializer,
    WellDetailSerializer,
    ComponentSerializer  # Add this
)

from .simulation_serializers import (
    SimulationModelSerializer,
    SimulationResultSerializer,
    SimulationModelDetailSerializer
)

__all__ = [
    'ProjectSerializer',
    'WellSerializer',
    'AquiferPropertiesSerializer',
    'FieldMeasurementSerializer',
    'ProjectDetailSerializer',
    'WellDetailSerializer',
    'ComponentSerializer',  # Add this
    'SimulationModelSerializer',
    'SimulationResultSerializer',
    'SimulationModelDetailSerializer'
]