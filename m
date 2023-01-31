Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B23006832BB
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 17:31:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232227AbjAaQbq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 11:31:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231837AbjAaQbN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 11:31:13 -0500
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F2355A6
        for <stable@vger.kernel.org>; Tue, 31 Jan 2023 08:30:52 -0800 (PST)
Received: by mail-vs1-xe2b.google.com with SMTP id d66so16619737vsd.9
        for <stable@vger.kernel.org>; Tue, 31 Jan 2023 08:30:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lBBAv7auuofV3mn/jMc63ypgGH7OTBBCVGwNFFhI9lo=;
        b=cmomvh9k3jaGwlTvw3psBh8t9BpdXK53FMmaKmVPJ0UYnPRbHmS+exg6RPDUegr2CI
         CSq/rk08xxLtm0yq8d0E94Qj6IRL6oe15rx9zXm5pLAh6Nmx5NrYxD438mxow8WlQScF
         CVMtw5uzGacoodlepX5jwsfVVDi8lpqQAL8gKBCHep1nftM2PqDf78qEhbywitEDxyiO
         DqOaAUy1MkJPDW3ABKhVZfVG4othNNfkrtQTYJ3glzvUOj8dyI1FITrXwUqRcV9YTn2e
         1/sVLR9cJpxRtSfGxOJwoyA1CN6Jz5pW8vlXHmoAAEJ1ZYRwiPftT3L2Py62KC681fh2
         ORUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lBBAv7auuofV3mn/jMc63ypgGH7OTBBCVGwNFFhI9lo=;
        b=iNEEQvME+Pm0ylzBeO0kUwEdCKuVoieZxovyBY1bOsbWmj2Uxvu1mWWuYAnlJqaQEJ
         uE1Y6CRpaW3n7iZyogsyJ/JU/ZrTRxj6u/zTYa4fYCWdCkq2+Li6NpEWILNvgyiNgskj
         cR9/uBnqxxALa/D8gMOb6OW5vwN1frfyHo3jyAODKrtVFlsBvSShgFIfsd0n+Mp3gP8U
         sy4Jd+AG4uhDI0Gks+bh6yj8mhfjw7V74bu+TzqgyvqN2+9ovZaTZ9q9J0gA7qJ+2kxW
         BDuPvKKhcvPHUpJGYpR2iqZurPswpq1xUpB6WEwIhTvFG0KewPWQSt3QzhRoZWpMMi7n
         M10g==
X-Gm-Message-State: AO0yUKXJlLJgQnfbSt4x1/Bnqg3PaFGLXThs9p/TnLFTrz5AxKBkrhPz
        GBS+zgOpMMMqfqcZx0loR2id5pibr/ixsEawoFoJ/A==
X-Google-Smtp-Source: AK7set8jP1zvJKcvdwPGEfpjv3UqU9OptNqqbyVR8s9wizmd+4xvxEvgSyLXIP2CqvTzwWxkF0J3/wF619DqISI6D+I=
X-Received: by 2002:a05:6102:2406:b0:3f1:53d4:9e87 with SMTP id
 j6-20020a056102240600b003f153d49e87mr1703773vsi.34.1675182651187; Tue, 31 Jan
 2023 08:30:51 -0800 (PST)
MIME-Version: 1.0
References: <20230131072621.746783417@linuxfoundation.org>
In-Reply-To: <20230131072621.746783417@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 31 Jan 2023 22:00:40 +0530
Message-ID: <CA+G9fYsyZ_zRLZJZEt6hQEziUPnyFvya9fV5gS5jQOVCvuKvmg@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/306] 6.1.9-rc3 review
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

On Tue, 31 Jan 2023 at 13:04, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.9 release.
> There are 306 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 02 Feb 2023 07:25:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.9-rc3.gz
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

# Build
* kernel: 6.1.9-rc3
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: abbe4e7b63421364736284a85ddac372e35651e0
* git describe: v6.1.8-307-gabbe4e7b6342
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.8=
-307-gabbe4e7b6342

## Test Regressions (compared to v6.1.8)

## Metric Regressions (compared to v6.1.8)

## Test Fixes (compared to v6.1.8)

## Metric Fixes (compared to v6.1.8)

## Test result summary
total: 185657, pass: 153111, fail: 5000, skip: 27519, xfail: 27

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 149 total, 148 passed, 1 failed
* arm64: 51 total, 50 passed, 1 failed
* i386: 39 total, 36 passed, 3 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 38 total, 32 passed, 6 failed
* riscv: 16 total, 15 passed, 1 failed
* s390: 16 total, 14 passed, 2 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 44 total, 44 passed, 0 failed

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
* v4l2-complianciance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
