FROM azuresdk/azure-cli-python:hotfix-2.0.41

ARG tf_version="0.11.7"

RUN apk update && apk upgrade && apk add ca-certificates && update-ca-certificates && \
    apk add --no-cache --update curl unzip

RUN curl https://releases.hashicorp.com/terraform/${tf_version}/terraform_${tf_version}_linux_amd64.zip -o terraform_${tf_version}_linux_amd64.zip && \
    unzip terraform_${tf_version}_linux_amd64.zip -d /usr/local/bin && \
    mkdir -p /opt/workspace && \
    rm /var/cache/apk/*

WORKDIR /opt/workspace
ENV TF_IN_AUTOMATION somevalue
