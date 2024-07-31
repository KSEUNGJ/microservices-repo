from django.contrib.auth.forms import UserCreationForm
from .models import CustomUser
from django import forms

class CustomUserCreationForm(UserCreationForm):
    name = forms.CharField(max_length=255, required=True, label="Name")

    class Meta:
        model = CustomUser
        fields = ('username', 'name', 'email', 'password1', 'password2')