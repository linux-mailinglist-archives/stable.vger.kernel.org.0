Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C197940F6AE
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 13:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241829AbhIQL0t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Sep 2021 07:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbhIQL0s (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Sep 2021 07:26:48 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D0FAC061764
        for <stable@vger.kernel.org>; Fri, 17 Sep 2021 04:25:26 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id g8so28773764edt.7
        for <stable@vger.kernel.org>; Fri, 17 Sep 2021 04:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KkBfKrBXy1fDp0O0FbJyBBlgnJBorb/M1zpwR4sM5Qk=;
        b=P6NigRHu9MnGIfZpMok1YsnC8O+4aQpUEgSeCxAuFYdwVNwIk22F0QFodvfq+Zq2uh
         JYBDXLUrSuNwiJ+SCrQ/8iFTc+Qj5BkC6E99r3393OpCJebaTd7ruMEhpp+4oOr7mvn5
         igsxdpPb3t4GKqVKyWC8LcNaCJ3Z3r68vR+wARBoBSmQcusu2RnJcMNIFIKKfcFKNpYe
         11V5iCw7iWK4NTwxrHeAPF9c4f4PAXAn3yd+5CPOEbGpPA/jrIz1ncrxXYsiuSDwghJF
         SIiJWUm62ChDKM7rARBEczhm1cN6jotMGWrFdOPCrQLLQZwAZz2oxvXFGRwnw5Rznbl3
         mgqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KkBfKrBXy1fDp0O0FbJyBBlgnJBorb/M1zpwR4sM5Qk=;
        b=zWwDTIUtDQS6i1FAzhHAoAy/75wrf8D++/T8LtO5MH/qmENMQFIGZAevVdJKca0jOp
         59wWpdl69554/L6C/3FnHEK7H4uuzfK4GXleSEmUuXtsSTlF0utafeqW+B0Zs6Ql4zYn
         /C3lr6v7E4Jyg1EyBbrWkpUV8qShnpx1ldqFJMnGOOsCweYspLy0j0Jor7FxehHlCICm
         K7KrK38NOkI7YjSKPMgTcHap7AfAOXGse1tXFT14DyRpRXyqauxHJL0ndHkT1qtVQjCX
         GeHV4m0V+6alaPKfwkrqK1/YFNbTAi2e4LxGWeFqhV/pO71GSbBDM/d7S8SUteGPUXxZ
         3oLA==
X-Gm-Message-State: AOAM533Xjjya0e4D3MFYXC5Tj3UMUpBgE2DRU+CobpIS3eoCvoXTTU/g
        DH7dks5dWuNbraY76O1PGBJHhcOXQQ4sOUpfoLV6KQ==
X-Google-Smtp-Source: ABdhPJxPf1bjOnqSNBZWo92E+P8mW1mJzRE7iX2vsvcI1KBZa1essHMLgCEJlW4YG/6NbC1wUfZPZuYZMU4scv7s95g=
X-Received: by 2002:aa7:c85a:: with SMTP id g26mr11769867edt.217.1631877924758;
 Fri, 17 Sep 2021 04:25:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210916155753.903069397@linuxfoundation.org>
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 17 Sep 2021 16:55:13 +0530
Message-ID: <CA+G9fYtySQ-K1wkp+grGWu-6j6Xs0qM0gFBW+aWJzTk_wocUsw@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/306] 5.10.67-rc1 review
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

On Thu, 16 Sept 2021 at 21:35, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.67 release.
> There are 306 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 18 Sep 2021 15:57:06 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.67-rc1.gz
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
* kernel: 5.10.67-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 729f504fde252d9bd1854ba90456253c3df643f5
* git describe: v5.10.66-307-g729f504fde25
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.66-307-g729f504fde25

## No regressions (compared to v5.10.65-55-g84286fd568e7)

## No fixes (compared to v5.10.65-55-g84286fd568e7)

## Test result summary
total: 86342, pass: 72348, fail: 568, skip: 12351, xfail: 1075

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 289 total, 289 passed, 0 failed
* arm64: 39 total, 39 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 38 total, 38 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 51 total, 51 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 36 total, 35 passed, 1 failed
* riscv: 30 total, 30 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 39 total, 39 passed, 0 failed

## Test suites summary
* fwts
* install-android-platform-tools-r2600
* kselftest-android
* kselftest-arm64
* kselftest-arm64/arm64.btitest.bti_c_func
* kselftest-arm64/arm64.btitest.bti_j_func
* kselftest-arm64/arm64.btitest.bti_jc_func
* kselftest-arm64/arm64.btitest.bti_none_func
* kselftest-arm64/arm64.btitest.nohint_func
* kselftest-arm64/arm64.btitest.paciasp_func
* kselftest-arm64/arm64.nobtitest.bti_c_func
* kselftest-arm64/arm64.nobtitest.bti_j_func
* kselftest-arm64/arm64.nobtitest.bti_jc_func
* kselftest-arm64/arm64.nobtitest.bti_none_func
* kselftest-arm64/arm64.nobtitest.nohint_func
* kselftest-arm64/arm64.nobtitest.paciasp_func
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
* kunit
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
