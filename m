Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A95947C4F7
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 18:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232891AbhLURYr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Dec 2021 12:24:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231996AbhLURYr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Dec 2021 12:24:47 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB626C061574
        for <stable@vger.kernel.org>; Tue, 21 Dec 2021 09:24:46 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id d10so41054206ybn.0
        for <stable@vger.kernel.org>; Tue, 21 Dec 2021 09:24:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KlmUjgrDgCnHrb4pHRfggpW+PxoV4JLDgRs10VlOABM=;
        b=UUGqlz2Mmd/P8Mxj9A0f0Dvi5GVohPmCCl1RxcoZymUgRQkL+lxZQXeYHtm92xILnU
         h+Tu9H/CwyRaOZW9rak6qNPCF+cjVjWEKniLvnCln3CVW3BbWD33EVAG6eearOJgeh1r
         bhRJWPK7PtutonRub0zdUJE9gRdMb924MSvw3ET34JIdW5miVoyie5SXxi7EnBvRf3Hn
         x466eYwEeNq04da2rhZ5b/gzU2D+rueMzDB/31exWZn8efBnQNaMFBwdVSLQ9N6lwZ3E
         LLHvrXTdDPxfune0tS9ZUhtj/G2D1RwxX7zCuSOcpuAnRKG9AtcyUwdvgras6QCsK8ij
         Hslw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KlmUjgrDgCnHrb4pHRfggpW+PxoV4JLDgRs10VlOABM=;
        b=gjpJl3Xzqm0vA7pizxneZW/eXkHjB1490KbapPAun0QguqIij2PNxbKNcwMCWYBJpg
         xQrHLXxXdZMm3lgVHKEA/iRwYuvOv4+LZbv8qN8OZeDN/fiLb7cWrUm6S0ZuHBzb8JZt
         1w8hsCseBEDZYge6Y7WletyADlHjnepcaPqRLyYmVh16bZr18adbWz26iBD6bK60I9S0
         hVsIOA+R75e1SSWTx87oBKoj/AoakI/GqbRJnLGDysMZ8vUUWZsNc/pcPrO9sCouMXH6
         xgrIv8+yfojt0+FabGzPU5OAOEd4Jtnw3tx4HymwVqiTfLcSXD4RopzdXayeuEz0oUnR
         iAEg==
X-Gm-Message-State: AOAM531L+X4ie2U/w/5Nq0rkeI8oeySj0iptgF63lcKS0H21KsiUsUMI
        PmOo4BMORi/n7wOQ3qoV4GEctYGzS5qMIRiXh3KCAYDyDeE1+g==
X-Google-Smtp-Source: ABdhPJyJ2hs4Mx5dN1WE2hCto9lXtbSx7HjysBti/Jhs3pasyGB4uu/mk3kMbpSs/7a2A9YJenKBVY6Ix1fsrDDTKeI=
X-Received: by 2002:a25:26c5:: with SMTP id m188mr5941565ybm.146.1640107484575;
 Tue, 21 Dec 2021 09:24:44 -0800 (PST)
MIME-Version: 1.0
References: <20211220143023.451982183@linuxfoundation.org>
In-Reply-To: <20211220143023.451982183@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 21 Dec 2021 22:54:33 +0530
Message-ID: <CA+G9fYssvVRBMTh37PBK7DRty8uNfL0KGLsCL6vRVtRRNLZj5A@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/56] 4.19.222-rc1 review
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

On Mon, 20 Dec 2021 at 20:13, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.222 release.
> There are 56 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Dec 2021 14:30:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.222-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.19.222-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.19.y
* git commit: 2b0e0aea0c2aec46fb5e692e66a67cb1701ee5fd
* git describe: v4.19.221-57-g2b0e0aea0c2a
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.221-57-g2b0e0aea0c2a

## No Test Regressions (compared to v4.19.221-10-g1d60913d545c)


## No Test Fixes (compared to v4.19.221-10-g1d60913d545c)

## Test result summary
total: 82353, pass: 67127, fail: 754, skip: 12730, xfail: 1742

## Build Summary
* arm: 254 total, 246 passed, 8 failed
* arm64: 35 total, 35 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 26 total, 26 passed, 0 failed
* powerpc: 52 total, 48 passed, 4 failed
* s390: 12 total, 12 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 34 total, 34 passed, 0 failed

## Test suites summary
* fwts
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
* kvm-unit-tests
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
