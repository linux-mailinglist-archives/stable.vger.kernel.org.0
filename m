Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C09223CC3F0
	for <lists+stable@lfdr.de>; Sat, 17 Jul 2021 17:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234458AbhGQPDs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Jul 2021 11:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234425AbhGQPDr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Jul 2021 11:03:47 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4E54C061762
        for <stable@vger.kernel.org>; Sat, 17 Jul 2021 08:00:49 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id h2so16936559edt.3
        for <stable@vger.kernel.org>; Sat, 17 Jul 2021 08:00:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lKMibIsS9rT2fMwJ90ICX9C9VxJ1nvPaBmilinRidwY=;
        b=ODbRE9y82G8vvp0wCrzGcMnwQsvmVPgW0YCvZ13DDasa+YYcjkFEJdKbWM45ZClJy6
         Pb7C0rjVABX4T+s7fEF33DxjvxxM9vzVvz4STFSnzqwgzVcbBgH+jtXuegbbf9TY62JJ
         u+FteOwA5LkLTljDRSiaVQ2ikfUzHgZWqjfOTPSKBa+xUOkYjAHZeG1MKjl1QvYe1hdL
         ZXWP/RMkqRe2+OCzwxnRAjvPJRLZ3WF8iYyk4F5L9EvCTZfqHksQtrgud74fSwsTchO2
         bZ0Bunr69/mMq2KiB5EqF1C7YUvi5Lg1EehVvfPMCYWTlKJ5CfRR2oHZfGUbsdAIGaNj
         TQWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lKMibIsS9rT2fMwJ90ICX9C9VxJ1nvPaBmilinRidwY=;
        b=hstx5xttL1tMQi8rjXojh65PLuYxbjzmEsOfpHcdgFXxgguorf/7thqIS4DQpSoD6Z
         wsiwNcWTOlBls+ZpSXvV67g4vL710vwSc5fuXz15EaXLdxni9qSe8AD1+Sld1s+ueePF
         zL3cl9OBLZhTRE5QiVFEYZOmZs+nJdKpz16HG4COPM0hn/vPxo+17iUyPTwr9XxBCPn9
         4bFcj9A5N37MtemkhrL1LDAF/u/QdMiN3Ixbz5cjIUgvEsIovOS2VHOCO7F0xI12pyLE
         dFXmUm2d28ucf7xydUB3SGUBc6O4XU+42gSH7LVyCKJLIZACyXbI5CfQ0Cu4H+XAythc
         OZIA==
X-Gm-Message-State: AOAM533csPoplMzOADjGi5l77Kekfdy4cCPU5ZY3lb2AFXKiLJ3u5ZNQ
        Y8GalJkLzquSVBZdTRfZDjYg1phhV09Vy2EvjXtXdg==
X-Google-Smtp-Source: ABdhPJyinOuYsnSquwzBxkUya+jJtrGVKl1n0RGU49BT6E0ChyLqxGg9c/0Z108PYAMlW5De4zIYTSvnTrpMxOOUYeg=
X-Received: by 2002:aa7:dc01:: with SMTP id b1mr22227345edu.239.1626534047968;
 Sat, 17 Jul 2021 08:00:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210716182150.239646976@linuxfoundation.org>
In-Reply-To: <20210716182150.239646976@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 17 Jul 2021 20:30:36 +0530
Message-ID: <CA+G9fYsGZKxkOqWZJwcTr9mpnVE5WEUr5FG1wrh+KNHX9oZpWQ@mail.gmail.com>
Subject: Re: [PATCH 5.13 000/258] 5.13.3-rc2 review
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
> This is the start of the stable review cycle for the 5.13.3 release.
> There are 258 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 18 Jul 2021 18:16:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.13.3-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.13.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.13.3-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.13.y
* git commit: df7d40fdca4b2ca46a7606a7e0b2107f2f82628a
* git describe: v5.13.2-259-gdf7d40fdca4b
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.13.y/build/v5.13=
.2-259-gdf7d40fdca4b

## No regressions (compared to v5.13.2-267-g7e5885df1870)

## Fixes (compared to v5.13.2-267-g7e5885df1870)

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
 total: 79739, pass: 65308, fail: 2144, skip: 11035, xfail: 1252,

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
