open Raylib
open Boat
open AudioSprite
open Constants
open Score
open Loadables

type state
(** Type to represent the current state of the game window. *)

val current_state : state ref
(** The current state of the window. *)

val current_fish : Sprites.Fish.t ref
(** The currently spawned fish. *)

val current_coin : Sprites.Coin.t ref
(** The currently spawned coin. *)

val current_seamine : Sprites.Seamine.t ref
(** The currently spawned seamine. *)

val score : Score.t
(** The current score of the game. *)

type game_data = {
  mutable final_score : int;  (** Final score achieved in the game. *)
  mutable rods : int;  (** Number of rods purchased in the game. *)
  mutable bait : int;  (** Amount of bait purchased in the game. *)
  mutable trophy : bool;
      (** True if the player bought the trophy, false otherwise. *)
}
(** Represents the game data containing mutable fields for final score, rods,
    and bait. *)

val game_data : game_data
(** Initial game data with default values. *)

(** The signature of a window module. *)
module type WindowSig = sig
  val setup : string -> string -> Loadables.t -> unit
  (** Sets up the window. *)

  val loop : string -> Loadables.t -> unit
  (** Runs all the operating functions for the window. *)
end

module StartMenuWin : WindowSig
(** Represents the window for the starting menu of the fishing game. *)

module MainWin : WindowSig
(** Represents the window for the main part of the fishing game. *)

module MiniWin : WindowSig
(** Represents the pop-up window for the fish-catching minigame. *)

module StoreWin : WindowSig
(** Represents the pop-up window for the store. *)

module WinScreen : WindowSig
(** Represents the pop-up window when you win. *)

val setup : string -> string -> Loadables.t
(** Sets up all the necessary characteristics of the main window. *)

val looper : string -> string -> state -> Loadables.t -> unit
(** [looper map user st] runs all the operating functions for the current state
    of the game while the window is open. *)

val run : string -> string -> unit
(** Activates the window and allows the user to interact with what's inside. *)
