from django.db import models

class HydroVizUser(models.Model):
    email = models.CharField(max_length = 50, primary_key = True)
    password = models.CharField(max_length = 255)
    firstName = models.CharField(max_length = 20)
    lastName = models. CharField(max_length = 20)

    def __str__(self):
        return self.firstName
