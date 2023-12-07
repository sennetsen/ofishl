open Raylib
open Boat
open Fish
open Coin
open AudioSprite
open Constants
open Target
open Score

type state
(** Type to represent the current state of the game window. *)

val current_state : state ref
(** The current state of the window. *)

val current_fish : Fish.t ref
(** The currently spawned fish. *)

val current_coin : Coin.t ref
(** The currently spawned coin. *)

val score : Score.t
(** The current score of the game. *)

module type WindowSig = sig
    val setup : string -> string -> unit
    (** Sets up the window. *)
  
    val loop : string -> bool -> unit
    (** Runs all the operating functions for the window. *)
  end

module MainWin : WindowSig
(** Represents the window for the main part of the fishing game. *)

module MiniWin : WindowSig
(** Represents the pop-up window for the fish-catching minigame. *)

val setup : string -> string -> unit
(** Sets up all the necessary characteristics of the main window. *)

val looper : string -> string -> state -> unit
(** [looper map user st] runs all the operating functions for the current state
 of the game while the window is open. *)

val run : string -> string -> unit
(** Activates the window and allows the user to interact with what's inside. *)