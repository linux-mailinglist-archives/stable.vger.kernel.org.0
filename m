Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A595A422E9F
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 18:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236527AbhJERBl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 13:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235954AbhJERBj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 13:01:39 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A7F2C06174E
        for <stable@vger.kernel.org>; Tue,  5 Oct 2021 09:59:48 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id x27so89188322lfu.5
        for <stable@vger.kernel.org>; Tue, 05 Oct 2021 09:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jXMqP/PvzpvaEAzV6rgSgaNlUpBpXLXzn4drCm/j120=;
        b=pzeOxPcYFD2yrYO1liMG9xkU4OypyTsdv0fAk5If5LYIqvOKlQCKtRn+TamNHLyUEO
         XSXFDdXHX2GOiqLWYYJJSUAm6zvNlcj00zobtKoprVOM6QTwExyYg8MM1+HG+l56vwYJ
         H5mdrFJaILYL6qLUg4dhsr79C32ot4pNBCvQ+qm+51YXSZCNQXCwFpayuY226vVWuhEh
         4psdlDrKKkP6kKFazzYPPjl15S8hScTvOaI0T/uB+tm5uAnbEZbh9e4bmNFiCdmZbSGH
         8uT9K4ayWc52R/s+l2o8xwhf8D3FJoU0CwtiS4+fQ4bfdbTzpoKhHBfMTxhzp4IgxJcg
         pKSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jXMqP/PvzpvaEAzV6rgSgaNlUpBpXLXzn4drCm/j120=;
        b=AwqLvPlHBdKKVMmY1uHeYyTrvf6t2JfsPGBehaqYzJJISI0eSmar/N3TghjOfUrz/Y
         2d2FibEsVlFDXOdQtqitCgj9v/SSysoV/+6N4IRitisA6zjHJw8tFIhnfCR313X8LYsq
         EkPL0Ap/gOOIagv8YoUm1T7r7BAl3IwteiwesbzBlEQ1H91LMHsOIQyM6VQPJYf44u55
         sLGhg50kFzd6ssv94kv1Vzdt53AzJIu5tSJymY+97hm6YmlPPU96B7dZEFh0HXICSIAe
         UB8SbD54o/IHz5Q9K35XnpUPDcqlVQmznogNKHNhGO/3h0TzEgP/MsEVGgwiCctNOmPa
         HSpQ==
X-Gm-Message-State: AOAM530hvL80EO8qPa7Df5jcyy0zbuTRUFmIrs+IvYwqTpe2tI8Dbjdn
        ljcYbYXpHidmlvy9cPoB9hsZsMPKEIII0kYr9ZcWJg==
X-Google-Smtp-Source: ABdhPJyIDDf8IIbCUF9bCZ8JMNFoW8ovLSfXbT7zrUo9grDjKWZ69d/JkkwIoTh1oFpt7dP6fPE025rxZpYPVnoMvUo=
X-Received: by 2002:a2e:9b98:: with SMTP id z24mr22811110lji.339.1633453186494;
 Tue, 05 Oct 2021 09:59:46 -0700 (PDT)
MIME-Version: 1.0
References: <20211004230431.2321009-1-adelg@google.com>
In-Reply-To: <20211004230431.2321009-1-adelg@google.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 5 Oct 2021 09:59:34 -0700
Message-ID: <CAKwvOdnGrKbsfreQHQQprSTeHRaqadJtKi3N9LE+mZGgmUCf1g@mail.gmail.com>
Subject: Re: [PATCH] selftests: Remove explicit headers for clang
To:     Andrew Delgadilo <adelg@google.com>
Cc:     Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>, gthelen@google.com,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 4, 2021 at 4:04 PM Andrew Delgadilo <adelg@google.com> wrote:
>
> From: Andrew Delgadillo <adelg@google.com>
>
> GCC allows paths to header files to be passed on the command line while
> using -o, but clang does not:

Ah, it's because `-I` *insn't* being used more so than `-o` being present.

>
> $ make -C tools/testing/selftests TARGETS=futex
>
> $ make -C tools/testing/selftests TARGETS=futex LLVM=1
> clang -Wall   -g -O2 -Wall -D_GNU_SOURCE -pthread -I../include \
> -I../../ -I../../../../../usr/include/ -I/kselftest/usr/include \
> futex_wait_timeout.c ../include/futextest.h ../include/atomic.h \
> ../include/logging.h -lpthread -lrt -o \
> tools/testing/selftests/futex/functional/futex_wait_timeout
> clang: error: cannot specify -o when generating multiple output files

Why aren't `-I` flags being passed? Rather than:

$ clang ... ../include/futextest.h ../include/atomic.h ../include/logging.h ...

shouldn't this be:

$ clang ... -I ../include/futextest.h -I ../include/atomic.h -I
../include/logging.h

>
> To fix this, remove explicit paths to headers from the commandline in
> lib.mk. We must explicitly remove them for x86 and binderfs as they are
> not filtered out by the change to lib.mk, but the compiler search paths
> for includes are already setup correctly, so the compiler finds the
> correct headers.
>
> Tested: selftests build with LLVM=1 now.

With this patch applied
$ make -C tools/testing/selftests TARGETS=futex LLVM=1
WFM but
$ make -C tools/testing/selftests LLVM=1
fails, horribly. Are you always expected to pass TARGETS when building
the selftests?

> Cc: stable@vger.kernel.org
> Signed-off-by: Andrew Delgadillo <adelg@google.com>
> ---
>  tools/testing/selftests/filesystems/binderfs/Makefile | 2 +-
>  tools/testing/selftests/lib.mk                        | 2 +-
>  tools/testing/selftests/x86/Makefile                  | 4 ++--
>  3 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/tools/testing/selftests/filesystems/binderfs/Makefile b/tools/testing/selftests/filesystems/binderfs/Makefile
> index 8af25ae96049..58e41bd98200 100644
> --- a/tools/testing/selftests/filesystems/binderfs/Makefile
> +++ b/tools/testing/selftests/filesystems/binderfs/Makefile
> @@ -3,6 +3,6 @@
>  CFLAGS += -I../../../../../usr/include/ -pthread
>  TEST_GEN_PROGS := binderfs_test
>
> -binderfs_test: binderfs_test.c ../../kselftest.h ../../kselftest_harness.h
> +binderfs_test: binderfs_test.c
>
>  include ../../lib.mk
> diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
> index fa2ac0e56b43..fb152e20c86a 100644
> --- a/tools/testing/selftests/lib.mk
> +++ b/tools/testing/selftests/lib.mk
> @@ -142,7 +142,7 @@ endif
>  ifeq ($(OVERRIDE_TARGETS),)
>  LOCAL_HDRS := $(selfdir)/kselftest_harness.h $(selfdir)/kselftest.h
>  $(OUTPUT)/%:%.c $(LOCAL_HDRS)
> -       $(LINK.c) $(filter-out $(LOCAL_HDRS),$^) $(LDLIBS) -o $@
> +       $(LINK.c) $(filter-out %.h,$^) $(LDLIBS) -o $@

What? Aren't kselftest.h and kselftest_harness.h already part of
LOCAL_HDRS?  Perhaps that filter-out is broken, or LOCAL_HDRS.  Yeah,
adding some debugging:

diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index fe7ee2b0f29c..827f766d6057 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -142,6 +142,7 @@ endif
 # OVERRIDE_TARGETS = 1.
 ifeq ($(OVERRIDE_TARGETS),)
 LOCAL_HDRS := $(selfdir)/kselftest_harness.h $(selfdir)/kselftest.h
+$(info $$LOCAL_HDRS is [${LOCAL_HDRS}])
 $(OUTPUT)/%:%.c $(LOCAL_HDRS)
        $(LINK.c) $(filter-out $(LOCAL_HDRS),$^) $(LDLIBS) -o $@

prints:

$LOCAL_HDRS is [/android0/kernel-all/tools/testing/selftests/kselftest_harness.h
/android0/kernel-all/tools/testing/selftests/kselftest.h]

so of course filter-out isn't going to match `../include/futextest.h
../include/atomic.h ../include/logging.h`.

>
>  $(OUTPUT)/%.o:%.S
>         $(COMPILE.S) $^ -o $@
> diff --git a/tools/testing/selftests/x86/Makefile b/tools/testing/selftests/x86/Makefile
> index b4142cd1c5c2..68967006b3e9 100644
> --- a/tools/testing/selftests/x86/Makefile
> +++ b/tools/testing/selftests/x86/Makefile
> @@ -72,10 +72,10 @@ all_64: $(BINARIES_64)
>  EXTRA_CLEAN := $(BINARIES_32) $(BINARIES_64)
>
>  $(BINARIES_32): $(OUTPUT)/%_32: %.c helpers.h
> -       $(CC) -m32 -o $@ $(CFLAGS) $(EXTRA_CFLAGS) $^ -lrt -ldl -lm
> +       $(CC) -m32 -o $@ $(CFLAGS) $(EXTRA_CFLAGS) $(filter-out %.h,$^) -lrt -ldl -lm
>
>  $(BINARIES_64): $(OUTPUT)/%_64: %.c helpers.h
> -       $(CC) -m64 -o $@ $(CFLAGS) $(EXTRA_CFLAGS) $^ -lrt -ldl
> +       $(CC) -m64 -o $@ $(CFLAGS) $(EXTRA_CFLAGS) $(filter-out %.h,$^) -lrt -ldl
>
>  # x86_64 users should be encouraged to install 32-bit libraries
>  ifeq ($(CAN_BUILD_I386)$(CAN_BUILD_X86_64),01)
> --
> 2.33.0.800.g4c38ced690-goog
>


-- 
Thanks,
~Nick Desaulniers
