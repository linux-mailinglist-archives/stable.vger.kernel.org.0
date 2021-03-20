Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65C0B342BAC
	for <lists+stable@lfdr.de>; Sat, 20 Mar 2021 12:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhCTLMa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Mar 2021 07:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbhCTLML (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Mar 2021 07:12:11 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41400C061A2D
        for <stable@vger.kernel.org>; Sat, 20 Mar 2021 03:55:46 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a7so13628883ejs.3
        for <stable@vger.kernel.org>; Sat, 20 Mar 2021 03:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1O6lTI+J/EyzpIOMw8N5voY20M2dP/M6U6yDczttxis=;
        b=LnpPoHx3Cn5ygXQoqDfZ7/e2+ym9yHg2/ISTsWsWSt2Mu5CT7EV6QA+p33CeDjC5Ig
         nCSRqjmLhhd5dTIxTBpILeEtbjf93niaRiMJVIGMlmacq15KXPJ7EuwgfE1Mcfo93ixk
         pUFCMpozWBhrr4EWqwbwaOicE6pUe9YmuM9sXCCRjLWhKsF4loxOar1VFsMCW8U1180P
         KEOx+gY/7v9PvO/j0z+YFhrUB9/rC/AuPR0dzScaE2LWsJASOd+RZ6vu3oWcH1kj3lqw
         zfGJ7pD3uBBd7XxtNEkVLJ5IkKAQM8nCXPS4AaQe8MtkPLr2Ofvd1F4C35QPUttG0LVI
         n1Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1O6lTI+J/EyzpIOMw8N5voY20M2dP/M6U6yDczttxis=;
        b=NAWX7EAlvgGQlXrMueO/HnzWPeLSPUlU4P8eMkdxhWmYP3Xzh4/ekL9o80l9e7Y/D7
         dKpehpl8vU6WXy4VfpaLCUz+4VVoDm0hyF3YvQI8ad17Ouk49Lhgllvyq2c8n+BE1GrP
         b8suoH4MNXFE5WHn1NCfBJpK7Wepz+5t3lg4OYAPPfnYJ9DuQZ2Mo2UaAa1pa3kKz9Qr
         Zh/E1iRG3tuKeCQxwXk60ZOmZ4JVYOSdMWi0B352rKRYlaVo6+ZwJh5NPP4eXocNEF4X
         BAymmiimv4QZrnORbslphGyDE8bExqO6Ek8+8BQ4jubU7DT5y/g4SEGo4mn+9X8OfnTN
         LoEA==
X-Gm-Message-State: AOAM53046qIT5/hSpDpXlcQQhGfG+csLSbBNL3z13S+YxkY4zvp762Zy
        hE6XByUYADSRcAvHVpAoeo7aVjfENdXLi6GGkDsMKgdXz48d//gB
X-Google-Smtp-Source: ABdhPJz70unVWa/fJkjUFWWa5fln+Y7TLMaWUKFebEX6ZJTOU8oRXVEfn0b/hxSKGuSUCeCFGsmPrrSzIdIZVwpO1KM=
X-Received: by 2002:aa7:dd99:: with SMTP id g25mr14183996edv.230.1616227769717;
 Sat, 20 Mar 2021 01:09:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210319121745.449875976@linuxfoundation.org>
In-Reply-To: <20210319121745.449875976@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 20 Mar 2021 13:39:18 +0530
Message-ID: <CA+G9fYtksFDeohBt8QP-kisxew5niRF3YxYpJ5G-bU=Z5z6kjA@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/18] 5.4.107-rc1 review
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

On Fri, 19 Mar 2021 at 17:49, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.107 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 21 Mar 2021 12:17:37 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.107-rc1.gz
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

kernel: 5.4.107-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 8a800acdf26f05d289c05e416591b6b18917b044
git describe: v5.4.106-19-g8a800acdf26f
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.=
y/build/v5.4.106-19-g8a800acdf26f

No regressions (compared to build v5.4.106)

No fixes (compared to build v5.4.106)


Ran 62773 total tests in the following environments and test suites.

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
- qemu-arm-debug
- qemu-arm64-clang
- qemu-arm64-debug
- qemu-arm64-kasan
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
* kselftest-
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
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* perf
* kselftest-lkdtm
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* network-basic-tests
* kselftest-kexec
* kselftest-vm
* kselftest-x86
* ltp-open-posix-tests
* v4l2-compliance
* kvm-unit-tests
* fwts
* rcutorture
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
