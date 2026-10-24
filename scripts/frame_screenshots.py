#!/usr/bin/env python3
"""Turns raw simulator screenshots into captioned App Store screenshots.

Usage: frame_screenshots.py <raw dir with max/ and pro/> <output dir>

Writes 6.9" (1320 x 2868) and 6.3" (1206 x 2622) PNGs with no alpha channel,
as App Store Connect requires.
"""
import pathlib
import sys

from PIL import Image, ImageDraw, ImageFilter, ImageFont

SIZES = {"max": ("6.9-inch", (1320, 2868)), "pro": ("6.3-inch", (1206, 2622))}

CAPTIONS = {
    "01-right-now": ("Help for the moment\nit hits", "Wobble, storm or after: know what to do"),
    "02-storm": ("Know what to say,\nand what not to", "Calm, clear steps for the hardest moments"),
    "03-signal-cards": ("When words\nwon't come", "Full-screen cards to show, not explain"),
    "04-feelings-finder": ("Put big feelings\ninto words", "Tap what you notice, then share it"),
    "05-translate": ("Say it so\nit's heard", "Everyday moments, translated for RSD"),
    "06-us": ("Build your plan\ntogether", "Triggers, signs, what helps, a pause word"),
    "07-understand": ("Understand RSD,\ngently", "Short, clear explainers in minutes"),
}

TOP = (33, 120, 136)       # deep teal
BOTTOM = (92, 184, 194)    # light teal, matches the icon
BEZEL = (24, 24, 28)
FONT_DIR = pathlib.Path("/usr/share/fonts/opentype/inter")


def font(name, size):
    try:
        return ImageFont.truetype(str(FONT_DIR / name), size)
    except OSError:
        return ImageFont.truetype("DejaVuSans-Bold.ttf", size)


def gradient(width, height):
    image = Image.new("RGB", (width, height))
    draw = ImageDraw.Draw(image)
    for y in range(height):
        t = y / (height - 1)
        draw.line([(0, y), (width, y)], fill=tuple(round(a + (b - a) * t) for a, b in zip(TOP, BOTTOM)))
    return image


def rounded_mask(size, radius):
    mask = Image.new("L", size, 0)
    ImageDraw.Draw(mask).rounded_rectangle([0, 0, size[0] - 1, size[1] - 1], radius=radius, fill=255)
    return mask


def frame(shot, caption, width, height):
    canvas = gradient(width, height)
    draw = ImageDraw.Draw(canvas)
    unit = width / 1320  # layout is designed at 6.9" and scaled

    title, subtitle = caption
    title_font = font("InterDisplay-Bold.otf", round(112 * unit))
    sub_font = font("Inter-Medium.otf", round(50 * unit))
    y = round(150 * unit)
    draw.multiline_text((width / 2, y), title, font=title_font, fill="white", anchor="ma",
                        align="center", spacing=round(14 * unit))
    title_box = draw.multiline_textbbox((width / 2, y), title, font=title_font, anchor="ma",
                                        align="center", spacing=round(14 * unit))
    y = title_box[3] + round(40 * unit)
    draw.text((width / 2, y), subtitle, font=sub_font, fill=(230, 247, 248), anchor="ma")

    # The phone: screenshot inside a dark bezel, running off the bottom edge.
    screen_w = round(width * 0.80)
    screen_h = round(shot.height * screen_w / shot.width)
    screen = shot.convert("RGB").resize((screen_w, screen_h), Image.LANCZOS)
    bezel = round(26 * unit)
    radius = round(120 * unit)
    phone_w, phone_h = screen_w + bezel * 2, screen_h + bezel * 2
    left = (width - phone_w) // 2
    top = round(640 * unit)

    shadow = Image.new("L", (width, height), 0)
    ImageDraw.Draw(shadow).rounded_rectangle(
        [left, top + round(30 * unit), left + phone_w, top + phone_h + round(30 * unit)],
        radius=radius + bezel, fill=110)
    shadow = shadow.filter(ImageFilter.GaussianBlur(round(50 * unit)))
    canvas = Image.composite(Image.new("RGB", (width, height), (10, 50, 58)), canvas, shadow)

    phone = Image.new("RGB", (phone_w, phone_h), BEZEL)
    phone.paste(screen, (bezel, bezel), rounded_mask((screen_w, screen_h), radius))
    canvas.paste(phone, (left, top), rounded_mask((phone_w, phone_h), radius + bezel))
    return canvas


def main():
    raw, out = pathlib.Path(sys.argv[1]), pathlib.Path(sys.argv[2])
    for key, (label, (width, height)) in SIZES.items():
        source = raw / key
        if not source.is_dir():
            print(f"skipping {key}: {source} not found")
            continue
        target = out / label
        target.mkdir(parents=True, exist_ok=True)
        for name, caption in CAPTIONS.items():
            path = source / f"{name}.png"
            if not path.exists():
                print(f"missing {path}")
                continue
            image = frame(Image.open(path), caption, width, height)
            assert image.size == (width, height) and image.mode == "RGB"
            image.save(target / f"{name}.png", optimize=True)
            print(f"wrote {target / name}.png")


if __name__ == "__main__":
    main()
