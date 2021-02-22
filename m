Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60D43321D4E
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 17:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbhBVQoU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 11:44:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231286AbhBVQnx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 11:43:53 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3066AC061574;
        Mon, 22 Feb 2021 08:43:13 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id q7so13950947iob.0;
        Mon, 22 Feb 2021 08:43:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=pMONngvvuyffvAM1oBHinIVMZdGYRmB5h1Te5Fms+io=;
        b=D9OvjGSbIQ6MlsbuW5Jrno2duP1ISKNgwvSJfKgUKtKBsn8ufYY890DKWf/+t6ihp7
         gLr8QOCc1RP1K3K7Ie/sVrj5mp5Tm9Q2/M7iOdup7pNL5K8BggEM0X5k3qan7NVUnx+Z
         aW6c+1UWxjWrV7MpwoJH4Gf5JaRgEIYDvyve4eXPUlMww6hntPdN+GmilZwrd/6OwM6c
         47VUowBLKO5D54b7YVT/sStXsYpdZQO7oEiTHqD+UrM+k5eUACCq3xdCoDDkAs8veQo1
         9HIBnSN/mAb4k6vDmREha1lLTM/i7niq0vTt5rs+ikdRZ67yc0RXMXM62oOQpKJc98k+
         Zqug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=pMONngvvuyffvAM1oBHinIVMZdGYRmB5h1Te5Fms+io=;
        b=KQnvTWDWSavCxxMzcY0SuZRLAw9GB6ycH8zyw2UP+V36/MN4msWbDf4kjZsCuIOusf
         neb8Gk6cff9YqmvYeco6GUlKVZvDl2jRuXiZxu/AJDa/ujc5uaBOX6iAcFiFHU+Dxg00
         i5565EXmyfPHMeWGAhfbR5KZNvM57M5f1FIUH2xUsQghUzptVhxsKgLyeZHs38sKc/zb
         cHiBIFXgQ0mfRNAKUHcXgASGz+4xiLCCwcpEn3oAv9+AW1L0FrtTPbuhX7JVyvfgS3x6
         GzWVrOy910YjL1U872ZwcxCVHKkxe7fzJlM9E+nnJzwT0EcIVA1zTmlVGkxzmJWBcgNq
         ifJQ==
X-Gm-Message-State: AOAM532INFi/rEMX8JyY5VbCdGrDKPZkl+28nccp0WCQBSyHpWVg6Zcg
        gGRNN1LrUPDhxkhde2Q0qHVXom+dDl3KhqLZRns=
X-Google-Smtp-Source: ABdhPJwYjkYrI9wfQJklN+s81NVyPZqutO+GBFKjk5c1alTQtNZ2lwqqnVCfwqiMxuekhiifGXC4H5CTHHKxJUNDkgM=
X-Received: by 2002:a5e:c10b:: with SMTP id v11mr16261489iol.75.1614012192564;
 Mon, 22 Feb 2021 08:43:12 -0800 (PST)
MIME-Version: 1.0
References: <CA+G9fYtNOZ-G_RTq_Uedy-7wkFog2q+OWNbWd--eL+i2-OQ7NA@mail.gmail.com>
 <CA+icZUVdpyNC=e8Cdg2bXaKdQGgkY1Te-OEXE7jaKARw0KKrCw@mail.gmail.com> <CA+G9fYvGgR82mwC9Kk6fKR6Cb53u02MQJffBBZ+bTp2nNxHL7A@mail.gmail.com>
In-Reply-To: <CA+G9fYvGgR82mwC9Kk6fKR6Cb53u02MQJffBBZ+bTp2nNxHL7A@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Mon, 22 Feb 2021 17:43:07 +0100
Message-ID: <CA+icZUX6y_cPa1ev3RGbq2P8-PfthzZYJUbP3W_9du=GBLQXdA@mail.gmail.com>
Subject: Re: clang-12: i386: Unsupported relocation type: R_386_PLT32 (4)
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     clang-built-linux <clang-built-linux@googlegroups.com>,
        open list <linux-kernel@vger.kernel.org>,
        x86-ml <x86@kernel.org>, lkft-triage@lists.linaro.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fangrui Song <maskray@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 22, 2021 at 5:30 PM Naresh Kamboju
<naresh.kamboju@linaro.org> wrote:
>
> On Mon, 22 Feb 2021 at 21:44, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> >
> > On Mon, Feb 22, 2021 at 5:08 PM Naresh Kamboju
> > <naresh.kamboju@linaro.org> wrote:
> > >
> > > While building i386 configs on stable-rc 5.10, stable-rc 5.11 branch
> > > and mainline
> > > with clang-12 these following warnings and errors were noticed.
> > >
> >
> > Hi Naresh,
> >
> > Please see commit bb73d07148c405c293e576b40af37737faf23a6a
> > ("x86/build: Treat R_386_PLT32 relocation as R_386_PC32").
> > Recently accepted into Linus Git tree.
>
> Can this be backported / cherry-picked into stable-rc 5.10 and stable-rc 5.11 ?
>

I have this one in my custom patchset (even though I only build x86-64).

Makes sense to have it in Linux v5.10.y LTS and Linux v5.11.y and
maybe other linux-stable releases.

The usual way to get a fix into linux-stable is to contact Greg and
Sasha - the Linux-stable maintainers and ask for inclusion.
See "STABLE BRANCH" in MAINTAINERS.
But we have also LLVM/Clang maintainers (see [2]).
Cannot say if you address LLVM/Clang maintainers first... and they
help or what is the recommended/ideal way.

- Sedat -

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/MAINTAINERS/?h=v5.11#n16828
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/MAINTAINERS/?h=v5.11#n4306

> >
> > [1] says:
> >
> > Further info for the more interested:
> >
> >   https://github.com/ClangBuiltLinux/linux/issues/1210
> >   https://sourceware.org/bugzilla/show_bug.cgi?id=27169
> >   https://github.com/llvm/llvm-project/commit/a084c0388e2a59b9556f2de0083333232da3f1d6
> >
> > Hope that helps.
> >
> > - Sedat -
> >
> > [1] https://git.kernel.org/linus/bb73d07148c405c293e576b40af37737faf23a6a
> >
> > > make --silent --keep-going --jobs=8
> > > O=/home/tuxbuild/.cache/tuxmake/builds/1/tmp ARCH=i386
> > > CROSS_COMPILE=i686-linux-gnu- 'HOSTCC=sccache clang' 'CC=sccache
> > > clang'
> > >
> > > drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c:2586:9: warning: shift
> > > count >= width of type [-Wshift-count-overflow]
> > >
> > >         return hweight64(VDBOX_MASK(&i915->gt));
> > >                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > include/asm-generic/bitops/const_hweight.h:29:49: note: expanded from
> > > macro 'hweight64'
> > > #define hweight64(w) (__builtin_constant_p(w) ? __const_hweight64(w) :
> > > __arch_hweight64(w))
> > >                                                 ^~~~~~~~~~~~~~~~~~~~
> > > include/asm-generic/bitops/const_hweight.h:21:76: note: expanded from
> > > macro '__const_hweight64'
> > > #define __const_hweight64(w) (__const_hweight32(w) +
> > > __const_hweight32((w) >> 32))
> > >                                                                            ^  ~~
> > > include/asm-generic/bitops/const_hweight.h:20:49: note: expanded from
> > > macro '__const_hweight32'
> > > #define __const_hweight32(w) (__const_hweight16(w) +
> > > __const_hweight16((w) >> 16))
> > >                                                 ^
> > > include/asm-generic/bitops/const_hweight.h:19:48: note: expanded from
> > > macro '__const_hweight16'
> > > #define __const_hweight16(w) (__const_hweight8(w)  +
> > > __const_hweight8((w)  >> 8 ))
> > >                                                ^
> > > include/asm-generic/bitops/const_hweight.h:10:9: note: expanded from
> > > macro '__const_hweight8'
> > >          ((!!((w) & (1ULL << 0))) +     \
> > >                ^
> > > drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c:2586:9: warning: shift
> > > count >= width of type [-Wshift-count-overflow]
> > >         return hweight64(VDBOX_MASK(&i915->gt));
> > >                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > <trim>
> > >
> > > 32 warnings generated.
> > > Unsupported relocation type: R_386_PLT32 (4)
> > > make[3]: *** [arch/x86/boot/compressed/Makefile:116:
> > > arch/x86/boot/compressed/vmlinux.relocs] Error 1
> > > make[3]: *** Deleting file 'arch/x86/boot/compressed/vmlinux.relocs'
> > > make[3]: Target 'arch/x86/boot/compressed/vmlinux' not remade because of errors.
> > >
> > > Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> > >
> > > Steps to reproduce:
> > > ---------------------------
> > > # TuxMake is a command line tool and Python library that provides
> > > # portable and repeatable Linux kernel builds across a variety of
> > > # architectures, toolchains, kernel configurations, and make targets.
> > > #
> > > # TuxMake supports the concept of runtimes.
> > > # See https://docs.tuxmake.org/runtimes/, for that to work it requires
> > > # that you install podman or docker on your system.
> > > #
> > > # To install tuxmake on your system globally:
> > > # sudo pip3 install -U tuxmake
> > > #
> > > # See https://docs.tuxmake.org/ for complete documentation.
> > >
> > > tuxmake --runtime podman --target-arch i386 --toolchain clang-12
> > > --kconfig defconfig  --kconfig-add
> > > https://builds.tuxbuild.com/1opxSKxZuRowPsiOsSJ0IoUOXOt/config
> > >
> > > --
> > > Linaro LKFT
> > > https://lkft.linaro.org
>
> - Naresh
