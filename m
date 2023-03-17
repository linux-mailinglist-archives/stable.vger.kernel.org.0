Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 636B86BDE47
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 02:49:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbjCQBtz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 21:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjCQBty (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 21:49:54 -0400
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB668682
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 18:49:52 -0700 (PDT)
Received: by mail-ua1-x92e.google.com with SMTP id ay14so2411873uab.13
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 18:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679017792;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v0NbEojGA+vmVWgCQ8nPj2yRSUaYaD5X4ms1AH9cdNM=;
        b=LC80W4bZUJI2oLW3+0+jUra8vA4kweV5de1BEYZUXuVi+a8uy/euvM5stt6a6D8pzR
         r8CGOnkF+ecXvjuojYkpOu6dzJ6BLzwHzM2riT3lmZvFxkBegkszcXfpQnZI7+3uwR1l
         fdbR1EXbRoNEdxhs5ytM+avDTg65pobuXhGMk/dQ7+uO5B2sZLN8z1XUyDGqKiadf/45
         bTHFJq/2/j0hWmRjfdRNauubAaYLRWVsm0lhxkJTkvpX0C+tT8w5d5d/RIEnioGhzsxL
         cn48/Cr4mcw7n1AFVyRJv3YXWuxFPzbaf7eHANceI06GhB25lmmQ5Jr6h2J1QcPPuF92
         irgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679017792;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v0NbEojGA+vmVWgCQ8nPj2yRSUaYaD5X4ms1AH9cdNM=;
        b=C8ToDOwLFCXT5+69nyeYYr9+1yCK/yZXnZCpGbYjLsk1LMkKOa9Kmp3bKxuCsrBbbP
         5xegjOk7LYr4kzWEw5iFz2VhqVTPSDdZYgVwr2I1lyhSBEx5LV8lDsATfow/2GjdNlfo
         72jyxab9yTNhYEJms809RzuoGfHAEqyA846PIoCkNlnyFlukg7g7dbabbMZTP2kUHwTk
         l5Dn27wp9uibkiiamX6EruvSKwF0QXFwo1yr387nP0r0iwnkh23WbxJbW8iqsIokzrtP
         GwnlukZmL6W2GekHlS1Npr9ZfdkLpzv+ICDAeuNzN99g8qOvXCE+tnD336UnY/SCyCo7
         Qr5g==
X-Gm-Message-State: AO0yUKUHnwJW3FFq8mpR0gpZZrjKiFrfzQQC8PuqqHpiZRqzIwH2Jz+D
        lVQUv9cB1tTc2Kvsp1Ld0/eggJilK4iXCZ5nFqb4RA==
X-Google-Smtp-Source: AK7set/qzFE+noVy2CFbGGqgTPsvWJHb7F1YUcPtah+pugW8UZ0tJz8vfd19RGkUu0Jea0g9jEidzCcAq9/5jZrSpfo=
X-Received: by 2002:a9f:3104:0:b0:687:afc8:ffb9 with SMTP id
 m4-20020a9f3104000000b00687afc8ffb9mr31309728uab.2.1679017791771; Thu, 16 Mar
 2023 18:49:51 -0700 (PDT)
MIME-Version: 1.0
References: <20230316083444.336870717@linuxfoundation.org>
In-Reply-To: <20230316083444.336870717@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 17 Mar 2023 07:19:40 +0530
Message-ID: <CA+G9fYu62rdAjiDpJjFsSTHk4qMpwx+gHrnDtKgevuh-xqHdhQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/140] 6.1.20-rc2 review
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
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 16 Mar 2023 at 14:20, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.20 release.
> There are 140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.20-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.1.20-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: 7887563347ee26d8ffb29c637246e923d4d71a0e
* git describe: v6.1.18-146-g7887563347ee
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.1=
8-146-g7887563347ee

## Test Regressions (compared to v6.1.18)

## Metric Regressions (compared to v6.1.18)

## Test Fixes (compared to v6.1.18)

## Metric Fixes (compared to v6.1.18)

## Test result summary
total: 167364, pass: 147749, fail: 4638, skip: 14593, xfail: 384

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 149 total, 148 passed, 1 failed
* arm64: 51 total, 50 passed, 1 failed
* i386: 39 total, 36 passed, 3 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 38 total, 36 passed, 2 failed
* riscv: 16 total, 15 passed, 1 failed
* s390: 16 total, 16 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 44 total, 44 passed, 0 failed

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
* kselftest-ftrace
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
* packetdrill
* perf
* rcutorture
* v4l2-compliance
* v4l2-complianciance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
