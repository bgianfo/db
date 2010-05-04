
CC = javac

all: DB.java
	$(CC) DB.java

clean:
	rm -rf *.class

run: DB.class
	java DB
