open Raylib
open Constants

type t = {
  mutable score : int;
  mutable font_size : float;
  mutable color : Color.t;
}
(** AF: The record
    [{
        score = i; 
        font_size = f; 
        color = c; 
      }]
    represents the score textbox containing a score of [i], using a font size of
    [f], and with the text color [c]. RI: No representation invariant necessary. *)

let new_score () : t = { score = 0; font_size = 0.; color = Color.white }
let get_score (sc : t) : int = sc.score
let text (sc : t) : string = "Score: " ^ string_of_int (get_score sc)

let print (sc : t) (font : Font.t) : unit =
  let text_to_print = text sc in
  draw_text_ex font text_to_print (Vector2.create 360. 24.) sc.font_size 1.
    sc.color

let update_score (sc : t) (n : int) : unit = sc.score <- sc.score + n
let set_font_size (sc : t) (size : float) : unit = sc.font_size <- size
let set_color (sc : t) (color : Color.t) : unit = sc.color <- color
