Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E335832F93E
	for <lists+stable@lfdr.de>; Sat,  6 Mar 2021 10:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbhCFJzz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Mar 2021 04:55:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbhCFJzb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Mar 2021 04:55:31 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D556C061760
        for <stable@vger.kernel.org>; Sat,  6 Mar 2021 01:55:31 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id ci14so8658978ejc.7
        for <stable@vger.kernel.org>; Sat, 06 Mar 2021 01:55:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=79KHpaMBPafi3Bn2aleStdPnZiV42c6ygeQVY6heukU=;
        b=C/mJoCNER92dwghTTlwljoT+3f7QZA7cegPPopdcRO8hYLcjEiwd2tz5Y78WdwPmpF
         HX4uGEgMVXJQf6DVbSrb4nWHPxCCnjDnkvrUZmfMLC8m/nPSOwrkdIv7H4mIJ8RxT6Xu
         7N1uNEQimgwojQDwH70SHaj47CN6bKRhUJnpIumGdN2EqPTlVPcs+JhhBvWDNqbsXicp
         yf+TJHBdB++teVxlDqE6HhSU1JbiyWTFpMqXzIYwxr0xEZe/Zes+lgPv/suq3A5D+yRh
         peb+n1JiWiudkWC1DNA621B3oa1LAxnnXJ+Nd6nb3Z8cvKn6MIQEPBpJ3rWv7xwphsMw
         cxaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=79KHpaMBPafi3Bn2aleStdPnZiV42c6ygeQVY6heukU=;
        b=g1npuHjNrV2ROjBf6oLa9Q15Vn4uzyngM9z2JvzoLdbXP7CaBsZUlXe8y2ifhuqu3W
         wjcAINLtk2vJKtfBVJlVpfaONIikfz1YHER2Qg+nJ3GrDtskjrPac1X/P9jdzCCwCpIM
         htDnzXNhmpZNX4YJ9k/LBHoqNTo93FG2sPDe6EF5WIS8kt9W2MLlnPjekRJ2CvTDPO3A
         RtttPLPyD0qg/NGAiKcAK6eUZPArroF2VcJZvciQc2hYjaR93Yo5oI0LQo9ZHbw2rivt
         PZQm9LKsUInqO4hNtFK6fAKcP2Rjzi0F/8DYJpmaZH7MGzullJ3Jyek7y0RHAqO1XhXL
         wqeg==
X-Gm-Message-State: AOAM530dTke6MOBK4tph2kRKhq4wjyDHZqJArvZcKC1em9jnqz+oP8+u
        iBhAHDy29NZuzbfMYttOIonUHxlKMxhgklAey9pPJQ==
X-Google-Smtp-Source: ABdhPJzKOYr2DXVoeGQLpOBtu2aymv2AaHhCpUiuVVEfYGsI0IeDFNen0j+qKVavETCvUcztIP4chEmXwaqAtjl9/5U=
X-Received: by 2002:a17:906:444d:: with SMTP id i13mr6100426ejp.170.1615024529586;
 Sat, 06 Mar 2021 01:55:29 -0800 (PST)
MIME-Version: 1.0
References: <20210305120857.341630346@linuxfoundation.org>
In-Reply-To: <20210305120857.341630346@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 6 Mar 2021 15:25:18 +0530
Message-ID: <CA+G9fYvaJdGe1cQB1upCb4kGuLV9J_0x78kN-v_X-knHkX5TQQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/72] 5.4.103-rc1 review
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

On Fri, 5 Mar 2021 at 18:04, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.103 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 07 Mar 2021 12:08:39 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.103-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 5.4.103-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 2e10dba9fe0e67740146f3b3be42ed9403a7636e
git describe: v5.4.102-73-g2e10dba9fe0e
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.=
y/build/v5.4.102-73-g2e10dba9fe0e

No regressions (compared to build v5.4.102)

No fixes (compared to build v5.4.102)


Ran 54103 total tests in the following environments and test suites.

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
* libhugetlbfs
* ltp-containers-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-io-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-tracing-tests
* perf
* v4l2-compliance
* kvm-unit-tests
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-syscalls-tests
* network-basic-tests
* kselftest-kexec
* kselftest-vm
* kselftest-x86
* ltp-open-posix-tests
* fwts
* rcutorture
* kselftest-
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
