VIEWER=zathura
PAPER=cv.tex
OUTPUT=cv.pdf

all:
	@xelatex $(PAPER)

view:
	@setsid $(VIEWER) $(OUTPUT) &>/dev/null

clean:
	@for ext in aux out log pdf; do rm -v cv.$$ext; done
