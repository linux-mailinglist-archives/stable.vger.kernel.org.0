Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A12432F926
	for <lists+stable@lfdr.de>; Sat,  6 Mar 2021 10:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbhCFJhK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Mar 2021 04:37:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbhCFJhK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Mar 2021 04:37:10 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73425C06175F
        for <stable@vger.kernel.org>; Sat,  6 Mar 2021 01:37:07 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id t1so6348579eds.7
        for <stable@vger.kernel.org>; Sat, 06 Mar 2021 01:37:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hgLC2gL7+jrR036xKYjmUttxSScVAwH1a98vjs+S9Zw=;
        b=v+4Ec5zt99MbWbWXgfwzaQfRWtp8XsCOPooveNOu2ofSVvaW7V9nI5vZzEfzrz3S1C
         aMYqpHqdxdkYfQGHJCqTcmJmt3GfzeefIB9BFnatXE9Kb/7e64XBm3+bJHeo3ajl+qN9
         8RK8akpcsMbmxogCeO2UvvljProDSABkicYcJQjRSIeKhoNveyWpfrpYLy6vteturNsK
         SbadaYPTlblJLpT1a94tZIqklOJammzKI1Ul+JW5UxP/DPpVvop+l1j6Unkuf/cmgwTi
         SLZPHCypY27tMmFelJI5VALNPUr2J31vk4aQ4OH78tOSYAEvDTnbYt/On3acrmVTtI96
         wSlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hgLC2gL7+jrR036xKYjmUttxSScVAwH1a98vjs+S9Zw=;
        b=VmspV8N4poRZ1akxDZPAhX293W1tZgFxil351czNMJbxrbUnwfdo1gBAFa61CkjGqd
         o7mOb/8K3FGW5ZJcv/O2W+pia0uTFa9rDhSilh1DcY2Ey9AYJVsGdoRzPtxCFCoRtsKM
         eZgcva3srkNGTb8BLab1+g6Rj+3U+Zb+nQJFxz9RbB/JR2Mx3Msp6WRIKUTbkH0r7kjL
         C1/tU1feZTV9kRl8QTXWPeDa5p2nSUErcDqa1xCkYBCpD+kKyTgUR7XBRKhccLPxDrva
         ZoNOJa1d33td7To2iHEcp5H9UuoFTxifLdsSWGXYFdEajIJo3bjzNZs8vKiK3ixbnG4F
         HgvA==
X-Gm-Message-State: AOAM5311hty8vRSIhRvVvgLFgoy9PXK3Nj+JkvUjmkRONlQtQQFmRj1y
        6nsR940g5TYQNZ9FELRw835D0qPhpX/3MN9A1ymI0A==
X-Google-Smtp-Source: ABdhPJxGwfrYEiX+q/mgyffFfH+/PM3qHy2H6CxzqgLJS+FUJViZ1ZfRTCEqjRo8Y2EnFO6jMSveD10/nUqQoKJJc2s=
X-Received: by 2002:aa7:cb0d:: with SMTP id s13mr13007139edt.221.1615023425876;
 Sat, 06 Mar 2021 01:37:05 -0800 (PST)
MIME-Version: 1.0
References: <20210305120903.276489876@linuxfoundation.org>
In-Reply-To: <20210305120903.276489876@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 6 Mar 2021 15:06:54 +0530
Message-ID: <CA+G9fYtEVEaXPojqqkOdZZXN+q5-QZEN-W8a9E9CkjS58hpFnQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/102] 5.10.21-rc1 review
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

On Fri, 5 Mar 2021 at 17:59, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.21 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 07 Mar 2021 12:08:39 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.21-rc1.gz
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

kernel: 5.10.21-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.10.y
git commit: 80aaabbaf433294d1f075981fa3785d7f4b55159
git describe: v5.10.20-103-g80aaabbaf433
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10=
.y/build/v5.10.20-103-g80aaabbaf433

No regressions (compared to build v5.10.20)

fixes (compared to build v5.10.20)
------------------
  ltp-pty-tests:
    * hangup01


Ran 65964 total tests in the following environments and test suites.

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
- nxp-ls2088-64k_page_size
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
- x86_64

Test Suites
-----------
* build
* linux-log-parser
* install-android-platform-tools-r2600
* kselftest-net
* kselftest-netfilter
* kselftest-nsfs
* kselftest-tc-testing
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-zram
* kvm-unit-tests
* libhugetlbfs
* ltp-commands-tests
* ltp-cve-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* v4l2-compliance
* fwts
* kselftest-
* kselftest-bpf
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
* kselftest-membarrier
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
* kselftest-mount
* kselftest-mqueue
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
* kselftest-ptrace
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-dio-tests
* ltp-io-tests
* network-basic-tests
* kselftest-android
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-kexec
* kselftest-kvm
* kselftest-lkdtm
* kselftest-rseq
* kselftest-rtc
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sync
* kselftest-sysctl
* kselftest-vm
* kselftest-x86
* ltp-containers-tests
* ltp-controllers-tests
* ltp-open-posix-tests
* perf
* kunit
* rcutorture
* kselftest-vsyscall-mode-native-
* kselftest-vsyscall-mode-none-
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
