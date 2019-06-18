FROM ruby:2.6.2-alpine

LABEL maintainer="ahsan.dar@live.com"

ARG BUILD_DATE
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.name="ahsan/json2bqschema"
LABEL org.label-schema.description="BQ schema extractor from a JSON object"
LABEL org.label-schema.url="https://github.com/ahsan/json2bqschema"

ENV PROJECT_ROOT /src/json2bqschema
ENV PATH ${PROJECT_ROOT}/bin:$PATH

WORKDIR ${PROJECT_ROOT}

COPY . .

ENTRYPOINT ["json2bqschema"]
