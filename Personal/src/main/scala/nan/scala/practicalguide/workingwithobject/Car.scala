package nan.scala.practicalguide.workingwithobject

class Car(val year: Int) {

  /**
   * 私有的，通过miles才能取值
   */
  private var milesDriver = 0

  def miles = milesDriver

  def driver(distance: Int) = {
    milesDriver += distance
  }
}

object UserCar extends App {
  val car = new Car(2015)

  println(s"Car made in year ${car.year}")

  println(s"Miles driver ${car.miles}")

  println("Drive 10 miles")

  car.driver(10)

  println(s"Miles driver ${car.miles}")
}
