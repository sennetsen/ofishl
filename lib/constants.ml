open Raylib
open Vector2

(** Constant values for use in code implementations of Raylib GUI application. *)
module Const = struct
  let canvas_height_fl : float = 512.
  let canvas_width_fl : float = 512.
  let volume : int = 75
  let speed : float ref = ref 1.
  let set_speed (sp : float) : unit = speed := sp
  let get_speed () : float = !speed
  let diag_speed () : float = !speed /. sqrt 2.
end
