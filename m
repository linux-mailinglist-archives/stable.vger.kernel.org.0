Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2651B37F821
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 14:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232344AbhEMMsw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 08:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbhEMMst (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 08:48:49 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B453C061574
        for <stable@vger.kernel.org>; Thu, 13 May 2021 05:47:38 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id w3so39699889ejc.4
        for <stable@vger.kernel.org>; Thu, 13 May 2021 05:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0Vqwnb3HW4wJhL2DdPMyNO6LUb0kC2UBgW7LGw4Exzk=;
        b=kuiZzV3YowzlkLotjIqt5NigyH/HsLv02c28eTSWyHC8NOrZk4Cy9wJO/vT6MvrncJ
         3rE9nyYGKnNv00L6AGVTEzGRSIaycd9f9LAVcxTJjqfaSp76acBtASo/UzaiJxdAEpWj
         Ez/xpKFMknz4SooBx+Qb6GS88CAQFCPatv8MEcOf5kagfvqfXreuMdaWmbJnIbN43pqs
         2njVb7EdHA/pI6O26X34mD826i9JRz/wK2iQV1ffBmsPOrlngijMb9Juoly7S4n4OyoT
         unIOALc8X4sYj5iXBt/GXlnxbD9dks494xhovW5PpmQiJbYKYKSpLVvrD78U6VMp2LGm
         a2jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0Vqwnb3HW4wJhL2DdPMyNO6LUb0kC2UBgW7LGw4Exzk=;
        b=hXkr0PoSsZdqlmGwgHWFetHnL+Or2PgouysosOyr/g/xB5SmWt7V+y3d9H5zNnP3RG
         x7jLfBRWa2StFp+Xt9FdRHEa2ubR7fD0V8ZNREFB3cdiLJiNLs1q/r2lKrEa6y32Ujb4
         4JlqFMYFxpM7jmFTNQSLW+X2OziX7Ls5ZS5++SyEpWQm1dEPYslD5EDKUi+qeh7raduz
         ecnNtFpzv4MqTBCMc022/H9JPSjZ+1YpP/k0nGsWOG82r3bW3ESC2yBRqPfby9pJvOPe
         0Y5IrQ4qJoaP7AcFQVzQmSBpZ8DZQAA64AizWBHN5Wxcdsz/t0kyomdknc95gSAlSJZE
         1bjw==
X-Gm-Message-State: AOAM532pVxf1VUUGrgjFxxa0z4TBcyRYgGyA/s7UpopkrntM/LxGlPtn
        +s93JeVXbf7KKCV9XrMzRxJHukqif5EjTvIt2Vqz1g==
X-Google-Smtp-Source: ABdhPJxLCTnmrS0FxDexJS8BUi6yS3NFxGZvwfx6rBPeoTO1tGtSktgJZHmhtA7m/pi4McQuQzTCaGg1ODJluD5KmYI=
X-Received: by 2002:a17:906:4f91:: with SMTP id o17mr43371030eju.503.1620910056785;
 Thu, 13 May 2021 05:47:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210512144743.039977287@linuxfoundation.org>
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 13 May 2021 18:17:25 +0530
Message-ID: <CA+G9fYsYS1bYuXLrWjPmFzLajr8U0aE_g7KjNvVrUjVZXUOs7w@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/244] 5.4.119-rc1 review
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

On Wed, 12 May 2021 at 20:22, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.119 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 14 May 2021 14:47:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.119-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.

Apart from the mips clang build failures no other new test failures noticed=
.

## Build
* kernel: 5.4.119-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: 12be7a21d6221f3522c583c1d0407ac22578bd85
* git describe: v5.4.117-430-g12be7a21d622
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
17-430-g12be7a21d622

## Regressions (compared to v5.4.117)
* arm, build
  - clang-10-axm55xx_defconfig
  - clang-11-axm55xx_defconfig
  - clang-12-axm55xx_defconfig
  - gcc-10-axm55xx_defconfig
  - gcc-8-axm55xx_defconfig
  - gcc-9-axm55xx_defconfig


* mips, build
  - clang-10-allnoconfig
  - clang-10-defconfig
  - clang-10-tinyconfig
  - clang-11-allnoconfig
  - clang-11-defconfig
  - clang-11-tinyconfig
  - clang-12-allnoconfig
  - clang-12-defconfig
  - clang-12-tinyconfig

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## No fixes (compared to v5.4.117)

## Test result summary
 total: 69342, pass: 57571, fail: 1395, skip: 10128, xfail: 248,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 192 total, 186 passed, 6 failed
* arm64: 26 total, 26 passed, 0 failed
* i386: 14 total, 14 passed, 0 failed
* mips: 45 total, 36 passed, 9 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 21 total, 21 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x86_64: 26 total, 26 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-android
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
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kvm
* kselftest-lib
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
* kselftest-zram
* kvm-unit-tests
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
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
