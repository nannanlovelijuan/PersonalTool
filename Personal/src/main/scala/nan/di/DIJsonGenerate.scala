package nan.di

import org.json4s.{Formats, NoTypeHints}
import org.json4s.jackson.Serialization
import scalikejdbc.{
  AutoSession,
  ConnectionPool,
  scalikejdbcSQLInterpolationImplicitDef
}

import scala.collection.mutable.ArrayBuffer

/**
 * 数据一体化生成json配置
 */
object DIJsonGenerate {
  Class.forName("com.mysql.jdbc.Driver")

  ConnectionPool.singleton(
    "jdbc:mysql://192.168.12.41:3306/ezp-bd",
    "ezwrite",
    "33KlsXareQbsbrfhq2eJ"
  )

  implicit val session = AutoSession

  def main(args: Array[String]): Unit = {

    val members: List[DescTableSchema] = sql"desc mp_msg_grpmsg".map(rs => DescTableSchema(rs)).list.apply()

    val list = ArrayBuffer[FieldSchema]()
    var i = 0
    members.foreach(f => {
      val fieldType = mysqlSwitchJavaType(f.Type)
      val isKey = if (f.Key == "PRI" || f.Field.equalsIgnoreCase("BrandId")) 1 else 0

      val fieldFormat = if (f.Type.equalsIgnoreCase("datetime")) "yyyy-MM-dd HH:mm:ss" else ""
      val fieldSchema = FieldSchema(f.Field, fieldType, i, fieldFormat, 1, "", isKey)

      i += 1
      list += fieldSchema
    })

    val customFields: ArrayBuffer[FieldSchema] = getCustomField(i)
    val out = list ++ customFields

    implicit val formats: Formats = Serialization.formats(NoTypeHints)
    val aa = Serialization.write(out)
    println(aa)
  }

  /** mysql数据类型转化成java类型
    */
  def mysqlSwitchJavaType(from: String): String = {
    if (from.contains("int")) "Long"
    else if (
      from.contains("char") || from
        .contains("datetime") || from.contains("text")
    ) "String"
    else throw new Exception("不被识别的数据类型")
  }

  def getCustomField(b: Int): ArrayBuffer[FieldSchema] = {
    var i = b
    val dbSharId = FieldSchema("DbShardId", "Long", i, "", 0, "", 0)
    i += 1
    val cloudType = FieldSchema("CloudType", "String", i, "", 0, "", 0)
    i += 1
    val opType = FieldSchema("OpType", "String", i, "", 0, "", 0)
    i += 1
    val pushTimestamp = FieldSchema("PushTimestamp", "Long", i, "", 0, "", 0)
    i += 1
    val consumeTimestamp =
      FieldSchema("ConsumeTimestamp", "Long", i, "", 0, "", 0)
    i += 1
    val canalTimestamp = FieldSchema("CanalTimestamp", "Long", i, "", 0, "", 0)
    i += 1
    val originTableName =
      FieldSchema("OriginTableName", "String", i, "", 0, "", 0)
    ArrayBuffer(
      dbSharId,
      cloudType,
      opType,
      pushTimestamp,
      consumeTimestamp,
      canalTimestamp,
      originTableName
    )
  }

}
