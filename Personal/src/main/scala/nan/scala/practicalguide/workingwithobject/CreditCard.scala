package nan.scala.practicalguide.workingwithobject

/**
 * 查看字节码
 *
 *  scalac .\CreditCard.scala
 *  javap -private CreditCard
 *
 */
class CreditCard(val number: Int, val creditLimit: Int)