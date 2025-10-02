from django.db import models
from django.contrib.auth.models import User

class Member(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    role = models.CharField(max_length=50, default='Member')
    phone = models.CharField(max_length=15, blank=True)

    def __str__(self):
        return self.user.username