Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 181B344D47E
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 10:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232808AbhKKKAd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 05:00:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232783AbhKKKAc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Nov 2021 05:00:32 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A97C061766
        for <stable@vger.kernel.org>; Thu, 11 Nov 2021 01:57:43 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id v15-20020a9d604f000000b0056cdb373b82so174134otj.7
        for <stable@vger.kernel.org>; Thu, 11 Nov 2021 01:57:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=x4E9Ov5wgrdVdgeFWkGeggKUzjHvS0JzcmCa1ngl0s8=;
        b=vS4XkUpiD4sfEzmukFlYvNY703pATIFCuajmyF+67J3PnuqN68LVQkrx7alPwwCFeM
         DDk+115mJ6/iYrrS4vsoX/onJOtHOctpKUmHeG13bKQu+oMsX8zqz+0mb0WhU2pGWUd9
         GNm4aTwwLdW0V+mv5IlMD13cxv5vcDelHMil3j2M7FkaVfbkm/I6+nicUUFb6pyPzu2q
         d7az40iNPsFf6miQgl7jkjxhAHt7bqAEGKVNqK2WI1QWX8pUaKsNKLqmnN0iF7itEL88
         rWMF1sSEskMvP2swybjeHsodBojFd3y0w5x+7eO/HWJEDTKwPbjsZvjIBERA1BmKQ1Cu
         8qoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=x4E9Ov5wgrdVdgeFWkGeggKUzjHvS0JzcmCa1ngl0s8=;
        b=syGp0yUpuRTpL8/uS1FDtYGJyE0X1Rmdvq9qyu46NZkeV55HiScAC1DzGQscvLervQ
         yJ0vTr/ClQ/j34SOmKX05jKO2OZWIjiWGjy/DP4RRE8OubSWRg3wuCVBx/sD+iENbL4n
         G8+82bCcTDeTaDfDm6N2FB+mowx9qL1j+rj4AGy/K9CpuX8bwYdYB+fcUukt69lAgDxk
         HzM+ioBb6ETq1AuxNWc1cifbQt2auA+7TOuw7AmoOZ5Tvf8ya/tN/eEpg9Ia8yBs9LWs
         HPEKTheqFJG0FQmbuo7XEORoxKkXPQCkpMijNXqt5rCcDZEAnVA75sqdRHmYBLKQeBEj
         x50g==
X-Gm-Message-State: AOAM5338eNpnkDcV8j4rkGZeUI6R2ZOoMjKVIPek9Nx0vK0o1EYnUkie
        5PzNS+0z/xftFPfViFfBHiKaa+Et1ejgLuetJ6Hv2w==
X-Google-Smtp-Source: ABdhPJzzeax4Y9MdA75mKpbwh7svAQ+pT4JrbHAXeyrrznETwzSW6Rjwrgp9K2swMh+ieiq9vCa5AWszPZGtmtyAe2A=
X-Received: by 2002:a9d:61c1:: with SMTP id h1mr4904173otk.27.1636624662289;
 Thu, 11 Nov 2021 01:57:42 -0800 (PST)
MIME-Version: 1.0
References: <20211110182003.700594531@linuxfoundation.org>
In-Reply-To: <20211110182003.700594531@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 11 Nov 2021 15:27:30 +0530
Message-ID: <CA+G9fYupujFit=XgfBtaz_EakkiP74-DYHQpFge24M2joXGbjw@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/26] 5.15.2-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 11 Nov 2021 at 00:21, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.2 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.2-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.2-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.15.y
* git commit: 12d0445d66e0451efe07e65f9713fff3d71c3205
* git describe: v5.15.1-27-g12d0445d66e0
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.1-27-g12d0445d66e0

## No regressions (compared to v5.15.1)

## No fixes (compared to v5.15.1)


## Test result summary
total: 97508, pass: 82057, fail: 1042, skip: 13317, xfail: 1092

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 290 total, 268 passed, 22 failed
* arm64: 40 total, 40 passed, 0 failed
* dragonboard-410c: 2 total, 2 passed, 0 failed
* hi6220-hikey: 2 total, 2 passed, 0 failed
* i386: 40 total, 40 passed, 0 failed
* juno-r2: 2 total, 2 passed, 0 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 45 total, 42 passed, 3 failed
* riscv: 24 total, 24 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 2 total, 2 passed, 0 failed
* x86: 2 total, 2 passed, 0 failed
* x86_64: 40 total, 40 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-
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
