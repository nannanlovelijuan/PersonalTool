import org.scalatest.{FlatSpec, Matchers}

import java.util

class ExampleTest  extends FlatSpec with Matchers{

  trait EmptyArrayList{
    val list = new util.ArrayList[String]
  }

  "a list" should "be empty no create" in new EmptyArrayList {
    list.size() should be(0)
  }

  "a list "should "increase in size upon add" in new EmptyArrayList {
    list.add("Milk")
    list.add("Sugar")
    list.size() should be(2)
  }

}
