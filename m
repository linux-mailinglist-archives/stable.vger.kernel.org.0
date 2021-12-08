Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD0E46CBFE
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 05:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239943AbhLHEO2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 23:14:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239862AbhLHEO1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 23:14:27 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F99C061574
        for <stable@vger.kernel.org>; Tue,  7 Dec 2021 20:10:56 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id x6so3933125edr.5
        for <stable@vger.kernel.org>; Tue, 07 Dec 2021 20:10:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xNciXeE5mfNKBn+xLfyt+kwCN5b4hSI12y+mRmjiIe8=;
        b=zlHMtKWLaOOAJKOaMc1D+9RXbfMxgiAz1aOpFpW5hAva1PUfYUClRpKkaMldwVbfL6
         Qa/ysd/ueh9VKy7EDD1+pO4S8oJ+JHg5m3LIvsoOd7pLuvAGr1KJ3C6YL0/8o39MZVka
         Mn8rwrqPJ/V0fuf6IkZn+tcOop4DdKq6ntO6HOd2p88kj4X8syhQwWFtW5xS8Sr0gtqX
         ZvZ9MURHgW19vEkHzMegXYfTRs1FtE7ObL4diY62uAWXdKEdYya54r+Tky46gxahuOhS
         WBnWX6oXKjlgHnG5mfc+9669IxdAoIisWPnari0AmEIFHlRJBpYKDmBtwLFi1b4UI8rL
         84gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xNciXeE5mfNKBn+xLfyt+kwCN5b4hSI12y+mRmjiIe8=;
        b=yw9z1bEY+UgHblRf/PMcQiLN7Ka0nBWMX4fTcbb71hLUhxZBiNUJY7QxW9msjFahTv
         aDUKnTFkx9Hz7r19cUA5XI8PJtJj1SEO4Ols63/M/xKm2vOYn1ePUJgX9PBsZ3xHqyg4
         itc5BuHyhD0yqL4kW6iEhpYTojlTx6AXjmLZh4ZY3OPhVQj8H5SjF4BrIWHqxQIrPQ1L
         fXhRLEIRA+oJ+EannwvaQnVb2j6t5eHvoyOtnHC5zO6IWOY8f8KhngoE1IJ01oLekbfq
         6ccf/KIyJdJ9EagkIHvgu7POoXosmQCcS0S6neavyXPWpEZ2kSsUwy7q54mz0Z4t22jF
         AFvA==
X-Gm-Message-State: AOAM532l8743cB2FwmUVaZSAp6zWdHLYAJappVzMyMzd0aL4X2nkzdKg
        g5oybY4qaM8bZZD1bI2LSnps3xvrHBcb+PT4bYcHzA==
X-Google-Smtp-Source: ABdhPJzwcOZkfdTrIc9iypu8XmGotkpKMHHRKOU5Q0rJHTutHQbG1SAsDJYXygGMS1J90u7AYDE4wwXc8bMdlGaIzNc=
X-Received: by 2002:a50:e003:: with SMTP id e3mr15514013edl.374.1638936654541;
 Tue, 07 Dec 2021 20:10:54 -0800 (PST)
MIME-Version: 1.0
References: <20211206145549.155163074@linuxfoundation.org>
In-Reply-To: <20211206145549.155163074@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 8 Dec 2021 09:40:42 +0530
Message-ID: <CA+G9fYsJeJ2E1LzR=yKYKB=NcJzC7Som9MC0dz3L43ATuy4X7w@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/62] 4.9.292-rc1 review
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

On Mon, 6 Dec 2021 at 20:31, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.292 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 08 Dec 2021 14:55:37 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.292-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.9.292-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.9.y
* git commit: b14dcd4dade22e4f6d6e07a965f92c5eac548baf
* git describe: v4.9.291-63-gb14dcd4dade2
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.2=
91-63-gb14dcd4dade2

## No Test Regressions (compared to v4.9.291-13-g2cd9f5eb5e7f)

## No Test Fixes (compared to v4.9.291-13-g2cd9f5eb5e7f)

## Test result summary
total: 72576, pass: 57494, fail: 566, skip: 12421, xfail: 2095

## Build Summary
* arm: 130 total, 130 passed, 0 failed
* arm64: 32 total, 32 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 19 total, 19 passed, 0 failed

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
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-vm
* kselftest-x86
* kselftest-zram
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
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
