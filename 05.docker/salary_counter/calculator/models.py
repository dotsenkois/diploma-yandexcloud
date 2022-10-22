from django.db import models
from django.contrib.auth.models import User


class Profile(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, unique=False)
    date_start = models.DateField('Начало вахты')
    date_end = models.DateField('Конец вахты')
    days_road = models.IntegerField('Дни в пути')  # Дни в пути
    hourly_fee = models.FloatField('Оплата в час')  # Оплата в час
    district_coefficient = models.IntegerField('Районный коэффициент')  # Районный коэффициент
    northern_coefficient = models.IntegerField('Северный коэффициент')  # Северный коэффициент
    award = models.IntegerField('Премия')  # Премия
    extras = models.IntegerField('Доплата')  # Доплата
    observation = models.IntegerField('Обсервация')

    def __str__(self):
        return f'{self.user} - {self.date_start} - {self.date_end}'

    class Meta:
        verbose_name = 'Запись'
        verbose_name_plural = 'Записи'


class Results(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, unique=False)
    date_start = models.DateField('Начало вахты')
    date_end = models.DateField('Конец вахты')
    all_result = models.FloatField('Начислено')
    result = models.FloatField('На руки')
    wage = models.FloatField('Оклад')
    days_road = models.FloatField('Дни в дороге')
    award = models.FloatField('Премия')
    district_coefficient = models.FloatField('Районный коэффициент')
    northern_coefficient = models.FloatField('Северный коэффициент')
    extras = models.FloatField('Доплата за вахту')
    holiday = models.FloatField('Доплата за праздники')
    observation = models.FloatField('Обсервация')
    data_set = models.JSONField('data-set')

    def __str__(self):
        return f'{self.user} - {self.date_start} - {self.date_end}'

    class Meta:
        verbose_name = 'Результат'
        verbose_name_plural = 'Результаты'


class Holidays(models.Model):
    holiday = models.DateField()

    def __str__(self):
        return self.holiday

    class Meta:
        verbose_name = 'Праздник'
        verbose_name_plural = 'Праздники'
