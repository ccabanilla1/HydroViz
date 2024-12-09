from rest_framework import serializers
from .models import HydroVizUser

class HydroVizUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = HydroVizUser
        fields = ['email', 'password', 'first_name', 'last_name']
