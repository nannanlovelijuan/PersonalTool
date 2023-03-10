package nan.scala.clickhouse

class CheckResult(val success: Boolean) {

  private var msg: String = _

  def this(success: Boolean, msg: String) {
    this(success)
    this.msg = msg
  }
}

object CheckResult {

  def success(): CheckResult = {
    new CheckResult(true)
  }

  def error(msg: String): CheckResult = {
    new CheckResult(false, msg)
  }
}
