from math import cos, pi, sin # get math functions
import matplotlib.pyplot as plt # get plot 
import numpy as np # get arrays
from mpl_toolkits import mplot3d
from mpl_toolkits.mplot3d.art3d import Poly3DCollection # get 3D
import sys # get command line arguments

def zoom_factory(ax, base_scale=2.):
    def zoom_fun(event):
                                                    # get the current x and y limits
        cur_xlim = ax.get_xlim()
        cur_ylim = ax.get_ylim()
        cur_zlim = ax.get_zlim()
        cur_xrange = (cur_xlim[1] - cur_xlim[0]) * .5
        cur_yrange = (cur_ylim[1] - cur_ylim[0]) * .5
        cur_zrange = (cur_zlim[1] - cur_zlim[0]) * .5
        xdata = event.xdata                         # get event x location
        ydata = event.ydata                         # get event y location
        zdata = event.xdata                         # get event z location
        if event.button == 'up':
                                                    # deal with zoom in
            scale_factor = 1 / base_scale
        elif event.button == 'down':
                                                    # deal with zoom out
            scale_factor = base_scale
        else:
                                                    # deal with something that should never happen
            scale_factor = 1
            print(event.button)
        # set new limits
        try:
           ax.set_xlim([
               xdata - cur_xrange * scale_factor,
               xdata + cur_xrange * scale_factor
           ])
           ax.set_ylim([
               ydata - cur_yrange * scale_factor,
               ydata + cur_yrange * scale_factor
           ])
           ax.set_zlim([                           # calculating new limits
               zdata - cur_zrange * scale_factor,
               zdata + cur_zrange * scale_factor
           ])

           plt.draw()                              # redraw!
        except:
           print('Cursor out of bound')

    fig = ax.get_figure()               
                                                   # attach the call back
    fig.canvas.mpl_connect('scroll_event', zoom_fun)

                                                   # return the function
    return zoom_fun

def get_bezier(P1, P2, T1, T2, steps):    # interpolation of the Bezier curve by the formula
    res = []
    for t in range(steps):
        s = t / steps
        h1 = (1 - s) ** 3
        h2 = 3 * s * (1 - s) ** 2
        h3 = 3 * s ** 2 * (1 - s)
        h4 = s ** 3
        res.append(h1 * P1 + h2 * P2 + h3 * T1 + h4 * T2)
    return res

p0 = np.array([-150, 300, 100])            # initial coordinates of the main points
p1 = np.array([-200, 800, 1600])
p2 = np.array([-250, 50, -250])
p3 = np.array([200, -300, 600])

option = sys.argv[1]
if option == "-b": #based
    pass
if option == "-c": #read from console
        p0[0] = float(sys.argv[2])
        p0[1] = float(sys.argv[3])
        p0[2] = float(sys.argv[4])
        
        p1[0] = float(sys.argv[5])
        p1[1] = float(sys.argv[6])
        p1[2] = float(sys.argv[7])
        
        p2[0] = float(sys.argv[8])
        p2[1] = float(sys.argv[9])
        p2[2] = float(sys.argv[10])
        
        p3[0] = float(sys.argv[11])
        p3[1] = float(sys.argv[12])
        p3[2] = float(sys.argv[13])
elif option == "-f": #read from file
    filename = sys.argv[2]
    lines = []
    with open(filename) as f:
        lines = f.readlines()
    count = 0
    for line in lines:
        x_tmp = line[:line.find(" ")]
        y_tmp = line[line.find(" ")+1:line.rfind(" ")]
        z_tmp = line[line.rfind(" ")+1:]
        if count == 0:
            p0[0] = float(x_tmp)
            p0[1] = float(y_tmp)
            p0[2] = float(z_tmp)
        elif count == 1:
            p1[0] = float(x_tmp)
            p1[1] = float(y_tmp)
            p1[2] = float(z_tmp)
        elif count == 2:
            p2[0] = float(x_tmp)
            p2[1] = float(y_tmp)
            p2[2] = float(z_tmp)
        elif count == 3:
            p3[0] = float(x_tmp)
            p3[1] = float(y_tmp)
            p3[2] = float(z_tmp)
        count += 1


t1 = 0.3 * (p2 - p0)
t2 = 0.3 * (p3 - p1)

curve = get_bezier(p1, p2, t1, t2, 60)    # array [[x, y, z], [], [].....]

x, y, z = zip(*curve)
e = 30
ell = []
for p in curve:                            # cardioda ( каждая точка кривой служит центром, кардиоды задается параметрически)
    points = []
    for j in range(0, e + 1):
        tmp_x = 2*300*cos(j * 7 / e) - 300*cos(2*j * 7 / e) + p[0]
        tmp_y = p[1] * 2
        tmp_z = 2*300*sin(j * 7 / e) - 300*sin(2*j * 7 / e) + p[2]
        points.append((tmp_x, tmp_y, tmp_z))
    points = np.array(points)
    ell.append(points)

verts = []                                  # main array of vertices
for i in range(len(ell) - 1):
    for j in range(len(ell[i])):
        verts.append([
            ell[i][j], ell[(i + 1) % len(ell)][j],
            ell[(i + 1) % len(ell)][(j + 1) % len(ell[i])],
            ell[i][(j + 1) % len(ell[i])]
        ])
        
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d', facecolor = 'w', )
ax.grid(True)
plt.xlabel('x')
plt.ylabel('y')
plt.axis('off')
plt.title("Kinematic surface")

ax.set_xlim([-1000, 1000])
ax.set_ylim([-100, 1000])
ax.set_zlim([-1000, 1000])

scale = 1.5
f = zoom_factory(ax, base_scale=scale)
                                             # plot sides
ax.add_collection3d(
    Poly3DCollection(
        verts,
        facecolor='blue',
        linewidths=0.5,
        edgecolor='yellow'))


plt.show()
