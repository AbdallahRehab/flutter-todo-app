from PIL import Image, ImageDraw

size = 1024
img = Image.new('RGB', (size, size))
draw = ImageDraw.Draw(img)

start = (157, 80, 187)
mid = (255, 107, 157)
end = (78, 143, 255)
for y in range(size):
    t = y / (size - 1)
    if t < 0.5:
        tt = t * 2
        r = int(start[0] + (mid[0] - start[0]) * tt)
        g = int(start[1] + (mid[1] - start[1]) * tt)
        b = int(start[2] + (mid[2] - start[2]) * tt)
    else:
        tt = (t - 0.5) * 2
        r = int(mid[0] + (end[0] - mid[0]) * tt)
        g = int(mid[1] + (end[1] - mid[1]) * tt)
        b = int(mid[2] + (end[2] - mid[2]) * tt)
    draw.line([(0, y), (size, y)], fill=(r, g, b))

pad = 80
radius = 140
overlay = Image.new('RGBA', (size - 2*pad, size - 2*pad), (255, 255, 255, 0))
odraw = ImageDraw.Draw(overlay)
odraw.rounded_rectangle([0, 0, overlay.size[0], overlay.size[1]], radius=radius, outline=(255, 255, 255, 40), width=8, fill=None)
img.paste(overlay, (pad, pad), overlay)

cx, cy = size//2, size//2
bag_w, bag_h = 420, 420
x0, y0 = cx - bag_w//2, cy - bag_h//2
x1, y1 = cx + bag_w//2, cy + bag_h//2
handle_h = 80
odraw = ImageDraw.Draw(img)
odraw.rounded_rectangle([x0, y0 + handle_h, x1, y1], radius=90, fill=(255, 255, 255, 245))
odraw.rounded_rectangle([x0 + 110, y0, x1 - 110, y0 + handle_h + 40], radius=50, fill=(255, 255, 255, 245))
check = [
    (cx - 90, cy + 40),
    (cx - 10, cy + 120),
    (cx + 140, cy - 40),
]
odraw.line(check, fill=(157, 80, 187), width=42, joint='round')

img.save('assets/icons/app_icon.png', format='PNG')
