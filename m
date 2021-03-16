Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADD9C33CD02
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 06:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235259AbhCPFQX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 01:16:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbhCPFPx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Mar 2021 01:15:53 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B75C06174A
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 22:15:53 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id dx17so70081484ejb.2
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 22:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LEFPFvt8MF2rFyKja9eaaDVQnks2LWaEMeyDoOUgbCU=;
        b=zQZYOjElW6H/wgGZfpVu7He5892VE+ZgqHAEKzgVPsqIAQ/gHgQO5t3I8+DFpE8tnX
         FCFmDzIMKQPJvIMIyq9zuOyqYsVu+5K6adc9qKW1HBTyTvdSnSE3oDZwnTHVt/uj0uit
         u/bbC0eFT28gB0X1s0k5LNK3m17M47Uc9ltoiEwHz0ZeSSKrbMTIFioAgmn6aZucNd32
         9rQVoY8DO/FNFbhV5CvPZu8ZKMg6rxouziksZZBbaCCI7Ein8rRd+9mRRmjrYfRbvJu4
         n2obczjyjUb6U0wwtz1mryBksQUtfh9Y3QSs5KocDTGf+SsVyxulMH4j5IZKBYUjUCos
         29Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LEFPFvt8MF2rFyKja9eaaDVQnks2LWaEMeyDoOUgbCU=;
        b=Nj1oYlmerz+fcmqXHspVttfZFBbPJLJi558lUywJWrIv/wK59HzTja57ziwppv17gT
         oQL4bBGJ1BhqPc2GlKoxcVeetccwDowu0f0iKpPxDmglhRQ2L3NgtvrSxM82wAh4r0sG
         ovpRqksbBg9G2MeFCNyA4BiejaLODI8KKbxnvYR79zj8Gzm82NWcGvQTnAjXxafswj0H
         qLcoFibo7xyHiM352DEhm0lLJwa0bSysnD27uef729MaMBF1AuS80pu2rG2iH+NTRLSS
         0nhV3DOFuEnJj7+/b6o7lSeziK8VXVYOxtahn4l2+z0aSsrnQGzUVKE+PsoRIfhkSL0j
         oAQg==
X-Gm-Message-State: AOAM532LRfP2C8/JQolG6qix/eeTrOSgMt/zewXK23LobVW8NB23V5Q5
        L3mZ0+kEDuM+8hLpNi6fqlEisAb9iRDmuMRimMCFDPSptenutlLx
X-Google-Smtp-Source: ABdhPJwbG6uVNN/F0ddv4R2N95OyaeqaT44/3JzAScasAmWVJP434nmjFCBKOKVY14jiXK1B7rbRobAeKHwVaL0si8w=
X-Received: by 2002:a17:906:70d:: with SMTP id y13mr16656551ejb.170.1615871751994;
 Mon, 15 Mar 2021 22:15:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210315135507.611436477@linuxfoundation.org>
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 16 Mar 2021 10:45:40 +0530
Message-ID: <CA+G9fYtRqGK2QUWCMQ8W0awGxykCYFMRCXYud9yKHkR3_jooQg@mail.gmail.com>
Subject: Re: [PATCH 5.11 000/306] 5.11.7-rc1 review
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

On Mon, 15 Mar 2021 at 19:27, <gregkh@linuxfoundation.org> wrote:
>
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> This is the start of the stable review cycle for the 5.11.7 release.
> There are 306 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 17 Mar 2021 13:54:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.11.7-rc1.gz
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

kernel: 5.11.7-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.11.y
git commit: f109baa2424b2523fbb975de996fedc7a53ef531
git describe: v5.11.6-307-gf109baa2424b
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.11=
.y/build/v5.11.6-307-gf109baa2424b

No regressions (compared to build v5.11.6)

No fixes (compared to build v5.11.6)


Ran 55999 total tests in the following environments and test suites.

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
- qemu-arm64-clang
- qemu-arm64-kasan
- qemu-i386-clang
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
* kselftest-lib
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
* ltp-cap_bounds-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-dio-tests
* ltp-fs-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-syscalls-tests
* perf
* v4l2-compliance
* fwts
* kselftest-android
* kselftest-bpf
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-zram
* ltp-commands-tests
* ltp-cve-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-tracing-tests
* network-basic-tests
* kselftest-intel_pstate
* kselftest-kexec
* kselftest-kvm
* kselftest-livepatch
* kselftest-ptrace
* kselftest-vm
* kselftest-x86
* libhugetlbfs
* ltp-controllers-tests
* ltp-mm-tests
* ltp-open-posix-tests
* kvm-unit-tests
* rcutorture
* kunit
* kselftest-vsyscall-mode-native-
* kselftest-vsyscall-mode-none-
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
