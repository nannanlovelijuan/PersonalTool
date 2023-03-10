package nan.practicalguide.workingwithobject

import scala.beans.BeanProperty

/**
 * java 调用scala
 * @param firstName
 * @param lastName
 */
class Dude(@BeanProperty val firstName: String, val lastName: String) {
  @BeanProperty var position: String = _
}
