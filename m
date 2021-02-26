Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 070BD325E93
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 09:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbhBZIBi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 03:01:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbhBZIB1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Feb 2021 03:01:27 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2908BC061756
        for <stable@vger.kernel.org>; Fri, 26 Feb 2021 00:00:47 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id d2so9799765edq.10
        for <stable@vger.kernel.org>; Fri, 26 Feb 2021 00:00:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+cCnvqPl/AB2g/rBCqOWO+msBf4tIh3Bh6qIDLBPfpE=;
        b=JsAvrIKlM3pL20nlLL0BGEAkMQ3GUpsDs0XoRGguz27yaqnCrbkbOF9kproZLnThBV
         5E+hiLimH0JGxTQ7lO4zwbefzp7zDJ3blbEg3Q7s4Dv6yX2x69aEnlq4OKdpTVSf+X4h
         iJjSipoy6nTbZpZr7K6o97b3oP+XpIknAERMe8K5YnH0mmQufDu+S7GhPX30jeHE9UhD
         eN1QZOsgF3imwOK3dFkI50oJCYmDNPl4odkxgz+WODdlUKNSCGyhMXpzUpUpz1+tVY2X
         Af19VZthnhkhZc3zn5zLBcHHRylF7vHPugX9g5QMbBDKNPyW80BCw/BFiuxBkNVubT+f
         PY8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+cCnvqPl/AB2g/rBCqOWO+msBf4tIh3Bh6qIDLBPfpE=;
        b=sO5pb1qpFaneWxrhSme8KAEgnxrBKIf9aNWGjUa1QTHyxosYuRtZrTZC6CWN6BVf1f
         e4gV3nfODTkXbgWLc6S7pCwxm//d+QMhkgQJXei8AgcVA8hLzTVR8kIOV3AWSP+CHCv3
         TQ2s6iN4OCVHcpOELCHtFxGqAYES8rztfZ9GLoIArlVAgLFszYUsgTuP0CDb5Rjjn9j4
         Uorjv7dDyq2ZCKO/T1LRGqAE/dfAPXLLMhbMChPSiOCUQY0OR0OdjOM4d3xTFwil4RF/
         R3bSnQki6KCdx/5hvdbq/4bkP8utvgIsjmXQ0tx+vyVcRJ9f4gYJmDULCLZ82Ou0u9LG
         AALg==
X-Gm-Message-State: AOAM531aR8F5eF+2RvC08XAwEQd9H0KtT6/NqYpEAfhb7PWYE8TqCQTf
        qdjs+KyYpChgJnZobAA7ZD5fw1AAt90guRu5ohIrWw==
X-Google-Smtp-Source: ABdhPJy+9ukdO4/4f4X7C9KDKCtQDucXdj3+WjwRZkYshjkjwzKOaFEWBvOHrT9uAZCURYIRIPxV2ImOkm21opowz2c=
X-Received: by 2002:aa7:cb0d:: with SMTP id s13mr1870001edt.221.1614326445786;
 Fri, 26 Feb 2021 00:00:45 -0800 (PST)
MIME-Version: 1.0
References: <20210225092515.015261674@linuxfoundation.org>
In-Reply-To: <20210225092515.015261674@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 26 Feb 2021 13:30:34 +0530
Message-ID: <CA+G9fYu-UQxh+TppNVU88wWcLtBgrB-FseSf-MdGN02EAkd5aA@mail.gmail.com>
Subject: Re: [PATCH 5.11 00/12] 5.11.2-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 25 Feb 2021 at 15:24, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.11.2 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 27 Feb 2021 09:25:06 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.11.2-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.11.y
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

kernel: 5.11.2-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.11.y
git commit: 68eabe17bf08272cb338564500da7be0d4aad9a5
git describe: v5.11.1-13-g68eabe17bf08
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.11=
.y/build/v5.11.1-13-g68eabe17bf08

No regressions (compared to build v5.11-13-g6380656c9227)


No fixes (compared to build v5.11-13-g6380656c9227)


Ran 46115 total tests in the following environments and test suites.

Environments
--------------
- arc
- arm
- arm64
- dragonboard-410c
- hi6220-hikey
- i386
- juno-64k_page_size
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
* kselftest-
* kselftest-bpf
* kselftest-intel_pstate
* kselftest-lib
* kselftest-livepatch
* kselftest-membarrier
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
* kselftest-mount
* kselftest-mqueue
* kselftest-net
* kselftest-netfilter
* kselftest-nsfs
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
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
* kselftest-tc-testing
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-hugetlb-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* perf
* v4l2-compliance
* ltp-commands-tests
* ltp-containers-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* network-basic-tests
* kselftest-android
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
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kexec
* kselftest-kvm
* kselftest-lkdtm
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-vm
* kselftest-x86
* kselftest-zram
* ltp-controllers-tests
* ltp-open-posix-tests
* ltp-sched-tests
* kvm-unit-tests
* fwts
* kunit
* rcutorture

--=20
Linaro LKFT
https://lkft.linaro.org
