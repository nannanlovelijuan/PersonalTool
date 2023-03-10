package org.concurrent.file.count

import akka.actor._

import java.io.File

/**
 * 无状态的Actor
 * 并发统计给定目录下的文件数量
 */
class FileExplorer extends Actor {
  override def receive: Receive = {
    case dirName: String =>
      val file = new File(dirName)
      val children = file.listFiles()
      var filesCount = 0

      if (children != null) {
        children.filter(_.isDirectory)
          // 子目录发送给该消息的发送者
          .foreach(sender ! _.getAbsolutePath)
        filesCount = children.count(!_.isDirectory)
      }
      sender ! filesCount
  }
}
