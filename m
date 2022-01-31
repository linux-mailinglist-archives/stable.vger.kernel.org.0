Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 122E14A4F4C
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 20:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244352AbiAaTTS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 14:19:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244349AbiAaTTQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 14:19:16 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E39C06173B
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 11:19:16 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id g14so43602708ybs.8
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 11:19:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qwzRzEwuqw6nEEp+LR5bpH0X1lKdQy168fe8lxN1IKM=;
        b=zJubMy7thZhS/EBI1H83EKRih8gg4scNwu2xIsSa1blElYQCDoBQ1Txv7GlSx/hm4/
         TsuQsRPX6pZKfaPkaL1aGkrBaKrliP4sb7FzPMRTRhtjMIhA4G1Aw5Tl1XAn5r6JoRDm
         kkHFmmvTRitOnkoqQ6wmvY9Dv3RPoiYHNegXprdNQd1PBr88hoHuy8vDwwVc96lgKjRc
         xpSzEp2i7jmqxnEtorFSK/MEoFaVBJZc3/FY+xwKAhvQpttEjPwoRxk+hw0RkR1r7+ps
         NshXAWKPuDna/T4iHP4wP9KZ6xQqu/VSbqmp3bEvt2z6abpHnQl1lyusSMRj2lsOeGLE
         /IxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qwzRzEwuqw6nEEp+LR5bpH0X1lKdQy168fe8lxN1IKM=;
        b=DRKzAZ1h5m0x3nTXLR3FsSsOkl6+HOgE5FtGaV+OErGNJa8oDEUaG71iFZK8Ri44+q
         1ZGUsjM+iJSnP5wwhgCNXC1TfUBbU189Qv01DVf+tTQCyk0sUow7TIB0YbQY395R9GEp
         UjWfseUMJnEsxkaH5ihPdK/eEt61tclITaAospavrSwdKkCcwQXYD08VU/OBeM+3YLE1
         Ht5+CyG5IPM5n9mkUEvIfdtk1c8dG5OKoa+cspgHOFcEHNOhitNclA6Kfjhh4BbLshyk
         Bz3dMVHjPxg77JO7iVTuf0WuCq1yPIzhKK2HatSt2QqBwORjC1KPH7fRetKIX9C57hQl
         9n4Q==
X-Gm-Message-State: AOAM532B6oFZOqvy+xWoT2elM7HYwuX35APXTgUWsjv1M7b9TTAQq0ES
        Boeo2/02WN5wIN9cv1eyCDc7wToIjhj2IoFQM9n2vw==
X-Google-Smtp-Source: ABdhPJyYnNwdAU1m/B6iTqafIETaENwmrGumtargwR6xtWgbQcDpkU4yxkaq1OqtXMiP3jVJiuheTfBUgoSe4i8Szz8=
X-Received: by 2002:a25:b13:: with SMTP id 19mr28937432ybl.684.1643656755203;
 Mon, 31 Jan 2022 11:19:15 -0800 (PST)
MIME-Version: 1.0
References: <20220131105233.561926043@linuxfoundation.org>
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 1 Feb 2022 00:49:03 +0530
Message-ID: <CA+G9fYusQ2Y5_QZ_f+V3D_aGNbcNgf7PdU13BoX9oMoQvv2q-g@mail.gmail.com>
Subject: Re: [PATCH 5.16 000/200] 5.16.5-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 31 Jan 2022 at 16:46, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.16.5 release.
> There are 200 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 02 Feb 2022 10:51:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.16.5-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.16.5-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.16.y
* git commit: 04f8430582e6a2a7bb728d05119e2d66bd3c819a
* git describe: v5.16.4-201-g04f8430582e6
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.16.y/build/v5.16=
.4-201-g04f8430582e6

## Test Regressions (compared to v5.16.4-187-g950d978a980e)
No test regressions found.

## Metric Regressions (compared to v5.16.4-187-g950d978a980e)
No metric regressions found.

## Test Fixes (compared to v5.16.4-187-g950d978a980e)
No test fixes found.

## Metric Fixes (compared to v5.16.4-187-g950d978a980e)
No metric fixes found.

## Test result summary
total: 84643, pass: 72410, fail: 848, skip: 10560, xfail: 825

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 259 total, 259 passed, 0 failed
* arm64: 37 total, 37 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 36 total, 36 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 34 total, 34 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 52 total, 48 passed, 4 failed
* riscv: 24 total, 20 passed, 4 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 37 total, 37 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-
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
* prep-inline
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
