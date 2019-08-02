FROM python:3.7-alpine AS python-image


FROM python-image AS base

ENV PYTHONUNBUFFERED 1
RUN apk add --no-cache --update --virtual=deps python3-dev libevent-dev
RUN pip install pipenv
RUN mkdir /app
ADD Pipfile* ./
WORKDIR /app


FROM base AS development

RUN pipenv lock -r >> requirements.txt \
    && pipenv lock -r --dev >> requirements.txt
RUN pip install -r requirements.txt
RUN apk del deps


FROM base AS production

RUN pipenv lock -r >> requirements.txt
RUN pip install -r requirements.txt
RUN apk del deps


FROM production AS build

