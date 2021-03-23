Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C622B345EDB
	for <lists+stable@lfdr.de>; Tue, 23 Mar 2021 14:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbhCWNCG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Mar 2021 09:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231368AbhCWNBp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Mar 2021 09:01:45 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A43C061574
        for <stable@vger.kernel.org>; Tue, 23 Mar 2021 06:01:44 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id h13so23341229eds.5
        for <stable@vger.kernel.org>; Tue, 23 Mar 2021 06:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MDQVPB21tbAD+n2q1O5yJ4gJubTla3FGUSr+CGpgj6w=;
        b=dwaVwfAgM4ORcTJhzIAFcNzjVkd5PvciuGWgrX9asoe35dBfgknLvmUSabF6fFs1MH
         HbFQ2TtKuc4T5R8fe5ImO+OxjNJlFzGlmaK8rfzDuTU/9KibrF1OxYI5WFK+v7+oFXY0
         vcY5Aiohz3w/aaHnEJyPpoc2+kNsHSOeGgLYMB+M3OKfyEwEGp2gmv+Y5qzsmUASgEG8
         GS2OBD6t08s+AZF7ot1tIDe+RAlmLfMjPxfq4wPyLKarCMsJaO6fyjh4GGfMo4eHHEBq
         6hBtMk8HRnvVAfCdvo1vTmFGz7qQZyQBQIFBpSy7lcrYIdHIQlX2A5MZS1CFy6rjQMsP
         Gd2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MDQVPB21tbAD+n2q1O5yJ4gJubTla3FGUSr+CGpgj6w=;
        b=BFYbEZp6NW9atz8Jh0F+3VXcahg3upN/odz8HVIGJfsKR3wsMPJO1aSdm2HjDFp4b2
         36J2eju5/4tlXh2TJXvB3UbJ9FuiFA4/82aNSh+1tRE+MXmDR3EXBk7j3dF26bHuTEVA
         9UMYfHqKxnLORWDEI5EeeZ6u5vIaXdgw4IUYvl6dj50Hhm2FO22YD9IBF/924EPTPLYD
         jfuvnI5sqR2+wrOev65ipHtP5BU35j5Pws0sUBTMKz3EuHKULQGA4w0XGiOaRKl9tgNY
         OfCG1EFHlrHEZ9V3O973y5s17d3Ycb7AYNp8XkuzREzGl8ABvm9g87uWktwPYYysliS5
         3+0w==
X-Gm-Message-State: AOAM532gYE58dcNuyItpQyZjDDlxEc63iKf8wiFcGgfLPDs4kPiPuikl
        l3YzAkJFyV6s0EPx9LvO4YNCHAdekzSUbfITzWT86Q==
X-Google-Smtp-Source: ABdhPJyKTHEROJ36eIaIQ3TA3wPl+y5GwPTbxulu8xa6hXgVrfEGHsEJ06nc6QCmFCoduFWdtbj40jSBmyWaD9Xpa+w=
X-Received: by 2002:aa7:dd99:: with SMTP id g25mr4446576edv.230.1616504502772;
 Tue, 23 Mar 2021 06:01:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210322121920.053255560@linuxfoundation.org>
In-Reply-To: <20210322121920.053255560@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 23 Mar 2021 18:31:29 +0530
Message-ID: <CA+G9fYvAyyRUD6Axjn-iYoCydwi+GnBPfFKVSz64dwfWF587Ww@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/43] 4.14.227-rc1 review
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

On Mon, 22 Mar 2021 at 18:29, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.227 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 24 Mar 2021 12:19:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.227-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
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

kernel: 4.14.227-rc1
git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc=
.git
git branch: linux-4.14.y
git commit: dbfdb55a0970570a02a8d7bb6abc2e4db71218c8
git describe: v4.14.226-44-gdbfdb55a0970
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14=
.y/build/v4.14.226-44-gdbfdb55a0970

No regressions (compared to v4.14.226-8-g085047cda613)

No fixes (compared to v4.14.226-8-g085047cda613)

Ran 48680 total tests in the following environments and test suites.

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
* kselftest-bpf
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
* ltp-sched-tests
* ltp-securebits-tests
* ltp-tracing-tests
* v4l2-compliance
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
* kvm-unit-tests
* ltp-fs-tests
* network-basic-tests
* perf
* kselftest-kexec
* kselftest-vm
* kselftest-x86
* ltp-open-posix-tests
* ltp-syscalls-tests
* fwts
* rcutorture
* igt-gpu-tools
* ssuite
* kselftest-vsyscall-mode-native-
* kselftest-vsyscall-mode-none-

--=20
Linaro LKFT
https://lkft.linaro.org
