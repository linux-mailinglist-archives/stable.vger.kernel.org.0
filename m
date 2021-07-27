Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD503D70AA
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 09:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235849AbhG0H4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 03:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235829AbhG0H4c (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 03:56:32 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C8F6C061757
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 00:56:31 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id z26so14204675edr.0
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 00:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OvNUT72492UbyZRsDT1/b9P0ONRlNs756QXs0rtMnSY=;
        b=jCk0AWGgtN+g/CaugIAPBVvibSmvxhUMPtLheCin7PhODWuwrbRxRQ0YVB9DsfCKkN
         giHTqIgSNA/hhyh4AtJDVsA6QXO6uC3g6qQvnSyrjqgvEm5ZZ2fSIJr68hKRaaiLLqws
         nqNumAX9rR12dVHyxF3uWe8PkD6hiie5k5oT94GP6HuA52NccYlC9k9xFgZMhytKAcJz
         N9jOmpgo/xm0ZG0dRQizhIad5FwhlmvTcYJJCqQC/AUhbmz7uT60JL8e7VgNkBoJndaL
         +oH6dbFwHI3zFK1vWrP5bftRwfkWr3m7sdwiUnnnfUvpbwXCKNJ4Kjs0oxs1Czb3jw5y
         mvpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OvNUT72492UbyZRsDT1/b9P0ONRlNs756QXs0rtMnSY=;
        b=lLyDDuivGQ+5A3Kg5+1SF86MEX27l9oGs0UYDOaVbnJ6d3Ze7DT5gB+fhwspAo43u3
         uu+75zhy0Js4Urjg+cc6g6hkweGHBg+94ZZcOL48IyLtGJKSUSXxp2VrN2Y4bHeNW1iZ
         BBRcE08CqrzsUYf+eckqmQZoM3gMFMUB6QAQ2/LTnnPi5AO5TQTDddKypw6UuxBaYOw4
         mjaylLziu0qv4Oo+Tht9GPKPZjrV1nB7XzltncyE7he9V2TYNK9w3O53OrXFdJX1cj71
         vksYmuu6I0nhGCHvOpfUxqiTXL3ONxjix6ajEGBv1XpH5NM215IriOaZdMkkVggnGbTw
         vhww==
X-Gm-Message-State: AOAM53259pqPcU1+TXlFQDi7FVKshBwnsvaxS2JeyCqJkUcYv2WGk4E5
        HiUNrwnemaOFrkpuPKkgUUbZq9Brv5iDGIAqUaoaag==
X-Google-Smtp-Source: ABdhPJzbmGyzTFdXSz7dSgREquLIOo0uSsv5Ll/f00iR/6tpugqWo/Aoeqj3G5rijmipAZzrt7u5GNR6m2FMeUxXoBk=
X-Received: by 2002:a05:6402:152:: with SMTP id s18mr25821207edu.221.1627372589423;
 Tue, 27 Jul 2021 00:56:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210726165240.137482144@linuxfoundation.org>
In-Reply-To: <20210726165240.137482144@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 27 Jul 2021 13:26:17 +0530
Message-ID: <CA+G9fYvRpVQDt-5L7R16obSgWTnSLtMjZ5FVA8GcgVeBKx3YWg@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/168] 5.10.54-rc2 review
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

On Tue, 27 Jul 2021 at 10:36, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.54 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 28 Jul 2021 16:52:14 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.54-rc2.gz
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

## Build
* kernel: 5.10.54-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: f52d2bc365d20d8768af7bbd794d9f94ed40f7a7
* git describe: v5.10.53-169-gf52d2bc365d2
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.53-169-gf52d2bc365d2

## Regressions (compared to v5.10.53-168-g53bd37407eed)
No regressions found.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>


## Fixes (compared to v5.10.53-168-g53bd37407eed)
* arc, build
  - gcc-8-axs103_defconfig
  - gcc-8-defconfig
  - gcc-8-vdk_hs38_smp_defconfig
  - gcc-9-axs103_defconfig
  - gcc-9-defconfig
  - gcc-9-vdk_hs38_smp_defconfig

* arm, build
  - clang-10-at91_dt_defconfig
  - clang-10-axm55xx_defconfig
  - clang-10-bcm2835_defconfig
  - clang-10-clps711x_defconfig
  - clang-10-davinci_all_defconfig
  - clang-10-defconfig
  - clang-10-exynos_defconfig
  - clang-10-footbridge_defconfig
  - clang-10-imx_v4_v5_defconfig
  - clang-10-imx_v6_v7_defconfig
  - clang-10-integrator_defconfig
  - clang-10-ixp4xx_defconfig
  - clang-10-keystone_defconfig
  - clang-10-lpc32xx_defconfig
  - clang-10-mini2440_defconfig
  - clang-10-multi_v5_defconfig
  - clang-10-mxs_defconfig
  - clang-10-nhk8815_defconfig
  - clang-10-omap1_defconfig
  - clang-10-omap2plus_defconfig
  - clang-10-orion5x_defconfig
  - clang-10-pxa910_defconfig
  - clang-10-s3c2410_defconfig
  - clang-10-s5pv210_defconfig
  - clang-10-sama5_defconfig
  - clang-10-shmobile_defconfig
  - clang-10-u8500_defconfig
  - clang-10-vexpress_defconfig
  - clang-11-at91_dt_defconfig
  - clang-11-axm55xx_defconfig
  - clang-11-bcm2835_defconfig
  - clang-11-clps711x_defconfig
  - clang-11-davinci_all_defconfig
  - clang-11-defconfig
  - clang-11-exynos_defconfig
  - clang-11-footbridge_defconfig
  - clang-11-imx_v4_v5_defconfig
  - clang-11-imx_v6_v7_defconfig
  - clang-11-integrator_defconfig
  - clang-11-ixp4xx_defconfig
  - clang-11-keystone_defconfig
  - clang-11-lpc32xx_defconfig
  - clang-11-mini2440_defconfig
  - clang-11-multi_v5_defconfig
  - clang-11-mxs_defconfig
  - clang-11-nhk8815_defconfig
  - clang-11-omap1_defconfig
  - clang-11-omap2plus_defconfig
  - clang-11-orion5x_defconfig
  - clang-11-pxa910_defconfig
  - clang-11-s3c2410_defconfig
  - clang-11-s5pv210_defconfig
  - clang-11-sama5_defconfig
  - clang-11-shmobile_defconfig
  - clang-11-u8500_defconfig
  - clang-11-vexpress_defconfig
  - clang-12-at91_dt_defconfig
  - clang-12-axm55xx_defconfig
  - clang-12-bcm2835_defconfig
  - clang-12-clps711x_defconfig
  - clang-12-davinci_all_defconfig
  - clang-12-defconfig
  - clang-12-defconfig-50bba0f5
  - clang-12-exynos_defconfig
  - clang-12-footbridge_defconfig
  - clang-12-imx_v4_v5_defconfig
  - clang-12-imx_v6_v7_defconfig
  - clang-12-integrator_defconfig
  - clang-12-ixp4xx_defconfig
  - clang-12-keystone_defconfig
  - clang-12-lpc32xx_defconfig
  - clang-12-mini2440_defconfig
  - clang-12-multi_v5_defconfig
  - clang-12-mxs_defconfig
  - clang-12-nhk8815_defconfig
  - clang-12-omap1_defconfig
  - clang-12-omap2plus_defconfig
  - clang-12-orion5x_defconfig
  - clang-12-pxa910_defconfig
  - clang-12-s3c2410_defconfig
  - clang-12-s5pv210_defconfig
  - clang-12-sama5_defconfig
  - clang-12-shmobile_defconfig
  - clang-12-u8500_defconfig
  - clang-12-vexpress_defconfig
  - gcc-10-at91_dt_defconfig
  - gcc-10-axm55xx_defconfig
  - gcc-10-bcm2835_defconfig
  - gcc-10-clps711x_defconfig
  - gcc-10-davinci_all_defconfig
  - gcc-10-defconfig
  - gcc-10-exynos_defconfig
  - gcc-10-footbridge_defconfig
  - gcc-10-imx_v4_v5_defconfig
  - gcc-10-imx_v6_v7_defconfig
  - gcc-10-integrator_defconfig
  - gcc-10-ixp4xx_defconfig
  - gcc-10-keystone_defconfig
  - gcc-10-lpc32xx_defconfig
  - gcc-10-mini2440_defconfig
  - gcc-10-multi_v5_defconfig
  - gcc-10-mxs_defconfig
  - gcc-10-nhk8815_defconfig
  - gcc-10-omap1_defconfig
  - gcc-10-omap2plus_defconfig
  - gcc-10-orion5x_defconfig
  - gcc-10-pxa910_defconfig
  - gcc-10-s3c2410_defconfig
  - gcc-10-s5pv210_defconfig
  - gcc-10-sama5_defconfig
  - gcc-10-shmobile_defconfig
  - gcc-10-u8500_defconfig
  - gcc-10-vexpress_defconfig
  - gcc-11-defconfig-493f0879
  - gcc-11-defconfig-50bba0f5
  - gcc-11-defconfig-5a3a4204
  - gcc-11-defconfig-883c3502
  - gcc-11-defconfig-a05dd807
  - gcc-11-defconfig-c58d92d2
  - gcc-8-at91_dt_defconfig
  - gcc-8-axm55xx_defconfig
  - gcc-8-bcm2835_defconfig
  - gcc-8-clps711x_defconfig
  - gcc-8-davinci_all_defconfig
  - gcc-8-defconfig
  - gcc-8-exynos_defconfig
  - gcc-8-footbridge_defconfig
  - gcc-8-imx_v4_v5_defconfig
  - gcc-8-imx_v6_v7_defconfig
  - gcc-8-integrator_defconfig
  - gcc-8-ixp4xx_defconfig
  - gcc-8-keystone_defconfig
  - gcc-8-lpc32xx_defconfig
  - gcc-8-mini2440_defconfig
  - gcc-8-multi_v5_defconfig
  - gcc-8-mxs_defconfig
  - gcc-8-nhk8815_defconfig
  - gcc-8-omap1_defconfig
  - gcc-8-omap2plus_defconfig
  - gcc-8-orion5x_defconfig
  - gcc-8-pxa910_defconfig
  - gcc-8-s3c2410_defconfig
  - gcc-8-s5pv210_defconfig
  - gcc-8-sama5_defconfig
  - gcc-8-shmobile_defconfig
  - gcc-8-u8500_defconfig
  - gcc-8-vexpress_defconfig
  - gcc-9-at91_dt_defconfig
  - gcc-9-axm55xx_defconfig
  - gcc-9-bcm2835_defconfig
  - gcc-9-clps711x_defconfig
  - gcc-9-davinci_all_defconfig
  - gcc-9-defconfig
  - gcc-9-exynos_defconfig
  - gcc-9-footbridge_defconfig
  - gcc-9-imx_v4_v5_defconfig
  - gcc-9-imx_v6_v7_defconfig
  - gcc-9-integrator_defconfig
  - gcc-9-ixp4xx_defconfig
  - gcc-9-keystone_defconfig
  - gcc-9-lpc32xx_defconfig
  - gcc-9-mini2440_defconfig
  - gcc-9-multi_v5_defconfig
  - gcc-9-mxs_defconfig
  - gcc-9-nhk8815_defconfig
  - gcc-9-omap1_defconfig
  - gcc-9-omap2plus_defconfig
  - gcc-9-orion5x_defconfig
  - gcc-9-pxa910_defconfig
  - gcc-9-s3c2410_defconfig
  - gcc-9-s5pv210_defconfig
  - gcc-9-sama5_defconfig
  - gcc-9-shmobile_defconfig
  - gcc-9-u8500_defconfig
  - gcc-9-vexpress_defconfig

* arm64, build
  - clang-10-defconfig
  - clang-11-defconfig
  - clang-12-defconfig
  - clang-12-defconfig-5b09568e
  - gcc-10-defconfig
  - gcc-11-defconfig-389abf09
  - gcc-11-defconfig-59041e85
  - gcc-11-defconfig-5b09568e
  - gcc-11-defconfig-5e73d44a
  - gcc-11-defconfig-904271f2
  - gcc-11-defconfig-bcbd88e2
  - gcc-11-defconfig-eec653ad
  - gcc-11-defconfig-fac1da4b
  - gcc-8-defconfig
  - gcc-9-defconfig

* dragonboard-410c, build
  - build_process

* hi6220-hikey, build
  - build_process

* i386, build
  - build_process
  - clang-10-defconfig
  - clang-11-defconfig
  - clang-12-defconfig
  - clang-12-defconfig-b9979cfa
  - gcc-10-defconfig
  - gcc-11-defconfig-9cda1611
  - gcc-11-defconfig-b9979cfa
  - gcc-11-defconfig-bb946595
  - gcc-11-defconfig-cee60f56
  - gcc-11-defconfig-e3753fbe
  - gcc-11-defconfig-ec3ad359
  - gcc-8-i386_defconfig
  - gcc-9-i386_defconfig

* juno-r2, build
  - build_process

* mips, build
  - clang-10-defconfig
  - clang-11-defconfig
  - clang-12-defconfig
  - gcc-10-ar7_defconfig
  - gcc-10-ath79_defconfig
  - gcc-10-bcm47xx_defconfig
  - gcc-10-bcm63xx_defconfig
  - gcc-10-cavium_octeon_defconfig
  - gcc-10-defconfig
  - gcc-10-malta_defconfig
  - gcc-10-nlm_xlp_defconfig
  - gcc-10-rt305x_defconfig
  - gcc-8-ar7_defconfig
  - gcc-8-ath79_defconfig
  - gcc-8-bcm47xx_defconfig
  - gcc-8-bcm63xx_defconfig
  - gcc-8-cavium_octeon_defconfig
  - gcc-8-defconfig
  - gcc-8-malta_defconfig
  - gcc-8-nlm_xlp_defconfig
  - gcc-8-rt305x_defconfig
  - gcc-9-ar7_defconfig
  - gcc-9-ath79_defconfig
  - gcc-9-bcm47xx_defconfig
  - gcc-9-bcm63xx_defconfig
  - gcc-9-cavium_octeon_defconfig
  - gcc-9-defconfig
  - gcc-9-malta_defconfig
  - gcc-9-nlm_xlp_defconfig
  - gcc-9-rt305x_defconfig

* parisc, build
  - gcc-10-defconfig
  - gcc-8-defconfig
  - gcc-9-defconfig

* powerpc, build
  - gcc-10-cell_defconfig
  - gcc-10-defconfig
  - gcc-10-maple_defconfig
  - gcc-10-mpc83xx_defconfig
  - gcc-10-ppc64e_defconfig
  - gcc-10-ppc6xx_defconfig
  - gcc-10-tqm8xx_defconfig
  - gcc-8-cell_defconfig
  - gcc-8-defconfig
  - gcc-8-maple_defconfig
  - gcc-8-mpc83xx_defconfig
  - gcc-8-ppc64e_defconfig
  - gcc-8-ppc6xx_defconfig
  - gcc-8-tqm8xx_defconfig
  - gcc-9-cell_defconfig
  - gcc-9-defconfig
  - gcc-9-maple_defconfig
  - gcc-9-mpc83xx_defconfig
  - gcc-9-ppc64e_defconfig
  - gcc-9-ppc6xx_defconfig
  - gcc-9-tqm8xx_defconfig

* riscv, build
  - clang-10-defconfig
  - clang-11-defconfig
  - clang-12-defconfig
  - gcc-10-defconfig
  - gcc-8-defconfig
  - gcc-9-defconfig

* s390, build
  - clang-10-defconfig
  - clang-11-defconfig
  - clang-12-defconfig
  - gcc-10-defconfig
  - gcc-8-defconfig
  - gcc-9-defconfig

* sh, build
  - gcc-10-defconfig
  - gcc-10-dreamcast_defconfig
  - gcc-10-microdev_defconfig
  - gcc-10-shx3_defconfig
  - gcc-8-defconfig
  - gcc-8-dreamcast_defconfig
  - gcc-8-microdev_defconfig
  - gcc-8-shx3_defconfig
  - gcc-9-defconfig
  - gcc-9-dreamcast_defconfig
  - gcc-9-microdev_defconfig
  - gcc-9-shx3_defconfig

* sparc, build
  - gcc-10-defconfig
  - gcc-8-defconfig
  - gcc-9-defconfig

* x15, build
  - build_process

* x86, build
  - build_process

* x86_64, build
  - clang-10-defconfig
  - clang-11-x86_64_defconfig
  - clang-12-defconfig-61adc17b
  - clang-12-defconfig-b9979cfa
  - clang-12-x86_64_defconfig
  - gcc-10-defconfig
  - gcc-11-defconfig-9cda1611
  - gcc-11-defconfig-b9979cfa
  - gcc-11-defconfig-bb946595
  - gcc-11-defconfig-cee60f56
  - gcc-11-defconfig-e3753fbe
  - gcc-11-defconfig-ec3ad359
  - gcc-11-defconfig-fb5e7dc8
  - gcc-8-x86_64_defconfig
  - gcc-9-x86_64_defconfig


## Test result summary
 total: 82005, pass: 67588, fail: 1837, skip: 11337, xfail: 1243,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 193 total, 193 passed, 0 failed
* arm64: 27 total, 27 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 26 total, 26 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 21 total, 21 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 27 total, 27 passed, 0 failed

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
* kselftest-vsyscall-mode-native-
* kselftest-vsyscall-mode-none-
* kselftest-x86
* kselftest-zram
* kunit
* kvm-unit-tests
* libgpiod
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-cap_bounds[
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
