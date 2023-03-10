package nan.scala.di

import scalikejdbc.{AutoSession, ConnectionPool, DB, scalikejdbcSQLInterpolationImplicitDef, select, withSQL}


object TestH2 {
  Class.forName("org.h2.Driver")
  ConnectionPool.singleton("jdbc:h2:mem:hello",
    "user",
    "pass")

  implicit val session = AutoSession

  def main(args: Array[String]): Unit = {
    sql"""
         |create table members (
         |  id serial not null primary key,
         |  name varchar(64),
         |  created_at timestamp not null
         |)
         |""".stripMargin.execute.apply()

    Seq("Alice", "Bob", "Chris") foreach {
      name => sql"insert into members (name,created_at) values (${name}, current_timestamp)".update().apply()
    }
    val entities: List[Map[String, Any]] = sql"select * from members".map(_.toMap).list.apply()
    //
    println(entities)
    val columns: List[Map[String, Any]] = sql"desc members".map(_.toMap).list.apply()

    println(columns)
  ConnectionPool.close()
  }
}
