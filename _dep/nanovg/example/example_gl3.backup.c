
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

void draw_circle(
        NVGcontext* vg,
        float mx, float my,
        float s, float t)
{
    nvgBeginPath(vg);
    nvgEllipse(vg, mx, my, s, s);
    nvgFillColor(vg, nvgRGBA(255, 255, 255, 10));
    nvgFill(vg);
    nvgRestore(vg);
}

void errorcb(int error, const char* desc)
{
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

    window = glfwCreateWindow(1200, 850, "NanoVG", NULL, NULL);
    /* window = glfwCreateWindow(1200, 850, "NanoVG", glfwGetPrimaryMonitor(), NULL); */

	if (! window) {
		glfwTerminate();
		return -1;
	}

	glfwSetKeyCallback(window, key);

	glfwMakeContextCurrent(window);

	vg = nvgCreateGL3(NVG_ANTIALIAS | NVG_STENCIL_STROKES | NVG_DEBUG);
	if (vg == NULL) {
		printf("Could not init nanovg.\n");
		return -1;
	}

	glfwSwapInterval(0);
	glfwSetTime(0);


    double mx, my, t;
    int win_width, win_height;
    int fb_width, fb_height;
    float px_ratio;

    glfwGetWindowSize(window, &win_width, &win_height);
    glfwGetFramebufferSize(window, &fb_width, &fb_height);

    px_ratio = (float)fb_width / (float)win_width;

    // Initi Gl viewport
    glViewport(0, 0, fb_width, fb_height);
    /* glClearColor(0.3f, 0.3f, 0.32f, 1.0f); */
    glClearColor(0.0f, 0.0f, 0.02f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT|GL_STENCIL_BUFFER_BIT);

    char dev[100];
    char time_str[100];
    float x, y, z;

    int c = 0;
    while (! glfwWindowShouldClose(window)) {
        c += 1;

        t = glfwGetTime();
        glfwGetCursorPos(window, &mx, &my);


        if (scanf("%[^,],%[^,],%f,%f,%f\n", time_str, dev, &x, &y, &z) != EOF) {
            nvgBeginFrame(vg, win_width, win_height, px_ratio);

            draw_circle(vg, x*5.0, win_height - y*5.0 - 100, 1, t);

            if (c % 1000 == 0) {
                nvgEndFrame(vg);
                glfwSwapBuffers(window);
            }
        }
        else {
        }


        glfwPollEvents();
    }

	nvgDeleteGL3(vg);
	glfwTerminate();

	return 0;
}
