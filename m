Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF0B345BEF
	for <lists+stable@lfdr.de>; Tue, 23 Mar 2021 11:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbhCWKcg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Mar 2021 06:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbhCWKcO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Mar 2021 06:32:14 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DFEEC061756
        for <stable@vger.kernel.org>; Tue, 23 Mar 2021 03:32:14 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id y6so22853727eds.1
        for <stable@vger.kernel.org>; Tue, 23 Mar 2021 03:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Kj12+mxvJ+i0/4H7ureazLhFHG7dYKE3ygASVGopRQQ=;
        b=FSIKeYJf+uFoy0axmgrUr3YHA2I7tlG8QWeuFLnPpnZ0xj0FNf1dePYs1iVi3JXWLl
         ZuFdXFUyA7ZTOG9tTIdXpeo5cPWoJ/SvwuPPr6LODQ4tr0SUzyRHMtlxMlZkpg6zmf5e
         1R6lCjslbnH/TSiEJdxClxzUkJMiFrvHw7DfQwTTIH3HP05862NtZuyyBVWzJdglhViN
         +l6Lc4eL+TNpac2050T+mE2Nus8HAHoDVW31cJ4fPsrFD+pCPxoY/HWayr1/fX+pRx4L
         CCEW+nbeZaa4wikdhzmRGK/2xQIPHFHu8uu/zgIKCQpmVceIVawsTpQTuu1oZ0PTPSBL
         GrrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Kj12+mxvJ+i0/4H7ureazLhFHG7dYKE3ygASVGopRQQ=;
        b=te2F14qE7eXbQomD7irPldA5YYV9RZuUoIaWIoLPg68TzkMtiX+8fDdHMl0BOn69Yx
         CfC6E96PK2dWupmrwA9u58JCMZc8u3z7bS4jjVfz4Tl2TWPhIvu4x5lJWnbCqtrrJJHZ
         M8/b0ddYNcWwM4S4jFNL8pardCQBSXNdda/FpoyjcYKRNJ0TNzHizmklc89As3/sZCIe
         Oop8jEP1DakGwHA5LujTFv5ah2wwFKtzw4f+u+dhkvdphxYkvU4wy9fX9DL/mAOA/MZ7
         f4ii+b1Qbz9UVf5MKUgOknH9AS2apAmV+t3JDVvWsG5DMwrWkvGcklRnq0lmUoThfVwJ
         d8CQ==
X-Gm-Message-State: AOAM5328oAWqtd0oTW2Y/CZ1ihYPgfA1utNrcWEKzjw3cnAK6y73kvk4
        sogkZVdOCh+d7Cd3qfiOTkgd9/GfJeYEVzb03p2L7w==
X-Google-Smtp-Source: ABdhPJzM+8QH6hxX6iAId1BUNdMppRlPxMX3AX6Gb0uf6j+kdf2PeF288dIYDS7XYPqJiDLT4E638Usa97qyksl4x78=
X-Received: by 2002:aa7:d416:: with SMTP id z22mr3833201edq.239.1616495532435;
 Tue, 23 Mar 2021 03:32:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210322121919.936671417@linuxfoundation.org>
In-Reply-To: <20210322121919.936671417@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 23 Mar 2021 16:01:56 +0530
Message-ID: <CA+G9fYsKJOvt=6dzEkmpqAnoST2F2-ZM=_cS2Kh9tEytNwvj2A@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/43] 4.19.183-rc1 review
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

On Mon, 22 Mar 2021 at 18:20, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.183 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 24 Mar 2021 12:19:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.183-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 4.19.183-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 155590e98805144ae9800805ca98d3edcd2228de
git describe: v4.19.182-44-g155590e98805
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19=
.y/build/v4.19.182-44-g155590e98805

No regressions (compared to build v4.19.182)

No fixes (compared to build v4.19.182)

Ran 55402 total tests in the following environments and test suites.

Environments
--------------
- arm
- arm64
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- mips
- nxp-ls2088
- nxp-ls2088-64k_page_size
- powerpc
- qemu-arm-debug
- qemu-arm64-clang
- qemu-arm64-debug
- qemu-arm64-kasan
- qemu-i386-debug
- qemu-x86_64-clang
- qemu-x86_64-debug
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- s390
- sparc
- x15 - arm
- x86_64
- x86-kasan
- x86_64

Test Suites
-----------
* build
* linux-log-parser
* install-android-platform-tools-r2600
* kselftest-
* kselftest-android
* kselftest-bpf
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-intel_pstate
* kselftest-kvm
* kselftest-livepatch
* kselftest-lkdtm
* kselftest-net
* kselftest-netfilter
* kselftest-nsfs
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
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-zram
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
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
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-tracing-tests
* v4l2-compliance
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-firmware
* kselftest-fpu
* kselftest-futex
* kselftest-gpio
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-lib
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
* kvm-unit-tests
* ltp-fs-tests
* network-basic-tests
* perf
* kselftest-kexec
* kselftest-vm
* kselftest-x86
* ltp-open-posix-tests
* ltp-syscalls-tests
* fwts
* rcutorture
* igt-gpu-tools
* ssuite
* kselftest-vsyscall-mode-native-
* kselftest-vsyscall-mode-none-

--=20
Linaro LKFT
https://lkft.linaro.org
