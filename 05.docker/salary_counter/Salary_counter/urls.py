from django.contrib import admin
from django.urls import path, include
from calculator.views import home_view, calculate_view, profile_view, delete
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
                  path('admin/', admin.site.urls),
                  path('', home_view, name='home'),
                  path('calculator/', calculate_view, name='calculator'),
                  path('delete/<int:card_id>/', delete, name='delete'),
                  path('profile/', profile_view, name='profile'),
                  path('accounts/', include('django.contrib.auth.urls')),
                  path('accounts/', include('accounts.urls')),
              ] + static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
