Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6295C342C04
	for <lists+stable@lfdr.de>; Sat, 20 Mar 2021 12:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbhCTLT5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Mar 2021 07:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbhCTLTe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Mar 2021 07:19:34 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F74C0613B8
        for <stable@vger.kernel.org>; Sat, 20 Mar 2021 03:48:06 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id h10so13664322edt.13
        for <stable@vger.kernel.org>; Sat, 20 Mar 2021 03:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pgUlQnIH/sy7L2vQNmfcbiIFL+U1sgCh1fWfgNUyW4U=;
        b=yvvlT4dPVpALglSKY0w0kmQriRtM9Y6svF0/dqES2TPcgzCvlc3ZV3gss4diGe42qa
         eE/FJNjSzAg0D99ac4B8m86Akf1dmAp8E+UgF0lHSPFGpnGQ9kKt7p+I43IGOVnyE1rz
         tZ2JTQNc3EGHXrIJCklUVshqDuM7yfkHTb/ofSc/zUiLn/xsHGTW1t1E4LAkby1rmHBq
         AA8fv3FD8ZItUqIrPAGTZRuKwbDNYiZQFy4XTbfya5EUbROla60bU3Eqsie6/GzF4Nig
         OfDoM3B7zwzQ6Xhb4I4TrFz4ske1PBLsE46ivpSIhRRvDO98m8JJvYOFCGbl4K24VAYS
         CESQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pgUlQnIH/sy7L2vQNmfcbiIFL+U1sgCh1fWfgNUyW4U=;
        b=AFwj4Sw6J7LWOWSciobvfpSEbQPikibcioyBxnGbpRJENFIBLJf6UQeN1YZTZY44zL
         SGlTB1niTeqF/XB9bxSVNTisRxntm5HLStUYOHUH8aUCCUckQPtd3gWjNS7JH2n4uqpn
         4e9Z2D/ajcUUxRcPIS3gUEQuUTdCxU+xaCuSokXHY9E7TK1BRSIOiWh+hguqBcMluf1/
         +w+X3ecaghAl4dY8IZnBVD6IY0k1UO4y8jt1d86z6zvuzc6jKuDIx7VyAC7SYEHIWndS
         MSvye+Q4ktmriR73A4oITXIr0twxD7I88Ew9r3xQCXgFXs5PCzP/5d/l/t6Ozk/DNFIX
         OBZA==
X-Gm-Message-State: AOAM531HUZrp42+5et5DPWcESbn77yaWByrmfNz09U0hZagRF7i7Q3kL
        q5jlZhb0pOgyVSR5jl7Qa+C0szU89qhoSNH5vMDxrKNYM8zpdDjf
X-Google-Smtp-Source: ABdhPJw+RmCAZ30vRYMFf2lJockDUW5ppiKYZnoOOJuSUUTiYWinH2c/rc7HPo9SIdkrkP978ahsTz4R1jMUbeSiy/I=
X-Received: by 2002:a17:907:720a:: with SMTP id dr10mr1039935ejc.375.1616228105639;
 Sat, 20 Mar 2021 01:15:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210319121744.114946147@linuxfoundation.org>
In-Reply-To: <20210319121744.114946147@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 20 Mar 2021 13:44:54 +0530
Message-ID: <CA+G9fYuM5SQwM5g8w8MLbYBqByaepz1fKGs5iwkhKR_y1A6aVQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 0/8] 4.19.182-rc1 review
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

On Fri, 19 Mar 2021 at 17:48, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.182 release.
> There are 8 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 21 Mar 2021 12:17:37 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.182-rc1.gz
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

Summary
------------------------------------------------------------------------

kernel: 4.19.182-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 7281e11121f6fb47ea1e757b7781c5c15e3781fe
git describe: v4.19.181-9-g7281e11121f6
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19=
.y/build/v4.19.181-9-g7281e11121f6

No regressions (compared to build v4.19.181)

No fixes (compared to build v4.19.181)


Ran 58666 total tests in the following environments and test suites.

Environments
--------------
- arm
- arm64
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- mips
- nxp-ls2088
- nxp-ls2088-64k_page_size
- powerpc
- qemu-arm-debug
- qemu-arm64-clang
- qemu-arm64-debug
- qemu-arm64-kasan
- qemu-i386-debug
- qemu-x86_64-clang
- qemu-x86_64-debug
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- s390
- sparc
- x15 - arm
- x86_64
- x86-kasan
- x86_64

Test Suites
-----------
* build
* linux-log-parser
* install-android-platform-tools-r2600
* kselftest-
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
* ltp-commands-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* perf
* v4l2-compliance
* fwts
* kselftest-bpf
* libhugetlbfs
* ltp-dio-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-mm-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* network-basic-tests
* kselftest-kexec
* kselftest-vm
* kselftest-x86
* ltp-containers-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-open-posix-tests
* kvm-unit-tests
* rcutorture
* kselftest-vsyscall-mode-native-
* kselftest-vsyscall-mode-none-
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
