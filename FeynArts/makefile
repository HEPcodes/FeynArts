all: TopologyEditor.jar FeynArts.pro FeynArts.texpro

CC = gcc
CPP = $(CC) -E -P -C -x c-header

JLINK = /opt/Wolfram/Mathematica/11.0/SystemFiles/Links/JLink/JLink.jar
JOPT = -source 1.4 -target 1.4

TopologyEditor.jar: TopologyEditor.java
	rm -fr de TopologyEditor.jar
	CLASSPATH=$(JLINK): javac $(JOPT) -d . TopologyEditor.java
	jar cvf TopologyEditor.jar de
	rm -fr de

FeynArts.pro: FeynArts.prologue psripper
	$(CPP) FeynArts.prologue | ./psripper > FeynArts.pro

FeynArts.texpro: FeynArts.prologue psripper
	$(CPP) -DTEX FeynArts.prologue | ./psripper > FeynArts.texpro

psripper: psripper.c
	$(CC) -o psripper psripper.c

clean:
	$(RM) psripper FeynArts.texpro

