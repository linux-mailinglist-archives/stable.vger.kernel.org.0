Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD5984A2D53
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 10:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbiA2JUJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 04:20:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiA2JUI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 04:20:08 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF9EC06173B
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 01:20:08 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id p5so25357403ybd.13
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 01:20:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Fmg8R0DlhNpOmkHKo73NhOYJJVG4NLTqZoLmCBH7BGI=;
        b=a4OatBY7GPljwpd05Z6hIBRgQq+FqhPIp9C1GhohOUpAqaTYr3nBvWW10eYfR1dcrf
         AfdtUn+fgCl2j2DKRSHZp567CnGvI9ECiF3rKbGhbIIPfBM2VtocvVXpNFJzMAsP4MA7
         BmbndYJIHikImP1PNwr08PkHNuTwdhD8Tw1lgQ/DI9vdYXcd7DdUV24y788jNzWO2bhY
         8MIcf62fslW5LEJdo9y4oNNr+LyOAm6cTfgGtomy7eRHjwlsObjMe+ZJ/AKvKOVOAwPq
         plEI23kU7uY15YIXM8ma7gaBt3RRXnNf6gZz3icAsPVuM8iCbkrZTqdnpY13xMnHxXPE
         of9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Fmg8R0DlhNpOmkHKo73NhOYJJVG4NLTqZoLmCBH7BGI=;
        b=gcmoBbdsWouO2vrG2i5g0tWKvMb7/QcZl/W2pzMlkY9EGR+Dx18nH5pvdZZHoUXf31
         PY/mQpzH/E3UzIr9BNeIwdKBaYVJaxlDHkQD7KhCBpWGFAKlhvFFdmLZar2PtQ31JA1f
         04vj0iOIgwTb0Yl2j7t3zN8hSX7kRj3b84x8ptdrzoeY6VsXETA3zfZ0bMttiB8UCP5c
         VwPMqDwz9Vj3RuRNAGxZutG18YTMp5x9y41IZiWO0L5zWxJpXy9jJD620zprrJc0i67V
         kIadX6Kpvscnyfh5BVoLgKHchNQ8fIQEQdNxK7DFNss2IDLsEQ1QNxnSgJsQaQMvdtXs
         f9tw==
X-Gm-Message-State: AOAM531syQCwdHWDP8/9B1shIwDjrACjMx1IR4AzJT0gdUAFZZr0hVs1
        kxs8ntXYGi5FlzmrE1mBKdOlp6Ahkgg5Lp0R1NWtew==
X-Google-Smtp-Source: ABdhPJxon0VydaZw6BrbMxr1ebOAFpPPE4trfgaK38I4rlLdJDsvnvAnuaCSeue48MysxEVAF+RZsbaknHdKUVoEW5c=
X-Received: by 2002:a25:324a:: with SMTP id y71mr18068828yby.181.1643448006858;
 Sat, 29 Jan 2022 01:20:06 -0800 (PST)
MIME-Version: 1.0
References: <20220127180256.837257619@linuxfoundation.org>
In-Reply-To: <20220127180256.837257619@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 29 Jan 2022 14:49:55 +0530
Message-ID: <CA+G9fYszsF8zZ4nw-wL2Rc12+AoZuftdNXx0nvUmKihkztwE=Q@mail.gmail.com>
Subject: Re: [PATCH 4.19 0/3] 4.19.227-rc1 review
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

On Thu, 27 Jan 2022 at 23:39, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.227 release.
> There are 3 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 29 Jan 2022 18:02:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.227-rc1.gz
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
* kernel: 4.19.227-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: 0f7abe705832c477bd2571c77981ca3034202ace
* git describe: v4.19.226-4-g0f7abe705832
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.226-4-g0f7abe705832

## Test Regressions (compared to v4.19.225-239-gcedebae149c2)
No test regressions found.

## Metric Regressions (compared to v4.19.225-239-gcedebae149c2)
No metric regressions found.

## Test Fixes (compared to v4.19.225-239-gcedebae149c2)
No test fixes found.

## Metric Fixes (compared to v4.19.225-239-gcedebae149c2)
No metric fixes found.

## Test result summary
total: 78421, pass: 63758, fail: 737, skip: 12182, xfail: 1744

## Build Summary
* arm: 250 total, 246 passed, 4 failed
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
