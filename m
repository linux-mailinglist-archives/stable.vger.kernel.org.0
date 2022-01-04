Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8AAB4842DC
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 14:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232574AbiADNzI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 08:55:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232511AbiADNzI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 08:55:08 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2701BC061784
        for <stable@vger.kernel.org>; Tue,  4 Jan 2022 05:55:08 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id e202so65540853ybf.4
        for <stable@vger.kernel.org>; Tue, 04 Jan 2022 05:55:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uICLl7ALMQbyPSU7KmBXA9OTc0fxri6yRq599PdZEK4=;
        b=kGRkffB/vzcg98AS1YV5pMh/tmyyjXEmXl3l1QpeRnFprZyx6MpCwGM6eRU09S3F4G
         bqFvcBokuAE8IKVz+dLNqdI8o+Zlcx9HYxMgyVB2A08KvnGzM/Jz+KZqg+7hCDBYI8pW
         viCynoDXhHTwaWKQpqVmBjHa7Nr1JYAccjd3H/IQKgvfc/4ZnfsRcAlI4BHZQVha7zTx
         UAOdXu2uJj6+ENWx5LTA7JmEnn9jHMxlklPaEqzuyN73r1G8DI92oZaicdx4GY5ZJohr
         gfa49fIuz0dQO/xFmDe/cmNztwNzIhTvhQ8Y844QtYlh/YCZTiuk/uTJFKYDCU4JVz5Z
         7Zbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uICLl7ALMQbyPSU7KmBXA9OTc0fxri6yRq599PdZEK4=;
        b=eFeIODhzxTM3ZjWcdOsyI/rH1b1N+aViD8WXY/W4dT/00xLhDkcTj8LSTTT59uQKL5
         +8lfniYk2iThkkAmMiL/4axi22yFVn7UppFNLikekeiZPLhIffZvpvhsw9WtJzao7TxN
         LrVEo0N+tJVR/wBYoIXckHr2L/hvR+JisLfeJlpjE5CHl7p5u5nJ4lM2cYpZ4dG9wYU0
         46WFYC6T0LpgKUYQPHdHK3zK45TSU3wFqJPKnfqQUnLie96egUiiQ8m0fmxk8vX5ri0p
         73jv/Pr2QchKzEZrPwyC45RPJAbImEK7r+OXwvA2+M11BpfqMX/qCis4/Edw3ZDMlELW
         f7gw==
X-Gm-Message-State: AOAM531AdYoAlwj7tpw7D9+S83BzUr2zyWIKJr/kyuTAjptHi2VZSc2S
        4TT+8UBZR7YOtILP/X9Napsp3qc+p919hB5Cm4ubBn9fy7wxLQ==
X-Google-Smtp-Source: ABdhPJzzqIseI0oQdOtLu75NcsaQhp5C9T36Sdr822+Mr9yJhImaYv/fXv72XKnWiATEF0wqloGLNTHy7MR/Pp6yfGw=
X-Received: by 2002:a25:b981:: with SMTP id r1mr54967879ybg.520.1641304507196;
 Tue, 04 Jan 2022 05:55:07 -0800 (PST)
MIME-Version: 1.0
References: <20220103142051.979780231@linuxfoundation.org>
In-Reply-To: <20220103142051.979780231@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 4 Jan 2022 19:24:55 +0530
Message-ID: <CA+G9fYs8YtKsu+adOaswD-v8m0mkEsamJR5E-NRQ3rW-F32rfA@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/13] 4.9.296-rc1 review
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

On Mon, 3 Jan 2022 at 19:52, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.296 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 05 Jan 2022 14:20:40 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.296-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.9.296-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.9.y
* git commit: c154c6cb3efdb71f32e51470e61b791083fab40c
* git describe: v4.9.295-14-gc154c6cb3efd
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.2=
95-14-gc154c6cb3efd

## Test Regressions (compared to v4.9.295)
No test regressions found.

## Metric Regressions (compared to v4.9.295)
No metric regressions found.

## Test Fixes (compared to v4.9.295)
No test fixes found.

## Metric Fixes (compared to v4.9.295)
No metric fixes found.

## Test result summary
total: 54919, pass: 43155, fail: 435, skip: 9846, xfail: 1483

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
