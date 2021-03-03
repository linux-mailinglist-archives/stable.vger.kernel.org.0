Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA5832C821
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 02:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355790AbhCDAeZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 19:34:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235502AbhCCQFY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 11:05:24 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF30C061763
        for <stable@vger.kernel.org>; Wed,  3 Mar 2021 08:04:24 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id hs11so43227962ejc.1
        for <stable@vger.kernel.org>; Wed, 03 Mar 2021 08:04:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7P0ECFZga2jYSTUEc3GMITFYDojAwdE2hu69blx60ww=;
        b=yVju7jS7vwVsKV4nJ/Ko5mkNmoj8hqBrkrrHgQbqu7drXUYEvag3eUF2cKl057MMhk
         OEPVQIKeB7oiuGOnxWUGXCAWqcrlhJpCq7HEBswiMfQhJu2fafS7QfL8WEz9IlhSCXXA
         w2ZJKkdHObTk3e4VjzcYNiBkiipbLsP1k2D9RSNc0TrQU1K0ZrasAFRYYkg3/TrlrxyQ
         dBZHyuJ/OuhYd9XYFZqH7q0HYh67p1aEIzmiOrstetbnWwuIS5xxhrNU76iMPezhI2VJ
         lUiOPEZyD48bh+CPHw5tdespOmcsUyMGtSYtWCQxMOjEvLLKATbxpQhDFFFxzN0xt4uA
         9sAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7P0ECFZga2jYSTUEc3GMITFYDojAwdE2hu69blx60ww=;
        b=Tq3oW3SLXuA0b9Tv5+EvaOsXEpJ3Dp1Uw2pAeuRkbI8FhAvDdfTX/BmB8WVEkOF9Ip
         p4MYguUymVPtWVABdDtVA3T065L+vrzusuwJRmr6ZlBe6fz+Ti07K7bEQzf8s7CDAsw9
         dZFX8HKdjTBM6TjzFb1e5j6B6fKbmhFEfUAPORkWiYg4gHrjQKhuH0pjK5modYcqcSYO
         +5nYV5zAMv3yI2RNS1e/fQZPZ/irnezm5eGxi3nqbQ7xGbp9JRApeYoYCgIN5+nfBvBg
         ccSq43WOai2GjsvYrJzyPrf8r0nSK8Q34omfl3Ue2JEjFarvkjJxPcEJw8VSD0oyHw43
         c8XA==
X-Gm-Message-State: AOAM532O6GgptJFp+lJ6DY14JRa1In8+pV6tc29wvs7eNQ8cx9Vv5Y37
        CIyGuKpdsIcLcnmpc7w7UGRIKd0Yo0Fk/Rt4V1iidQ==
X-Google-Smtp-Source: ABdhPJyUtorPel/psTZMby0goZ+Bbacuj0Kuq/XCptCEOmO8twBG2TA4+W+VV/WVcljLv1N3BtKhOOXZAeh9EumnyDI=
X-Received: by 2002:a17:906:444d:: with SMTP id i13mr25657181ejp.170.1614787462825;
 Wed, 03 Mar 2021 08:04:22 -0800 (PST)
MIME-Version: 1.0
References: <20210302192532.615945247@linuxfoundation.org>
In-Reply-To: <20210302192532.615945247@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 3 Mar 2021 21:34:10 +0530
Message-ID: <CA+G9fYs0hGL4KO6L-hVtpNw+41S=prNSaYUWUitbKGghXmXDNQ@mail.gmail.com>
Subject: Re: [PATCH 4.9 000/134] 4.9.259-rc3 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
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

On Wed, 3 Mar 2021 at 00:58, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.259 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 04 Mar 2021 19:25:07 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.259-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 4.9.259-rc3
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: 90d5aacad5cf640a69a965432687787f5ad7a949
git describe: v4.9.258-135-g90d5aacad5cf
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.=
y/build/v4.9.258-135-g90d5aacad5cf

No regressions (compared to build v4.9.258-rc1)

No fixes (compared to build v4.9.258-rc1)

Ran 39097 total tests in the following environments and test suites.

Environments
--------------
- arm
- arm64
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-64k_page_size
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- mips
- qemu-arm64-kasan
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
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
* kselftest-lib
* kselftest-livepatch
* kselftest-lkdtm
* kselftest-membarrier
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sysctl
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-zram
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
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* perf
* v4l2-compliance
* fwts
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-firmware
* kselftest-fpu
* kselftest-futex
* kselftest-gpio
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* libhugetlbfs
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-mm-tests
* network-basic-tests
* kvm-unit-tests
* ltp-open-posix-tests
* kselftest-vm
* kselftest-kexec
* kselftest-x86

--
Linaro LKFT
https://lkft.linaro.org
