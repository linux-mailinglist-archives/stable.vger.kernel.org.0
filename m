Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E14F345FB3
	for <lists+stable@lfdr.de>; Tue, 23 Mar 2021 14:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbhCWNbG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Mar 2021 09:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbhCWNay (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Mar 2021 09:30:54 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9505DC061574
        for <stable@vger.kernel.org>; Tue, 23 Mar 2021 06:30:53 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id u9so27109792ejj.7
        for <stable@vger.kernel.org>; Tue, 23 Mar 2021 06:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MDPG8p5N4UdjXCdq+avfFbXU3o20BK4EHu8tEMTA+n8=;
        b=fRJiLdxnFUFHfKYtfDXCQ1Jqc8UN0FtE6hUB8TbJAE10MatNb+f4MbY22cHILEpw6u
         Z6O1tUyHVrHtax+Vn1hpyJD99+gAvCvSm4/+NcvzztES/ga/5h3W6QEltBRh6BT0gkuv
         r4vpRXf4MapBEjVnfIv4dLhOSufZCNPK5X61u6b5oUfg0DP0BtWhBg66tE98A/r6I+24
         4Mu9o5Us+VezF/foRIj6raFh0wWoqa3wjnDpbj2s5RgEcZNAS0B2KNbQNmGN7b8nYUHa
         NRPotLOOzn99gxTCcJWatTXTWwJNnXiI426SYlZt5bFGSfeNYEvTH4LpHsHHUsOYBval
         gpvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MDPG8p5N4UdjXCdq+avfFbXU3o20BK4EHu8tEMTA+n8=;
        b=gG0PVyPOKpZBECJ/Jo//YpsAmGr73qKprcMWxCNLL34uv3mUnRqXVRKLO31AuzheIE
         gBwPkzXK+Pb1tnGTMl0sJyvX84EJiG9RdDNAKF99ebBxxzsq4c9Gcv4E8ggPxpLBDphy
         eVuPPcfneG30rppgrwpjKJsBUJxAWMkWLsvJx6J7JC1NAGEJN5YvefYx5wAdAajR1L7L
         eGth2JXK19CKArz+spNzSgdYThnFzSc8/byo+TaIq2xTkU8q2icdVpefaSxHiGd9nnUz
         oULkFAuau3Kq0h4q3tYDe0vcMmG8+YPp4/qhIXvD94gnVPPzFfPr53ocwDhUNwTUyHpL
         f93A==
X-Gm-Message-State: AOAM532ob8qYY/iHd+TFDRC5IsZ+wEer+cPlMyUKKP0YQAd1aBYDy95Q
        jTJHvG93qnSDxFVpB/lITbJ8r5RHiI6vgDf7Zd2CLw==
X-Google-Smtp-Source: ABdhPJxdYLsLDACHsLswRTuiUt4NDuSSm6YMvQdUUXZhASd7w6Z97Wt9RjPYSse39yqsFZUS9sulekOO83b7HRXhLJo=
X-Received: by 2002:a17:906:a896:: with SMTP id ha22mr4853619ejb.503.1616506252192;
 Tue, 23 Mar 2021 06:30:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210322121919.202392464@linuxfoundation.org>
In-Reply-To: <20210322121919.202392464@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 23 Mar 2021 19:00:39 +0530
Message-ID: <CA+G9fYuuOHGm0EijoGeQ0npRMBDZeG56x0GMpzKmZditiRPqsA@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/14] 4.4.263-rc1 review
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
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 22 Mar 2021 at 18:24, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.263 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 24 Mar 2021 12:19:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.263-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.4.y
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

kernel: 4.4.263-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: 769f344ebed2d7d9adc324015195b8c3fda886da
git describe: v4.4.262-15-g769f344ebed2
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.=
y/build/v4.4.262-15-g769f344ebed2

No regressions (compared to build v4.4.262)

No fixes (compared to build v4.4.262)


Ran 36066 total tests in the following environments and test suites.

Environments
--------------
- arm
- arm64
- i386
- juno-64k_page_size
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- mips
- qemu-arm64-kasan
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- sparc
- x15 - arm
- x86_64
- x86-kasan
- x86_64

Test Suites
-----------
* build
* linux-log-parser
* libhugetlbfs
* ltp-commands-tests
* ltp-containers-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-tracing-tests
* network-basic-tests
* ltp-cap_bounds-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-mm-tests
* ltp-sched-tests
* ltp-syscalls-tests
* kselftest-android
* kselftest-bpf
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-firmware
* kselftest-fpu
* kselftest-futex
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-livepatch
* kselftest-lkdtm
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sync
* kselftest-sysctl
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-zram
* kvm-unit-tests
* ltp-open-posix-tests
* perf
* v4l2-compliance
* install-android-platform-tools-r2600
* kselftest-kvm
* kselftest-vm
* fwts

Summary
------------------------------------------------------------------------

kernel: 4.4.263-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.263-rc1-hikey-20210322-970
git commit: cdbe5973893696eb29efb23b75953efd2f7edf4d
git describe: 4.4.263-rc1-hikey-20210322-970
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.263-rc1-hikey-20210322-970

No regressions (compared to 4.4.263-rc1-hikey-20210319-968)

No fixes (compared to 4.4.263-rc1-hikey-20210319-968)

Ran 1863 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest-android
* kselftest-bpf
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-firmware
* kselftest-fpu
* kselftest-futex
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-lib
* kselftest-livepatch
* kselftest-lkdtm
* kselftest-membarrier
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sync
* kselftest-sysctl
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-zram
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
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
* perf
* spectre-meltdown-checker-test
* v4l2-compliance

--=20
Linaro LKFT
https://lkft.linaro.org
