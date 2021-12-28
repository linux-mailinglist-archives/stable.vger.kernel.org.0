Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 606194808CB
	for <lists+stable@lfdr.de>; Tue, 28 Dec 2021 12:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbhL1L2H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Dec 2021 06:28:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbhL1L2H (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Dec 2021 06:28:07 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7E6C061574
        for <stable@vger.kernel.org>; Tue, 28 Dec 2021 03:28:07 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id y130so28431657ybe.8
        for <stable@vger.kernel.org>; Tue, 28 Dec 2021 03:28:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9tiYE+A5IsV8BNtDtNs94jTBqjMG3OVIBQ1Y9dvwNeU=;
        b=iT+JbpJ/0J5llTk5+bWUgst+LAznGzXsmHfDdGPW5yHKMSdxaylFwb6UU0sJkELePb
         yQHN4ccaeYSsWdRi4umvzlNPg3ELfhv+KyIlLUqXtSG3GeCuoXF3hiSdDrGpUjkHjzIb
         8WaLaOxIidn2Uic8zPe9F8kWmBq3mM4+RyTOdZX2IHGxBoJg9rSpdahqRIhgSJ0fChq3
         AczoTXLe0qa65/awFyO1M4dB/AUYsm78eLprNDVpKXQInwtIi9rhmlskXX8+KlAtD0S1
         0FfhHx+sTUluN1iWNDLNA48FHqOPTew5ma0SUNAbzzCxd+gA4PL6EeArizolBrw16NiK
         mBdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9tiYE+A5IsV8BNtDtNs94jTBqjMG3OVIBQ1Y9dvwNeU=;
        b=7VCB3yxeBSsJ1GBTVBIPOEspAIBShLVJ7/IfTKCdf0D3lf33wtuaNlMer9gDrcBYCq
         KVmZDuhkKU6se4ZLjdPuGr1cgYxp3crkui4hHvJyusnVm9IBaLmZzgerya7TN+kntb7B
         eLqxIBfAALO9xLTQEWav2ykWUBdb0iatmW4E12PfxJmT0jxhUr9PgEybZiMb5ifIEjnl
         SAG9NHwVe9cLUnq+YRpui8bSMo+y5Bbm3vI+ukqDtRQyS/WVfxDg9XUOGtMtsIbikMQI
         bwT0Q5hn1i9NgfdjBGGvEk3HyUDkmtaglqrKaoHmdEM+kcuMabNML984gVv2fkHBJK6u
         RUMg==
X-Gm-Message-State: AOAM533o6EJ/NdvMZu2N2+3czi0ji3yb/6EwNyc9eYdGIdx4HIOc9L7V
        ifFQ8NCw0obVpPG4iHNYKwzr4gcWaE8Kq1+hEJGnUcjC9qCpZg==
X-Google-Smtp-Source: ABdhPJyjWE4BTyxeE3NqaYlYpafpe/S7FNUUOnFgLYAI0fA23TdxE1d2LZjiYpqvZKf5VcXfm2+6bAX+ZogEPXRiEhE=
X-Received: by 2002:a25:84c3:: with SMTP id x3mr7938287ybm.553.1640690886250;
 Tue, 28 Dec 2021 03:28:06 -0800 (PST)
MIME-Version: 1.0
References: <20211227151318.475251079@linuxfoundation.org>
In-Reply-To: <20211227151318.475251079@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 28 Dec 2021 16:57:55 +0530
Message-ID: <CA+G9fYvpNZsU05y8i6XKfG08QXJo6O0k2R1FmK0_XTJb1-PSZA@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/29] 4.14.260-rc1 review
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

On Mon, 27 Dec 2021 at 21:00, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.260 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 29 Dec 2021 15:13:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.260-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.260-rc1
* git: ['https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git',
'https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc']
* git branch: linux-4.14.y
* git commit: 5ddb49631ce806b40b03cc8691a81579eea08178
* git describe: v4.14.259-30-g5ddb49631ce8
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.259-30-g5ddb49631ce8

## No Test Regressions (compared to v4.14.259)

## No Test Fixes (compared to v4.14.259)

## Test result summary
total: 75212, pass: 60370, fail: 620, skip: 11931, xfail: 2291

## Build Summary
* arm: 254 total, 242 passed, 12 failed
* arm64: 32 total, 32 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* powerpc: 52 total, 0 passed, 52 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 31 total, 31 passed, 0 failed

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
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
