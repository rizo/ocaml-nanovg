
#include <unistd.h>

#include <stdio.h>
#ifdef NANOVG_GLEW
#	include <GL/glew.h>
#endif

#ifdef __APPLE__
#	define GLFW_INCLUDE_GLCOREARB
#endif

#include <GLFW/glfw3.h>
#include "nanovg.h"
#define NANOVG_GL3_IMPLEMENTATION
#include "nanovg_gl.h"

// Continente (9)
#define BLUEPRINT_IMAGE_PATH "./9.jpg"
#define BLUEPRINT_WIDTH_PX   1483
#define BLUEPRINT_HEIGHT_PX  748
#define BLUEPRINT_WIDTH_M    185.375
#define BLUEPRINT_HEIGHT_M   93.5

// SportZone NS (11)
/* #define BLUEPRINT_IMAGE_PATH "/Users/rizo/Desktop/11.jpg" */
/* #define BLUEPRINT_WIDTH_PX   879 */
/* #define BLUEPRINT_HEIGHT_PX  604 */
/* #define BLUEPRINT_WIDTH_M    60.85 */
/* #define BLUEPRINT_HEIGHT_M   42.1 */


/* #define BLUEPRINT_IMAGE_PATH "/Users/rizo/Desktop/23.jpg" */
/* #define BLUEPRINT_WIDTH_PX   507 */
/* #define BLUEPRINT_HEIGHT_PX  981 */
/* #define BLUEPRINT_WIDTH_M    11.21 */
/* #define BLUEPRINT_HEIGHT_M   21.69 */

// Renault Valência (126)
/* #define BLUEPRINT_IMAGE_PATH "/Users/rizo/Desktop/126-2.jpg" */
/* #define BLUEPRINT_WIDTH_PX   1603 */
/* #define BLUEPRINT_HEIGHT_PX  1000 */
/* #define BLUEPRINT_WIDTH_M    59.2 */
/* #define BLUEPRINT_HEIGHT_M   37.0 */

// NortShopping (1)
/* #define BLUEPRINT_IMAGE_PATH "1.jpg" */
/* #define BLUEPRINT_WIDTH_PX   1200 */
/* #define BLUEPRINT_HEIGHT_PX  1026 */
/* #define BLUEPRINT_WIDTH_M    232.814 */
/* #define BLUEPRINT_HEIGHT_M   199.1175 */


void draw_circle(
        NVGcontext* vg,
        float mx, float my,
        float s)
{
    NVGcolor c = nvgRGBA(255, 55, 25, 200);
    nvgBeginPath(vg);
    nvgEllipse(vg, mx, my, s, s);
    nvgFillColor(vg, c);
    nvgFill(vg);
}

void errorcb(int error, const char* desc) {
	printf("GLFW error %d: %s\n", error, desc);
}

static void key(GLFWwindow* window, int key, int scancode, int action, int mods)
{
	NVG_NOTUSED(scancode);
	NVG_NOTUSED(mods);

	if (key == GLFW_KEY_ESCAPE && action == GLFW_PRESS)
		glfwSetWindowShouldClose(window, GL_TRUE);

	if (key == GLFW_KEY_SPACE && action == GLFW_PRESS)
        puts("space pressed");

}

int main()
{
	GLFWwindow* window = NULL;
	NVGcontext* vg = NULL;

	if (! glfwInit()) {
		printf("Failed to init GLFW.");
		return -1;
	}

	glfwSetErrorCallback(errorcb);
	glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
	glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 2);
	glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
	glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

    window = glfwCreateWindow(
            BLUEPRINT_WIDTH_PX,
            BLUEPRINT_HEIGHT_PX,
            "NanoVG",
            NULL,
            NULL
    );

	if (! window) {
		glfwTerminate();
		return -1;
	}

	glfwSetKeyCallback(window, key);
	glfwMakeContextCurrent(window);

	vg = nvgCreateGL3( NVG_STENCIL_STROKES | NVG_DEBUG);
    printf("vg flags: %d\n", NVG_ANTIALIAS | NVG_STENCIL_STROKES | NVG_DEBUG);
	if (vg == NULL) {
		printf("Could not init nanovg.\n");
		return -1;
	}

	glfwSwapInterval(0);
	glfwSetTime(0);

    int fb_width, fb_height;
    float px_ratio;

    int win_width, win_height;
    glfwGetWindowSize(window, &win_width, &win_height);
    printf("window size: (%d, %d)\n", win_width, win_height);

    glfwGetFramebufferSize(window, &fb_width, &fb_height);

    px_ratio = (float)fb_width / (float) BLUEPRINT_WIDTH_PX;

    char dev[100];
    char time_str[100];
    float x, y, z;

    // Clear
    glViewport(0, 0, fb_width, fb_height);
    glClearColor(0.0, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT|GL_STENCIL_BUFFER_BIT);

    glfwWindowHint(GLFW_DOUBLEBUFFER, GL_FALSE);
    glDrawBuffer(GL_FRONT);
    glReadBuffer(GL_FRONT);

    // (px -> m) convertion factor
    float f = BLUEPRINT_WIDTH_PX / BLUEPRINT_WIDTH_M;

    nvgBeginFrame(vg, BLUEPRINT_WIDTH_PX, BLUEPRINT_HEIGHT_PX, px_ratio);

    int iw, ih;
    int img = nvgCreateImage(vg, BLUEPRINT_IMAGE_PATH, 0);
    nvgImageSize(vg, img, &iw, &ih);
    printf("blueprint image size: (%d, %d)\n", iw, ih);
    NVGpaint img_paint = nvgImagePattern(vg, 0, 0, iw, ih, 0.0f/180.0f*NVG_PI, img, 1);
    nvgBeginPath(vg);
    nvgRect(vg, 0, 0, iw, ih);
    nvgFillPaint(vg, img_paint);
    nvgFill(vg);


    // Antennas
    // --------
    /*
    nvgBeginPath(vg);
    nvgEllipse(vg, 84.26 * f - 5, BLUEPRINT_HEIGHT - (21.49 * f) - 5, 10, 10);
    nvgFillColor(vg, nvgRGBA(26, 189, 157, 230));
    nvgFill(vg);

    nvgBeginPath(vg);
    nvgEllipse(vg, 183.72 * f - 5, BLUEPRINT_HEIGHT - (13.62 * f) - 5, 10, 10);
    nvgFillColor(vg, nvgRGBA(26, 189, 157, 230));
    nvgFill(vg);

    // Zones
    // -----
    nvgFillColor(vg, nvgRGBA(0, 0, 150, 130));
	nvgStrokeWidth(vg, 3);
	nvgStrokeColor(vg, nvgRGBA(0, 0, 150, 255));

    nvgBeginPath(vg);
    nvgMoveTo(vg, 147.15 * f, BLUEPRINT_HEIGHT - 11.42 * f);
    nvgLineTo(vg, 151.18 * f, BLUEPRINT_HEIGHT - 15.68 * f);
    nvgLineTo(vg, 155.92 * f, BLUEPRINT_HEIGHT - 10.23 * f);
    nvgLineTo(vg, 151.65 * f, BLUEPRINT_HEIGHT - 5.97  * f);
    nvgClosePath(vg);
    nvgFill(vg);
	nvgStroke(vg);

    nvgBeginPath(vg);
    nvgMoveTo(vg, 78.25 * f, BLUEPRINT_HEIGHT - 11.15 * f);
    nvgLineTo(vg, 78.25 * f, BLUEPRINT_HEIGHT - 14.23 * f);
    nvgLineTo(vg, 88.31 * f, BLUEPRINT_HEIGHT - 14.23 * f);
    nvgLineTo(vg, 88.34 * f, BLUEPRINT_HEIGHT - 11.09 * f);
    nvgClosePath(vg);
    nvgFill(vg);
	nvgStroke(vg);

    nvgBeginPath(vg);
    nvgMoveTo(vg, 163.33*f, BLUEPRINT_HEIGHT - 11.72*f);
    nvgLineTo(vg, 163.33*f, BLUEPRINT_HEIGHT - 15.04*f);
    nvgLineTo(vg, 178.03*f, BLUEPRINT_HEIGHT - 14.99*f);
    nvgLineTo(vg, 178.03*f, BLUEPRINT_HEIGHT - 18.07*f);
    nvgLineTo(vg, 180.63*f, BLUEPRINT_HEIGHT - 18.12*f);
    nvgLineTo(vg, 180.63*f, BLUEPRINT_HEIGHT - 11.72*f);
    nvgClosePath(vg);
    nvgFill(vg);
	nvgStroke(vg);

    nvgEndFrame(vg);
    glFlush();
    */

    int c = 0;
    puts("Rendering...");
    while (! glfwWindowShouldClose(window)) {

        if (scanf("%[^,],%[^,],%f,%f,%f\n", time_str, dev, &x, &y, &z) == EOF) {
            puts("EOF");
            break;
        }

        c += 1;
        /* printf("ts: %s, dev: %s, x: %f, y: %f\n", time_str, dev, x, y); */

        nvgBeginFrame(vg, BLUEPRINT_WIDTH_PX, BLUEPRINT_HEIGHT_PX, px_ratio);
        draw_circle(vg, x * f, BLUEPRINT_HEIGHT_PX - (y * f), 2);
        nvgEndFrame(vg);
        /* usleep(500); */

        glFlush();

        glfwPollEvents();
    }

    printf("Processed %d points.\n", c);

	nvgDeleteGL3(vg);
	glfwTerminate();

	return 0;
}

