Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF6A9536C6A
	for <lists+stable@lfdr.de>; Sat, 28 May 2022 12:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234108AbiE1Kwv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 May 2022 06:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233231AbiE1Kwu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 May 2022 06:52:50 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E9461ADA5
        for <stable@vger.kernel.org>; Sat, 28 May 2022 03:52:49 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-2ff7b90e635so69562817b3.5
        for <stable@vger.kernel.org>; Sat, 28 May 2022 03:52:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ioIS4MmbnyxtV60nK14BZTISmYYV8F53dBo4pl+MrCU=;
        b=i8ntuccCB+c6maGjmExSujxuabVomBABL3eUgH/7h52X9b2sVK3qSLSwH0bNqp8hfl
         42toS/l+ZHongcN3hnS/vgZH438o3sjfomKef2eM4Sc4Rzv+ImviWWrQDU7qQPSk1HLM
         0cIvSHt6/yqGjqbXZ3mHvrHsItK03BtRKTZDvDcvG3kAlGzfZqDxGdJcUoULZuCRdFY2
         wn1sHhZlgFMFP9rDEpnSxsob2sBlZ+h3I8+N/ulkRF71+YUViNC1J1UditLbeNeWoirj
         SMPdLaqvTQOOFIqMFxX9aDNjCqiC6LERR3iMFFrP8M/EJ3aq9rGjxRPy4+CmzpZXjx1R
         skgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ioIS4MmbnyxtV60nK14BZTISmYYV8F53dBo4pl+MrCU=;
        b=5Wc5dLBu8Me7bNRFRMLI0lhAb8f6vlSh58ZTrxyKNIzJdCPEA9LZe2Cdxwqh/bOKm+
         tsCZIYXqiPDmx0PwvFqQz7Fbrg4Qf6PDHhoCCGfM9G9qdhOsndFRbyEguo7Ua7BO710Z
         st9q7ttrzWhIWujhofZFUajWU6WPDa1GboxXKiT4k3K2611Nge/EsROqWJXZ+zEE3GNN
         OAxyUIY6Zdeg+ndQBL4LdYPnDy29fk7AWzOGujBawWH90XBZUHb6Y7N2GsomK9j0HQnY
         c5VUUV/R31COI3fy+27bjXOixiXFFDcQe0CKahtVJUeuOkfXl3RNoG0mOOMVttc2XM7m
         p3cQ==
X-Gm-Message-State: AOAM532KwsX5IdRgbIDYWopeWIyVPNNakmrg2MftNy/BtAhb121JJnDa
        W/e/2JRStNBcAHSiM1+q/aA4nl+Q7A7T7yK1aWIgpQ==
X-Google-Smtp-Source: ABdhPJyOh/8ZdNcUvRrhUIB+iV9DXUn5pklUodLjEgkvZ9y5LLuecA3S1ho+3d6tvVbt97Lk2VSZH55r6s0+chbXtHA=
X-Received: by 2002:a05:690c:443:b0:2fe:eefc:1ad5 with SMTP id
 bj3-20020a05690c044300b002feeefc1ad5mr47794058ywb.199.1653735168551; Sat, 28
 May 2022 03:52:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220527084850.364560116@linuxfoundation.org>
In-Reply-To: <20220527084850.364560116@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 28 May 2022 16:22:37 +0530
Message-ID: <CA+G9fYsQ6vrSMwActas8vWQtRV=L_tT2cqQGVHQz=CEC=6Dq+g@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/145] 5.15.44-rc1 review
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

On Fri, 27 May 2022 at 14:21, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.44 release.
> There are 145 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 29 May 2022 08:46:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.44-rc1.gz
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
* kernel: 5.15.44-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 510d04da560ccd2e08230967864dfdd47b9b74a8
* git describe: v5.15.43-146-g510d04da560c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.43-146-g510d04da560c/

## Test Regressions (compared to v5.15.43)
No test regressions found.

## Metric Regressions (compared to v5.15.43)
No metric regressions found.

## Test Fixes (compared to v5.15.43)
No test fixes found.

## Metric Fixes (compared to v5.15.43)
No metric fixes found.

## Test result summary
total: 100757, pass: 85945, fail: 475, skip: 13420, xfail: 917

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 296 total, 293 passed, 3 failed
* arm64: 47 total, 47 passed, 0 failed
* i386: 44 total, 40 passed, 4 failed
* mips: 41 total, 38 passed, 3 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 59 total, 56 passed, 3 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 26 total, 23 passed, 3 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x86_64: 47 total, 46 passed, 1 failed

## Test suites summary
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
* perf/Zstd-perf.data-compression
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
