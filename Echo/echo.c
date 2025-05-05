#include <stdio.h>

static void called(void) {
	while (1);
	printf("hello world\n");
}

static void never_called(void) {
	printf("hello world\n");
}

int main(void) {
	called();
}
