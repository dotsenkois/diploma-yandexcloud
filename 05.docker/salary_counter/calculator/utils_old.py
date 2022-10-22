from .models import Results
from datetime import datetime, timedelta

HOLIDAYS = {
    'holidays': ['2021-01-01',
                 '2021-01-02',
                 '2021-01-03',
                 '2021-01-04',
                 '2021-01-05',
                 '2021-01-06',
                 '2021-01-07',
                 '2021-01-08',
                 '2021-02-23',
                 '2021-03-08',
                 '2021-05-01',
                 '2021-05-09',
                 '2021-06-12',
                 '2021-11-04',
                 '2021-12-31',
                 '2022-01-01',
                 '2022-01-02',
                 '2022-01-03',
                 '2022-01-04',
                 '2022-01-05',
                 '2022-01-06',
                 '2022-01-07',
                 '2022-01-08',
                 '2022-02-23',
                 '2022-03-08',
                 '2022-05-01',
                 '2022-05-09',
                 '2022-06-12',
                 '2022-11-04',
                 '2022-12-31']
}


def calculate(form, user_id):
    user_id = user_id
    date_start = form.data.get('date_start')  # Начало вахты
    date_end = form.data.get('date_end')  # Конец вахты
    start = datetime.strptime(str(date_start), '%Y-%m-%d')
    end = datetime.strptime(str(date_end), '%Y-%m-%d')
    days = [(start + timedelta(days=x)).strftime('%Y-%m-%d') for x in range(0, (end - start).days + 1, )]

    days_road = form.data.get('days_road')  # Дни в пути
    hourly_fee = form.data.get('hourly_fee')  # Часовая ставка
    district_coefficient = form.data.get('district_coefficient')  # Районный
    northern_coefficient = form.data.get('northern_coefficient')  # Северный
    award = form.data.get('award')  # Премия
    extras = form.data.get('extras')  # Доплата
    observation = form.data.get('observation')  # Обсервация

    # all_hours = int(len(days)) * 11
    calc_wage = 11 * float(hourly_fee) * int(len(days))  # all_hours * float(hourly_fee)  Оплата по часам
    calc_days_road = float(hourly_fee) * 8 * int(days_road)  # int(days_road) * 8 * float(hourly_fee)   Дни в дороге
    calc_award = (calc_wage / 100) * int(award)  # Премия
    calc_dis_coeff = (calc_wage / 100) * int(district_coefficient)  # Районный
    calc_north_coeff = (calc_wage / 100) * int(northern_coefficient)  # Северный
    calc_award_dis_coeff = (calc_award / 100) * int(district_coefficient)  # Премия районные
    calc_award_north_coeff = (calc_award / 100) * int(northern_coefficient)  # Премия северный
    calc_extras = (int(len(days)) + int(days_road)) * int(extras)  # Доплата
    calc_observation = (float(hourly_fee) * 8) * int(observation)
    count_holiday = 0
    for holiday_l in HOLIDAYS.values():
        for h in holiday_l:
            if h in days:
                count_holiday += 1
    calc_holiday = float(hourly_fee) * 11 * count_holiday  # count_holiday * 11 * float(hourly_fee)   Праздники
    calc_holiday_dis_coeff = calc_holiday * (int(district_coefficient) / 100)
    calc_holiday_north_coeff = calc_holiday * (int(northern_coefficient) / 100)

    # calc = calc_wage + calc_days_road + calc_award + calc_dis_coeff + calc_north_coeff + calc_award_dis_coeff \
    #     + calc_award_north_coeff + calc_extras + calc_holiday + calc_holiday_dis_coeff + calc_holiday_north_coeff \
    #     + calc_observation

    # calc_nalog = ((calc - calc_extras) / 100) * 13  # Минус 13%

    calc = calc_wage + calc_days_road + calc_award + calc_dis_coeff + calc_north_coeff + calc_extras + calc_holiday \
        + calc_observation
    print(calc)
    calc_nalog = (calc_wage + calc_dis_coeff + calc_north_coeff) * 0.13
    result = {'calc_result': round(calc, 2),
              'calc_result_nalog': round(calc - calc_nalog, 2),
              'wage': round(calc_wage, 2),
              'days_road': calc_days_road,
              'award': round(calc_award, 2),
              'dis_coeff': round(calc_dis_coeff, 2),
              'north_coeff': round(calc_north_coeff, 2),
              'extras': calc_extras,
              'holiday': calc_holiday,
              'date_start': date_start,
              'date_end': date_end,
              'observation': calc_observation,
              'user_id': int(user_id),
              }

    return save_calc_data(result)


def save_calc_data(result):
    Results.objects.create(
        user_id=result.get('user_id'),
        date_start=result.get('date_start'),
        date_end=result.get('date_end'),
        all_result=result.get('calc_result'),
        result=result.get('calc_result_nalog'),
        wage=result.get('wage'),
        days_road=result.get('days_road'),
        award=result.get('award'),
        district_coefficient=result.get('dis_coeff'),
        northern_coefficient=result.get('north_coeff'),
        extras=result.get('extras'),
        holiday=result.get('holiday'),
        observation=result.get('observation')
    )
