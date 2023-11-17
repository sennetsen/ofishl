open Ray
open Window

let rec enter_map () =
  print_string "Choose a map (1, 2, or 3): ";
  flush stdout;
  try
    let map_choice = read_int () in
    match map_choice with
    | 1 -> "1"
    | 2 -> "2"
    | 3 -> "3"
    | _ ->
        print_endline "Invalid choice. Enter a number (1, 2, or 3): ";
        enter_map ()
  with
  | Failure _ ->
      print_endline "Invalid choice. Enter a number.";
      enter_map ()

let () =
  print_string "Enter character name: ";
  flush stdout; (* Ensures prompt is displayed immediately. *)
  let user = read_line () in
  Printf.printf "Hello, %s!\n" user;
  let chosen_map = enter_map () in
  Printf.printf "You've chosen map %s\n" (chosen_map);
  Window.run (chosen_map)
  
  



  
