Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5DFF48A9AD
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 09:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236373AbiAKIjo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 03:39:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236356AbiAKIjo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 03:39:44 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE89C06173F
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 00:39:44 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id e198so22447487ybf.7
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 00:39:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=T+/gfKVjd06ywoXi0uXiNGcjF1CBfh8OJNr7zztK3mY=;
        b=H7q0OrNwN8ywepg390c76Ny7LvEqrBvzow5sqzpioSL8iG7EVTrENMnc4tgdDnOXPS
         pIyn6L133CFu5kdvaLtoTTjpCejiAHC/gwlmCNtAEbOYRici/6JJebEqu2K8OVwNU+rv
         rBpE6nUaWGjqpxgE49/zqZ0yfGqh2vfHwlBwr8fyKirvCd2oKoeu/w/dP9MGjUGvfpid
         /8ciaV7Y/OoNL8bF11cpO2uWJCqiT/RgXXf3mnEv+lny33ZsY2keZleQWJwGxdxejDs0
         pih+NIaXqMT8FBZsXs6YUnmbsMUek/zb19DFPSz0IEZduQ5rt/QcY/F/3sTffEMDnUKw
         CPow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=T+/gfKVjd06ywoXi0uXiNGcjF1CBfh8OJNr7zztK3mY=;
        b=3GHN1D0hyWks1efGOSYZfV/dv+JMiNehinxvP/DYNGS4Pz1bin5fWhRJunarKPLaJQ
         UUqSv9pLjrxKiMxYTfGApalkxYpvs9hvTsxvOmMSstPoGVo3s6GGf2IQqWYCZad2H0CB
         xGvtiiTZoMnQafjPGjEcelfivGoRdCU8nZ8JTdxaLl3VSWdQpb3MIj+tAUAWnA+9wDeY
         wrpMyL71a6t7PgqVUQ7CxKB1mc7/Ls0wl3g3zSI2QEdQ4ZJNhY8jcuKkMTTxw6I2FWyY
         JVN0HG7CRZdBb2iceMQHtwrVmj/CiiLQp1K63bI6PdAxaBE/W37OLLrEZBXthZ6ozQlk
         vwwg==
X-Gm-Message-State: AOAM5321tq0XWSZJteP2RLc74qcssdDxFhCMUAtB42+UAei7ly3l5V90
        InmpHM2T/mGPefW1JAXDcselVPJA+EDuTOYwdoIRCQ==
X-Google-Smtp-Source: ABdhPJxK5LKRZx2tIsnqyw4lDSt0EBsiNA5l74rDzMBi0NXKXWoOfnwzy12JbkfIdXhpK4H5vQJJvf74SVRRWPlbdsI=
X-Received: by 2002:a25:a04a:: with SMTP id x68mr4654632ybh.200.1641890383256;
 Tue, 11 Jan 2022 00:39:43 -0800 (PST)
MIME-Version: 1.0
References: <20220110071812.806606886@linuxfoundation.org>
In-Reply-To: <20220110071812.806606886@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 11 Jan 2022 14:09:32 +0530
Message-ID: <CA+G9fYvZAs=c_e07eD8TusdVs=xjUbrVDCjPOK_rmbmm7MxCiA@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/21] 4.9.297-rc1 review
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

On Mon, 10 Jan 2022 at 12:55, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.297 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 12 Jan 2022 07:18:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.297-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.9.297-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.9.y
* git commit: 166c7a334704473e72e891612b8ffa513e43754d
* git describe: v4.9.296-22-g166c7a334704
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.2=
96-22-g166c7a334704

## Test Regressions (compared to v4.9.296)
No test regressions found.

## Metric Regressions (compared to v4.9.296)
No metric regressions found.

## Test Fixes (compared to v4.9.296)
No test fixes found.

## Metric Fixes (compared to v4.9.296)
No metric fixes found.

## Test result summary
total: 61520, pass: 48909, fail: 438, skip: 10557, xfail: 1616

## Build Summary
* arm: 254 total, 226 passed, 28 failed
* arm64: 32 total, 32 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 31 total, 31 passed, 0 failed

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
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
