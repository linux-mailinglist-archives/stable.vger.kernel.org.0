Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27C7E3CB711
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 13:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232088AbhGPMCQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 08:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbhGPMCQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Jul 2021 08:02:16 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 774E6C061760
        for <stable@vger.kernel.org>; Fri, 16 Jul 2021 04:59:21 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id bu12so14854080ejb.0
        for <stable@vger.kernel.org>; Fri, 16 Jul 2021 04:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Ej8SIWz0OcpHLm8FmiDOFRnXSxDgeO5zMJ7XUup1PTA=;
        b=dfqGx9usURFRxmqVqxyLBm/eTT11z1zmysBYuvI2fPcO3oJNytOjlmT3q9kd0SgbLg
         rkPthDhjDmDIe8lwRt4UH8dEspSHH1h5ImneawABkNCFTka3dQuzg80yEY0mi2nzDnz8
         dyBIEmnBQPKeRBkXdIkpEL00GfxDTFBDY/K+hauar833HEcXWnLJBJ+p6xugfYnaQL52
         Rf4qX/tH2K6hk4lfuaseMS6Mpqbc6UCP6smUu9zDJerdFKhMRj/mbT5gKlinHaUGy92M
         IU6wPVC7WQoOp0N/mNeaRp0S/VY0p2DEl9OrkijP+aTfvbehqYwTDet6nCxEonmTHu+L
         1q+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Ej8SIWz0OcpHLm8FmiDOFRnXSxDgeO5zMJ7XUup1PTA=;
        b=ZmZ9Kgk+tj5i8JX11SqLP61+AAa6dyO2hoAWwt+BQUvN+F/THRvaC8yMPhYIRNMtuq
         pnmdHNI+rUrvA7g0dmUi1Fc0LcknDNlazLZ8JyOdjh2NBUzmpKvQs84SCVlpuRJOsqJ3
         lMQm820XG9+cXatScZkx7IraX1hEnXmjFYy/dMlB2oPTzicev4bBLu1r+pLjyaOKrO/U
         Y4Z+KryhNZwZFfo3GMjDAGi0bilzin0lPd4p31SMCovJ8Q4GTk61PjuKwaWFLVhT+YEs
         8k1qQi69+bZB67RBHyQQ+2EUuC2TNzZeZBvTcNEL89zc3qjmP6nftkp9J+kn2kYFPAMs
         XyOA==
X-Gm-Message-State: AOAM532dMPAaAN5LCVddq559Vd8QSChmj92dXnUgib9c53GoB0Kq5zXX
        QrHgc+FRRc9ZseLegQDmxhJ1Z8O1pkNYisy5QSFN42NTS6UKEjIy
X-Google-Smtp-Source: ABdhPJwe5+sGzXE2oIhdfGmYLeuGYRlUa22gDBfVDoLPQfgK3srGhZeHfY5T56Jk405Rm4iZGds6saOLiY2+B3N4HkQ=
X-Received: by 2002:a17:906:cec1:: with SMTP id si1mr11414424ejb.18.1626436759846;
 Fri, 16 Jul 2021 04:59:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210715182558.381078833@linuxfoundation.org>
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 16 Jul 2021 17:29:08 +0530
Message-ID: <CA+G9fYtW156WOWbUH37XaPWMmv7wthZcoUG7JSrob1TU5LYSqw@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/215] 5.10.51-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 16 Jul 2021 at 00:17, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.51 release.
> There are 215 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 17 Jul 2021 18:21:07 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.51-rc1.gz
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
* kernel: 5.10.51-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: 36558b9a3bb700ca62ec3ac2f06e6fbec57a35d2
* git describe: v5.10.50-216-g36558b9a3bb7
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.50-216-g36558b9a3bb7

## No regressions (compared to v5.10.49-594-g3e2628c73ba0)

## No fixes (compared to v5.10.49-594-g3e2628c73ba0)

## Test result summary
 total: 79086, pass: 65714, fail: 1691, skip: 10507, xfail: 1174,

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
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 27 total, 27 passed, 0 failed

## Test suites summary
* fwts
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
