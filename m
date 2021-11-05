Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE9A4462D2
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 12:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232620AbhKELj1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 07:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232618AbhKELj1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Nov 2021 07:39:27 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D7EDC061203
        for <stable@vger.kernel.org>; Fri,  5 Nov 2021 04:36:47 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id m14so31292605edd.0
        for <stable@vger.kernel.org>; Fri, 05 Nov 2021 04:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lLasoDXteJ6yCWJ/fkDPhxFRgMJi2Ca3xnwEnWyCZSY=;
        b=fEP1FvL6hI4e4ly0ypWDAEAFF4TjRADk4FJn5nQySgM4g/zlOMD7MCjasn/7mBNI8M
         2DjHdafgLudI82SwjLDphqZVJJgga3yrWfDmjTWTred+DoIzj3+twUH4+yX0hok6budm
         z2t2ZoEzWjqZI5+Am/60ie5NFO02jB/NHwVDkE4fEbjsRySYAQOfm/tGaQRPC9hFJKWn
         6bZZh1CkKX/jiL001DiGzZBF+v9sW7Lz4MACErqBQFvopzLrMAU4L9zXfEwZuLM9a5TN
         5KQy0gj1hvmP41nlMNf1h1Me+/S+EiVQzJ23rScpjZpGo7tDb42pfJ2VYUmkEAcyvQ21
         aP7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lLasoDXteJ6yCWJ/fkDPhxFRgMJi2Ca3xnwEnWyCZSY=;
        b=zLOoFb2CzColhbJm4pO3wv8JwtRBm99BTdxmbQbd0f7/D5xugeymTy0NB3lJOeg8MZ
         tGTzqVHV7fEa+E+cIYWcjVfIZin/dYB/TBhUxLFKctfmst4Z9lbJd7o6Und1/8dX5r7P
         kyx/CiD7S/V28Uv6Wm9m4WFlBXGjI/JVI1FjDTnSUJzLU27m0UHcFeiQjW54dTDHVsvQ
         unZ82Q+88RdgCt54kONMmRAjJQ3fTY1IHm8cxAdjhrlJ3ktFU591dkaptsbYMSlYlC3D
         +WwTO4+arMKL3x57yotqGtV15INAhkL1Ud9Lqw8i6kGwLOljw5x6+oq+VQ17s9nAQ50j
         0twg==
X-Gm-Message-State: AOAM532+HNEXuH+90MP9k5Q9x0dFhjhc+aw8jtj7DEMDXfHwouX5ejaT
        zxugf1SEr9sF11JYJld2WRCKUSYN5HGGa50l+BpqPg==
X-Google-Smtp-Source: ABdhPJzq0BaOa058DFQJJDw3h/QtZh/nLxESwB9XcX7uLp5U/XARA4QlG6oo7FVBvJ/KCp7fLVAYxBIAoa4G0D93Bds=
X-Received: by 2002:a50:e184:: with SMTP id k4mr77580788edl.217.1636112205965;
 Fri, 05 Nov 2021 04:36:45 -0700 (PDT)
MIME-Version: 1.0
References: <20211104141158.384397574@linuxfoundation.org>
In-Reply-To: <20211104141158.384397574@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 5 Nov 2021 17:06:34 +0530
Message-ID: <CA+G9fYtrX8NdfyPFY_R-vGz0Bd-Zmcvk9HApNGSYWz58Yq3rOQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 0/9] 5.4.158-rc1 review
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

On Thu, 4 Nov 2021 at 19:46, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.158 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 06 Nov 2021 14:11:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.158-rc1.gz
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
* kernel: 5.4.158-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: f4b30ec4660320a284634b244975523964b581bb
* git describe: v5.4.157-10-gf4b30ec46603
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
57-10-gf4b30ec46603

## No regressions (compared to v5.4.157)

## No fixes (compared to v5.4.157)

## Test result summary
total: 91815, pass: 75798, fail: 826, skip: 13900, xfail: 1291

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 289 total, 267 passed, 22 failed
* arm64: 39 total, 39 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 20 total, 20 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 36 total, 36 passed, 0 failed
* riscv: 24 total, 24 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 39 total, 39 passed, 0 failed

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
* perf/Zstd-perf.data-compression
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
