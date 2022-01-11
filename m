Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46A1248A76B
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 06:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347257AbiAKFfl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 00:35:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347212AbiAKFfk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 00:35:40 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA72C06173F
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 21:35:40 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id j83so44259771ybg.2
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 21:35:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xXHC0oKFlfCWoiLwgClkJs4JUDvKCYDFmuE9q77eX5g=;
        b=l39ZRDtln+aFId/Ikaq3OcEOTh3ChRjHrtDBh3DVDySgkC4eHYXnjgpz1NprvTm6IQ
         sOuvrBdjohD2xBqmJZKcQBDH0a3mqQPPsQ9hsepNs04vimdvVwb7740dMNORE4ZmKc1S
         jCqgK/Th5h+yTMU6EbVQ6lOiivlJzXNngfzehXuwAVtteodea+VFbDjUyj88XZKksqQP
         RgPh/j2mU0ZdDNwdqiLh3clTtxumDErpSXFK6/50RLHIwsyrvKPY6qTOrbjlg6GYznBy
         g6iDclzLX1P4YfZtSdszBLalN14TmQ2WfVWjocYMkd/dJN5RQDdWmokD8XnTEcMtrWCI
         Fb0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xXHC0oKFlfCWoiLwgClkJs4JUDvKCYDFmuE9q77eX5g=;
        b=RmjV05FlCfdz3KzKtyfQsdgGqrWYy61n0oHNQgP6bh+j2EwdFv2JuAa/ayY1ABfowN
         Suygzju810g182gIe0m9gDpgvYnAYC7EgYZ0FwjULgw7Nmj5NegRNEk4oCOwSzOmKomf
         5BOcrteH1DSSh6m5BDanw0M92AsPMYAam+XN/kGTS4ykzLOKvPuj9hFdAC+x2nRBD+ae
         fi8+i6gnhZitsGjAhqPgYVKMpf88JIzS1Biz4wW+HEH3x6Qcndvx74E0df5zZBVyO46a
         H8X2pUx/BR6Mfdj0A4BOTwv1TGFLkpEOG//VzY2fS3HkMBdetVx/GIg0o5VAaTGz3vkG
         qHFg==
X-Gm-Message-State: AOAM5328/mrHh+7CZz5DsR+4cO+SrnGm1cyS+sBQJA2HJoXyO09iZvyj
        C5hguJBuX+wvPIYeGyMRQ+AYPMTJJlxmowUSQeRR7f8dgvuT5g==
X-Google-Smtp-Source: ABdhPJzmhGpztsuzCaeZMwimY/lEKU7AqzJEZziH2hR6CPU7QA5D/1rEo2gggisquz9XdfsG25/LS7woPzvH5M/McHM=
X-Received: by 2002:a25:414f:: with SMTP id o76mr4216589yba.146.1641879339575;
 Mon, 10 Jan 2022 21:35:39 -0800 (PST)
MIME-Version: 1.0
References: <20220110071815.647309738@linuxfoundation.org>
In-Reply-To: <20220110071815.647309738@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 11 Jan 2022 11:05:28 +0530
Message-ID: <CA+G9fYupkEbBW9KQwrPkZqp2hpq3oWA8XgS6yEo55o1zHVPOog@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/34] 5.4.171-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 10 Jan 2022 at 12:58, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.171 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 12 Jan 2022 07:18:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.171-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.171-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: 681e37e4e026f3e38040daf69869b507a40b60c3
* git describe: v5.4.170-35-g681e37e4e026
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
70-35-g681e37e4e026

## Test Regressions (compared to v5.4.169)
No test regressions found.

## Metric Regressions (compared to v5.4.169)
No metric regressions found.

## Test Fixes (compared to v5.4.169)
No test fixes found.

## Metric Fixes (compared to v5.4.169)
No metric fixes found.

## Test result summary
total: 88836, pass: 73926, fail: 769, skip: 12722, xfail: 1419

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 258 total, 254 passed, 4 failed
* arm64: 36 total, 31 passed, 5 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 20 total, 20 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 34 total, 34 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 52 total, 48 passed, 4 failed
* riscv: 24 total, 24 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 36 total, 36 passed, 0 failed

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
