
open Elements

open Tgl3
module Vg = NanoVG

module Points_by_time = Map.Make(Int32)


let blueprint_image_path  = "./9.jpg"
let blueprint_width_px    = 1483.0
let blueprint_height_px   = 748.0
let blueprint_width_m     = 185.375
let blueprint_height_m    = 93.5
let blueprint_width_px_i  = int_of_float blueprint_width_px
let blueprint_height_px_i = int_of_float blueprint_height_px

let draw_device_path vg points =
  match points with
  | [] -> ()
  | (x, y)::ps ->
    let open Vg in
    begin_path vg;
    stroke_color vg (rgba 0 160 192 255);
    stroke_width vg 4.0;
    move_to vg x y;
    List.iteri points ~f:(fun i (x, y) -> line_to vg x y);
    stroke vg;
    begin_path vg;
    ellipse vg x y 9.0 9.0;
    fill_color vg (Vg.rgba 255 55 25 255);
    fill vg

let read_row () =
  let line = try read_line ()
    with End_of_file ->
      Log.inf "Reached end of file."; exit 0 in
  match Str.split line ~sep:',' with
  | [ts_str; x_str; y_str] ->
    ts_str, "<dev>", float_of_string x_str, float_of_string y_str
  | [ts_str; dev; x_str; y_str; _z_str] ->
    ts_str, dev, float_of_string x_str, float_of_string y_str
  | [_space_id; ts_str; dev; x_str; y_str; _z_str] ->
    ts_str, dev, float_of_string x_str, float_of_string y_str
  | _ -> Log.wrn (fmt "Bad input line format:\n\t%s" line); exit 1

let () =
  let init_status = Glfw.init () in
  let () = if init_status <> 1 then
      (Log.err (fmt "could not init GLFW, status = %d" init_status);
       exit 1) in

  Glfw.window_hint Glfw.context_version_major 3;
  Glfw.window_hint Glfw.context_version_minor 2;
  Glfw.window_hint Glfw.opengl_forward_compat 1;
  Glfw.window_hint Glfw.opengl_profile Glfw.opengl_core_profile;

  let win = Glfw.create_window blueprint_width_px_i blueprint_height_px_i
      "GLFW OCaml Demo" Glfw.null Glfw.null in
  Glfw.make_context_current win;

  let vg = Vg.(create_gl3 (antialias lor stencil_strokes lor debug)) in

  (* Geometry *)
  let fb_width,  fb_height  = Glfw.get_framebuffer_size win in
  let px_ratio = float_of_int fb_width /. blueprint_width_px in
  let px_factor = blueprint_width_px /. blueprint_width_m in

  Log.inf "Rendering...";

  Gl.viewport 0 0 blueprint_width_px_i blueprint_height_px_i;
  Gl.clear_color 0.5 0.5 0.6 1.0;
  Gl.clear (Gl.color_buffer_bit lor Gl.depth_buffer_bit lor Gl.stencil_buffer_bit);
  Glfw.swap_interval 0;
  Glfw.set_time 0.0;

  let img = Vg.create_image vg "/Users/rizo/Desktop/9.jpg" 0 in
  let (iw, ih) =
    let iw_int, ih_int = Vg.get_image_size vg img in
    (float_of_int iw_int, float_of_int ih_int) in
  let img_paint = Vg.image_pattern vg 0.0 0.0 iw ih (0.0 /. 180.0 *. 3.14) img 1.0 in

  let points = ref [] in
  (* let pt = ref Points_by_time.empty in *)
  while Glfw.window_should_close win = 0 do
    let t = Glfw.get_time () in
    print (fmt "t: %f" t);

    (* Background *)
    Vg.begin_frame vg blueprint_width_px_i blueprint_height_px_i px_ratio;
    Vg.begin_path vg;
    Vg.rect vg 0.0 0.0 iw ih;
    Vg.fill_paint vg img_paint;
    Vg.fill vg;
    Vg.end_frame vg;

    let ts_str, dev, x_px, y_px = read_row () in
    let p_m = (x_px *. px_factor, blueprint_height_px -. (y_px *. px_factor)) in

    (* let pt := Points_by_time.add t *)

    points := p_m :: !points;

    Vg.begin_frame vg blueprint_width_px_i blueprint_height_px_i px_ratio;
    draw_device_path vg (List.take (!points) 200);
    Vg.end_frame vg;

    Glfw.swap_buffers win;
    Glfw.poll_events ();
  done

(* ------------------------------------------------------------------------- *)


(* Doublebuffering *)
(* Glfw.window_hint Glfw.doublebuffer Gl.false_; *)
(* Gl.draw_buffer Gl.front; *)
(* Gl.read_buffer Gl.front; *)




(* Background *)
(* let img = Vg.create_image vg "/Users/rizo/Desktop/9.jpg" 0 in *)
(* let (iw, ih) = *)
  (* let iw_int, ih_int = Vg.get_image_size vg img in *)
  (* (float_of_int iw_int, float_of_int ih_int) in *)
(* let img_paint = Vg.image_pattern vg 0.0 0.0 iw ih (0.0 /. 180.0 *. 3.14) img 1.0 in *)
(* Vg.begin_frame vg blueprint_width_px_i blueprint_height_px_i px_ratio; *)
(* Vg.begin_path vg; *)
(* Vg.rect vg 0.0 0.0 iw ih; *)
(* Vg.fill_paint vg img_paint; *)
(* Vg.fill vg; *)
(* Vg.end_frame vg; *)

(* Text rendering *)
(* let font_status = Vg.create_font vg "sans-bold" "/Users/rizo/Desktop/Roboto-Bold.ttf" in *)
(* Vg.begin_frame vg (int_of_float blueprint_width_px) (int_of_float blueprint_height_px) px_ratio; *)
(* let text = (fmt "hello radar, beware of aware, count = %d" !i) in *)
(* let x, y = 0.0, 100.0 in *)
(* Vg.font_size vg 72.0; *)
(* Vg.font_face vg "sans-bold"; *)
(* Vg.text_align vg (Vg.align_left lor Vg.align_middle); *)
(* Vg.fill_color vg (Vg.rgba 0 0 0 255); *)
(* Vg.text vg x y text; *)
(* Vg.end_frame vg; *)

