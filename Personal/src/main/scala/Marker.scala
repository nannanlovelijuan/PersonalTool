import scala.collection.mutable

class Marker(val color: String) {

  println(s"Creating ${this}")

  override def toString = s"make color $color"
}

object MarkerFactory extends App {

  private val makers = mutable.Map(
    "red" -> new Marker("red"),
    "blue" -> new Marker("blue"),
    "yellow" -> new Marker("yellow")
  )

  def getMarker(color: String): Marker =
    makers.getOrElseUpdate(color, new Marker(color))


  println(MarkerFactory.getMarker("blue"))
  println(MarkerFactory.getMarker("blue"))
  println(MarkerFactory.getMarker("red"))
  println(MarkerFactory.getMarker("red"))
  println(MarkerFactory.getMarker("green"))
}
