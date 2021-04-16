Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB76C361703
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 03:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234735AbhDPBC5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 21:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235576AbhDPBCz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 21:02:55 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154BFC061756
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 18:02:31 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id s15so30269451edd.4
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 18:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FLviiZ7u+W7zpUN/iahSHhCxR57RALjCp4R+bIR/q4I=;
        b=xVMATBheO4kBDQK/42InsYS0tuwCR6LeGG+3fgwyOQjeNF72re1507kyWmxtY+yS/o
         SEjhzBjKfTNj8mAVrv2KEdKRlk2n+wgLvH0Em9Xeyj4EVoSck7fCoO6H+cRDLR4F1tXi
         rBi1LnGTyzy4mSi6rqkIwstEOyuHNxo7DT76bnFAxrxvnW79LAhxQClbaAu7sOJJj3oo
         ljy7vRuEvY+CJcfbPhdz3X8v1Z5idqF6xmdCOuH+rACY0Xy4k7Go3yuhs8PBkBj+zkAb
         Ihf2ZEKB2sI/dhi+vIGlmJqZew17l0aN2lHIxHVulL9OK4+n6wZsDZYm+7qhvE+xf/LA
         0aRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FLviiZ7u+W7zpUN/iahSHhCxR57RALjCp4R+bIR/q4I=;
        b=nBvM8i2y2iRifE+FcAdmi+8cIclMxuIRK4Fog0ilY3ba/T/8V8F/LG1e5oVGJw4+w1
         /eIYI/FB+mlWrmV6tEz0YQfPS+JElz755g0vUPvB1YnwwhC/Rif7N3EuJvvHhmkOX3qb
         ppvYPIdN70qAmVVQUq9Q+I2naku5QNcDHk2ou1BAk8obj4xpEtWI88ND4BvnXOwE32co
         4OcqMrFqMauKqkGB+qcOJAB5ofpiVadkkLMZxQ4UR2NyfpY8KIuAejvR7P7EaEWce9PM
         6GU2tV3okuaRgeG2UEnXS6eJfZV7xw+dHqGxVvhrPadXFNtiMxxa6jKwMuT+n0jw9wwe
         gv9g==
X-Gm-Message-State: AOAM531kfxmVeVqn8bv07GV8jdPtmbXvzCnXtwOuyY7vUMx7kgJr4+dZ
        +wTdeFC/iH0C9Y3qeqaE8Sb/SJ4lCp/bjFCKxFKTRg==
X-Google-Smtp-Source: ABdhPJxprpID/mPhVpOecG4jP9GfpH7JpuSGlZ2hGFIMybnx0sEmcrWACF4LYjSwXS3j6jmlAvBnG5DK2s7Ml07rh/o=
X-Received: by 2002:a05:6402:145:: with SMTP id s5mr7280712edu.221.1618534948973;
 Thu, 15 Apr 2021 18:02:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210415144413.146131392@linuxfoundation.org>
In-Reply-To: <20210415144413.146131392@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 16 Apr 2021 06:32:17 +0530
Message-ID: <CA+G9fYucwKvD8=oyP8k761JbuMb8TXaCQemha5sNBzEV_yL7Ew@mail.gmail.com>
Subject: Re: [PATCH 5.11 00/23] 5.11.15-rc1 review
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

On Thu, 15 Apr 2021 at 20:34, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.11.15 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 17 Apr 2021 14:44:01 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.11.15-rc1.gz
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

## Build
* kernel: 5.11.15-rc1
* git: ['https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git',
'https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc']
* git branch: linux-5.11.y
* git commit: 7825299a896f0cf519f259bb9d4ccab262d8c175
* git describe: v5.11.14-24-g7825299a896f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.11.y/build/v5.11=
.14-24-g7825299a896f

## No regressions (compared to v5.11.14)


## No fixes (compared to v5.11.14)

## Test result summary
 total: 74984, pass: 63321, fail: 1427, skip: 9959, xfail: 277,

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
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 0 passed, 1 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 26 total, 26 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
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
* perf
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
