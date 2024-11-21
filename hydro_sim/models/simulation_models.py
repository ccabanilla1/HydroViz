from django.db import models
from .physical_models import Project

class SimulationModel(models.Model):
    # Link to parent project
    project = models.ForeignKey(Project, on_delete=models.CASCADE, related_name='simulations')
    name = models.CharField(max_length=200)
    # Store mesh and boundary data as JSON
    mesh_data = models.JSONField(null=True, blank=True)
    boundary_conditions = models.JSONField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    
    # Define simulation types
    simulation_type = models.CharField(max_length=50, choices=[
        ('STEADY_STATE', 'Steady State'),
        ('TRANSIENT', 'Transient'),
        ('PARTICLE_TRACKING', 'Particle Tracking')
    ], default='STEADY_STATE')
    
    # Store simulation parameters
    convergence_criteria = models.JSONField(null=True, blank=True,
        help_text="Convergence criteria for the simulation")
    
    class Meta:
        ordering = ['-created_at']
        indexes = [
            models.Index(fields=['project', 'created_at']),
        ]

    def __str__(self):
        return f"Simulation {self.name} for {self.project.project_name}"

class SimulationResult(models.Model):
    # Link to parent simulation
    model = models.ForeignKey(SimulationModel, on_delete=models.CASCADE, related_name='results')
    time_step = models.IntegerField()
    result_data = models.JSONField()
    
    # Spatial and value data
    location_x = models.FloatField(null=True)
    location_y = models.FloatField(null=True)
    layer_id = models.IntegerField(null=True)
    head_value = models.FloatField(null=True)
    flow_rate = models.FloatField(null=True)
    convergence = models.FloatField(null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    
    # Track simulation progress
    status = models.CharField(max_length=20, choices=[
        ('PENDING', 'Pending'),
        ('RUNNING', 'Running'),
        ('COMPLETED', 'Completed'),
        ('FAILED', 'Failed')
    ], default='PENDING')
    error_log = models.TextField(null=True, blank=True)
    
    class Meta:
        ordering = ['time_step']
        indexes = [
            models.Index(fields=['model', 'time_step']),
            models.Index(fields=['status', 'created_at']),
        ]

    def __str__(self):
        return f"Result for {self.model.name} at step {self.time_step}"