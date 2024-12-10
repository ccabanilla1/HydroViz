from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include('hydro_sim.urls')),
    path('api-auth/', include('rest_framework.urls')),
]