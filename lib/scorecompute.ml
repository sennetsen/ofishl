open Raylib
open Constants

  type t = (int * Const.level)
  (** The type of a score element. *)

  let new_score () = (0, Const.Easy)
  let is_score (sc : t) : bool = failwith ""
  let print (sc : t) : unit = failwith ""
  let update_score (sc : t) (n : int) : unit = failwith ""
  let set_font_size (sc : t) (size : int) : unit = failwith ""

  let set_color (sc : t) (color : string) : unit = failwith ""