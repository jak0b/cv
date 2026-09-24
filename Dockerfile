FROM ghcr.io/typst/typst:0.14.2

COPY cv.typ .
COPY images images

RUN typst fonts

RUN typst compile cv.typ
