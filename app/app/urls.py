from django.urls import path, include
from django.http import HttpResponse

urlpatterns = [
    path('', lambda r: HttpResponse("Hello, world! This is Django on EKS 🚀")),
    path('hello/', include('hello.urls')),
    path('healthz/', lambda r: HttpResponse("ok")),
]
