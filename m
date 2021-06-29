Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF5CE3B7064
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 12:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232717AbhF2KKu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 06:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232420AbhF2KKt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Jun 2021 06:10:49 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48CE9C061574
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 03:08:22 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id l24so2388524edr.11
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 03:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FaIByOHQ52+r83TxLiYLLnRJs52hLl+dcK/lBJRgiDE=;
        b=z01Lse4ZcXHwNayHq/Wfv48YJPVYu4jXMsvDfcwTyaPBUFNolKWWBP9h7HYsH/pWlD
         ANNYFkoQAizE3xm1FtFrw4fEYGB0CfTg63xuROrZkp+vbrtPWdzDQDmipYvEE/BiRuex
         +a6byXnS4wAj7WQlq8nb9+00I4su8jsbitQdr/mj7R3jrzvaj1jL55GpYwG8vRCVE125
         yHC9T4JF7Hwyqt3/hkCbnfzRnl1HkZd9jIfmH8vOcB8LWGuZ3eQqpyzN9qh0uCyOQD3b
         2jZ06eGaSBPNkU1ln+e5DEyWqrqSFVQ8VjJdEhkyxvBzqVywewBIWQIc9jSdKpsDJQsZ
         S2aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FaIByOHQ52+r83TxLiYLLnRJs52hLl+dcK/lBJRgiDE=;
        b=jguXndnnWsH/FIaWCbroyVmK8V/I87z7G5DQ2PgDq8FpXeeYYMNgGHOnn8/rvM7Y21
         NBlW7GMMPIAWaExjq2FjUAaxvpEdk12/qNlbHnCv9j0LFCUW8CncMlPcetRQ2kAiFeqX
         qLuS28qNq6VvVwkAmkIW9z5ejR78bO1I3IETL2SOPb2erpKmCT7UdfASzdBj5Ze0wtjD
         3VmJ7235aH1EmyS3WD5BMT92Ty/ISEEB58frKrb/WqR6WKZNH2/KNyyZ/DXJKaMq3xO6
         5TIepjf/Ipp/YtKAVXjVbnuweUCXbkZIv5bxIlE/tKSkotRNdViqoYlvSRhvHNubYl4E
         Nxfg==
X-Gm-Message-State: AOAM532Z59vnPn3owEiWeYMr7UVzlimLTETvvq/MF3ctYMT+EKvm6MUN
        5KxaOsGSVwcOnYT5O0dAXJnZUa8KFE8FpDqMa/D1Kw==
X-Google-Smtp-Source: ABdhPJygqi3Cj+nj3NxKv5tVBA7U6oLmY9ewNuj3zQLMPRF4p72XUpxArD13Z7XEGUUL6IsXnW+O8Vp5sorfQuFSrnM=
X-Received: by 2002:a05:6402:152:: with SMTP id s18mr38692362edu.221.1624961300775;
 Tue, 29 Jun 2021 03:08:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210628143305.32978-1-sashal@kernel.org>
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 29 Jun 2021 15:38:09 +0530
Message-ID: <CA+G9fYs7US2Ho4+4t9QVXRZdz9NH8siycjDGftaaqBa1hpH4jw@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/109] 4.19.196-rc1 review
To:     Sasha Levin <sashal@kernel.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 28 Jun 2021 at 20:05, Sasha Levin <sashal@kernel.org> wrote:
>
>
> This is the start of the stable review cycle for the 4.19.196 release.
> There are 109 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed 30 Jun 2021 02:32:48 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git/patch/?id=3Dlinux-4.19.y&id2=3Dv4.19.195
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> Thanks,
> Sasha

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.19.196-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.19.y
* git commit: 7064c50476914a248e42de8f0d3fa614be5f1b8f
* git describe: v4.19.195-109-g7064c5047691
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.195-109-g7064c5047691

## No regressions (compared to v4.19.195-89-gf34b5acd3d54)

## No fixes (compared to v4.19.195-89-gf34b5acd3d54)


## Test result summary
 total: 71432, pass: 55166, fail: 2504, skip: 12400, xfail: 1362,

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
