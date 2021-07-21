Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 611843D0B62
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 11:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237833AbhGUIir (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 04:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236870AbhGUISM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Jul 2021 04:18:12 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C582EC0613EF
        for <stable@vger.kernel.org>; Wed, 21 Jul 2021 01:57:21 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id hc15so2121157ejc.4
        for <stable@vger.kernel.org>; Wed, 21 Jul 2021 01:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dPUNY2N70IWHdqlhkZrd0lInW4bOlZ9Slu+L+VjXhJE=;
        b=SrWZuMVwVPK1k37aWFSoP+403FgEUmiZMgRb/LXs+liidYIbvcM8INvkYUngExavAG
         aqqfAGs5q4U6PjRAyXqryCutwkuYu3/nccXLf/4NTVziuw513+pOHe5g7kbM6D8YB81F
         jaXNp9LP/GbPVLXnn7U4IoMe0iyyC/Um5+DqQzvYcLaQhiGuenM3NHaDK+gbXHexstc+
         5wnW4Xl6ye+ZEAEeCzH2oPBWuMjpQG7Jt4Sc19+PFOCuyGMGUo39c0ICtEAmJyAYJx4g
         18FzblrxLrnAKy9u4TQ0y1bHzuyYiN4Lg1fGN3RB0fX6mFEQHRJS7OfaZou53/iSiEpu
         dj3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dPUNY2N70IWHdqlhkZrd0lInW4bOlZ9Slu+L+VjXhJE=;
        b=VEfP4lXodoQvRGHJkGaFguad2PPSxWIk0H9XnR3G+CStCZz8iaF812t2wMcTlvp5gu
         uwAU93czYngEJwmsdS2zbUNOnFfu7Psbk+YI9jrB8/U2s1RvoCL5VeVZnZB4nT6vHg07
         RaMU6HvUHFQQsSZmtYkyOZCqI+dROIfDOhFuoLKARBBPKpRmn0J925L1wWqZjj6ErFxS
         9iPTC3bUChmJu4a8/K6MIxaIQPqg6HGWtDhiRbEeVlBRcd8h9C3OGbaWPEsIz5jGERZ6
         +aE9mQlSfzlxAFUoTNz6gfIONifqnRv4GBuxo8m7Gwy4PViz2WbczrCYn4eENnXRd9in
         CaaQ==
X-Gm-Message-State: AOAM533Hc/3NJzwylEDHnRNH2cSogiYsK/NHDWW0g5Y2BOhH2GogZ7v+
        HbHc+Vm2VR1b/+cn62Wkgaj2wUWGOd/1UoS2hCpsaA==
X-Google-Smtp-Source: ABdhPJw/SXlwlaJhkvQDBQ51DCoVxxVWzyPn3a7O0HURpVCl2Rm0WSkPphTMdle0XwDxYmBZ8tMCt/AbiTSSiYDHhKM=
X-Received: by 2002:a17:906:844d:: with SMTP id e13mr37400461ejy.503.1626857840178;
 Wed, 21 Jul 2021 01:57:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210719184316.974243081@linuxfoundation.org>
In-Reply-To: <20210719184316.974243081@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 21 Jul 2021 14:27:09 +0530
Message-ID: <CA+G9fYtS7S9j-2B7pB47VpzZ6moWC-9vjX9hyVk_x9r_FF8R1A@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/148] 5.4.134-rc2 review
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

On Tue, 20 Jul 2021 at 00:15, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.134 release.
> There are 148 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 21 Jul 2021 18:42:54 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.134-rc2.gz
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

## Build
* kernel: 5.4.134-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.4.y
* git commit: 5b0c31d40d771b5f47ddc5fc813761aa13c34944
* git describe: v5.4.133-148-g5b0c31d40d77
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
33-148-g5b0c31d40d77

## No regressions (compared to v5.4.133-150-g58bcc6ca3a4e)

## Fixes (compared to v5.4.133-150-g58bcc6ca3a4e)

* arm64, build
  - clang-10-defconfig
  - clang-11-defconfig
  - clang-12-defconfig
  - gcc-10-defconfig
  - gcc-8-defconfig
  - gcc-9-defconfig


## Test result summary
 total: 72756, pass: 58812, fail: 1131, skip: 11656, xfail: 1157,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 192 total, 192 passed, 0 failed
* arm64: 26 total, 26 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 15 total, 15 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 21 total, 21 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 26 total, 26 passed, 0 failed

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
* kselftest-x86
* kselftest-zram
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
