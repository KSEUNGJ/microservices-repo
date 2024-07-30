from django.contrib.auth import login, logout
from django.contrib.auth.forms import AuthenticationForm
from django.shortcuts import render, redirect
from django.utils import timezone
from .forms import CustomUserCreationForm


def index(request):
    return render(request, 'cloud/index.html')

def login_view(request):
    if request.method == 'POST':
        form = AuthenticationForm(request, data=request.POST)
        if form.is_valid():
            user = form.get_user()
            login(request, user)
            user.login_time = timezone.now()
            user.save()
            return redirect('index')
    else:
        form = AuthenticationForm()
    return render(request, 'cloud/login.html', {'form': form})

def logout_view(request):
    user = request.user
    user.logout_time = timezone.now()
    user.save()
    logout(request)
    return redirect('index')  # Ensure this redirects to 'index'

def register_view(request):
    if request.method == 'POST':
        form = CustomUserCreationForm(request.POST)
        if form.is_valid():
            user = form.save()
            login(request, user)
            return redirect('index')
    else:
        form = CustomUserCreationForm()
    return render(request, 'cloud/register.html', {'form': form})

