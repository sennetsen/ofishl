open Graphics

(** Signature for an operable character that will represent the user. *)
module type Player = sig
  (** Moves the character when the user presses the W, A, S, or D keys. *)
  val move : status -> unit
end