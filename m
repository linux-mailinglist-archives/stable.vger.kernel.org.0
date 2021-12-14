Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4771A47428C
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 13:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhLNM3Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 07:29:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbhLNM3Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 07:29:24 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF46C06173F
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 04:29:23 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id g14so61574053edb.8
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 04:29:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=E4kFIQlYfEMdSdQHq59R2bHoiLI2p2NoG6TrGYgOLuk=;
        b=NJ6oraqig8GGFKfjjiJvdrp6uCNr8eqiAFtZuLsv/XPmwFuSkMSPchuCg8P4gWpOIT
         Ee5boJ3tpL5kDsRxIlVQNMmujA65K4tfvQRbZdM9H0vWuyTvukeFC31pPEp+wN5srIU8
         pmPvguHkLJmAXjJYKlCLABiUDozkDBW1f8zIobPM9GTsy6PBdEQvAIYPYrMju8RSgwKN
         zTAdVuJydfUEqzi5zHX5poj9GVP/Cia6vN2jm7Hl6QngDkK/qimcCqcknJDn7jPv/Ftc
         CYtjJ8v2qbktIHy1jWwSkytwYl+HXNVpWGYnnssTp3fGS1yMFcKggHNzOrgAFZZWzp9I
         GMdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=E4kFIQlYfEMdSdQHq59R2bHoiLI2p2NoG6TrGYgOLuk=;
        b=3hko5lYvicco+aMBW2MMorqo0S0URJv3geVSd5lH/b/d63XxLH92MMzra3HaPwGJ01
         vtNvVW4wNHC5gqenSrx9Qv10aRv3G/7m9e1myzZ4at6VfOP67ng3pW43KUBFly/xaSa2
         H+N8KdeGTKpBTXppZrksNAgSSRZj7CZsbECnTRrlj4MWW6wpxJTX4WoScJxA+mdk0Fzs
         AUplmwOYC9QC2QFSD3N98hMPKYCfZ1Vy5vulW0/UD7YNeIVWsI3wTpPXzmSUUQwHGKr4
         Lv60qxRUgTgnMNAI5MX8PAYcL4ntBkWQ7NjbQGIEEojwxdf4dQhx5uLsEI/R5PIyd+HX
         5+sw==
X-Gm-Message-State: AOAM533qoPKEcb0/CK0Nza3p1DoLYgMdqtNubO/IMpla5rQ4UECPeJ11
        6hzXD/jMSVH4A+FLKrTGYrXnly4gRIjWWaZTxY2oCwFSMMLEXw==
X-Google-Smtp-Source: ABdhPJyA4wxMScbUqp/hC1iePv7zro6Wj1o5KvfMibM8p3gaRDWfG0oKTp3Td3fW8Gr+U9HQzDW4SD66W75UyACR2mA=
X-Received: by 2002:a17:907:7da5:: with SMTP id oz37mr5544947ejc.586.1639484962075;
 Tue, 14 Dec 2021 04:29:22 -0800 (PST)
MIME-Version: 1.0
References: <20211213092933.250314515@linuxfoundation.org>
In-Reply-To: <20211213092933.250314515@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 14 Dec 2021 17:59:10 +0530
Message-ID: <CA+G9fYugo1bTbUu6Vk_pXoVEveWqhrTyftfddTx6FxRL5kiDFw@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/88] 5.4.165-rc1 review
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

On Mon, 13 Dec 2021 at 15:13, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.165 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 15 Dec 2021 09:29:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.165-rc1.gz
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
* kernel: 5.4.165-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: 0896ccf9036401df1f284b0a02b954d71d071d74
* git describe: v5.4.164-89-g0896ccf90364
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
64-89-g0896ccf90364

## No Test Regressions (compared to v5.4.163-71-g9be61260aa6e)

## No Test Fixes (compared to v5.4.163-71-g9be61260aa6e)

## Test result summary
total: 94642, pass: 78861, fail: 782, skip: 13447, xfail: 1552

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
