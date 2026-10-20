VIEWER=zathura
PAPER=cv.typ
OUTPUT=cv.pdf

all:
	typst compile $(PAPER) $(OUTPUT)

view:
	@test -f $(OUTPUT) && \
	$(VIEWER) $(OUTPUT) 2>&1&\
	disown -h $$!

clean:
	rm -f $(OUTPUT)
