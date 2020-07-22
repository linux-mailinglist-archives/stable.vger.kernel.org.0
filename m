Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DED5228DB5
	for <lists+stable@lfdr.de>; Wed, 22 Jul 2020 03:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731599AbgGVBnR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 21:43:17 -0400
Received: from condef-07.nifty.com ([202.248.20.72]:59097 "EHLO
        condef-07.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731589AbgGVBnQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jul 2020 21:43:16 -0400
Received: from conssluserg-05.nifty.com ([10.126.8.84])by condef-07.nifty.com with ESMTP id 06M1bYuR032230
        for <stable@vger.kernel.org>; Wed, 22 Jul 2020 10:37:34 +0900
Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com [209.85.222.43]) (authenticated)
        by conssluserg-05.nifty.com with ESMTP id 06M1b7vJ023564;
        Wed, 22 Jul 2020 10:37:08 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-05.nifty.com 06M1b7vJ023564
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1595381828;
        bh=8OlTIawxGJAnm7U5ijTKoZc7UIGiiqP4rmftbHnofNI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ZUxeHj7ZEvTdAgSmI7hz3a0KDXXy21oQcM/eK3sGrJoHajByuQ65L96gho7FWvJay
         6WcQkMFtMyYg2sCpZnQl11elEU4Kgd2nZv2uM4J1lL5GeAzMKL5AKYmmwkejt/04EO
         sPe9bCn8NYiF7SrOiD4OpU3dGMJ0HkjU0ved7PQlHduZWrh6W+VPgjPYnECspR4FO7
         DVbepuMqQtlt6XAGi0L74SAuwmybrYxnNcAlZT3fKNmDWGCLwXbvRv1Mm2b03O3sPI
         0okPuZM36daDhmbHtDjjgNWqImWw75e1y4aXKTsD8Gne8SStnV8ynnE3hgl8Xh7iW5
         Tm83DhZ/Sr0zQ==
X-Nifty-SrcIP: [209.85.222.43]
Received: by mail-ua1-f43.google.com with SMTP id i24so125881uak.3;
        Tue, 21 Jul 2020 18:37:07 -0700 (PDT)
X-Gm-Message-State: AOAM531yvKv9Ssp7rx3TnGMUEXdTRTKY4ljZ7hDQKm2kILTQ6Wd9YfQ8
        arfTnIP3re+MDW6S+2u2b9266pX2QEHAp5iNn1U=
X-Google-Smtp-Source: ABdhPJzrG1nu/j1SDWMFyU+zzXjJUVF3iCyupp7xt1xm9TaYY8jywCMdZs0lJQJFo54MyY5ejTP7fuJZ79WrpifCNrM=
X-Received: by 2002:ab0:48:: with SMTP id 66mr23303088uai.40.1595381826755;
 Tue, 21 Jul 2020 18:37:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200721173125.1273884-1-maskray@google.com> <CAK7LNARjOjr2wSD_iM6yNSZpSGEWrkZZuWKCgCqOrYcA29+LBA@mail.gmail.com>
 <20200722001424.qor3up6357jjsbia@google.com>
In-Reply-To: <20200722001424.qor3up6357jjsbia@google.com>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Wed, 22 Jul 2020 10:36:30 +0900
X-Gmail-Original-Message-ID: <CAK7LNAQtqdTi49cYL0zVWdqPV2QEsgN+2AACALumanu9L=OuGg@mail.gmail.com>
Message-ID: <CAK7LNAQtqdTi49cYL0zVWdqPV2QEsgN+2AACALumanu9L=OuGg@mail.gmail.com>
Subject: Re: [PATCH v3] Makefile: Fix GCC_TOOLCHAIN_DIR prefix for Clang cross compilation
To:     Fangrui Song <maskray@google.com>
Cc:     Michal Marek <michal.lkml@markovi.net>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Jian Cai <jiancai@google.com>,
        Bill Wendling <morbo@google.com>,
        Manoj Gupta <manojgupta@google.com>,
        stable <stable@vger.kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 22, 2020 at 9:14 AM Fangrui Song <maskray@google.com> wrote:
>
> On 2020-07-22, Masahiro Yamada wrote:
> >On Wed, Jul 22, 2020 at 2:31 AM 'Fangrui Song' via Clang Built Linux
> ><clang-built-linux@googlegroups.com> wrote:
> >>
> >> When CROSS_COMPILE is set (e.g. aarch64-linux-gnu-), if
> >> $(CROSS_COMPILE)elfedit is found at /usr/bin/aarch64-linux-gnu-elfedit,
> >> GCC_TOOLCHAIN_DIR will be set to /usr/bin/.  --prefix= will be set to
> >> /usr/bin/ and Clang as of 11 will search for both
> >> $(prefix)aarch64-linux-gnu-$needle and $(prefix)$needle.
> >>
> >> GCC searchs for $(prefix)aarch64-linux-gnu/$version/$needle,
> >> $(prefix)aarch64-linux-gnu/$needle and $(prefix)$needle. In practice,
> >> $(prefix)aarch64-linux-gnu/$needle rarely contains executables.
> >>
> >> To better model how GCC's -B/--prefix takes in effect in practice, newer
> >> Clang (since
> >> https://github.com/llvm/llvm-project/commit/3452a0d8c17f7166f479706b293caf6ac76ffd90)
> >> only searches for $(prefix)$needle. Currently it will find /usr/bin/as
> >> instead of /usr/bin/aarch64-linux-gnu-as.
> >>
> >> Set --prefix= to $(GCC_TOOLCHAIN_DIR)$(CROSS_COMPILE)
> >> (/usr/bin/aarch64-linux-gnu-) so that newer Clang can find the
> >> appropriate cross compiling GNU as (when -no-integrated-as is in
> >> effect).
> >>
> >> Cc: stable@vger.kernel.org
> >> Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> >> Signed-off-by: Fangrui Song <maskray@google.com>
> >> Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
> >> Tested-by: Nathan Chancellor <natechancellor@gmail.com>
> >> Tested-by: Nick Desaulniers <ndesaulniers@google.com>
> >> Link: https://github.com/ClangBuiltLinux/linux/issues/1099
> >> ---
> >> Changes in v2:
> >> * Updated description to add tags and the llvm-project commit link.
> >> * Fixed a typo.
> >>
> >> Changes in v3:
> >> * Add Cc: stable@vger.kernel.org
> >> ---
> >>  Makefile | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/Makefile b/Makefile
> >> index 0b5f8538bde5..3ac83e375b61 100644
> >> --- a/Makefile
> >> +++ b/Makefile
> >> @@ -567,7 +567,7 @@ ifneq ($(shell $(CC) --version 2>&1 | head -n 1 | grep clang),)
> >>  ifneq ($(CROSS_COMPILE),)
> >>  CLANG_FLAGS    += --target=$(notdir $(CROSS_COMPILE:%-=%))
> >>  GCC_TOOLCHAIN_DIR := $(dir $(shell which $(CROSS_COMPILE)elfedit))
> >> -CLANG_FLAGS    += --prefix=$(GCC_TOOLCHAIN_DIR)
> >> +CLANG_FLAGS    += --prefix=$(GCC_TOOLCHAIN_DIR)$(CROSS_COMPILE)
> >
> >
> >
> >CROSS_COMPILE may contain the directory path
> >to the cross toolchains.
> >
> >
> >For example, I use aarch64-linux-gnu-*
> >installed in
> >/home/masahiro/tools/aarch64-linaro-7.5/bin
> >
> >
> >
> >Basically, there are two ways to use it.
> >
> >[1]
> >PATH=$PATH:/home/masahiro/tools/aarch64-linaro-7.5/bin
> >CROSS_COMPILE=aarch64-linux-gnu-
> >
> >
> >[2]
> >Without setting PATH,
> >CROSS_COMPILE=~/tools/aarch64-linaro-7.5/bin/aarch64-linux-gnu-
> >
> >
> >
> >I usually do [2] (and so does intel's 0day bot).
> >
> >
> >
> >This patch works for the use-case [1]
> >but if I do [2], --prefix is set to a strange path:
> >
> >--prefix=/home/masahiro/tools/aarch64-linaro-7.5/bin//home/masahiro/tools/aarch64-linaro-7.5/bin/aarch64-linux-gnu-
>
> Thanks. I did not know the use-case [2].
> This explains why there is a `$(notdir ...)` in
> `CLANG_FLAGS     += --target=$(notdir $(CROSS_COMPILE:%-=%))`
>
>
> >
> >
> >Interestingly, the build is still successful.
> >Presumably Clang searches for more paths
> >when $(prefix)$needle is not found ?
>
> The priority order is:
>
> -B(--prefix), COMPILER_PATH, detected gcc-cross paths
>
> (In GCC, -B paths get prepended to the COMPILER_PATH list. Clang<=11 incorrectly
> adds -B to the COMPILER_PATH list. I have fixed it for 12.0.0)
>
> If -B fails, the detected gcc-cross paths may still be able to find
> /usr/bin/aarch64-linux-gnu-
>
> For example, on my machine (a variant of Debian testing), Clang finds
> $(realpath
> /usr/lib/gcc-cross/aarch64-linux-gnu/9/../../../../aarch64-linux-gnu/bin/as),
> which is /usr/bin/aarch64-linux-gnu-as
>
> >
> >I applied your patch and added -v option
> >to see which assembler was internally invoked:
> >
> > "/home/masahiro/tools/aarch64-linaro-7.5/lib/gcc/aarch64-linux-gnu/7.5.0/../../../../aarch64-linux-gnu/bin/as"
> >-EL -I ./arch/arm64/include -I ./arch/arm64/include/generated -I
> >./include -I ./arch/arm64/include/uapi -I
> >./arch/arm64/include/generated/uapi -I ./include/uapi -I
> >./include/generated/uapi -o kernel/smp.o /tmp/smp-2ec2c7.s
> >
> >
> >Ok, it looks like Clang found an alternative path
> >to the correct 'as'.
> >
> >
> >
> >
> >But, to keep the original behavior for both [1] and [2],
> >how about this?
> >
> >CLANG_FLAGS += --prefix=$(GCC_TOOLCHAIN_DIR)$(notdir $(CROSS_COMPILE))
> >
> >
> >
> >Then, I can get this:
> >
> > "/home/masahiro/tools/aarch64-linaro-7.5/bin/aarch64-linux-gnu-as"
> >-EL -I ./arch/arm64/include -I ./arch/arm64/include/generated -I
> >./include -I ./arch/arm64/include/uapi -I
> >./arch/arm64/include/generated/uapi -I ./include/uapi -I
> >./include/generated/uapi -o kernel/smp.o /tmp/smp-16d76f.s
>
> This looks good.
>
> Agreed that `--prefix=$(GCC_TOOLCHAIN_DIR)$(notdir $(CROSS_COMPILE))` should work for both [1] and [2].
>
> Shall I send a v4? Or you are kind enough that you'll just add your Signed-off-by: tag
> and fix that for me? :)
>

I fixed it up and applied to linux-kbuild/fixes.
Thanks.




While I am here, could you teach me a bit more?


The top Makefile sets the following option as well:

CLANG_GCC_TC    := --gcc-toolchain=$(GCC_TOOLCHAIN)



I checked the manual:
https://clang.llvm.org/docs/ClangCommandLineReference.html


  -B<dir>, --prefix <arg>, --prefix=<arg>
  Add <dir> to search path for binaries and object files used implicitly

  --gcc-toolchain=<arg>, -gcc-toolchain <arg>
  Use the gcc toolchain at the given directory




It is not clear to me
how they work differently when
clang searches for toolchains.




If I delete --gcc-toolchain from the top Makefile,
clang fails to link standalone programs
because it wrongly invokes /usr/bin/ld
instead of aarch64-linux-gnu-ld.


Does Clang search for gnu assembler
based on --prefix option?

And, searches for a linker
based on --gcc-toolchain ?



-- 
Best Regards
Masahiro Yamada
