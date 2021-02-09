Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A529A31485B
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 06:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbhBIFvM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 00:51:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbhBIFvM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 00:51:12 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 484F1C061786
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 21:50:31 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id q2so22009612edi.4
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 21:50:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=RJjgesn23X7Db8cnvTKzmtrqcIT6X/e0B2Dtp0kT6Yc=;
        b=UnHSr4EpJNqFY/jhuy4lV9RhMemejbr1EWSkNCQRGT/PdpT40ZNQ60Gx92wkeoc/P/
         qqS0bt06qEUbowBcIXgWekvx7ToTfkUtxxMnX0HO8t9d1J8y3gOuXDM/SccpdWh4w4TF
         0gKrbDu1nnbSkLu1tKjWP7bbDwDOx9I04J+LAGA5Hqd4tUA5nflH0KCipDj9Y/lrSDfQ
         7pCEgkL0UDryc3j0i3u74YBNCiNGORl+glT1IvFhnuUcYZ3B2CaGMM5KcjMfj2B88bp3
         eLvXz9cGylr02sVh8hfG/NFC6B5onSXm9JnfNWnT2DeVQyvVpvLfrwlPNsjA6RJRWnDZ
         BVOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RJjgesn23X7Db8cnvTKzmtrqcIT6X/e0B2Dtp0kT6Yc=;
        b=oSFRWhIQhEp0eXm/cZXJM8R0rDF7Zy8DFc8pBVOoKAZ8vga9kGPIVLCwf1+ZRCTqSR
         Y7oBtXed+rhRfYBX+q5bmaThlHwf4OaF/EY79voWzDoZXAqHJ0ASDIXAoUcM6O6oGMqP
         Ifqf0HNGEPVeSTgt4A5UVNN0b3X2hVSbj1ot4wJ3uCmxVyrP14mgWLsPnLBKdqpl42bF
         s4JVclbSe+RXDjgjm9gAtqGcqUHaOkeLBGkR0F4Y5/kvqdhogKVavyrkcfmCbikl8k5J
         qUthMQ3FR/YvRvqoPpsmb6qn0Vxe+u8KVzI+7kZPT3n7fnu13Zt4yeIKDeMGB95RoFkY
         eslA==
X-Gm-Message-State: AOAM530ldHQCctfsGuShLGnGmKt0xLF8SrWcf2GEgNivba5fdVOonzdr
        2che3aJaCEzMSHh55EkMAA3C2oT5/uJh5iBkoFYy5Q==
X-Google-Smtp-Source: ABdhPJwEBIElMab1I1gJU4zJ/jxMLChyWiwFpc9bhugskWu6u7yhZRyERk91kYVPusJhYPOIxThljLAyt0KZnZB1P9s=
X-Received: by 2002:a05:6402:702:: with SMTP id w2mr21398627edx.78.1612849829918;
 Mon, 08 Feb 2021 21:50:29 -0800 (PST)
MIME-Version: 1.0
References: <20210208145810.230485165@linuxfoundation.org>
In-Reply-To: <20210208145810.230485165@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 9 Feb 2021 11:20:18 +0530
Message-ID: <CA+G9fYu0bMXa3cn7qtd+52iwR17PH4ZADDxsdj2Q3QGY_3=EjA@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/65] 5.4.97-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 8 Feb 2021 at 20:41, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.97 release.
> There are 65 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 10 Feb 2021 14:57:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.97-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
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

kernel: 5.4.97-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 7b6a7cd488bf6be0b5d83709c148c3d69c737a15
git describe: v5.4.96-66-g7b6a7cd488bf
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.=
y/build/v5.4.96-66-g7b6a7cd488bf

No regressions (compared to build v5.4.96)

No fixes (compared to build v5.4.96)


Ran 50496 total tests in the following environments and test suites.

Environments
--------------
- arc
- arm
- arm64
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- mips
- nxp-ls2088
- nxp-ls2088-64k_page_size
- parisc
- powerpc
- qemu-arm-clang
- qemu-arm64-clang
- qemu-arm64-kasan
- qemu-x86_64-clang
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
* libhugetlbfs
* ltp-commands-tests
* ltp-cve-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* v4l2-compliance
* fwts
* install-android-platform-tools-r2600
* kselftest-android
* kselftest-bpf
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
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
* kselftest-zram
* ltp-cap_bounds-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-mm-tests
* ltp-sched-tests
* ltp-tracing-tests
* network-basic-tests
* perf
* kselftest-kexec
* kselftest-vm
* kselftest-x86
* ltp-controllers-tests
* ltp-dio-tests
* ltp-io-tests
* ltp-open-posix-tests
* ltp-syscalls-tests
* kvm-unit-tests
* rcutorture
* kselftest-vsyscall-mode-none-
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
