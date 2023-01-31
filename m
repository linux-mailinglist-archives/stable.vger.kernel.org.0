Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67577682567
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 08:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbjAaHMr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 02:12:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbjAaHMq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 02:12:46 -0500
Received: from mail-vk1-xa31.google.com (mail-vk1-xa31.google.com [IPv6:2607:f8b0:4864:20::a31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 947AC303D5
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 23:12:45 -0800 (PST)
Received: by mail-vk1-xa31.google.com with SMTP id 6so4269573vko.7
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 23:12:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5//sUDN7aAa+/fdAa54DT1YY07Np/vQiCEXU20HW7A8=;
        b=mp5Sv6Mm56vPapy+tjZGh3nfS/GG1pk5KRXs4RHrdXQKmMyifRidlaN5LS2Z994ec1
         bENSN1Ztt56ZOpibf/EraXbQvDF+tXBOY6yLj1ZxQDVy3zyZYs0Jof8T92/hxDyFn7Fa
         W3Vau43jZKssGvJEUrOekJPF8gPn7/MpPjeix5hVCSiWyeUlzZ1BBcLIAIlIPYbu9fr1
         jN5Nftzmnq3QF7VHhsAJeG9AvZUnFWSG/JkKnS1IQmgEc1Eqbw+QtfzpvkzTUYdJYTKT
         5Fy+CLYwRZgasA+QhO41c7MVEmt+vV8CNumdTggcuBp3T3/1CXqv6K146hFbLsLbS6i9
         FJew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5//sUDN7aAa+/fdAa54DT1YY07Np/vQiCEXU20HW7A8=;
        b=AjDIASjjymDurn9afXhN3aEyEzyKURTOYcxSeGl+6YZaoYlVT44yg/takpe4e1+oN7
         XJ6mCgXykK1Z+PCE7U7WyNcp36wP2qCIglB2eFY42tGglnMikkZNdF7uv4UmQuO3j7Pc
         zWcPwbDR67FzIyUJWzvi4y0mXxMuF6115WomeZ/JqBZ1oEzC67AFdcXJaqW97BD8Afqv
         YHiWsy1iis3OgXBi2Wa3+BRkudUwpgtBowCZQQcPesBprOO2h7hqmaV4b3r2jzj2RYQi
         kmbe6jB1FOuZovYom1vVziGQ1ypuCXHLF2azzhAo8cpBWU74TzSGJeinV5W2veBXxdPa
         l2lA==
X-Gm-Message-State: AFqh2kqDpbrj2NDcJQQ+KXwr6JGKIl5ODQLrKEfJt1Rk0ddmEsT3gr5r
        sLAjxenVTKFOC+UNHRBrxiIT4//tKMtnkFvwpyT2Ow==
X-Google-Smtp-Source: AMrXdXvjqVMGMbYiTFtTDld6AddwuPV8R5YGhW/eXTCuAwdkRC/HVJ98OdA1IRSeM3saP5w1wvmGnhbD7/CyoLbP1R0=
X-Received: by 2002:a1f:ab92:0:b0:3d5:63ee:dae1 with SMTP id
 u140-20020a1fab92000000b003d563eedae1mr7199589vke.9.1675149164506; Mon, 30
 Jan 2023 23:12:44 -0800 (PST)
MIME-Version: 1.0
References: <20230130134316.327556078@linuxfoundation.org>
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 31 Jan 2023 12:42:33 +0530
Message-ID: <CA+G9fYvGio_rUOQPemEB-jTryPaP=nsfzkCRQY60d=-QoipwAQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/204] 5.15.91-rc1 review
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
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 30 Jan 2023 at 19:39, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.91 release.
> There are 204 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 01 Feb 2023 13:42:39 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.91-rc1.gz
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
* kernel: 5.15.91-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 5605d15db0225e49efaa8f83e03f78a8bee3bb5d
* git describe: v5.15.90-205-g5605d15db022
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.90-205-g5605d15db022

## Test Regressions (compared to v5.15.90)

## Metric Regressions (compared to v5.15.90)

## Test Fixes (compared to v5.15.90)

## Metric Fixes (compared to v5.15.90)

## Test result summary
total: 154391, pass: 127547, fail: 4115, skip: 22498, xfail: 231

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
* kselftest-net
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
* perf
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
