FROM python:3.14-rc-slim

WORKDIR /app

COPY app .

COPY elasticsearch /elasticsearch
COPY c /c

RUN pip install --no-cache-dir -r requirements.txt

ENTRYPOINT ["python", "."]
