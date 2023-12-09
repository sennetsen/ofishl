open Raylib
open Boat

module type FishSig = sig
  type t

  val spawn : Boat.t -> t
  val draw_fish : Texture2D.t -> t -> unit
  val colliding : Vector2.t -> t -> bool
end

module Fish : FishSig = struct
  type t = Vector2.t

  let rec spawn (boat : Boat.t) : t =
    let x, y = (Random.float 512., Random.float 512.) in
    if x <= 310. && x >= 220. && y <= 310. && y >= 220. then spawn boat
    else
      let boat_x, boat_y = (Boat.get_x boat, Boat.get_y boat) in
      if
        x <= boat_x +. 20.
        && x >= boat_x -. 20.
        && y <= boat_y +. 20.
        && y >= boat_x -. 20.
      then spawn boat
      else Vector2.create x y

  let draw_fish (texture : Texture2D.t) (fish : t) =
    draw_texture texture
      (int_of_float (Vector2.x fish) - 50)
      (int_of_float (Vector2.y fish) - 50)
      Color.raywhite

  let colliding (boat : Vector2.t) (fish : t) : bool =
    check_collision_circles boat 15. fish 50.
end
