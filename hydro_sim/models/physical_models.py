from django.db import models
from django.contrib.auth.models import User

class Project(models.Model):
    # Basic project information
    project_id = models.AutoField(primary_key=True)
    project_name = models.CharField(max_length=100)
    description = models.TextField()
    created_date = models.DateTimeField(auto_now_add=True)
    last_modified = models.DateTimeField(auto_now=True)
    owner = models.ForeignKey(User, on_delete=models.CASCADE)
    
    # Project status and type
    status = models.CharField(max_length=20, choices=[
        ('ACTIVE', 'Active'),
        ('ARCHIVED', 'Archived'),
        ('DRAFT', 'Draft')
    ])
    model_type = models.CharField(max_length=20)
    
    # Additional project details
    metadata = models.JSONField(null=True, blank=True, 
        help_text="Additional project metadata and settings")
    tags = models.CharField(max_length=200, blank=True,
        help_text="Comma-separated tags for project categorization")
    
    class Meta:
        indexes = [
            models.Index(fields=['status', 'created_date']),
            models.Index(fields=['owner', 'status']),
        ]

    def __str__(self):
        return f"{self.project_name} ({self.status})"

class Well(models.Model):
    # Well identification and location
    well_id = models.AutoField(primary_key=True)
    project = models.ForeignKey(Project, on_delete=models.CASCADE, related_name='wells')
    location_x = models.FloatField()
    location_y = models.FloatField()
    
    # Physical characteristics
    ground_elevation = models.FloatField()
    total_depth = models.FloatField()
    install_date = models.DateField()
    status = models.CharField(max_length=20)
    purpose = models.CharField(max_length=50)
    
    # Well screen details
    screen_top = models.FloatField(null=True, blank=True,
        help_text="Top of well screen elevation")
    screen_bottom = models.FloatField(null=True, blank=True,
        help_text="Bottom of well screen elevation")
    metadata = models.JSONField(null=True, blank=True,
        help_text="Additional well metadata")

    class Meta:
        indexes = [
            models.Index(fields=['project', 'status']),
            models.Index(fields=['location_x', 'location_y']),
        ]

    def __str__(self):
        return f"Well {self.well_id} at ({self.location_x}, {self.location_y})"

class AquiferProperties(models.Model):
    # Basic identification
    property_id = models.AutoField(primary_key=True)
    project = models.ForeignKey(Project, on_delete=models.CASCADE, related_name='aquifer_properties')
    layer_id = models.IntegerField()
    
    # Hydraulic properties
    conductivity_x = models.FloatField()
    conductivity_y = models.FloatField()
    conductivity_z = models.FloatField()
    storage_coeff = models.FloatField()
    porosity = models.FloatField()
    
    # Location data
    location_x = models.FloatField()
    location_y = models.FloatField()
    
    # Additional properties
    effective_depth = models.FloatField(null=True, blank=True,
        help_text="Effective depth of the aquifer layer")
    anisotropy_ratio = models.FloatField(null=True, blank=True,
        help_text="Ratio of horizontal to vertical conductivity")
    
    class Meta:
        verbose_name_plural = "Aquifer Properties"
        indexes = [
            models.Index(fields=['project', 'layer_id']),
            models.Index(fields=['location_x', 'location_y']),
        ]

    def __str__(self):
        return f"Aquifer Properties for layer {self.layer_id}"

class FieldMeasurement(models.Model):
    # Measurement identification
    measurement_id = models.AutoField(primary_key=True)
    well = models.ForeignKey(Well, on_delete=models.CASCADE, related_name='measurements')
    measure_date = models.DateTimeField()
    
    # Measured values
    water_level = models.FloatField()
    temperature = models.FloatField()
    conductivity = models.FloatField()
    quality = models.CharField(max_length=20)
    measured_by = models.ForeignKey(User, on_delete=models.CASCADE)

    def __str__(self):
        return f"Measurement {self.measurement_id} for Well {self.well_id}"
    
class Component(models.Model):
    # Link to project
    project = models.ForeignKey(Project, on_delete=models.CASCADE, related_name='components')
    
    # Component type and position
    type = models.CharField(max_length=50, choices=[
        ('WELL', 'Well'),
        ('RIVER', 'River'),
        ('RECHARGE', 'Recharge'),
        ('BOUNDARY', 'Boundary'),
    ])
    location_x = models.FloatField()
    location_y = models.FloatField()
    
    # Component details
    created_date = models.DateTimeField(auto_now_add=True)
    last_modified = models.DateTimeField(auto_now=True)
    properties = models.JSONField(null=True, blank=True,
        help_text="Additional component properties")
    
    class Meta:
        indexes = [
            models.Index(fields=['project', 'type']),
            models.Index(fields=['location_x', 'location_y']),
        ]

    def __str__(self):
        return f"{self.type} Component at ({self.location_x}, {self.location_y})"