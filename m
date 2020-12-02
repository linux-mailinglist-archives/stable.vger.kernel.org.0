Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0711B2CB423
	for <lists+stable@lfdr.de>; Wed,  2 Dec 2020 06:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbgLBE7R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 23:59:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgLBE7Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Dec 2020 23:59:16 -0500
Received: from mail-oo1-xc41.google.com (mail-oo1-xc41.google.com [IPv6:2607:f8b0:4864:20::c41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73518C0613CF
        for <stable@vger.kernel.org>; Tue,  1 Dec 2020 20:58:36 -0800 (PST)
Received: by mail-oo1-xc41.google.com with SMTP id h10so76084ooi.10
        for <stable@vger.kernel.org>; Tue, 01 Dec 2020 20:58:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QWSWScHcCDQ+nf3XiCuO3EwbF43AA8xuLuIZCopOA6Y=;
        b=d2YO1ZemNG3BELxBdB7W5jvqFs4Wbi7zhb943W+E+hukOOI5MPN3T8NRoMIufppimo
         xIASON5mHSNUdNb2+Tw2xbizrf1vG0esnzFICG/DW2m7wtkGY5JOzV8CEdH1JMl1LXuk
         FRoJAm2UfK5YrWn6PPDZxrrcrd0HIpxJAdwnNoqA1Js4kupMC7LaWo5uEKV9tIKeP1lY
         V9BjrWHjat85xt+3x9ByZjJyK4EWCjADs2oYRsWaGGVcc3nAGgiRzM81G1MUEbXg9E06
         S62+h6WoQ7uZ137ydfe+O+hi+xLbdsflFCfyJ6PTthtiMXxfKBB4lq5mFurOrIneq5fK
         k2Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QWSWScHcCDQ+nf3XiCuO3EwbF43AA8xuLuIZCopOA6Y=;
        b=aprM+S23xk79AXioH6I4bxlfhMvaD+uZ2GF4i0p4l+NjRdLPiNiEmA4ZDlq7KFk3K1
         01pK0Sxriw5L9kMcu7vVGEU8TPF2/7UrsyAQEaqdAZn/3VUykyyw4a5APVtWzZNvuDfJ
         3KrMgWJsKuMeWOfopMAhYzrPi9BLDxbylel0ClH42yoNrlyxHn7cr/Hi6ZB04j0aS8eR
         TTCHD4Z3aGuWvMyyYkK7c4AMi5o4Orj3hAy3BVeldN1MBOEPbC+EQ7Q/mnnMxu3ueLU7
         dm/jLHyobvV7Sy/V0+AOaz9VjMIFEneDH3klawmRKQPHcgCvlcDZf40RkAnn7KcE3Jsz
         L0cA==
X-Gm-Message-State: AOAM532zmuRS81xrHqqXs71WhYSjTcC1RLQUkEdPRzFRadWoLWCdMe4t
        3UxitP6sLDpxwEphmUcU88pPaPq7FOi/EerqvH3NBg==
X-Google-Smtp-Source: ABdhPJzqWLJAiCdsr6Wc0FF/Pql/EsJ7mI8JD2WoYCrSTszxlO6kVq9xojVggmA+IMYhcn1eljVqHKYhp1V91Mib10w=
X-Received: by 2002:a4a:9502:: with SMTP id m2mr413982ooi.93.1606885115613;
 Tue, 01 Dec 2020 20:58:35 -0800 (PST)
MIME-Version: 1.0
References: <20201201084652.827177826@linuxfoundation.org>
In-Reply-To: <20201201084652.827177826@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 2 Dec 2020 10:28:23 +0530
Message-ID: <CA+G9fYv_PwCRakrQbiXLOEsmQzKT7KWPZL3UVMDGna1xEpwQ2g@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/98] 5.4.81-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 1 Dec 2020 at 14:34, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.81 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 03 Dec 2020 08:46:29 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.81-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
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

kernel: 5.4.81-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 89a0528bfd8df49c50fda873ffb8cfeea5a2898b
git describe: v5.4.80-99-g89a0528bfd8d
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.=
y/build/v5.4.80-99-g89a0528bfd8d

No regressions (compared to build v5.4.80)

No fixes (compared to build v5.4.80)

Ran 47231 total tests in the following environments and test suites.

Environments
--------------
- arc
- arm
- arm64
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- mips
- nxp-ls2088
- parisc
- powerpc
- qemu-arm-clang
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
- riscv
- s390
- sh
- sparc
- x15
- x86
- x86-kasan

Test Suites
-----------
* build
* linux-log-parser
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
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
* ltp-mm-tests
* ltp-sched-tests
* ltp-tracing-tests
* perf
* v4l2-compliance
* ltp-commands-tests
* ltp-containers-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* network-basic-tests
* ltp-fs-tests
* ltp-open-posix-tests
* ltp-syscalls-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
