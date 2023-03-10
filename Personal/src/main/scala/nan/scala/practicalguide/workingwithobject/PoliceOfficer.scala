package nan.scala.practicalguide.workingwithobject

/**
 * 类型别名
 * @param name
 */
class PoliceOfficer(val name: String)

object Test extends App {

  type Cop = PoliceOfficer

  val topCop = new Cop("abc")
  println(topCop.getClass)
}
