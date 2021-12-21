import numpy as np # get arrays
import matplotlib.pyplot as plt # get plot
import sys # get command line arguments

def draw(a, A, B):
    ax = plt.figure().add_subplot(projection='rectilinear')
    # Prepare arrays t, x, y
    t = np.linspace(A, B, 1000)
    x = 3*a*t/(1+t**3)
    y = 3*a*t**2/(1+t**3)
    ax.plot(x, y, label='parametric curve')
    ax.legend()
    plt.show()

a = float(sys.argv[1])
A = float(sys.argv[2])
B = float(sys.argv[3])

draw(a, A, B)



