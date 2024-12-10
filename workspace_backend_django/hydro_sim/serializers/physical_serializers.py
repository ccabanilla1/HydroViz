from rest_framework import serializers
from ..models.physical_models import Project, Well, AquiferProperties, FieldMeasurement, Component
from ..models.physical_models import HydroFile

class HydroFileSerializer(serializers.ModelSerializer):
    class Meta:
        model = HydroFile
        fields = ['id', 'name', 'description', 'created_at', 'updated_at']
        read_only_fields = ['created_at', 'updated_at']
        
# Basic project serializer
class ProjectSerializer(serializers.ModelSerializer):
    class Meta:
        model = Project
        fields = '__all__'
        # Optional project metadata fields
        extra_kwargs = {
            'metadata': {'required': False},
            'tags': {'required': False}
        }

# Basic well serializer
class WellSerializer(serializers.ModelSerializer):
    # Link to related measurements
    measurements = serializers.PrimaryKeyRelatedField(many=True, read_only=True)
    
    class Meta:
        model = Well
        fields = '__all__'
        # Optional well details
        extra_kwargs = {
            'screen_top': {'required': False},
            'screen_bottom': {'required': False},
            'metadata': {'required': False}
        }

# Aquifer properties serializer
class AquiferPropertiesSerializer(serializers.ModelSerializer):
    class Meta:
        model = AquiferProperties
        fields = '__all__'
        # Optional aquifer characteristics
        extra_kwargs = {
            'effective_depth': {'required': False},
            'anisotropy_ratio': {'required': False}
        }

# Field measurement serializer
class FieldMeasurementSerializer(serializers.ModelSerializer):
    class Meta:
        model = FieldMeasurement
        fields = '__all__'


class ComponentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Component
        fields = ['id', 'type', 'location_x', 'location_y', 'properties', 'project']
        extra_kwargs = {
            'properties': {'required': False},
            'id': {'read_only': True}
        }

# Detailed project serializer with related data
class ProjectDetailSerializer(serializers.ModelSerializer):
    wells = WellSerializer(many=True, read_only=True)
    aquifer_properties = AquiferPropertiesSerializer(many=True, read_only=True)
    components = ComponentSerializer(many=True, read_only=True)  # Add this line

    class Meta:
        model = Project
        fields = '__all__'

# Detailed well serializer with related data
class WellDetailSerializer(serializers.ModelSerializer):
    # Include full measurement and project data
    measurements = FieldMeasurementSerializer(many=True, read_only=True)
    project = ProjectSerializer(read_only=True)

    class Meta:
        model = Well
        fields = '__all__'

