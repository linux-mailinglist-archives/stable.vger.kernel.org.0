Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6421E679122
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 07:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjAXGkJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 01:40:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233412AbjAXGkC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 01:40:02 -0500
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE6311043A
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 22:40:00 -0800 (PST)
Received: by mail-ua1-x936.google.com with SMTP id i23so3463271ual.13
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 22:40:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PCwYwHkcMziQQpLoqfobwGZKVeKGkLMrHFailCAo9m4=;
        b=o/58jFOA1F/vxfSDjvg0JVuxH6TB8CvB9OwYl8QuadE2r653dIG847vrSpUS6jjnWO
         8u6tkHR1SCUHYA5aErHol4wDYHuGUfiquCawZNg0+ztyMOKpxMwiwzNEHwBXjn3e4wkR
         VsTqNGB11HzLoZdu34Tj6+iR2VCM4J4ThwGssobR4KOcv+wnqZSUvkweDnvJ2OkgDpot
         zaZ7LLzBcEN+H/Gf37RzzlWQ4oYPaeooFBxzi4DR7gPUQd2MVf4zgGtfV8Uz5F95Jlgi
         Pcvvxi9XOtIDT+khoCrrQXNAOFqC2/ru+xuVPjbl4agm6al5+g2Dfofsrcmi/YqRR8fk
         zk/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PCwYwHkcMziQQpLoqfobwGZKVeKGkLMrHFailCAo9m4=;
        b=bWwr0OB/1370JJmA3znwvbAFszAY6FJLQ2fS221cEJvrxyjyP8QWAnU4tuHODZ84Gk
         1FToZ0mHaxUxXYa/HJAid6kGxtHxrDjRHtBk8yw6OvAZhMj4HBrRpDiKx5KbHx4wXZ70
         Y51RU1n+Z+BRaKg3eCQ52EnVnRpwbtpfAEMbXovsxsx5hXpxmCCPkPf8DYPJzeLk1GZh
         yHvROeXUOw0bHQrOpRtY3Yyo6IUNBdhl/I15/qpodgma9exF6plb2eWQyVmQScx/Y3mf
         efUsjj3lhXB9YhjGGcUKRx6bNiHsQjPnaF8QUfXq54+m6IDxz1/89cJ+6QpOpBGWMndA
         2LSA==
X-Gm-Message-State: AFqh2kqERtOGusZ0hHWiQxlNGldw6aW36wSfNO/hIfpXgfYRUIbqtcY0
        MIKaIK0cfDbCeHC6JQ9tV86c3Bfxf5pAGn9Pmv8wlA==
X-Google-Smtp-Source: AMrXdXtYo+BdyqSpF03WpQ0MIt5Vfp8G3lgEqHNbGWIcoFMg6UNrsn7XOcQfInyoWy/1ElMalne4SUCwT8u6sSgaK/g=
X-Received: by 2002:ab0:60a7:0:b0:628:73c6:a79a with SMTP id
 f7-20020ab060a7000000b0062873c6a79amr1858500uam.92.1674542399803; Mon, 23 Jan
 2023 22:39:59 -0800 (PST)
MIME-Version: 1.0
References: <20230123094918.977276664@linuxfoundation.org>
In-Reply-To: <20230123094918.977276664@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 24 Jan 2023 12:09:48 +0530
Message-ID: <CA+G9fYvX45uU0+Dz2Gv_sTsx8PYZDT7nifJU6soO9O-Az-c-2g@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/117] 5.15.90-rc2 review
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
> This is the start of the stable review cycle for the 5.15.90 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 Jan 2023 09:48:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.90-rc2.gz
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
* kernel: 5.15.90-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 60931c95bb6db9ce421e75a907a245f828c11243
* git describe: v5.15.87-219-g60931c95bb6d
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.87-219-g60931c95bb6d

## Test Regressions (compared to v5.15.87-101-gbe338c42efd1)

## Metric Regressions (compared to v5.15.87-101-gbe338c42efd1)

## Test Fixes (compared to v5.15.87-101-gbe338c42efd1)

## Metric Fixes (compared to v5.15.87-101-gbe338c42efd1)

## Test result summary
total: 160151, pass: 129328, fail: 4546, skip: 25944, xfail: 333

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
* packetdrill
* perf
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
