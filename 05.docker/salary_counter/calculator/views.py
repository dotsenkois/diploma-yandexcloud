from django.http import HttpResponseRedirect, HttpResponseNotFound
from django.shortcuts import render
from django.contrib.auth.models import User
from django.core.paginator import Paginator
from django.db.models import Sum
from django.urls import reverse
from django.core.exceptions import PermissionDenied
from django.contrib import messages
from ratelimit.decorators import ratelimit
from datetime import date

from .calculate import calculate, get_month_sum
from .models import Results, Profile
from .forms import UserForm

date_today = date.today()
START_DATE = date(date_today.year, 1, 1)
END_DATE = date(date_today.year, 12, 31)


def home_view(request):
    data = {'first_name': 'First_name1', 'last_name': 'Last_name1'}
    context = {'data': data}
    return render(request, 'home.html', context)


def calculate_view(request):
    if request.user.is_authenticated:
        profile_data_last = Profile.objects.filter(user_id=request.user.id).last()
        total_count = Results.objects.filter(user_id=request.user.id).count()
        limit_count = 100  # Ограничение количества записей расчетов зарплаты
        if limit_count - 1 >= total_count:
            error = ''
            if request.method == 'POST':
                form = UserForm(request.POST)
                if form.is_valid():
                    post = form.save(commit=False)
                    post.user = User.objects.get(pk=request.user.id)
                    post.month = 0
                    post.save()
                    calculate(form, user_id=request.user.id)
                    return HttpResponseRedirect(reverse('profile'))
                else:
                    error = 'Форма заполнена не верно'

            form = UserForm()

            context = {
                'form': form,
                'error': error,
                'profile_data_last': profile_data_last
            }
            return render(request, 'calculator/calculator.html', context)
        else:
            messages.add_message(request, messages.INFO, 'Вы превысили максимально допустимое количество записей!')
            return HttpResponseRedirect(reverse('profile'))
    else:
        raise PermissionDenied


@ratelimit(key='ip', rate='50/h', block=True)
def profile_view(request):
    if request.user.is_authenticated:
        obj_card_null = ''
        last_entry_null = ''
        card = Results.objects.filter(user_id=request.user.id)
        try:
            last_entry = Results.objects.filter(user_id=request.user.id).last().data_set
        except AttributeError:
            last_entry = 0

        calc_y = Results.objects.filter(user_id=request.user.id).filter(date_start__range=(START_DATE, END_DATE))
        calc_year = calc_y.aggregate(total_sum=Sum('result'))
        calc_total = Results.objects.filter(user_id=request.user.id).aggregate(total_sum=Sum('result'))

        sort = request.GET.get('sort')
        if sort:
            obj_card = card.order_by('date_start')
            context = {
                'page': None,
                'data': obj_card,
                'calc_year': calc_year,
                'calc_total': calc_total,
                'data_null': obj_card_null,
            }
        else:
            obj_card = card.order_by('-id')
            if len(obj_card) == 0:
                obj_card_null = 'Данных нет'
            if last_entry == 0:
                last_entry_null = 'Данных нет'
                last_entry = ''
            paginator = Paginator(obj_card, 5)
            current_page = request.GET.get('page', 1)
            page = paginator.get_page(current_page)

            # Заработанная сумма по месяцам: {01: 100, 02: 200}
            month_sum = {}

            if last_entry:
                month_sum = get_month_sum(request.user.id)

            context = {
                'page': page,
                'data': page.object_list,
                'calc_year': calc_year,
                'calc_total': calc_total,
                'data_null': obj_card_null,
                'last_entry': last_entry,
                'last_entry_null': last_entry_null,
                'month_sum': month_sum
            }

        return render(request, 'calculator/profile.html', context)
    else:
        raise PermissionDenied


def delete(request, card_id):
    if request.user.is_authenticated:
        try:
            card = Results.objects.get(id=card_id)
            card.delete()
            return HttpResponseRedirect(reverse('profile'))
        except Results.DoesNotExist:
            return HttpResponseNotFound("<h2>Card not found</h2>")
    else:
        raise PermissionDenied
