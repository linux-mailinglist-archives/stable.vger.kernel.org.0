Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1368B374FDB
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 09:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232271AbhEFHPm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 May 2021 03:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231254AbhEFHPm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 May 2021 03:15:42 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5583C06174A
        for <stable@vger.kernel.org>; Thu,  6 May 2021 00:14:44 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id y26so4948723eds.4
        for <stable@vger.kernel.org>; Thu, 06 May 2021 00:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2ylmmxs+TaB3xrkE/2Zlsxz/yNTcrgLEBXV0nI/0Rr4=;
        b=VxUxHYmXfisn0UtQuKY9Y0B7RTXRoJ/Fnv9zcEnTk4XUk4JsoMfLEbfil+q0xLNy+U
         8Y6c9dvBUh54whtKA8/XBEmQbvlafFxV4/1sV9cFEUH30/HJ8dm/R/6U45I8l3bnsDed
         gjQDSRtqhLOztytJLJ0KI/pzkb5/VRduGBvirwuMiRnmf6HxkUQUeUtsIknGwJZWmVg+
         rmYMdQFYgILJq2bmBjJ3KGb99PsVGP93gHA8nUX0opQoxGkvWAFpzFX84OOE00KN6uOM
         vcpZ2lMLwI/BtXMARC6NQNsgUzAUoqUuWzMSyNGVuTTGIDiLHArUEuhfZx7HSJObdhQI
         jDPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2ylmmxs+TaB3xrkE/2Zlsxz/yNTcrgLEBXV0nI/0Rr4=;
        b=fl8gLpFvaOgPuIx7Uq22UA5s8TYC1Xeb5hVjI00Oll+46PZjJphKciblO34j4ijNkR
         Ow0peIlU3vKreL0hfZCWVVoQsypTZ/fQ4bwgZqKO5wS1BnPAjLaqraAV/4c0pXvEZoMc
         tSp10JGgtuIJqpiEAhvbMYgv38y9XaCedx/z9Q2pi2Z6MSjRZ7mStRPQ9JugrSlpPXa+
         N6p+lnhj65bUAiw8X+cguvbmzRFbM41guSUON3VBqQPbT2fV7URTvyI555tXgDkrkKmK
         Q6mSON3egcFW6l8xNIBv1DrL+50uRfuHYHZwAIuOL5IIK41Ov4z5DF0s6NJ14TmqpF73
         QRvA==
X-Gm-Message-State: AOAM533ih+tpVxXAp+CQWhovD/zwoGgV0ZRSOWVGj3ojQAuh9UDl4gaK
        5UEzBnu3/zD298GjZqD6HHFcTti4ShSgRH/wdwYP7g==
X-Google-Smtp-Source: ABdhPJx0kcdPAe+JYobud457UWeAKWmB1LuF2zhEwEL+62ASH5Z2h4D514Rhv+bsFntjrexXSj8ON+pBmB1j7mSPZtE=
X-Received: by 2002:aa7:c78a:: with SMTP id n10mr3322356eds.239.1620285283235;
 Thu, 06 May 2021 00:14:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210505112326.672439569@linuxfoundation.org>
In-Reply-To: <20210505112326.672439569@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 6 May 2021 12:44:31 +0530
Message-ID: <CA+G9fYv_HVktCp-pB4HKM4KG-Suu=ZmR_qOTdF5KYHih9Oxt3Q@mail.gmail.com>
Subject: Re: [PATCH 5.11 00/31] 5.11.19-rc1 review
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

On Wed, 5 May 2021 at 17:39, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.11.19 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 07 May 2021 11:23:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.11.19-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.11.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.11.19-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.11.y
* git commit: cffd2a415e649b47f93b2f10fd7b7fa2441c3585
* git describe: v5.11.18-32-gcffd2a415e64
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.11.y/build/v5.11=
.18-32-gcffd2a415e64

## No regressions (compared to v5.11.18-9-g7c5623736e0c)

## No fixes (compared to v5.11.18-9-g7c5623736e0c)

## Test result summary
 total: 84037, pass: 69465, fail: 2557, skip: 11736, xfail: 279,

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
