
open Tgl3

module Str = struct
  include String
  let split ?(sep=' ') str =
    let rec indices acc i =
      try
        let i = succ(String.index_from str i sep) in
        indices (i::acc) i
      with Not_found ->
        (String.length str + 1) :: acc
    in
    let is = indices [0] 0 in
    let rec aux acc = function
      | last::start::tl ->
        let w = String.sub str start (last - start - 1) in
        aux (w::acc) (start::tl)
      | _ -> acc
    in
    aux [] is
end

module Vg = NanoVG

let blueprint_image_path = "./9.jpg"
let blueprint_width_px   = 1483.0
let blueprint_height_px  = 748.0
let blueprint_width_m    = 185.375
let blueprint_height_m   = 93.5


let fmt = Printf.sprintf
module Log = struct
  let out level msg = output_string stderr (fmt "%s: %s\n%!"  level msg)
  let inf msg = out "inf" msg
  let err msg = out "err" msg
  let wrn msg = out "wrn" msg
end

(* ========================================================================== *)

let draw_device_path vg points t =
  let open Vg in
  let x0, y0 = List.hd points in
  begin_path vg;
  stroke_color vg (rgba 0 160 192 255);
	stroke_width vg 3.0;
  move_to vg x0 y0;
  for i = 0 to List.length points do
    let xi, yi = List.nth points i in
    line_to vg xi yi
  done;
  stroke vg;
  let xn, yn = List.nth points ((List.length points) - 1) in
  ellipse vg xn yn 5.0 5.0;
  fill_color vg (Vg.rgba 255 55 25 200);
  fill vg


let () =
  let init_status = Glfw.init () in
  let () = if init_status <> 1 then
      (Log.err (fmt "could not init GLFW, status = %d" init_status);
       exit 1) in

  Glfw.window_hint Glfw.context_version_major 3;
  Glfw.window_hint Glfw.context_version_minor 2;
  Glfw.window_hint Glfw.opengl_forward_compat 1;
  Glfw.window_hint Glfw.opengl_profile Glfw.opengl_core_profile;

  let win = Glfw.create_window
      (int_of_float blueprint_width_px)
      (int_of_float blueprint_height_px)
      "GLFW OCaml Demo" Glfw.null Glfw.null in
  Glfw.make_context_current win;

  let vg = Vg.(create_gl3 (antialias lor stencil_strokes lor debug)) in

  (* Geometry *)
  let fb_width,  fb_height  = Glfw.get_framebuffer_size win in
  let px_ratio = float_of_int fb_width /. blueprint_width_px in
  let px_factor = blueprint_width_px /. blueprint_width_m in

  (* Glfw.window_hint Glfw.doublebuffer Gl.false_; *)
  Gl.draw_buffer Gl.front;
  Gl.read_buffer Gl.front;

  (* Doublebuffering *)
  Glfw.swap_interval 0;

  (* Clear *)
  Gl.viewport 0 0 (int_of_float blueprint_width_px) (int_of_float blueprint_height_px);
  Gl.clear_color 0.5 0.5 0.6 1.0;
  Gl.clear (Gl.color_buffer_bit lor Gl.depth_buffer_bit lor Gl.stencil_buffer_bit);

  (* Background *)
  let img = Vg.create_image vg "/Users/rizo/Desktop/9.jpg" 0 in
  let (iw, ih) =
  let iw_int, ih_int = Vg.get_image_size vg img in
  (float_of_int iw_int, float_of_int ih_int) in
  let img_paint = Vg.image_pattern vg 0.0 0.0 iw ih (0.0 /. 180.0 *. 3.14) img 1.0 in
  Vg.begin_frame vg (int_of_float blueprint_width_px) (int_of_float blueprint_height_px) px_ratio;
  Vg.begin_path vg;
  Vg.rect vg 0.0 0.0 iw ih;
  Vg.fill_paint vg img_paint;
  Vg.fill vg;
  Vg.end_frame vg;

  Gl.flush();

  let font_status = Vg.create_font vg "sans-bold" "/Users/rizo/Desktop/Roboto-Bold.ttf" in
  print_endline (fmt "font_status = %d" font_status);

  (* Vg.begin_frame vg (int_of_float blueprint_width_px) (int_of_float blueprint_height_px) px_ratio; *)
  (* let text = "hello radar, beware of aware" in *)
  (* let x, y = 300.0, 500.0 in *)
  (* Vg.font_size vg 72.0; *)
  (* Vg.font_face vg "sans-bold"; *)
  (* Vg.text_align vg (Vg.align_left lor Vg.align_middle); *)
  (* Vg.fill_color vg (Vg.rgba 0 0 0 160); *)
  (* Vg.text vg x y text; *)
  (* Vg.end_frame vg; *)
  (* Gl.flush (); *)

  Log.inf "Rendering...";
  let i = ref 0 in
  (* Gl.viewport 0 0 (int_of_float blueprint_width_px) (int_of_float blueprint_height_px); *)
  (* Gl.clear_color 0.5 0.5 0.6 1.0; *)
  (* Gl.clear (Gl.color_buffer_bit lor Gl.stencil_buffer_bit); *)

  while Glfw.window_should_close win = 0 do

    (* Vg.begin_frame vg (int_of_float blueprint_width_px) (int_of_float blueprint_height_px) px_ratio; *)
    (* let text = (fmt "hello radar, beware of aware, count = %d" !i) in *)
    (* let x, y = 0.0, 100.0 in *)
    (* Vg.font_size vg 72.0; *)
    (* Vg.font_face vg "sans-bold"; *)
    (* Vg.text_align vg (Vg.align_left lor Vg.align_middle); *)
    (* Vg.fill_color vg (Vg.rgba 0 0 0 255); *)
    (* Vg.text vg x y text; *)
    (* Vg.end_frame vg; *)

    let ts_str, dev, x_px, y_px =
    let line = try read_line ()
    with End_of_file ->
    Log.inf "Reached end of file."; exit 0 in
    match Str.split line ~sep:',' with
    | [ts_str; x_str; y_str] -> ts_str, "<dev>", float_of_string x_str, float_of_string y_str
    | [ts_str; dev; x_str; y_str; _z_str] ->
      ts_str, dev, float_of_string x_str, float_of_string y_str
    | [_space_id; ts_str; dev; x_str; y_str; _z_str] ->
      ts_str, dev, float_of_string x_str, float_of_string y_str
    | _ -> Log.wrn (fmt "Bad input line format:\n\t%s" line); exit 1 in

    let x_m = x_px *. px_factor in
    let y_m = blueprint_height_px -. (y_px *. px_factor) in

    (* Draw point *)
    Vg.begin_frame vg
      (int_of_float blueprint_width_px)
      (int_of_float blueprint_height_px) px_ratio;
    Vg.restore vg;
    Vg.begin_path vg;
    Vg.ellipse vg x_m y_m 5.0 5.0;
    Vg.fill_color vg (Vg.rgba 255 55 25 200);
    Vg.fill vg;
    Vg.save vg;
    Vg.end_frame vg;

    print_endline (fmt "ts: %s, dev: %s, x: %f, y: %f" ts_str dev x_m y_m);
    Thread.delay 0.1;

    (* Glfw.swap_buffers win; *)



    (* if !i mod 100 = 0 then begin *)
    Gl.flush ();
    (* end; *)

    i := !i + 1;

    Glfw.poll_events ();
  done

