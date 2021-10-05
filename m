Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68B9442305D
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 20:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbhJESwS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 14:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbhJESwS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 14:52:18 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55405C06174E
        for <stable@vger.kernel.org>; Tue,  5 Oct 2021 11:50:27 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id x27so89499446lfa.9
        for <stable@vger.kernel.org>; Tue, 05 Oct 2021 11:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lXdezQfuCfVkENY7jnc43K9813HJFYnFN+4/R39hM/w=;
        b=q03Oj5ha0jq4IwzFMGNAXWasG6hsDXopmlEBCVyNfl06Cr57ccAVIw//C+FoVyxZkP
         wh6TPHqNpxyuOz4N/nXnIB7zf7eTkayp6sQbWDK+jf0GJZZ4cA/EsVX1+nLNZupavxnm
         dS+l+8KDcF4aL0kUpNsGIWZCjKe8mIkdE7sJoXIXT6TMAWZszrO9ozBY9S/glNN7o57g
         nsxbNYA5OFcP/o3ZCIj3vZ6vR7DW4MDWgk+ZznaFJ6qN/uXOFLYc6yqZAB8S0uYhHOCG
         nwC+xoNtOBBQzTWZsrr2ctZtjTk+HjZ+F5wTZTIzZZ51uEw9Altrb6xwkWRVMhl/7FVd
         eO0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lXdezQfuCfVkENY7jnc43K9813HJFYnFN+4/R39hM/w=;
        b=kPkg3YQVDA1vP7rhL0c9ZrW5eF+iFDn/GuppRquIa3YO2aXL/zxqMb0DJxggXvTQvr
         ajtmJJMscxqmC/unzgNI81PtLAtInTz9tysdKDl9qdFFRVhd5vgI7wDEofUYHixOd805
         hEV29OjuJx1Gjx8Xb3BZlR7pGRfQaXRthItITz5rocbdCVokMjeGnZWit7thL6vT+ykE
         1x/s/hbAk6aAuRS7L+BYQa90RcRHd7yLy6uXxjM49YBWQJeOnGkj5hUrRHZ7+d00Ot6/
         BY59FWbmXQvAgHbJATsX++hWh3ZCrMD2Dgte3uMWhLhBVDbvzu72Pid1BVfJUdURDXov
         sB/A==
X-Gm-Message-State: AOAM5304iBwZWc11eRvgS+A7O+SbhAIBYEVZgx1cg7iYZNZUNFj1XwC4
        qWUwOGK/KI4DWw1cUQb90yFnneOTo5xktIGwk15ueA==
X-Google-Smtp-Source: ABdhPJytzFo4zbb2aR2vokF6x9HkN6BJUAxhIehAY3OVqFeHzbzGHIRc0Rc+UX1hX+BArmitfvwB7L/Y6yjicKgOC4M=
X-Received: by 2002:a2e:b892:: with SMTP id r18mr24029097ljp.220.1633459825395;
 Tue, 05 Oct 2021 11:50:25 -0700 (PDT)
MIME-Version: 1.0
References: <20211004230431.2321009-1-adelg@google.com> <CAKwvOdnGrKbsfreQHQQprSTeHRaqadJtKi3N9LE+mZGgmUCf1g@mail.gmail.com>
 <CAEHm+vHNorGNxPMzrhqWhsKnQrLxfciAVmaMtgPk0E-7b0D8FA@mail.gmail.com>
In-Reply-To: <CAEHm+vHNorGNxPMzrhqWhsKnQrLxfciAVmaMtgPk0E-7b0D8FA@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 5 Oct 2021 11:50:13 -0700
Message-ID: <CAKwvOdm5vF08BmgAN9TKEmQnu8o9Nq_oDLiPztBkarWvCpp8kQ@mail.gmail.com>
Subject: Re: [PATCH] selftests: Remove explicit headers for clang
To:     Andrew Delgadillo <adelg@google.com>
Cc:     Shuah Khan <shuah@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Greg Thelen <gthelen@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 5, 2021 at 11:43 AM Andrew Delgadillo <adelg@google.com> wrote:
>
> On Tue, Oct 5, 2021 at 9:59 AM Nick Desaulniers <ndesaulniers@google.com> wrote:
> >
> > On Mon, Oct 4, 2021 at 4:04 PM Andrew Delgadilo <adelg@google.com> wrote:
> > >
> > > From: Andrew Delgadillo <adelg@google.com>
> > >
> > > GCC allows paths to header files to be passed on the command line while
> > > using -o, but clang does not:
> >
> > Ah, it's because `-I` *insn't* being used more so than `-o` being present.
> > >
> > > $ make -C tools/testing/selftests TARGETS=futex
> > >
> > > $ make -C tools/testing/selftests TARGETS=futex LLVM=1
> > > clang -Wall   -g -O2 -Wall -D_GNU_SOURCE -pthread -I../include \
> > > -I../../ -I../../../../../usr/include/ -I/kselftest/usr/include \
> > > futex_wait_timeout.c ../include/futextest.h ../include/atomic.h \
> > > ../include/logging.h -lpthread -lrt -o \
> > > tools/testing/selftests/futex/functional/futex_wait_timeout
> > > clang: error: cannot specify -o when generating multiple output files
> >
> > Why aren't `-I` flags being passed? Rather than:
> >
> > $ clang ... ../include/futextest.h ../include/atomic.h ../include/logging.h ...
> >
> > shouldn't this be:
> >
> > $ clang ... -I ../include/futextest.h -I ../include/atomic.h -I
> > ../include/logging.h
>
> Okay, I see, so the fix here wouldn't be to remove the headers from
> the commandline, we should just prepend them with `-l`.

Yes; I suspect they're added for a reason. If not for the futex tests
then perhaps others, so removing them outright may allow the futex
selftests to build, but I worry stripping them out might cause more
issues down the line for building other selftests with clang, or
regress the build with GCC support even.  But maybe not?

>
> > >
> > > To fix this, remove explicit paths to headers from the commandline in
> > > lib.mk. We must explicitly remove them for x86 and binderfs as they are
> > > not filtered out by the change to lib.mk, but the compiler search paths
> > > for includes are already setup correctly, so the compiler finds the
> > > correct headers.
> > >
> > > Tested: selftests build with LLVM=1 now.
> >
> > With this patch applied
> > $ make -C tools/testing/selftests TARGETS=futex LLVM=1
> > WFM but
> > $ make -C tools/testing/selftests LLVM=1
> > fails, horribly. Are you always expected to pass TARGETS when building
> > the selftests?
>
> I specifically passed TARGETS=futex because I want to point out a
> specific example where this is in an issue as there are other errors I
> see when I build all of selftests with LLVM=1. But to answer your
> question, no, I do not think you are expected to always pass TARGETS.
>
> When I run (without this patch)
>
> $ make -C tools/testing/selftests LLVM=1
>  I get a bunch of errors as well ranging from:
> - clang: error: cannot specify -o when generating multiple output
> files <-- the specific one I'm trying to fix
> - clang: warning: argument unused during compilation: '-pie'
> [-Wunused-command-line-argument]
> - include/x86_64/processor.h:344:25: warning: variable 'xmm7' is
> uninitialized when used here [-Wuninitialized]
>
>                 return (unsigned long)xmm7;
> - fuse_mnt.c:17:10: fatal error: 'fuse.h' file not found
>
> #include <fuse.h>
>
>          ^~~~~~~~
>
> However with the patch applied, I no longer see any "clang: error:
> cannot specify -o when generating multiple output files", meaning that
> I fixed one class of errors when building with LLVM=1.
>
> Do you see a clean build currently when building selftests with
> LLVM=1?

No.

> I'm not arguing that this patch fixes *all* the errors seen,

That was my interpretation of your `Tested` tag. Perhaps it can be reworded?

> but it at least fixes one class of them. Although, it seems I went
> about fixing it in the wrong manner. I can respin this to prepend -l
> before header includes to get rid of the "clang: error: cannot specify
> -o when generating multiple output files" errors.
>
>
>
>
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Andrew Delgadillo <adelg@google.com>
> > > ---
> > >  tools/testing/selftests/filesystems/binderfs/Makefile | 2 +-
> > >  tools/testing/selftests/lib.mk                        | 2 +-
> > >  tools/testing/selftests/x86/Makefile                  | 4 ++--
> > >  3 files changed, 4 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/tools/testing/selftests/filesystems/binderfs/Makefile b/tools/testing/selftests/filesystems/binderfs/Makefile
> > > index 8af25ae96049..58e41bd98200 100644
> > > --- a/tools/testing/selftests/filesystems/binderfs/Makefile
> > > +++ b/tools/testing/selftests/filesystems/binderfs/Makefile
> > > @@ -3,6 +3,6 @@
> > >  CFLAGS += -I../../../../../usr/include/ -pthread
> > >  TEST_GEN_PROGS := binderfs_test
> > >
> > > -binderfs_test: binderfs_test.c ../../kselftest.h ../../kselftest_harness.h
> > > +binderfs_test: binderfs_test.c
> > >
> > >  include ../../lib.mk
> > > diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
> > > index fa2ac0e56b43..fb152e20c86a 100644
> > > --- a/tools/testing/selftests/lib.mk
> > > +++ b/tools/testing/selftests/lib.mk
> > > @@ -142,7 +142,7 @@ endif
> > >  ifeq ($(OVERRIDE_TARGETS),)
> > >  LOCAL_HDRS := $(selfdir)/kselftest_harness.h $(selfdir)/kselftest.h
> > >  $(OUTPUT)/%:%.c $(LOCAL_HDRS)
> > > -       $(LINK.c) $(filter-out $(LOCAL_HDRS),$^) $(LDLIBS) -o $@
> > > +       $(LINK.c) $(filter-out %.h,$^) $(LDLIBS) -o $@
> >
> > What? Aren't kselftest.h and kselftest_harness.h already part of
> > LOCAL_HDRS?  Perhaps that filter-out is broken, or LOCAL_HDRS.  Yeah,
> > adding some debugging:
> >
> > diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
> > index fe7ee2b0f29c..827f766d6057 100644
> > --- a/tools/testing/selftests/lib.mk
> > +++ b/tools/testing/selftests/lib.mk
> > @@ -142,6 +142,7 @@ endif
> >  # OVERRIDE_TARGETS = 1.
> >  ifeq ($(OVERRIDE_TARGETS),)
> >  LOCAL_HDRS := $(selfdir)/kselftest_harness.h $(selfdir)/kselftest.h
> > +$(info $$LOCAL_HDRS is [${LOCAL_HDRS}])
> >  $(OUTPUT)/%:%.c $(LOCAL_HDRS)
> >         $(LINK.c) $(filter-out $(LOCAL_HDRS),$^) $(LDLIBS) -o $@
> >
> > prints:
> >
> > $LOCAL_HDRS is [/android0/kernel-all/tools/testing/selftests/kselftest_harness.h
> > /android0/kernel-all/tools/testing/selftests/kselftest.h]
> >
> > so of course filter-out isn't going to match `../include/futextest.h
> > ../include/atomic.h ../include/logging.h`.
>
> Like you mentioned above, it seems a better way to about this would be
> to prepend -I before the includes. I'll go ahead and send a new patch
> to do that.

SGTM.  Thanks for pursuing this! ++beers_owed;

> > >
> > >  $(OUTPUT)/%.o:%.S
> > >         $(COMPILE.S) $^ -o $@
> > > diff --git a/tools/testing/selftests/x86/Makefile b/tools/testing/selftests/x86/Makefile
> > > index b4142cd1c5c2..68967006b3e9 100644
> > > --- a/tools/testing/selftests/x86/Makefile
> > > +++ b/tools/testing/selftests/x86/Makefile
> > > @@ -72,10 +72,10 @@ all_64: $(BINARIES_64)
> > >  EXTRA_CLEAN := $(BINARIES_32) $(BINARIES_64)
> > >
> > >  $(BINARIES_32): $(OUTPUT)/%_32: %.c helpers.h
> > > -       $(CC) -m32 -o $@ $(CFLAGS) $(EXTRA_CFLAGS) $^ -lrt -ldl -lm
> > > +       $(CC) -m32 -o $@ $(CFLAGS) $(EXTRA_CFLAGS) $(filter-out %.h,$^) -lrt -ldl -lm
> > >
> > >  $(BINARIES_64): $(OUTPUT)/%_64: %.c helpers.h
> > > -       $(CC) -m64 -o $@ $(CFLAGS) $(EXTRA_CFLAGS) $^ -lrt -ldl
> > > +       $(CC) -m64 -o $@ $(CFLAGS) $(EXTRA_CFLAGS) $(filter-out %.h,$^) -lrt -ldl
> > >
> > >  # x86_64 users should be encouraged to install 32-bit libraries
> > >  ifeq ($(CAN_BUILD_I386)$(CAN_BUILD_X86_64),01)
> > > --
> > > 2.33.0.800.g4c38ced690-goog
> > >
> >
> >
> > --
> > Thanks,
> > ~Nick Desaulniers



-- 
Thanks,
~Nick Desaulniers
