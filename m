Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665DA45546C
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 06:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243172AbhKRFt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 00:49:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243176AbhKRFtH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 00:49:07 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1557FC0613B9
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 21:46:08 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id x6so10079313edr.5
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 21:46:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9xoW2+qkJ0j06ZzFxD55kRcyYr97dCzfdx7pR0ez3FU=;
        b=DF6/Syf1yIPTSEGDvDhST+BhCiXFoIZsdY+oDYJPhqObHj+7DayTXrwz8wRKyU4Jxi
         z0oQneBzdeU56fdLsGO+ZRYfdy1y1P7bo87By/hDx0vNAnqlCGZd/S4/tXZUCr2tIGcc
         jhkGSYN9dWTdtCKJdsQMzdmqCM3TXmPQne0viIBl8xIWuVLrIVBHVWHht70FWT/+oxZU
         csB5Ao4E3oKD/h/hmob5KDXgsk6gOIdCu7hDtXxt3Sgi7vBk474HvxeX9UbzeE9/r2ym
         mBqiuDaMhglzGN94nbDy7Eud11Ez+UuQ9mi9ICWgMm+vOBHmyKPlZd8qT1kHhM/hdXq9
         eKhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9xoW2+qkJ0j06ZzFxD55kRcyYr97dCzfdx7pR0ez3FU=;
        b=OomoyjtAEURU77SM41Djln7kLFXHI+wZyDUjYqbMDr+K0kb9sH88vM9zF97zYd5uPw
         WW1Uv2v5e1NUWpHXyRjjBv+QX9ZTNtB8Bk+SacsuOtQ5bxLVQ2t61kpbw7NxvOeaE4vU
         YlA2QtuIADOAp8GLEzEYiQOR/zSHu6kEavEaadEXb36Qp9FHIzcI9u0Oi8y01joPxjM7
         OE9kyke5W+oUBK9PrzC9VDHeyoY/6UwcdZMoO5ckPtelHN0z3QUardgt5T7ejzDs6AeK
         0A6e18reeoZwdPSYvo+jbFYW+zhUNy40e30aI4UmNFIfP1ojgbGyV+W4KNFtCubJagYF
         gmcQ==
X-Gm-Message-State: AOAM531OaUZEV1+9KsZFUh4M0pGAnP9P45oZ823hWoe8BWY/a0051Xxz
        e3DbYkM0L3/46BdNpme+zWGxdZATZMeUSJLs6sFaZw==
X-Google-Smtp-Source: ABdhPJyd9wbn0UkOynT79hGk79iWB4YdsFGu5uRGNcHc/R/TVhezhM+Ur0tOZkFRVaojcogkxkJHgaUSwGXprFmrLpA=
X-Received: by 2002:a17:906:b50:: with SMTP id v16mr29941824ejg.384.1637214366463;
 Wed, 17 Nov 2021 21:46:06 -0800 (PST)
MIME-Version: 1.0
References: <20211117101657.463560063@linuxfoundation.org>
In-Reply-To: <20211117101657.463560063@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 18 Nov 2021 11:15:55 +0530
Message-ID: <CA+G9fYu51TyOskHrMf9oNCmTWdnoBX=QTunxf_QD1eNua4Q1Gg@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/923] 5.15.3-rc3 review
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

On Wed, 17 Nov 2021 at 15:49, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.3 release.
> There are 923 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 19 Nov 2021 10:14:52 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.3-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.3-rc3
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 7c10b031cbb7ead7befe5ffd99f08aaae7128eac
* git describe: v5.15.2-924-g7c10b031cbb7
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.2-924-g7c10b031cbb7

## No regressions (compared to v5.15.2-928-gcb98d6b416c1)

## No fixes (compared to v5.15.2-928-gcb98d6b416c1)

## Test result summary
total: 88673, pass: 75229, fail: 811, skip: 11931, xfail: 702

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 290 total, 290 passed, 0 failed
* arm64: 40 total, 40 passed, 0 failed
* i386: 38 total, 38 passed, 0 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 45 total, 42 passed, 3 failed
* riscv: 24 total, 24 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 40 total, 40 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
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
* kselftest-membarrier
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
