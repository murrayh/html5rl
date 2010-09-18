# Just a quick manual job to get things up and running

all: bin/html5rl

bin/html5rl: bin/html5rl.o
	g++ bin/html5rl.o -o bin/html5rl

bin/html5rl.o: bin/html5rl.cpp
	g++ -c bin/html5rl.cpp -o bin/html5rl.o

bin/html5rl.cpp: cpp/src/html5rl.rl
	ragel cpp/src/html5rl.rl -o bin/html5rl.cpp

cpp/src/html5rl_cpp.rl: etc/html5parser.rl

clean:
	rm -f bin/html5rl bin/html5rl.o bin/html5rl.cpp
