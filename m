Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC8647BF03
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 12:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbhLULeN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Dec 2021 06:34:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237182AbhLULeN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Dec 2021 06:34:13 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E48C061574
        for <stable@vger.kernel.org>; Tue, 21 Dec 2021 03:34:12 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id 131so37790406ybc.7
        for <stable@vger.kernel.org>; Tue, 21 Dec 2021 03:34:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Z9+V1aGya/Hb+Ui2nvpmg7RECtXiIeunXU1isHEoQ8I=;
        b=P7iHs7VoVN4MJoE59E1P1IPqLlbnoRpd/0/LTNRvi+7mdOj/gip8JIDzpNQvGOjR8i
         fqz4Ll0FQPW6G6RASEo/9jKidxD8FIuX79rHUwdRhIp6D97zwTtG4qZAXHBkzU5d9USt
         iAyL+Q0BO47cVW5QTu2Ro5ExYxPDBP2EwDADmbBZz4WkyTkvd8TwUD6i0gTxOZ5oIujN
         ReWuPjR0E4Hibb3ntxhC+GjsHjfoJzIGgEchR1QLeUM+wgi2d01Rhsdsp5E0pbikXllr
         CO+JVtsXDkFeYI568l0KBLn3cT3LH79/JA+rNBAHbYpg2OKsMl2anZ1S3lA899rcixzr
         iCoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Z9+V1aGya/Hb+Ui2nvpmg7RECtXiIeunXU1isHEoQ8I=;
        b=mt35qNjU3qrDhiVlusv65zUiaYnLTU7cGt+y1wHjT9CeUFHGoA0UcI0IQtg3H2J0Bk
         OaGt7llMErowHtMBnd5E8U4MPiDTST421VPui5pFdR/u6m+rZ9KU9Yc2E+8kOdiOQDfm
         SAD/LLTWRTLBUjThDmmnjLviZftxyDScBwoUqX7KMHlWcEDSQ6SV8yyqowFYalvsoIFF
         5VnhoTmcV4fVHKCtDvkPWh33Gc9NTNMuAAJMxw0yyMC13kRKa8exT8velX2u/oZU7RmO
         37Ve+XEAda04FmQMOz+vPhtECP553hlE80Jv/6KD0EylMimiq+QwBTAncVN0E7cGFP6P
         UttQ==
X-Gm-Message-State: AOAM532z0LZVGgvCwAL4Syr/9u77+6WqnCXeTQvzrmRHOGaKYHqg1pjS
        me2vd2hRTju+CLJQLeIQ8w8TT6H0IxqDueBmwXZZCg==
X-Google-Smtp-Source: ABdhPJxzriEGE3qTmY8bhfS+uPzicxwSv+W0Keuw0kfQQ5beuYsAqJOyzjmC52LhnSihvltPAAt49a2fw87z0oXoIXs=
X-Received: by 2002:a5b:18c:: with SMTP id r12mr3875829ybl.553.1640086451895;
 Tue, 21 Dec 2021 03:34:11 -0800 (PST)
MIME-Version: 1.0
References: <20211220143029.352940568@linuxfoundation.org>
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 21 Dec 2021 17:04:00 +0530
Message-ID: <CA+G9fYuWtS83ZO8neLVby97Ux9_W1aAbhtvuAVfzPR2izmEQ+Q@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/99] 5.10.88-rc1 review
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

On Mon, 20 Dec 2021 at 20:17, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.88 release.
> There are 99 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Dec 2021 14:30:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.88-rc1.gz
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
* kernel: 5.10.88-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 22ecdc9ddc3f790d7897c1c8bc1813fba064ec9c
* git describe: v5.10.87-100-g22ecdc9ddc3f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.87-100-g22ecdc9ddc3f

## No Test Regressions (compared to v5.10.84-128-g24961377099e)

## No Test Fixes (compared to v5.10.84-128-g24961377099e)

## Test result summary
total: 92504, pass: 79026, fail: 519, skip: 12006, xfail: 953

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 259 total, 255 passed, 4 failed
* arm64: 37 total, 37 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 36 total, 36 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 34 total, 30 passed, 4 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 52 total, 46 passed, 6 failed
* riscv: 24 total, 16 passed, 8 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
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
