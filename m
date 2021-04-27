Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6339536BF27
	for <lists+stable@lfdr.de>; Tue, 27 Apr 2021 08:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbhD0GPY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Apr 2021 02:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231475AbhD0GPX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Apr 2021 02:15:23 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 379D1C061574
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 23:14:39 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id ja3so11994125ejc.9
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 23:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=La/3BQxbnvCJHJDcLFbnMhXadMg8RfndgFkFC1hCKQ4=;
        b=Hx45LnW71hgN35E3kp/9jD1q9Uq32bYEy3veIlBFlg3fYYcJm9W/85fGIUysHjbcFH
         LRPz7hyafwuwv9PZvRCARzp59l/m0yZdhURt3kv3GbPBPveKnRmODftX35hSpPHPS9uS
         +blEiKue6x5EFvVTe1vygTJ+NXGgBlVkwCTQmBClfoM++ZwxFBMvk7quKpUb/LyNnFiR
         GUkW9YxihItYToVTMAI8WExF1OAf+fMZdV+nm5Vub7iC8VgDpvjmtjEggUziC0xVyzUZ
         tRXVFm21/mieVd9Lzmc86rUtMrXVESfRYfJa9J9CPHNkPTI3SxsRwtCB06UL+j7fDqIc
         STVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=La/3BQxbnvCJHJDcLFbnMhXadMg8RfndgFkFC1hCKQ4=;
        b=Vm2qdhbUnUqNcq7885zDS2RCqW9vWsGx9mLI3PFmpmaQ7GU6qki3hJFfGzD7qLb6DG
         l3Ex8eypQd44h5ZVymvR9INrk6T2FD+CwgIFuWgVuNxd4/cvbrULfTz41oKCD71g4WOW
         ihDCGn35EzCa4sV8ppKClB6STuftf/N2MRvCkoPmm0Lj3cdhlEFG2xE1cvktTPavQr0d
         nW23b/q3PdwUfVjUy310MWd0Zrp4rOxrLEpvTJTKRch6z1Wzx1K3xh65zeYsWIUvO928
         sk6LgKb4R5PO9dLPxSGrZWzMK94sU9XFQfT5eKdkmgBjXm0UMg3Xp7Ls00gP61gcVkqi
         d2Mg==
X-Gm-Message-State: AOAM530VjmitECWTOcltCj1f6TBky5YiUV9F79qIg8f6KuTraYp2LL4M
        DqZyKrp6akqNkUga2IMVwmDGzHJCG8nZwN9XNig9Mg==
X-Google-Smtp-Source: ABdhPJw1TkhSQ4hzcWCf3ikBmHDAfJbzXarfGpIu8o/HWiPqwOAwFopBW+AMP3wwSFAvXVXlOzXMHpY6i6234u39kD4=
X-Received: by 2002:a17:906:c04:: with SMTP id s4mr1354191ejf.170.1619504077681;
 Mon, 26 Apr 2021 23:14:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210426072818.777662399@linuxfoundation.org>
In-Reply-To: <20210426072818.777662399@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 27 Apr 2021 11:44:26 +0530
Message-ID: <CA+G9fYvJpSARiTX+4O3Z-znn2inP6++oVOM6MSPaRN3VAAa64g@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/36] 5.10.33-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 26 Apr 2021 at 13:10, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.33 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 28 Apr 2021 07:28:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.33-rc1.gz
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

## Build
* kernel: 5.10.33-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: f52b4f86deb4f6bcd54159dfce2303f4928de80c
* git describe: v5.10.32-37-gf52b4f86deb4
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.32-37-gf52b4f86deb4

## No regressions (compared to v5.10.32)

## No fixes (compared to v5.10.32)


## Test result summary
 total: 81811, pass: 66606, fail: 2889, skip: 12062, xfail: 254,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 192 total, 192 passed, 0 failed
* arm64: 26 total, 26 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 25 total, 25 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 21 total, 21 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 26 total, 26 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest-
* kselftest-android
* kselftest-bpf
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-drivers
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-firmware
* kselftest-fpu
* kselftest-ftrace
* kselftest-futex
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kexec
* kselftest-kvm
* kselftest-lib
* kselftest-livepatch
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
* kselftest-vm
* kselftest-vsyscall-mode-native-
* kselftest-vsyscall-mode-none-
* kselftest-x86
* kselftest-zram
* kunit
* kvm-unit-tests
* libhugetlbfs
* linux-log-parser
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
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* network-basic-tests
* packetdrill
* perf
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
