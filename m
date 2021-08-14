Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B99333EC0CD
	for <lists+stable@lfdr.de>; Sat, 14 Aug 2021 07:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235990AbhHNF44 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Aug 2021 01:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232021AbhHNF4z (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Aug 2021 01:56:55 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2B63C06175F
        for <stable@vger.kernel.org>; Fri, 13 Aug 2021 22:56:26 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id dj8so10662839edb.2
        for <stable@vger.kernel.org>; Fri, 13 Aug 2021 22:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4/UCSskfWpf3qaX0d2+yLnsniMqcNJZsjT9sYCqCaWI=;
        b=e3eo8fAjgEa8/f2pKfi9Ai30MIP3vaO6648BXmvFmQc2zePQwXbGStCAeyuXpzruN3
         O7IivVfvsnCxatn3qBs+Uo2+m0aSJ6psNFv55+OUpWk6a0foa53phfr8I/CkEBz6bjv5
         R8TIakfAlwFvIeH904A2p95eF//Nq4WLlq6Qkr3wb+O/TwAExj+RvOrBOZl3CPIX66Mv
         2Goh+aahsvHnwuzMe64zso7pLDDodu6T86rnr7hJa1uC1JA5SZ20bbNNuUBYW4DX2v6+
         5E9d+Ic2jxdlwIpXXn4r6nDnd428WI7g4p8t50WLFm6JJJWILxYZqGGvmYIYAGK3Wc/D
         tRgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4/UCSskfWpf3qaX0d2+yLnsniMqcNJZsjT9sYCqCaWI=;
        b=g70E2VyWzd1TSZMBfgTHNcepMWiCGmzHUhN7NE2SjLT4INXOiVrxSSIR8Xo4G8XENK
         U4QZZY5SQtNPimX7U7ZCBR1aS/nOaLFnjN/ogRwK/UbhBbMyG0cseWyouYLtdHA8c4Qb
         1nH2IkydTdWZ/jNI9pnPL5noSMji2lOnsp3RqHXQ0ILl4baxrnUHlnoM6b4Ys8OSN8sR
         Ah9UNQD9b+OL4ChuGfgMjerxUXivw9FI72m6NnfqfYQgLfmlStVW0VNHlwgV4AUwbXYr
         zmkeVyAI5hqHIzIXKFjLtsngku2816A3xwTMUgLBdkEFGqaWhofejQ29+iezbfBD/RkO
         CG1w==
X-Gm-Message-State: AOAM531JSJH1oRR3Ryu1kTL8qDghRZcdJSvfliEKZyVcM4CYsshsk3Dt
        /iy+GTPZ+A3FofbwCN44ZWh4x20Zo7J1t+EK8TCg0Q==
X-Google-Smtp-Source: ABdhPJyN5grejFKKWqKgEnv+xq45jTdmlGV9EhbklMQ4NZv6ZQ4iaJltnqPoHmBECvQZgOT7wwlQV74H7rwEyObPESw=
X-Received: by 2002:a05:6402:220e:: with SMTP id cq14mr7442699edb.52.1628920585079;
 Fri, 13 Aug 2021 22:56:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210813150520.090373732@linuxfoundation.org>
In-Reply-To: <20210813150520.090373732@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 14 Aug 2021 11:26:13 +0530
Message-ID: <CA+G9fYvL7zNvcHNstg_80z3yEJ4e7ePaEBr-qybGxOzVb47vxA@mail.gmail.com>
Subject: Re: [PATCH 5.13 0/8] 5.13.11-rc1 review
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

On Fri, 13 Aug 2021 at 20:45, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.13.11 release.
> There are 8 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 15 Aug 2021 15:05:12 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.13.11-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.13.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.13.11-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.13.y
* git commit: af09d9fd00b76db4e959daea57373a32c2cd5bcc
* git describe: v5.13.9-184-gaf09d9fd00b7
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.13.y/build/v5.13=
.9-184-gaf09d9fd00b7

## No regressions (compared to v5.13.10-9-g22e76c328b34)

## No fixes (compared to v5.13.10-9-g22e76c328b34)

## Test result summary
total: 84808, pass: 70770, fail: 893, skip: 12352, xfail: 793

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 194 total, 194 passed, 0 failed
* arm64: 28 total, 28 passed, 0 failed
* i386: 26 total, 26 passed, 0 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 21 total, 21 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x86_64: 28 total, 28 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-android
* kselftest-arm64
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
