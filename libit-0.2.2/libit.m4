dnl AM_PATH_LIBIT([MINIMUM-VERSION, [ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND [, MODULES]]]])
dnl Test for libit, and define LIBIT_CFLAGS and LIBIT_LIBS
dnl Vivien Chappelier 12/11/00
dnl stolen from ORBit autoconf
dnl
AC_DEFUN(AM_PATH_LIBIT,
[dnl 
dnl Get the cflags and libraries from the libit-config script
dnl
AC_ARG_WITH(libit-prefix,[  --with-libit-prefix=PFX   Prefix where libit is installed (optional)],
            libit_config_prefix="$withval", libit_config_prefix="")
AC_ARG_WITH(libit-exec-prefix,[  --with-libit-exec-prefix=PFX Exec prefix where libit is installed (optional)],
            libit_config_exec_prefix="$withval", libit_config_exec_prefix="")
AC_ARG_ENABLE(libittest, [  --disable-libittest       Do not try to compile and run a test libit program],
		    , enable_libittest=yes)

  if test x$libit_config_exec_prefix != x ; then
     libit_config_args="$libit_config_args --exec-prefix=$libit_config_exec_prefix"
     if test x${LIBIT_CONFIG+set} != xset ; then
        LIBIT_CONFIG=$libit_config_exec_prefix/bin/libit-config
     fi
  fi
  if test x$libit_config_prefix != x ; then
     libit_config_args="$libit_config_args --prefix=$libit_config_prefix"
     if test x${LIBIT_CONFIG+set} != xset ; then
        LIBIT_CONFIG=$libit_config_prefix/bin/libit-config
     fi
  fi

  AC_PATH_PROG(LIBIT_CONFIG, libit-config, no)
  min_libit_version=ifelse([$1], , 0.2.2, $1)
  AC_MSG_CHECKING(for libit - version >= $min_libit_version)
  no_libit=""
  if test "$LIBIT_CONFIG" = "no" ; then
    no_libit=yes
  else
    LIBIT_CFLAGS=`$LIBIT_CONFIG $libit_config_args --cflags`
    LIBIT_LIBS=`$LIBIT_CONFIG $libit_config_args --libs`
    libit_config_major_version=`$LIBIT_CONFIG $libit_config_args --version | \
	   sed -e 's,[[^0-9.]],,g' -e 's/\([[0-9]]*\).\([[0-9]]*\).\([[0-9]]*\)/\1/'`
    libit_config_minor_version=`$LIBIT_CONFIG $libit_config_args --version | \
	   sed -e 's,[[^0-9.]],,g' -e 's/\([[0-9]]*\).\([[0-9]]*\).\([[0-9]]*\)/\2/'`
    libit_config_micro_version=`$LIBIT_CONFIG $libit_config_args --version | \
	   sed -e 's,[[^0-9.]],,g' -e 's/\([[0-9]]*\).\([[0-9]]*\).\([[0-9]]*\)/\3/'`
    if test "x$enable_libittest" = "xyes" ; then
      ac_save_CFLAGS="$CFLAGS"
      ac_save_LIBS="$LIBS"
      CFLAGS="$CFLAGS $LIBIT_CFLAGS"
      LIBS="$LIBIT_LIBS $LIBS"
dnl
dnl Now check if the installed LIBIT is sufficiently new. (Also sanity
dnl checks the results of libit-config to some extent
dnl
      rm -f conf.libittest
      AC_TRY_RUN([
#include <fame.h>
#include <stdio.h>
#include <stdlib.h>

int 
main ()
{
  int major, minor, micro;
  char *tmp_version;

  system ("touch conf.libittest");

  /* HP/UX 9 (%@#!) writes to sscanf strings */
  tmp_version = strdup("$min_libit_version");
  if (sscanf(tmp_version, "%d.%d.%d", &major, &minor, &micro) != 3) {
     printf("%s, bad version string\n", "$min_libit_version");
     exit(1);
   }

  if ((libit_major_version != $libit_config_major_version) ||
      (libit_minor_version != $libit_config_minor_version) ||
      (libit_micro_version != $libit_config_micro_version))
    {
      printf("\n*** 'libit-config --version' returned %d.%d.%d, but Libit (%d.%d.%d)\n", 
             $libit_config_major_version, $libit_config_minor_version, $libit_config_micro_version,
             libit_major_version, libit_minor_version, libit_micro_version);
      printf ("*** was found! If libit-config was correct, then it is best\n");
      printf ("*** to remove the old version of libit. You may also be able to fix the error\n");
      printf("*** by modifying your LD_LIBRARY_PATH enviroment variable, or by editing\n");
      printf("*** /etc/ld.so.conf. Make sure you have run ldconfig if that is\n");
      printf("*** required on your system.\n");
      printf("*** If libit-config was wrong, set the environment variable LIBIT_CONFIG\n");
      printf("*** to point to the correct copy of libit-config, and remove the file config.cache\n");
      printf("*** before re-running configure\n");
    } 
#if defined (LIBIT_MAJOR_VERSION) && defined (LIBIT_MINOR_VERSION) && defined (LIBIT_MICRO_VERSION)
  else if ((libit_major_version != LIBIT_MAJOR_VERSION) ||
	   (libit_minor_version != LIBIT_MINOR_VERSION) ||
           (libit_micro_version != LIBIT_MICRO_VERSION))
    {
      printf("*** libit header files (version %d.%d.%d) do not match\n",
	     LIBIT_MAJOR_VERSION, LIBIT_MINOR_VERSION, LIBIT_MICRO_VERSION);
      printf("*** library (version %d.%d.%d)\n",
	     libit_major_version, libit_minor_version, libit_micro_version);
    }
#endif /* defined (LIBIT_MAJOR_VERSION) ... */
  else
    {
      if ((libit_major_version > major) ||
        ((libit_major_version == major) && (libit_minor_version > minor)) ||
        ((libit_major_version == major) && (libit_minor_version == minor) && (libit_micro_version >= micro)))
      {
        return 0;
       }
     else
      {
        printf("\n*** An old version of libit (%d.%d.%d) was found.\n",
               libit_major_version, libit_minor_version, libit_micro_version);
        printf("*** You need a version of libit newer than %d.%d.%d. The latest version of\n",
	       major, minor, micro);
        printf("*** libit is always available from http://www-eleves.enst-bretagne.fr/~chappeli/fame\n");
        printf("***\n");
        printf("*** If you have already installed a sufficiently new version, this error\n");
        printf("*** probably means that the wrong copy of the libit-config shell script is\n");
        printf("*** being found. The easiest way to fix this is to remove the old version\n");
        printf("*** of libit, but you can also set the LIBIT_CONFIG environment to point to the\n");
        printf("*** correct copy of libit-config. (In this case, you will have to\n");
        printf("*** modify your LD_LIBRARY_PATH enviroment variable, or edit /etc/ld.so.conf\n");
        printf("*** so that the correct libraries are found at run-time))\n");
      }
    }
  return 1;
}
],, no_libit=yes,[echo $ac_n "cross compiling; assumed OK... $ac_c"])
       CFLAGS="$ac_save_CFLAGS"
       LIBS="$ac_save_LIBS"
     fi
  fi
  if test "x$no_libit" = x ; then
     AC_MSG_RESULT(yes)
     ifelse([$2], , :, [$2])     
  else
     AC_MSG_RESULT(no)
     if test "$LIBIT_CONFIG" = "no" ; then
       echo "*** The libit-config script installed by libit could not be found"
       echo "*** If libit was installed in PREFIX, make sure PREFIX/bin is in"
       echo "*** your path, or set the LIBIT_CONFIG environment variable to the"
       echo "*** full path to libit-config."
     else
       if test -f conf.libittest ; then
        :
       else
          echo "*** Could not run libit test program, checking why..."
          CFLAGS="$CFLAGS $LIBIT_CFLAGS"
          LIBS="$LIBS $LIBIT_LIBS"
          AC_TRY_LINK([
#include <libit.h>
#include <stdio.h>
],      [ return ((libit_major_version) || (libit_minor_version) || (libit_micro_version)); ],
        [ echo "*** The test program compiled, but did not run. This usually means"
          echo "*** that the run-time linker is not finding libit or finding the wrong"
          echo "*** version of LIBIT. If it is not finding libit, you'll need to set your"
          echo "*** LD_LIBRARY_PATH environment variable, or edit /etc/ld.so.conf to point"
          echo "*** to the installed location  Also, make sure you have run ldconfig if that"
          echo "*** is required on your system"
	  echo "***"
          echo "*** If you have an old version installed, it is best to remove it, although"
          echo "*** you may also be able to get things to work by modifying LD_LIBRARY_PATH"
          echo "***" ],
        [ echo "*** The test program failed to compile or link. See the file config.log for the"
          echo "*** exact error that occured. This usually means libit was incorrectly installed"
          echo "*** or that you have moved libit since it was installed. In the latter case, you"
          echo "*** may want to edit the libit-config script: $LIBIT_CONFIG" ])
          CFLAGS="$ac_save_CFLAGS"
          LIBS="$ac_save_LIBS"
       fi
     fi
     LIBIT_CFLAGS=""
     LIBIT_LIBS=""
     ifelse([$3], , :, [$3])
  fi

  AC_SUBST(LIBIT_CFLAGS)
  AC_SUBST(LIBIT_LIBS)
  rm -f conf.libittest
])
