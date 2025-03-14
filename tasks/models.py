from django.db import models
from django.contrib.auth.models import User
from django.utils import timezone

class Task(models.Model):
    STATUS_CHOICES = [
        ('pending', 'Pending'),
        ('in_progress', 'In Progress'),
        ('completed', 'Completed'),
    ]

    title = models.CharField(max_length=200)
    description = models.TextField(blank=True)
    created_by = models.ForeignKey(User, on_delete=models.CASCADE, related_name='created_tasks')
    assigned_to = models.ForeignKey(User, on_delete=models.CASCADE, related_name='assigned_tasks')
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')
    created_time = models.DateTimeField(auto_now_add=True)
    due_date = models.DateTimeField()
    finished_time = models.DateTimeField(null=True, blank=True)

    def __str__(self):
        return self.title

    def is_overdue(self):
        return self.status != 'completed' and self.due_date < timezone.now()

class UserProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    avatar = models.ImageField(upload_to='avatars/', null=True, blank=True)
    is_admin = models.BooleanField(default=False)

    def __str__(self):
        return self.user.username
