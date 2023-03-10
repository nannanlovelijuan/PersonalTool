package nan.scala.practicalguide.fromjavatoscala

object Parameter {

  /**
   * 变长参数值
   * @param values
   * @return
   */
  def max(values: Int*) = values.foldLeft(values(0)) {
    Math.max
  }


  def main(args: Array[String]): Unit = {
    println(max(1, 3, 5))
  }
}
