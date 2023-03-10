package nan.clickhouse

import ru.yandex.clickhouse.{BalancedClickhouseDataSource, ClickHouseConnectionImpl}

import java.text.SimpleDateFormat
import java.util
import java.util.Properties
import scala.collection.JavaConversions.mapAsScalaMap
import scala.util.matching.Regex

/**
 * 单例：只有一个实例的类 用object
 * 独立对象：和任何类都没有关联
 * 伴生对象：一个单例关联一个类型，这样的单例，其名字和对应类的名字一致，被称为伴生对象
 * 半生类和伴生对象
 */
object Main {
  def main(args: Array[String]): Unit = {
    val conn = Clickhouse.getClickhouseConnection("192.168.12.24:8123", "ezp_crm", new Properties())

    val schema = Clickhouse.getSchema(conn, "crm_vip_info_new_all")

    print(schema)
    val map = schema.toMap
    println(map)
    val list = schema.keys.toList

    println(list)
    val clickhouse = new Clickhouse(list, "crm_vip_info_new_all")

    println(clickhouse.initPrepareSQL())
    //    for ((key, value) <- schema) {
    //      println(s"key:$key,value:$value")
    //    }
  }
}

class Clickhouse {

  private var table: String = _
  private var fields: List[String] = _
  // used for split mode
  private var splitMode: Boolean = false
  private var shardTable: String = _

  def this(fields: List[String], table: String) {
    this
    this.fields = fields
    this.table = table
  }

  def initPrepareSQL(): String = {
    val prepare = List.fill(fields.size)("?")
    var table = this.table

    if (splitMode) table = this.shardTable
    s"insert into $table (${this.fields.map(a => a).mkString(",")}) values (${prepare.mkString(",")})"
  }
}

object Clickhouse {

  val arrayPattern = "(Array.*)".r
  val dateTime64Pattern = "(DateTime64\\(.*\\))".r
  val nullablePattern: Regex = "Nullable\\((.*)\\)".r


  def acceptedClickHosuseSchema(fields: List[String], tableSchema: Map[String, String], table: String): CheckResult = {

    val nonExistFields = fields.map(field => (field, tableSchema.contains(field)))
      .filter(!_._2)

    // todo 数据类型的判断支持
    if (nonExistFields.nonEmpty)
      CheckResult.error(s"field ${nonExistFields.mkString(",")} not exist in table $table")
    else
      CheckResult.success()
  }

  /**
   * 表的结构信息
   *
   * @param conn  conn
   * @param table table
   * @return
   */
  def getSchema(conn: ClickHouseConnectionImpl, table: String): util.LinkedHashMap[String, String] = {
    val sql = s"desc $table"
    val resultSet = conn.createStatement.executeQuery(sql)
    val schema = new util.LinkedHashMap[String, String]()
    while (resultSet.next()) schema.put(resultSet.getString(1), resultSet.getString(2))
    schema
  }

  /**
   * 获取数据库连接
   *
   * @param host       host
   * @param database   db
   * @param properties prop
   * @return
   */
  def getClickhouseConnection(host: String, database: String, properties: Properties): ClickHouseConnectionImpl = {
    val globalJdbc = s"jdbc:clickhouse://$host/$database"
    //jdbc 负载均衡的数据源实现
    val balanced = new BalancedClickhouseDataSource(globalJdbc, properties)
    balanced.getConnection.asInstanceOf[ClickHouseConnectionImpl]
  }


  /**
   * 获取默认值
   *
   * @param fieldType type
   * @return
   */
  def getDefaultValue(fieldType: String): Object = {
    fieldType match {
      case "DateTime" | "Date" | "String" => renderStringDefault(fieldType)
      case dateTime64Pattern(_) => renderStringDefault(fieldType)
      case "Int8" | "UInt8" | "Int16" | "Int32" | "UInt32" | "Int64" | "UInt64" |
           "Float32" | "Float64" =>
        new Integer(0)
      case arrayPattern(_) | nullablePattern(_) => null
      case _ => ""
    }
  }

  /**
   * 提供String类型的默认值
   *
   * @param fieldType 字段类型
   * @return
   */
  private def renderStringDefault(fieldType: String): String = {
    fieldType match {
      case "DateTime" =>
        val dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
        dateFormat.format(System.currentTimeMillis())
      case dateTime64Pattern(_) =>
        val dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS")
        dateFormat.format(System.currentTimeMillis())
      case "Date" =>
        val dateFormat = new SimpleDateFormat("yyyy-MM-dd")
        dateFormat.format(System.currentTimeMillis())
      case "String" =>
        ""
    }
  }


  case class DistributedEngine(clusterName: String, database: String, table: String)

  case class Shard(shardNum: Int, shardWeight: Int, replicaNum: Int, hostname: String, hostAddress: String, port: String, database: String) extends Serializable {
    val jdbc = s"jdbc:clickhouse://$hostAddress:$port/$database"
  }
}