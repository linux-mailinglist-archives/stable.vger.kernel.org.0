Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCE646660F4
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 17:50:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbjAKQuF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 11:50:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232926AbjAKQuC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 11:50:02 -0500
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A6511C2B
        for <stable@vger.kernel.org>; Wed, 11 Jan 2023 08:50:00 -0800 (PST)
Received: by mail-vs1-xe32.google.com with SMTP id i185so16344623vsc.6
        for <stable@vger.kernel.org>; Wed, 11 Jan 2023 08:50:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c06q7Fj57CAs5lFLpRgHaQZHKGNjLTDnde3ARKQh2IA=;
        b=Sc9I5cNm7pkDNxYXsObVjnMUNUZcyzfizODDVP/Q3lGn6qJJ6Yeul+s80nch9p42qG
         5GR2SbUsFX4KvorpUA9NQ9ywig82Zk89dcETvWPg8LT2cPhipGzzJp3SCD1CPFBBVOPi
         S0BUVvp0drAKAjatDJUKjaP62x26uN5ZzGX6QGtoQbRpF6XmOnFX9aS9GMJv5ROyKxtI
         xa5Np/J2f34PQI0Bmy3TAJhxNc+LPqy2KxXNvNjzXCQxX5xe2UIWMAWz9r41WRGfN3r9
         dihRiYUgo5b84QX9qmeMfgMck83S7IqHH3Qte2Px9EQK6eQmmk13ZXENCPOdkDkd8uk5
         X+cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c06q7Fj57CAs5lFLpRgHaQZHKGNjLTDnde3ARKQh2IA=;
        b=u8+j/JdNov+HjmwYJP1uhjPAgPlKiG95lWAI9o6trt8Db6ubrwW8DkinA3uTsPhNO5
         RWBPXWRhXc4FOEFZY6jqnfQ+FvxG8uJnZSZuVYg7w+LSvp66xHeQx05yityZOobxtK9t
         Vmf9d2QH9qhjchKnhAuNY4yms/C9qA51DILz6+M1T3aSnt5BfIb0F8AchIsByr5XX1zT
         qNlilXKeXJZYOb7yaoLCwW4/jBhz3JXFscnWnKO9BfrtF5AymymIxPqCRWkyZUsAGTnR
         Lw2/NfjvdS0sc43cwDMQMPRczPWEMAwbEKuJ0WSCv/VKMRA00IwrJawt5WukhNIDK0VY
         Q9Aw==
X-Gm-Message-State: AFqh2koHE8Ib5WNiDeFJ851XHvhELFvZdDKabg9eVQxZ7NlsuUIDvNsb
        TiWlHf/ZR+qdhJeLCG7NAU7/kJbeGJNPUF/HcK/w6Q==
X-Google-Smtp-Source: AMrXdXsdW/eFsF3QAm7+LGBlxkFvVtaitIjRBaku04sp1p5AdQfn981S+UweIZPGH4rS5OUs3W/GgsFx2EPrTEuez7A=
X-Received: by 2002:a05:6102:c4e:b0:3c8:c513:197 with SMTP id
 y14-20020a0561020c4e00b003c8c5130197mr7644776vss.9.1673455799584; Wed, 11 Jan
 2023 08:49:59 -0800 (PST)
MIME-Version: 1.0
References: <20230110180018.288460217@linuxfoundation.org>
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 11 Jan 2023 22:19:48 +0530
Message-ID: <CA+G9fYuLC+qMFYOCUwonVGs-a0OAfUdazwwnDHWTQmBe7WYM+g@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/159] 6.1.5-rc1 review
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

On Tue, 10 Jan 2023 at 23:44, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.5 release.
> There are 159 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 12 Jan 2023 17:59:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.5-rc1.gz
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

NOTE:
Regression reported on FVP details can be found in this link,
https://lore.kernel.org/stable/Y76ykHsQcyusWNah@debian/T/#m9dd9798da554c58e=
5634205de1cb4203d065a177

## Build
* kernel: 6.1.5-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: 06bcfb15cd3bb7bfcfa0b06528b2ba3013d2d17b
* git describe: v6.1.4-160-g06bcfb15cd3b
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.4=
-160-g06bcfb15cd3b

## Test Regressions (compared to v6.1.4)

## Metric Regressions (compared to v6.1.4)

## Test Fixes (compared to v6.1.4)

## Metric Fixes (compared to v6.1.4)

## Test result summary
total: 183653, pass: 152799, fail: 5075, skip: 25752, xfail: 27

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 148 passed, 3 failed
* arm64: 51 total, 50 passed, 1 failed
* i386: 39 total, 36 passed, 3 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 38 total, 32 passed, 6 failed
* riscv: 16 total, 15 passed, 1 failed
* s390: 16 total, 13 passed, 3 failed
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
* ltp-ip
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
