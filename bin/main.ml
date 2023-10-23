open Spectrum
let rec read (eval : string -> string) =
read_line ()


let () =
  Spectrum.Simple.printf "@{<green>%s@}\n" "Testing ASCII colors in terminal";;
           
let () = 
  print_string "\nWelcome to Fish Game! Enter your name: ";
  match (read_line ()) with 
  | n -> print_string "Hello "; print_endline n;


  let rec print_tildas n =
    if n > 0 then (
      print_string "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
      print_endline "";
      print_tildas (n-1);
    ) in

  let rec print_tildas_line n =
    if n > 0 then (
      print_tildas n;
      print_newline ();
      print_tildas_line (n)
    ) in

let num_rows = 10 in
print_tildas_line num_rows