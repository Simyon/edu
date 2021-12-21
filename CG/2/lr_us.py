import numpy as np # get arrays
import matplotlib.pyplot as plt # get plot
from mpl_toolkits.mplot3d.art3d import Poly3DCollection, Line3DCollection # get polygons
import sys # get command line arguments

fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

number_of_v = 5
v = [] # vertices of a regular truncated pyramid 
for i in range(number_of_v):
    v.append([2*np.cos(2*np.pi*i/number_of_v), 2*np.sin(2*np.pi*i/number_of_v), 0])
    v.append([np.cos(2*np.pi*i/number_of_v), np.sin(2*np.pi*i/number_of_v), 2])

v = np.array(v)
ax.scatter3D(v[:, 0], v[:, 1], v[:, 2])

sides = [[v[j % (2*number_of_v)], v[(j+1) % (2*number_of_v)],       
          v[(j+3) % (2*number_of_v)], v[(j+2) % (2*number_of_v)]] for j in range(0, 2*number_of_v - 1, 2) ]

sides.append([v[k] for k in range(0, 2*number_of_v - 1, 2)])
sides.append([v[k] for k in range(1, 2*number_of_v, 2)])

flag_o_i = int(sys.argv[1]) # orto/iso projection
flag_c_h = int(sys.argv[2]) # carcas draw or invisible lines

if flag_o_i:
    ax.view_init(-3, 0)
    if flag_c_h == 1:
        ax.add_collection3d(Poly3DCollection(sides, alpha=0.42, edgecolors='black'))
    else:
        ax.add_collection3d(Poly3DCollection(sides, alpha=1, edgecolors='black'))
else:
    if flag_c_h == 1:
        ax.add_collection3d(Poly3DCollection(sides, alpha=0.42, edgecolors='black'))
    else:
        ax.add_collection3d(Poly3DCollection(sides, alpha=1, edgecolors='black'))

plt.show()
