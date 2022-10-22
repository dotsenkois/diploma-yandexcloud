from .models import Profile
from django.forms import ModelForm


class UserForm(ModelForm):
    class Meta:
        model = Profile
        fields = ['date_start', 'date_end', 'hourly_fee', 'district_coefficient',
                  'northern_coefficient', 'award', 'extras', 'days_road', 'observation']
