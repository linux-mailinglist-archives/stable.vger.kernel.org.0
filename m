Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C76CB37D207
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234497AbhELSEk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239939AbhELRZn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 13:25:43 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E206C06138B
        for <stable@vger.kernel.org>; Wed, 12 May 2021 10:23:17 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id t15so306505edr.11
        for <stable@vger.kernel.org>; Wed, 12 May 2021 10:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oyKCugOHrF3iiwRI1CT/wN4ttg5vDvJaE34/Sl3BUss=;
        b=dZ2P6Nf8zI09crYT0Q9zg80xELxLlJV9Q8BBOVL1kOXS6EVivIw3xHH+SwEiSkF/z5
         TyzYPCaK+P5B4DKytLs2THnS1Kxbt2rH+11yJ8fPkbXFG8uLm/2XYXD9Q6J+j8fGANxm
         tEsjVGBa5zl5072hFmmzEVC1Wl5vHOuNtYzEIVsN9qxrXd6n2EGMcJJMu5ZewJi/RPga
         Hj83F/mMMmfDJsa6k+5eQq1Ubqflf219wyHJqB68J+Z/RpyQKKTC1Y/4K8Gsw4U6nMdY
         Z5bxByxLUqzOEEiypReff8QxFKUujGrhV6vPRTjCKbjTvZmaz2SXVhCvCU0lx5dfN5gJ
         /Osg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oyKCugOHrF3iiwRI1CT/wN4ttg5vDvJaE34/Sl3BUss=;
        b=hlEwb78LNCP9METf02zOmaHyMdI0JH/teqCqH0JIL/4lG26kgbMMI4OHEmMU4Ilxrw
         MBsFkZo/ZzAZiB6koX467gvloVf+z1+KpFQ0MpF+GzDmJeLGPT09OKb4Arm3PM9YLG5i
         ngNJ6Q8yNb3cliBUcWRMeTGPbXGmQkQ+pPvw7YTN+Iu6pNyw8loSO3ETSN5QwURsFJlr
         QSwxZKYAREKWVoBmzVPrpSwT7DS+Kui/3CCrSKyvNX5nXvnKl1Q45xFmelq79vFHH7Dy
         7lsu8FeEof3IdfseQJ7qxMwEzL5ClrxTokiiF8+IX8//LnHkiWZDrH3VfmD9n7xHs9wF
         yPhA==
X-Gm-Message-State: AOAM530DbjYYxuVbZT/4jIPRiBaihukbdUhidjvZAafISAhDuNfPq4S3
        mvYR1TezOeRhRVj+eLZqDGOZFM8QN3fB7uSiCi4ymQ==
X-Google-Smtp-Source: ABdhPJx9dtHw4yIQzA4Rjc857bcPUhAz0JGfW+d3zkOljlTonr+OVpudbnfDWa0BXv6JHsRYANBAi/d+vE0E3pcgl7E=
X-Received: by 2002:aa7:c6ca:: with SMTP id b10mr29676518eds.221.1620840195559;
 Wed, 12 May 2021 10:23:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210512144837.204217980@linuxfoundation.org>
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 12 May 2021 22:53:04 +0530
Message-ID: <CA+G9fYufHvM+C=39gtk5CF-r4sYYpRkQFGsmKrkdQcXj_XKFag@mail.gmail.com>
Subject: Re: [PATCH 5.12 000/677] 5.12.4-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Huacai Chen <chenhuacai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 12 May 2021 at 21:27, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.12.4 release.
> There are 677 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 14 May 2021 14:47:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.4-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


MIPS Clang build regression detected.
MIPS gcc-10,9 and 8 build PASS.

> Maciej W. Rozycki <macro@orcam.me.uk>
>     MIPS: Reinstate platform `__div64_32' handler

mips clang build breaks on stable rc 5.4 .. 5.12 due to below warnings / errors
 - mips (defconfig) with clang-12
 - mips (tinyconfig) with clang-12
 - mips (allnoconfig) with clang-12

make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=mips
CROSS_COMPILE=mips-linux-gnu- 'HOSTCC=sccache clang' 'CC=sccache
clang'
kernel/time/hrtimer.c:318:2: error: couldn't allocate output register
for constraint 'x'
        do_div(tmp, (u32) div);
        ^
include/asm-generic/div64.h:243:11: note: expanded from macro 'do_div'
                __rem = __div64_32(&(n), __base);       \
                        ^
arch/mips/include/asm/div64.h:74:11: note: expanded from macro '__div64_32'
                __asm__("divu   $0, %z1, %z2"                           \
                        ^
1 error generated.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

steps to reproduce:
--------------------------
#!/bin/sh

# TuxMake is a command line tool and Python library that provides
# portable and repeatable Linux kernel builds across a variety of
# architectures, toolchains, kernel configurations, and make targets.
#
# TuxMake supports the concept of runtimes.
# See https://docs.tuxmake.org/runtimes/, for that to work it requires
# that you install podman or docker on your system.
#
# To install tuxmake on your system globally:
# sudo pip3 install -U tuxmake
#
# See https://docs.tuxmake.org/ for complete documentation.

tuxmake --runtime podman --target-arch mips --toolchain clang-12
--kconfig defconfig

build ref:
https://builds.tuxbuild.com/1sRW8pJDUO08LLScNJnPlFqm8lV/

--
Linaro LKFT
https://lkft.linaro.org
