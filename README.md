# docker-pyspark
Apache Spark with Python Image

- `latest` (spark and python at master branch)
- `buildbot-worker` (spark, python and buildbot-worker at buildbot-worker branch)

```
docker run --name spark_test \
    -v /path/to/spark_conf:/opt/spark/conf \
    -d eshizhan/pyspark
```

user `root`

password `root`
