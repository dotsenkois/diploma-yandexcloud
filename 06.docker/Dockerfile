FROM ubuntu:20.04

WORKDIR /usr/src/app

COPY requirements.txt .
COPY entrypoint.sh .
RUN apt-get update && apt-get install python3-pip locales git -y 
RUN echo "ru_RU.UTF-8 UTF-8" > /etc/locale.gen && locale-gen
ENV LC_ALL=ru_RU.UTF-8
RUN pip install -r requirements.txt
RUN chmod +x entrypoint.sh
RUN git clone https://github.com/dotsenkois/diploma-web-app.git /usr/src/app

ENTRYPOINT ["bash", "entrypoint.sh"]