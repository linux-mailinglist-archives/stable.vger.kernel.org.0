Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A42DD331E06
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 05:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbhCIEnl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 23:43:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbhCIEnk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Mar 2021 23:43:40 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C54C06175F
        for <stable@vger.kernel.org>; Mon,  8 Mar 2021 20:43:40 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id r17so24859821ejy.13
        for <stable@vger.kernel.org>; Mon, 08 Mar 2021 20:43:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=h53NPiOJ9hX8bXjlAIC4CS9wGdO6ZbZbLlf/R8bwdUQ=;
        b=mpjAYyq672Mj2enPjZz4Bifull4/DHrB1mKl2/6HoT/ucMqppn03Ax7M3/SLJKcj3O
         fimFdOtQMAAi2miTFZIkUUwp0Vhhu3Y2bIAw8Lm4Bu/C/y3LYKlnG9g1zhWsJJqnK3D3
         pvDmS8BPjDPBcXorNDkgFCZh1No+nuba01RmTN6E6yOdmdz+g0HLARISKkMAH1uvLoNI
         0EHjHiF+ZclGB799gMLwnvgf7Q29krBwO+uue2OJKPtylfNqwZOOqT/QcYp7iwUnj1sP
         6M3PvYuM0ReBGrGOddgiH7x9/9WQ//KDEtKacrrJDp1R0+dgesnvN7b65NAd5UB/PyJ6
         bKUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=h53NPiOJ9hX8bXjlAIC4CS9wGdO6ZbZbLlf/R8bwdUQ=;
        b=QC2kwXLpq8j3FNscrZ6rXSTWSabGpVty7iWDWxMl6w2kxec3IcS/CBpz2IF1axuk4t
         XlRc/vT/eXvMHue22Qx3sSBtkbwPMchJYnRGf9uzzEYRaChxxV93xDBoodnkcaEpN/EF
         frJq6mV8NzDUYzHINL/fur0WNhaCrolwATa8uzSm813vttUItzjBgWAg0z8BW1GZqB+U
         XzXaF8lhImvR3Q1ENrBmnI59N5KezJ6pmCayO7zllgjLd7+lBz8ujzieG16gQ23uesQY
         IZsGjPNsVI2pjFE2E9pZekj9FjDD4ZuOCRuC3HAZE+MQLFS0hWPzjxPjLRWOp/CToa03
         tvVg==
X-Gm-Message-State: AOAM5313ncDvz90R76Ia/h4yFcE4K2The3wR1A0tyiE0FCJZoBAi6vHG
        YXEPV3LTBNyzVN2ggqbYPgP1I6MVKCE3QtOZUGpSjw==
X-Google-Smtp-Source: ABdhPJxNxMZh710hWWMykxmEJsNPt0JYbmezwJe6PTMGZFCsropOkMmXatY3KzrccSGjn8ONe01b1bdQ9rR1HQWchVM=
X-Received: by 2002:a17:906:444d:: with SMTP id i13mr17789458ejp.170.1615265018691;
 Mon, 08 Mar 2021 20:43:38 -0800 (PST)
MIME-Version: 1.0
References: <20210308122718.120213856@linuxfoundation.org>
In-Reply-To: <20210308122718.120213856@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 9 Mar 2021 10:13:27 +0530
Message-ID: <CA+G9fYu5L90w3f4p30uTRn-KT03ZVzg4a8cfJa-01JXGwtG8Sw@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/42] 5.10.22-rc1 review
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

On Mon, 8 Mar 2021 at 18:04, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.22 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 10 Mar 2021 12:27:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.22-rc1.gz
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

kernel: 5.10.22-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.10.y
git commit: 9226165b6cc7667b147e1de52090d1b6a17af336
git describe: v5.10.21-43-g9226165b6cc7
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10=
.y/build/v5.10.21-43-g9226165b6cc7

No regressions (compared to build v5.10.21)

No fixes (compared to build v5.10.21)


Ran 56945 total tests in the following environments and test suites.

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
* kselftest-android
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
* kselftest-livepatch
* kselftest-ptrace
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-containers-tests
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
* ltp-io-tests
* ltp-sched-tests
* ltp-tracing-tests
* perf
* v4l2-compliance
* fwts
* kselftest-
* kselftest-kvm
* kselftest-lib
* kselftest-lkdtm
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
* kselftest-zram
* ltp-commands-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* kselftest-bpf
* kselftest-kexec
* kselftest-net
* kselftest-netfilter
* kselftest-nsfs
* kselftest-tc-testing
* kselftest-vm
* kselftest-x86
* ltp-controllers-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kunit
* rcutorture
* ssuite
* kselftest-vsyscall-mode-native-
* kselftest-vsyscall-mode-none-

--=20
Linaro LKFT
https://lkft.linaro.org
