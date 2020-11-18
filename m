Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A56E2B77C1
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 09:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727244AbgKRH6H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 02:58:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727241AbgKRH6H (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Nov 2020 02:58:07 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED673C061A4D
        for <stable@vger.kernel.org>; Tue, 17 Nov 2020 23:58:06 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id ay21so989906edb.2
        for <stable@vger.kernel.org>; Tue, 17 Nov 2020 23:58:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=50/FF29WsDwR5/RG+05kKUZBR7OcboOye2gIPXSPEgc=;
        b=aOXl/RzAd0O5oVpR/gWsu2rcGApSOJOUN7A+147nL5JHLy7AUBvKU+n9Zp65lxapd1
         8gE25zr98eGSupFqddCxc+IHSeEbIpsxs1+Fq2N0VKQWDxbDMZO8qEf/rcEaeAPMSGaG
         UKcbylxi8juhRtxh+JDMokMhxxgA6JILDTazQ2dKTTjhwnmwXDOjgpCUY2fbJLCORbUa
         XU2PC8WfIWM0JSIhHQq1FBYs9fN/v0NJnHgIHd/HXW2JbNcKpKYtbbFUJHMod9Mq4mo/
         Taz+LzphQspq+cyG6dpOFMvyMs0bAaEf7KlGXJMPvetUPlNy3wOwMiHxAA51A/SgxV8c
         /0VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=50/FF29WsDwR5/RG+05kKUZBR7OcboOye2gIPXSPEgc=;
        b=fAChvxEfUCOnoWxPiZTj5ERz50ZCb+4TPQUhH02fJOpfJv/1Yz/4kqqLR1QKaAjGS0
         6zNPnsmWdge63Zo1KcoqqHWqz6EQEr04hPuGvnQ+SOBXaxyv4hhaFC6EDOhEAloF0ibg
         LVs44NSD9drdNkUHkNxmh00pKd1Pclkmn2tpbEjmX1XVogo0VUzHlnA9g9tYvT7LF7Fk
         ohdOlA9bLSM6+7YjbP1gNKCv0Z9r+yGgCV/buIIn0Idv7SdZZzMpEj//Lg0UwdjsAoRS
         98/mf2wdiYUFR454QhPL8JfOv6tK7KjVCZ/FcIHMWyhPaZVpGb+b5tlNIDyqCB/SDBRT
         xibQ==
X-Gm-Message-State: AOAM5304H9L/VXSuGsVHuN3muqnP1/4JPqfgu4kabUaOhwquo/s6/6v6
        w+V1143qV/v6EA3tk5uMxFiK9rMsj29JhOmr5KcXTg==
X-Google-Smtp-Source: ABdhPJxn+dVsOOTyn/S8VRLx909iKLZpEz06uL98sOV7q47tpfm6LyHBSrqD950XGRNtEAM93MtKLr50G0okKkStJHw=
X-Received: by 2002:aa7:df81:: with SMTP id b1mr24035894edy.365.1605686285400;
 Tue, 17 Nov 2020 23:58:05 -0800 (PST)
MIME-Version: 1.0
References: <20201117122113.128215851@linuxfoundation.org>
In-Reply-To: <20201117122113.128215851@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 18 Nov 2020 13:27:53 +0530
Message-ID: <CA+G9fYugEFjs4PqwqvKjwdO1QZ5bjKuLMm==G6PX-HfZZ7jEeg@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/101] 4.19.158-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        linux-stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 17 Nov 2020 at 18:48, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.158 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Nov 2020 12:20:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.158-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 4.19.158-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 1d674327c1b7a5243fc8f01e52e226736f6f987f
git describe: v4.19.157-102-g1d674327c1b7
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19=
.y/build/v4.19.157-102-g1d674327c1b7

No regressions (compared to build v4.19.157)

No fixes (compared to build v4.19.157)

Ran 46869 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- nxp-ls2088
- qemu-arm64-clang
- qemu-arm64-kasan
- qemu-x86_64-clang
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* libhugetlbfs
* linux-log-parser
* ltp-commands-tests
* ltp-controllers-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* v4l2-compliance
* ltp-cap_bounds-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-fs-tests
* network-basic-tests
* perf
* ltp-open-posix-tests
* kvm-unit-tests
* ltp-tracing-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
