from django.urls import path, include
from . import views 

urlpatterns = [
    path("signup/", views.signup, name = "signup"), #direct to sign up in views
    path("login/", views.login, name = "login"), #direct to login in views
    path("reset-password/", views.resetPassword, name = "reset-password"), #direct to resetPassword in views
]
