Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B139480724
	for <lists+stable@lfdr.de>; Tue, 28 Dec 2021 09:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbhL1IBT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Dec 2021 03:01:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235463AbhL1IBS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Dec 2021 03:01:18 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C704C061574
        for <stable@vger.kernel.org>; Tue, 28 Dec 2021 00:01:18 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id w13so17857817ybs.13
        for <stable@vger.kernel.org>; Tue, 28 Dec 2021 00:01:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=gZ4aLMuzlbsmFJFAnMFETb98tvXZJk1H+3t3xDTrxUw=;
        b=WIGfMXuzMqEj2uVIiyN4O4GCmsiO+m6RJrgWJBrmE436D3Rqchk/QY6CaqUf12ZDET
         I1B1TvqzRJ1FtgbaxlA08aQe+KXyV7/ZBzCsD0lEA0xbLs1qJ7HNJNU5eh6y25p17PVt
         4fnusCYjd8Nptltl1JtLNI2OO2tXuso/+FERMG5U9jWvgM1iaJAx0O+eUgx1b4D54PoP
         LCIt6iERW3J99o71eINGrcfAP2P3vSdf39Sa8EEplT5Wey6pGGngnXq3kakiwmcbBSOw
         QLxpKcdIwwep2bwU0QoBTIVi4jookgjV7d3y48BSBdEDoLfNWvQDeVUqtN4Q+ak1dgsp
         65UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gZ4aLMuzlbsmFJFAnMFETb98tvXZJk1H+3t3xDTrxUw=;
        b=e7sINL0ea7VUdVX74hc92RSvavTVj8ucGvamae5K486aaIOWEb3QbPewJnZBRL8DFG
         r4r/i7opDIV87+d1UkaiGWhzH3nE3fHY3LTZmiKg9FAhnmvxHeCJ2BXMrtCN14mPHy+n
         A7YnmpNHlC7LY77wfdjZdlUM2HsJvY+FX4KlMDZZSuWD25LT/uvxIYON4Ju1MfCjI+l2
         iHWaM4/BravMoS8XV2nu+eYLQvhF3TvVqI9dfs4RUIAQ5XJ93ooWzRBDsR+QpHTQOjDy
         te2QIXwONGvNoDS+GrMaN+xRtRdZvtKgsZDaISaCFsOlicG5FW6AjR0OXqmX6j3bPO9M
         WhXA==
X-Gm-Message-State: AOAM530DWk2DCdK4l/ywnDAFRvCCxPCZLaPMeDMQP8c/jq3FuJLZ5VZF
        kIe1jgjLvMcdpJzZKbpP6d8MGuEbU3q5MMPk+n+Ssg==
X-Google-Smtp-Source: ABdhPJw1Q1LZWsSfUdg5KJ++AaDEJOt+yQX9WRATp2fq+leGoZzx2wtIdDgZhUSu1MyvAvJ1CUytU372D/fL0AuLDDs=
X-Received: by 2002:a25:ae85:: with SMTP id b5mr13395777ybj.200.1640678477728;
 Tue, 28 Dec 2021 00:01:17 -0800 (PST)
MIME-Version: 1.0
References: <20211227151331.502501367@linuxfoundation.org>
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 28 Dec 2021 13:31:06 +0530
Message-ID: <CA+G9fYt4MoT0N7o1YJ2ZK=cUPKrGq2RtgsGJsJzACZgYvJs6tQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/128] 5.15.12-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 27 Dec 2021 at 21:11, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.12 release.
> There are 128 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 29 Dec 2021 15:13:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.12-rc1.gz
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
* kernel: 5.15.12-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.15.y
* git commit: 47b0c287880218282c014bf268884d9aad05e3d3
* git describe: v5.15.11-129-g47b0c2878802
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.11-129-g47b0c2878802

## No Test Regressions (compared to v5.15.11)

## No Test Fixes (compared to v5.15.11)

## Test result summary
total: 103326, pass: 88452, fail: 826, skip: 13195, xfail: 853

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 263 total, 257 passed, 6 failed
* arm64: 42 total, 40 passed, 2 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 40 total, 37 passed, 3 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 31 passed, 6 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 56 total, 50 passed, 6 failed
* riscv: 28 total, 19 passed, 9 failed
* s390: 22 total, 20 passed, 2 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 42 total, 40 passed, 2 failed

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
* kselftest-lkdtm
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
* kselftest-secco[
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
