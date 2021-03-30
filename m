Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB54D34E18A
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 08:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbhC3Gwf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 02:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbhC3GwV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Mar 2021 02:52:21 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE481C061764
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 23:52:20 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id x21so16891048eds.4
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 23:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WPlavxZjx/CyaIqXYJqYgJcpIj73IOHsePZspM3MA+w=;
        b=g95hRnCcekZQvzrjQ01I2gsQEe3rHCooMbaObjIIoXVvpmWxdSOUKcIxL/5GMKsdvU
         HBZVQZ6upe+pTZE2rsUr+6Tz09JGlLDPeS3azrBIN9Pgt9Hr99FjT3D7bMZpFutg0HWY
         dQX74wJ019zVGEpdZBfAFUKBiUQWSCuzHKPURdZbm+ScLUzQPDxcHKk1y6cOaRX+p74L
         h12HRVu8qiKsykshn2CA/7/TZqJpZT5dxXjXEmrDEz4eVxFPZB5ctnbgwdQDmRJE6GDs
         0MOzHHCUne7j1aGrE9wuGnMvER3z0yM+2pTImH5y2c6NxzLeOVxw385lGfWk/33r01Op
         YRAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WPlavxZjx/CyaIqXYJqYgJcpIj73IOHsePZspM3MA+w=;
        b=S5fmsv5WBED0zQMWnfeFKookdOU8GEj8+G5XkiTbp2DzTjo0S1bRmJL3ElpkUNXzjZ
         D30ipS0/hokVnzYRcSha36fE7vOYF44RqtVSWM71q8S0rXT3HsCPUNH95KJjGvTj94Kb
         +1/t2MKOjzAPcucmpA2TjFsCLgT19xhf8/WeZIBVlukYe2GTO4xKxpOrA91wR7AelGQg
         JMQ7oT8EftPtcoOh3zD7RnZUljG8jtTAMxbz8aR8PPRLV0HeJWFcOIVGQQhRpF/2nHTk
         OXfyQ/s8E2ry1rpWQlKB2bZs9/1N4ZjbOyP/brwAB0XlBkVXC2h9V8CY0cAQG+ik54P9
         rGlA==
X-Gm-Message-State: AOAM531F07V2Uc8RSm8eH6eQUrs0zszwZ5E/NcJ5nnZseml8vm1YgIED
        G6TteqrGpLZojaAdZFlfCsbyByAgCTP0UOfl1gT53w==
X-Google-Smtp-Source: ABdhPJwR6UYcq49jWqG8rRJ37y+CmMERl2g2zWlLK5kdjYcTq2RwRbGmIBeaX2P9qU8oyENDAZNWx+FhDVGhgcamoCA=
X-Received: by 2002:a05:6402:13ce:: with SMTP id a14mr32215276edx.365.1617087139272;
 Mon, 29 Mar 2021 23:52:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210329075610.300795746@linuxfoundation.org>
In-Reply-To: <20210329075610.300795746@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 30 Mar 2021 12:22:07 +0530
Message-ID: <CA+G9fYukKdQWRwXPC2V-9FvF8vgZbbvC0qGpBbRkix4WLUxMOw@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/72] 4.19.184-rc1 review
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

On Mon, 29 Mar 2021 at 13:40, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.184 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 31 Mar 2021 07:55:56 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.184-rc1.gz
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

kernel: 4.19.184-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: bbd08292bae4049381e5537588ba9f581456c4d5
git describe: v4.19.183-73-gbbd08292bae4
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19=
.y/build/v4.19.183-73-gbbd08292bae4

No regressions (compared to build v4.19.183)

No fixes (compared to build v4.19.183)

Ran 57059 total tests in the following environments and test suites.

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
* igt-gpu-tools
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
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kvm
* kselftest-lib
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
* kselftest-tc-testing
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* perf
* v4l2-compliance
* fwts
* kselftest-bpf
* kselftest-intel_pstate
* kselftest-livepatch
* kselftest-lkdtm
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
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-zram
* ltp-fs-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-tracing-tests
* network-basic-tests
* kselftest-kexec
* kselftest-vm
* kselftest-x86
* ltp-cve-tests
* ltp-dio-tests
* ltp-open-posix-tests
* kvm-unit-tests
* rcutorture
* ssuite
* kselftest-vsyscall-mode-native-
* kselftest-vsyscall-mode-none-

--=20
Linaro LKFT
https://lkft.linaro.org
