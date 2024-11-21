from django.contrib import admin
from .models.physical_models import Project, Well, AquiferProperties, FieldMeasurement
from .models.simulation_models import SimulationModel, SimulationResult

# Project admin configuration
@admin.register(Project)
class ProjectAdmin(admin.ModelAdmin):
    list_display = ('project_name', 'owner', 'status', 'created_date')  # Columns shown in list view
    search_fields = ('project_name', 'description')  # Fields available for search
    list_filter = ('status', 'model_type')  # Filters shown in sidebar

# Well administration settings
@admin.register(Well)
class WellAdmin(admin.ModelAdmin):
    list_display = ('well_id', 'project', 'location_x', 'location_y', 'status')
    search_fields = ('well_id', 'purpose')
    list_filter = ('status', 'project')

# Aquifer properties configuration
@admin.register(AquiferProperties)
class AquiferPropertiesAdmin(admin.ModelAdmin):
    list_display = ('property_id', 'project', 'layer_id', 'conductivity_x')
    list_filter = ('layer_id', 'project')

# Field measurement data management
@admin.register(FieldMeasurement)
class FieldMeasurementAdmin(admin.ModelAdmin):
    list_display = ('well', 'measure_date', 'water_level', 'quality', 'measured_by')
    list_filter = ('quality', 'measure_date', 'well')

# Simulation model settings
@admin.register(SimulationModel)
class SimulationModelAdmin(admin.ModelAdmin):
    list_display = ('name', 'project', 'simulation_type', 'created_at')
    list_filter = ('simulation_type', 'project')
    search_fields = ('name',)

# Simulation results management
@admin.register(SimulationResult)
class SimulationResultAdmin(admin.ModelAdmin):
    list_display = ('model', 'time_step', 'status', 'created_at')
    list_filter = ('status', 'model')