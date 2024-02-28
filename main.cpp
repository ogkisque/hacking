#include <stdio.h>
#include <stdlib.h>

const char*     FILE_NAME       = "EASY.COM";
const size_t    MAX_NUM_CHARS   = 200;

int main ()
{
    FILE* file_read = fopen (FILE_NAME, "rb");
    if (!file_read)
    {
        printf ("Error with opening file\n");
        return 1;
    }

    char* buffer = (char*) calloc (MAX_NUM_CHARS, sizeof (char));
    size_t num_chars = fread (buffer, sizeof (char), MAX_NUM_CHARS, file_read);

    buffer[13] = 0xEB;
    buffer[14] = 0x19;
    fclose (file_read);

    FILE* file_write = fopen (FILE_NAME, "wb");
    if (!file_write)
    {
        printf ("Error with opening file\n");
        return 1;
    }

    fwrite (buffer, sizeof (char), num_chars, file_write);
    fclose (file_write);
    free (buffer);
}