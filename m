Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C48348EF53
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 18:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235280AbiANRoD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 12:44:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbiANRoD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 12:44:03 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE3F5C061574
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 09:44:02 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id p187so25974240ybc.0
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 09:44:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CIdcniFkESogcfuxZJbci8rmJq/a9Xy6sonYcBI09eE=;
        b=ifuBgYtHYC48R3emVaGeDrBm5fhweaRTU0tYjC3FJ2xbDfSDHGaskiSF3iAoqxhrC5
         5OJBIEYfiWQuFnbvM54zNu44AogDfw2OB4WNVjLjlwV1jtKawFs4SNUxZHeK3YG5jqoj
         oXRcGkmvxjdAbxiGB3nHJEFAjcBPUwhpdkjr/DdiDsDAGV6BYs5KgYS6Bs6e1Y+2f9JJ
         gmtarTiCR1cf2Qb1ZwHrslW4GGxTcJkZtRCYXq9jLNVrrvIvtfTPmO7bc6cVChkSpzXO
         8RarHdw/pzp5lXL4fpXuAX5vZogUGUvdyDjJQN+XJl19Pjg5CEbni1Fsrf/QDEgX4RIB
         F+6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CIdcniFkESogcfuxZJbci8rmJq/a9Xy6sonYcBI09eE=;
        b=j7A1atSYtat9RCyinByWF552eAMNuSDgU1UWAZaHP2Y+1YudOPGcg8YWcIouuUFyO5
         VJjNpnMcOtg+yNcS6BO8/4noj+9nMqA82VY2AQUh2GC+YFsIt56m74SqYtYq9uldnUXN
         XIHba50XqIe0vIjz0OsJ15l/cdoqnyKr6qk8IuEGEShOFan0n53RDltcd1DXF7E+7KLN
         6OdvqxyUsrAzp40sOWuQqRxK3mVOpEP8E87YI/xvrRcxa6PQnIJMkzqJdAorJcZ3aIb6
         daOCptHMuxNufs5Gtbrx9iBZVb9LGU1Uzbr4yVHyLPEOFlBh6FMVbyZ/++DZ3pUvcdXO
         tkUQ==
X-Gm-Message-State: AOAM533+UUADm2BulXCDJxvPrLJ2AKs+LMIY2kF9URPCiqPmNr7Yhkxp
        eVtYBIR3NhKYvIK8yj/8Bn+7CWRriEOsEhjC9/yk+82g9wW9lw==
X-Google-Smtp-Source: ABdhPJw/+LccB/c4YVq88CNM1frHU08znyUuRluNpzIpNkJlriVRcXRHpZJSuYbKQsS0u020JG7fSZRq8b2rm4eHiR8=
X-Received: by 2002:a25:8e89:: with SMTP id q9mr15670271ybl.520.1642182241669;
 Fri, 14 Jan 2022 09:44:01 -0800 (PST)
MIME-Version: 1.0
References: <20220114081545.158363487@linuxfoundation.org>
In-Reply-To: <20220114081545.158363487@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 14 Jan 2022 23:13:50 +0530
Message-ID: <CA+G9fYsxnbb00O61CxtFzWG-J6GTMftXgBFmC2=yxvLaJXMXyQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/41] 5.15.15-rc1 review
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

On Fri, 14 Jan 2022 at 13:50, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.15 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 16 Jan 2022 08:15:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.15-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.15-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: f9dc3f25c12ab4f1f1e691dcb48202fbf8d6226d
* git describe: v5.15.14-42-gf9dc3f25c12a
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.14-42-gf9dc3f25c12a

## Test Regressions (compared to v5.15.14-39-gc9df4d832e20)
No test regressions found.

## Metric Regressions (compared to v5.15.14-39-gc9df4d832e20)
No metric regressions found.

## Test Fixes (compared to v5.15.14-39-gc9df4d832e20)
No test fixes found.

## Metric Fixes (compared to v5.15.14-39-gc9df4d832e20)
No metric fixes found.

## Test result summary
total: 90478, pass: 77086, fail: 780, skip: 11832, xfail: 780

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 259 total, 255 passed, 4 failed
* arm64: 37 total, 37 passed, 0 failed
* i386: 35 total, 35 passed, 0 failed
* mips: 34 total, 30 passed, 4 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 52 total, 48 passed, 4 failed
* riscv: 24 total, 20 passed, 4 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 37 total, 37 passed, 0 failed

## Test suites summary
* fwts
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
* kunit
* kvm-unit-tests
* libgpiod
* libhugetlbfs
* linux-log-parser
* lt[
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
