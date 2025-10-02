from rest_framework import serializers
from django.contrib.auth.models import User
from .models import Member

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'password']
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        user = User.objects.create_user(**validated_data)
        Member.objects.create(user=user, role=validated_data.get('role', 'Member'), phone=validated_data.get('phone', ''))
        return user

class MemberSerializer(serializers.ModelSerializer):
    user = UserSerializer()
    class Meta:
        model = Member
        fields = '__all__'