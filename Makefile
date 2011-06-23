PC = fpc
PFLAGS = -g -Sc -Mobjfpc
OBJ = bin/game.o bin/screen.o bin/snake.o

all: bin/main

bin/main: $(OBJ)
	$(PC) $(PFLAGS) -o$@ src/main.pas

bin/%.o: src/%.pas
	$(PC) $(PFLAGS) -o$@ $^

clean:
	rm bin/*
