Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E90C3A147E
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 14:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233186AbhFIMek (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 08:34:40 -0400
Received: from mail-ej1-f47.google.com ([209.85.218.47]:40677 "EHLO
        mail-ej1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233109AbhFIMej (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Jun 2021 08:34:39 -0400
Received: by mail-ej1-f47.google.com with SMTP id my49so21535093ejc.7
        for <stable@vger.kernel.org>; Wed, 09 Jun 2021 05:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6XTRjG8DA6//Vza5ToMO0nrVrP4kOHe2lAk8iv5fYAA=;
        b=kxlcOz7ILufwDk7GIkyi4qcUD54tPcjtc+LCeRzh2CaaivCUjmV6+2elFYqnVR0l7q
         VyMu6fcTqWoG/r88p8ntaRU4RpB0cIEyULsRHWVU1mYv0KELTs4DKANa5DEVkXMC9kke
         8O3Vbqc4Qf5cLhkR3kpSMnN5/Uwk3m/UXcPKB2xuAQLPEMy8MozDDvjEaHcdNBZSniKr
         EWl7WAhbuKJmgqUBiwmwRWjiOyu7Sw26p4fLKY9YR43Cm8fczxLY4Rio5htscQUccrVI
         eX1WCxQZYA12CuOARtgpZOs2Tul6btRW/1NwDWCLEnbEzDx0HvD+Xa9524rtY8bkQ7Rn
         FfDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6XTRjG8DA6//Vza5ToMO0nrVrP4kOHe2lAk8iv5fYAA=;
        b=uXqryAR4xDHiLJj0wHPuQLSp7vo5NA7X3kszB/N1i5p9j9G8eWcvVLmYAW7aNTMRZX
         S+ijLKxv2boG9fqaP3/bzW0JxeuXriDupHjHDFLtYdyrIAWDJRFfj7czW5Ed3AeDTDif
         nJtX2DO2htV5YZ28cTKkco7rjFCjqbv8+Z4ENbdINRhzlN/Z9sKyeJGCjylVhOP4UFzz
         Iz5VFkZ6/1mjJWIspdUtFOOfPWxrPe72tzFcSuKQcCHfct6dD7Rsitp3XPRuC1EwPnUF
         VOP/3Tq6Kprqbl1IZAT8GpF39WqAw80pcz6BWDZO/nkUBgLrukzHD7RHQITWwaNWuk3u
         0Rjg==
X-Gm-Message-State: AOAM532fiUI9VDOQB9HmI903Z/vc3M6K44GRxJ+NPXS/bCrih7xZQ1kJ
        xH+lJ+JvAmWoVFS/Vuv6AfEMfeOb09hL05Vq7aWpHQ==
X-Google-Smtp-Source: ABdhPJzJbYf9A+vwKTyYAuw/aRGHwnTx5yKWeK96Vnztmii5iLbspIkOsm5bCuvHyiIisDIbWwt2iyBp3CYxBkRim0k=
X-Received: by 2002:a17:906:25db:: with SMTP id n27mr27776459ejb.170.1623241892052;
 Wed, 09 Jun 2021 05:31:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210609062858.532803536@linuxfoundation.org>
In-Reply-To: <20210609062858.532803536@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 9 Jun 2021 18:01:20 +0530
Message-ID: <CA+G9fYtxxYWyvCiv=uXv1VSaX=6VSSPzhd7tdmq_Jgzg2khwvQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/57] 4.19.194-rc2 review
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

On Wed, 9 Jun 2021 at 13:24, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.194 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 11 Jun 2021 06:28:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.194-rc2.gz
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
* kernel: 4.19.194-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.19.y
* git commit: 3a6c65ec05c006c635fbfbbbbb941bb397dd4086
* git describe: v4.19.193-58-g3a6c65ec05c0
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.193-58-g3a6c65ec05c0

## No regressions (compared to v4.19.193-60-ge0814e7f9827)

## No fixes (compared to v4.19.193-60-ge0814e7f9827)

## Test result summary
 total: 71558, pass: 55780, fail: 2296, skip: 12168, xfail: 1314,

## Build Summary
* arm: 97 total, 97 passed, 0 failed
* arm64: 25 total, 25 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 14 total, 14 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 39 total, 38 passed, 1 failed
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
* kselftest-m[
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
* kselftest-vsyscall-mode-[
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
* timesync-off
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
