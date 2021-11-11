Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD97944D851
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 15:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232265AbhKKOfV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 09:35:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232182AbhKKOfU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Nov 2021 09:35:20 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B64E2C061766
        for <stable@vger.kernel.org>; Thu, 11 Nov 2021 06:32:31 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id j21so24741115edt.11
        for <stable@vger.kernel.org>; Thu, 11 Nov 2021 06:32:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ntyQoIMsqCXcReeRS5/ylB7GeUq21ujmpM7z4typwPw=;
        b=fOvlvPBFrbQbpkouPvU6yzpZLf7IgKR+rMTwe7ar6Rk/aWzh1+3HwVOrXlAPd2pvru
         1EaxYkmMeZmCUbQ7IDeKZxQibsPBDbWDLF8tsN7DLJeRMAt5SZ4W7dwvtpMULfvRoxoz
         cvqRUvthlTOKJ++ru04nWDWKwdusixuXknL8QRCJjuKxmwhpW6P7sgh78SECog1718Gu
         zpqXHqvrUasrRU5BBtPg79kZtUs4bGm9eAnwUyP4Wb8MXlK6xyS12GPfxpfJ0/S4nIXO
         b+xNfbEnS52ysd1Da96ogKWWQJAu6tcc9PYflHLFmBDDVYwyZtO86XDLJIk5hqgDOpjt
         P6+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ntyQoIMsqCXcReeRS5/ylB7GeUq21ujmpM7z4typwPw=;
        b=j7C3Ks0n74ORaZ3dM+OlUtBEVLIbdmA5fRQFQZioKeJFHaoVB6dka09pLLsEB2CDxL
         eD2hwsSZkZBYuAv+kSAvmICkRSteoCvhfqYfs8QorZz0ivtU0omwdFTy9L30KLcOrdMM
         U3g75KLPaSFBLKti2NOsDu7bNBMhDgDfw4C2zXBAkZ0hLtnjkG0euMldoCzcXxLV68xX
         Kal7vscnyXBkZX2choH2VNv4FqEnuYLid1t9MKb1kls5KUZ3xQBivhAZuUaHsq3USrTW
         uC9EeNvFKuJg+uFpubkID6j2G9AyaSO45uP0wJ8b+imH3PlFG5/gAwRZLK2jv5DpC8c2
         yJfA==
X-Gm-Message-State: AOAM532mwNVZ6ktWBUR04vlimvK526NWHbauLHGoHV7HcSxfImzai7Ql
        lIbdAe5/gTBJT1TBsWjRcSYqlbINXcL/mQi292U4fA==
X-Google-Smtp-Source: ABdhPJyNGvtI0jStQdpzcqafH5hK8YL0uhi2mAyz5bo0nBTNG7M5zlU6whxmr4XRVNbjbu634WWWBSVWbeF1uHybIJQ=
X-Received: by 2002:a05:6402:4412:: with SMTP id y18mr10191911eda.103.1636641150024;
 Thu, 11 Nov 2021 06:32:30 -0800 (PST)
MIME-Version: 1.0
References: <20211110182001.994215976@linuxfoundation.org>
In-Reply-To: <20211110182001.994215976@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 11 Nov 2021 20:02:18 +0530
Message-ID: <CA+G9fYsUwT8QssS0p_r94QfFC6hG_dqkWGzkNOKgTGY_0BnkUw@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/16] 4.19.217-rc1 review
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

On Thu, 11 Nov 2021 at 00:17, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.217 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.217-rc1.gz
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
* kernel: 4.19.217-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.19.y
* git commit: f1ca790424bdd0693e501e24dc3300f01460cfed
* git describe: v4.19.216-17-gf1ca790424bd
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.216-17-gf1ca790424bd

## No regressions (compared to v4.19.216)

## No fixes (compared to v4.19.216)

## Test result summary
total: 83189, pass: 66945, fail: 783, skip: 13526, xfail: 1935

## Build Summary
* arm: 130 total, 108 passed, 22 failed
* arm64: 38 total, 38 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 27 total, 27 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 22 total, 22 passed, 0 failed

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
