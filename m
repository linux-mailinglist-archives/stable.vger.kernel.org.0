Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EBE869DDE9
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 11:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233706AbjBUKbg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 05:31:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233708AbjBUKbf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 05:31:35 -0500
Received: from mail-ua1-x92b.google.com (mail-ua1-x92b.google.com [IPv6:2607:f8b0:4864:20::92b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF22A24497
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 02:31:31 -0800 (PST)
Received: by mail-ua1-x92b.google.com with SMTP id e16so238753uav.5
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 02:31:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1676975491;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vUPlnNPnOuO97v5YoHv4MkQhOnpL4HqARBldqt6DP4g=;
        b=HdTZ9FqqxjGxhFkROovTkkDW0quKKCuY/jFFGL18+08pEKDaXmZl/oLERPWpKDHC2e
         9MfnX/rKyPrVoYPDmkBij10OEBTUWLFLOJYXGVwVf4odeuydc6gEOq5ILAR1KwLuMhXa
         zPgQnsag/izgOjA7zyh5EtsaES9IAILo2gGRMrej2ex5K+eNOiLT8vOqMZIMUC2qHK8F
         CftS73UKLzBWN/7SQNDSK6XkohSwCIQCNNc4Ttr1juH3Q27EXE5F6FCRZ/GVfxsO12UM
         zwSit6SIdEE2XIUgZUzNH7OPIAScSBzpMTtuHnldevj569WTOf5TcWdlAjygNlwTPVNO
         kNkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676975491;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vUPlnNPnOuO97v5YoHv4MkQhOnpL4HqARBldqt6DP4g=;
        b=cUJN86xVbFvenBqLPnoxUqK3qHjpNHqSIwXa+R0pVLKmW0YUV457vdOk6eVOuku+3S
         KtQysIfT+2HQezN+rp0Oz3OpHEaWEz9EvzS5vMBsSL/eU60k/R43VKutLcszPxvtTOcE
         AGiXEKRv0Emoc0Bklm1yUnvGS+tRn9nzIKD5SFDuq/TSiZ7X6KFaEVDvP/YjSuotcCqg
         rMal191XY5duoFI/L+J6SJBQaozdMhkuxIUXo+oSv5cr6SdKU3rNVM/5RtbrF2aoeypt
         4QEkniVUu4ZFrgKdVs09fNeIyzM7ORhb11GqO+hObMxPoFGEENFVKexHZU7jBUcWa7UC
         CVxw==
X-Gm-Message-State: AO0yUKV+Zt5ZNfr33Yw9ztnmJhFUTFJUmBFsEbDGhK5E5a3MYALutuLY
        n8Thms/DMVF4MWn4brhpQjgH/yRKKvOOK7l2g0W3LQ==
X-Google-Smtp-Source: AK7set/8ow8BBI26zb3f2MdJCsGM3iec2NgvV5nC/+qPeXI9rPI3T/7lke/rwLN3XVKKqTCRlsBX3KDGom9BCpvi+l0=
X-Received: by 2002:a1f:2305:0:b0:40e:eec8:6523 with SMTP id
 j5-20020a1f2305000000b0040eeec86523mr369162vkj.43.1676975490651; Tue, 21 Feb
 2023 02:31:30 -0800 (PST)
MIME-Version: 1.0
References: <20230220133602.515342638@linuxfoundation.org>
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 21 Feb 2023 16:01:19 +0530
Message-ID: <CA+G9fYsXwWBUBkvP4kYejJOqwOoS5n+DtoAsb5WUUtRmh774qA@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/156] 5.4.232-rc1 review
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

On Mon, 20 Feb 2023 at 19:14, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.232 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.232-rc1.gz
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
* kernel: 5.4.232-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: 01caaff111842f1fb3c245d4387cb2ba7aed627c
* git describe: v5.4.231-157-g01caaff11184
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
31-157-g01caaff11184

## Test Regressions (compared to v5.4.231)

## Metric Regressions (compared to v5.4.231)

## Test Fixes (compared to v5.4.231)

## Metric Fixes (compared to v5.4.231)

## Test result summary
total: 128121, pass: 104609, fail: 3232, skip: 19905, xfail: 375

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 148 total, 147 passed, 1 failed
* arm64: 48 total, 44 passed, 4 failed
* i386: 28 total, 22 passed, 6 failed
* mips: 31 total, 29 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 34 total, 32 passed, 2 failed
* riscv: 16 total, 12 passed, 4 failed
* s390: 8 total, 8 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 41 total, 39 passed, 2 failed

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
