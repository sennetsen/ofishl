open Raylib
open Unix
open Window

val save_to_file : string -> string -> string -> unit
(** [save_to_file] saves the provided [content] to a file with the specified
    user's name. *)

val ask_to_save : string -> string -> string -> bool
(** [ask_to_save] asks the user whether or not final game data should be written
    to a file based on the game data [data], [user], and [map]. *)

val print_content : Window.game_data -> string -> string -> string
(** [print_content] prints a provided game round's summary data to the terminal,
    based on the values in the record type [data], [user], and [map]. *)

val print_save_notif : bool -> string -> unit
(** [print_save_notif] alerts the player in the terminal that their game data
    has been saved to a given [filename] for [user], based on whether the data
    saving was confirmed [is_confirmed]. *)
