Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E10E23D717C
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 10:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235933AbhG0Itm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 04:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235932AbhG0Itm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 04:49:42 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB9AC061757
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 01:49:42 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id hp25so20715652ejc.11
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 01:49:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=N+3DXi642GqDpFpnUX/m+M4EKuorPVrRr3DgsMu4Ntg=;
        b=zO4GMwJRTkMW2jglCDdbxfnzAB/CrPx0IoFjJMiB24fWa+9U2ROM9Ci98K/bzSTGbH
         UUCtkJxF6DQ+SQoI70a8MCIlqDu23T2lB0FmmeCnAnSu4+IqmWrDvz+4ejxdqxYs7F5x
         hVFOqRApPGg0qZnWfw7/ak8TDRXDsQapP3vWtkRpLmRe5DKmOhIlnjlBIcgr0WMEhjiE
         +y3xtWd1Z5KMY9J3oZT97xPATmRqfapypw1MKerXlnNuRh0OewDetEz1zlB6ppQpDzHQ
         t5GGm++LPSyk5198qzqMTVOmk+RFilobjB0uw890RzhmB1MgNKhBC3O/UJ/ZsGZIp4jM
         E7tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=N+3DXi642GqDpFpnUX/m+M4EKuorPVrRr3DgsMu4Ntg=;
        b=ib6lX/lLSiGT8FB2xOy1WjhVeHKo95AG4uJCwzSflE73CR3Nr5Y1yGiobjK+gyVmMy
         9CaY5o51pi4aBKtynP6BDbbDptdQf9NB4O7u/Ti8Fo3WH8HqzmlYLv9oYa54C+aLR4+W
         BF9qWSXzUaLpbY5DFkIuSamvzKILiisaFIVtQqFB9vwOCmk/R6PIUNArG/pEPW7JT8lt
         nX8zfHFmbULA6ZpBwqCFD4U+jRt9UfR/c1lXNWTY9xt485/heBHlqbqbYk6nl+qxOSxj
         pw+PuZNRoIMHruISGoP5SYcr+42bH+d+uNobJAP0vz76fm2XP975foozWaRtRsVAKl00
         R5GA==
X-Gm-Message-State: AOAM530aaoCx/jKUHz/1BVXdtZVauJCkwuXKdIBB1OEJ52QI5uhhsBr+
        EudoJOvVn+WyXLlQ35J5xWee6Nhlsx9O9kcyRo7g6g==
X-Google-Smtp-Source: ABdhPJwssx92s9INRUabScriKMwv9Gz0vKkIANQpCkrFdkyEovXwJeMv8zkNy5vhIbHii8huFIA/k8fwTToewlVxODI=
X-Received: by 2002:a17:906:4b46:: with SMTP id j6mr21051156ejv.247.1627375780645;
 Tue, 27 Jul 2021 01:49:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210726153831.696295003@linuxfoundation.org>
In-Reply-To: <20210726153831.696295003@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 27 Jul 2021 14:19:29 +0530
Message-ID: <CA+G9fYt6eZR_3uFmG+LoqAV6wFc7TZiShdXGwordRiN9XT6ufQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/108] 5.4.136-rc1 review
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

On Mon, 26 Jul 2021 at 21:25, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.136 release.
> There are 108 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 28 Jul 2021 15:38:12 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.136-rc1.gz
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

## Build
* kernel: 5.4.136-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.4.y
* git commit: 77cfe86f32232bb4b8fd35352d6db630e5ef4985
* git describe: v5.4.135-109-g77cfe86f3223
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
35-109-g77cfe86f3223

## No regressions (compared to v5.4.134-72-gdcc7e2dee7e9)

## No fixes (compared to v5.4.134-72-gdcc7e2dee7e9)

## Test result summary
 total: 77330, pass: 62228, fail: 1011, skip: 12507, xfail: 1584,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 192 total, 192 passed, 0 failed
* arm64: 26 total, 26 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 15 total, 15 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 21 total, 21 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
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
* kselftest-x86
* kselftest-zram
* kvm-unit-tests
* libgpiod
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
