Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB1466C2B26
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 08:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbjCUHOw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 03:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbjCUHOu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 03:14:50 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BD69305C8
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 00:14:29 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id cn12so10258178edb.4
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 00:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679382867;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DMKnA20mFWi0udSf/zybjijsVLooERpPllnHaq0vSy0=;
        b=Z2tptAG0szt5WNjW2A8IMPCmHMgELon3SubWx7AKhDU0xIffe3LnFIrr5q8zLqLI+X
         Xm3dah3AqFbg0NLuY8W5bgOImwQACErjkpj1eA2mPVT9NQ7vpOFtkEnMRtap/XqaswKS
         UY4m4hbod/FsvEt0S4ZUNpDl2npVNjGQATizktgLlCRt1fraCmy+kE7/1bgQ24r9z/Cr
         hnPnxNmaLWJABKci9MgSodgUQR71McHZ5TCKadUna5Rc0FhBYvCXX3nFur8KFr8jWedI
         4qBHhIp1fn52/CcHghUui7oXEkKicjZiH887RIbL6LuEMZXWSwRfluo6vewTAKpzkWMW
         BbQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679382867;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DMKnA20mFWi0udSf/zybjijsVLooERpPllnHaq0vSy0=;
        b=rRtvMXKzukieOd1zLlRqByZowlHSc337mx1D43xyy8ncil/++geljmYDVngObapqAC
         /rJPj4pnpW8TQssOAGbyxy57Mvakgfsj2hCwp3A0CZ1luI+CTwErDPkyGzt+KZZPxjwZ
         5ATr/1hF5R+xNRdbh4y8NtvCNVqA7UIhHUgu6yEWRfMRYk/vU92vCobV3KLRBvhv01xb
         Z3841iKgfWHV7/2dFEck2Ns43aiJHblKjBy1MO5ngOR1N8cGXDv7Tcjf/TcdfGUTE5d8
         vf6U2iuIDFBFwtLl+EBvZY0FSn14x3MzcrGfwnpKHI/E8PcCdkAU9HgimXzih5Xobe3M
         LbXg==
X-Gm-Message-State: AO0yUKVBphUoYKDnN5jpjMtRoWqbyaSEUm9AWPp8mJ01KAvgUVsV5ils
        6jPTgdF8bCHbun+WCo+bKqEwEMqh6O/PSMkyvQXZyw==
X-Google-Smtp-Source: AK7set+7Z7aazmG76t5T4UkCTOEf4hlLtWpVyZGBTI2mG3jrxtWYBAve38VvAviEerfMWdlce9pJaW8edCnz+XxY9SE=
X-Received: by 2002:a50:9fad:0:b0:4c1:6acc:ea5 with SMTP id
 c42-20020a509fad000000b004c16acc0ea5mr1104322edf.4.1679382866821; Tue, 21 Mar
 2023 00:14:26 -0700 (PDT)
MIME-Version: 1.0
References: <20230320145420.204894191@linuxfoundation.org>
In-Reply-To: <20230320145420.204894191@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 21 Mar 2023 12:44:14 +0530
Message-ID: <CA+G9fYsiKyJYQnRf8fJi_27bOTZZtskOQ0-=H9cf2McH5CgPOw@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/30] 4.14.311-rc1 review
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

On Mon, 20 Mar 2023 at 20:26, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.311 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Mar 2023 14:54:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.311-rc1.gz
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
* kernel: 4.14.311-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 771f7d636cc99d7d29357a63b34dc212c76c2e16
* git describe: v4.14.310-31-g771f7d636cc9
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.310-31-g771f7d636cc9

## Test Regressions (compared to v4.14.310)

## Metric Regressions (compared to v4.14.310)

## Test Fixes (compared to v4.14.310)

## Metric Fixes (compared to v4.14.310)

## Test result summary
total: 75642, pass: 64390, fail: 3110, skip: 8031, xfail: 111

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 199 total, 197 passed, 2 failed
* arm64: 37 total, 35 passed, 2 failed
* i386: 29 total, 28 passed, 1 failed
* mips: 41 total, 41 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 20 total, 19 passed, 1 failed
* s390: 15 total, 11 passed, 4 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 34 total, 33 passed, 1 failed

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
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
