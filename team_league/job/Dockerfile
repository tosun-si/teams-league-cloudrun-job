FROM python:3.10-slim

ENV PYTHONUNBUFFERED True

COPY team_league/job/requirements.txt ./

RUN pip install -r requirements.txt

ENV APP_HOME /app
WORKDIR $APP_HOME
COPY setup.py $APP_HOME/setup.py
COPY team_league $APP_HOME/team_league

CMD ["/usr/local/bin/python3", "-m", "team_league.job.main"]
