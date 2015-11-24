#  Makefile 
#  Auteur : Farès BELHADJ
#  Email  : amsi@ai.univ-paris8.fr
#  Date   : 03/02/2014

SHELL = /bin/sh
# définition des commandes utilisées
CPPC = g++
ECHO = echo
RM = rm -f
TAR = tar
MKDIR = mkdir
CHMOD = chmod
CP = rsync -R
# déclaration des options du compilateur
PG_FLAGS =
CPPFLAGS = -I.
CFLAGS = -Wall -O3
LDFLAGS = -lopencv_highgui -lopencv_imgproc -lopencv_core -lopencv_objdetect -lglut -lGLU -lGL -lm -lSDL -lSDL_image

UNAME := $(shell uname)
ifeq ($(UNAME),Darwin)
	MACOSX_DEPLOYMENT_TARGET = 10.9
        CFLAGS += -I/opt/local/include/ -I/opt/local/include/opencv2 -mmacosx-version-min=$(MACOSX_DEPLOYMENT_TARGET)
        LDFLAGS += -L/opt/local/lib -mmacosx-version-min=$(MACOSX_DEPLOYMENT_TARGET) -L/usr/lib -lc++ -lopencv_videoio -lopencv_imgcodecs
else
        CFLAGS += -I/usr/include/opencv2 -I/usr/include/opencv2/objdetect -I/usr/include/opencv2/highgui -I/usr/include/SDL
        LDFLAGS += -lstdc++
endif

#définition des fichiers et dossiers
PROGNAME = projet
PACKAGE=$(PROGNAME)
VERSION = 06.1
distdir = $(PACKAGE)-$(VERSION)
HEADERS = 
SOURCES = projet.cpp glimage.c
OBJ = $(SOURCES:.cpp=.o)
DOXYFILE = documentation/Doxyfile
EXTRAFILES = COPYING haarcascade_eye.xml	\
haarcascade_frontalface_default.xml visages.jpg
DISTFILES = $(SOURCES) Makefile $(HEADERS) $(DOXYFILE) $(EXTRAFILES)

all: $(PROGNAME)

$(PROGNAME): $(OBJ)
	$(CC) $(OBJ) $(LDFLAGS) -o $(PROGNAME)

%.o: %.cpp
	$(CPPC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

dist: distdir
	$(CHMOD) -R a+r $(distdir)
	$(TAR) zcvf $(distdir).tgz $(distdir)
	$(RM) -r $(distdir)

distdir: $(DISTFILES)
	$(RM) -r $(distdir)
	$(MKDIR) $(distdir)
	$(CHMOD) 777 $(distdir)
	$(CP) $(DISTFILES) $(distdir)

doc: $(DOXYFILE)
	cat $< | sed -e "s/PROJECT_NAME *=.*/PROJECT_NAME = $(PROGNAME)/" | sed -e "s/PROJECT_NUMBER *=.*/PROJECT_NUMBER = $(VERSION)/" >> $<.new
	mv -f $<.new $<
	cd documentation && doxygen && cd ..

clean:
	@$(RM) -r $(PROGNAME) $(OBJ) *~ $(distdir).tgz gmon.out core.* documentation/*~ shaders/*~ documentation/html
