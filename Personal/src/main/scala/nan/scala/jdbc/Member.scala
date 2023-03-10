package nan.scala.jdbc

import scalikejdbc.{SQLSyntaxSupport, WrappedResultSet}

import java.time.ZonedDateTime

case class Member(id: Long,name: Option[String],createdAt: ZonedDateTime)

object Member extends SQLSyntaxSupport[Member] {

  override val tableName = "members"

  def apply(rs: WrappedResultSet) = new Member(
    rs.long("id"), rs.stringOpt("name"), rs.zonedDateTime("created_at"))
}
