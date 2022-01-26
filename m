Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C21C549C5AB
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 09:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238653AbiAZI75 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 03:59:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238663AbiAZI74 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 03:59:56 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E8BC061744
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 00:59:56 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id 23so69273327ybf.7
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 00:59:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=T0O2RYBvXI413kf/Ld0KJM8o1ANZb53hZiPPSa3Eb3Q=;
        b=iNXv+RaDW65wfKxheW2D7b9IfGYHuJxTwB2B68bkmet85Xb1MEEZxyT/ptI0c7wxAL
         26aZrMDR1GirnHV1w+fTM8PicEFanPRkb2Nw2a0PBYnRj3dtZf/iMHl4csCYjFT3qYHo
         t3YV8JjPYVwxJkfiWY1CHs/+vBxZVUt/7mVVzlItrGRyhLpF/K75qlrpsTMudDEqMGlz
         BeCQMtx5dStL0HWGYQXy1gnG2W433GD2PWDunz34j1Fo7Ti4p3MZY/2IEjwPQox5JLcP
         GOd9YOa56T5SoOWPSZF+9HD7izdiQWf4ULQY5psyTCGIqWHfqRTDWfwLvZCkyQGOst4n
         M7ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=T0O2RYBvXI413kf/Ld0KJM8o1ANZb53hZiPPSa3Eb3Q=;
        b=DXRa26oFe49dcucbPnXzR7p4nS/B1l1Z5oQ/U5sEzC+oeucwmYzUlDQND4+bsIUb/2
         R0+7cXohpRZ9cP3zO8rpk64/D8uBC9qHZL5BNlCoYM1qxH+QPUv21IBN3NGm+3gkR/Gl
         3V25siI6kfHXjJ4VU1oocCOvKTZ3wz1BqtSeLv/H8JbZZeQyZiLlOcCbfbxaJajlnpn8
         pHdWKo9CSKmhgxxDGMrFNovi6JlELMMtG0GbCCshks4Nk7nm1XvG2kKnLbWKymrfw3E+
         ISpgntgDSdJqJW82r8e6RGninXyBU8pvsEG17co+3BMKfX6i+X/Ew+50BBt4jATKAT1/
         5LQw==
X-Gm-Message-State: AOAM531aoiDU6+n5xA7nogfq5jJTu2oqVnz6N+ngqhDx1+0YAWfU1SmH
        YQz4fClxUidFtf4oYQmhhvKZqgmtqwVQDX808Wf3cg==
X-Google-Smtp-Source: ABdhPJx++/1jA2g2gynru6Ctuaw26a/eB5z81sieyhm5ETtWQOf3hqbae5rGoRyaEdc4eOFPDSXX4nZS4w4nkl+KCHg=
X-Received: by 2002:a25:838b:: with SMTP id t11mr33546069ybk.146.1643187595464;
 Wed, 26 Jan 2022 00:59:55 -0800 (PST)
MIME-Version: 1.0
References: <20220125155423.959812122@linuxfoundation.org>
In-Reply-To: <20220125155423.959812122@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 26 Jan 2022 14:29:43 +0530
Message-ID: <CA+G9fYscJ1-KUg-XAaykXNY4-7X7MgUFKgdZWWFB5hD3+SHu+A@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/841] 5.15.17-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 25 Jan 2022 at 22:02, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.17 release.
> There are 841 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 27 Jan 2022 15:52:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.17-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.17-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 384933ffef76e18b9783e4777881d7aca33c32d1
* git describe: v5.15.16-842-g384933ffef76
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.16-842-g384933ffef76

## Test Regressions (compared to v5.15.16-847-g86228f6e03f0)
No test regressions found.

## Metric Regressions (compared to v5.15.16-847-g86228f6e03f0)
No metric regressions found.

## Test Fixes (compared to v5.15.16-847-g86228f6e03f0)
No test fixes found.

## Metric Fixes (compared to v5.15.16-847-g86228f6e03f0)
No metric fixes found.

## Test result summary
total: 105489, pass: 90245, fail: 743, skip: 13539, xfail: 962

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 263 total, 261 passed, 2 failed
* arm64: 42 total, 42 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 40 total, 37 passed, 3 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 31 passed, 6 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 56 total, 50 passed, 6 failed
* riscv: 28 total, 24 passed, 4 failed
* s390: 22 total, 20 passed, 2 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 42 total, 42 passed, 0 failed

## Test suites summary
* build/gcc-11-https://github.com/raspberrypi/linux/raw/rpi-5.15.y/arch/arm=
/configs
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
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
