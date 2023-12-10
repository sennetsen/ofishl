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
  let width = get_terminal_width () in
  let padding = (width - String.length text) / 2 in
  Printf.printf "%*s%s\n" padding "" text

let rec make_fish_string emoji count acc =
  if count <= 0 then acc else make_fish_string emoji (count - 1) (acc ^ emoji)

let print_welcome_screen () =
  let title =
    "\027[33m Welcome to OFishl, the Official OCaml Fishing Tournament! \027[0m"
  in
  let instructions =
    [
      "\027[36m Instructions: \027[0m";
      "\027[36m Use the arrow keys or WASD to move. Press F to interact with \
       fish and the store. \027[0m";
      "\027[36m When in the store, click the red box or press X to exit. Hold \
       down Left-Shift to mass buy 10 of the chosen item. \027[0m";
      "\027[36m Press the 'esc' key to quit. \027[0m";
      "\027[36m Go fish! \027[0m";
    ]
  in

  let fish_emoji = "🎣" in

  let separator = make_fish_string fish_emoji (get_terminal_width () / 2) "" in

  print_endline separator;
  print_centered_text title;
  print_endline separator;
  List.iter print_centered_text instructions;
  print_endline separator
