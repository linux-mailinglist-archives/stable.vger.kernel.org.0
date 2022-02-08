Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFC644AD2A8
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 09:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236882AbiBHICR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 03:02:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235636AbiBHICQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 03:02:16 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82FA3C0401F1
        for <stable@vger.kernel.org>; Tue,  8 Feb 2022 00:02:15 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id y129so11203363ybe.7
        for <stable@vger.kernel.org>; Tue, 08 Feb 2022 00:02:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=18wDr3iBWJyPszrKfi6iREa7Z/8ZDmdoo9EUSjqSWbg=;
        b=yHn3riNqPLF+XajvtDefkPK1zsMnv13sFtffeUUq8khW4bM27oT8cQVqIiNVEjiOs6
         /HFpTwOeI9cp2YYxyndA0LMGY56HEf4FqCdgZEC0gwoIvoeML6gbJFknS5LtKUtfAR6C
         S7uGw6C2jtBGMHreuGVSdcYynvvK0I66Ee7/J7cY+lTy+WtVJwjJiOIECVWJBak7ihrS
         rspMQ8/ngCnKYvns5n+T5erDaYfFI98tyQTEU+9Wxos81FhfvLhi8q/M/pEN9ZOfIvXq
         gjgsxEYIbPP2yev5Reb5uej21Mgim0BJBKNKmFdAZOLSPQZtf9HjyM8O7GXwSNNzSjRT
         jNWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=18wDr3iBWJyPszrKfi6iREa7Z/8ZDmdoo9EUSjqSWbg=;
        b=s0WGnrjH+2ew7fGHT9hl0CvSUljIbMEjARDTdq1DyzP/VSlLQ2Z8UjGUdPgpBk1u1H
         c/dOD3iRZTlr1kesAwxXjAORs8J9B5XZmEbIsHba1Agve3Mge4I/v8bmFwDdoWXq1RD7
         rR91VQjKjLeXmIC8oVVgtQV/XPZ5kclqP7LykSvy+PqtirMpNNR5mFASh9mmz2Yxdn1F
         PCHcx/nYSDFhvz0otetdTf4X579UelbgTOMblfkncUUSjOezK+9oM7CSqggKRqatJTql
         1CPfVKW1CVeAm6o9iF5JPEKrciCXEaRhjK2DFYV5ET1oP46sun4G/kNsurTj/5SBG4Vu
         h4cQ==
X-Gm-Message-State: AOAM530YNuTgxhIXXIOLrvE6Gd4r49j4DuVtYpf4p7GVzz9ArZGAFee5
        SFLuWZhkXuNO09mjLl6RbKDcTke408miVm8+09ZOIQ==
X-Google-Smtp-Source: ABdhPJydZx/3mH1R46FTUbwr2Nbo3+VGwWujH4gfsMn02scAjMg51XXsdS7pmXNmLDo6ssSO4xFbadCjUngzOTul1MY=
X-Received: by 2002:a81:3542:: with SMTP id c63mr3652366ywa.87.1644307334550;
 Tue, 08 Feb 2022 00:02:14 -0800 (PST)
MIME-Version: 1.0
References: <20220207103757.232676988@linuxfoundation.org>
In-Reply-To: <20220207103757.232676988@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 8 Feb 2022 13:32:03 +0530
Message-ID: <CA+G9fYu+ycCuKhzY3bcP4OGhF9X=MFf9jJJaOhK2fj2LxduMsQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/74] 5.10.99-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 7 Feb 2022 at 16:51, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.99 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 09 Feb 2022 10:37:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.99-rc1.gz
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
* kernel: 5.10.99-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: 9f5cb871ceb99f4667e351fd556d9de87b0de526
* git describe: v5.10.98-75-g9f5cb871ceb9
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.98-75-g9f5cb871ceb9

## Test Regressions (compared to v5.10.98)
No test regressions found.

## Metric Regressions (compared to v5.10.98)
No metric regressions found.

## Test Fixes (compared to v5.10.98)
No test fixes found.

## Metric Fixes (compared to v5.10.98)
No metric fixes found.

## Test result summary
total: 101051, pass: 86633, fail: 563, skip: 12965, xfail: 890

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 259 total, 259 passed, 0 failed
* arm64: 37 total, 37 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 36 total, 36 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 34 total, 34 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 52 total, 46 passed, 6 failed
* riscv: 24 total, 22 passed, 2 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 37 total, 37 passed, 0 failed

## Test suites summary
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
* kselftest-bpf
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-drivers
* kselftest-efivarfs
* kselftest-filesystems
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
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* network-basic-tests
* packetdrill
* perf
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
