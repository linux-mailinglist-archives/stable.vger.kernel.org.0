Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24B4125B865
	for <lists+stable@lfdr.de>; Thu,  3 Sep 2020 03:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgICBqU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 21:46:20 -0400
Received: from conssluserg-05.nifty.com ([210.131.2.90]:18478 "EHLO
        conssluserg-05.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbgICBqT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Sep 2020 21:46:19 -0400
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179]) (authenticated)
        by conssluserg-05.nifty.com with ESMTP id 0831k0uB030915;
        Thu, 3 Sep 2020 10:46:00 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-05.nifty.com 0831k0uB030915
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1599097561;
        bh=1/mxdzsfMle0lQOkE8hY9bEbmZGVcwgm8MgV0/tr0lo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=1Dit0Ta59P10cBm5ONcB9bNE52YPFnTH82snltJA58p7U80ht6q4Idj7VAsRG6yNq
         ZaO0CDe7izRtA2pCX/XOXLwFMO7QmL70k5n+/whzc8q5zvfn+x6YVHk2428LmjB1IP
         NuD05pN92IVWzP7LAe4DZHRvlr+cuTysRqSia+/C5wHR/AVK1NpahWiPZRQY/64lVU
         RUNB3tZxP9cT/D9ax398Avrgfc1+uFVeRuQCKtNP5LlEG2yFp6jyumqF94PVo+aZ30
         XvY7MikFOQdwYSaHnzjIhWWsAmsL6axGSEPxoY/52NXaDh6xYD6bIMI3wPJ2Wuv5zC
         Pk2W2hZSUfGwg==
X-Nifty-SrcIP: [209.85.210.179]
Received: by mail-pf1-f179.google.com with SMTP id 17so885098pfw.9;
        Wed, 02 Sep 2020 18:46:00 -0700 (PDT)
X-Gm-Message-State: AOAM530/ARDxA5Fw5j/cSAshPHSdujYGBBWvaS9cPzx+FHZr8WavwAfb
        3BWeEHDSkmRJxawyqwsada9zYOtqjf5oKf3LkxU=
X-Google-Smtp-Source: ABdhPJwy2a9t/PYPDUGXPUjbUBDIk0jJfoIqu5vLFrzDkovOMVbb8nHIuajkB14U7OHjM8CAVZFQ0BkVvoMEtCE1mPc=
X-Received: by 2002:a63:e018:: with SMTP id e24mr693958pgh.175.1599097559845;
 Wed, 02 Sep 2020 18:45:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200820220955.3325555-1-ndesaulniers@google.com>
 <CAK7LNAQO9sKw=7RLPSnsChddrwNCc_si-XgSDQcGHTSxeq4_Pg@mail.gmail.com> <CAKwvOdnbdhkB=OG0Gec5jt5H4b4jRGPvKfgJ-JbZY+gym-u3_g@mail.gmail.com>
In-Reply-To: <CAKwvOdnbdhkB=OG0Gec5jt5H4b4jRGPvKfgJ-JbZY+gym-u3_g@mail.gmail.com>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Thu, 3 Sep 2020 10:45:23 +0900
X-Gmail-Original-Message-ID: <CAK7LNAT9KN4dBgyuXqoiFbP_Sa335DahudshJTjcK354=QpBLQ@mail.gmail.com>
Message-ID: <CAK7LNAT9KN4dBgyuXqoiFbP_Sa335DahudshJTjcK354=QpBLQ@mail.gmail.com>
Subject: Re: [PATCH] Makefile: add -fuse-ld=lld to KBUILD_HOSTLDFLAGS when LLVM=1
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     stable <stable@vger.kernel.org>,
        Matthias Maennich <maennich@google.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Stephen Hines <srhines@google.com>,
        Dan Albert <danalbert@google.com>,
        Fangrui Song <maskray@google.com>,
        Elliott Hughes <enh@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 3, 2020 at 7:40 AM Nick Desaulniers <ndesaulniers@google.com> wrote:
>
> On Fri, Aug 21, 2020 at 10:14 PM Masahiro Yamada <masahiroy@kernel.org> wrote:
> >
> > On Fri, Aug 21, 2020 at 7:10 AM 'Nick Desaulniers' via Clang Built
> > Linux <clang-built-linux@googlegroups.com> wrote:
> > >
> > > While moving Android kernels over to use LLVM=1, we observe the failure
> > > when building in a hermetic docker image:
> > >   HOSTCC  scripts/basic/fixdep
> > > clang: error: unable to execute command: Executable "ld" doesn't exist!
> > >
> > > The is because the build of the host utility fixdep builds the fixdep
> > > executable in one step by invoking the compiler as the driver, rather
> > > than individual compile then link steps.
> > >
> > > Clang when configured from source defaults to use the system's linker,
> > > and not LLVM's own LLD, unless the CMake config
> > > -DCLANG_DEFAULT_LINKER='lld' is set when configuring a build of clang
> > > itself.
> > >
> > > Don't rely on the compiler's implicit default linker; be explicit.
> >
> >
> > I do not understand this patch.
> >
> > The host compiler should be able to link executables
> > without any additional settings.
>
> Correct; there is no issue linking working executables. The issue is
> which linker is used by default or implied when -fuse-ld=* is not
> explicitly set.
>
> >
> > So, can you link a hello world program
> > in your docker?
> >
> > masahiro@zoe:~$ cat test.c
> > #include <stdio.h>
> > int main(void)
> > {
> >         printf("helloworld\n");
> >         return 0;
> > }
> > masahiro@zoe:~$ clang test.c
>
> It will fail, because:
> 1. clang will implicitly default to ld.bfd on linux hosts and ld on
> OSX hosts (idk about windows).
> 2. ld.bfd is not installed, and we *dont'* want to install it.
> Instead, we *want* to use ld.lld in a hermetic environment.
>
> > If this fails, your environment is broken.
>
> Disagree.  The environment has unique constraints (cross compiling for
> Android from OSX host, caring about builds being hermetic, etc.).
>
> > Just do  -DCLANG_DEFAULT_LINKER='lld'
> > if you know GNU ld is missing in your docker environment.
>
> I understand your point. However, I have two reasons I still think
> this patch should be upstream rather than downstream:
>
> 1. The build of clang that is distributed with Android, "AOSP LLVM"
> [0], does not and cannot yet set `-DCLANG_DEFAULT_LINKER='lld'`.  See
> the discussion in the comments of [1] where I'm trying to do that.
> The reason is that AOSP LLVM is used to build Android userspace,
> kernel, and is part of the NDK for developers to target Android from
> Windows, OSX, and Linux.  If AOSP is used to build a "host binary" on
> OSX, LLD will not work there for that quite yet.  OSX has its own
> linker that is not LLD, and LLD support for mach-o binaries is a work
> in progress.  NDK has their own timeline that's blocking that change.
>
> You might think "that's Android problem" and that we should just carry
> the patch downstream/out of tree since it is somewhat self-inflicted
> but a very important second point why I think this should be upstream:
>
> 2. clang itself (upstream of AOSP LLVM) doesn't yet default to
> -fuse-ld=lld (likely for similar reasons related to OSX).  That means
> distributions of clang-10 from your distro package manager such as
> Debian's apt won't be hermetic.  That means if you build clang from
> source, and don't configure it with -DCLANG_DEFAULT_LINKER='lld', then
> your kernel builds with LLVM=1 will not be hermetic.


I am still not convinced with this.

If you care which linker is internally used,
you can/should set -DCLANG_DEFAULT_LINKER='lld',
and that is what 'configure' exists for.



> That means we
> have to document this somewhere for other people to know or find this.
> That means I have to run around and tell all of the different Kernel
> CI folks about this compiler configuration in order to test
> hermetically.


Is it so important?
This is just host programs we are talking about.

If you really want to ensure lld is used everywhere,
you need to ask any other projects to add -fuse-ld=lld
in their build systems, but it is not realistic.

So, I tend to stick to the default
for host programs.


Your environment is _unique_, at least.

Kbuild provides a way to add extra flags to HOSTCC.

What do you think about doing this?

$ make LLVM=1 HOSTCFLAGS=-fuse-ld=lld


This is documented in Documentation/kbuild/kbuild.rst

HOSTCFLAGS
----------
Additional flags to be passed to $(HOSTCC) when building host programs.






>
> ...
>
> Or, encouraged by the zen of Python, we can just be explicit about
> what linker we want when using LLVM=1, which already signals that that
> is what we want to do.
>
> I think there are similar issues with other distros changing default
> flags of GCC (like -fstack-protector) [2].  The kernel is already
> explicit, so that differences in distro's changes to compiler defaults
> don't matter for kernel builds (except where people accidentally wipe
> out KBUILD_CFLAGS).  I'd argue my change is in the same bucket.
> Please reconsider this patch.
>
> (I should also probably add something like this for `make LD=ld.lld`
> and `make LD=ld.bfd`, regardless of compiler, since everyone supports
> `-fuse-ld=`)
> [0] https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/
> [1] https://android-review.googlesource.com/c/toolchain/llvm_android/+/1007826
> [2] https://fedoraproject.org/wiki/Changes/HardenedCompiler#Detailed_Description
> --
> Thanks,
> ~Nick Desaulniers



-- 
Best Regards
Masahiro Yamada
