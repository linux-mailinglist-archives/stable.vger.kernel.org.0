Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 387BB344716
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 15:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbhCVO0U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 10:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbhCVO0P (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 10:26:15 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E2FC061756
        for <stable@vger.kernel.org>; Mon, 22 Mar 2021 07:26:14 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id b7so21628071ejv.1
        for <stable@vger.kernel.org>; Mon, 22 Mar 2021 07:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nhFTEJ97t4uaq57HZ+2T9emmpOecmmq8jUt4j7pWlIg=;
        b=h8R4hxc9jbBc9nmJwIDtGZj6aylge4zH5pGALJLN4zw4Zx7Id8fsAlXKpxZJovgnFc
         ej203faRNDG6hiV7do5vKjYxP7myY1Wqi0W3GOB5uGXpxn8BETHSjT5+hqVnwZ8oE5GX
         9UV9hAvryZ4woW/bt3e03uI2NCbEXJ+CTNKA3R1dMF24Ff+Mg+m12pAXIZQg9QqkGR9d
         NtyUaHv8Ba3DDK+5Et1naqbdZr0/4IljzJZYzmXv5HNj80mQcB8Y8VrF0rg6XwdRKHO7
         VcTsa9vHrNxQMUofybJjy+DPzp2aWMNgrluIlWAvgiy/QYRPJb7QKG1i/Z4rjZCTYxrG
         Q00A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nhFTEJ97t4uaq57HZ+2T9emmpOecmmq8jUt4j7pWlIg=;
        b=tFdpQDUOa1CbDoKfljL1IjvEth1ha90EboD7OMPEga5KSOlIQ4VSZr/fyl6oIN0Wl4
         f3eXggJJWtzVFZwM851zdK/pQrg8fv70PkD0MM67d+GcEju0xK9EZJS3TT89ulFnmDOh
         QXzabNl8a9fc7CmenRkUEivvimn8/v/8cvaqa7WwFmUGml+zcLw/crGxh6PCsyUIbF6w
         5ItZb0hlWlhTVuHrov7Kj2A7FJmfX2u/+TI6SCU5I2TBHHxx4eiz/KJdzT8443U9QM5L
         Zr1/KmGsz8uEOeej0DVEYr/3Cvi0H/SdyQ+tPDTZtRCSuysCzCozK7D8235Y2hmm56h5
         XLjQ==
X-Gm-Message-State: AOAM530PzjIQi/xvAJ4WRGcgRGvOg1K3HI5T/L5MS+jGPO64kUJ8ZjUv
        5Qx6sd45kqkP1HVEK34vorSneqxzcxT0GEDS3/51zQ==
X-Google-Smtp-Source: ABdhPJwhqB8I9DqooyHXQCjASg9A5jvHQ0g111pn9J5d6vH93Qna+bGAfuIcEOMS5ZctBfUeNdhmocfEmOtvOWbBywc=
X-Received: by 2002:a17:906:70d:: with SMTP id y13mr25755ejb.170.1616423172607;
 Mon, 22 Mar 2021 07:26:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210322121933.746237845@linuxfoundation.org>
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 22 Mar 2021 19:56:01 +0530
Message-ID: <CA+G9fYtK9effpD=wRmiJWmiE9iphE9NVxPw=W9dxV=OTSduR4w@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/157] 5.10.26-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 22 Mar 2021 at 18:08, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.26 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 24 Mar 2021 12:19:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.26-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

mipc tinyconfig and allnoconfig builds failed on stable-rc 5.10 branch

make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/1/tmp ARCH=mips
CROSS_COMPILE=mips-linux-gnu- 'CC=sccache mips-linux-gnu-gcc'
'HOSTCC=sccache gcc'
WARNING: modpost: vmlinux.o(.text+0x6a88): Section mismatch in
reference from the function reserve_exception_space() to the function
.meminit.text:memblock_reserve()
The function reserve_exception_space() references
the function __meminit memblock_reserve().
This is often because reserve_exception_space lacks a __meminit
annotation or the annotation of memblock_reserve is wrong.

FATAL: modpost: Section mismatches detected.
Set CONFIG_SECTION_MISMATCH_WARN_ONLY=y to allow them.
make[2]: *** [/builds/linux/scripts/Makefile.modpost:59:
vmlinux.symvers] Error 1

Here is the list of build failed,
 - gcc-8-allnoconfig
 - gcc-8-tinyconfig
 - gcc-9-allnoconfig
 - gcc-9-tinyconfig
 - gcc-10-allnoconfig
 - gcc-10-tinyconfig
 - clang-10-tinyconfig
 - clang-10-allnoconfig
 - clang-11-allnoconfig
 - clang-11-tinyconfig
 - clang-12-tinyconfig
 - clang-12-allnoconfig

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

link:
https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/1117167411#L142

steps to reproduce:
---------------------------
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


tuxmake --runtime podman --target-arch mips --toolchain gcc-10
--kconfig tinyconfig


--
Linaro LKFT
https://lkft.linaro.org
