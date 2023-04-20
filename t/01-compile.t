use Test2::V0;
use Test::Alien;
use Alien::FluentBit;

alien_ok 'Alien::FluentBit';
note 'cflags '.Alien::FluentBit->cflags;
note 'libs '.Alien::FluentBit->libs;
note 'bin_dir '.Alien::FluentBit->bin_dir;

eval {
xs_ok { xs => do { local $/; <DATA> }, verbose => 1 }, with_subtest {
   is TestFluent::loadit(), 1, 'Created fluentbit context';
};
1; } or POSIX::_exit(2);

done_testing;

__DATA__
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

//#include <fluent-bit.h>

struct flb_lib_ctx;
typedef struct flb_lib_ctx flb_ctx_t;
extern flb_ctx_t *flb_create();
extern void flb_destroy(flb_ctx_t *ctx);

MODULE = TestFluent PACKAGE = TestFluent
 
int
loadit()
   INIT:
      flb_ctx_t *ctx;
   CODE:
      if ((ctx= flb_create()) != NULL) {
         RETVAL= 1;
         flb_destroy(ctx);
      } else {
         RETVAL= 0;
      }
   OUTPUT:
      RETVAL
