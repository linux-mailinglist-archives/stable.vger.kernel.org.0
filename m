Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB8C462C5E
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 06:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238365AbhK3F7Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 00:59:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234146AbhK3F7Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 00:59:25 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B840C061574
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 21:56:06 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id r11so82045182edd.9
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 21:56:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mU7mxV2SXHu5Qf3ZpewHyy24d1tNVug9FIKuiJMjO7I=;
        b=tmSvYuXHDXMWZRcT5pXBmVIQs6oQ+wTUD00nTuiSVzRTyax+25sAlKhB72mqR8wRdp
         DQl25OpRqkgS2eImsKdRMZeN+uyqOjLydWSffknBKfve7WiItS3TpctrDdLF32Rb4EJH
         xoSgOvvtlzr0QkHONXAwXr8FRd1wYUl2hYOzr1v3bgIEcROlZn1haO8zvuIdZUVgvpqc
         h/bZT8nIQoS6SQML/3uKnzxAYz+dCHAqsie2aH0EdmQHNzyFfoLlsIGW28g8PRmIICJg
         ZtDXQORwHWkOv5t3tz6HlGrEMbunVM7v0yY98kD8J4TsAq+TvnMv/SizOwiV60YY1Hwj
         K6HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mU7mxV2SXHu5Qf3ZpewHyy24d1tNVug9FIKuiJMjO7I=;
        b=TK94BcLc62na/J38kDgausb+2vUlrMKy/ord53JAf1q0utquLjs9DbjcQnw5FVFQg/
         2vx1coZYHfYBpkKQv0X8N623o5zBpvfBAixsO8n8ysbvI3HVtKpe450SkwMpntzGepJX
         R3D4etop5DjgxIp/NzY6VqIg8zsSE42ydUL9Y3D/sbkM2zyw+M9dBmBgJmBVeKuICTIm
         c82JX8angrVlPvXqCfPowUvgFy9LESebj+mAVQF98SbEQEEolQKkx+0osLD5tS5WaBtU
         aVJ2liBZl1OIZsYRTEsS0pb46yv87IgBd94pKNgfKhJx0H/ID1XwEsmDDLApxkAru+ed
         l7hQ==
X-Gm-Message-State: AOAM532LXugBExZATsnj+UFpcVxbphLZTM/AVQxK6vW22hN2RtGMRdGd
        OJyGHn+wBbbjXZEZI3k7+bDt/3WtOZGsy5eIXtExlA==
X-Google-Smtp-Source: ABdhPJyGUvOQUiiLgTrzP8EFun23a7r3DkaGNmq58PHu9rqmsr28Jd+mnwXeOe5ZveU7LyQvHXl+LjxsPef4cZ/EEbM=
X-Received: by 2002:a05:6402:12d3:: with SMTP id k19mr80462105edx.244.1638251764787;
 Mon, 29 Nov 2021 21:56:04 -0800 (PST)
MIME-Version: 1.0
References: <20211129181711.642046348@linuxfoundation.org>
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 30 Nov 2021 11:25:53 +0530
Message-ID: <CA+G9fYtPpcjzkfkTh_RTecLQ+d_2JM7RwODGFH2DDEoUJ5=cqw@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/121] 5.10.83-rc1 review
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

On Tue, 30 Nov 2021 at 00:01, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.83 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 01 Dec 2021 18:16:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.83-rc1.gz
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
* kernel: 5.10.83-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: cd4fd0597d3787df6c6771a7b41379d35a8f31b0
* git describe: v5.10.82-122-gcd4fd0597d37
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.82-122-gcd4fd0597d37

## No regressions (compared to v5.10.81-155-gf8f271281cd8)

## No fixes (compared to v5.10.81-155-gf8f271281cd8)

## Test result summary
total: 86505, pass: 73579, fail: 512, skip: 11613, xfail: 801

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 259 total, 259 passed, 0 failed
* arm64: 37 total, 37 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 36 total, 36 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 34 total, 34 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 54 total, 46 passed, 8 failed
* riscv: 24 total, 24 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 20 total, 20 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 37 total, 37 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-android
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
