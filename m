Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A897E3DEA84
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 12:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235059AbhHCKKa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 06:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235058AbhHCKK3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Aug 2021 06:10:29 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07D68C06175F
        for <stable@vger.kernel.org>; Tue,  3 Aug 2021 03:10:19 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id ec13so27761959edb.0
        for <stable@vger.kernel.org>; Tue, 03 Aug 2021 03:10:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LGkg+tEKNi+6cq7JJd/Wd28kqNOTiVmWoVZkricfcWw=;
        b=F1jU1sEiGki0ctpVPHy+pXuqLkqJkeqWSChQJKEdwh/u4o1jDamuddMmMW/UfAOpo7
         kEe2fWxs1bPUKAulnqt1CeJXlyH4qVlVHle+tWY1Zc4xvBAHa2Y1j/jX3QLJI7JfFlom
         Qa5BzIK1ESybsMJMySYplEpG4JUPbkURQYf4ZUlpH8g0eET0WNSNRJTDAUhuvPI+HHlR
         GvAVjZyQm0aJKVELk/xoBRkPFjUwK9C/hLxFr6UBmblZu2Iyo/WaHV59gyqsMGKyUrwN
         fZuUL48T1cAQLQqMifNSeKG4ffMbSUt5cAPW7ZNQUFz1qeYwXsN8IZCmfvAqWPFJo7va
         aZYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LGkg+tEKNi+6cq7JJd/Wd28kqNOTiVmWoVZkricfcWw=;
        b=Qc4wlLPnioGFvouXKAeAiWSdTpKFAezmldXgQ3gASTgrf7Jv2Teq0C8s1NgQ12Pwg4
         LQulsOcZwsfEIGwIWmDj8Gi6A8yqCC97B+17R1TkjWTFnRRVz6QKUCninDwyXQJSqObO
         lKXC/d1BcOB8/vSKIMp2AZ7QVScT760wWsiKxqKz1Voqgxsuf6odriywk8v6MRg1j4pn
         1H+H8ZixHDtgu2zQsXBzyO2qSF/HX0KIy5CJN3m1OBeq1lCVLCEq2IGhSa5ZyFQo9JA9
         Ei/GUHJJrW9FesEhU1Xv4DQSFywvpF+/bsHEFALW83/fjV8yo7hFccYMij1thvvDuRA/
         S21g==
X-Gm-Message-State: AOAM533YoUbe58vi3x2tXthMfuRttxyhdU5MTKijATQ9Y9an7aPzpBEz
        If+oEaQ3TqdWbg0ng1FqwMayosppCrPfhV8Px9XNjc8DfPv/ZgOK
X-Google-Smtp-Source: ABdhPJz+oc77cT1vGzJEr5sly502MyYWV7G7l2sd/9HCUeJ+E/mmE0fonNgXIsX6F4GWqyj4uS+8Rqga3E8JhUqkoqk=
X-Received: by 2002:aa7:c647:: with SMTP id z7mr24239038edr.52.1627985417407;
 Tue, 03 Aug 2021 03:10:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210802134334.081433902@linuxfoundation.org>
In-Reply-To: <20210802134334.081433902@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 3 Aug 2021 15:40:06 +0530
Message-ID: <CA+G9fYu+Bax17kwqWMFniMfPZO+qh2Spz9mXvdgXiEA7fsptQw@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/30] 4.19.201-rc1 review
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

On Mon, 2 Aug 2021 at 19:19, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.201 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 04 Aug 2021 13:43:24 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.201-rc1.gz
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
* kernel: 4.19.201-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.19.y
* git commit: 7d0b2cf6631fd9776096a6a1bc52a89946f15d4c
* git describe: v4.19.200-31-g7d0b2cf6631f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.200-31-g7d0b2cf6631f

## No regressions (compared to v4.19.200-15-g5b0f1f3c91d6)

## No fixes (compared to v4.19.200-15-g5b0f1f3c91d6)

## Test result summary
 total: 71236, pass: 55001, fail: 1762, skip: 12270, xfail: 2203,

## Build Summary
* arm: 97 total, 97 passed, 0 failed
* arm64: 25 total, 25 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 14 total, 14 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 39 total, 39 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 15 total, 15 passed, 0 failed

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
