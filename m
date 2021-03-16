Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D042B33D0E3
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 10:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbhCPJeK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 05:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbhCPJdq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Mar 2021 05:33:46 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0FC0C06174A
        for <stable@vger.kernel.org>; Tue, 16 Mar 2021 02:33:45 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id lr13so71024486ejb.8
        for <stable@vger.kernel.org>; Tue, 16 Mar 2021 02:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sTSjV0k7aYMh48sDF9lHvN5tVI/LaskmTHtn/37QvSE=;
        b=C68DfTgNR86XrIUaTSGBWS8al1EK3vK2Z64CHZtf7r2lmPx3u6VDegf6+mmDBBoPsK
         6iQ04ehtR2kGl6+R/Xupv2fmxBxTLhf/x/1c6iFy3E3Xn1hXVHTTflnMXQnv2cPDrH+t
         I1X+a3sEoexaLxjAt1m8k21CevpGia7TPUp8Wq+gpDhgEKvo3W3B2z+3wSfTeqy4W0va
         Dc0h603TyH3rr6XxBG7W8H3WJdFe567QWqpw1bk5o428i8i2tAIEshWs+QfICOKZupsA
         ETdVDWeCvlu7drZcalPc7PwPFHKnjBOONnPmXJGHmAnAFNVmE8usX4Zx++Jqt4JA6N2k
         mTZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sTSjV0k7aYMh48sDF9lHvN5tVI/LaskmTHtn/37QvSE=;
        b=LYGPTKRRWw4PdwYnTHHmgBheuco9DRJazqu2hvDaWmN0bl7sosA7dNph5T0abJkX3D
         m9IgSs78/7z2gbTQpyd1Vw7QnlKCF1eOSL+qgKFsUBZzIugBWi5M4C1pUo6zxAMlUyZW
         8dTTySKmYOdiz3KaSjxwuU1LWEWBu5OMlKYE/pl40J53DyDtnuqMMdUCWUpQ3OD8IT8N
         1dZbpx3Hp8IjqLdpqYys2U6e1RPGFyTxLOe501KxnCevHJ9mYQ8G1eW0gIhxuf7fFl1k
         +4X+hMiCmEMHTW2hNookpzWaFkHCeRZtn5gpXUUY1Sxi+TPWfkeQCChgrbLDRz5Yl444
         HOiw==
X-Gm-Message-State: AOAM532mqTumj6SDGFjhQq4yStipgh4xO+g7qjgBA0O6/f+UEt3XeqRq
        wEY0Vtqmi6qYvGhrMWyjTJAcCkaJlrVQhtu5fX8OLw==
X-Google-Smtp-Source: ABdhPJyL+BaPgKhnE9Y3B0eaZgXDBBma36rIJcw7xSM2pTh9CNYmCGuZUr/oadmLPL33ptVPg+MkQavKHkK9RrxNj+Q=
X-Received: by 2002:a17:907:7785:: with SMTP id ky5mr17118612ejc.133.1615887224450;
 Tue, 16 Mar 2021 02:33:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210315135720.002213995@linuxfoundation.org>
In-Reply-To: <20210315135720.002213995@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 16 Mar 2021 15:03:33 +0530
Message-ID: <CA+G9fYs=fdvsYf3OD2kFHFpJfmnBFHnfQLMxRcn-xxRx3eFGmQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/120] 4.19.181-rc1 review
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

On Mon, 15 Mar 2021 at 19:29, <gregkh@linuxfoundation.org> wrote:
>
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> This is the start of the stable review cycle for the 4.19.181 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 17 Mar 2021 13:57:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.181-rc1.gz
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

kernel: 4.19.181-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: a636947af93f0a20fdba2c08ae38b7825ebf9c56
git describe: v4.19.180-121-ga636947af93f
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19=
.y/build/v4.19.180-121-ga636947af93f

No regressions (compared to build v4.19.180)

No fixes (compared to build v4.19.180)

Ran 49481 total tests in the following environments and test suites.

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
- qemu-arm64-clang
- qemu-arm64-kasan
- qemu-x86_64-clang
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
* libhugetlbfs
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
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* perf
* v4l2-compliance
* fwts
* kselftest-intel_pstate
* kselftest-livepatch
* kselftest-net
* kselftest-netfilter
* kselftest-nsfs
* kselftest-ptrace
* kselftest-tc-testing
* ltp-fs-tests
* ltp-sched-tests
* network-basic-tests
* kselftest-
* kselftest-kexec
* kselftest-kvm
* kselftest-vm
* kselftest-x86
* ltp-open-posix-tests
* kvm-unit-tests
* rcutorture
* igt-gpu-tools
* ssuite
* kselftest-vsyscall-mode-native-
* kselftest-vsyscall-mode-none-

--=20
Linaro LKFT
https://lkft.linaro.org
