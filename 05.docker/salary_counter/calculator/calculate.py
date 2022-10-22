from .models import Results, Holidays
from datetime import datetime, timedelta
import locale
import pymorphy2


locale.setlocale(locale.LC_TIME, 'ru_RU.UTF-8')
morph = pymorphy2.MorphAnalyzer()
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


def calc_holidays_home(all_days, days):
    days_home = []
    holidays_home = []
    for day in all_days:
        if day not in days:
            days_home.append(day)

    for holiday_l in HOLIDAYS.values():
        for day in days_home:
            if day in holiday_l:
                holidays_home.append(day)
    return holidays_home


def create_days_month_dict(days):
    """
    :return:
    {'04': ['2021-04-03', '2021-04-04' ...],
    '05': ['2021-05-01', '2021-05-02' ...]}
    """

    days_month = {}

    for day in days:
        month = day.split('-')[1]
        days_month[month] = []

    for day in days:
        month = day.split('-')[1]
        for k, v in days_month.items():
            if month == k:
                v.append(day)

    return days_month


def get_user_input(form):
    # user_id = user_id
    date_start = form.data.get('date_start')  # Начало вахты
    date_end = form.data.get('date_end')  # Конец вахты
    start = datetime.strptime(str(date_start), '%Y-%m-%d')
    end = datetime.strptime(str(date_end), '%Y-%m-%d')
    days = [(start + timedelta(days=x)).strftime('%Y-%m-%d') for x in range(0, (end - start).days + 1, )]

    all_days_start = datetime.strptime(str(f'{start.year}-{start.month}-01'), '%Y-%m-%d')
    try:
        all_days_end = datetime.strptime(str(f'{end.year}-{end.month}-30'), '%Y-%m-%d')
    except ValueError:
        all_days_end = datetime.strptime(str(f'{end.year + 1}-01-30'), '%Y-%m-%d')
    all_days = [(all_days_start + timedelta(days=x)).strftime('%Y-%m-%d') for x in
                range(0, (all_days_end - all_days_start).days + 1, )]

    days_road = form.data.get('days_road')  # Дни в пути
    hourly_fee = form.data.get('hourly_fee')  # Часовая ставка
    district_coefficient = form.data.get('district_coefficient')  # Районный
    northern_coefficient = form.data.get('northern_coefficient')  # Северный
    award = form.data.get('award')  # Премия
    extras = form.data.get('extras')  # Доплата
    observation = form.data.get('observation')  # Обсервация

    user_input = {
        'date_start': date_start,
        'date_end': date_end,
        'job_days': days,
        'all_days': all_days,
        'days_road': days_road,
        'hourly_fee': hourly_fee,
        'district_coefficient': district_coefficient,
        'northern_coefficient': northern_coefficient,
        'award': award,
        'extras': extras,
        'observation': observation
    }

    return user_input


def calculate_moth(hourly_fee, days_road, observation, extras,
                   award, district_coefficient, northern_coefficient, days, all_days):
    award_list = []
    data_list = []
    days_month = create_days_month_dict(days)
    len_days_month = len(days_month)
    holiday_home = calc_holidays_home(all_days, days)
    calc_extras = 0.0
    for num, items in enumerate(days_month.items()):
        calculate_all_month = {}
        calc_wage = (11 * float(hourly_fee)) * (int(len(items[1])))
        if num == 0:
            calc_days_road = float(hourly_fee) * 8 * int(days_road)  # Дни в дороге
            calc_extras = (int(len(items[1])) + days_road + observation) * int(extras)  # Доплата
            calc_observation = (float(hourly_fee) * 8) * int(observation)
        elif num == len_days_month - 1:
            calc_days_road = float(hourly_fee) * 8 * int(days_road)  # Дни в дороге
            calc_observation = 0
            calc_extras = (int(len(items[1]))) * int(extras)  # Доплата
        else:
            calc_days_road = 0  # Дни в дороге не считаем
            calc_observation = 0
        calc_award = (calc_wage / 100) * int(award)  # Премия
        calc_dis_coeff = (calc_wage / 100) * int(district_coefficient)  # Районный
        calc_north_coeff = (calc_wage / 100) * int(northern_coefficient)  # Северный
        count_holiday = 0
        for holiday_l in HOLIDAYS.values():
            for h in holiday_l:
                if h in items[1]:
                    count_holiday += 1
        calc_holiday = float(hourly_fee) * 11 * count_holiday  # Праздники
        calc_holiday_dis = calc_holiday * (district_coefficient / 100)
        calc_holiday_north = calc_holiday * (northern_coefficient / 100)

        calculate_all_month[int(items[0])] = {
            'calc_wage': round(calc_wage, 2),
            'calc_days_road': round(calc_days_road, 2),
            'calc_award': 0,
            'calc_dis_award': 0,
            'calc_north_award': 0,
            'calc_dis_coeff': round(calc_dis_coeff, 2),
            'calc_north_coeff': round(calc_north_coeff, 2),
            'calc_extras': round(calc_extras, 2),
            'calc_holiday': round(calc_holiday, 2),
            'calc_holiday_dis': round(calc_holiday_dis, 2),
            'calc_holiday_north': round(calc_holiday_north, 2),
            'calc_holiday_home': 0,
            'calc_observation': round(calc_observation, 2)}

        data_list.append(calculate_all_month)
        award_list.append((num, calc_award))

    count = 0
    month_count = 0
    for num, d in enumerate(data_list):
        if len(data_list) > 2:
            for keys in d.keys():
                if num != 0:
                    try:
                        d[keys]['calc_award'] = round(award_list[count][1], 2)
                        d[keys]['calc_dis_award'] = round(award_list[count][1] * (district_coefficient / 100), 2)
                        d[keys]['calc_north_award'] = round(award_list[count][1] * (northern_coefficient / 100), 2)
                        # count += 1
                    except IndexError:
                        d[keys]['calc_award'] = round(award_list[count - 1][1], 2)
                        d[keys]['calc_dis_award'] = round(award_list[count - 1][1] * (district_coefficient / 100), 2)
                        d[keys]['calc_north_award'] = round(award_list[count - 1][1] * (northern_coefficient / 100), 2)
                    if num == count:
                        try:
                            data_list.append({
                                [keys][month_count]: {
                                    'calc_award': round(award_list[count][1], 2),
                                    'calc_dis_award': round(award_list[count][1] * (district_coefficient / 100), 2),
                                    'calc_north_award': round(award_list[count][1] * (northern_coefficient / 100), 2),
                                    'calc_holiday_home': round(424.6 * len(holiday_home), 2),
                                    'calc_holiday_home_dis': round(
                                        (424.6 * len(holiday_home)) * (district_coefficient / 100), 2),
                                    'calc_holiday_home_north': round((424.6 * len(holiday_home)) * (
                                            northern_coefficient / 100), 2)
                                }})
                            break
                        except IndexError:
                            pass
                    count += 1
        else:
            for keys in d.keys():
                try:
                    data_list.append({
                        [keys][month_count]:
                            {'calc_award': round(award_list[count][1], 2),
                             'calc_dis_award': round(award_list[count][1] * (district_coefficient / 100), 2),
                             'calc_north_award': round(award_list[count][1] * (northern_coefficient / 100), 2),
                             'calc_holiday_home': round(424.6 * len(holiday_home), 2),
                             'calc_holiday_home_dis': round((424.6 * len(holiday_home)) * (district_coefficient / 100),
                                                            2),
                             'calc_holiday_home_north': round(
                                 (424.6 * len(holiday_home)) * (northern_coefficient / 100), 2)
                             }})
                    month_count += 1
                except IndexError:
                    pass

    return data_list


def calculate(form, user_id):
    sum_not_calc_nalog = []
    all_sum = []
    calc_positions = {
        'calc_wage': 0,
        'calc_days_road': 0,
        'calc_dis_coeff': 0,
        'calc_north_coeff': 0,
        'calc_award': 0,
        'calc_extras': 0,
        'calc_holiday': 0,
        'calc_observation': 0
    }

    user_input = get_user_input(form=form)  # Получаем данные с формы
    calc_data_list = calculate_moth(
        hourly_fee=float(user_input['hourly_fee']),
        days_road=int(user_input['days_road']),
        observation=int(user_input['observation']),
        extras=int(user_input['extras']),
        award=int(user_input['award']),
        district_coefficient=int(user_input['district_coefficient']),
        northern_coefficient=int(user_input['northern_coefficient']),
        days=user_input['job_days'],
        all_days=user_input['all_days']
    )  # Расчет

    not_calc_nalog = ['calc_extras', 'calc_observation', 'calc_days_road']

    for d_dict in calc_data_list:
        for month, v_dict in d_dict.items():
            for name, value in v_dict.items():
                if name in not_calc_nalog:
                    sum_not_calc_nalog.append(value)
                all_sum.append(value)
                if name == 'calc_dis_award' or name == 'calc_north_award':
                    calc_positions['calc_award'] += value
                elif name == 'calc_holiday_dis' or name == 'calc_holiday_north' or name == 'calc_holiday_home' \
                        or name == 'calc_holiday_home_dis' or name == 'calc_holiday_home_north':
                    calc_positions['calc_holiday'] += value
                else:
                    calc_positions[name] += value
    # save
    Results.objects.create(
        user_id=user_id,
        date_start=user_input['date_start'],
        date_end=user_input['date_end'],
        all_result=sum(all_sum),
        result=sum(all_sum) - ((sum(all_sum) - sum(sum_not_calc_nalog)) * 0.13),
        wage=calc_positions['calc_wage'],
        days_road=calc_positions['calc_days_road'],
        award=calc_positions['calc_award'],
        district_coefficient=calc_positions['calc_dis_coeff'],
        northern_coefficient=calc_positions['calc_north_coeff'],
        extras=calc_positions['calc_extras'],
        holiday=calc_positions['calc_holiday'],
        observation=calc_positions['calc_observation'],
        data_set=calc_data_list
    )


def get_month_sum(user_id):
    """Заработанная сумма по месяцам: {январь: 100, 02: 200}"""
    last_entry = Results.objects.filter(user_id=user_id).last().data_set
    not_calc_nalog = ['calc_extras', 'calc_observation', 'calc_days_road']
    month_sum = {}
    for dict_last_entry in last_entry:
        for k, v in dict_last_entry.items():
            month = datetime(1900, int(k), 1).strftime('%B')
            normal_month = morph.parse(month)[0].normal_form
            list_not_calc_nalog = []
            for name, value in v.items():
                if name in not_calc_nalog:
                    list_not_calc_nalog.append(value)

            sum_minus_nalog = (sum(v.values()) - sum(list_not_calc_nalog)) * 0.13
            result = round(sum(v.values()) - sum_minus_nalog, 2)
            if normal_month not in month_sum:
                month_sum[normal_month] = round(result, 2)
            else:
                month_sum[normal_month] += round(result, 2)
    return month_sum
