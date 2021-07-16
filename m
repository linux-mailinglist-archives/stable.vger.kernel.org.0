Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9A73CB707
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 13:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232743AbhGPL4Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 07:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232088AbhGPL4Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Jul 2021 07:56:25 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53454C061760
        for <stable@vger.kernel.org>; Fri, 16 Jul 2021 04:53:28 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id nd37so14748963ejc.3
        for <stable@vger.kernel.org>; Fri, 16 Jul 2021 04:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=x31rx+sTedCLPZCYpFXXREs5WOIbW2tGnQ12o5YNa/8=;
        b=zuTV6A5T3Pk4weqNtZJelZPVVKQg5mfnOtDJtHHrKSoebvuIeyNZupB8rnLBaYZuPG
         P0RUaYGT47850VgfarnwzgobwB+a96AD+EU0yj5r4+lhDApEtjW6nPwk1pH7vn8C50nV
         cnRvO6Ko3yi+Kl0iDLELmW6FBfYXE8SV+PBj4S6DtkolLM1xhza3PGt4DFb698tey2wD
         Mmz0zXtAdRTPmlxlfU0ko6y3aWxKGNI4CpWXbFH/g+ocyvhe9t6OjuhY6/vJjztI7629
         q6tGivwh4I2nyMZXrLGgzRV+SFxhJSa+jXbvYK6VcVB7rkDPNS439dcnSCPEgReMHFWd
         RWVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=x31rx+sTedCLPZCYpFXXREs5WOIbW2tGnQ12o5YNa/8=;
        b=kQac0WlqzDHzwNdID1PQ5TpPbCqLEl3esKRdSg7i9DJH2cdcoD48v7v/YZWzbQqMzE
         rdHvQx7x4dv1sxm+Y7TLpcv9WlaEvSBusvZdYdD11oRuVOrUQE419yRp+7zlEPBHDBZQ
         XZ2uEk4pkkbCmQ50Xu/YB6fE+27RzcdlpOZ1AWJO26Xizq6RhCFBUH6E75ZjT9p8RDGs
         EOSB28SC3IOn87ma+wcBjxJOTE0a8DOdX/qzWhv3P4X3K4FwVe6cjaPol7zpRfb2X4DU
         AXeB4N6dEyg50WLUhGlxP0LNbaWgQ2KjDOau8VpPBxKydwKo5SpLBxuGdxm9GhG7NZXX
         2ezQ==
X-Gm-Message-State: AOAM531Lg+p/upBFSiUWUDch119G/UqLM7WSE6GlrkxPUYDC9RYGsluz
        UqSd9wDLN8GSX9gOF+86O26zVcJFhn9FamS7kVWJeA==
X-Google-Smtp-Source: ABdhPJyOC8XbnTIbBnAjQilx7mtJX7w19oKYnT2RFlTFL+DFJsWykVTcVj6Fme0pOPkSPy8T2cwzrzZgdVSI0uADqE0=
X-Received: by 2002:a17:907:76b8:: with SMTP id jw24mr11004060ejc.375.1626436406679;
 Fri, 16 Jul 2021 04:53:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210715182448.393443551@linuxfoundation.org>
In-Reply-To: <20210715182448.393443551@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 16 Jul 2021 17:23:15 +0530
Message-ID: <CA+G9fYtcXVt5V_56Br6AJaHUm6fL9xEd4j5aBNeLrwMaQsJ+Wg@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/122] 5.4.133-rc1 review
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

On Fri, 16 Jul 2021 at 00:12, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.133 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 17 Jul 2021 18:21:07 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.133-rc1.gz
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
* kernel: 5.4.133-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.4.y
* git commit: 7f5fd6e106edc9ee7ca2a508fd7fa81e074102e5
* git describe: v5.4.132-123-g7f5fd6e106ed
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
32-123-g7f5fd6e106ed

## No regressions (compared to v5.4.132)

## No fixes (compared to v5.4.132)

## Test result summary
 total: 73331, pass: 59092, fail: 1149, skip: 11288, xfail: 1802,

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
* kselftest-vsyscall-mode-none-
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
