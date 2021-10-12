Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFC8A42A0FB
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 11:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235722AbhJLJ2M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 05:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235682AbhJLJ2J (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Oct 2021 05:28:09 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 030D9C06161C
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 02:26:08 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id t16so56758472eds.9
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 02:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Ozsk5wU9BRdehEm6wfFkwHm7LZpP1yOcjBM51oE2xXY=;
        b=nxAZmBEO/uB9toOz505VYHMZKds9anF1BM4pyPIWx3CrqNyrN1RTGbT4dXhNK64xcv
         DM9+uca91rPdwFXUoNsMyETp6X5Kn4RqKGyWLgQ5YUjVV7wrbkkFvAbd+9xMN1ir2Nyi
         JF3E1+WxFXaDky+CYe+Awlm4eZ6YS3xuX2EOuRh6rW+C8rR621j+2UYIOw4fn8drfZhA
         dBUdztzR/aZwdgVBwI0VWLlhkKFh0hB3YgPy2HQkkbtwRChNtqOkAs04cfkS/8V+gZrl
         SAHbCmaA/Wqv614/qRh06GIw7Xnhc3VydLgijtV/KK1jZ7UVne1LB3Q82EB2k7f7tAfu
         M2OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Ozsk5wU9BRdehEm6wfFkwHm7LZpP1yOcjBM51oE2xXY=;
        b=YgRT9yLsItbvA4xKQV0sSTjUopJh4z7mP2nDCD7n9hZteHmilU4af46blaVUFPbgDB
         PMfhl9CwFg905dnZOLldc5S87ReWeyTz7MClQF5EOVG1T8c6jYxjuCiwKds/nldg7UnE
         xNofcmqPjaI+wx7YsZigradA1loNM+7W4mHnvp0mBUKDtk+YDvWLAuvwn3DPeTJJfq/M
         eCXiBZRJqE/5XUQJKet3jEG6we0uLfs+4nmVWLGd7bVdhlRRkyRkhCZrExaM6nQySXSC
         qkwxQ4OFsIzU9v/GGRGSlc3h0EmPg3uh1gyXhtrZOSlIRxV77JWGfEMlQOJXEPcQ9O1u
         Oa3w==
X-Gm-Message-State: AOAM532jC6GiPPSREiQsQ/9G0DaixXvYB4KFbinbRfdAxGAGo5fAq2xB
        hQfOzBsmQIybdcH+zBy4jTlk9EBiXXxKCrmohkQV3g==
X-Google-Smtp-Source: ABdhPJwHd/r5h9LPbSQgbvVWqIim/F/A9SIvxiQ3dVgZYJqMkalFXGfXdPDRQ8ggp0IDSY9Ix47J9PxDApGWxVc7XlA=
X-Received: by 2002:a50:e184:: with SMTP id k4mr49794940edl.217.1634030766417;
 Tue, 12 Oct 2021 02:26:06 -0700 (PDT)
MIME-Version: 1.0
References: <20211011153306.939942789@linuxfoundation.org>
In-Reply-To: <20211011153306.939942789@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 12 Oct 2021 14:55:54 +0530
Message-ID: <CA+G9fYu1ybgNS4ttzk+-t_4evb5EsZMdTdCS1Qa1BGyHctR_dA@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/82] 5.10.73-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 11 Oct 2021 at 21:04, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.73 release.
> There are 82 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 13 Oct 2021 15:32:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.73-rc2.gz
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
* kernel: 5.10.73-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 0d59553e5bda91f40076ce48a3f6025079d45ac4
* git describe: v5.10.72-83-g0d59553e5bda
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.72-83-g0d59553e5bda

## No regressions (compared to v5.10.72-85-g9564d0571928)

## No fixes (compared to v5.10.72-85-g9564d0571928)

## Test result summary
total: 88621, pass: 75123, fail: 566, skip: 12197, xfail: 735

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 289 total, 289 passed, 0 failed
* arm64: 39 total, 39 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 38 total, 38 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 39 total, 39 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 36 total, 36 passed, 0 failed
* riscv: 30 total, 30 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 39 total, 39 passed, 0 failed

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
