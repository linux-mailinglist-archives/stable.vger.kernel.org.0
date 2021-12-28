Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC09480741
	for <lists+stable@lfdr.de>; Tue, 28 Dec 2021 09:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232897AbhL1IM2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Dec 2021 03:12:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232588AbhL1IM2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Dec 2021 03:12:28 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32E9C06173E
        for <stable@vger.kernel.org>; Tue, 28 Dec 2021 00:12:27 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id y130so27143736ybe.8
        for <stable@vger.kernel.org>; Tue, 28 Dec 2021 00:12:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tXtzcFyMaHPATlLxLSMta1PDXKmuXlpZVJiyLRTiMpk=;
        b=MATEnt/jbkP19I5DH70G8wFzOk9QXcO1oiW+miUSssRqZpE83dltIXPCJ9vMEd0G2N
         Mu4Hwvr83GyFjcmxoU/sj+4d3ID6xemyXRBj2FD23BAU0E0yR/mfosLNKPZa4kYk5Wd8
         zKCpHtU3ijuUr75arAc1pCSHG9S+puQWGCVT2pO0ec6Np7T5r1lFJ4hYFSajYRH/wyit
         tD2TadRGtDocFcvj3VvyEhD5rfqU/mSXLDKSYW4qHIiLUlCvFU8Kh3gCQXKhml3XOFk1
         qrM1MlveozGrJ21ihV75MIxh4dzLJDUQS5UFFQBlqnrbEgxvK63dueu1+V1hD1XzQzJB
         UtKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tXtzcFyMaHPATlLxLSMta1PDXKmuXlpZVJiyLRTiMpk=;
        b=X+e7tnDgHX3NG6okMWZNw8EeNSG+JUjka7GeQyn288e0pBeAjkiQIMNX2pTEuQt+VK
         sgdvCZZyXiH5wcGrTu2BM9jWPMgjkgEhCHR+t/a2LHX4yp8pqaSJldaEkHQHzXUiQskR
         DLHG9yhhJrHexZifycnAGOQYOtlIj0gfRt7XlvtKpsz2vzEsZpuFic1MRYLu4gPTiS6O
         1YHrLVkKh/gCySgfAu4kP+g+W4AI1lhOUtshxLkrF4Pwec+Wha2JTLv5v0+kaS3mOnFY
         EASlrfBEjGBsUh+blJPMa6w+qiuc8X87jz1oDpYSXul854o9FG9A1NErXe3NkIHp4jkj
         Y23A==
X-Gm-Message-State: AOAM530fR1CgRsQBV/uTpjnelPmw9xcRqBdC6PzLXvo5ffyavfPK5wYr
        2oaRnTpeOwwYLB93De0dHKUixIj5PnoSmYFVR7iwAA==
X-Google-Smtp-Source: ABdhPJz7m8EZ+QorDO//n4w5Ona6jVHugFGB+rn9uz2ilMqA/H2mrOmWjQuOmziQR4rPSp431cQQrEkG2J9ggYtwCJY=
X-Received: by 2002:a25:84c3:: with SMTP id x3mr7191644ybm.553.1640679146858;
 Tue, 28 Dec 2021 00:12:26 -0800 (PST)
MIME-Version: 1.0
References: <20211227151324.694661623@linuxfoundation.org>
In-Reply-To: <20211227151324.694661623@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 28 Dec 2021 13:42:15 +0530
Message-ID: <CA+G9fYvKUeOQ7WCg7xMB2y9DuG5VOFAnAD6+GUsUiKvxVvpyyg@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/76] 5.10.89-rc1 review
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

On Mon, 27 Dec 2021 at 21:09, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.89 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 29 Dec 2021 15:13:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.89-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.89-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: 44b3abecd41b48c75aab8337849358703fa5d58d
* git describe: v5.10.88-77-g44b3abecd41b
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.88-77-g44b3abecd41b

## No Test Regressions (compared to v5.10.88-65-ga809519bc1d9)

## No Test Fixes (compared to v5.10.88-65-ga809519bc1d9)


## Test result summary
total: 98599, pass: 84552, fail: 547, skip: 12501, xfail: 999

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 259 total, 255 passed, 4 failed
* arm64: 37 total, 37 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 36 total, 36 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 34 total, 30 passed, 4 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 52 total, 46 passed, 6 failed
* riscv: 24 total, 16 passed, 8 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 37 total, 37 passed, 0 failed

## Test suites summary
* build/gcc-11-https://github.com/raspberrypi/linux/raw/rpi-5.10.y/arch/arm=
/configs
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
