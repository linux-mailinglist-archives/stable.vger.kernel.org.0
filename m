Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0A0D2F2891
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 07:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388257AbhALGwc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 01:52:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387836AbhALGwc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jan 2021 01:52:32 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25988C061575
        for <stable@vger.kernel.org>; Mon, 11 Jan 2021 22:51:52 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id jx16so1915843ejb.10
        for <stable@vger.kernel.org>; Mon, 11 Jan 2021 22:51:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=z+c5bYfh/67BCaPtpPIY8Cp/tFxWK5rm6TOabXYygI0=;
        b=SbkHmgYnaFO0Da1UpFnG8FstJZZuXcINBwxlKLxwNwlCPNt72aXP6yzJM62GIgsSZ1
         FAFnsnn7qCXJGfdRXe/5F+letv0dBLCy+WWaGtFfS/ZzdKpCeqt/UNdACIkR6luQap4D
         gPUz5lJH1Gr/efDVOAQsthPRGIjxp1egAXo2eBd41FKjliAAjx4kI5k2kY4t4vPfBkT/
         +DmdCyXsDNkV0XutiG0x2DfrBM/M6ZMMf/a4DsNBn4YDNk4QEzvAx4q8g5DKdk2utIFm
         NLtIhvtC0mgNSSUOeyFcxsAPohAoxrI1g/jFXEjUZGnrkyIDY7fjjNjf8m3gup128bO9
         BWog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=z+c5bYfh/67BCaPtpPIY8Cp/tFxWK5rm6TOabXYygI0=;
        b=PZWAI+9ZZhSgm6EJFpUC8V7Cc6VJDEMrlKCx4AW46i6yLWHroEKxUPI1Gvadrc84nX
         pbfrTtUO4FAEwHaJaXrdfW9bAs6XFH/4l8u/TORN16fycy+NUVY0O2bdc9sLJE0p0iiK
         oMdfzb4iHLNzF9b7Ky5j1wpcyat2E+OwT/s3gzoFEGv5vYgJkqPcD2Fy/5DLoqJUEe7s
         v+JZTWxMgFr5gP8r8BkJkGcAkJV5XcAvshjx2QtSkvVFRly2e1dxTbGju776HVX7D9C3
         6kFz0Q78vebVE71i9F4s38eTLbtMj/h5KeFrX5Z+bCTCYFxZ3LTSI4CJFGFkswwGYTtK
         C1IQ==
X-Gm-Message-State: AOAM532Mng1EPfxhO8tIsH+yMlloic0m2a4gjluWRyn1HvGpMVVF9QY3
        9reeJf8QpYdseOFBV862zSihgRswRwpkL1qwzjfMuTlt+HtIlFWC
X-Google-Smtp-Source: ABdhPJyrT2OM1dghokFc/SpNR1HOfB57rndheYACgmEIIMJ7zu/RgxJANbau3/Qr7Idf16ieu0HKUYiK0DAs20usWSs=
X-Received: by 2002:a17:906:2695:: with SMTP id t21mr2283824ejc.287.1610434310650;
 Mon, 11 Jan 2021 22:51:50 -0800 (PST)
MIME-Version: 1.0
References: <20210111161510.602817176@linuxfoundation.org>
In-Reply-To: <20210111161510.602817176@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 12 Jan 2021 12:21:39 +0530
Message-ID: <CA+G9fYsYyW+eC3oBJeV+cT6WSuagxwo2qFjdzF7YbXinumJxEA@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/144] 5.10.7-rc2 review
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

On Mon, 11 Jan 2021 at 21:44, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.7 release.
> There are 144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 13 Jan 2021 16:14:43 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.7-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
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

kernel: 5.10.7-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.10.y
git commit: 0ea94a3ff7f854eb84150ee1f9d6a111d978c0ec
git describe: v5.10.6-145-g0ea94a3ff7f8
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10=
.y/build/v5.10.6-145-g0ea94a3ff7f8

No regressions (compared to build v5.10.6)

No fixes (compared to build v5.10.6)

Ran 60294 total tests in the following environments and test suites.

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
- qemu-i386-clang
- qemu-x86_64-clang
- qemu-x86_64-kasan
- qemu-x86_64-kcsan
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
* install-android-platform-tools-r2600
* ltp-commands-tests
* ltp-containers-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* fwts
* kselftest
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-ipc-tests
* ltp-sched-tests
* ltp-tracing-tests
* network-basic-tests
* perf
* ltp-controllers-tests
* ltp-open-posix-tests
* v4l2-compliance
* kvm-unit-tests
* kunit
* rcutorture
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
