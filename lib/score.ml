open Raylib
open Constants

type t = {
  mutable score : int;
  mutable level : Const.level;
  mutable font_size : float;
  mutable color : Color.t;
}

let new_score () : t =
  {
    score = 0;
    level = Easy;
    font_size = 22.;
    color = Color.create 255 161 0 1000;
  }

let get_score (sc : t) : int = sc.score
let is_score (sc : t) : bool = failwith ""

let print (sc : t) (font : Font.t) : unit =
  let text = "Score: " ^ string_of_int (get_score sc) in
  draw_text_ex font text (Vector2.create 390. 24.) sc.font_size 1. sc.color

let update_score (sc : t) (n : int) : unit = sc.score <- sc.score + n
let set_font_size (sc : t) (size : float) : unit = sc.font_size <- size
let set_color (sc : t) (color : Color.t) : unit = sc.color <- color
