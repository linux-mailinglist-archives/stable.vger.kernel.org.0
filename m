Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1803D701E
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 09:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235675AbhG0HP1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 03:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235629AbhG0HP0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 03:15:26 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D418C061760
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 00:15:27 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id y12so5980133edo.6
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 00:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IX2aZ2UCtzwQVhm7u4V1RxOAzJXY4Toz/5A5epH0fik=;
        b=Oj/V6CIcEas+nbgCQlRJl4yCGaWlGE0xQnncVPyfuODuxWLoFDpI0CGbHs12zemSOF
         UPDQB23f2DtGdf/XISzVCvvVS+B4ITTyJ2oEVe85OewYEQEnCb6IeiUrmpLNpEbcbXzi
         2C+HOa62/HnqUVQLKtJUEGOUT6PFKEWdyrfCdJgj8XqPORNW3zX41JyUkshrqf2B5E4M
         ygPk/9TeOj9Ywiriq0JPRChy2Vje4thdq8V7r75o1IPPCsmj6DnIrBRGWFv2Z+JzEca+
         s8MpQ4cgKm6NUFdpP4yQmznNfQ7rdXH7s7ArMS5zv7KPOqzZeNS7uvOGqY8nUajtvCGA
         kShA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IX2aZ2UCtzwQVhm7u4V1RxOAzJXY4Toz/5A5epH0fik=;
        b=gjdZw0h4oR/bqx5FxqS/HL25GzjAWDyiDsvHKrxvtCfwluvVOHiQixbPCzMW823OhH
         sTiSKEtSvmkxVzSLEfpEDebSxMMW5TqtL71JvIYzmU4OAy08othjfZ73KOlnLCfpl7Te
         CJH7Pdt0eUUkMuLq5IKoCF8anwM6ztAaWwuVFBD3lH5ZCnWFfIOq/jOYMD6oR4KDTQQi
         lLIAVH7WMVtWx4bZSPu2D0ev2MeI9wJeETcPtgYvSGeo94nOT3ZGUPes3bESSUL1J1np
         gAI5z9HcjI8GtbNsPHUraA6gtzGr3ab4T+xgestcAdib1VYkUn/90Ukv3vbmo8wJg9Qg
         lkzA==
X-Gm-Message-State: AOAM532UFYopVWy5lbd9Q9iDhXXX+Oc4Lx58uvPw2pwLD5BIJJtYGXlY
        AxPBW0jkz00nUyRLC3mxRV0m8bmId4vTeXdr3sHHCzQkJih5M3nx
X-Google-Smtp-Source: ABdhPJxt0GhHCrfAjZ5rOaUuIRbbeZ7eTU3fTihU8W77qEBqlxDCzSt9bD3zUtWm/whxTFFpf/CvYAaHe/ZHX4Qcfys=
X-Received: by 2002:a05:6402:4386:: with SMTP id o6mr25883782edc.239.1627370125438;
 Tue, 27 Jul 2021 00:15:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210726165238.919699741@linuxfoundation.org>
In-Reply-To: <20210726165238.919699741@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 27 Jul 2021 12:45:14 +0530
Message-ID: <CA+G9fYvg+KvgTuJ6f=bcudiO1hhHtDf3Y5qWFENRL2ygS1d35g@mail.gmail.com>
Subject: Re: [PATCH 5.13 000/224] 5.13.6-rc2 review
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
> This is the start of the stable review cycle for the 5.13.6 release.
> There are 224 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 28 Jul 2021 16:52:07 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.13.6-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.13.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.13.6-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.13.y
* git commit: 692072e7b7faec65eef9b9fc79b980bd23745b50
* git describe: v5.13.5-225-g692072e7b7fa
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.13.y/build/v5.13=
.5-225-g692072e7b7fa

## Regressions (compared to v5.13.5-224-gda3a182166a4)
No regressions found.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>


## Fixes (compared to v5.13.5-224-gda3a182166a4)
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
 total: 84433, pass: 69154, fail: 2102, skip: 12002, xfail: 1175,

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
* x15: 1 total, 0 passed, 1 failed
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
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-f[
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
* timesync-off
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
