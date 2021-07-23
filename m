Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C99AA3D38E9
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 12:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231519AbhGWKIK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 06:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231984AbhGWKIJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Jul 2021 06:08:09 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD80DC061575
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 03:48:41 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id v21so3128119ejg.1
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 03:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/izvkyfApwDRPhD0enodwTd0L5Ly7S2ZmWqmIcFHr2E=;
        b=cEWeuYpDT5hdJgwjn0nUeusgzjdktfT1++kFjVkhNtV4UvjCt5qoGNAUyh8P7C14A+
         +q+Lm5nAlwoStRxM9qnwX2TBkjU0+3hPESQBZskYuVkpYSehrqaxAsVUAWwp2JEm50k1
         ur+KNNfjR+fZKhUpqtra2RWESZxChQxE/Qwl9Pzw5h2jsbmolZmJmgxU9LYjDQj5LUEc
         PAwlZI0JhdtxOaNzjU2k+3TxQAIpKhmyvcN1AgpuRPz1N5nlViJfo91YlznU3FLZ49oN
         Z7ngavOeebFVvbHtUJFWX/9l0Y39b4cfM3kCPN6GmXDHN2y/YMkRG5pPZbJa+xhuF4Ru
         G2Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/izvkyfApwDRPhD0enodwTd0L5Ly7S2ZmWqmIcFHr2E=;
        b=oykmuAi3wiccMvISJ0gNvVkMtp22BS9Kgz6tHU9lt2o6Ew0/KN7Bm3ZorANJrAebyg
         rYRLzKi8ARgfl20QlG5A14wCjv31Em3Eai7OAaOWMTne3h4V5AqEDepJUoNtPEvqXDtY
         dM4XdRiXge2MS5ruS2O2lddcnGGpNwu++5Tx9Hyy/9V0omgpPofXAIUDkNJMIl6gj13N
         eeaLktfj/RKE0evjk75di18KDwcXrAFRXXMpNOswAOStCqDjXRZTO0+SyrRkd5rA0GjZ
         w5FCwOFY18cIPV6jv9EY/tKaCutfW4wdAWGuMlCoKDidp5S7OAryzR0jGp9H408fn6LD
         BZLg==
X-Gm-Message-State: AOAM531m6OkjZtsoRmpPDctn2lSx8vwhilDBc3mMiAnhcsRUB3yD6Qmv
        Xv5zcBVvGgbJnhdMsAPcV/+G9bCGRWHctdOTJgTAvw==
X-Google-Smtp-Source: ABdhPJyUSGB50XGodyHq7EtGQ7LXGQZLJxQmK7yYHgHXHGOTkJqxh9Mz7maSwhiuRllFPPhHZc00MdKj91ilT+8rZ4g=
X-Received: by 2002:a17:907:7b9f:: with SMTP id ne31mr3958977ejc.133.1627037320143;
 Fri, 23 Jul 2021 03:48:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210722184939.163840701@linuxfoundation.org>
In-Reply-To: <20210722184939.163840701@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 23 Jul 2021 16:18:28 +0530
Message-ID: <CA+G9fYt-pNgjaWQLhntbWSv6gF9hq1C_pi0XQ_SzmgYnD+uizw@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/123] 5.10.53-rc2 review
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

Hi Greg,

On Fri, 23 Jul 2021 at 00:20, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.53 release.
> There are 123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 24 Jul 2021 18:49:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.53-rc2.gz
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
* kernel: 5.10.53-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 5e0262e1f1ac5576193112de3ecc70fd3726fee3
* git describe: v5.10.51-364-g5e0262e1f1ac
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.51-364-g5e0262e1f1ac

## No regressions (compared to v5.10.51-244-g36694d0b92d3)


## Fixes (compared to v5.10.51-244-g36694d0b92d3)
* arm64, build
  - clang-10-defconfig
  - clang-11-defconfig
  - clang-12-defconfig
  - gcc-10-defconfig
  - gcc-8-defconfig
  - gcc-9-defconfig

## Test result summary
 total: 73213, pass: 61571, fail: 364, skip: 10406, xfail: 872,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 193 total, 193 passed, 0 failed
* arm64: 27 total, 27 passed, 0 failed
* i386: 25 total, 25 passed, 0 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 21 total, 21 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x86_64: 27 total, 27 passed, 0 failed

## Test suites summary
* fwts
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
* kselftest-intel_pstate
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
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
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-vm
* kselftest-x86
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
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
