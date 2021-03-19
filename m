Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33240342684
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 20:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbhCSTx6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 15:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbhCSTx6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Mar 2021 15:53:58 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD559C06175F
        for <stable@vger.kernel.org>; Fri, 19 Mar 2021 12:53:57 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id o19so12156037edc.3
        for <stable@vger.kernel.org>; Fri, 19 Mar 2021 12:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HZ9wljtafTTXPEC/zXLucHFY7bAqroopM+Vt3mSm4So=;
        b=Hmt3jF2XxV8zTfdMVvEEqx/MyxkaGicIxCj/gXh8gNng8dCXVAWv9Zs79xVale5IPQ
         epvFiZW0sGvpxFRYnAKnhumQbnw439N0ZzL6uY1bzx51t75zn7uJHSox6q/x2zVDKamG
         hqZehFuMb1gfiUfJHX2S/lcIJ04kIpJIzrFCl7CFO9zjO/CiPMRDawK11xIQO/m2efuF
         K2uzK6mbQDzGPqweTBOwq7FtTPA6y3jZMi7o2mwvNgdCuc+pDS6nH2cZLx2wRUSnQ/zC
         tjTq1SIWNCg2t/Fd8GKFN3Oe84oiHpn0UO6tprvcRbUzwMsVHJfcNgE+hZnu/rLMWLoK
         L/zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HZ9wljtafTTXPEC/zXLucHFY7bAqroopM+Vt3mSm4So=;
        b=gD6CqxtBhVsprxEEaSMu2hfB/FYmu46QIdR4wtaV3woHeTUN721YqFj7ZqUdEKLHAu
         itaWmlAhwmu5q1xAqeCzn7mXsZyc4ySptl1D6ixrQ2CR9/9DVNpOAhV0p1Pz7RAih9UZ
         g5M1r4BglDY9nwE8JmVVidB08b0qYppQJhSZXKpm35tlfm96aSRWtna62My+bVy0c+kT
         pFkTnsFncbwP/AfJR9kDKFXdMr0VlqiWgdHwNg6ZUj71MYVpT2etLMNbqNmOYWr/ePyD
         AyuR3PdcnAe3N/GK3KXKA2dzC4Go8is9myvPy0/MxpuO/uqVVqFENcxqKpKNPLhJWWBb
         6n5w==
X-Gm-Message-State: AOAM532vMyptNbYuQz2fZEvA96BZpSY0SzUJXtArzS+QbSMSR9dO4VN+
        IgZczSPbbATbRMpiHTPBNFx5tieJjha/VkFFKujPOg==
X-Google-Smtp-Source: ABdhPJzD+/Dp0vDg154AOJlfxOnLf5CDCizwk8Jj2R+YyL2PoZ1B2U40b6MSyBWcLVCrUfPWj1ydLlsBBVINW4UAPVk=
X-Received: by 2002:aa7:dd99:: with SMTP id g25mr11488935edv.230.1616183636302;
 Fri, 19 Mar 2021 12:53:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210319121745.112612545@linuxfoundation.org>
In-Reply-To: <20210319121745.112612545@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 20 Mar 2021 01:23:44 +0530
Message-ID: <CA+G9fYuwhmx-oi2+mdZRNn+3A0HUcR5Yn+6hjLts2u3guJR+_w@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/13] 5.10.25-rc1 review
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

On Fri, 19 Mar 2021 at 17:51, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.25 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 21 Mar 2021 12:17:37 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.25-rc1.gz
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

kernel: 5.10.25-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.10.y
git commit: b05da84e91a81ee89c814d51c18cc6f5b077256a
git describe: v5.10.24-14-gb05da84e91a8
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10=
.y/build/v5.10.24-14-gb05da84e91a8

No regressions (compared to build v5.10.24)

No fixes (compared to build v5.10.24)

Ran 57572 total tests in the following environments and test suites.

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
- parisc
- powerpc
- qemu-arm-clang
- qemu-arm-debug
- qemu-arm64-clang
- qemu-arm64-debug
- qemu-arm64-kasan
- qemu-i386-clang
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
* igt-gpu-tools
* install-android-platform-tools-r2600
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
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
* ltp-containers-tests
* ltp-fs-tests
* ltp-sched-tests
* ltp-tracing-tests
* network-basic-tests
* ltp-controllers-tests
* ltp-open-posix-tests
* kvm-unit-tests
* perf
* v4l2-compliance
* fwts
* kselftest-
* kselftest-lkdtm
* kselftest-rseq
* kselftest-rtc
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sync
* kselftest-sysctl
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
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-zram
* kunit
* kselftest-bpf
* kselftest-intel_pstate
* kselftest-livepatch
* kselftest-net
* kselftest-netfilter
* kselftest-nsfs
* kselftest-ptrace
* kselftest-tc-testing
* kselftest-vm
* kselftest-kexec
* kselftest-x86
* rcutorture
* timesync-off

--=20
Linaro LKFT
https://lkft.linaro.org
