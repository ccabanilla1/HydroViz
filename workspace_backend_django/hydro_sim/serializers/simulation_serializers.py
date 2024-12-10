from rest_framework import serializers
from ..models.simulation_models import SimulationModel, SimulationResult
from .physical_serializers import ProjectSerializer

# Basic simulation model serializer
class SimulationModelSerializer(serializers.ModelSerializer):
    # Link to associated results
    results = serializers.PrimaryKeyRelatedField(many=True, read_only=True)
    
    class Meta:
        model = SimulationModel
        fields = '__all__'
        # Optional fields for model creation
        extra_kwargs = {
            'mesh_data': {'required': False},
            'boundary_conditions': {'required': False},
            'convergence_criteria': {'required': False}
        }

# Serializer for simulation results
class SimulationResultSerializer(serializers.ModelSerializer):
    class Meta:
        model = SimulationResult
        fields = '__all__'
        # Optional fields that may be populated later
        extra_kwargs = {
            'error_log': {'required': False},
            'location_x': {'required': False},
            'location_y': {'required': False},
            'layer_id': {'required': False}
        }

# Detailed simulation model serializer including related data
class SimulationModelDetailSerializer(serializers.ModelSerializer):
    # Include full result and project data
    results = SimulationResultSerializer(many=True, read_only=True)
    project = ProjectSerializer(read_only=True)

    class Meta:
        model = SimulationModel
        fields = '__all__'