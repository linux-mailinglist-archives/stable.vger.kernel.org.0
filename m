Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9C331C5EA
	for <lists+stable@lfdr.de>; Tue, 16 Feb 2021 05:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbhBPEAM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 23:00:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbhBPEAJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Feb 2021 23:00:09 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0343C061756
        for <stable@vger.kernel.org>; Mon, 15 Feb 2021 19:59:28 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id n13so7855256ejx.12
        for <stable@vger.kernel.org>; Mon, 15 Feb 2021 19:59:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=u+11AVSqbXoxogfL8MD+diB+PcHPNubqnQd4DodJCKQ=;
        b=N9ST4LZvjL6ViQe3TPdCCB0c4ycCIhzwx0EHHHHe9BfQoCNEV3UQGOhunG1U/NdfCF
         02e4cVODUYSAarME/GvukJYOBIG55snpGfcADef3pGr+wLCgenv8vTf+tQu9dLYdtlJE
         JSxfAAbBdgkWQgz8yqygTQxts3KtCSWFczZQOEAWXOLZHtJvyLGVzkgCn0DbQtFelATa
         XnPyT2IQN5rq9MIAmlxbm1zCHKWgIC9ezpS4C7whTSvJaX2xzDWb1X2iH26gODjdu/LR
         bYgFzyHQwX9PJo4epfcAAoe1U2ERrwE6ankhmuzjvWJbfHybHWqi+gwmxZML85s7pjfy
         LcAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=u+11AVSqbXoxogfL8MD+diB+PcHPNubqnQd4DodJCKQ=;
        b=dJpGYynR4ddVwt/GLSagq0sKKfkThlLlXik65mZqX18sTmeKJPEFIINdVj8UOIE7GN
         oUH5GpgTUWiJS78N5WzI3rb7gg09PpKFOwFjpcsEAxrjbjn+RHT1/DvSPHTPeGDaL7Wa
         A0WPrQxcsVQvs5uiWVc7RyhOiSG+JSGP9GH5M+jIoitld1bVZ4DK9D1w3EEZqrXIzFkU
         iEcOrUHQf1WQ94Ir2kMilPHPEbMK6dnfF4tnMtKi2MTDZDQ7YlDAbE3hun4iCC317uHV
         dKh6WKogsemNVHv1lUnQewbDdBqoR2WPrGDskM4SRs5tKjTbAxdgreSWidZzcZMCYnif
         Wchg==
X-Gm-Message-State: AOAM531AhVEyK+RNFgNWwdZ/5hJCHWfsyPZSKVQ42EJP1x+lDJfYjwW9
        eV1JmV14Yrqq3XxZrpx5wpmFv+FIjrLtBGB60YNI4cck/H+QPOyz
X-Google-Smtp-Source: ABdhPJzmrHtQdLMDZL5MLvZJLis7ZsqOdMUDdWDZS0iwEsljsIjxsTPzUw7aNTz1aSEJM0jEDkZHj/XHAfYJ+ek/jNw=
X-Received: by 2002:a17:906:a153:: with SMTP id bu19mr19407889ejb.287.1613447967500;
 Mon, 15 Feb 2021 19:59:27 -0800 (PST)
MIME-Version: 1.0
References: <20210215152715.401453874@linuxfoundation.org>
In-Reply-To: <20210215152715.401453874@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 16 Feb 2021 09:29:16 +0530
Message-ID: <CA+G9fYsoSQ=uEwXAakZwyi6Lucedf1XJRiw_m6-6VWtAjJ-z8w@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/60] 5.4.99-rc1 review
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

On Mon, 15 Feb 2021 at 20:59, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.99 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 17 Feb 2021 15:27:00 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.99-rc1.gz
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

NOTE:
The following lockdep warning was found during the arm64 db410c boot.
And this is easily reproducible.

WARNING: possible recursive locking detected
5.4.99-rc1 #1 Not tainted

 kworker/1:1/31 is trying to acquire lock:
 ffff00000eb36940 (regulator_ww_class_mutex){+.+.}, at:
create_regulator+0x23c/0x360


Summary
------------------------------------------------------------------------

kernel: 5.4.99-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: c65ed94f3071e59865975e91b52ec522a50f7ade
git describe: v5.4.98-61-gc65ed94f3071
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.=
y/build/v5.4.98-61-gc65ed94f3071

No regressions (compared to build v5.4.97-25-g539f3bba2f5b)

No fixes (compared to build v5.4.97-25-g539f3bba2f5b)

Ran 50148 total tests in the following environments and test suites.

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
* kselftest-android
* kselftest-bpf
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-intel_pstate
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
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-dio-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* perf
* fwts
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
* kselftest-net
* kselftest-netfilter
* kselftest-nsfs
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
* kselftest-tc-testing
* kvm-unit-tests
* ltp-containers-tests
* ltp-cve-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-sched-tests
* ltp-syscalls-tests
* network-basic-tests
* v4l2-compliance
* kselftest-kexec
* kselftest-kvm
* kselftest-vm
* kselftest-x86
* ltp-controllers-tests
* ltp-fs-tests
* ltp-open-posix-tests
* ltp-tracing-tests
* rcutorture
* kselftest-
* kselftest-vsyscall-mode-native-
* ssuite
* timesync-off


--
Linaro LKFT
https://lkft.linaro.org
