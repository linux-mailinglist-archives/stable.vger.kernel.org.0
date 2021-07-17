Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 360D03CC46E
	for <lists+stable@lfdr.de>; Sat, 17 Jul 2021 18:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbhGQQZt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Jul 2021 12:25:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbhGQQZs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Jul 2021 12:25:48 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3D56C061762
        for <stable@vger.kernel.org>; Sat, 17 Jul 2021 09:22:51 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id ca14so17138357edb.2
        for <stable@vger.kernel.org>; Sat, 17 Jul 2021 09:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=E67XC8ut+Wbo8FtLZ8FU9WX44vzgOaBvxfQnPswNml8=;
        b=wh7zWnAvgj3PBSV5hN4gAW8+YiposSyvedJL1xn9NMDon8ok7jb0xqw0DTdOJS08GG
         GGI7OKjr3seDix5OJdXsTQm0c95jKM0ZXCJjKb4XVMMflAPCeDefK9Y7Io0DH3rU4SET
         Cjh7dE8AnuLKuLzIPXDlYRc2Rc7YfXOKvCZ0YKNYnRffYIGZcRx8EeYyWqwbdST3Pm8e
         DWN0LpEKVSqANG/qqUl2BzwACpr1hH251VtAqvP117IMOjVkjTORkuXa4KucvSTqR4T0
         +6VzLSUzlqgu9mE/V8M63YZzIce6owWYSLgn/QOsPaoSCmbKE7X+Z/Rl9oSeqaZ5MYED
         0i/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=E67XC8ut+Wbo8FtLZ8FU9WX44vzgOaBvxfQnPswNml8=;
        b=SxhlaTUQORdjBuZ2tq68KE6FD8vPqUYVpZZcd/2AkV19ZoXHWXPRCV4ey7VxMsOW9p
         sHlLZkWJIdc4eJSRSGQ9xmUQT15upjn8Q+F3ipNBsvOoeG1IOmecYQWs64FjQCQWeffx
         pwuXY66XjCplHsQ23MnrmmmWkGRbiISErZM/8qcEYYwxEw5x7bClDPH0oEZr6MVAz3eF
         M5/ox4i7PBoQU6HQ9Sw+yPjF0YPXCgq/JlZ0MsnLM/j5CAvses6jp2p0EzFyUQtIu0yH
         9FdFLmYRruxBUx2cob2cEbk6O+sOPFe5misZxQ3hH2V+LL9Rnv+mbLar1PpXgy0sZDT7
         VLhQ==
X-Gm-Message-State: AOAM5339/FnBz6GkOYBb6QZShmh9mZmbUkZESxI88KGe/CH/GOkQT0Bo
        oaSs1eekSKXZxXR3n/zBcU+8Ef0zJ4qkwsK3sRujaA==
X-Google-Smtp-Source: ABdhPJxGzdlyINvg9Ff2hzIJoWHcqDNXja435cuhVD5wkc+q/jw9WDIgV28dBZLWvu5f4VB/10a83deWZ//XNTS9Jzg=
X-Received: by 2002:a05:6402:152:: with SMTP id s18mr22675365edu.221.1626538970127;
 Sat, 17 Jul 2021 09:22:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210716182137.994236340@linuxfoundation.org>
In-Reply-To: <20210716182137.994236340@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 17 Jul 2021 21:52:38 +0530
Message-ID: <CA+G9fYuHv7vdvKZK=vCGP5xkecMgBWyOZNn+uao18mguWVRRGQ@mail.gmail.com>
Subject: Re: [PATCH 5.12 000/235] 5.12.18-rc2 review
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

On Fri, 16 Jul 2021 at 23:59, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.12.18 release.
> There are 235 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 18 Jul 2021 18:16:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.12.18-rc2.gz
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
* kernel: 5.12.18-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.12.y
* git commit: 55f470748e682bd0b4f977aa86ead52bb4b00225
* git describe: v5.12.17-236-g55f470748e68
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.12.y/build/v5.12=
.17-236-g55f470748e68

## No regressions (compared to v5.12.17-243-g56ea26ce5c02)

## Fixes (compared to v5.12.17-243-g56ea26ce5c02)

* s390, build
  - clang-10-allnoconfig
  - clang-10-defconfig
  - clang-10-tinyconfig
  - clang-11-allnoconfig
  - clang-11-defconfig
  - clang-11-tinyconfig
  - clang-12-allnoconfig
  - clang-12-defconfig
  - clang-12-tinyconfig
  - gcc-10-allnoconfig
  - gcc-10-defconfig
  - gcc-10-tinyconfig
  - gcc-8-allnoconfig
  - gcc-8-defconfig
  - gcc-8-tinyconfig
  - gcc-9-allnoconfig
  - gcc-9-defconfig
  - gcc-9-tinyconfig

## Test result summary
 total: 80635, pass: 66371, fail: 1624, skip: 11618, xfail: 1022,

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
