#include <string.h>
#include <janet.h>
#include "md5.h"

static Janet jmd5(int32_t argc, Janet* argv) {
    janet_fixarity(argc, 1);
    /* TODO: look into janet_getstring vs janet_getcstring */
    const char* msg = janet_getcstring(argv, 0);
    JanetBuffer* buf = janet_buffer(HASHSIZE);
    md5(msg, strlen(msg), (char *)buf->data);
    buf->count = HASHSIZE;
    return janet_wrap_buffer(buf);
}

JANET_MODULE_ENTRY(JanetTable* env) {
    static const JanetReg funcs[] = {
        {"md5", jmd5,
            "(md5/md5 msg &opt buf)\n\n"
            "Calculates the MD5 hash of msg. If buf is nil, a buffer is "
            "created by default. Returns the buffer."
        },
        {NULL, NULL, NULL}
    };
    janet_cfuns(env, "md5", funcs);
}
