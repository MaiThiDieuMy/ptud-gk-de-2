from PIL import Image, ImageDraw

# Create a new image with a transparent background
size = (32, 32)
image = Image.new('RGBA', size, (0, 0, 0, 0))
draw = ImageDraw.Draw(image)

# Draw a rounded rectangle background
background_color = (44, 62, 80)  # #2C3E50
draw.rounded_rectangle([(0, 0), (31, 31)], radius=6, fill=background_color)

# Draw a checkmark
checkmark_color = (255, 255, 255)  # White
points = [(8, 16), (13, 21), (24, 10)]
draw.line(points, fill=checkmark_color, width=3, joint="curve")

# Save the image
image.save('static/img/favicon.png', 'PNG') 