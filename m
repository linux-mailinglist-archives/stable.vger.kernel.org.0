Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96D6346B69F
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 10:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233455AbhLGJJM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 04:09:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233462AbhLGJJL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 04:09:11 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ADBFC061746
        for <stable@vger.kernel.org>; Tue,  7 Dec 2021 01:05:41 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id x15so54440766edv.1
        for <stable@vger.kernel.org>; Tue, 07 Dec 2021 01:05:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yfNeVAEJNsPDHBkiUNwx8jk6DdxFu2JbtGVo99AEWk0=;
        b=skETUmDs6gqZjbchWLm1m9wzFOGEIihG4hXurzpWsZivXIT9oZridz+5X0D47WP07C
         pA369q5sF3fLAdbgCuD43DgAW0ZEoYYVGdr/HhdSAUdiG26vwiTZj/eh+cbViobpOJGW
         fq7S49y8e4o66stkFVsXC/YfZ1c9saKWhFReibk1he8c23wVs9ujyecTLcvQ9Ws4u5Oz
         9vXZiVOe5KX4FMYIMeX60w9DEsbL/gMnExFdCS4MKAaFu0O46PjO7PDZUoSUGO8mwYyP
         mtW3coq7bCRDCcPoMwgCvb512Am29SRwj+D6C8gHJWQw1k8wBM3KF92pilxd7WkEnAB+
         Dr3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yfNeVAEJNsPDHBkiUNwx8jk6DdxFu2JbtGVo99AEWk0=;
        b=zvUzEBfQzS6jOVnPcbqvSd5R640bYsdlOR5RE9/aEm8w1Ld5lqouxBludavSGLS8H8
         CYbHptgLXnf5XCQix2IfbQD1CXzDLgeDoBq/tFzq0f4NBWXmCLxY/SrVyd7g0zBLnnMo
         ASLT0t5LA7wf9Kg8gVVDlgEKOhGtCWgqpRFBttaXpOy8mEjrfwcHMFl+3UmHcIl0WHlI
         Pq+5crwx46RmTcZIdgD3FsIpS6gCMqeAiqOngVD0plFfbYwguF3YhntQrFynZgVjgnCS
         RyudPZIlLyyTT8QgXqk/wqTn0ZTx+koqL3XnufZFFCbd5CU0OXlk5FfM0giIVk8Xdvdj
         Prlg==
X-Gm-Message-State: AOAM532dRADQ0ZWPB2HhJtzHSBxiS1Sf3bbQiVpZ3KyxCVRKxLVkgiug
        lqpI4544urxn+Ac434WE0Rm4KFx0qOxi4oJa8AKOuw==
X-Google-Smtp-Source: ABdhPJygMdexfzXj32AqBdFdslv/H/SE7k0xf3caUOLqBlP/MIyTkbteIU7MpQhuRTAVmq7TPo3L8/5CK4hxjNy95aI=
X-Received: by 2002:a05:6402:12d3:: with SMTP id k19mr7207753edx.244.1638867939817;
 Tue, 07 Dec 2021 01:05:39 -0800 (PST)
MIME-Version: 1.0
References: <20211206145610.172203682@linuxfoundation.org>
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 7 Dec 2021 14:35:28 +0530
Message-ID: <CA+G9fYur3vcuyCLMc-5BZfoyTWd7E=1H=otAT35O6+0Zkd3uwg@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/207] 5.15.7-rc1 review
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

On Mon, 6 Dec 2021 at 20:52, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.7 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 08 Dec 2021 14:55:37 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.7-rc1.gz
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
* kernel: 5.15.7-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.15.y
* git commit: 47c02c404f4a01320618263ee704576959e3de43
* git describe: v5.15.6-208-g47c02c404f4a
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.6-208-g47c02c404f4a

## No Test Regressions (compared to v5.15.6)

## No Test Fixes (compared to v5.15.6)

## Test result summary
total: 96420, pass: 81828, fail: 1003, skip: 12755, xfail: 834

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 260 total, 260 passed, 0 failed
* arm64: 42 total, 37 passed, 5 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 40 total, 37 passed, 3 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 35 passed, 2 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 49 total, 44 passed, 5 failed
* riscv: 27 total, 25 passed, 2 failed
* s390: 22 total, 20 passed, 2 failed
* sh: 22 total, 20 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 42 total, 40 passed, 2 failed

## Test suites summary
* fwts
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
* kselftest-mque[
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
* perf/Zstd-perf.data-compression
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
