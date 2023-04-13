VIEWER=zathura
PAPER=cv.tex
OUTPUT=cv.pdf

all:
	@xelatex $(PAPER)

view:
	@test -f $(OUTPUT) && \
	$(VIEWER) $(OUTPUT) 2>&1&\
	disown -h $$!

clean:
	@for ext in aux out log pdf; do rm -v cv.$$ext; done
