package org.concurrent.file.count

import akka.actor._
import akka.routing.RoundRobinPool

class FilesCounter extends Actor{
  // 记录开始时间
  val start = System.nanoTime()
  // 记录已经发现的文件数
  var filesCount = 0L
  // 正在进行的尚未完成的文件遍历数
  var pending = 0L

  // RoundRobinPool 路由器，它由这个类的几个实例支撑。顾名思义，
  //发送到这个路由器的消息将会被均匀地路由到支撑这个路由器的多个 Actor
  // 持有一个RoundRobinPool实例的引用，持有100个FileExplorer Actor的实例
  val fileExplorers: ActorRef = context.actorOf(RoundRobinPool(100).props(Props[FileExplorer]))

  override def receive: Receive = {
    case dirName: String =>
      println(s"$dirName----------$filesCount")
      pending = pending + 1
      fileExplorers ! dirName

    case count: Int =>
      println(s"$count----------$filesCount")
      filesCount = filesCount + count
      pending = pending -1

      if (pending == 0){
        val end = System.nanoTime()
        println(s"Files count: $filesCount")
        println(s"Time taken: ${(end - start) / 1.0e9} seconds")
        context.system.terminate()
      }
  }
}
