Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49C6D3DE6E8
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 08:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234020AbhHCG5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 02:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233991AbhHCG5K (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Aug 2021 02:57:10 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78988C061764
        for <stable@vger.kernel.org>; Mon,  2 Aug 2021 23:56:59 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id p21so27676241edi.9
        for <stable@vger.kernel.org>; Mon, 02 Aug 2021 23:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4k/291QQ0Y3kbJa/+9YyY1Du192umeFdR0cwtDAsZ9k=;
        b=oW8Ld5wErK3IxE3XWkIhMnfw5spUGLTu0t+gc8mDh9sof3FcuBf36BBPw06XLyEwXT
         kp7IHtoczuGoBIzdWjwSiDaH1yIDseT6TlDt1iDarN/RmZpk326mHCRyakBGxx/Nwejf
         72QaPqkt6T+LN4hK74coN4TII31j04ZnjG2+E3dwXVwOHhvoRHByOIY8VjgMUpIDuUr2
         37uA0TlTXd8LtUT4wfTD/b3Chwye+bvHWlPUw2RyeuTPRVUzjiAl/eEOtUMOLiwhgqZc
         d2imvz7mgizXac6AmQZ4w+LIJeOPdC+zIYRhUguP2Nw+/yIid61FDebe17vveZIhfZ1z
         hfTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4k/291QQ0Y3kbJa/+9YyY1Du192umeFdR0cwtDAsZ9k=;
        b=YdhFMt5Dc6mvvoXHeoAgpVuNdOfSTz+MuuXPT6H8QEEWwL5J/gnI44k6W0Ds/oHjaj
         Bu6FqYJGXMydD0Axdeiun/VdqjbzvhBbT1HZYn6yBV9HLaZxui6kAfnbkSncvds1X+nw
         jPQ9IhnKXhe/WU/pib/DPVG/CYNcZtgDQYqdghazMgUuRukXb389rasVQxt99zfElZR+
         GT82ZDOAS1wFlcrBy7v/pUzW3SJ3tZ6WljSoG2vp/1D0E9gOdRnzy+pAm079Xnfsa8v6
         j018zTKVSYRdqVmCt2Nda3og6iideq1mXwmYnh9aulwq6n98kpo1xUSo49isMQ6UU5VV
         NqXg==
X-Gm-Message-State: AOAM530PgUHb6bbVN3H6cQ4ocv1lzeLQSelDkqnSmOqZSg4mfHJpJ5FM
        bBvWDk7QArD2mm4LxWhhooiOqOb0KvByxVA/M3kGTQ==
X-Google-Smtp-Source: ABdhPJyVeEUEVChr8RzUvCOUu5aVaoEx7i4QrWV/vqJqC+KjpCyUG9sJbWm1DTh4QaJN7o1m17By+AEF48U9Y5TYKJU=
X-Received: by 2002:aa7:c805:: with SMTP id a5mr23601080edt.23.1627973817932;
 Mon, 02 Aug 2021 23:56:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210802134344.028226640@linuxfoundation.org>
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 3 Aug 2021 12:26:46 +0530
Message-ID: <CA+G9fYtT_PLUK0EJkOkwJd+mqBVdDkVLVAUY6i4_ZM2BRHqbkw@mail.gmail.com>
Subject: Re: [PATCH 5.13 000/104] 5.13.8-rc1 review
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

On Mon, 2 Aug 2021 at 19:25, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.13.8 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 04 Aug 2021 13:43:24 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.13.8-rc1.gz
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
* kernel: 5.13.8-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.13.y
* git commit: cd55ef855022f15ca361d562635918bb2738f143
* git describe: v5.13.7-105-gcd55ef855022
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.13.y/build/v5.13=
.7-105-gcd55ef855022

## No regressions (compared to v5.13.7)

## No fixes (compared to v5.13.7)

## Test result summary
 total: 83254, pass: 68674, fail: 1508, skip: 12075, xfail: 997,

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
