Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDA754554B0
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 07:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243302AbhKRGUd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 01:20:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242971AbhKRGUd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 01:20:33 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB25C061570
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 22:17:33 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id w1so22010600edd.10
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 22:17:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2Jgd/Uy9gtODKx1KtUIvf0F11hbP4Jy1x4tgEAPO2Ag=;
        b=nUSEXBVc11rBCtBD7x3GDqvBrXQo4CKDhYAd2w9Ptj3WCS/T8/tNSQ52nXpBiC5+hr
         A9woN8mVpcOVmPA+f0TLSka078BeypYAO+9wBv3tC0wGkwCHS0LmaRwBcDfGG1bYEl0g
         X4mi49p/RBBy9bqlp8qyz5e75pFwcTEB7YfViavDlBXi+C9H1KLW12MX63sdMcmIAIaE
         r435TVQC4PYHHDfEqaiPZag7+7wxUKMuqkt96hWxrgPbJY+8TgPb1mS6frDaVscjeKfI
         7PoblSYw/y5dyLxSRSiTFc6ghyERIOWtlrwvQ9kDWHtskIV98S3pMpKQ5rrvfzarhLqo
         aUfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2Jgd/Uy9gtODKx1KtUIvf0F11hbP4Jy1x4tgEAPO2Ag=;
        b=soaRtga5EiZa+J/ywiWZPvMUiG99vKcBgwE+RF8RcI0+YIDidXzsEHjuKU+ReHPaLv
         iUhYUe5nk4xCHHDjZOk0BTW+M3Yxa0Lo9Pd3fPWrE++nvMoRBTlt4tI2qE0emQ3qciAP
         TpPCEr1o5FSZAKOZYK+uIXBds7RvunIcyQn/OpNlNXADz+8zibqMVR+Cqp9anOiuOksF
         wdmAK9Jo3y8gVOMxW5xGHK18/XxlioiWT0XhHKQQTBwVlZeWYLe2fq0zIcZhoHHjerjo
         zQsqMMwVyP9H/uSvCHPc9cNeSpAdz3qZYKbXNhUw0vRpeE+nzkB7uC7v3XMtYD02ToqG
         7NDg==
X-Gm-Message-State: AOAM533TIoIZ/kCSKYU3H4/eVw9DL5kK236VzK/OfaLsWvj43+/uNk0M
        gJMM910+0RSX6Hp0DzL6T9sQqu/7d9X9c+r8/DtzAA==
X-Google-Smtp-Source: ABdhPJz5jXV9FDBEk4qJUbxvQpSDeAySuVhYuOB3OxjgG/lbBWVUwaxhu5X3K+zXJjQIZSyxGugAievmkFXtCmQ3ZZ0=
X-Received: by 2002:a17:906:489b:: with SMTP id v27mr29401117ejq.567.1637216251656;
 Wed, 17 Nov 2021 22:17:31 -0800 (PST)
MIME-Version: 1.0
References: <20211117144602.341592498@linuxfoundation.org>
In-Reply-To: <20211117144602.341592498@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 18 Nov 2021 11:47:20 +0530
Message-ID: <CA+G9fYv6gNNhtGtE5HC4e4M+kdb7gJKn1t6tC1mec3V0gJ2SZA@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/569] 5.10.80-rc4 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 17 Nov 2021 at 20:16, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.80 release.
> There are 569 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 19 Nov 2021 14:44:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.80-rc4.gz
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

NOTE:
Anders reported that,
The following warnings are still noticed on arm64 builds.
drivers/soc/tegra/pmc.c: In function 'tegra_powergate_power_up':
drivers/soc/tegra/pmc.c:726:1: warning: label 'powergate_off' defined
but not used [-Wunused-label]
  726 | powergate_off:
      | ^~~~~~~~~~~~~

If I cherry pick 19221e308302 ("soc/tegra: pmc: Fix imbalanced clock
disabling in error code path")
the warning goes away.

build link:
https://builds.tuxbuild.com/213DyYEZ9MU7o7yLjEn0sleNfM6/

## Build
* kernel: 5.10.80-rc4
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 087abd07310fe0fc9974a321f3e0918e63c4bd44
* git describe: v5.10.79-570-g087abd07310f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.79-570-g087abd07310f

## No regressions (compared to v5.10.79-579-g739c1bb0c245)

## No fixes (compared to v5.10.79-579-g739c1bb0c245)

## Test result summary
total: 90167, pass: 76691, fail: 526, skip: 12152, xfail: 798

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 259 total, 259 passed, 0 failed
* arm64: 37 total, 37 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 36 total, 36 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 34 total, 34 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 54 total, 46 passed, 8 failed
* riscv: 24 total, 24 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 37 total, 37 passed, 0 failed

## Test suites summary
* fwts
* kselftest-android
* kselftest-arm64
* kselftest-arm64/arm64.btitest.bti_c_func
* kselftest-arm64/arm64.btitest.bti_j_func
* kselftest-arm64/arm64.btitest.bti_jc_func
* kselftest-arm64/arm64.btitest.bti_none_func
* kselftest-arm64/arm64.btitest.nohint_func
* kselftest-arm64/arm64.btitest.paciasp_func
* kselftest-arm64/arm64.nobtitest.bti_c_func
* kselftest-arm64/arm64.nobtitest.bti_j_func
* kselftest-arm64/arm64.nobtitest.bti_jc_func
* kselftest-arm64/arm64.nobtitest.bti_none_func
* kselftest-arm64/arm64.nobtitest.nohint_func
* kselftest-arm64/arm64.nobtitest.paciasp_func
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
* perf/Zstd-perf.data-compression
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
