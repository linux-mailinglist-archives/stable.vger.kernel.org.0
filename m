Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA4531C5F1
	for <lists+stable@lfdr.de>; Tue, 16 Feb 2021 05:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhBPEJt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 23:09:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbhBPEJs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Feb 2021 23:09:48 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 055DEC061574
        for <stable@vger.kernel.org>; Mon, 15 Feb 2021 20:09:08 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id ot7so11811087ejb.9
        for <stable@vger.kernel.org>; Mon, 15 Feb 2021 20:09:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CY+EJJyVaUAfm8SSWvq9ngV3Q8HfHbMWgUog076EEB4=;
        b=wuABRxl2Bg641O6P4vVWctmGhJxxFhd596UYoK+qNKMeM8uzEtCVcuxEj4InWF+EOJ
         zc9lIdYGFHKkJ8PzmHiysZBdqPEfhZzVpSM11ZeDPRZeZfdYTnHT196aiICTDjdPBnaw
         MhBxWUtO9sOtf0a9sm3tv91cvVMwSwwW9nw8mJkEyBIVkF0XKb72lKG30fMlfJJmuigo
         AK1/NcHmfD/ihVVWRm4LG2fl+bM1dwgrLeIwCZxrtesfSHuzgq0lVOqOK3J7r1nmXPyQ
         gkhfX8j9HMTGa3j8nzGNmczdejBcs9vXYL3/Qqcp5n7QxchoKQxUsBSNNY9Q20UrwqAC
         WegQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CY+EJJyVaUAfm8SSWvq9ngV3Q8HfHbMWgUog076EEB4=;
        b=r/Q7LlrzODOpM2F3zAyXntK1F7qsXfQa14OaVoi+OyGBtxaXUnq57ARN7V4q1yEiFd
         Ouo5KBDkQrYJov/Jc0M/DQP1+P8iGRMRTJkJZU29ZWaV+gzccvT5twVEsaN+W9qUDT9l
         8bLMQkdXbRCkZaSOnAiguQhzSz14zaPQBUSJ5A9k+gIJsbk1Tt1I5EbhzMkyaoyJeMkZ
         I0iAc/fzVOz0Gig4zcXnCBMxU6Zg0iuZd0MwQYmWxyBBTlq16RfVoVykoy83PENdkas7
         AGxXpy9MHJPmE/QZqcnoWSaUnj/2NeAsA7YKawTVaCfbxrlRdZqdE8gBuMIuzqeRJkOe
         Oakg==
X-Gm-Message-State: AOAM530FG0HYSalqXd7B2bRX9lrWX1nNwRPl5g99GhjO3wCKLBUVsFJm
        txfVC03GevzJ5NMn5djz5BuoIH2K2396Yawnbv1q5g==
X-Google-Smtp-Source: ABdhPJzR5GHmRnbrILH+mRaomOsagarWccJfBCzhEA1g3tY52jtcLc7FuY3Inw3Vxzm3dWVVAfgeRiXS+nogsfu/+BY=
X-Received: by 2002:a17:906:444d:: with SMTP id i13mr18276509ejp.170.1613448546690;
 Mon, 15 Feb 2021 20:09:06 -0800 (PST)
MIME-Version: 1.0
References: <20210215152719.459796636@linuxfoundation.org>
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 16 Feb 2021 09:38:55 +0530
Message-ID: <CA+G9fYu3nxjxfApyGzg-YwkDkRM9kZR0A=9pnLX_KJXmu3pkQQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/104] 5.10.17-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
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

On Mon, 15 Feb 2021 at 21:02, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.17 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 17 Feb 2021 15:27:00 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.17-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
The reported problem from last week's fix is in discussion.
scripts: Fix linking extract-cert against libcrypto
https://lore.kernel.org/stable/20210209050047.1958473-1-daniel.diaz@linaro.=
org/T/#u

Summary
------------------------------------------------------------------------

kernel: 5.10.17-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.10.y
git commit: 643709657afaaebc02f8fc7cd4e96bebe6ad0ccb
git describe: v5.10.16-105-g643709657afa
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10=
.y/build/v5.10.16-105-g643709657afa/

No regressions (compared to build v5.10.16)

No fixes (compared to build v5.10.16)

Ran 50355 total tests in the following environments and test suites.

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
* kvm-unit-tests
* libhugetlbfs
* ltp-commands-tests
* ltp-containers-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* fwts
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-mm-tests
* ltp-controllers-tests
* ltp-open-posix-tests
* network-basic-tests
* perf
* v4l2-compliance
* kunit
* rcutorture
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
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-lib
* kselftest-lkdtm
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
* kselftest-tc-testing
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-zram
* kselftest
* kselftest-intel_pstate
* kselftest-kexec
* kselftest-kvm
* kselftest-livepatch
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
* kselftest-vm
* kselftest-x86

--=20
Linaro LKFT
https://lkft.linaro.org
