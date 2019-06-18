## Extract BQ Schema from JSON Object
This is a tool to create Google Big Query table schema from JSON object. It can be used to generate BQ schema for your tables from JSON object.

This is modified code to run on a single JSON object and create BQ Schema.

The original gist is available here => https://gist.github.com/igrigorik/83334277835625916cd6

Difference between the gist code and this is that it uses standard ruby `json` library instead of `yajl`. Though `yajl` might be faster but to add that as a dependency the `docker` image size ballons up to 271MB compared to 50MB with using `ruby` `json`.

# To build on local

> `docker build --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') -t darahsan/json2bqschema:latest .`

> `docker run -i  darahsan/json2bqschema:latest < input-file.json > output-file.json`


# To run via docker on your files locally

> `docker run --rm -i darahsan/json2bqschema:latest  < input-file.json > output-file.json`


## $ input-file.json
```
{
    "id": "389652af-afbe-4e87-80c4-9d94a0cd4bc1",
    "event_id": "82306f5bc519b9da",
    "ip": "127.0.0.1",
    "client": {
    "id": "b1266dd3-55fb-4b1c-8a44-a3f4a817c48a",
    "created_at": "2019-04-10 04:48:55",
    "timezone": "+08:00",
    "session_id": "74d776e9-be21-40d9-acb2-7ea6d03113d6"
    },
    "page": {
    "url": "https://example.com/json/2/bq/schema",
    "referrer_url": "https://example.com/json",
    "locale": "en"
    }
}
```

## $ output-file.json
```
[
  {
    "name": "id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "event_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "ip",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "client",
    "type": "RECORD",
    "mode": "NULLABLE",
    "fields": [
      {
        "name": "id",
        "type": "STRING",
        "mode": "NULLABLE"
      },
      {
        "name": "created_at",
        "type": "STRING",
        "mode": "NULLABLE"
      },
      {
        "name": "timezone",
        "type": "STRING",
        "mode": "NULLABLE"
      },
      {
        "name": "session_id",
        "type": "STRING",
        "mode": "NULLABLE"
      }
    ]
  },
  {
    "name": "page",
    "type": "RECORD",
    "mode": "NULLABLE",
    "fields": [
      {
        "name": "url",
        "type": "STRING",
        "mode": "NULLABLE"
      },
      {
        "name": "referrer_url",
        "type": "STRING",
        "mode": "NULLABLE"
      },
      {
        "name": "locale",
        "type": "STRING",
        "mode": "NULLABLE"
      }
    ]
  }
]
```

## To go inside the container for fun or else

> `docker-compose up`

> `docker exec -it json2bqschema sh`
