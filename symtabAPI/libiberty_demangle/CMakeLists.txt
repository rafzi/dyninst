PROJECT(libiberty_demangle)

ADD_DEFINITIONS(-DHAVE_CONFIG_H=1)

ADD_LIBRARY(${PROJECT_NAME} STATIC
    cplus-dem.c
    safe-ctype.c
    xmalloc.c
    xstrdup.c
)

TARGET_INCLUDE_DIRECTORIES(${PROJECT_NAME} PUBLIC .)