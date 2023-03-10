package nan.practicalguide.fromjavatoscala

/**
 * 默认值
 */
object DefaultValues {

  def mail(destination: String = "head office",mailClass: String = "first") = println(s"Sending to $destination by $mailClass class" )

  def main(args: Array[String]): Unit = {
    mail("a","b")
    mail("a")
    mail()
    mail(mailClass = "abc")
  }

}
