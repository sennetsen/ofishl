open Graphics

module type Player = sig
  val move : status -> unit
end