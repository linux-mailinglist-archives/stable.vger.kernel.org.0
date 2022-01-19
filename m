Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9B049389C
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 11:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345242AbiASKfU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 05:35:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344549AbiASKfU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jan 2022 05:35:20 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DCD7C06161C
        for <stable@vger.kernel.org>; Wed, 19 Jan 2022 02:35:20 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id m6so5978755ybc.9
        for <stable@vger.kernel.org>; Wed, 19 Jan 2022 02:35:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rUKeKsjrWT9Cp/WtLJMVg1xmKzt09vNFzaRVXi5Pt+8=;
        b=Ub6J0W3Y67POIPR1h338w1Mg85jgaV9lFjNg2DLDx+ZYkSzN+sG0hObnGVZtfw6lzo
         7+MrS/lfE3CgnRo1ydR4VLPJNzFM8vsZsfaMLFh77fSi57UrkskqgFkiyaPoGePDm8qT
         hGPu4cElSBb/YHj2IOYjMxwbepD9r0zvEElXzVybmBn24FEVpFYIS2N9rEoyztKOJFKE
         ou6OuUTIS2WuwTIjP9x6AQl9aD5qiRrlHOaSOcDc7/5J9oWcHKAFguVEYQ1Tm9avryJi
         pqn5yXd5nA/lKpjQrbpn3K9TCk4ZhFJ0X4GtbbpkrM7Qnenqf2anSgDXIlPTQeXW4yrB
         uFqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rUKeKsjrWT9Cp/WtLJMVg1xmKzt09vNFzaRVXi5Pt+8=;
        b=ng1yS0zu2T0ds/z700+v9RA5xZNGorTtJ6ZHy5nL8cw1KxnJvPmThTiwJtsdh8vfLm
         psoryKPGtdvNMhmHC5/+16OEMoqcj/J8xggQrmwftXedZz2sWS9av/Fj/goWrkSAgIMZ
         jqwqDOUDaeGhQkWGOL+u7IbTQSYB9fzc5rhftpfliF+Hu9/MIzGxeoh48urNLAtLBEaI
         arXl4lI6pI/IdwOAXt6nBFBfN0a1mwXWqAKKHeYPzd15+zrMV0gtdkcZEIBH3w4ujC6W
         cW/vdCdJKcsAHa2TarmucacFuhU7egW6n2Ur9XLEUTnZ9dmL5LQCh/aL0P1x/4P64x8a
         jKwA==
X-Gm-Message-State: AOAM533fh3HjhOD3PBIGFd5FZi/gfvMEa4hI1jKC/h+E1/7S6UBxI9rO
        mb+6rffCfMwlzq64Byj+RliR1Nj3fjCSPOZqRP33ugwQW/AEvQ==
X-Google-Smtp-Source: ABdhPJw/vYew1FkR09Brq4X0P17iLMqtPO7S0/RJNI9cQswIR9ZABIavOoLobixST2/jsgHrZ1rt30ueALY8g1uTpYY=
X-Received: by 2002:a5b:346:: with SMTP id q6mr19257512ybp.704.1642588518011;
 Wed, 19 Jan 2022 02:35:18 -0800 (PST)
MIME-Version: 1.0
References: <20220118160451.233828401@linuxfoundation.org>
In-Reply-To: <20220118160451.233828401@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 19 Jan 2022 16:05:06 +0530
Message-ID: <CA+G9fYujm6ezVyEq9PTJyo9Q9=9-goJtM3m7Ah70x-t0SZ9Zmw@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/23] 5.10.93-rc1 review
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

On Tue, 18 Jan 2022 at 21:37, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.93 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 20 Jan 2022 16:04:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.93-rc1.gz
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
* kernel: 5.10.93-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: e0476c04ea8991e23850dab84ce56ab557c56986
* git describe: v5.10.91-50-ge0476c04ea89
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.91-50-ge0476c04ea89

## Test Regressions (compared to v5.10.92)
No test regressions found.

## Metric Regressions (compared to v5.10.92)
No metric regressions found.

## Test Fixes (compared to v5.10.92)
No test fixes found.

## Metric Fixes (compared to v5.10.92)
No metric fixes found.

## Test result summary
total: 91017, pass: 78176, fail: 498, skip: 11633, xfail: 796

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 259 total, 259 passed, 0 failed
* arm64: 37 total, 37 passed, 0 failed
* i386: 35 total, 35 passed, 0 failed
* mips: 34 total, 30 passed, 4 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 52 total, 46 passed, 6 failed
* riscv: 24 total, 22 passed, 2 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 37 total, 37 passed, 0 failed

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
* kselftest-kvm
* kselftest-lib
* kselftest-livepatch
* kselftest-membarrier
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
