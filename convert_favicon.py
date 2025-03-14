from svglib.svglib import svg2rlg
from reportlab.graphics import renderPM

# Convert SVG to PNG
drawing = svg2rlg('static/img/favicon.svg')
renderPM.drawToFile(drawing, 'static/img/favicon.png', fmt='PNG') 