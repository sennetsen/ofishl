open Unix

val get_terminal_width : unit -> int
(** Retrieves the width of the terminal window. Returns the width of the
    terminal or a default value of 80 if unable to retrieve. *)

val print_centered_text : string -> unit
(** Prints the given text centered in the terminal window. *)

val make_fish_string : string -> int -> string -> string
(** Creates a string of fish emojis to be printed as line separators in the
    welcome screen generation. *)

val print_welcome_screen : unit -> unit
(** [print_welcome_page ()] prints a welcome message and instructions for the
    game. *)
