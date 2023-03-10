package nan.scala.clickhouse

import org.scalatest.FlatSpec
import ru.yandex.clickhouse.except.ClickHouseException

import java.util.Properties

class ClickhouseTest extends FlatSpec {

  "getClickhouseConnection " should "not null" in{
    assert(Clickhouse.getClickhouseConnection("192.168.12.242:8123","ezp_crm",new Properties()) != null)
  }

  // 判断异常方法1
  "Clickhouse Connection " should " throw RuntimeException if Address not right" in {
    intercept[RuntimeException]{
      Clickhouse.getClickhouseConnection("192.168.12.24:8123","ezp_crm",new Properties())
    }
  }
  // 判断异常方法2
  "Clickhouse Connection " should " throw ClickHouseException if Address not right" in {
    assertThrows[RuntimeException](Clickhouse.getClickhouseConnection("192.168.12.24:8123","ezp_crm",new Properties()))
  }

}
