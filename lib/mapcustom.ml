open Raylib
open Constants

module type MapCustomMaker = sig
  type t
  val get_height: t -> int
  val get_width: t -> int
  (*val make_arr : string -> int array array*)
  val generate_map: int array array -> unit
end

module Custom : MapCustomMaker = struct
  type t = string

  let get_width _ = failwith "Not implemented"
  let get_height _ = failwith "Not implemented"

  let generate_map maze =
    let cell_size = 20 in
    let maze_width = Array.length maze in
    let maze_height = Array.length maze.(0) in
  
    init_window (maze_width * cell_size) (maze_height * cell_size) "Maze";  
  
      for y = 0 to maze_height - 1 do
        for x = 0 to maze_width - 1 do
          if maze.(x).(y) = 1 then
            draw_rectangle 
            (x * cell_size) (y * cell_size) cell_size cell_size Color.black;
        done;
      done;
    end  
  
