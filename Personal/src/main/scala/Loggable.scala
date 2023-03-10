import org.apache.log4j.{Level, Logger}

trait  Loggable{
      // 被 transient 标记的变量不会被序列化
  // lazy：惰性求值 告诉Scala 编译器推迟绑定变量和它的值，直到该值被使用时为止
  @transient private lazy val logger = Logger.getLogger(getClass())

  @transient private lazy val griffinLogger: Logger =
    Logger.getLogger("org.apache.griffin")

  def getGriffinLogLevel: Level = {
    var logger = griffinLogger
    while (logger != null && logger.getLevel == null) {
      logger = logger.getParent.asInstanceOf[Logger]
    }
    logger.getLevel
  }

  // :=> 函传参
  // def f4(x:=>Int,y){println(x,y)}
  // f4(f3(1,2),9)
  protected def info(msg: => String): Unit = {
    logger.info(msg)
  }

  protected def debug(msg: => String): Unit = {
    logger.debug(msg)
  }

  protected def warn(msg: => String): Unit = {
    logger.warn(msg)
  }

  protected def warn(msg: => String, e: Throwable): Unit = {
    logger.warn(msg, e)
  }

  protected def error(msg: => String): Unit = {
    logger.error(msg)
  }

  protected def error(msg: => String, e: Throwable) {
    logger.error(msg, e)
  }
}
