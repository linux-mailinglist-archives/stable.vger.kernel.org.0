Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3890B402359
	for <lists+stable@lfdr.de>; Tue,  7 Sep 2021 08:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbhIGGWY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Sep 2021 02:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbhIGGWX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Sep 2021 02:22:23 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B89C061575
        for <stable@vger.kernel.org>; Mon,  6 Sep 2021 23:21:17 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id s25so12427414edw.0
        for <stable@vger.kernel.org>; Mon, 06 Sep 2021 23:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kyLqso2zFvMOQ+4RWU6jmHnwEql9tRheZI3QDveqF5I=;
        b=yJULVcFN75pagbjz1NkL9/3Eytz3zDcWFTcbtnVbMAkqDd0nn8zOv3eBP5fL8O8krX
         MXlQlBBMRcQXtG88CbWfZHkIh3ZJWeRrOZxu1aqMJejdyPUFefkJ6WaJ7SU9TxeqMNKr
         S37+2+BRyyizWuamXaUuNXSScdnn7JEFkzDpatvgzGTaPgWaeiJcHXaxWdWRdb4GsMkm
         4ucjFRP4B9DDxl9yVfsmWWo8hTDNcpdflHAT8GLKDKyZcINTPoB2UeVxO4NVppQtJS9U
         MDB0nHMzYrK/hs5+krICzU1vD2T8rNRBBigtZYaXn68uUpZ8ktRIYVk6P8qWL+c8DYRX
         19/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kyLqso2zFvMOQ+4RWU6jmHnwEql9tRheZI3QDveqF5I=;
        b=Lk8wK0K4zHzTCXOJptYB5A3iuI8G4OzNoeuBJ3Hyc3sMkZtN5PSn4NdfGeVyyqMr+Z
         ipZFfu39qkF+ZQC3QGCl1sQ8+vt81u0TBNG0mVTf+S2SsuGGpwAf0PgkY+0WnJLqlKu5
         Vf1JSGHNuU+ERybUBmxweAVlNUlDG/r3eH4gzPTS3NLRRP2aQd97JZfrVUwFbYC0Qhrs
         +7ilAkpU4SWMa4Gr+3BRkmsobm8fF78aQTVFc1iLaDLhL2zL83n75sjcmX+HjYykuLdz
         tPpcgb5Oy9zqa08Nkqnxr/t3R+5WxjelaHr/jwDZG+u/hJzifeK5QnXDVTkRil/K8HYN
         P/Zw==
X-Gm-Message-State: AOAM531EXaKev7zBVwlICRumroMGPPBc8ztv1gIO1zQQ/tqR1U4ZzfDS
        mwPrSZmoNqyi78bDKmGUpFmx74NZVJIoXYiuWO8QJ4L82EM/2g==
X-Google-Smtp-Source: ABdhPJw64fQkoXwa2HfFRvaQaBZqeQJRTwvo627G8yTuR5S2pgV31f66YKf1ugFdetFuFfjQbKRV3yB1A8kObU27jbM=
X-Received: by 2002:aa7:d3c7:: with SMTP id o7mr16831573edr.288.1630995675861;
 Mon, 06 Sep 2021 23:21:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210906125448.160263393@linuxfoundation.org>
In-Reply-To: <20210906125448.160263393@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 7 Sep 2021 11:51:04 +0530
Message-ID: <CA+G9fYsCNv2p88g21qyDcTZGDZERiKj1=_QwsrVvw1m4_f1DcA@mail.gmail.com>
Subject: Re: [PATCH 5.14 00/14] 5.14.2-rc1 review
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

On Mon, 6 Sept 2021 at 18:28, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.14.2 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 08 Sep 2021 12:54:40 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.14.2-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.14.2-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.14.y
* git commit: afbaa4bb4e04f7c99e483611d4436b299129483d
* git describe: v5.14.1-15-gafbaa4bb4e04
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.14.y/build/v5.14=
.1-15-gafbaa4bb4e04

## No regressions (compared to v5.14-12-g95dc72bb9c03)

## No fixes (compared to v5.14-12-g95dc72bb9c03)

## Test result summary
total: 89039, pass: 74152, fail: 1065, skip: 13023, xfail: 799

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 289 total, 289 passed, 0 failed
* arm64: 39 total, 39 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 38 total, 38 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 51 total, 51 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 36 total, 35 passed, 1 failed
* riscv: 30 total, 30 passed, 0 failed
* s390: 27 total, 18 passed, 9 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 0 passed, 1 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 39 total, 39 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* install-android-platform-tools-r2600
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
* prep-inline
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
