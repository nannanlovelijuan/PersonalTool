package nan.scala.jdbc

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


    // find all members
    val members: List[Member] = sql"select * from members".map(rs => Member(rs)).list.apply()

    println(members)
    // use paste mode (:paste) on the Scala REPL
    val m = Member.syntax("m")
    val name = "Alice"
    val alice: Option[Member] = withSQL {
      select.from(Member as m).where.eq(m.name, name)
    }.map(rs => Member(rs)).single.apply()

    println(alice)

    // 使用scala的标准api和sql
    val memberId: Option[Long] = DB readOnly ({
      implicit session =>
        sql"select id from members where name = ${name}"
          .map(rs => rs.long("id"))
          .single().apply()
    })

    println(memberId)

//    val (p, c) = (Programmer.syntax("p"), Company.syntax("c"))
//
//    val programmers: Seq[Programmer] = DB.readOnly { implicit session =>
//      withSQL {
//        select
//          .from(Programmer as p)
//          .leftJoin(Company as c).on(p.companyId, c.id)
//          .where.eq(p.isDeleted, false)
//          .orderBy(p.createdAt)
//          .limit(10)
//          .offset(0)
//      }.map(Programmer(p, c)).list.apply()


    val columns: List[Map[String, Any]] = sql"desc members".map(_.toMap).list.apply()

    println(columns)
  ConnectionPool.close()
  }
}
