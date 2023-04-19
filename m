Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10EBE6E7331
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 08:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbjDSG1Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 02:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbjDSG1Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 02:27:24 -0400
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F4BC7
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 23:27:22 -0700 (PDT)
Received: by mail-vs1-xe2e.google.com with SMTP id r24so1130768vsj.0
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 23:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681885641; x=1684477641;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5gR9QnevZIFqUAZcTVV7xSwBhCO/82rP3S5b5X8dnr0=;
        b=RmZTqAOcCoDoIqt61oczB49mPHVd4tcrIvsFTwgdtX4TB1vDgEQTlsUFpbtTFd3IWz
         77e3J7BxCgYhcyXnqdzhTfsEXGwqS2BfL3kPWMPMQh0tk2CGzLan/G/hoYbIKY+2+rYR
         dMshhoJYmTutbU8S2AOiBo3aU+LZn5bTwVhWxTNo7bG+0+6lxADtO0FDyueGNLfOOFf4
         pAcvf8ZDzT4uINNX9VKwEbJhC5oIl8+5V5KjVokJTDmMm5uCM/oMrkexblHhcSY40tmV
         bwtFnSG5ztU8gdJ2hxAfu8ZkL9zwmUXE9kTrFTTINBhLeBjEy5HRKAl6jqyEAW4rwkF3
         Kppg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681885641; x=1684477641;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5gR9QnevZIFqUAZcTVV7xSwBhCO/82rP3S5b5X8dnr0=;
        b=lxZHzChGvt6MJG45SeAiif6/BgEHv0Z8f0UB4S7/Pf94kbL8a1GJ4S/eiBArseMBx1
         KMxEbHCGo1sH3BCJz+Lj2sanbFmXOBof1HApsArFOpyg33uP+EghYwCcfHCun4H0JP2h
         UOW+T0+pXrqbJBjP/gf/Z9nI5pzEPD9q052Q9MzHCaDqXjpOGHYBm9TAFmT3pxBrfGAJ
         e/TKuKcctLszfkHPl9HYdf9BeONnJDX4uYagclgK8l8B7t+Hhc5bOD+kG5QcbjW8yJqJ
         KuSRBEdDddyTuQik0QAs2Ic8iggwOHpSxW5MlLMmpQe+sjeJeezGJfU0VQuxOlJazEwd
         DfQA==
X-Gm-Message-State: AAQBX9flRTnw27o4E7pVYg8bAREAuELkMlTke7KC4zBrBO8NQjUSJP9p
        VJ1yWD+LInMYF0q1tHwA3sVkbPZtvPeAxM0qsL6ElA==
X-Google-Smtp-Source: AKy350Z2jTarge6T7Fg6F92eSYQwrCeUEPgApVB/FUoppRFSd/tmjwqy5p/H6N2QNosLJ9vV771ylia+o/4y6DqXpzU=
X-Received: by 2002:a05:6102:533:b0:42e:7c42:7ff3 with SMTP id
 m19-20020a056102053300b0042e7c427ff3mr4087630vsa.6.1681885641213; Tue, 18 Apr
 2023 23:27:21 -0700 (PDT)
MIME-Version: 1.0
References: <20230418120313.725598495@linuxfoundation.org>
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 19 Apr 2023 11:57:09 +0530
Message-ID: <CA+G9fYuF56sONXmw0OHiv82KEaYLAT46FrOFePLOGGWfa1jt5g@mail.gmail.com>
Subject: Re: [PATCH 6.2 000/139] 6.2.12-rc1 review
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 18 Apr 2023 at 18:17, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.2.12 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.2.12-rc1.gz
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
* kernel: 6.2.12-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.2.y
* git commit: 0b816653f21b8d3be558317406fcc5ab1f6a5bfb
* git describe: v6.2.9-501-g0b816653f21b
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.2.y/build/v6.2.9=
-501-g0b816653f21b

## Test Regressions (compared to v6.2.9-361-g5f50ce97de71)

## Metric Regressions (compared to v6.2.9-361-g5f50ce97de71)

## Test Fixes (compared to v6.2.9-361-g5f50ce97de71)

## Metric Fixes (compared to v6.2.9-361-g5f50ce97de71)

## Test result summary
total: 185409, pass: 158309, fail: 3947, skip: 22855, xfail: 298

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
