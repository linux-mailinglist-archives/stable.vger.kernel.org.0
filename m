Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7794034265C
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 20:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbhCSTjf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 15:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbhCSTjG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Mar 2021 15:39:06 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E2EC06174A
        for <stable@vger.kernel.org>; Fri, 19 Mar 2021 12:39:05 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id u5so11547487ejn.8
        for <stable@vger.kernel.org>; Fri, 19 Mar 2021 12:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+RGsCEMUFSYEdYRwbEYSMZ0Hpk+/jkoO6bx9V2//bbY=;
        b=FUVW6urBwsR0SGIxzRaogwm3w2VFA0OK5DXBO2PhE/IiUUjUvWQVw+2E/2wfFqSqDx
         QMy7MGMA/qB2kbSj548uIJQBR1GwQ8SyZAaYBib6JpyYej1c8jAcXf2xCQ4A0xfR8A8C
         jsZJqWlN2DECOq7P/+m8wuctZPRjS8HqkTal1EBbGcZ4YOVktvPCqEbIdZjmiGnlhnEg
         /pi2k+7iu9DVvHNfMDAWuRy4AbgMW9DDyhcBdXT4KbJTL7A0Es7iwgR1k9Bpukn8FXdc
         SejfgogVeYqDDAJWpM9aux+bEpQC8HB0m0HXN/OT02Gv2N22OZpf5E+JnPlGdyAiqejZ
         zaTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+RGsCEMUFSYEdYRwbEYSMZ0Hpk+/jkoO6bx9V2//bbY=;
        b=ty3YJHCF8J52ymCHzv8KmEwM6uFNm+xaU4RCymi36DhyW+GtdheqlC9ADARcknVjTF
         5f7jt4I8fnPS+kpDCvd4pg8TD7aFb7dVfTC/0CYfobHjIIZr3nK3+ZS8QgVSMCLFVyW2
         FjWsZK/HbHhLLv6GP2Y6MXxHa50do3sLLarI38Ew5EqeixFOHDaRMQR0GU/dmxdvvWbD
         b3jwNTUxFmJg7OL77qBLJ+FyW5egdMi6kUuBYm9PKrMNaH4oTBj0Q2575qSOk3ChVWh5
         n4LpPFZ/Uaao4+Z3oyOVunxSsxESOeGNQXOmJD1U+fhic7N2Tgwrd2TwdRb0gV3Js+G7
         UQTw==
X-Gm-Message-State: AOAM533RG8jyCl7NE12B6Po6xNEK3NGUoejHfqMIsqIDxExRZxt1NRR/
        zTCgf3uk/f+X3p4qVZKauY6DdIwYhrtuWl7GOCRfLA==
X-Google-Smtp-Source: ABdhPJzxWXQiENgt57OW8Dew9TbFMoV8ERb9e+3KhZafNMxzqQiLO18czzQVeouvk2YKtsvYz3ilK3PiGQLvYbzSpWU=
X-Received: by 2002:a17:906:70d:: with SMTP id y13mr6123434ejb.170.1616182744163;
 Fri, 19 Mar 2021 12:39:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210319121747.203523570@linuxfoundation.org>
In-Reply-To: <20210319121747.203523570@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 20 Mar 2021 01:08:52 +0530
Message-ID: <CA+G9fYs6BxWn=Myx=RvjTqpR9cwAnJ5qfgC2xdEhg-3sfYf2EA@mail.gmail.com>
Subject: Re: [PATCH 5.11 00/31] 5.11.8-rc1 review
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

On Fri, 19 Mar 2021 at 17:51, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.11.8 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 21 Mar 2021 12:17:37 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.11.8-rc1.gz
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

Summary
------------------------------------------------------------------------

kernel: 5.11.8-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.11.y
git commit: 48a0708a31ceced042f5acd1d6a225a2fb66ebf3
git describe: v5.11.7-32-g48a0708a31ce
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.11=
.y/build/v5.11.7-32-g48a0708a31ce

No regressions (compared to build v5.11.7)

No fixes (compared to build v5.11.7)

Ran 66943 total tests in the following environments and test suites.

Environments
--------------
- arc
- arm
- arm64
- dragonboard-410c
- hi6220-hikey
- i386
- juno-64k_page_size
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- mips
- nxp-ls2088
- nxp-ls2088-64k_page_size
- parisc
- powerpc
- qemu-arm-clang
- qemu-arm-debug
- qemu-arm64-clang
- qemu-arm64-debug
- qemu-arm64-kasan
- qemu-i386-clang
- qemu-i386-debug
- qemu-x86_64-clang
- qemu-x86_64-debug
- qemu-x86_64-kasan
- qemu-x86_64-kcsan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- riscv
- s390
- sh
- sparc
- x15
- x86
- x86-kasan
- x86_64

Test Suites
-----------
* build
* linux-log-parser
* install-android-platform-tools-r2600
* kselftest-android
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-intel_pstate
* kselftest-kvm
* kselftest-livepatch
* kselftest-lkdtm
* kselftest-net
* kselftest-netfilter
* kselftest-nsfs
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
* libhugetlbfs
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* v4l2-compliance
* fwts
* kselftest-bpf
* ltp-cap_bounds-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-ipc-tests
* network-basic-tests
* kselftest-
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-firmware
* kselftest-fpu
* kselftest-futex
* kselftest-gpio
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kexec
* kselftest-lib
* kselftest-membarri[
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
* kselftest-mount
* kselftest-mqueue
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-vm
* kselftest-x86
* kselftest-zram
* ltp-commands-tests
* ltp-controllers-tests
* ltp-math-tests
* ltp-open-posix-tests
* kvm-unit-tests
* rcutorture
* kunit
* kselftest-vsyscall-mode-native-
* kselftest-vsyscall-mode-none-
* perf
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
