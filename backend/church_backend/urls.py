from django.contrib import admin
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from members.views import signup, MemberViewSet

router = DefaultRouter()
router.register(r'members', MemberViewSet)

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/signup/', signup),
    path('api/', include(router.urls)),
]