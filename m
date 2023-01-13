Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE6DB66A122
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 18:50:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbjAMRuK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 12:50:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbjAMRtU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 12:49:20 -0500
Received: from mail-vk1-xa31.google.com (mail-vk1-xa31.google.com [IPv6:2607:f8b0:4864:20::a31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52EB971FE1
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 09:42:22 -0800 (PST)
Received: by mail-vk1-xa31.google.com with SMTP id e132so196977vke.11
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 09:42:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0OKp9P3wlvWQglflLVdMb97bFP7zeKILwFZMB7vI+io=;
        b=YUvhoZPDtOA/dQPmdROCRCT97mbXpZeR78HU7GFGWmrLAinRrfGM9P5BPvJCx7tacJ
         yw6+nbuWOTH4tOGgRmVcTg/uOVdaDms89Q0kwZjFZMG9bf2cAqIwyMDsxocFBQ40MRAp
         Xu/85wKjrfb5ADZi/jdIFPIyZByhCB+aMdbdlW2ml/Eyj8a67FeJFy9bF0SZnCXfaPuj
         LNypzCQHDH1BWiCLUO6t/vgKwjs1vV3o5M1sxRg1ZYVpl/GWZCTMXBmcLewC2vvNDhuU
         832n9FsfPIzn0pjBX39w/NZtw9tLWNtM/pCTJG5pGmZvnt0AJH0a9779Vv5L9wTCGtX0
         LZCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0OKp9P3wlvWQglflLVdMb97bFP7zeKILwFZMB7vI+io=;
        b=OlwjD0rxyhmOiGbYXqUC487ReUAX1tPbSUK26VfCF/VX7CHNRx5fGuLJBYG/kb8v6r
         5GWXTEDOPXYYPUBwU7EfaiXIAsUHkfAzVJqfsvecDnTummGpZmYnvXdJY0VOFl8aX66j
         V4xJ5A3nG7J3r8hm2XjS9duHPvrXK+sPYcgzmc/2WQMatg4DWvW1UoJsR+WJJRMk9OWp
         eBfaQ99+n1+YxAoLjbHPt2EOsAb6LRHxj6iKNwTijpMTXFCSDgxAcwheJrc2Q3cGTIwh
         0hdjl1P8c9ffiYsRVGmAGoKpi0FdoXeqSzyMRS4MzlPYWya7tUV04HoLQFz4lVQ0TyOA
         +RbA==
X-Gm-Message-State: AFqh2kp+oWFikUqaGPcnaFcNfwK8tYYWZ/r4Zrnj7h09yAyg/q28mzfT
        XF0jULlGtlT0H8GmFS8RY8tATAcA1N5ocPvOYwDr4Q==
X-Google-Smtp-Source: AMrXdXs+D+TXEDwYQeE6Ar7RW5jftM2r4ElnktAnD8xg8hJfcF+xbz4j7ShMOSSTswckXGQUPAFeWjpz6ngr3w6b2n4=
X-Received: by 2002:a1f:9e12:0:b0:3d5:de78:715f with SMTP id
 h18-20020a1f9e12000000b003d5de78715fmr5579199vke.7.1673631741277; Fri, 13 Jan
 2023 09:42:21 -0800 (PST)
MIME-Version: 1.0
References: <20230112135326.689857506@linuxfoundation.org>
In-Reply-To: <20230112135326.689857506@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 13 Jan 2023 23:12:09 +0530
Message-ID: <CA+G9fYuMAW8EqwCUwtUwSu7-y=4kj+FU6_vex9GCB8pdVQWNPQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/10] 5.15.88-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 12 Jan 2023 at 19:27, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.88 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 14 Jan 2023 13:53:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.88-rc1.gz
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
* kernel: 5.15.88-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 14a059c00cd899f037916c382498d573e4c5b365
* git describe: v5.15.87-11-g14a059c00cd8
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.87-11-g14a059c00cd8

## Test Regressions (compared to v5.15.86-291-g5e4a8f5e829f)

## Metric Regressions (compared to v5.15.86-291-g5e4a8f5e829f)

## Test Fixes (compared to v5.15.86-291-g5e4a8f5e829f)

## Metric Fixes (compared to v5.15.86-291-g5e4a8f5e829f)

## Test result summary
total: 162543, pass: 135922, fail: 4890, skip: 21378, xfail: 353

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 150 passed, 1 failed
* arm64: 49 total, 47 passed, 2 failed
* i386: 39 total, 35 passed, 4 failed
* mips: 31 total, 29 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 34 total, 32 passed, 2 failed
* riscv: 14 total, 14 passed, 0 failed
* s390: 16 total, 14 passed, 2 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 42 total, 40 passed, 2 failed

## Test suites summary
* boot
* fwts
* igt-gpu-tools
* kselftest-android
* kselftest-arm64
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-drivers-dma-buf
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-filesystems-binderfs
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
* kselftest-net-forwarding
* kselftest-net-mptcp
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
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-cpuhotplug
* ltp-crypto
* ltp-cve
* ltp-dio
* ltp-fcntl-locktests
* ltp-filecaps
* ltp-fs
* ltp-fs_bind
* ltp-fs_perms_simple
* ltp-fsx
* ltp-hugetlb
* ltp-io
* ltp-ipc
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-open-posix-tests
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* packetdrill
* perf
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
