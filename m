Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCCEB66A0FC
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 18:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbjAMRqC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 12:46:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbjAMRpO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 12:45:14 -0500
Received: from mail-vk1-xa35.google.com (mail-vk1-xa35.google.com [IPv6:2607:f8b0:4864:20::a35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6770988DF3
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 09:32:58 -0800 (PST)
Received: by mail-vk1-xa35.google.com with SMTP id b81so10496874vkf.1
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 09:32:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E3d0L9EXeSI2xa3z2QyuDWU/GW2S6z4vkLQnF3O+530=;
        b=OnIoo9VUst637PaD3GIGw+8rqKwnkQLsUdbTvqYBTm4qQSS43PvGy96ENnv07t7th9
         xuw99hglKZn282xWmPZ8NLUPi0eeog0mBAouU8QIjMzhcKJwdeQg1x9pq7Z9sDyvRh+X
         B/T4naIBWhijaV1Z9nqPex9nz221WvdDsLkjyHvOjPxlITEPSM5vOtKSU++6UI8qTcEy
         p53PYTGQOLK1Yda9yfp+DFHADAEl9aPTTUgVFvFJ9g53XXTQehKJmunG+gay+ZHnUAhv
         ELxHmy37t/N3j8K3UW3/SMnN8dKSdWGA0f+3dmA4wJR5bGTuYBmupLM2mef25oYMFoti
         eUmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E3d0L9EXeSI2xa3z2QyuDWU/GW2S6z4vkLQnF3O+530=;
        b=TkipzeCpdvdNT/NEmzFabLSeY0zldDJ8ajR9rkr6gt0PwDJBgQvemSR5Ta1lIVo2Gp
         1RLjjaVfM03c1Dv8BYZjqTlJe7vEKMqaI/mfIaiuYyj9P3ZzmShqf45NZO4HX6kWBatd
         d+6t6ESapzhHEhPAQc9BUOTIl1siGoH7rdkeq48UIxXydST1ioZOUrrAM5jSdxOnkueF
         qMwSxDL/6F3nIXBonhuJmdMqvqkL+25khCemLz3m/9F3AO7qanRTVs+xxLX59UoMi5X+
         woLsy94mXqjg8a+jrwFoT173HZuG4s2a1X//NOk6qXv8gSoLz+2/ZCPJEVQ/SpCI563s
         7rpg==
X-Gm-Message-State: AFqh2kolmHIedEg2UGZnkKD9WV6CgrxQ5X5gdReVsT99W7W1Wu2Tk4y+
        ZI34vL68qHNn26SAui4b1X0aTJMCS9+MUwrqqSL4Hg==
X-Google-Smtp-Source: AMrXdXstM05aG5ZJ1+4SwdzPR7faL+HVwyRkbnLgjVAkWQ3RO1tj8uFpevrmAq5Yn0yPIfIA1D9zoiwHkDdEjzqcwF0=
X-Received: by 2002:a1f:3215:0:b0:3d5:86ff:6638 with SMTP id
 y21-20020a1f3215000000b003d586ff6638mr8249719vky.30.1673631177317; Fri, 13
 Jan 2023 09:32:57 -0800 (PST)
MIME-Version: 1.0
References: <20230112135326.981869724@linuxfoundation.org>
In-Reply-To: <20230112135326.981869724@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 13 Jan 2023 23:02:45 +0530
Message-ID: <CA+G9fYukcyTgt2xavZqcxv55vC5vn2havo9A+wCjo9aVBpzR6g@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/10] 6.1.6-rc1 review
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

On Thu, 12 Jan 2023 at 19:26, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.6 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 14 Jan 2023 13:53:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.6-rc1.gz
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
* kernel: 6.1.6-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: 5eedeabf82ee83045c63fd32b2473e1d61885204
* git describe: v6.1.5-11-g5eedeabf82ee
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.5=
-11-g5eedeabf82ee

## Test Regressions (compared to v6.1.4-160-g06bcfb15cd3b)

## Metric Regressions (compared to v6.1.4-160-g06bcfb15cd3b)

## Test Fixes (compared to v6.1.4-160-g06bcfb15cd3b)

## Metric Fixes (compared to v6.1.4-160-g06bcfb15cd3b)

## Test result summary
total: 183886, pass: 153292, fail: 5185, skip: 25382, xfail: 27

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
