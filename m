Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50F5234D686
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 20:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbhC2SCR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 14:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231388AbhC2SCE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 14:02:04 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9784AC061756
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 11:02:03 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id u9so20827423ejj.7
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 11:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=e8KNXf14WU5er2UKIj8pqaMgzclV9pM6uKswGnOq0GI=;
        b=YcYo7bu9r336af+ZihUai2NR1FN7E19CljmfOG7Ut4FbEZBRPLPSfmFx9cjry9N4Y4
         8I4Gd50bIqBTW4GBPyi3KKU8TWobDmMkORH9Pm2VSwgarDb4m5s8ZWbIeP0HKmE1QfFZ
         TFMEOx7iDIoULS14gOtTG7EOrYKRIQXl4IZkB6s81C2P0QE9WSGAFtGIibk74MKTWn63
         E/xJ2uxzbUjTdbzrT+/oZVDLpMVXsiUTzfWnnSN3Cq8albtvx6hzu0oCwcDi+aHfXZlN
         RBqU3YqLm0LYdSpJ056SGGYdNfO3m8xJhEOy/JWPJuDvi2BM6WHecxGLtdzXLqbvNXcJ
         HVRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=e8KNXf14WU5er2UKIj8pqaMgzclV9pM6uKswGnOq0GI=;
        b=IaUgVeYlsumuyY0QT8BwQdndahiZWY1DPArwpBxuOWMV8MurMY1D5Dn4Kx2RbaNg+W
         b0dCllVVQdy/HBIq6xh0WGXBXfuMUcLrq58OBr1K3wlFu3zgJiw9iTil/FX5oiF+pHsp
         vef82+QHJCUWIxiRjjjogor5//75mTHCjMEApuVFd2zcoo0PjF1QpX7+Y+2PmHGwyjoY
         /upB4bhy4Fn6x21XRi0HCyswPAzD4BLEB6/8EKfwMkdnnB8M9R8dOgXyAMMJvkzMAdSK
         /xCjgAtj9XR6ZznMuuVdXDseQgR3s6zz8ab9naX7ScUXI/rp+t6/KN4x1Hd8xPMU+7un
         cUBg==
X-Gm-Message-State: AOAM530HABYZoaocGByepv476ZFudUJGhJMxKcsg305s7XTGASB46ksZ
        eXjpSpLVPzph0/w9i9EiKl5nie3lbOIWQvKWq7OCcA==
X-Google-Smtp-Source: ABdhPJyWq+ZomiWSDl0ybZKapPb4tWS2qbLi9TxNv1TkUpgXj0wjt9dprwRxjCcvoKbRR01exYOKHFlM5KlT0qJdTrY=
X-Received: by 2002:a17:907:7785:: with SMTP id ky5mr28846636ejc.133.1617040922119;
 Mon, 29 Mar 2021 11:02:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210329101343.082590961@linuxfoundation.org>
In-Reply-To: <20210329101343.082590961@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 29 Mar 2021 23:31:50 +0530
Message-ID: <CA+G9fYsGM7g=W9P4GN=VbmpQpV6dez6SdTqoF969A-+14j3xyg@mail.gmail.com>
Subject: Re: [PATCH 5.11 000/252] 5.11.11-rc2 review
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

On Mon, 29 Mar 2021 at 15:45, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.11.11 release.
> There are 252 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 31 Mar 2021 10:13:07 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.11.11-rc2.gz
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

kernel: 5.11.11-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.11.y
git commit: f288f3edc68844bc15b54723fe2c7a50c24f5da6
git describe: v5.11.10-253-gf288f3edc688
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.11=
.y/build/v5.11.10-253-gf288f3edc688

No regressions (compared to build v5.11.9-3-g7ab86fca27ce)

No fixes (compared to build v5.11.9-3-g7ab86fca27ce)


Ran 66219 total tests in the following environments and test suites.

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
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-lkdtm
* kselftest-net
* kselftest-netfilter
* kselftest-nsfs
* kselftest-tc-testing
* ltp-commands-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* fwts
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-ipc-tests
* ltp-syscalls-tests
* network-basic-tests
* perf
* kselftest-intel_pstate
* kselftest-kexec
* kselftest-kvm
* kselftest-lib
* kselftest-livepatch
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
* kselftest-vm
* kselftest-x86
* kselftest-zram
* ltp-containers-tests
* ltp-controllers-tests
* ltp-open-posix-tests
* ltp-tracing-tests
* kvm-unit-tests
* v4l2-compliance
* rcutorture
* kunit
* igt-gpu-tools
* kselftest-vsyscall-mode-native-
* kselftest-vsyscall-mode-none-
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
