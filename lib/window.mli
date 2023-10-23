open Player

(** The signature for windows that will display elements of the game. *)
module type Window = sig
  val init : unit -> unit
end
