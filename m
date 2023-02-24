Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 261AD6A2188
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 19:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbjBXScU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 13:32:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjBXScU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 13:32:20 -0500
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 150D86C526
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 10:32:16 -0800 (PST)
Received: by mail-vs1-xe36.google.com with SMTP id o2so684456vss.8
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 10:32:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v+g2qCpnal7loN6QCFrurLS2PALIQt/+PVVdydvd50I=;
        b=C6XuAp+mutkN4ED6cCj/Y/Z2ckdxV5pptJyCdVMe3vcnHpkGXR3RLnjxWtvNSzN6gU
         337mHRxCrIYqmjIBoVTpduC1HBj3mlESbOVh0BS+E/ir8Ka+UO/L1L9puWAnTjhIVOiY
         m0Ru28BIua7Gsr4w9mlxkYNh2L3tV0RphHdetyQCXvQtDuN6lBPCj+qZNzo/P5FDet2H
         V02LzLORf96Hn9komQWrSpF3Zj4b2K1GJ+u7Tv5AOEMy5wHX7Ey6u2f3bCXcXKYc06r8
         ozehFqWMmK8FbQb1wPP1xhnf7ulGeVrhM+01g/gObbLo6PnEfEVjN+kbcnT9Nd6arb1b
         Bo7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v+g2qCpnal7loN6QCFrurLS2PALIQt/+PVVdydvd50I=;
        b=BMY0p8aw6TMC7ZF4MnrDHd3D4odshgfEv13urs8gIdGmCkQqozA0rYM1FXwioYYPQd
         PTbifegn2Rwf1/NtXCLOkRXFvZYaVGQH3aiCXjbmu6blWCpE24CGQaqs/wI/xJMqtZ71
         bUaxWvtRdcIKgLsqqweNZu95jYXv0+3+M8Ag7/2owRzs/+SoDSSdLL89L8aMTEqude0V
         rrLhzWZvNe/8ZA/LIjeqQKiSz/ZWaXOvtQbJKMEP0A6TklGHAWkV3yEQYML4bEMHhZ5r
         jO19fhPr6OjnqVt9XlepfAuFkodc62CcKqddZ0lDFnhylZzw+MlFBP0+khvnxV/FG2xU
         e/cA==
X-Gm-Message-State: AO0yUKUj2eYRB8cwnHQIRF9wgrJTh+6kCffx6xq5gJJlF/yAvZdinFZ6
        tad7XkY6YKb6s0HnwAJs4tH4f3zRei52qJxRnNZY4A==
X-Google-Smtp-Source: AK7set/eiDLngCWPSVzTAUOLr4JOvlVHo0dwgYUeIgCLVB30yu4hbYdFnvB39u6miGDQ4JfLl+7cAjg+0xcAz6WgUNM=
X-Received: by 2002:a05:6102:3a61:b0:412:2ed6:d79b with SMTP id
 bf1-20020a0561023a6100b004122ed6d79bmr2945441vsb.3.1677263534940; Fri, 24 Feb
 2023 10:32:14 -0800 (PST)
MIME-Version: 1.0
References: <20230224102235.663354088@linuxfoundation.org>
In-Reply-To: <20230224102235.663354088@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 25 Feb 2023 00:02:03 +0530
Message-ID: <CA+G9fYsvvAD6XRrCbesFowzDd+uZhtenszgOdNTNHm_UP21ddQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/37] 5.15.96-rc3 review
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

On Fri, 24 Feb 2023 at 15:54, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.96 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 26 Feb 2023 10:22:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.96-rc3.gz
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
* kernel: 5.15.96-rc3
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 75c1b03758ed17a09cf86c10bd6e17448a978d21
* git describe: v5.15.95-38-g75c1b03758ed
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.95-38-g75c1b03758ed

## Test Regressions (compared to v5.15.95)

## Metric Regressions (compared to v5.15.95)

## Test Fixes (compared to v5.15.95)

## Metric Fixes (compared to v5.15.95)

## Test result summary
total: 161577, pass: 132929, fail: 4487, skip: 23824, xfail: 337

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 149 total, 148 passed, 1 failed
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
* ltp-c
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
