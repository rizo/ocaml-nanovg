
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

int main()
{
	GLFWwindow* win = NULL;
    int init_status = glfwInit();
    printf("init_status: %d", init_status);
	if (! init_status) {
		printf("Failed to init GLFW.");
		return -1;
	}

	glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
	glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 2);
	glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
	glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

    win = glfwCreateWindow(800, 600, "NanoVG", NULL, NULL);

	if (! win) {
		glfwTerminate();
		return -1;
	}

	glfwMakeContextCurrent(win);

    NVGcontext *vg = nvgCreateGL3(NVG_ANTIALIAS | NVG_STENCIL_STROKES | NVG_DEBUG);
    NVGcolor c = nvgRGBA(255.0,0.0,0.0,255.0);

    glViewport(0,0,800,600);
    glfwSwapInterval(0);

    double mx, my;
    while (! glfwWindowShouldClose(win)) {

        glfwGetCursorPos(win, &mx, &my);

        glClearColor(0.5,0.5,0.9,1.0);
        glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT|GL_STENCIL_BUFFER_BIT);

        nvgBeginFrame(vg, 800, 600, 1.0);
        nvgBeginPath(vg);
        nvgEllipse(vg,mx,my,50.0,50.0);
        nvgFillColor(vg,c);
        nvgFill(vg);
        nvgEndFrame(vg);

        glfwSwapBuffers(win);
        glfwPollEvents();
    }

	glfwTerminate();

	return 0;
}

