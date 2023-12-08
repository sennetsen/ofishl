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
  val generate : unit -> t
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

  let generate (() : unit) : t =
    (Vector2.create (Random.float 512.) (Random.float 512.), random_diff ())

  let draw (sprite : t) : unit =
    match snd sprite with
    | Trap -> draw_circle_v (fst sprite) 18. Color.yellow
    | Mine -> draw_circle_v (fst sprite) 18. Color.red
    | Bomba -> draw_circle_v (fst sprite) 18. Color.black

  let colliding (boat : Vector2.t) (sprite : t) : bool =
    check_collision_circles boat 15. (fst sprite) 8.
end
