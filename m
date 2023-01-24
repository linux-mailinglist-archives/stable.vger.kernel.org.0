Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 798E66795DC
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 11:58:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233316AbjAXK6a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 05:58:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233097AbjAXK62 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 05:58:28 -0500
Received: from mail-vk1-xa36.google.com (mail-vk1-xa36.google.com [IPv6:2607:f8b0:4864:20::a36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9CE17ED6
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 02:58:27 -0800 (PST)
Received: by mail-vk1-xa36.google.com with SMTP id z190so7409190vka.4
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 02:58:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3AN0CZj1or5oyCoIIviJcOK3a+NvicCbaz4Rv9urqNc=;
        b=vRhWh+Fgiqu9tk/Q+CB5dp1yislUK717FuGM/E4mxRr8C3/E3466AGjMQtKI1JFN2F
         dimH1VrYKI1rHnbxvw/Om6ye5e44IRCvRmcv5j11uqLL9mbe1Tk5u1VCUA5+85NfNTO4
         o8gq65eOigTJbcUzIXu8T0r9GrbLO9xB0piha75W0YAcouWqWLM+dZ/Fdyi3XxfIMmoK
         m4RNx81MXoCwGvQi4aKSYdslTjQy2HC3Gv3Hm6gVR83ps+9sC1dmtaaj7yMFBHGMRPvf
         +O+c4h3oJGUUjOCmR6dLLUDogfT5FHQl3PCdqn6ZLBWjp9Or2bDeYQlp5CU/9giOaWYn
         nstg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3AN0CZj1or5oyCoIIviJcOK3a+NvicCbaz4Rv9urqNc=;
        b=GXoBmjDVznu3DizrUa0cv57Q4Xre9WUrSuVhhApu+uhYxiPi1eIHj2eSNh4tvsNBdw
         vzjwmbucGHocPZy917P6Dxw5NVyFpJdJ66JVs/8H4usBRrBh9rhEmeUWawjOyz9xeqPm
         jP87VFS6PlxQIwHCEvSgC5bIqOkgdo+nJ6iPEidSdBVcZnomkvkzFI0kgj419gewrKBP
         rttGASxZyc82uaWWvM3NXO33sO43xvhr6zMJv59pbj0KWYbfpQuMS8Q6Xm48h53wCrbC
         yZd4MP9KkGXM9JQt818jOI1Xib5fubUojECPQeFtvokrk5s8Dcz9PwVQBurVMg0ur2+v
         d6Hg==
X-Gm-Message-State: AFqh2kr9LtBtYwnO5fz9fMRS7Nsr8U3Qma7Qy5sLACPC5t+uYw2K6jKe
        X5XMSoaa5+UCFWLt5/yJlYsKBSFvEkTEHTzZX4wfdSf2SBxwDhrp
X-Google-Smtp-Source: AMrXdXtNASeAksMLwvaG7RnZsQaQpwgnqfOR9+W+mZyQmfARh+TUKh5vgCVrtPK90D8OaknMuiu+o7bR+9w4kIs+bag=
X-Received: by 2002:a1f:5dc1:0:b0:3e1:9fdf:7740 with SMTP id
 r184-20020a1f5dc1000000b003e19fdf7740mr3558952vkb.20.1674557906633; Tue, 24
 Jan 2023 02:58:26 -0800 (PST)
MIME-Version: 1.0
References: <20230123094907.292995722@linuxfoundation.org>
In-Reply-To: <20230123094907.292995722@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 24 Jan 2023 16:28:15 +0530
Message-ID: <CA+G9fYto2Z1UogmgUSWR0cbQjicQL2qi6S+CD=yK=HwBcefWNw@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/51] 5.4.230-rc2 review
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

On Mon, 23 Jan 2023 at 15:22, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.230 release.
> There are 51 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 Jan 2023 09:48:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.230-rc2.gz
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
* kernel: 5.4.230-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: c4ab8d7671d5c73e2b9882577257409b6364ba7a
* git describe: v5.4.228-675-gc4ab8d7671d5
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
28-675-gc4ab8d7671d5

## Test Regressions (compared to v5.4.228-623-g11f7238df0b4)

## Metric Regressions (compared to v5.4.228-623-g11f7238df0b4)

## Test Fixes (compared to v5.4.228-623-g11f7238df0b4)

## Metric Fixes (compared to v5.4.228-623-g11f7238df0b4)

## Test result summary
total: 131200, pass: 103770, fail: 3090, skip: 23968, xfail: 372

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 150 total, 149 passed, 1 failed
* arm64: 48 total, 44 passed, 4 failed
* i386: 28 total, 22 passed, 6 failed
* mips: 31 total, 29 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 34 total, 32 passed, 2 failed
* riscv: 16 total, 13 passed, 3 failed
* s390: 8 total, 8 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 41 total, 39 passed, 2 failed

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
