open Raylib
open Boat
open Vector2
open Score

type diff =
  | Trap
  | Mine
  | Bomba

module type MineSig = sig
  type t

  val random_diff : unit -> diff
  val get_damage : t -> int
  val generate : Boat.t -> t
  val draw : t -> unit
  val colliding : Vector2.t -> t -> bool
end

module Seamine : MineSig = struct
  type t = Vector2.t * diff

  let random_diff (() : unit) : diff =
    match Random.int 3 with
    | 0 -> Trap
    | 1 -> Mine
    | 2 -> Bomba
    | _ -> failwith ""

  let get_damage (s : t) : int =
    match snd s with
    | Trap -> -1
    | Mine -> -3
    | Bomba -> -5

  let rec generate (boat : Boat.t) : t =
    let x, y = (Random.float 512., Random.float 512.) in
    if x <= 310. && x >= 220. && y <= 310. && y >= 220. then generate boat
    else
      let boat_x, boat_y = (Boat.get_x boat, Boat.get_y boat) in
      if
        x <= boat_x +. 20.
        && x >= boat_x -. 20.
        && y <= boat_y +. 20.
        && y >= boat_x -. 20.
      then generate boat
      else (Vector2.create x y, random_diff ())

  let draw (sprite : t) : unit =
    match snd sprite with
    | Trap -> draw_circle_v (fst sprite) 15. (Color.create 255 248 110 500)
    | Mine -> draw_circle_v (fst sprite) 15. (Color.create 255 159 140 500)
    | Bomba -> draw_circle_v (fst sprite) 15. (Color.create 166 166 166 500)

  let colliding (boat : Vector2.t) (sprite : t) : bool =
    check_collision_circles boat 15. (fst sprite) 8.
end
