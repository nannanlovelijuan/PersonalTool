package nan.di

object Test {

  def main(args: Array[String]): Unit = {
    var i = 0

    val array = Array(1,2,3)

    array.foreach(f=>{
      println(i)

      i +=1
    })

    i += 1
    println("-----" + i)
  }

}
