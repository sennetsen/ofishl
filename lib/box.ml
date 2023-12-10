open Raylib

module type BoxSig = sig
  type t

  val generate : float -> float -> float -> float -> t
  val get_coord : string -> t -> float
  val draw : t -> Color.t -> unit
  val draw_text : t -> string -> float -> float -> Color.t -> Font.t -> unit
  val colliding : Vector2.t -> t -> bool
end

module Box : BoxSig = struct
  type t = Rectangle.t
  (** AF: A box is represented by a Raylib.Rectangle whose x and y position
      correspond with the position of the box in the game window and whose
      height and width correspond with the dimensions of the box. RI: the x, y,
      height, and width of the rectangle must always be within the dimensions of
      the game window. *)

  let generate (x : float) (y : float) (width : float) (height : float) : t =
    Rectangle.create x y width height

  let get_coord (coord : string) (box : t) : float =
    match coord with
    | "x" -> Rectangle.x box
    | "y" -> Rectangle.y box
    | "width" -> Rectangle.width box
    | "height" -> Rectangle.height box
    | _ -> failwith "not a box dimension"

  let draw (rectangle : t) (color : Color.t) : unit =
    draw_rectangle_rounded rectangle 0.15 1 color

  let draw_text (sc : t) (text : string) (size : float) (x : float)
      (tint : Color.t) (font : Font.t) : unit =
    let y1 = Rectangle.y sc +. (Rectangle.height sc /. 2.) -. (size /. 2.3) in
    draw_text_ex font text (Vector2.create x y1) size 0.5 tint

  let colliding (mouse : Vector2.t) (rectangle : t) : bool =
    check_collision_circle_rec mouse 1. rectangle
end
