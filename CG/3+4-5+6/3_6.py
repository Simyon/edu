from OpenGL.GL import *
from OpenGL.GLU import *
from OpenGL.GLUT import *
import numpy as np
import sys
import threading
import time
from itertools import cycle

#координаты
X_ROT = 0
Y_ROT = 0
Z_ROT = 10
#константы
ARRAY_SIZE = 100
FIRST_COMPONENT = 4
SECOND_COMPONENT = 3
THIRD_COMPONENT = 2
FOURTH_COMPONENT = 6
REFLECTION = 115
PARABOLID_SIZE = 6
APPROXIMATION = 50


def drawBox():
    global X_ROT, Y_ROT, REFLECTION, APPROXIMATION
    glPushMatrix() 
    glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, (0.2, 0.8, 0.0, 0.8)) # Рассеянный свет
    glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, (0.2, 0.8, 0.0, 0.8)) # Отражённый свет
    glMaterialf(GL_FRONT_AND_BACK, GL_SHININESS, 128 - REFLECTION) # Блеск
    draw(APPROXIMATION)
    glPopMatrix()
    glutSwapBuffers()


def init():
    ambient = (1.0, 1.0, 1.0, 6)
    lightpos = (1.0, 6.0, 7.0)
    glClearColor(255, 255, 255, 1.0)
    glClearDepth(1.0)
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
    glEnable(GL_DEPTH_TEST) # Тест глубины
    glShadeModel(GL_FLAT) # Запрет сглаживания
    glDepthFunc(GL_LEQUAL) # Улучшает рисование
    glEnable(GL_RESCALE_NORMAL) # Масштабирование нормальных векторов
    glHint(GL_POLYGON_SMOOTH_HINT, GL_NICEST) # Устранение зубчиков на краях
    glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST) # Качество интерполяции
    glLightModelf(GL_LIGHT_MODEL_TWO_SIDE, GL_TRUE)
    glEnable(GL_NORMALIZE)
    glLightModelfv(GL_LIGHT_MODEL_AMBIENT, ambient) # Модель освещения
    glEnable(GL_LIGHTING)                           # Освещение включается
    glEnable(GL_LIGHT0)                             # Источник света включается
    glLightfv(GL_LIGHT0, GL_POSITION, lightpos)


def draw(APPROXIMATION):
    #x = R*cos(u)
    #y = R*R
    #z = R*sin(u)
    #-1 <= R <= 1
    #0 <= u <= 2pi
    u = np.linspace(0, 2*np.pi, int(APPROXIMATION*100))
    v = np.linspace(-1, 1, int(APPROXIMATION*100))
    vertex = []
    for i in range(APPROXIMATION*100):
        vertex.append(( (v[i]*np.cos(u[i])), (v[i]*np.sin([i])), (v[i]*v[i]) ))
    glBegin(GL_LINE_STRIP)
    for v in vertex:
        glVertex3fv(v)
    glEnd()

def reshape(width, height):
    glViewport(0, 100, width, height) # Задание объекта на экране
    glMatrixMode(GL_PROJECTION)
    glLoadIdentity()
    gluPerspective(60.0, float(width)/float(height), 1.0, 60.0) # Матрица перспективной проекции 
    glMatrixMode(GL_MODELVIEW)
    glLoadIdentity()
    gluLookAt(10.0, 10.0, 10.0, 1.0, -1.0, 1.0, 10.0, 1, 0.0)  


def display():
    global PARABOLID_SIZE
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
    glMatrixMode(GL_MODELVIEW)
    glLoadIdentity()
    gluLookAt(-20, -20, -15, 10, 10, 20, 0, 0, 10)
    glTranslatef(PARABOLID_SIZE, PARABOLID_SIZE, PARABOLID_SIZE)
    glRotatef(X_ROT, 1, 0, 0)
    glRotatef(Y_ROT, 0, 0, 1)
    glRotatef(Z_ROT, 0, 1, 0)
    drawBox()

def specialkeys(key, x, y):
    global X_ROT, Y_ROT, Z_ROT, PARABOLID_SIZE
    if key == b'x':
        X_ROT += 5
    elif key == b'c':
        X_ROT -= 5
    elif key == b'y':
        Y_ROT += 5
    elif key == b'u':
        Y_ROT -= 5
    elif key == b'k':
        Z_ROT += 5
    elif key == b'l':
        Z_ROT -= 5
    elif key == b'z':
        PARABOLID_SIZE += 1
    elif key == b'a':
        PARABOLID_SIZE -= 1
    elif key == b'p':
        app_change(APPROXIMATION + 1)
    elif key == b'm':
        app_change(APPROXIMATION - 1)
    elif key == b'e':
        exit(0)
    glutPostRedisplay()


def rotate():
    global ARRAY_SIZE, FIRST_COMPONENT, SECOND_COMPONENT, THIRD_COMPONENT, FOURTH_COMPONENT, X_ROT, Y_ROT
    u = np.linspace(0, 2 * np.pi, int(ARRAY_SIZE))
    speed = []
    for i in range(ARRAY_SIZE):
        speed.append((FIRST_COMPONENT + SECOND_COMPONENT * np.sin(THIRD_COMPONENT * u[i] + FOURTH_COMPONENT)) * 0.000005)
    for value in cycle(speed):
        X_ROT += value
        Y_ROT += value
        glutPostRedisplay()

def app_change(x):
    global APPROXIMATION
    APPROXIMATION = x # аппроксимация
    glutPostRedisplay()
    return 0


def main():
    glutInit(sys.argv)
    glutInitDisplayMode(GLUT_RGBA | GLUT_DOUBLE | GLUT_DEPTH)
    glutInitWindowSize(1000, 1000)
    glutInitWindowPosition(0, 0)
    glutCreateWindow("")
    glutDisplayFunc(display)
    glutReshapeFunc(reshape)
    glutKeyboardFunc(specialkeys)
    init()
    t = threading.Thread(target=rotate)
    t.daemon = True
    t.start()
    glutMainLoop()
    glutDestroyWindow()

if __name__ == "__main__":
   main()
