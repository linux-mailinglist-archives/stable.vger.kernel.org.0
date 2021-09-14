Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE89740A6B1
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 08:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240075AbhING05 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 02:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239936AbhING04 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 02:26:56 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3D3EC061574
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 23:25:39 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id n10so18096484eda.10
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 23:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dRNiDC7YLs5heF9NcfR3kRhzSMIb5odMrKovtse3vZ0=;
        b=TfNPXtb37/ctK/4DAPOe/UQzIAP8tujP01WQDhiu4XxlSP9NsLwAsRhGrff/fOwP6x
         KvjtKG3Pq46pE38LvWcgKTK/6iGlDuL3bkJX+hphmZ5OFHtyLjFK34sF6XOoSIUYqwdb
         1R4dZmkU1Tanex2tZkBfsSBAkE/6brNrNfTLu/zLERmDGA2XElrczKMqG5PTzYZHaX30
         z7fngl7M5eak0Y4jucGbkYRTrixl5MC0TnKXCG1AehKyu7SlM1ckYbV/KKtgL2QL3gew
         BnyZkZKqe4tf7b5yXzy2g9urGq3FwIdwcTlOZi30aydlhu5X9fyXRVP1MvtTBHFCuwUV
         IYaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dRNiDC7YLs5heF9NcfR3kRhzSMIb5odMrKovtse3vZ0=;
        b=sMHGGo5HYNxv8k0HRcjimwcXLV8387b1T4vxvFYnCVfhXfp4K/xFtCztV9KecVSR1d
         KeeJDqRWVWaA3zO5pBuwSpYXdSnLjK7fEfCpqLpIaV1mT06USiFJMtW9+PnlUh5nU7zv
         UCIeWAKICN0Gr1u+Gy9VMyPobiaS0mFdmpgcl6KTIhmgXEtV0DOj7a6XpDgk1tWUXbyX
         4x4LC1ajo8gAMzvtsveF6BN4ybryXaVRKdqHL3Ut55D9fpLBChf40Dek4LldeOKngVhw
         HKQOYlvd7S62HOHNqj8E8ki5fERllEqBR/RpPXsn2nXVL2ZBWmquk+A5TUgfdu+YLMn9
         Xwhg==
X-Gm-Message-State: AOAM530ftQs/uuziSbix3qpkrNjX1+B0Z2ta4UwYlj+Gzpk03NsPwk+5
        9P7yPB7clBDIqUMmjeLSNKKXtAoCzdhik/CaovIxSg==
X-Google-Smtp-Source: ABdhPJzmWKzZmBP1pEjQIcGKkCAAXcKhcY+v43u2I/h9tGtB3r0vwJL8GJcy7Q4XC1BD4AqLCfxyurN+PsUjKy78SH8=
X-Received: by 2002:aa7:dcd0:: with SMTP id w16mr17554934edu.288.1631600738232;
 Mon, 13 Sep 2021 23:25:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210913131100.316353015@linuxfoundation.org>
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 14 Sep 2021 11:55:26 +0530
Message-ID: <CA+G9fYuW0Z=NxY5wHrb6J0aWH393iDt=DafLQ8tYpHd6e5YY9w@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/236] 5.10.65-rc1 review
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

On Mon, 13 Sept 2021 at 18:54, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.65 release.
> There are 236 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 15 Sep 2021 13:10:21 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.65-rc1.gz
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
* kernel: 5.10.65-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: e306b25768e344bf338aeb3b1439af89af21b31e
* git describe: v5.10.64-237-ge306b25768e3
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.64-237-ge306b25768e3

## No regressions (compared to v5.10.64-215-g5352b1865825)

## No fixes (compared to v5.10.64-215-g5352b1865825)

## Test result summary
total: 89197, pass: 74790, fail: 603, skip: 12826, xfail: 978

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 289 total, 289 passed, 0 failed
* arm64: 39 total, 39 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 38 total, 38 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 51 total, 51 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 36 total, 35 passed, 1 failed
* riscv: 30 total, 30 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 39 total, 39 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest-android
* kselftest-arm64
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
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
