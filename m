Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3775437F6A4
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 13:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232856AbhEMLY5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 07:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232808AbhEMLYz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 07:24:55 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA922C061574
        for <stable@vger.kernel.org>; Thu, 13 May 2021 04:23:45 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id gx5so39335301ejb.11
        for <stable@vger.kernel.org>; Thu, 13 May 2021 04:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uk3Nuoqi9WrrlO8LNdfRu9oeJEhzgooAvqOd7EA2bC0=;
        b=FOqK6+boQCGhL7F7JNoJsU/9mIn/Y1xKY2MqKgw4q9fraenfRraM/G6k6jrjiUe9RK
         hLG2N8fFV8t5Z4xoSTlicXV/YV2BeeA1F3O/rLSZoD8/Lb3cL++5o10WE1Oz8RXf2g1j
         WYKmryrZRvEIf4WF2T4IwKxQrUQWtFrhL4aJCaci5puuVwW8CDQptlFiQF/OZgbdRhm5
         BmoS5AP98UWyP/qcW5+CTGJibOt6EzoW++ijBclTm3R5VL5zsDG78d1F1a+8kNWYQlS0
         eWrgyais1Lfc3lYifNHi4I11W1qpB/UUX67YxZDkX4cTAcENzt2Xm9S5PFMMDuxYFjtd
         r+zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uk3Nuoqi9WrrlO8LNdfRu9oeJEhzgooAvqOd7EA2bC0=;
        b=SD7jpTj81EMG+D3EvYr+gib0/rCsFSaTnav/p/jlqzRAo/eYW55qeIVHJ2ZwqZZTNm
         Nj/gUr8o062T3Pz3M2CHJtNyFKjF48gBnmmxbirLiz8iEme35+Vyio2CWdAwaXMJvKaS
         XbD4Jw0Y1tB7ZUuj0QzTrrmo3LM+4g8HTHsA2xl/vt2Xqsx0urZgSlWT+JHSSUTc2HY5
         FTvWXUO600OWfghn7QCpYP8cqPEowNa5pUR83ZqwgOzzMBpDLpxjSFtHkppzANDkswjW
         GKzZHuR7uKyY3IEeHEcr6SAhgF1xouNw7iHJ3pm+IMLLzJ/aPkD1MU3m4YQo/GvjlkG8
         jsew==
X-Gm-Message-State: AOAM533/mr2/OXqyqwVqvTCrqA7JZ+Qnvcfen4AH35MeiN6Hgil2cZPw
        Xh0KfeJi05LY+wczI1i/xJ0EQrXams0xJVHGE1RZrg==
X-Google-Smtp-Source: ABdhPJwBanYJkhng8FkxMKDscdU9yWBNt8sAdYEoJgKHghtwkyMRGaR6oLeFVKCWg0NAvYnalMGjSxoqqJO21/lsDtI=
X-Received: by 2002:a17:906:c211:: with SMTP id d17mr8002065ejz.247.1620905024349;
 Thu, 13 May 2021 04:23:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210512144827.811958675@linuxfoundation.org>
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 13 May 2021 16:53:32 +0530
Message-ID: <CA+G9fYtrG5TERBDNHewFP7fJnxbpbaqxBvm=psvLxvVFup8suw@mail.gmail.com>
Subject: Re: [PATCH 5.11 000/601] 5.11.21-rc1 review
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

On Wed, 12 May 2021 at 20:57, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.11.21 release.
> There are 601 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 14 May 2021 14:47:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.11.21-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.11.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.

Apart from mips clang build failures no other new test failures noticed.

## Build
* kernel: 5.11.21-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.11.y
* git commit: 1ec08480ab8706a140351f1c2e58d1624a1e0942
* git describe: v5.11.19-944-g1ec08480ab87
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.11.y/build/v5.11=
.19-944-g1ec08480ab87

## Regressions (compared to v5.11.19-342-g601189766731)

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

## No fixes (compared to v5.11.19-342-g601189766731)

## Test result summary
 total: 72537, pass: 61040, fail: 1006, skip: 10228, xfail: 263,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 193 total, 193 passed, 0 failed
* arm64: 27 total, 27 passed, 0 failed
* i386: 25 total, 25 passed, 0 failed
* mips: 45 total, 36 passed, 9 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 21 total, 21 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x86_64: 27 total, 27 passed, 0 failed

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
* kunit
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
* timesync-off
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
