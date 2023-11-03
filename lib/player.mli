open Graphics

(** Signature for an operable character that will represent the user. *)
module type Player = sig
  val move : status -> unit
  (** Moves the character when the user presses the W, A, S, or D keys. *)

  val init : unit -> unit
  (** Initiates the window with the player. *)
end
