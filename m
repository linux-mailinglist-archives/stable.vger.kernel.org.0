Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93FB1387638
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 12:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348401AbhERKO7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 06:14:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241713AbhERKO6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 06:14:58 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF528C061573
        for <stable@vger.kernel.org>; Tue, 18 May 2021 03:13:40 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id lz27so13648105ejb.11
        for <stable@vger.kernel.org>; Tue, 18 May 2021 03:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XCjdAIYKFIOUqRS2uYAt62Fdcvl22KkG/+jpGWUFmNg=;
        b=pARwqGxFgSWFZVtHdmPCntAfAH17AL74VqtoHM2b2jfvwizRH4R7FGVtG8vxqVAsJl
         ppgbQMobef7sh0L0k/3nbFaBf7ety4naWEebNjXMIlxySkRt0TPWPmVtgr+ZmaEGImkH
         +VwqYFZa80vRh3LoFnTXgvVGsEPxrl9JVY452t6RWDx0N+elehyWyCGykUF/XeE/3SXm
         yF/9zAJvUHWN44zf3AFzqYZPIm5sMkrQyohXv+EHO8Ym6SvRC/uqPtMstj9QGlm7m2SN
         44DJZZVYPZy/zVEPz6Vj1fhrx1g9zkqmuSz4qHXst8Tft7YOaZhYdGC/4Sv4NyK6MCIj
         Peog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XCjdAIYKFIOUqRS2uYAt62Fdcvl22KkG/+jpGWUFmNg=;
        b=XE+4SoBugVhIKtt+03HLovRVuQo7womiWGmOLPbMhAldrWX2N+ZA2CqNAqoayp7p4g
         D+1RalJOVuC5E2GaBKdqMEEZo8IMHMctwILFKo2yw1oHFUQWeMYtjznR/x/A8pi9r+MR
         UrAb/i6DQURjniiDSnGUgIX+hjyN4rcWgtlSrqe8XIC0chGXaxTcNauAK5ThhHn/00b+
         fwIGkR+Q7DYNFitN39W46MZbmtPD5CsqLtQoFkLpMD7GtNd8/Uu6BtIA6Bcw1l+Z6oQH
         P3JKWbl26Us+l8AMkFtsyZuxizbcrvswFT8ShKeag/pbVm/n3r76OW+RQZDQxl689Wli
         DLkw==
X-Gm-Message-State: AOAM532n7shmLU/5KLaYwVF+8/RYqVjlNRqjBWW8UF2rJHu3cUbaw8B1
        WsHfuCapOseb+0iH8ZKIHLcTyC4d29m3ZZgAM/wFCw==
X-Google-Smtp-Source: ABdhPJwk+Q9HRvxmLz+BVU0ruWtGX7c9AJRoVc6hdou0p5dZBJEFhKBnOXVmJCiiiO2gqUimL08QGt3NdI3yJuLFrWE=
X-Received: by 2002:a17:906:fcdc:: with SMTP id qx28mr5179957ejb.375.1621332819361;
 Tue, 18 May 2021 03:13:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210517140305.140529752@linuxfoundation.org>
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 18 May 2021 15:43:28 +0530
Message-ID: <CA+G9fYvpJ7_D3GJX=6w1Vg2kZAmiVKdYNHCfoiPm3AGYpGDc9A@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/289] 5.10.38-rc1 review
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
> This is the start of the stable review cycle for the 5.10.38 release.
> There are 289 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 19 May 2021 14:02:24 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.38-rc1.gz
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
* kernel: 5.10.38-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: 7ba05b4014e8c0aa939b4192e85cee82aff0045a
* git describe: v5.10.37-290-g7ba05b4014e8
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.37-290-g7ba05b4014e8

## No Regressions (compared to v5.10.37)


## Fixes (compared to v5.10.37)
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
 total: 71550, pass: 59638, fail: 1093, skip: 10144, xfail: 675,

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
* install-android-platform-tools-r2600
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
