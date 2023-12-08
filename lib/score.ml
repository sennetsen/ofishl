open Raylib
open Constants

type t = int * Const.level

let score : t ref = ref (0, Const.Easy)
let new_score () = (0, Const.Easy)

(** [get_score score] returns the score given [score]. *)
let get_score t : int = fst !score

let is_score (sc : t) : bool = failwith ""

let print (sc : t) : unit =
  let text = "Score: " ^ string_of_int (get_score sc) in
  let font = load_font "data/fonts/uni-sans/Uni Sans Heavy.otf" in
  draw_text_ex font text (Vector2.create 390. 24.) 22. 2.
    (Color.create 255 161 0 1000)

let update_score (sc : t) (n : int) : unit =
  let current_score, level = !score in
  let new_score = (current_score + n, level) in
  score := new_score

let set_font_size (sc : t) (size : int) : unit = failwith ""
let set_color (sc : t) (color : string) : unit = failwith ""
