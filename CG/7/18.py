import numpy as np # get arrays
import matplotlib.pyplot as plt # get plot
import sys # get command line arguments
from matplotlib.widgets import Slider # get Sliders

def get_bezier(Pi_x, Pi_y):
    # Prepare arrays t
    t = np.linspace(0, 1, 1000)
    # Get two segment
    x1 = (1-t)**3*Pi_x[0] + 3*t*(1-t)**2*Pi_x[1] + 3*t**2*(1-t)*Pi_x[2] + t**3*Pi_x[3]
    y1 = (1-t)**3*Pi_y[0] + 3*t*(1-t)**2*Pi_y[1] + 3*t**2*(1-t)*Pi_y[2] + t**3*Pi_y[3]
    x2 = (1-t)**3*Pi_x[3] + 3*t*(1-t)**2*Pi_x[2] + 3*t**2*(1-t)*Pi_x[4] + t**3*Pi_x[5]
    y2 = (1-t)**3*Pi_y[3] + 3*t*(1-t)**2*Pi_y[2] + 3*t**2*(1-t)*Pi_y[4] + t**3*Pi_y[5]
    #Merge segments
    x = [*x1, *x2]
    y = [*y1, *y2]
    return x, y


def update_x(val):
    for i in range(n):
        Pi_x[i] = sliders_x[i].val        
    x_interpolated, _ = get_bezier(Pi_x, Pi_y)
    initial.set_xdata(Pi_x)
    interpolated.set_xdata(x_interpolated)
def update_y(val):
    for i in range(n):
        Pi_y[i] = sliders_y[i].val
    _, y_interpolated = get_bezier(Pi_x, Pi_y)
    initial.set_ydata(Pi_y)
    interpolated.set_ydata(y_interpolated)


n = 6 # опорные точки
Pi_x = np.arange(n)
Pi_y = np.arange(n)

option = sys.argv[1]
if option == "-c": #read from console
    for i in range(n):
        Pi_x[i] = float(sys.argv[2*(i+1)])
        Pi_y[i] = float(sys.argv[2*(i+1)+1])
elif option == "-f": #read from file
    filename = sys.argv[2]
    lines = []
    with open(filename) as f:
        lines = f.readlines()
    count = 0
    for line in lines:
        x_tmp = line[:line.find(" ")]
        y_tmp = line[line.find(" ")+1:]
        Pi_x[count] = float(x_tmp)
        Pi_y[count] = float(y_tmp)
        count += 1

ax = plt.figure().add_subplot(projection='rectilinear')
initial, = plt.plot(Pi_x, Pi_y, '-o')

x_bezier, y_bezier = get_bezier(Pi_x, Pi_y)
interpolated, = plt.plot(x_bezier, y_bezier)

plt.title("2 mated Bezier segments")
plt.xlim((0, 5))
plt.ylim((-5, 5))
plt.subplots_adjust(left=0.2, bottom=0.4) # place for sliders

# Initialising sliders
sliders_x = []
for i in range(n):
    slider_init = plt.axes([0.2, 0.3 - 0.05 * i, 0.75, 0.03])
    slider = Slider(slider_init, 
                    r'$x_{0}$'.format(i), 
                    Pi_x[i]-20, Pi_x[i]+20, 
                    Pi_x[i])
    sliders_x.append(slider)   
sliders_y = []
for i in range(n):
    slider_init = plt.axes([0.01+0.025*i, 0.25, 0.0225, 0.63])
    slider = Slider(slider_init, 
                    r'$y_{0}$'.format(i), 
                    Pi_y[i]-5, Pi_y[i]+5, 
                    Pi_y[i], 
                    orientation="vertical")
    sliders_y.append(slider)
    

for i in range(n):
    sliders_x[i].on_changed(update_x)
    sliders_y[i].on_changed(update_y)

plt.show()

