open Game
open Window
open Gamestats

let start_time = ref 0.0

let rec enter_map () =
  start_time := Unix.gettimeofday ();
  print_string "Choose a map (1, 2, or 3): ";
  flush stdout;
  try
    let map_choice = read_line () in
    match map_choice with
    | "1" -> "1"
    | "2" -> "2"
    | "3" -> "3"
    | _ ->
        print_endline "Invalid choice. Enter a number (1, 2, or 3): ";
        enter_map ()
  with Failure _ ->
    print_endline "Invalid choice. Enter a number.";
    enter_map ()

let () =
  Terminalentry.print_welcome_screen ();
  print_string "Enter character name: ";
  flush stdout;

  (* Ensures prompt is displayed immediately. *)
  let user = read_line () in
  Printf.printf "Hello, %s!\n" user;
  let chosen_map = enter_map () in
  Printf.printf "You've chosen map %s\n" chosen_map;
  Window.run chosen_map user;

  let current_time = Unix.gettimeofday () in
  let elapsed_time = current_time -. !start_time in
  Printf.printf "\nElapsed time for this run: %.2f seconds\n" elapsed_time;
  let stats = Gamestats.print_content Window.game_data user chosen_map in
  let is_saved = Gamestats.ask_to_save user chosen_map stats in
  match is_saved with
  | true ->
      let time_string =
        "Elapsed time for this run: "
        ^ Printf.sprintf "%.2f" elapsed_time
        ^ " seconds\n"
      in
      Gamestats.save_to_file user (time_string ^ stats);
      Gamestats.print_save_notif true user;
      print_endline ""
  | false ->
      Gamestats.print_save_notif false user;
      print_endline ""
