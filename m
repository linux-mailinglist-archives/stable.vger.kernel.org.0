Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBBD6B58CE
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 06:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjCKF6u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 00:58:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjCKF6t (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 00:58:49 -0500
Received: from mail-ua1-x934.google.com (mail-ua1-x934.google.com [IPv6:2607:f8b0:4864:20::934])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D22761DB9B
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 21:58:45 -0800 (PST)
Received: by mail-ua1-x934.google.com with SMTP id m5so4964369uae.11
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 21:58:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678514325;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3ntsSgpkdi+Qg7CjwB/UZN8FSI5xELZBrHiGC6QvEDw=;
        b=CXHaE//9HA86ubnSE/vscXtbuggEwhvupnBjNkF2fveaGXrcTYdZWkVKeyrPYiJclt
         f/fZk/S6DvCdTFzi5fcg/OC5eiNwOlR3nd9fGaUFHZVX3zQPEiV/bOUbMgRbe+1CyHM+
         EYyhV9zdWo7m+zsa1SDOAcrFEgLGiF3lfXymMrsLFUxZB3XLOc+8V50bORpWVz/FKTqs
         hcE6XL117hYdAPgNC7AVRew04zJ/OXe7Md9ZI1ggyfsdkx6GEk56RLLye2BlQWtbtqp6
         fVeVToszWtp0dJW5OgbVPCWkR7b/cqJBFkS5kc6tK9QZbCIGe+/aydVzsS4WOjCD3lAN
         lT5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678514325;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3ntsSgpkdi+Qg7CjwB/UZN8FSI5xELZBrHiGC6QvEDw=;
        b=2txSJwaUjXQHKmXF5lc6aYvT8DBtSfy2Rz23t6EFvXeMAIZ6Uy9VF0CgvvBjo0Rd2l
         ZozDNDsGwzUjKQJHnxO6CV2iwSCb3WiZ4NzU29czIgaH/Qx2kyTBc97FXcGczaKfQozH
         8dqVLzMf2XJZSlEOB1SBDiC7DBBx7XNw8qFgHTUzhSeIOkQ6rWVgopSQOL33d5GqTb6E
         y2sKbHza19ZTbulWHmo7J21de5RCCJFonl6vQ94Dvb7adC+99V4zbFhfwoPx45zBg9/7
         A+xgzaVVDZLWuXed9+JUPmqU4574mqbu8N8HGD7bdj75JjdXKantXyfcP4uLb5TQIqQc
         48sA==
X-Gm-Message-State: AO0yUKWk5J7fju1wBlJaY9T7GzYOycOS8lIUTNK0n3GZx/TXYzN62C8x
        s+B2SxibmI7YNWPakFMv8ZHD/0bRIh3Xt+B2yaaI849huzBqe6WGc5s=
X-Google-Smtp-Source: AK7set/OiWvumTUM3PtMuSmj6efbMk9ZnH/RjkDpZHYc1eBZEgFanhjTs60Avr05sIBmWpy8o31fQ54viPrquM5yiLA=
X-Received: by 2002:a1f:4507:0:b0:42d:5ea6:bd58 with SMTP id
 s7-20020a1f4507000000b0042d5ea6bd58mr7783765vka.3.1678514324729; Fri, 10 Mar
 2023 21:58:44 -0800 (PST)
MIME-Version: 1.0
References: <20230310133717.050159289@linuxfoundation.org>
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 11 Mar 2023 11:28:32 +0530
Message-ID: <CA+G9fYvKkhFRCfLQ82awK1qSZW=-TEiz3NjcepUpYHdUQrBSOA@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/200] 6.1.17-rc1 review
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
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 10 Mar 2023 at 19:35, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.17 release.
> There are 200 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.17-rc1.gz
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
* kernel: 6.1.17-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: f345f456043c26b6a0d011d779ae746c16a9f8f1
* git describe: v6.1.16-201-gf345f456043c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.1=
6-201-gf345f456043c

## Test Regressions (compared to v6.1.16)

## Metric Regressions (compared to v6.1.16)

## Test Fixes (compared to v6.1.16)

## Metric Fixes (compared to v6.1.16)

## Test result summary
total: 166217, pass: 146661, fail: 5029, skip: 14499, xfail: 28

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 149 total, 148 passed, 1 failed
* arm64: 51 total, 50 passed, 1 failed
* i386: 39 total, 36 passed, 3 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 38 total, 36 passed, 2 failed
* riscv: 16 total, 15 passed, 1 failed
* s390: 16 total, 16 passed, 0 failed
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
