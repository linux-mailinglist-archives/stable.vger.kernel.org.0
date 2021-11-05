Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40D884462F9
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 12:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232723AbhKELu2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 07:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232713AbhKELu1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Nov 2021 07:50:27 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 115A7C061714
        for <stable@vger.kernel.org>; Fri,  5 Nov 2021 04:47:48 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id f8so32268309edy.4
        for <stable@vger.kernel.org>; Fri, 05 Nov 2021 04:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XTxab8i7yuKvcX/MconQlN8sr6y6p4GmfklrCzCyM6c=;
        b=ysPYLTWmuPHnL+KutMlfyXqmuUY3M1OMLQVPUpG2ToSOVV6oyhgpEx64+2hokaSxtz
         NKi/q5SB9QyujeTAGV4x2P1z77ynWsxTaGvV5HxlEHfrAtAw58BI6LbaZq7t/JadUNRH
         EY3VPum3/BK3F2G5JQeYRYX1aQuz3YCOaSgpDnXtYwiH+X4M3WNFxAXehvU90zVyT+9O
         UnN/T/6kU8zKjRjsOdrs6UyoHAHz8lzhsodEo1pkRDUyucxn86kwyZ8z9AWj0A9/5XaU
         4EvFXynmDvUMUMuKtM7dzqpdCyEiCSGEHm4LpUkFDxVPxVFT5nI4fIlSS/UF57HMc1zL
         kc5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XTxab8i7yuKvcX/MconQlN8sr6y6p4GmfklrCzCyM6c=;
        b=fV6w7AZZ/80qQU9MOSK0BLTizRqoxvC0s/hZv/EDSFDLXMfOX8MYY3PZDPPRa5C4KC
         +P0WdZYV/JL70/YoOVNx3ClRBM9Q5VbiuM4153fPcjBQVQPfe6WuJalrSnI5WAy0YVsS
         nNIQ7NK7qhHcdv7GH3eJg3/WlTggZyzTr4VvdKN5xfARSb62HKdcQQreuaai8m4N7o/R
         G5xZEXiOl7VVQykdAVqj3OwepqeUGpSbJXuK867FMT3z9iLVKUc1UESWMG7yXSPlYDmd
         Vf18cvzg4gJmQl9ceYWwribLscgoKwfdNzC7gv43HJM2ewFfI7SAtZkNwjmQaXGZ/XLw
         A78A==
X-Gm-Message-State: AOAM532ISSl4XhYB/LYpsf49Gd/VzXq0+vZgVDy47L6+efUaPFSnSeSZ
        DBjY+BxMFAEebP0GVSU/GWUmVjlFSrYSkVolclXC2A==
X-Google-Smtp-Source: ABdhPJwUid9aeskkGBdwmeVcBs8DWltFxHmlSxKFW0Vc1rM66dR7IlhUhNmq/f9Ee71Rv/sWuAxn9nP/EnoBtI3KdT0=
X-Received: by 2002:a17:907:7f90:: with SMTP id qk16mr10615099ejc.169.1636112866242;
 Fri, 05 Nov 2021 04:47:46 -0700 (PDT)
MIME-Version: 1.0
References: <20211104141158.037189396@linuxfoundation.org>
In-Reply-To: <20211104141158.037189396@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 5 Nov 2021 17:17:34 +0530
Message-ID: <CA+G9fYvLsOpFPkCD5czxfwz8TuVcmAbmk1Wm1mU0Jbz73bDuGw@mail.gmail.com>
Subject: Re: [PATCH 4.19 0/7] 4.19.216-rc1 review
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
> This is the start of the stable review cycle for the 4.19.216 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 06 Nov 2021 14:11:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.216-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.19.216-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: afcee5295c1e9b8651e30edeac3014a1049f15c1
* git describe: v4.19.215-8-gafcee5295c1e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.215-8-gafcee5295c1e

## No regressions (compared to v4.19.215)

## No fixes (compared to v4.19.215)

## Test result summary
total: 77617, pass: 62224, fail: 825, skip: 12865, xfail: 1703

## Build Summary
* arm: 130 total, 108 passed, 22 failed
* arm64: 38 total, 38 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 31 total, 30 passed, 1 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 27 total, 27 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 22 total, 22 passed, 0 failed

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
