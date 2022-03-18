Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2976C4DD710
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 10:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234451AbiCRJ2j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 05:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234447AbiCRJ2i (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 05:28:38 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2267E2D919F
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 02:27:20 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id t11so14832252ybi.6
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 02:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NiloVlsM0fD0ZTL183KlLDNEYD/TNeP0iD1gkzYQxF0=;
        b=A9LbMhHqQGc9aZQpJxn5H90B16tlLid88+DcaJwP2blODJ/0NaR0U+PyiLqkvfClB7
         ylHOaMMYAVOm8AyVvaPnz6E8/7CxqP6vkYMrV0lqegDRzJaUaJzq6UQ7D1R9Cdkr0QYQ
         NYlI2toKqArkdx/rWe8wKAk0TrGiwwe6oK832sQy6YISpEj9DAYP5JLrmphQfiE7oLsd
         TBVWaCGG3lWbNJCVfS4GfkV8Q+CBGZPOVv7Ot4tImVNvJLSJqGcFecyJFyR6iosc3XAi
         +Rh9Rien0vtfY3eutAFJlcFJNMSp1zN02atO0VsjwAdg/4meBDCFfLqYNS99JaqExGg2
         V5tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NiloVlsM0fD0ZTL183KlLDNEYD/TNeP0iD1gkzYQxF0=;
        b=xr/BPGzUiLX4hzoIwBNXXVHgt0d1lDdqck71k72AtjVtHjIKxgCJ9bJKtJKhfbZniq
         KEAi3RbkF2mAyZ4crBuEY0aTPXTcKknRwxsPKDITxKbFJQtFUDYJ9R3YwfpkLPPc+2Vk
         BXXeVsTh7u1KiokmqksnCik6+wakxcJTwZ1dVvYk4Y92iIS5RmX2ONk8fUsj55hUdQET
         jEMJjB3fPq7dR5L+HSJmSgyAGj+Y1tTOphJss/k7Us1VC21BVSO0P8LfNZxGH0yNJL+x
         rpzdCJkqAmUCA9LoJIbFlopV0LLHOJSGsuArmzLrlmUedSLbWPwUy7ObZo5GtWDMTT1v
         3bXw==
X-Gm-Message-State: AOAM533gbnO4nSvHmGnh7S8E86xnZP6QqrelID75UsEmDiHo4kIEeq2V
        U6YL3aU39tOKSO/bahAie7FFgj8DWM3xCpChPmaFCQ==
X-Google-Smtp-Source: ABdhPJwgUKcGhbSAMFyZt3qbdsm47q7qW+f6BZ/kJNV9antKRqNCXY92pQ6m+YqTKQys+CuflqoIYPyu8fiPuTvXNQk=
X-Received: by 2002:a25:be05:0:b0:629:1f49:b782 with SMTP id
 h5-20020a25be05000000b006291f49b782mr8767994ybk.88.1647595639236; Fri, 18 Mar
 2022 02:27:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220317124526.308079100@linuxfoundation.org>
In-Reply-To: <20220317124526.308079100@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 18 Mar 2022 14:57:07 +0530
Message-ID: <CA+G9fYs8uFFUuHerDpNpE3Tj_gH9RZry784nLk_j6MS9dPb4nw@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/25] 5.15.30-rc1 review
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

On Thu, 17 Mar 2022 at 18:22, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.30 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 19 Mar 2022 12:45:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.30-rc1.gz
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
* kernel: 5.15.30-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.15.y
* git commit: 1d4b468d2e8dfe717ff4f4991fa8f8decad564a5
* git describe: v5.15.29-26-g1d4b468d2e8d
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.29-26-g1d4b468d2e8d

## Test Regressions (compared to v5.15.29)
No test regressions found.

## Metric Regressions (compared to v5.15.29)
No metric regressions found.

## Test Fixes (compared to v5.15.29)
No test fixes found.

## Metric Fixes (compared to v5.15.29)
No metric fixes found.

## Test result summary
total: 106421, pass: 90242, fail: 1005, skip: 14074, xfail: 1100

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 296 total, 293 passed, 3 failed
* arm64: 47 total, 47 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 45 total, 41 passed, 4 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 41 total, 38 passed, 3 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 65 total, 50 passed, 15 failed
* riscv: 32 total, 27 passed, 5 failed
* s390: 26 total, 23 passed, 3 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 47 total, 47 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-
* kselftest-android
* kselftest-arm64
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
* ltp-fs_bind[
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
* perf/Zstd-perf.data-compression
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
