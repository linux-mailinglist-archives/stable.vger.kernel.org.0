Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 455A2321D0B
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 17:34:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbhBVQdK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 11:33:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbhBVQbU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 11:31:20 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 516ADC06178C
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 08:30:03 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id v22so22715580edx.13
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 08:30:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iYFZQhpI9PWFICV4j9Dcg2L4iXOc1SnJH/pDiQOJqnU=;
        b=FTApkqpOBIB0BP8YBy7a44yeNU9F8UeIhkSaI+PnH7UEnhgfNkbHGIScuM1SUMmjEB
         RXn68yAJGjmArwGz4ludBmIoXTQoH/qS7M6/fNoxX96FooLm2LYBWppHz/eaWP6VbRep
         CQ8RDRfwr01rNdnmTtP2+Lsa+A7d2f3txug+/Q2AriMVeRXFK0mkV0yDvC8gwCh33gPg
         /uCUCQA4svfc7LKBZk47yDsGyXAqNY9+9mJ9k8S3UMnhI2vOa1XeQbIydfPMzejn3pdZ
         AjVjGMrgpMar8ekJ77xWdUDOgbPtU34a156k0xAzvp2qMuvBUkzsstB3hew7gI8YFzSU
         8KhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iYFZQhpI9PWFICV4j9Dcg2L4iXOc1SnJH/pDiQOJqnU=;
        b=NydZKE5eTpfL1VCSM5/x1RPXfor3nzQDyWtI7RoHO9d42G/ZCjayV7Ac/cCOvB/kUl
         GZADvd9naS3mSd6oIBqZ5+uZw43lTYXdDIHsc8epPyy/MAzTIK7ujmGfbb5eMkwt0vJW
         GryYRy5PCaN4CcSQI7FAorQdSi0UXod00WX8atLfzen6KQR3JBcWkhwvg3YZBEwHyV19
         KfmLz/g2przKXxRTqW8JrQBGG57BTcT0AFdNvY+jTb5BtWmc5WY/B2PvYwy98ViigO/N
         V3yaU4x8XBRdaCQtVuh9MzQcXhqmoEFrXP6/4UcTV3ubzrFpAFJIqSo2fHWKPL8cYT/n
         pbpQ==
X-Gm-Message-State: AOAM533qmoC4QS+Xe/PlW3edyqvCPi6SPTS6+qQ/pDaavZKrwJY6dlPb
        cc2zDvtCz8tfACI9BczrgfMfguE5+Z39WzpHZ1V0Yg==
X-Google-Smtp-Source: ABdhPJyjqvFdfUdvrym9hYtXMn3ZicmRz2Gyn/YWDX9lE5hsJiHhBDR8hbEC6tniszfI9M6FMcf7i+hKCoz7d1XDbI8=
X-Received: by 2002:a05:6402:26c9:: with SMTP id x9mr23507629edd.365.1614011401515;
 Mon, 22 Feb 2021 08:30:01 -0800 (PST)
MIME-Version: 1.0
References: <CA+G9fYtNOZ-G_RTq_Uedy-7wkFog2q+OWNbWd--eL+i2-OQ7NA@mail.gmail.com>
 <CA+icZUVdpyNC=e8Cdg2bXaKdQGgkY1Te-OEXE7jaKARw0KKrCw@mail.gmail.com>
In-Reply-To: <CA+icZUVdpyNC=e8Cdg2bXaKdQGgkY1Te-OEXE7jaKARw0KKrCw@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 22 Feb 2021 21:59:50 +0530
Message-ID: <CA+G9fYvGgR82mwC9Kk6fKR6Cb53u02MQJffBBZ+bTp2nNxHL7A@mail.gmail.com>
Subject: Re: clang-12: i386: Unsupported relocation type: R_386_PLT32 (4)
To:     sedat.dilek@gmail.com
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

On Mon, 22 Feb 2021 at 21:44, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
> On Mon, Feb 22, 2021 at 5:08 PM Naresh Kamboju
> <naresh.kamboju@linaro.org> wrote:
> >
> > While building i386 configs on stable-rc 5.10, stable-rc 5.11 branch
> > and mainline
> > with clang-12 these following warnings and errors were noticed.
> >
>
> Hi Naresh,
>
> Please see commit bb73d07148c405c293e576b40af37737faf23a6a
> ("x86/build: Treat R_386_PLT32 relocation as R_386_PC32").
> Recently accepted into Linus Git tree.

Can this be backported / cherry-picked into stable-rc 5.10 and stable-rc 5.11 ?

>
> [1] says:
>
> Further info for the more interested:
>
>   https://github.com/ClangBuiltLinux/linux/issues/1210
>   https://sourceware.org/bugzilla/show_bug.cgi?id=27169
>   https://github.com/llvm/llvm-project/commit/a084c0388e2a59b9556f2de0083333232da3f1d6
>
> Hope that helps.
>
> - Sedat -
>
> [1] https://git.kernel.org/linus/bb73d07148c405c293e576b40af37737faf23a6a
>
> > make --silent --keep-going --jobs=8
> > O=/home/tuxbuild/.cache/tuxmake/builds/1/tmp ARCH=i386
> > CROSS_COMPILE=i686-linux-gnu- 'HOSTCC=sccache clang' 'CC=sccache
> > clang'
> >
> > drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c:2586:9: warning: shift
> > count >= width of type [-Wshift-count-overflow]
> >
> >         return hweight64(VDBOX_MASK(&i915->gt));
> >                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > include/asm-generic/bitops/const_hweight.h:29:49: note: expanded from
> > macro 'hweight64'
> > #define hweight64(w) (__builtin_constant_p(w) ? __const_hweight64(w) :
> > __arch_hweight64(w))
> >                                                 ^~~~~~~~~~~~~~~~~~~~
> > include/asm-generic/bitops/const_hweight.h:21:76: note: expanded from
> > macro '__const_hweight64'
> > #define __const_hweight64(w) (__const_hweight32(w) +
> > __const_hweight32((w) >> 32))
> >                                                                            ^  ~~
> > include/asm-generic/bitops/const_hweight.h:20:49: note: expanded from
> > macro '__const_hweight32'
> > #define __const_hweight32(w) (__const_hweight16(w) +
> > __const_hweight16((w) >> 16))
> >                                                 ^
> > include/asm-generic/bitops/const_hweight.h:19:48: note: expanded from
> > macro '__const_hweight16'
> > #define __const_hweight16(w) (__const_hweight8(w)  +
> > __const_hweight8((w)  >> 8 ))
> >                                                ^
> > include/asm-generic/bitops/const_hweight.h:10:9: note: expanded from
> > macro '__const_hweight8'
> >          ((!!((w) & (1ULL << 0))) +     \
> >                ^
> > drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c:2586:9: warning: shift
> > count >= width of type [-Wshift-count-overflow]
> >         return hweight64(VDBOX_MASK(&i915->gt));
> >                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > <trim>
> >
> > 32 warnings generated.
> > Unsupported relocation type: R_386_PLT32 (4)
> > make[3]: *** [arch/x86/boot/compressed/Makefile:116:
> > arch/x86/boot/compressed/vmlinux.relocs] Error 1
> > make[3]: *** Deleting file 'arch/x86/boot/compressed/vmlinux.relocs'
> > make[3]: Target 'arch/x86/boot/compressed/vmlinux' not remade because of errors.
> >
> > Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> >
> > Steps to reproduce:
> > ---------------------------
> > # TuxMake is a command line tool and Python library that provides
> > # portable and repeatable Linux kernel builds across a variety of
> > # architectures, toolchains, kernel configurations, and make targets.
> > #
> > # TuxMake supports the concept of runtimes.
> > # See https://docs.tuxmake.org/runtimes/, for that to work it requires
> > # that you install podman or docker on your system.
> > #
> > # To install tuxmake on your system globally:
> > # sudo pip3 install -U tuxmake
> > #
> > # See https://docs.tuxmake.org/ for complete documentation.
> >
> > tuxmake --runtime podman --target-arch i386 --toolchain clang-12
> > --kconfig defconfig  --kconfig-add
> > https://builds.tuxbuild.com/1opxSKxZuRowPsiOsSJ0IoUOXOt/config
> >
> > --
> > Linaro LKFT
> > https://lkft.linaro.org

- Naresh
