package nan.scala.practicalguide.workingwithobject

class Person(val firstName: String, val lastName: String) {

  var position: String = _

  // 辅助构造器 ：辅助构造器的第一行有效语句必须调用主
  //构造器或者其他辅助构造器
  def this(firstName: String, lastName: String, positionHeld: String) {
    this(firstName, lastName)
    position = positionHeld
  }

  override def toString: String = {
    s"$firstName $lastName holds $position position"
  }
}

object main extends App {
  val john = new Person("John", "Smith", "Analyst")

  println(john)

  val bill = new Person("Bill", "Walker")

  println(bill)


}
