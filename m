Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D32AF3C3413
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 12:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbhGJKO4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 06:14:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232493AbhGJKOz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Jul 2021 06:14:55 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F771C0613DD
        for <stable@vger.kernel.org>; Sat, 10 Jul 2021 03:12:09 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id w14so6279577edc.8
        for <stable@vger.kernel.org>; Sat, 10 Jul 2021 03:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8rR9t9XAfSBaAp3V37r8WlT62z8MkJBBnmR/4iU54rc=;
        b=TO3OuT8n9I4z8mS+AdCsNN5397QikENWfkbsOtYdRrNDVeX9R6sBOVFiJ29jvOQBoe
         RuYVxa1KPxz8nyy8sO0abIvJLjM6Ew9mh7Cwibol7Bm6GSaUDtKOa+e4KXRCWzvqna0D
         cEN+thgJzsGkl+Q9C9r2G5iB8za8apZY2cuvQSsjqB2bVDd/N4WlbsSsti8VNrLfulis
         5gr6VfS0AdX6mPi3iZR1g+BEZbirvR8qnrUkn+pzI9tQwm6Evv/zHwzyesqG/mSE9HGe
         v6fYV7f1wv6tWqR2My8piqqlfr6we8HZhJKztXZc26j+J4eYb8JNhTDgm1xzbkodY+T4
         fpgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8rR9t9XAfSBaAp3V37r8WlT62z8MkJBBnmR/4iU54rc=;
        b=fhjXrLtwVOIunIett9dWJGwFRiYmdLiWfQxE3X7CXfGInQJ+mZDsWwUf2/K9dQ0n4w
         ex4+MUeH1x+GC2ICNpF8vvCorBiMXuN+U5pLjKkcZMeURfoBKJnSmk4hjYnRLLjEyVLw
         acI5PYTCZhcajP+VaDP6TSrgnGB6lLo4l0qDU2fsUygjCNzs7OiOkOTlX5/sDLuKailD
         adQKZ2oqTCFkZadDoOfgL6hiVSPKxgvOE82KHirstbNk2FR2L3rgH9QhwQOHnmkGK+eJ
         Ag/pp7A+nVRfshb6IoFGS6TDuAheGaEISHsYRT8G6cBBjP4Hx5QJz6ZdnyJHz9qgaoMV
         xe/Q==
X-Gm-Message-State: AOAM532lEUn3j1bK60aXSGRpw6uOD88F7C/jg02s7UVtkLtM2aSgdT+F
        Apmd+AQw22FUaCC0HngrlDMNrn+Sd/D+hVir5N7/dg==
X-Google-Smtp-Source: ABdhPJzKpzH/wxNZO6oUuab08oTwEnNzLV+EBAKrvjRR/aEdTRCI1b70zQ07kLZZDpqVUk10yqaOWaTZnMidLJDvqao=
X-Received: by 2002:a05:6402:152:: with SMTP id s18mr52424148edu.221.1625911926142;
 Sat, 10 Jul 2021 03:12:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210709131549.679160341@linuxfoundation.org>
In-Reply-To: <20210709131549.679160341@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 10 Jul 2021 15:41:55 +0530
Message-ID: <CA+G9fYuwh=CLT00JRh2P4vV157-ddsKs6Zg+De5A_+iepcozdQ@mail.gmail.com>
Subject: Re: [PATCH 5.12 00/11] 5.12.16-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 9 Jul 2021 at 18:52, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.12.16 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 11 Jul 2021 13:14:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.12.16-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.12.16-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.12.y
* git commit: 45d72f8b4c4fd32aed859795c0ee6cb28d51af4f
* git describe: v5.12.15-12-g45d72f8b4c4f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.12.y/build/v5.12=
.15-12-g45d72f8b4c4f

## No regressions (compared to v5.12.15)

## No fixes (compared to v5.12.15)


## Test result summary
 total: 81182, pass: 66807, fail: 1819, skip: 11391, xfail: 1165,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 193 total, 193 passed, 0 failed
* arm64: 27 total, 27 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 26 total, 26 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 21 total, 21 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 0 passed, 1 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 27 total, 27 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest-
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
* kselftest-vsyscall-mode-native-
* kselftest-vsyscall-mode-none-
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
