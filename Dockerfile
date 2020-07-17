FROM ubuntu

LABEL version="0.1"

LABEL com.github.actions.name="AWS Cloudformation Deploy Action"
LABEL com.github.actions.description="Deploy AWS Cloudformation Stack"
LABEL com.github.actions.icon="upload-cloud"
LABEL com.github.actions.color="blue"

LABEL repository="https://github.com/university-of-york/aws-cfn-deploy-action"
LABEL homepage="https://github.com/university-of-york/aws-cfn-deploy-action"
LABEL maintainer="Dan Miller <dan.miller@york.ac.uk>"

ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y awscli jq

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
