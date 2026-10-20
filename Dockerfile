FROM ghcr.io/typst/typst:0.14.2

COPY cv.typ cv-de.typ cv-template.typ ./
COPY img img

RUN typst fonts

RUN typst compile cv.typ cv.pdf && typst compile cv-de.typ cv-de.pdf
