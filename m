Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A277364EA5E
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 12:27:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbiLPL1Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 06:27:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbiLPL1Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 06:27:24 -0500
Received: from mail-vk1-xa29.google.com (mail-vk1-xa29.google.com [IPv6:2607:f8b0:4864:20::a29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCB8B4D5E1
        for <stable@vger.kernel.org>; Fri, 16 Dec 2022 03:27:22 -0800 (PST)
Received: by mail-vk1-xa29.google.com with SMTP id x65so969813vkg.11
        for <stable@vger.kernel.org>; Fri, 16 Dec 2022 03:27:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZkdA11L6P1WPDBE1mrl4curSBheefLQYVgKHrgovhvw=;
        b=epgTZV18v5BRFirasNVaS0xStlOh43QI6CHisgNYFFoP1YfmVsa7CogJmcQQTCR5Xe
         fxCSn2VUSIylQgEByhYckyYrAbluS/bXcy05m2WSYKaBs10diDg6Ej7Xksk/n0jfk49F
         mWCGlTApwKmadLsh9IB6OImDEEKQoLm1qw8Xe/YmfgXYFIi7Ld+rUkO4MfXW8wMnOxeR
         P2xE7/Vi7KmZezSUvZysWDg8qwzXfY7QjOPupH8Bbi4YTdhUSTJRprkfRLDo4aqdbpaZ
         QGS9Lha2g7uf4N0uFJHkacgiBCk+CxXaxAFv0F7xMo2wUm9DRhrD8l8LSze4mwemJrTL
         9Qaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZkdA11L6P1WPDBE1mrl4curSBheefLQYVgKHrgovhvw=;
        b=QnVNggdFR5JndEbvuVJ6+JLU5jn0jJkLDI/FM6NrbZvs/solyjP3hirl4LenwVcFDC
         rsAm1muzSczPp2Nc704Go3vyT0vZ75UtglVoxPnOjUtiVNBTkiOts/Xh4NVOFSBoKY3Q
         h8Ovf5F54VSiiAyL4WoaKJ/Ia89pUoTRsrUndYsSt+1ovLR5j+luZLRGHTc+WD3CsiLz
         g0e+h0a4cTGYxSgsxLmkwkcvrhN8tpaPO3KEsfWsYe8+uKCCfjLCbOkVfNouJOSc2ZRV
         L6s4t8Jf2Wp+WUHdtRGbV+4U1OqxlFI4ttdAFKSH2kzkNIITeIVIu9D52SopOkHom4Qh
         sfNg==
X-Gm-Message-State: ANoB5plQ6/JR84Fa3gPRqY0Pciukc3DmgvG6+4Ky1pQiq2AOje4eVVi3
        pDZIl9vCk0yL5RGIKc2MqSRTN8LzHU2N0SLrpcljEA==
X-Google-Smtp-Source: AA0mqf7FamBckNuL80bbGypsOgPVSYrYJ9tNTUEuT4ATfS0wx7IGlkjf6W7wB3bmSeTusDBI0KllAUVN+e2BuNToBrk=
X-Received: by 2002:a1f:3846:0:b0:3bc:c843:c7b5 with SMTP id
 f67-20020a1f3846000000b003bcc843c7b5mr33399911vka.30.1671190041699; Fri, 16
 Dec 2022 03:27:21 -0800 (PST)
MIME-Version: 1.0
References: <20221215172906.638553794@linuxfoundation.org>
In-Reply-To: <20221215172906.638553794@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 16 Dec 2022 16:57:10 +0530
Message-ID: <CA+G9fYt2O6OZAbZ4rfVDJfWMi27OkMCEhTLyRBRPZuXucaSZzw@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/15] 5.10.160-rc1 review
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

On Thu, 15 Dec 2022 at 23:41, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.160 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 17 Dec 2022 17:28:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.160-rc1.gz
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
* kernel: 5.10.160-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: a66782e1af759c5fff50b1b382ff4e34fe8fe158
* git describe: v5.10.159-16-ga66782e1af75
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.159-16-ga66782e1af75

## Test Regressions (compared to v5.10.158-99-g2c8c8e98b2ec)

## Metric Regressions (compared to v5.10.158-99-g2c8c8e98b2ec)

## Test Fixes (compared to v5.10.158-99-g2c8c8e98b2ec)

## Metric Fixes (compared to v5.10.158-99-g2c8c8e98b2ec)

## Test result summary
total: 141503, pass: 122877, fail: 2557, skip: 15573, xfail: 496

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 148 passed, 3 failed
* arm64: 49 total, 46 passed, 3 failed
* i386: 39 total, 37 passed, 2 failed
* mips: 31 total, 29 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 32 total, 25 passed, 7 failed
* riscv: 16 total, 14 passed, 2 failed
* s390: 16 total, 16 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 42 total, 40 passed, 2 failed

## Test suites summary
* boot
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
* perf/Zstd-perf.data-compression
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
