Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 060AA423033
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 20:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235080AbhJESpM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 14:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235015AbhJESpL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 14:45:11 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89457C061753
        for <stable@vger.kernel.org>; Tue,  5 Oct 2021 11:43:20 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id 138so2554560qko.10
        for <stable@vger.kernel.org>; Tue, 05 Oct 2021 11:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SXjHDPHVkAfuTdG94OroOzGod0/baVo6NNkVzktujtw=;
        b=jxfUmTlMonkGB7Nwi3dCLGX7gsHGgpk3O04BG//JtP6g8bmsXyL4EStJ/8PDxuks6f
         LGTytYFjER09fkFMQCgS26wAfioUz5LQqJ4fMdG5sAkjyQI2pUaVha5s2T2Hzk8ZOsgn
         x2J4AfhkYlNjvoP8KE7cdkQ7xwQur+jp+jrLzpU1l74unsujJMJqy/q5wyjqnyIVc2ka
         59nuLeMuDQciWH6kpJE7R522BwfzjXAe0VdpxB/tkAkPUsG3FvU0s6coCDqga0rbCGVv
         PZ/1iBqqmVmSNHGWD4F699F3lAoSlB+BoV5/7QTC44dfUlN6KVTaXQ6pberrLV07QK6O
         HMIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SXjHDPHVkAfuTdG94OroOzGod0/baVo6NNkVzktujtw=;
        b=GQaZCJGiXr+17mVzG1B57buFcpL/TfSTQPmut9hc8naJtb3P7TH/6Olt9f8gFAGVFg
         KHykgmC3Rv/VHhg486Rj3tpN+TPrST8ApAztTQ7RiyIIHeplc86WP0MOb4o6t3s1FTKp
         9xjoQzP090GpbTszfQObh3nZ7klfjMa7RdCb9n+JPv73K/MgIzQkTHWVRdvdpLlvwG92
         PJG6iA2uHkB3xypBIdd6/3kp8l8TH4KT2hOpqfo02xex3tnUWRR3aiXFgtn1CEFgNOfA
         WxRBV75269z8FF6w15o70vv1MyaxKBa5Ai7HJkS8Bj4NYVI53kKqWxBSHWlKnrb63lAo
         QYqA==
X-Gm-Message-State: AOAM532WEhp2+ZqDLjS0QWb3LRazweml2jvaSqEv4PB903i9KGJ7Xv+o
        oFuqKWfRk3dLG2jURUKIC6UTsB65FfHu4O4TRaR8sQ==
X-Google-Smtp-Source: ABdhPJyxniKf1EdWzW8rx6eXVPi7baRIZaKvVG30qwSlIIPgF3tKXIdAlrFKTmm+mPQHEPW614IgcC36G+UBit/GTxU=
X-Received: by 2002:a37:8883:: with SMTP id k125mr15639166qkd.458.1633459399337;
 Tue, 05 Oct 2021 11:43:19 -0700 (PDT)
MIME-Version: 1.0
References: <20211004230431.2321009-1-adelg@google.com> <CAKwvOdnGrKbsfreQHQQprSTeHRaqadJtKi3N9LE+mZGgmUCf1g@mail.gmail.com>
In-Reply-To: <CAKwvOdnGrKbsfreQHQQprSTeHRaqadJtKi3N9LE+mZGgmUCf1g@mail.gmail.com>
From:   Andrew Delgadillo <adelg@google.com>
Date:   Tue, 5 Oct 2021 11:43:08 -0700
Message-ID: <CAEHm+vHNorGNxPMzrhqWhsKnQrLxfciAVmaMtgPk0E-7b0D8FA@mail.gmail.com>
Subject: Re: [PATCH] selftests: Remove explicit headers for clang
To:     Nick Desaulniers <ndesaulniers@google.com>
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

On Tue, Oct 5, 2021 at 9:59 AM Nick Desaulniers <ndesaulniers@google.com> wrote:
>
> On Mon, Oct 4, 2021 at 4:04 PM Andrew Delgadilo <adelg@google.com> wrote:
> >
> > From: Andrew Delgadillo <adelg@google.com>
> >
> > GCC allows paths to header files to be passed on the command line while
> > using -o, but clang does not:
>
> Ah, it's because `-I` *insn't* being used more so than `-o` being present.
> >
> > $ make -C tools/testing/selftests TARGETS=futex
> >
> > $ make -C tools/testing/selftests TARGETS=futex LLVM=1
> > clang -Wall   -g -O2 -Wall -D_GNU_SOURCE -pthread -I../include \
> > -I../../ -I../../../../../usr/include/ -I/kselftest/usr/include \
> > futex_wait_timeout.c ../include/futextest.h ../include/atomic.h \
> > ../include/logging.h -lpthread -lrt -o \
> > tools/testing/selftests/futex/functional/futex_wait_timeout
> > clang: error: cannot specify -o when generating multiple output files
>
> Why aren't `-I` flags being passed? Rather than:
>
> $ clang ... ../include/futextest.h ../include/atomic.h ../include/logging.h ...
>
> shouldn't this be:
>
> $ clang ... -I ../include/futextest.h -I ../include/atomic.h -I
> ../include/logging.h

Okay, I see, so the fix here wouldn't be to remove the headers from
the commandline, we should just prepend them with `-l`.

> >
> > To fix this, remove explicit paths to headers from the commandline in
> > lib.mk. We must explicitly remove them for x86 and binderfs as they are
> > not filtered out by the change to lib.mk, but the compiler search paths
> > for includes are already setup correctly, so the compiler finds the
> > correct headers.
> >
> > Tested: selftests build with LLVM=1 now.
>
> With this patch applied
> $ make -C tools/testing/selftests TARGETS=futex LLVM=1
> WFM but
> $ make -C tools/testing/selftests LLVM=1
> fails, horribly. Are you always expected to pass TARGETS when building
> the selftests?

I specifically passed TARGETS=futex because I want to point out a
specific example where this is in an issue as there are other errors I
see when I build all of selftests with LLVM=1. But to answer your
question, no, I do not think you are expected to always pass TARGETS.

When I run (without this patch)

$ make -C tools/testing/selftests LLVM=1
 I get a bunch of errors as well ranging from:
- clang: error: cannot specify -o when generating multiple output
files <-- the specific one I'm trying to fix
- clang: warning: argument unused during compilation: '-pie'
[-Wunused-command-line-argument]
- include/x86_64/processor.h:344:25: warning: variable 'xmm7' is
uninitialized when used here [-Wuninitialized]

                return (unsigned long)xmm7;
- fuse_mnt.c:17:10: fatal error: 'fuse.h' file not found

#include <fuse.h>

         ^~~~~~~~

However with the patch applied, I no longer see any "clang: error:
cannot specify -o when generating multiple output files", meaning that
I fixed one class of errors when building with LLVM=1.

Do you see a clean build currently when building selftests with
LLVM=1? I'm not arguing that this patch fixes *all* the errors seen,
but it at least fixes one class of them. Although, it seems I went
about fixing it in the wrong manner. I can respin this to prepend -l
before header includes to get rid of the "clang: error: cannot specify
-o when generating multiple output files" errors.




> > Cc: stable@vger.kernel.org
> > Signed-off-by: Andrew Delgadillo <adelg@google.com>
> > ---
> >  tools/testing/selftests/filesystems/binderfs/Makefile | 2 +-
> >  tools/testing/selftests/lib.mk                        | 2 +-
> >  tools/testing/selftests/x86/Makefile                  | 4 ++--
> >  3 files changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/tools/testing/selftests/filesystems/binderfs/Makefile b/tools/testing/selftests/filesystems/binderfs/Makefile
> > index 8af25ae96049..58e41bd98200 100644
> > --- a/tools/testing/selftests/filesystems/binderfs/Makefile
> > +++ b/tools/testing/selftests/filesystems/binderfs/Makefile
> > @@ -3,6 +3,6 @@
> >  CFLAGS += -I../../../../../usr/include/ -pthread
> >  TEST_GEN_PROGS := binderfs_test
> >
> > -binderfs_test: binderfs_test.c ../../kselftest.h ../../kselftest_harness.h
> > +binderfs_test: binderfs_test.c
> >
> >  include ../../lib.mk
> > diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
> > index fa2ac0e56b43..fb152e20c86a 100644
> > --- a/tools/testing/selftests/lib.mk
> > +++ b/tools/testing/selftests/lib.mk
> > @@ -142,7 +142,7 @@ endif
> >  ifeq ($(OVERRIDE_TARGETS),)
> >  LOCAL_HDRS := $(selfdir)/kselftest_harness.h $(selfdir)/kselftest.h
> >  $(OUTPUT)/%:%.c $(LOCAL_HDRS)
> > -       $(LINK.c) $(filter-out $(LOCAL_HDRS),$^) $(LDLIBS) -o $@
> > +       $(LINK.c) $(filter-out %.h,$^) $(LDLIBS) -o $@
>
> What? Aren't kselftest.h and kselftest_harness.h already part of
> LOCAL_HDRS?  Perhaps that filter-out is broken, or LOCAL_HDRS.  Yeah,
> adding some debugging:
>
> diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
> index fe7ee2b0f29c..827f766d6057 100644
> --- a/tools/testing/selftests/lib.mk
> +++ b/tools/testing/selftests/lib.mk
> @@ -142,6 +142,7 @@ endif
>  # OVERRIDE_TARGETS = 1.
>  ifeq ($(OVERRIDE_TARGETS),)
>  LOCAL_HDRS := $(selfdir)/kselftest_harness.h $(selfdir)/kselftest.h
> +$(info $$LOCAL_HDRS is [${LOCAL_HDRS}])
>  $(OUTPUT)/%:%.c $(LOCAL_HDRS)
>         $(LINK.c) $(filter-out $(LOCAL_HDRS),$^) $(LDLIBS) -o $@
>
> prints:
>
> $LOCAL_HDRS is [/android0/kernel-all/tools/testing/selftests/kselftest_harness.h
> /android0/kernel-all/tools/testing/selftests/kselftest.h]
>
> so of course filter-out isn't going to match `../include/futextest.h
> ../include/atomic.h ../include/logging.h`.

Like you mentioned above, it seems a better way to about this would be
to prepend -I before the includes. I'll go ahead and send a new patch
to do that.
> >
> >  $(OUTPUT)/%.o:%.S
> >         $(COMPILE.S) $^ -o $@
> > diff --git a/tools/testing/selftests/x86/Makefile b/tools/testing/selftests/x86/Makefile
> > index b4142cd1c5c2..68967006b3e9 100644
> > --- a/tools/testing/selftests/x86/Makefile
> > +++ b/tools/testing/selftests/x86/Makefile
> > @@ -72,10 +72,10 @@ all_64: $(BINARIES_64)
> >  EXTRA_CLEAN := $(BINARIES_32) $(BINARIES_64)
> >
> >  $(BINARIES_32): $(OUTPUT)/%_32: %.c helpers.h
> > -       $(CC) -m32 -o $@ $(CFLAGS) $(EXTRA_CFLAGS) $^ -lrt -ldl -lm
> > +       $(CC) -m32 -o $@ $(CFLAGS) $(EXTRA_CFLAGS) $(filter-out %.h,$^) -lrt -ldl -lm
> >
> >  $(BINARIES_64): $(OUTPUT)/%_64: %.c helpers.h
> > -       $(CC) -m64 -o $@ $(CFLAGS) $(EXTRA_CFLAGS) $^ -lrt -ldl
> > +       $(CC) -m64 -o $@ $(CFLAGS) $(EXTRA_CFLAGS) $(filter-out %.h,$^) -lrt -ldl
> >
> >  # x86_64 users should be encouraged to install 32-bit libraries
> >  ifeq ($(CAN_BUILD_I386)$(CAN_BUILD_X86_64),01)
> > --
> > 2.33.0.800.g4c38ced690-goog
> >
>
>
> --
> Thanks,
> ~Nick Desaulniers
