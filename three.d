
import glfw3;
import derelict.opengl3.gl;
import std.exception;
import std.math;


void gear(GLfloat inner_radius, GLfloat outer_radius, GLfloat width,
    GLint teeth, GLfloat tooth_depth)
{
  GLfloat r0, r1, r2;
  GLfloat angle, da;
  GLfloat u, v, len;

  r0 = inner_radius;
  r1 = outer_radius - tooth_depth / 2.0;
  r2 = outer_radius + tooth_depth / 2.0;
  
  da = 2.0 * PI / teeth / 4.0;

  glShadeModel(GL_FLAT);

  glNormal3f(0, 0, 1);

   /* draw front face */
  glBegin(GL_QUAD_STRIP);
  foreach (i; 0 .. teeth + 1)
  {
    angle = i * 2.0 * PI / teeth;
    glVertex3f(r0 * cos(angle), r0 * sin(angle), width * 0.5f);
    glVertex3f(r1 * cos(angle), r1 * sin(angle), width * 0.5f);
    if (i < teeth) {
      glVertex3f(r0 * cos(angle), r0 * sin(angle), width * 0.5f);
      glVertex3f(r1 * cos(angle + 3 * da), r1 * sin(angle + 3 * da), width * 0.5f);
    }
  }
  glEnd();

  /* draw front sides of teeth */
  glBegin(GL_QUADS);
  da = 2.0 * PI / teeth / 4.0;
  foreach (i; 0 .. teeth)
  {
    angle = i * 2.0 * PI / teeth;

    glVertex3f(r1 * cos(angle), r1 * sin(angle), width * 0.5f);
    glVertex3f(r2 * cos(angle + da), r2 * sin(angle + da), width * 0.5f);
    glVertex3f(r2 * cos(angle + 2 * da), r2 * sin(angle + 2 * da), width * 0.5f);
    glVertex3f(r1 * cos(angle + 3 * da), r1 * sin(angle + 3 * da), width * 0.5f);
  }
  glEnd();

  glNormal3f(0.0, 0.0, -1.0);

  /* draw back face */
  glBegin(GL_QUAD_STRIP);
  foreach (i; 0 .. teeth + 1)
  {
    angle = i * 2.0 * PI / teeth;
    glVertex3f(r1 * cos(angle), r1 * sin(angle), -width * 0.5f);
    glVertex3f(r0 * cos(angle), r0 * sin(angle), -width * 0.5f);
    if (i < teeth) {
      glVertex3f(r1 * cos(angle + 3 * da), r1 * sin(angle + 3 * da), -width * 0.5f);
      glVertex3f(r0 * cos(angle), r0 * sin(angle), -width * 0.5f);
    }
  }
  glEnd();

  /* draw back sides of teeth */
  glBegin(GL_QUADS);
  da = 2.0 * PI / teeth / 4.0;
  foreach (i; 0 .. teeth)
  {
    angle = i * 2.0 * PI / teeth;

    glVertex3f(r1 * cos(angle + 3 * da), r1 * sin(angle + 3 * da), -width * 0.5f);
    glVertex3f(r2 * cos(angle + 2 * da), r2 * sin(angle + 2 * da), -width * 0.5f);
    glVertex3f(r2 * cos(angle + da), r2 * sin(angle + da), -width * 0.5f);
    glVertex3f(r1 * cos(angle), r1 * sin(angle), -width * 0.5f);
  }
  glEnd();

  /* draw outward faces of teeth */
  glBegin(GL_QUAD_STRIP);
  foreach (i; 0 .. teeth)
  {
    angle = i * 2.0 * PI / teeth;

    glVertex3f(r1 * cos(angle), r1 * sin(angle), width * 0.5f);
    glVertex3f(r1 * cos(angle), r1 * sin(angle), -width * 0.5f);
    u = r2 * cos(angle + da) - r1 * cos(angle);
    v = r2 * sin(angle + da) - r1 * sin(angle);
    len = sqrt(u * u + v * v);
    u /= len;
    v /= len;
    glNormal3f(v, -u, 0.0);
    glVertex3f(r2 * cos(angle + da), r2 * sin(angle + da), width * 0.5f);
    glVertex3f(r2 * cos(angle + da), r2 * sin(angle + da), -width * 0.5f);
    glNormal3f(cos(angle), sin(angle), 0.0);
    glVertex3f(r2 * cos(angle + 2 * da), r2 * sin(angle + 2 * da), width * 0.5f);
    glVertex3f(r2 * cos(angle + 2 * da), r2 * sin(angle + 2 * da), -width * 0.5f);
    u = r1 * cos(angle + 3 * da) - r2 * cos(angle + 2 * da);
    v = r1 * sin(angle + 3 * da) - r2 * sin(angle + 2 * da);
    glNormal3f(v, -u, 0.0);
    glVertex3f(r1 * cos(angle + 3 * da), r1 * sin(angle + 3 * da), width * 0.5f);
    glVertex3f(r1 * cos(angle + 3 * da), r1 * sin(angle + 3 * da), -width * 0.5f);
    glNormal3f(cos(angle), sin(angle), 0.0);
  }

  glVertex3f(r1 * cos(0), r1 * sin(0), width * 0.5f);
  glVertex3f(r1 * cos(0), r1 * sin(0), -width * 0.5f);

  glEnd();

  glShadeModel(GL_SMOOTH);

  /* draw inside radius cylinder */
  glBegin(GL_QUAD_STRIP);
  foreach (i; 0 .. teeth + 1)
  {
    angle = i * 2.0 * PI / teeth;
    glNormal3f(-cos(angle), -sin(angle), 0.0);
    glVertex3f(r0 * cos(angle), r0 * sin(angle), -width * 0.5f);
    glVertex3f(r0 * cos(angle), r0 * sin(angle), width * 0.5f);
  }
  glEnd();
}

GLfloat view_rotx = 20.0,
        view_roty = 30.0,
        view_rotz = 0.0;
GLint gear1, gear2, gear3;
GLfloat angle = 0.0;

void draw()
{
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

  glPushMatrix();
    glRotatef(view_rotx, 1.0, 0.0, 0.0);
    glRotatef(view_roty, 0.0, 1.0, 0.0);
    glRotatef(view_rotz, 0.0, 0.0, 1.0);

    glPushMatrix();
      glTranslatef(-3.0, -2.0, 0.0);
      glRotatef(angle, 0.0, 0.0, 1.0);
      glCallList(gear1);
    glPopMatrix();

    glPushMatrix();
      glTranslatef(3.1f, -2.0, 0.0);
      glRotatef(-2.0 * angle - 9.0, 0.0, 0.0, 1.0);
      glCallList(gear2);
    glPopMatrix();

    glPushMatrix();
      glTranslatef(-3.1f, 4.2f, 0.0);
      glRotatef(-2.0 * angle - 25.0, 0.0, 0.0, 1.0);
      glCallList(gear3);
    glPopMatrix();

  glPopMatrix();
}

void animate()
{
  angle = 100.0 * glfwGetTime;
}

void key_f(GLFWwindow* window, int k, int s, int a, int m)
{
  if (a != GLFW_PRESS)
    return;

  switch (k) {
    case GLFW_KEY_Z:
      if (m & GLFW_MOD_SHIFT)
        view_rotz -= 5.0;
      else
        view_rotz += 5.0;
      break;
    case GLFW_KEY_ESCAPE:
      glfwSetWindowShouldClose(window, GL_TRUE);
      break;
    case GLFW_KEY_UP:
      view_rotx += 5.0;
      break;
    case GLFW_KEY_DOWN:
      view_rotx -= 5.0;
      break;
    case GLFW_KEY_LEFT:
      view_roty += 5.0;
      break;
    case GLFW_KEY_RIGHT:
      view_roty -= 5.0;
      break;
    default:
      return;
  }
}

void reshape(GLFWwindow* window, int width, int height)
{
  GLfloat h = cast(float) height / width;
  GLfloat xmax, znear, zfar;

  znear = 5.0;
  zfar = 30.0;
  xmax = znear * 0.5;

 glViewport( 0, 0, width, height );
 
 glMatrixMode( GL_PROJECTION );
 glLoadIdentity();
 glFrustum( -xmax, xmax, -xmax*h, xmax*h, znear, zfar );
 
 glMatrixMode( GL_MODELVIEW );
 glLoadIdentity();
 glTranslatef( 0, 0, -20 );
}

int autoexit = 0;

void init(string[] args)
{
  static GLfloat pos[4] = [ 5.0, 5.0, 10.0, 0.0 ];
  static GLfloat red[4] = [ 0.8, 0.1, 0.0, 1.0 ];
  static GLfloat green[4] = [0.0, 0.8, 0.2, 1.0 ];
  static GLfloat blue[4] = [ 0.2, 0.2, 1.0, 1.0 ];

  glLightfv( GL_LIGHT0, GL_POSITION, pos.ptr );
  glEnable( GL_CULL_FACE );
  glEnable( GL_LIGHTING );
  glEnable( GL_LIGHT0 );
  glEnable( GL_DEPTH_TEST );

  /* make the gears */
  gear1 = glGenLists(1);
  glNewList(gear1, GL_COMPILE);
  glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, red.ptr);
  gear(1.0, 4.0, 1.0, 20, 0.7f);
  glEndList();

  gear2 = glGenLists(1);
  glNewList(gear2, GL_COMPILE);
  glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, green.ptr);
  gear(0.5f, 2.0, 2.0, 10, 0.7f);
  glEndList();

  gear3 = glGenLists(1);
  glNewList(gear3, GL_COMPILE);
  glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, blue.ptr);
  gear(1.3f, 2.0, 0.5f, 10, 0.7f);
  glEndList();

  glEnable(GL_NORMALIZE);

  foreach (i; 1 .. args.length)
  {
    import std.stdio;
    /*import std.string;*/
    if (args[i] == "-info")
    {
      import std.conv;
      writef("GL_RENDERER   = %s\n", to!string(glGetString(GL_RENDERER)));
      writef("GL_VERSION    = %s\n", to!string(glGetString(GL_VERSION)));
      writef("GL_VENDOR     = %s\n", to!string(glGetString(GL_VENDOR)));
      writef("GL_EXTENSIONS = %s\n", to!string(glGetString(GL_EXTENSIONS)));
    }
    else if ( args[i] == "-exit")
    {
      autoexit = 30;
      printf("Auto Exit after %i seconds.\n", autoexit );
    }
  }
}

void main(string[] args)
{
  DerelictGL.load();

  GLFWwindow *window;
  int width, height;

  enforce(glfwInit);
  scope(exit) glfwTerminate;

  glfwWindowHint(GLFW_DEPTH_BITS, 16);

  enforce(window = glfwCreateWindow(300, 300, "Gears", null, null));
  scope(exit) glfwDestroyWindow(window);
  
  glfwSetFramebufferSizeCallback(window, (window, width, height){
        reshape(window, width, height);
      });

  glfwSetKeyCallback(window, (window, key, code, action, mods){
        key_f(window, key, code, action, mods);
      });

  glfwMakeContextCurrent(window);
  glfwSwapInterval( 1 );
  
  glfwGetFramebufferSize(window, &width, &height);
  reshape(window, width, height);
  
  init(args);

  while (!glfwWindowShouldClose( window ))
  {
    draw();
    animate();
    glfwSwapBuffers(window);
    glfwPollEvents();
  }
}
