Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 849C43198A7
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 04:17:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbhBLDRa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 22:17:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229467AbhBLDRa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Feb 2021 22:17:30 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B735C061756
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 19:16:49 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id jj19so13403196ejc.4
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 19:16:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KVZtuYvOKUEsNgQwhQovnxv616oWXfLXbkLFGeqHv/k=;
        b=xDKTXh2iegaRZAZwNcJnJpcYJZlDThSDc7WkY96oX89M2GhPXx/C3WPeqinRlVvmQ1
         nymgPGSmeSuvhQoCGPxFc3h+oVQRkRmNDPqE5EhsSzEZUvCylnNLZLWBO4Kp92NejUwj
         qqrzZn0UKygVvMdBqySIKnQ9cDTO9sr6FLDoBgyQhn2c5NcWHfKOdCrptn2KL2+RMPoj
         1EIUlKOYRyAq5zg0Dj3DSdbFNWDSvjqvuixUnEgSdrfdlqSyE32CFh/qljXplX5Z4+0R
         kX3If/xFeQ+/gDMJn2eNjI6IO+wTqBQt8ok541cRu+G5hIG24kL5BNyDJiYB2Bher9ll
         BiBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KVZtuYvOKUEsNgQwhQovnxv616oWXfLXbkLFGeqHv/k=;
        b=n18JTcleJVv2PjSCffIOpyR8qizepcocb70bxiZAKQqgNL6LKXfH40HGtgx1D4n/KB
         0wtCy4qz8J9c2lt5xsh8Vf3VdenPsKLYXudu+Pi+MmJ2ibLzh7LrW5gdL+14WScbXQOS
         fe1fVV+q1Lto279H0fy5fZrY0PlY738h9dkMeNzc1NAYWQREes+J7UwqTACO5fqFNJVv
         SWE5TznQBvtTwvMq6YTM8ZP4Gh8iZT6cPywj9o+siuxMnvgYUqrjTLHE6ZpLaPzRMl2a
         vmmg5EHzAeW3K9AlC57hrlzimn9JAENuBf7wWF3hXF3f4Grmayzxooqhr+nt5Gbm0ajD
         xXvg==
X-Gm-Message-State: AOAM531nJ+M6W3ZiE4mLib7LojPPxHSlD/8Gm40wZHLkW3BLVkPwxY1z
        x1wQ9dnp5cHcwKn7ral21Bu783BzWRl5dHenmQN79Q==
X-Google-Smtp-Source: ABdhPJxXIk7JjUBq/AWaEQMa48Muel2AJuJ2aEdSxsH0CFH5Ahl5xFzGaT54y5b1DR+89GZZ9tN0n9Zt+KOXcN9WoQA=
X-Received: by 2002:a17:906:6943:: with SMTP id c3mr892505ejs.133.1613099808067;
 Thu, 11 Feb 2021 19:16:48 -0800 (PST)
MIME-Version: 1.0
References: <20210211150152.885701259@linuxfoundation.org>
In-Reply-To: <20210211150152.885701259@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 12 Feb 2021 08:46:36 +0530
Message-ID: <CA+G9fYub55vxyF97HoVX58S9aUOQvNDoespFrAMKMffd0owzCA@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/54] 5.10.16-rc1 review
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

On Thu, 11 Feb 2021 at 20:35, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.16 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 13 Feb 2021 15:01:39 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.16-rc1.gz
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

Summary
------------------------------------------------------------------------

kernel: 5.10.16-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.10.y
git commit: 4dd7e46ded5fc095df2bd9a6e3ca023150c55452
git describe: v5.10.15-55-g4dd7e46ded5f
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10=
.y/build/v5.10.15-55-g4dd7e46ded5f

No regressions (compared to build v5.10.15)


No fixes (compared to build v5.10.15)


Ran 50609 total tests in the following environments and test suites.

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
* kselftest-bpf
* kselftest-kvm
* kselftest-lkdtm
* kvm-unit-tests
* ltp-containers-tests
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
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-tracing-tests
* fwts
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
* kselftest-livepatch
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
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-math-tests
* ltp-syscalls-tests
* network-basic-tests
* perf
* kselftest-
* kselftest-android
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-kexec
* kselftest-lib
* kselftest-membarrier
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
* ltp-controllers-tests
* ltp-open-posix-tests
* v4l2-compliance
* kunit
* rcutorture
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
