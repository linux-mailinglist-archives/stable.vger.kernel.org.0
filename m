Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8CEF48EF64
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 18:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243938AbiANRxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 12:53:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiANRxf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 12:53:35 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D52CC06161C
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 09:53:35 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id g81so25852026ybg.10
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 09:53:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iPiLzn8DvcR9mQ6SMaZnf4sCbYQHKuql8njzAXaalFU=;
        b=o/bOr+ZplfKp3Nw+3iAzhjo4u4vX62vI3uvbwlDd00IXK+HAdO2mE41x8KQ5atuU3h
         936vxM0U3QJSOBJNWGiREjDzEEg0VuYnpUejRmd8k3TUdXLyZjQGB6Zw7lT1306kb3qA
         hfO6fp8Defr3qZuVxJLIPSBzpjV20FAxPCbgTYxvtbl5xp/Oj16bQy65+YDhLB51+LkN
         s9/4K30gPXIhWh2igi0rPl7wk1seL+VrBMEC+vTjIRUNaJofrzmi87zUDsts3aqTKj4j
         vRXa49ymDP53Z8k2fEyMFtdfzrcxIah4JdX+/KisXCH1HjccQYja9IgUPFvdGyqt4mh7
         4gfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iPiLzn8DvcR9mQ6SMaZnf4sCbYQHKuql8njzAXaalFU=;
        b=CTCK7fCJz/srcgMIJ6MuFg0ljUPYPsYP4heBnaDQSvn7OHNR5GxYXH/6E+tt6TY2n6
         3zSXidEG1bx6Bgi8aOt6nKwxV8fvqF1XsPxisZ2obnK99jnv+XCFYMm+WVLmNn0cusxs
         cIpCoqf67opTRah8BAi4KzLGwbkJFr+j4vLzAX6HCgFNKp7CmPwxqGb62d2J3CJ2+cnL
         mlwEMMvnAZcsoRurzh7htJF2JnvPVHbUnXWfR7UXUHCfMd+iJN2RM/piR/2DsRMJyrpD
         AiyrM1jzFq7tZK3O+cnS+MEcoT45NY3LNYCXkPHi5Yt5+xeeN1UoY7WuVMd7RHprtc7e
         Ehhg==
X-Gm-Message-State: AOAM533IzVcc2+QNHwnK+KlNIn1+ltfMR/8a3KgwUmabu4lfzHgdHRiQ
        FLbMBvGsGaM63WJXHggLdBYBON21JTTtxvd1mXRktg==
X-Google-Smtp-Source: ABdhPJz0OZK3FHU82OSDrd5jS4IvbdEZeDUQVGueOTpxnUUSbF3rnMys4n4SJMpYO16fOh39plpZAQ9pg8BSBaD7Adk=
X-Received: by 2002:a25:dcc6:: with SMTP id y189mr4485265ybe.684.1642182814288;
 Fri, 14 Jan 2022 09:53:34 -0800 (PST)
MIME-Version: 1.0
References: <20220114081544.849748488@linuxfoundation.org>
In-Reply-To: <20220114081544.849748488@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 14 Jan 2022 23:23:23 +0530
Message-ID: <CA+G9fYuoW0_pc9Qd9BTq8hxPC1idc=HKviWhDX-LgYXqgVOB4Q@mail.gmail.com>
Subject: Re: [PATCH 5.16 00/37] 5.16.1-rc1 review
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

On Fri, 14 Jan 2022 at 13:52, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.16.1 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 16 Jan 2022 08:15:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.16.1-rc1.gz
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
* kernel: 5.16.1-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.16.y
* git commit: c8e806b92342da77315e4d60ad7dc4b9c41824a4
* git describe: v5.16-38-gc8e806b92342
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.16.y/build/v5.16=
-38-gc8e806b92342

## Test Regressions (compared to v5.16)
No test regressions found.

## Metric Regressions (compared to v5.16)
No metric regressions found.

## Test Fixes (compared to v5.16)
No test fixes found.

## Metric Fixes (compared to v5.16)
No metric fixes found.

## Test result summary
total: 98263, pass: 83437, fail: 2222, skip: 12604, xfail: 0

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
