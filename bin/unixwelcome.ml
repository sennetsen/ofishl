open Game
open Window
open Unix

let get_terminal_width () =
try
  let ic = Unix.open_process_in "tput cols" in
  let width = int_of_string (input_line ic) in
  close_in ic;
  width
with _ -> 80
 (* Default terminal width *)

let print_centered_text text =
let terminal_width = get_terminal_width () in
let text_width = String.length text in
let spaces_count = (terminal_width - text_width - 4) / 2 in
let spaces = String.make spaces_count ' ' in
Printf.printf "%s %s %s\n" spaces text spaces

let print_welcome_page () =
let title = "Welcome to Go Fish!" in
let instructions = [
  "Instructions:";
  "Use the arrow keys or WASD to move.";
  "Press the 'esc' key to quit.";
  "Go fish!"
] in

let separator = String.make (get_terminal_width ()) '~' in

print_endline separator;
print_centered_text title;
print_endline separator;
List.iter print_centered_text instructions;
print_endline separator

let () =
print_welcome_page ();
(* Add your game logic here *)
print_endline "Starting the game..."
