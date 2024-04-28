FROM python:3.11-slim-bullseye as build
WORKDIR /wheels

COPY requirements.txt /opt/sherlock/
RUN apt-get update \
  && apt-get install -y build-essential \
  && pip3 wheel -r /opt/sherlock/requirements.txt

FROM python:3.11-slim-bullseye
WORKDIR /opt/sherlock

ARG VCS_REF
ARG VCS_URL="https://github.com/sherlock-project/sherlock"

LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url=$VCS_URL

COPY --from=build /wheels /wheels
COPY . /opt/sherlock/

RUN pip3 install --no-cache-dir -r requirements.txt -f /wheels \
  && rm -rf /wheels

#WORKDIR /opt/sherlock/sherlock

#ENTRYPOINT ["python", "sherlock.py"]


WORKDIR .actor

RUN apt-get update; apt-get install curl gpg -y
RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
RUN apt-get update && apt-get install -y curl bash git jq jo xz-utils nodejs

RUN git clone https://github.com/netmilk/apify-cli.git
WORKDIR apify-cli
RUN npm install corepack
RUN corepack enable
RUN yarn install
ENV PATH="${PATH}:/opt/sherlock/.actor/apify-cli/node_modules/.bin"

WORKDIR /opt/sherlock/

CMD ./actor.sh

