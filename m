Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4928B49F796
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 11:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347891AbiA1KuT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 05:50:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347887AbiA1KuT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jan 2022 05:50:19 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F72DC061714
        for <stable@vger.kernel.org>; Fri, 28 Jan 2022 02:50:19 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id c10so17278760ybb.2
        for <stable@vger.kernel.org>; Fri, 28 Jan 2022 02:50:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5iJtkySLwcRuCrzTpAZSo4CH854DoIOnF0gPzT9nBX8=;
        b=esn3wUffdtBqAHBDV02Denz+oWNKWX/DsUxJ4Kh17rJDp3E/eu7fUmArUMhiQyrqPC
         CwqPecun1afUKQRInA7c+kBWmq7kupcKSo3n5E9KDP15YypDvlSl6hKTJDIje9bzcO2t
         6W0XvPInQOXX4dsQ9Nyj8YpVvtcB7rP+F9YUvscfwoaYzk9I8bpzOWQiBt69bbjwDO08
         n9BV7lSwa9vY8uGIqzxAZv9Ls7iRZLqRqX9suUaQlajgBdPOUQ6Ua/yFejKozEyP8Ju1
         e+jnZfJ3jrbABn3sNKNr6A9rdU9IdHcqOVSgAL/TH0CieUvTQ4GrpEh++ebXqRYz5YD5
         arnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5iJtkySLwcRuCrzTpAZSo4CH854DoIOnF0gPzT9nBX8=;
        b=b+dlRVBkA22ni6ZMtdMhYpVQtXjMAit5PgQFVW3w7C+LyZi8hRYuyJEJSzpBq8siPD
         sM0Pvs6Z51wnLVbJBaEEj2Z717AueXTI7Qs7cBkR9MDaLGWl/ZUG3L35O0/fvwCyaz05
         YeEC5SAp41AeAR8oVwpw7GhbUpqbFmiG4YNt6BJsEZUogMqdsCUK8G5sDV41D2B07hQC
         WBMHb0k42IfRsq/1rC1RVCtb4ZkbX1KCLaSa4SjyHepeCmZ0JlnhZ8MWpaSrsR63TOcu
         q9H4g5Bc6tZafaX7GKnJP0Aqk1RVaP7uXQ3jnPPli8+BBz4u5SAM7hPLDyM5yYGkcqN7
         FBUw==
X-Gm-Message-State: AOAM531CgRfClkELutlhFQRQxbxn1Qy+J0FdAf7GXArasyNd0b7JuI3h
        9ktgiS+26M0h+pPmt0iifwKx2ZL9CmBqEd0UvuwE0w==
X-Google-Smtp-Source: ABdhPJzyM3R/VVoF356f+5MdPq2h2ezfWj01LgKiDxNE2Fs7xGWNBE+5bqokJeKgvhIPOy5AzGnqH86AD+5Cw36cmV0=
X-Received: by 2002:a25:49c5:: with SMTP id w188mr11234776yba.200.1643367018417;
 Fri, 28 Jan 2022 02:50:18 -0800 (PST)
MIME-Version: 1.0
References: <20220127180258.892788582@linuxfoundation.org>
In-Reply-To: <20220127180258.892788582@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 28 Jan 2022 16:20:07 +0530
Message-ID: <CA+G9fYtSG7WMwmERY=-jVqTg1P=Hm19EFkANi9CA+8CZW1t-xw@mail.gmail.com>
Subject: Re: [PATCH 5.16 0/9] 5.16.4-rc1 review
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

On Thu, 27 Jan 2022 at 23:41, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.16.4 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 29 Jan 2022 18:02:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.16.4-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.16.4-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.16.y
* git commit: b894c0fc760c5712fe86926a234e7ccbe4dfead8
* git describe: v5.16.3-10-gb894c0fc760c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.16.y/build/v5.16=
.3-10-gb894c0fc760c

## Test Regressions (compared to v5.16.2-1034-g39cb7e05eaf4)
No test regressions found.

## Metric Regressions (compared to v5.16.2-1034-g39cb7e05eaf4)
No metric regressions found.

## Test Fixes (compared to v5.16.2-1034-g39cb7e05eaf4)
No test fixes found.

## Metric Fixes (compared to v5.16.2-1034-g39cb7e05eaf4)
No metric fixes found.

## Test result summary
total: 107251, pass: 90933, fail: 1502, skip: 13763, xfail: 1053

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 263 total, 261 passed, 2 failed
* arm64: 42 total, 42 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 40 total, 37 passed, 3 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 35 passed, 2 failed
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
* prep-inline
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
