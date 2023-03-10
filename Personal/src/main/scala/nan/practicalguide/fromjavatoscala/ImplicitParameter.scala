package nan.practicalguide.fromjavatoscala

/**
 * 隐式参数：由调用者来决定所传递的默认值
 * 被implicit修饰，传参是可选的，如果没有传值，scala会在调用的作用域中寻找一个隐式变量
 * 这个隐式变量必须和相应的隐式参数具有相同的类型
 * 因此，在一个作用域中每一种类型只能有一个隐式变量
 *
 * 连接网络场景：网络依赖于环境（办公是，家），每一次也不是同一个默认值生效
 */
object ImplicitParameter {

  def main(args: Array[String]): Unit = {

    atOffice()
    atHome()

  }

  def atOffice()={
    println("------>atOffice")

    implicit def officeNetwork = new Wifi("office-network")

    val cafeNetwork = new Wifi("cafe-network")

    connectToNetwork("guest")(cafeNetwork)
    connectToNetwork("Jill code")
    connectToNetwork("Joe Hacker")
  }

  def atHome()={
    println("------>atHome")
    implicit def homeNetwork = new Wifi("home-network")

    connectToNetwork("guest")(homeNetwork)
    connectToNetwork("Joe Hacker")
  }


  def connectToNetwork(user:String)(implicit wifi: Wifi): Unit ={
    println(s"User $user connecto to WIFI $wifi")
  }
}

class Wifi(name: String) {
  override def toString: String = name
}
