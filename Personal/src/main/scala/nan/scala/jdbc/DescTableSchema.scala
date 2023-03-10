package nan.scala.jdbc

import scalikejdbc.{SQLSyntaxSupport, WrappedResultSet}

case class DescTableSchema(Extra: String, Field: String, Null: String, Type: String, Key: String)

object DescTableSchema extends SQLSyntaxSupport[DescTableSchema] {

  //override val tableName = DescTableSchema.tableName

  def apply(rs: WrappedResultSet) = new DescTableSchema(
    rs.string("Extra"),
    rs.string("Field"),
    rs.string("Null"),
    rs.string("Type"),
    rs.string("Key"))
}


case class FieldSchema(FieldName: String, FieldType: String, Index: Int, FieldFormat: String, IsNativeField: Int, FieldAlias: String, IsKey: Int)
