Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E641467918D
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 08:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233352AbjAXHFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 02:05:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233309AbjAXHFR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 02:05:17 -0500
Received: from mail-vk1-xa33.google.com (mail-vk1-xa33.google.com [IPv6:2607:f8b0:4864:20::a33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F4AF367D2
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 23:05:16 -0800 (PST)
Received: by mail-vk1-xa33.google.com with SMTP id i82so7168690vki.8
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 23:05:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1U4Pd427NqFBAd4E6jn2FpNNrvScaOsOwCr5qsdbrMA=;
        b=kvHOzhqirUJEY2zobjxTgetF/Qh1dC+pyKnnRLtbiiKDrDupEU7yxKOb9NUJ5yIvms
         oddk2vtm41noduVp/uuHUhhvrxuEXgAL9E9GBUKr0zkllRl+xgor1ZO4wq205U30LTpm
         HIJYNMJD62KsG51CpmBZPqfy2PyUQUCyZrhP5Ipv84yFdjtw5YnWQ7KYZ+ZKctxFIXRN
         gQkl56lHLgt8alC0rPWRlThWl4J57vK8+LDplVFup3cadzWckLymTtctJv0Gfu/1mX6J
         yanLGTRxVAQJF1oA3/8Fmxj0awYagsXrbtBPQQ62ZMdxm51cloTfVo7Gs3LSqd/BsN8/
         LSUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1U4Pd427NqFBAd4E6jn2FpNNrvScaOsOwCr5qsdbrMA=;
        b=BoSLqyWs2ofGs1bH44WwRtu+N7SoukpxCtoZ9hIsLmRagvcKockCIrF0Xz1+V3dICE
         81IxIy5D9Op2kL+Tb5RyFEKSynJkWPsbMKtRZaRvwD6q8eFWRaVYw6vNnpN8Ox7PF4HZ
         9nnt1/Dgy5I5Qd96EaFpJ1uBWTuSFXG0gBaIFAKkJpFCtrYGY7w4PEkjxePWdtF0lL2w
         qeUm9ErbOJVpdVXnzQvec+f5P4n5VSSq5ln+K+LAEpf420FY+Oumblff/ePESWmqSuQn
         Ri2hKJUFR0jh0zkFZeTAfkXN3QhoNocPAnmvj0g1MeYDMk4yM+MncOds9cVpG6MSN0in
         RJaQ==
X-Gm-Message-State: AFqh2kpk+g/7twiy91hLofd0EmBRzYuMZrdScFHxQ9kWauC4rBkZWk7q
        AANzvI3TuKdv96UaJ2kT7p1rBNnxXcHXAMdSOzvUMw==
X-Google-Smtp-Source: AMrXdXtQRD0ag5IX+4z8ewSXMdgE1Q8WqAXhO3JGK03CZsrsbY6K3xZD9vhpqSCUEMJvaVcCu820VJkqpa8rUB6V04E=
X-Received: by 2002:a1f:2e58:0:b0:3e1:5761:fdbb with SMTP id
 u85-20020a1f2e58000000b003e15761fdbbmr3442036vku.7.1674543915467; Mon, 23 Jan
 2023 23:05:15 -0800 (PST)
MIME-Version: 1.0
References: <20230123094931.568794202@linuxfoundation.org>
In-Reply-To: <20230123094931.568794202@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 24 Jan 2023 12:35:04 +0530
Message-ID: <CA+G9fYtdM197crFZrfkJJkx6iufV058h6Xq3Egu5DqPOc58yng@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/188] 6.1.8-rc2 review
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
> This is the start of the stable review cycle for the 6.1.8 release.
> There are 188 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 Jan 2023 09:48:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.8-rc2.gz
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

## Build
* kernel: 6.1.8-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: fca9634405d4b2a7d5d0ce11dd3b2f11517de944
* git describe: v6.1.5-383-gfca9634405d4
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.5=
-383-gfca9634405d4

## Test Regressions (compared to v6.1.5-194-g507f83506c2b)

## Metric Regressions (compared to v6.1.5-194-g507f83506c2b)

## Test Fixes (compared to v6.1.5-194-g507f83506c2b)

## Metric Fixes (compared to v6.1.5-194-g507f83506c2b)

## Test result summary
total: 156405, pass: 139374, fail: 4023, skip: 12987, xfail: 21

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 148 passed, 3 failed
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
* lt
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
* perf
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
