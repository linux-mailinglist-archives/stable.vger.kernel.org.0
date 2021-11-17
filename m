Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1F5453F7B
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 05:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbhKQEdG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 23:33:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231512AbhKQEdG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 23:33:06 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15F1BC061746
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 20:30:08 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id r11so4813907edd.9
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 20:30:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GBiotd9TPk443msjTitQxRpdRQ8aKkjHS+WS9NMJP9Y=;
        b=FyU8RxUNo+Ff+qybKy2fCqxbL/iubTDCJRFCMjqnwpTSNA3NYOo4cuQz4zx83nF/4F
         MilafL9vHg25wmZF8TbTrGPu+KcYrM25fDOCCmhbqEQvuYgm8EQ07I+qKPfB4Wn017QT
         Cx7Hh05UA//pxRlTm3QxMji01138PLAzOaa2kwQr+Gc/343a4LwPlKH4ySMfjOSWTbyM
         g/VmxO+1hmMTMFOAcvHfM6YqmEFfxRAwNcSGJz/D42H4JSgj0r0lgmHwiTsHZSM101dK
         Izdds1vRSVItxzZOkYTYzj9C5p2XCBvuOTihK0XnbqCp7Vddkagmw9vQQyjyKTmuoDMY
         SArA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GBiotd9TPk443msjTitQxRpdRQ8aKkjHS+WS9NMJP9Y=;
        b=ZrkbIR3sV9pOY0f0Y7mlkWQ0XclCtD+loMRF5cWVlfftCsPb8mz9ycSDMDBDcRceun
         xyLxXT+NlEE5FPx3Xrm8mF9LYmdcJHFacoaPEBfktbQ+GT95jai1vM4CvGnae4qjHJZ3
         7VBdSx6LDn25mVk3xS3Jc4IZwff7neoPsp6uk9QYzxxgaJ6pusVdlF12zhja7k14uHS+
         x5ytKoyO/Vtw/ZSx099oSN2L9HZWWjgGdYAt7KB3zI/FUTuY2KXbiCsrfaoSib3wzAvC
         ALpNBMmCnRu8VKkEwveNIdrmXUEqbl4FvpCuP2y4pT4jqK9a1jjITJ8J7eRt/5N8WpqA
         kl2A==
X-Gm-Message-State: AOAM531gitu7AiipYJ8JEeViFDG21XqJZPz9OOIaDGnIIe9TEAmlgtG3
        VbxZt/nKwoNXjFmIv9wFQbW7gX759kZC9N7293Ys6A==
X-Google-Smtp-Source: ABdhPJwWqC8Q8ki0YfZJOCGmg1cgmhWpkr+KnfkgNFxynn1u84n15y8pwJO3S6TuKRxTetKBCl+Ygua0xFRiZux5DIc=
X-Received: by 2002:a05:6402:4412:: with SMTP id y18mr17124893eda.103.1637123406474;
 Tue, 16 Nov 2021 20:30:06 -0800 (PST)
MIME-Version: 1.0
References: <20211116142545.607076484@linuxfoundation.org>
In-Reply-To: <20211116142545.607076484@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 17 Nov 2021 09:59:55 +0530
Message-ID: <CA+G9fYtJjjVE8ojCYyXPm0gPUEcJtXHOqTCrofLZe2iFzxg2_A@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/578] 5.10.80-rc2 review
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

On Tue, 16 Nov 2021 at 20:31, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.80 release.
> There are 578 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 18 Nov 2021 14:24:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.80-rc2.gz
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
* kernel: 5.10.80-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 739c1bb0c245e2cc4f17c702cfab9f839138c867
* git describe: v5.10.79-579-g739c1bb0c245
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.79-579-g739c1bb0c245

## No regressions (compared to v5.10.79-576-gdec2599e2512)

## No fixes (compared to v5.10.79-576-gdec2599e2512)

## Test result summary
total: 89407, pass: 75813, fail: 552, skip: 12241, xfail: 801

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 290 total, 290 passed, 0 failed
* arm64: 40 total, 40 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 39 total, 39 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 54 total, 46 passed, 8 failed
* riscv: 24 total, 24 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 40 total, 40 passed, 0 failed

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
