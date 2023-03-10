## 核心概念  
<br>

### Measure 

> 创建测量指标一个数据源和测量的基准

<br>
1. Accuracy 精确度 指对比两个数据集source/target，指定对比规则如大于，小于，等于，指定对比的区间。最后通过job调起的spark计算得到结果集。
<br>
<br>
2. Data Profiling 数据分析，定义一个源数据集，求得n个字段的最大，最小，count值等等
<br><br>
3. Publish 发布，用户如果通过配置文件而不是界面方式创建了Measure，并且spark运行了该质量模型，结果集会写入到 ES中，通过publish 定义一个同名的Mesaure，就会在界面的仪表盘中显示结果集。
<br><br>
4. json/yaml Mesaure用户自定义的Measure，配置文件也可以通过这个位置定义

<br><br>
dq.json

```json
//GriffinMeasure
{
  "name": "streaming_accu",
  //ProcessType
  "process.type": "streaming",
  //DataSource
  "data.sources": [
    {
      "name": "src",
      "baseline": true,
      //DataConnector
      "connector": 
        {
          "type": "kafka",
          "version": "0.10",
          "config": {
            "kafka.config": {
              "bootstrap.servers": "hadoop101:9092",
              "group.id": "griffin",
              "auto.offset.reset": "largest",
              "auto.commit.enable": "false"
            },
            "topics": "source_1",
            "key.type": "java.lang.String",
            "value.type": "java.lang.String"
          },
          "pre.proc": [
            {
              "dsl.type": "df-opr",
              "rule": "from_json"
            }
          ]
        }
      ,
      "checkpoint": {
        "type": "json",
        "file.path": "hdfs://hadoop101:9000/griffin/streaming/dump/source",
        "info.path": "source_1",
        "ready.time.interval": "10s",
        "ready.time.delay": "0",
        "time.range": ["-5m", "0"],
        "updatable": true
      }
    }, {
      "name": "tgt",
      "connector": 
        {
          "type": "kafka",
          "version": "0.10",
          "config": {
            "kafka.config": {
              "bootstrap.servers": "hadoop101:9092",
              "group.id": "griffin",
              "auto.offset.reset": "largest",
              "auto.commit.enable": "false"
            },
            "topics": "target_1",
            "key.type": "java.lang.String",
            "value.type": "java.lang.String"
          },
          "pre.proc": [
            {
              "dsl.type": "df-opr",
              "rule": "from_json"
            }
          ]
        }
      ,
      "checkpoint": {
        "type": "json",
        "file.path": "hdfs://hadoop101:9000/griffin/streaming/dump/target",
        "info.path": "target_1",
        "ready.time.interval": "10s",
        "ready.time.delay": "0",
        "time.range": ["-1m", "0"]
      }
    }
  ],
  //EvaluateRule
  "evaluate.rule": { 
    //Rule
    "rules": [
      {
        "dsl.type": "griffin-dsl",
        //DqType
        "dq.type": "accuracy",
        "out.dataframe.name": "accu",
        "rule": "src.login_id = tgt.login_id AND src.bussiness_id = tgt.bussiness_id AND src.event_id = tgt.event_id",
        "details": {
          "source": "src",
          "target": "tgt",
          "miss": "miss_count",
          "total": "total_count",
          "matched": "matched_count"
        },
        "out":[
          {
            "type":"metric",
            "name": "accu"
          },
          {
            "type":"record",
            "name": "missRecords"
          }
        ]
      }
    ]
  },
  "sinks": ["HdfsSink"]
}
```

1、将Measure存入数据库中
2、提交任务交由griffin-measure.jar中的Application执行
3、job执行需要两个参数