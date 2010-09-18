# Just a quick manual job to get things up and running

all: bin/html5rl

bin/html5rl: gen/html5rl.o
	g++ gen/html5rl.o -o bin/html5rl

gen/html5rl.o: gen/html5rl.cpp
	g++ -c gen/html5rl.cpp -o gen/html5rl.o

gen/html5rl.cpp: src/html5rl_cpp.rl src/html5parser.rl
	ragel src/html5rl_cpp.rl -o gen/html5rl.cpp

