FROM alpine
MAINTAINER Albert Fedorovsky <alb271@yandex.ru>

RUN apk update

# Install python, pip and flask
ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools
RUN pip3 install flask

# Set ports
EXPOSE 5000

ADD main.py /flask_app/
CMD ["python3", "/flask_app/main.py"]
