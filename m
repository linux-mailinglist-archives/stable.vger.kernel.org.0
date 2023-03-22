Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 324156C47D9
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 11:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbjCVKnF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 06:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbjCVKnE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 06:43:04 -0400
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 140838A76
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 03:43:02 -0700 (PDT)
Received: by mail-ua1-x92f.google.com with SMTP id p2so12293544uap.1
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 03:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679481781;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zWIfm8SVDkTKI9ViVU3tx16H6A9LBzPzgrDU3mJSn9I=;
        b=aoud6el4BR9ejtkWiXguKp6tnrawQLb18JKrETfYB9OKoY8aunkiEZ2poeM88qn77v
         BPEJsbFSUzDg2eulI4WgG7lMKpskFVbu0QqGX0/8snR8Hj/9SDOG5r648sKSM4ncLAui
         ZdIC4OtyuFONaRPETZI2JTA7Au5c8gN+JaSjuvvygdhOOkRCzeBRweaLKm9i1AT6U/bY
         xI9I2NRhmJ1ko3BxyqBT6OuLm8PEbKDpFiJJTVqwtBhMgEKEQ83fdEIjuQ4XJjTFtxt2
         urgAayzSkYL+LJmHshE2TiRCn1GT+0jh4WMcA+q2AjwXA69c6XbzlUgHxpIUb17tniiv
         7gUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679481781;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zWIfm8SVDkTKI9ViVU3tx16H6A9LBzPzgrDU3mJSn9I=;
        b=FyCD3LV8QubrpAcnJqJ6j1+nqtaX0/wc2zhiXAa5LCSuw97UkM2Nv8+6rDrhdYVTRz
         TG1FetUM8085vEUC/KZnOOtdPGChIWpR3bvVpw7/vAZu+fMPvFdb0B8OxEDHKCrHiJjv
         o62shGSoCP0GzLqpTSXHNnUobhAA1Hhc0Qil0S+E1LIffcxnfMJZnxSRoqaAZRJ2GpGY
         FVXp6bto2QzRAiIBbYh1Ufqqd6PsCFE33dpVVX/fQ64ZIK/beqb6GTDe4mrNT5u3HTry
         rX+X/b3hAtSG+NoJw8PWBlXNdoCcvkZCDokxQw/qkzGM3HPcbap3YSEdt4xLFStagKqX
         /Ing==
X-Gm-Message-State: AAQBX9fJGy9aERcPpF+TlAiNgcl4hAePISkYoCtFnboNbjslW1Yc/4XY
        hvZCdAeY5D8Hm/of92hSsGCcxbrEAvp3/debZ8UnEw==
X-Google-Smtp-Source: AK7set8Pu4zFLx2g7Ys7jY0o+nIVqPLyI6iOmqkGLBZOkHO6gNL/N3MVY2qi6f3tHPfHC7qz3jijZ7e0ra7UIq9NJ+E=
X-Received: by 2002:a05:6130:c0b:b0:755:9b3:fef8 with SMTP id
 cg11-20020a0561300c0b00b0075509b3fef8mr2412705uab.2.1679481781023; Wed, 22
 Mar 2023 03:43:01 -0700 (PDT)
MIME-Version: 1.0
References: <20230321180747.474321236@linuxfoundation.org>
In-Reply-To: <20230321180747.474321236@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 22 Mar 2023 16:12:49 +0530
Message-ID: <CA+G9fYv1eB4JuhhSJORopQ2mUkXESuZMdEeYyypPLSKbdjYxgQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/199] 6.1.21-rc3 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 21 Mar 2023 at 23:38, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.21 release.
> There are 199 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 23 Mar 2023 18:07:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.21-rc3.gz
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
* kernel: 6.1.21-rc3
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: 2152cefff654f81f4c754469a07ac3c6105ed4b3
* git describe: v6.1.20-200-g2152cefff654
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.2=
0-200-g2152cefff654

## Test Regressions (compared to v6.1.20)

## Metric Regressions (compared to v6.1.20)

## Test Fixes (compared to v6.1.20)

## Metric Fixes (compared to v6.1.20)

## Test result summary
total: 174778, pass: 151098, fail: 4548, skip: 18729, xfail: 403

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 153 total, 150 passed, 3 failed
* arm64: 55 total, 51 passed, 4 failed
* i386: 43 total, 38 passed, 5 failed
* mips: 34 total, 32 passed, 2 failed
* parisc: 10 total, 9 passed, 1 failed
* powerpc: 42 total, 38 passed, 4 failed
* riscv: 20 total, 17 passed, 3 failed
* s390: 20 total, 17 passed, 3 failed
* sh: 16 total, 13 passed, 3 failed
* sparc: 10 total, 9 passed, 1 failed
* x86_64: 48 total, 47 passed, 1 failed

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
* ltp-controll-controllers
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
