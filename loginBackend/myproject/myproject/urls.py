from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path("admin/", admin.site.urls),
    path("auth/", include(("authapp.urls", "authapp"), "authapp"))
                #direct to the 'authapp' urls.py
]
