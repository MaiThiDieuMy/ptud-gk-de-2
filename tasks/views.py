from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.utils import timezone
from .models import Task, UserProfile
from .forms import TaskForm, UserProfileForm, UserRegistrationForm
from django.contrib.auth import login, logout
from django.contrib.auth.views import LoginView
import requests
from django.conf import settings
from django.db.models import Q
from django.http import JsonResponse
import random

# Create your views here.

@login_required
def task_list(request):
    tasks = Task.objects.filter(assigned_to=request.user)
    
    # Get filter parameter from query string
    filter_type = request.GET.get('filter', 'all')
    
    # Apply filters
    if filter_type == 'overdue':
        tasks = tasks.filter(
            Q(due_date__lt=timezone.now()) & 
            ~Q(status='completed')
        )
    elif filter_type == 'upcoming':
        tasks = tasks.filter(
            Q(due_date__gt=timezone.now()) &
            ~Q(status='completed')
        ).order_by('due_date')
    
    overdue_count = sum(1 for task in tasks if task.is_overdue())
    upcoming_count = Task.objects.filter(
        assigned_to=request.user,
        due_date__gt=timezone.now(),
        status__in=['pending', 'in_progress']
    ).count()
    
    return render(request, 'tasks/task_list.html', {
        'tasks': tasks,
        'overdue_count': overdue_count,
        'upcoming_count': upcoming_count,
        'current_filter': filter_type
    })

@login_required
def task_create(request):
    if request.method == 'POST':
        form = TaskForm(request.POST)
        if form.is_valid():
            task = form.save(commit=False)
            task.created_by = request.user
            task.created_time = timezone.now()
            task.save()
            messages.success(request, 'Task created successfully!')
            return redirect('task_list')
    else:
        form = TaskForm()
    return render(request, 'tasks/task_form.html', {'form': form})

@login_required
def task_update(request, pk):
    task = get_object_or_404(Task, pk=pk)
    if request.method == 'POST':
        form = TaskForm(request.POST, instance=task)
        if form.is_valid():
            task = form.save()
            if task.status == 'completed' and not task.finished_time:
                task.finished_time = timezone.now()
                task.save()
            messages.success(request, 'Task updated successfully!')
            return redirect('task_list')
    else:
        form = TaskForm(instance=task)
    return render(request, 'tasks/task_form.html', {'form': form})

@login_required
def profile_view(request):
    profile, created = UserProfile.objects.get_or_create(user=request.user)
    if request.method == 'POST':
        form = UserProfileForm(request.POST, request.FILES, instance=profile)
        if form.is_valid():
            form.save()
            messages.success(request, 'Profile updated successfully!')
            return redirect('profile')
    else:
        form = UserProfileForm(instance=profile)
    return render(request, 'tasks/profile.html', {'form': form})

@login_required
def generate_avatar(request):
    try:
        # Generate a random size between 200 and 400 pixels
        size = random.randint(200, 400)
        avatar_url = f'https://avatar-placeholder.iran.liara.run/{size}x{size}'
        
        # Make the request to get a new random avatar
        response = requests.get(avatar_url, allow_redirects=True)
        if response.status_code == 200:
            profile, created = UserProfile.objects.get_or_create(user=request.user)
            # Store the final URL after redirects
            profile.avatar_url = response.url
            profile.save()
            messages.success(request, 'New random avatar generated successfully!')
        else:
            messages.error(request, 'Failed to generate avatar. Please try again.')
    except Exception as e:
        messages.error(request, f'Error generating avatar: {str(e)}')
    return redirect('profile')

def register(request):
    # Redirect if user is already logged in
    if request.user.is_authenticated:
        messages.info(request, 'You are already logged in.')
        return redirect('task_list')
        
    if request.method == 'POST':
        form = UserRegistrationForm(request.POST)
        if form.is_valid():
            user = form.save()
            UserProfile.objects.create(user=user)
            login(request, user)
            messages.success(request, 'Registration successful!')
            return redirect('task_list')
    else:
        form = UserRegistrationForm()
    return render(request, 'registration/register.html', {'form': form})

class CustomLoginView(LoginView):
    def dispatch(self, request, *args, **kwargs):
        # Redirect if user is already logged in
        if request.user.is_authenticated:
            messages.info(request, 'You are already logged in.')
            return redirect('task_list')
        return super().dispatch(request, *args, **kwargs)

def logout_view(request):
    if request.method == 'POST':
        if request.user.is_authenticated:
            logout(request)
            messages.success(request, 'You have been successfully logged out.')
    return redirect('login')

@login_required
def task_toggle_complete(request, pk):
    task = get_object_or_404(Task, pk=pk)
    
    # Only allow the task creator or assigned user to toggle completion
    if request.user != task.created_by and request.user != task.assigned_to:
        messages.error(request, "You don't have permission to modify this task.")
        return redirect('task_list')
    
    if task.status == 'completed':
        # Uncomplete the task
        task.status = 'pending'
        task.finished_time = None
        messages.success(request, f'Task "{task.title}" marked as incomplete.')
    else:
        # Complete the task
        task.status = 'completed'
        task.finished_time = timezone.now()
        messages.success(request, f'Task "{task.title}" marked as complete!')
    
    task.save()
    return redirect('task_list')

@login_required
def task_delete(request, pk):
    task = get_object_or_404(Task, pk=pk)
    
    # Only allow the task creator or assigned user to delete the task
    if request.user != task.created_by and request.user != task.assigned_to:
        messages.error(request, "You don't have permission to delete this task.")
        return redirect('task_list')
    
    if request.method == 'POST':
        task_title = task.title
        task.delete()
        messages.success(request, f'Task "{task_title}" has been deleted.')
        return redirect('task_list')
    
    return render(request, 'tasks/task_confirm_delete.html', {'task': task})
