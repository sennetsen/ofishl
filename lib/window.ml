open Player

module Window = struct
  let init (input : unit) =
    Graphics.open_graph " 750x750+500+500";
    Graphics.set_window_title "hai :3";
    Graphics.plot 10 10;
    Graphics.auto_synchronize true;
    Graphics.display_mode true;
    Graphics.loop_at_exit [ Key_pressed ] move
end
