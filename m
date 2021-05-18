Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBE8A387684
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 12:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243281AbhERKcX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 06:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243040AbhERKcT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 06:32:19 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DED7C061756
        for <stable@vger.kernel.org>; Tue, 18 May 2021 03:31:01 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id w12so2762075edx.1
        for <stable@vger.kernel.org>; Tue, 18 May 2021 03:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=REMk6n3Nqw9wHkenYmke8jZFrqCP3sB2GUI8ZM8zJkg=;
        b=iI/fl35UrXezy2v/30F/Av/tHC3gCEk7OBWFtPN9Pm/13t77dJ0bOR08e2YQp9V83D
         wKnC8zSMV7lWN9CwNyh2hCasgKapZMprl8IMD91zApdotqagxIy8lNlZXtjg7Thv2WXG
         /Ofk/UhAl334yYEZYNWNVKyyoHHrz1jJ6VdmmEyJk9DPonukBDOyMrhd+TXbtJcrxFNH
         fiJW4xU9X77aBHFliKiLwoJmllNAuGmZnQb9rtRCXJgCRHa9VJZpiD8DtwTLiQaslqwK
         MnAp+CR+FSFbIK4o/K/dL2cR2bEqQ/Tr/DfZ0ipKMUsmP6RbAzAKx4PbZJmbkHDt48yE
         sogw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=REMk6n3Nqw9wHkenYmke8jZFrqCP3sB2GUI8ZM8zJkg=;
        b=VyN+gb0dbOy37RXF/FLy21UNeg3KklP4Ue9dcqMkfc0lCEBA3jOg24UCvexSqfJl4a
         5VFiypZDXeK7L5VqTd2tXEztNgo9jASifsa5bHQwAEan10v7HG+r8uAbu/y/Zo4FFxBo
         G9p7CFuxCH2kuxgo7A7Jyn9LJ13ls3QK3EiKm1GP/Fi86RQQ/VV6T7/lQ2B58ABGVOwk
         hzskYYsa+eu6w4S9eXAE5mcBj4VD3MXEjLZNAKC0uPdsUBucKFg/FNAZrV7998RJwp+z
         UScw58pI7dkAf//K7r3M9y2Ix3FKXFXZEgTsTqJg0fYzRYJLJEVnMBCn+liKRbVnXiJU
         ZUEA==
X-Gm-Message-State: AOAM531CXqCznk5rF41frH0FdZBlTv18SyT7J0s/7S/siz90lj5tPjRI
        o+kg3J0/3X+8u9p5J2ci1mPBUlh5O0FRhar6c5wdoQ==
X-Google-Smtp-Source: ABdhPJx9NPs2/r9JPT/dn3WPgeBkavMuPORQ4sUT6Tc6NbqCOYuHEdMVd6PVlmCQQUWJLErYslkQnK7TFSaMWIN7cAo=
X-Received: by 2002:aa7:d786:: with SMTP id s6mr6084088edq.239.1621333859680;
 Tue, 18 May 2021 03:30:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210517140242.729269392@linuxfoundation.org>
In-Reply-To: <20210517140242.729269392@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 18 May 2021 16:00:48 +0530
Message-ID: <CA+G9fYvtrwm0b__vR_fq3rXFN8AGxq-3rcgTZ3mEOa=aJbRCrA@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/141] 5.4.120-rc1 review
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

On Mon, 17 May 2021 at 19:33, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.120 release.
> There are 141 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 19 May 2021 14:02:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.120-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.120-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.4.y
* git commit: d406e11dbc1324e375ab1f7c4669abc3cbd994f4
* git describe: v5.4.119-142-gd406e11dbc13
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
19-142-gd406e11dbc13

## No regressions (compared to v5.4.119)

## Fixes (compared to v5.4.119)
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

## Test result summary
 total: 66208, pass: 53791, fail: 1226, skip: 10340, xfail: 851,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 192 total, 192 passed, 0 failed
* arm64: 26 total, 26 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 15 total, 15 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 21 total, 21 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 26 total, 26 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
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
