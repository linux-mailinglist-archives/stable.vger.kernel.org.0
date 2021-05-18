Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAA863873C7
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 10:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347406AbhERIOC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 04:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242020AbhERIOB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 04:14:01 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 837C2C061756
        for <stable@vger.kernel.org>; Tue, 18 May 2021 01:12:42 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id z12so11733077ejw.0
        for <stable@vger.kernel.org>; Tue, 18 May 2021 01:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8+rvu90qqHRVLIV6jyDYwaC+D+UAbpfG2s6LRRdF7Tw=;
        b=iLYMyT7GGyobgp3BOsIb8vCQ4JaEp0FlaCq8WZdJXvHzYgUgqk7xP2oQa2uqZBWj4K
         GbbKvGDheVPHQOp0354TwwTHz79kSoeu0DrEUyhBOdFMpLDATYpA62HAl2OVsBOtpjDW
         GuV8DEMOrpWmhFUeR7srEFgzw1ScccvTKcn6z1MlJVqThei3H79/QLO1xtEsh6nzCvmE
         3cLdbC1PAZ17Tjx+loAXDZp74XXwliZ9u9+X8KwnZ7x021p4nK+EGhg1U/zVJI33g1ku
         bjQL7tlDQpVsMblbeLH4OVK3OM+QAADeiemKhNzCyyvn9MkE7seavAksTXFtU1p34yoW
         bLGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8+rvu90qqHRVLIV6jyDYwaC+D+UAbpfG2s6LRRdF7Tw=;
        b=J2KtEYxreglpipCXBuoHEH7Yy5iUp5oi+ejyAXcMMB0/hMiR0hhmo/0JE/qIx5NrNG
         nB5fu0kuapAAtl0xdaTPNh2TajPHGnSG54b8HiVquljFxABH3EodxGIDy3J2l9czBHwk
         wV7akjvJrGc4OPSa8U0G8x+4vIxrj31/2E9iiDWF/6ROIILEjAUxcuIS+4OHnAgyMpP2
         +/9yis98/5lXvOIv3mZcZyhJCE/S3jol/Uyxemm8KoYBKpwzxQzwmFjnceKYa+ZEg+KO
         pEAT6amhG7Bu5V90gOTZJyXlo/Lk9BpKPxlePt1Fzx38sHXmgu7oLLfulu/6diJ54X1D
         wMZg==
X-Gm-Message-State: AOAM533p7WmyywjyGwQiTJbkhWFUhPGqQGlMWigBP+WvSHuZWaKBXsFY
        Yt2LXNditcxVun3u590k/8wcX5+houLt1XgjHhxgZQ==
X-Google-Smtp-Source: ABdhPJxEw3S1tILNEp6/aSmt9S1DVpPVaXzjk3cKAuJCNfa+z614rDbJ/HiIEC8u2iZxckhSk9PGMTUXlOBudwCQ5mU=
X-Received: by 2002:a17:906:4e59:: with SMTP id g25mr4804469ejw.133.1621325560935;
 Tue, 18 May 2021 01:12:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210517140302.508966430@linuxfoundation.org>
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 18 May 2021 13:42:29 +0530
Message-ID: <CA+G9fYsdpoByDJ3ULPRCUCQo7NOyyxwg_xXp3tjR9QE4hZnJkA@mail.gmail.com>
Subject: Re: [PATCH 5.12 000/363] 5.12.5-rc1 review
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

On Mon, 17 May 2021 at 19:33, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.12.5 release.
> There are 363 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 19 May 2021 14:02:12 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.12.5-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.12.5-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.12.y
* git commit: 8c6ba5015affe5c570b32cf542f58218e4dfebf1
* git describe: v5.12.4-364-g8c6ba5015aff
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.12.y/build/v5.12=
.4-364-g8c6ba5015aff

## No regressions (compared to v5.12.4)

## Fixes (compared to v5.12.4)
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

## Test result summary
 total: 76409, pass: 63868, fail: 1049, skip: 10771, xfail: 721,

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
