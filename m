Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE57F48F52A
	for <lists+stable@lfdr.de>; Sat, 15 Jan 2022 06:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbiAOFfo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jan 2022 00:35:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbiAOFfo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jan 2022 00:35:44 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F88EC061574
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 21:35:44 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id i68so14983364ybg.7
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 21:35:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xr5CoW233+ktKsC/jbnkLpzCBoSWMGWpWu2mHvuqTEo=;
        b=Nevyn/sUtYqfb/2OKlRHlPwSzDQD+MNA+Oy6Ibl5a4AtqSUyC1u0sNviHMaYDUnvQH
         myEi+5cuIh4vAYhb1H3EZ95Z+Df7ly2ohqr/CA2HjyxjLph039PMZJ1Inmo+Uu51Gjiu
         AhJDc/UlC54/qdiC08xy3OhNfFYTS866RFg6mJf2D0AwqnwCgNAuVK6NF8xXuS/bm0iO
         B8jcfdmtcUJBLHZaN6ghbyz5wXa+Owwa5ov0/91ULr+sK7omel7IN46CXvTi0Crvtcdt
         7ZUq4xtDXLJ346Lsbx4KC+jS20xwoft8bMs1njeK+ATy3UrWI6H4Ot+SsmXKbqCwQkzn
         H6Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xr5CoW233+ktKsC/jbnkLpzCBoSWMGWpWu2mHvuqTEo=;
        b=0IT+db7uOv9VYjFxG/yggjPMXppXdry+1LqSC8CXDhcoX2W9/lO5ALhsjOQFdGEHrn
         s7jL/jZdfj4i6k1An9DNCN89miltinae+34GNVO/LCquFEVmrMrpMF9PPS1nR+23lTzW
         1L5yHLO3GPUtv052ZGJ04q+xMQ/2HFFNKbDzK/q7Z6NNgr0HVFsmYG3w21bFJ5JD9EOr
         HLCF6sEGzL6Lb1mUwV1ll2nZjiTN/HmvVU0L+mVZu9kopVDaegpo+FFJYMTEWhWgcKUx
         1HcCAuYZj3KaVLh0Apqkw7T/WM3hpBRhr3SwMHz8kUu2l5gPhJReDzW0IY3Pr1VX0OFw
         zQmA==
X-Gm-Message-State: AOAM532GmVXBqiGO3ERqnc2G8GbvfPpU+fGsz4n21t1mDinZIoSnoVCu
        2FEYf0g6qiNjNqHbDjmgj5ceWC+U2mpKoaE8NHp6/g==
X-Google-Smtp-Source: ABdhPJyYjMw8wiXn4F1ryduX4HaSEsCIKcOrJNsZI0UL7PDtoBi/gwJZ2YVhYXxBdi5Mzq1TC93siD0HE7NhAmhilsQ=
X-Received: by 2002:a5b:d09:: with SMTP id y9mr17779457ybp.146.1642224943016;
 Fri, 14 Jan 2022 21:35:43 -0800 (PST)
MIME-Version: 1.0
References: <20220114081542.698002137@linuxfoundation.org>
In-Reply-To: <20220114081542.698002137@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 15 Jan 2022 11:05:31 +0530
Message-ID: <CA+G9fYtFfsDLPAfsXjbHeEqe9NP59E13x_=7uzx_k+8UOXMing@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/25] 5.10.92-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 14 Jan 2022 at 13:48, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.92 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 16 Jan 2022 08:15:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.92-rc1.gz
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
* kernel: 5.10.92-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: fe11f2e0d63baa47c1e36b02721b4fd7a1157955
* git describe: v5.10.91-26-gfe11f2e0d63b
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.91-26-gfe11f2e0d63b

## Test Regressions (compared to v5.10.91)
No test regressions found.

## Metric Regressions (compared to v5.10.91)
No metric regressions found.

## Test Fixes (compared to v5.10.91)
No test fixes found.

## Metric Fixes (compared to v5.10.91)
No metric fixes found.

## Test result summary
total: 94616, pass: 81315, fail: 544, skip: 11939, xfail: 818

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 259 total, 255 passed, 4 failed
* arm64: 37 total, 37 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 36 total, 36 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 34 total, 30 passed, 4 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 52 total, 46 passed, 6 failed
* riscv: 24 total, 22 passed, 2 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 37 total, 37 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
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
