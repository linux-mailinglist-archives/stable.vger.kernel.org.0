Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C38647C50F
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 18:33:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234048AbhLURdQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Dec 2021 12:33:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbhLURdP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Dec 2021 12:33:15 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 537C9C061574
        for <stable@vger.kernel.org>; Tue, 21 Dec 2021 09:33:15 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id v15-20020a9d604f000000b0056cdb373b82so17550273otj.7
        for <stable@vger.kernel.org>; Tue, 21 Dec 2021 09:33:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FB0lEFaDVq/tx0v1VRyim3u8jkqkScj1zvLxjYoJHjs=;
        b=wWaB0HDDeeIlYRMrwwhexY1tTxm4cO0qABqyMwL6m04YK75ZVxGwmzIzGtR+BCdqkg
         P6lzUGfk08SN6tItPN6IOt5xNxjyMqDfnLQV52Io6GukpkmHFVvwUiy3K2jLCG0S6mFg
         +f5bKSpXElHKBC9tnIwGLsIe5tvCYkbq0IjA2H8oJKknCSbGNro9ttWJAb3yRkZUea1r
         a4F+TJ6S/VP/Bef3RDHMCkh5c61upgElk2LxTgHJeeAzJqBbx7eCayCHQMYtjUU7KiLG
         MQsqksH6V7kfPYEbtT2EjChezhU8EBtjnN4Plr+MvE0goCMEFKzIEJHRtygAGw/JQUNp
         Aj2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FB0lEFaDVq/tx0v1VRyim3u8jkqkScj1zvLxjYoJHjs=;
        b=QIhmQ79NF2/BMGJLk5n6HpKinjKzYCcSAeZOnOQiZx9TOZBCwPwJPSHFAmTyU7kXy6
         LcynlSm1Ea/oRyTXLXs1rjo31zTeFFWm0NYv3HOc74XjZjoPFfZTH9UnWTySP2fybWub
         eyJpBiIqM9fTReSHUghxdl/2/QtKwhMNsJLA3cNOS87bYhen5NQ3y9DBwaxdYN+folJ3
         iIswfumgAdLa3Su0zSPskFmY6c0bXllDGwojbbUPo4ps2esbyhfZFeMiPNMdWkd7SWhk
         puPs55s7k0ewGTB3P80xUskA38E7gZ0DJqqCoS6gx5gA1gQoQhoW6Hv6p0AEi2aWIoQj
         j72w==
X-Gm-Message-State: AOAM533waIdYskD1/TdJhdAbt1P+XKhRwSl7UjYE12xGtJydKjjsEAxN
        YRYE2UilQrqjaVtJWxcDtZdnGkjGR5suGUbcapjB4Q==
X-Google-Smtp-Source: ABdhPJwQn6SvPlImm6bz2lYPJ2jKI09Y2wwgte/soCKhn7S+7+nfQTWmq0L/Pc+RShSMxigB475dTHgPeRI3Lta0F+k=
X-Received: by 2002:a9d:2ab:: with SMTP id 40mr3109453otl.208.1640107994492;
 Tue, 21 Dec 2021 09:33:14 -0800 (PST)
MIME-Version: 1.0
References: <20211220143019.974513085@linuxfoundation.org>
In-Reply-To: <20211220143019.974513085@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 21 Dec 2021 23:03:02 +0530
Message-ID: <CA+G9fYvnM5DqJHTPJX-rKy5b0=YW7_56zM6RvwwTuXOxnZpiLw@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/31] 4.9.294-rc1 review
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

On Mon, 20 Dec 2021 at 20:08, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.294 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Dec 2021 14:30:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.294-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.9.294-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.9.y
* git commit: 4578d170efaaa2f9aa7f8b3de176c7e80a892bed
* git describe: v4.9.293-32-g4578d170efaa
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.2=
93-32-g4578d170efaa

## No Test Regressions (compared to v4.9.292-43-gfd7faef74c4d)

## No Test Fixes (compared to v4.9.292-43-gfd7faef74c4d)

## Test result summary
total: 68977, pass: 54825, fail: 460, skip: 11689, xfail: 2003

## Build Summary
* arm: 254 total, 226 passed, 28 failed
* arm64: 32 total, 32 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 31 total, 31 passed, 0 failed

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
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
