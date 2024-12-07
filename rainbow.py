# Generate and list the scaled rainbow colors directly
import numpy as np

# Generate 32 rainbow colors starting from red on the left to purple on the right
def generate_ordered_rainbow_colors(n):
    colors = []
    for i in range(n):
        # Adjust the sine functions to start from red and end at purple
        red = int((np.sin(i / n * np.pi) + 1) * 7.5)  # Red channel: peaks at start
        green = int((np.sin((i / n * np.pi) + 2 * np.pi / 3) + 1) * 7.5)  # Green channel: mid-cycle
        blue = int((np.sin((i / n * np.pi) + 4 * np.pi / 3) + 1) * 7.5)  # Blue channel: peaks at end
        color = f"#{red:X}{green:X}{blue:X}"  # Convert to hex format
        colors.append(color)
    return colors

# Generate and visualize the colors
ordered_rainbow_colors = generate_ordered_rainbow_colors(32)

def generate_red_to_purple_rainbow(n):
    colors = []
    for i in range(n):
        # Calculate RGB values based on position in the range [0, n-1]
        red = int((1 - (i / (n - 1))) * 15)  # Red starts at max and decreases
        blue = int((i / (n - 1)) * 15)  # Blue starts at 0 and increases to max
        green = int((np.sin(i / (n - 1) * np.pi)) * 15)  # Green peaks in the middle
        color = f"#{red:X}{green:X}{blue:X}"  # Convert to hex format
        colors.append(color)
    return colors

# Generate and visualize the corrected colors
red_to_purple_colors = generate_red_to_purple_rainbow(32)

import pandas as pd
import matplotlib.pyplot as plt

# Manually calculated color values for demonstration (scaled 0x000 to 0xFFF)
example_colors = red_to_purple_colors
# Visualizing the manually calculated colors
plt.figure(figsize=(2, 6))
for i, color in enumerate(example_colors):
    plt.plot([0, 1], [i, i], linewidth=8, color=color)

plt.gca().set_yticks([])
plt.gca().set_xticks([])
plt.title("Static Example of Rainbow Colors", fontsize=12)
plt.axis("off")
plt.show()

w = open("rainbow.txt" , 'w')
for index,color in enumerate(red_to_purple_colors) :
    w.write(f"7'b{index+24:05b}: data = 12'h{color[1:]};\n")
    # print(color)
