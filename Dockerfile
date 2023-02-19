# ARG WHEEL_DIST="/tmp/wheels"

FROM python:3.6-alpine as base

RUN mkdir /source
WORKDIR /source
COPY requirements.txt .

# Instead, I run python setup.py bdist_wheel first, then run pip wheel -r requirements.txt for pypi packages.

RUN pip wheel -r requirements.txt --wheel-dir=/source/wheels

#########################################
FROM python:3.6-alpine
USER 
RUN rm -rf /var/cache/apk/* && \
    rm -rf /tmp/*

RUN useradd -u 1000 -g 1000 -b /app flask
USER flask
WORKDIR /app
COPY --from=base /source /app

RUN pip install --no-index --find-links=/app/wheels -r requirements.txt
WORKDIR /app
COPY app.py /app/
COPY src /app/src
ENTRYPOINT ["python", "/app/app.py"]