
open Tgl3

module Vg = NanoVG

let fmt = Printf.sprintf

let () =
  let init_status = Glfw.init () in
  print_endline (fmt "init_status: %d" init_status);
  (if init_status <> 1 then
     exit 1);

  Glfw.window_hint Glfw.context_version_major 3;
  Glfw.window_hint Glfw.context_version_minor 2;
  Glfw.window_hint Glfw.opengl_forward_compat 1;
  Glfw.window_hint Glfw.opengl_profile Glfw.opengl_core_profile;

  let win = Glfw.create_window 1483 748 "GLFW OCaml Demo" Glfw.null Glfw.null in
  Glfw.make_context_current win;

  let vg = Vg.(create_gl3 (antialias lor stencil_strokes lor debug)) in
  let c = Vg.rgba 255 0 0 255 in

  Gl.viewport 0 0 1483 748;
  Gl.clear_color 0.5 0.5 0.6 1.0;
  Gl.clear (Gl.color_buffer_bit lor Gl.depth_buffer_bit lor Gl.stencil_buffer_bit);

  let img = Vg.create_image vg "/Users/rizo/Desktop/9.jpg" 0 in
  let (iw, ih) =
    let iw_int, ih_int = Vg.get_image_size vg img in
    (float_of_int iw_int, float_of_int ih_int) in
  print_endline (fmt "image size: (%f, %f)\n" iw ih);
  let img_paint = Vg.image_pattern vg 0.0 0.0 iw ih (0.0 /. 180.0 *. 3.14) img 1.0 in
  let draw_bg () =
    Vg.begin_path vg;
    Vg.rect vg 0.0 0.0 iw ih;
    Vg.fill_paint vg img_paint;
    Vg.fill vg in
  draw_bg ();

  Glfw.swap_interval 0;

  while Glfw.window_should_close win = 0 do
    let (mx, my) = Glfw.get_cursor_pos win in

    draw_bg();

    Vg.begin_frame vg 1483 748 1.0;

    Vg.begin_path vg;
    Vg.ellipse vg mx my 50. 50.;
    Vg.fill_color vg c;
    Vg.fill vg;

    Vg.end_frame vg;

    Gl.flush ();
    Glfw.swap_buffers win;
    Glfw.poll_events ();
  done

