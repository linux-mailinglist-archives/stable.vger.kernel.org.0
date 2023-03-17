Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C200F6BDE32
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 02:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbjCQBiQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 21:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjCQBiP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 21:38:15 -0400
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33059AA263
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 18:38:13 -0700 (PDT)
Received: by mail-vs1-xe2f.google.com with SMTP id c1so477920vsk.2
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 18:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679017092;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bBn6JQBx1SHJKZPB8zhAUv5Fuj/NGhkfmZs2i9hUcgA=;
        b=FG1EYVYdASOEs5PEIu0lXb6o34qMOplqYGGprFQXDnyCxeLmik+TqdNAFKcbg87hTz
         daK8DPDMhSS4Oi+3xE0uH3JIsQhaqoZL1TqjyfcgUK2sijfi5Lw+Wr5kDbLpijtd/1Wh
         QTmnGVCczewvFTbfMIPTK3p1WgraxXq+VkCTrwZ6zdrtj7RbOuI73jIcYOexOFWSK8at
         JVvxK6esPsN+14+2CHOQp0Y9utSBH7nd+HZwOFU3cdpSHxprv7fKWaEgdWLdadDoJQ7u
         VpRNa+FM2/3mwCbefIQGgtKgL0jJMHvjEa2Bg8t6GoSLrd4mRSR/SlT1TFS6gnDVeAW7
         xQcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679017092;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bBn6JQBx1SHJKZPB8zhAUv5Fuj/NGhkfmZs2i9hUcgA=;
        b=nTiuxEsoQKKl9tpAV+RGksdVCTAJ52/ArMZrXqbMAaHjVSqfRGh160q5EpxyF4Ho/L
         TCAk0wOdmzi0lKusgDihzwOKBWucY+KDaFSMdtg3DvusFQPooUG5yeSv6YuADxJ3p92U
         NmVQG7TnaVo0eCXGvZ8RGTcoAPTLNNqcO4GmuX32jI5KaVGqPyPRxrZJCAe7eVNUqX1w
         ASzP4Q5WtqrGLNkH5+35HvbUBb0+EwT6AznVQKdXix1ZpL9zNc0LndKR91SewMZtqwQp
         0ez7hq9uGZ9xMvF9o7frqFPyVi5lXV0aJyfCXCR3NL/ZEZFTrEYhfoYGZmhW5OBMsoY1
         U3pQ==
X-Gm-Message-State: AO0yUKVoq4m//uaGvtl/3xJ63m30b9J86a0V1hnOLKDEaC8koNrHmDMJ
        BoMZTzHBHavmxSSI1E6ZRDbrGYgYFQHk6BSNwlw8vQ==
X-Google-Smtp-Source: AK7set8YSeusCd3ChZiDth1ZhkI6JI9Z0uq4CmeAATOagrzse4aeQHdjPRsmr+k9SuLvkMvvlZcIWBRnIAwrQievH/0=
X-Received: by 2002:a67:f8c7:0:b0:412:4e02:ba9f with SMTP id
 c7-20020a67f8c7000000b004124e02ba9fmr30451280vsp.1.1679017091998; Thu, 16 Mar
 2023 18:38:11 -0700 (PDT)
MIME-Version: 1.0
References: <20230316083443.733397152@linuxfoundation.org>
In-Reply-To: <20230316083443.733397152@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 17 Mar 2023 07:08:00 +0530
Message-ID: <CA+G9fYuErbJtY68zb32gkggNb96GRznoLS7OLfDSqBDD6-eJBw@mail.gmail.com>
Subject: Re: [PATCH 6.2 000/137] 6.2.7-rc2 review
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
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 16 Mar 2023 at 14:20, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.2.7 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.2.7-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.2.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.2.7-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.2.y
* git commit: 2756d84ffc14891b590f8d8e516ee60adea3b3b8
* git describe: v6.2.5-143-g2756d84ffc14
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.2.y/build/v6.2.5=
-143-g2756d84ffc14

## Test Regressions (compared to v6.2.5)

## Metric Regressions (compared to v6.2.5)

## Test Fixes (compared to v6.2.5)

## Metric Fixes (compared to v6.2.5)

## Test result summary
total: 190311, pass: 163849, fail: 3908, skip: 22192, xfail: 362

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 145 total, 142 passed, 3 failed
* arm64: 54 total, 53 passed, 1 failed
* i386: 41 total, 38 passed, 3 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 38 total, 36 passed, 2 failed
* riscv: 26 total, 25 passed, 1 failed
* s390: 16 total, 16 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 7 passed, 1 failed
* x86_64: 46 total, 46 passed, 0 failed

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
* kselftest-exec
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
* kselftest-user_events
* kselftest-vDSO
* kselftest-vm
* kselftest-watchdog
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
* ltpa-6278247/0/tests/4_ltp-fsx
* network-basic-tests
* packetdrill
* perf
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
