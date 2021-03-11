Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8D0E336A99
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 04:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbhCKDWI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 22:22:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbhCKDVv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 22:21:51 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC89C061760
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 19:21:40 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id p7so31869836eju.6
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 19:21:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=58KsFLgr6KLxNvD5xC5kJqAwJ63HiJ/2w1uIcACsZKs=;
        b=S8EmBfsg5uy4YlvFeFJgLxo8uSqwMgxCkzDJaN06QegOmUb+jmfxna63ljVzv6uv0U
         oAFzQGC4sTty9XT2fqyy55g11McLbl8kdwNnCuNoaIXdGQ9MMCd2MA+LZVT0jCDpE0lp
         KnWM6BvNqur2AvugBuy0P9OT4In6CEFOqCI2leOkdSxhg1S6PWrqslyCzkagZLmSzzM2
         um+85Qw0yiBovhEcSyzgIamVaJT6UhfEG90UwRftH3gY5A/dcnL68pVdUnAmJ7UC1AKz
         WyJ6637Rob5+fRGxGwv8uh6OAi02cm0V+mQfvFDY3GuccKGJRCyIsr1nriu9p7+PtKtR
         bPJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=58KsFLgr6KLxNvD5xC5kJqAwJ63HiJ/2w1uIcACsZKs=;
        b=kkPEdyRDCGlrpUwHDyBFeDNjsbNJmKhu768jwBpD24JTUap17V9uq46QOaORAF0OY2
         qkRXO3fQgI2G6JI7rpV7hEYXdck5GPgRgDOGMJvixGtaWSd9yFoCrJ7X8uGxQeAUl4GE
         5KuMo7/6+wY8RLf4osk6rir+mgmjOu3/gxwN8MKWWmohuPLM3oazA2OC3MDZkrKQi+Xy
         N6VRmYezwVsodpDmym6YbLQ/5YxS7vFAZF+Om2Y3nB3iKWWC4rPDQWqLx1BCj196wtwH
         8QoJqI9ENuuST04xcqon5IteOmgHA+Fs87ib+b9foSMYmwWyAaopgkiKQoYkMSBfoT0g
         IRPg==
X-Gm-Message-State: AOAM531QM3Txl76WvwfGY/fVqkniWCcBVKhWZCCaBfqEzzusYbWwatMa
        ETAEwPYXPomlfVmtoa5RyxaGH1MUTUK0WN5vX+pEOQ==
X-Google-Smtp-Source: ABdhPJwfU0cZitsOoMDn9KYFy1GGC5pxA5KT7muiD/jUgWKE0f6zr2B1nLaje47OpTz75JAY1P6uwV5yGszqBexkVSY=
X-Received: by 2002:a17:906:4c85:: with SMTP id q5mr961390eju.375.1615432898833;
 Wed, 10 Mar 2021 19:21:38 -0800 (PST)
MIME-Version: 1.0
References: <20210310132320.510840709@linuxfoundation.org>
In-Reply-To: <20210310132320.510840709@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 11 Mar 2021 08:51:27 +0530
Message-ID: <CA+G9fYt=K-uVJPBvwZUtTUQVe=ZsQLzsFd1QD6SvY6GwV770Hg@mail.gmail.com>
Subject: Re: [PATCH 5.11 00/36] 5.11.6-rc1 review
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

On Wed, 10 Mar 2021 at 18:54, <gregkh@linuxfoundation.org> wrote:
>
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> This is the start of the stable review cycle for the 5.11.6 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 12 Mar 2021 13:23:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.11.6-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.11.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 5.11.6-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.11.y
git commit: 4107fbb88ee5fa94c8e94ffe5833b7fbda792c96
git describe: v5.11.5-37-g4107fbb88ee5
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.11=
.y/build/v5.11.5-37-g4107fbb88ee5

No regressions (compared to build v5.11.5)

No fixes (compared to build v5.11.5)

Ran 52341 total tests in the following environments and test suites.

Environments
--------------
- arc
- arm
- arm64
- dragonboard-410c
- hi6220-hikey
- i386
- juno-64k_page_size
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- mips
- nxp-ls2088
- nxp-ls2088-64k_page_size
- parisc
- powerpc
- qemu-arm-clang
- qemu-arm64-clang
- qemu-arm64-kasan
- qemu-i386-clang
- qemu-x86_64-clang
- qemu-x86_64-kasan
- qemu-x86_64-kcsan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- riscv
- s390
- sh
- sparc
- x15
- x86
- x86-kasan
- x86_64

Test Suites
-----------
* build
* linux-log-parser
* install-android-platform-tools-r2600
* kselftest-
* kselftest-android
* kselftest-bpf
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
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
* kselftest-tc-testing
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-zram
* ltp-commands-tests
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
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* perf
* fwts
* kselftest-rseq
* kselftest-rtc
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sync
* kselftest-sysctl
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-ipc-tests
* ltp-sched-tests
* ltp-tracing-tests
* network-basic-tests
* v4l2-compliance
* kselftest-kexec
* kselftest-kvm
* kselftest-lkdtm
* kselftest-vm
* kselftest-x86
* ltp-controllers-tests
* ltp-open-posix-tests
* ltp-syscalls-tests
* kvm-unit-tests
* rcutorture
* kunit
* kselftest-vsyscall-mode-native-
* kselftest-vsyscall-mode-none-
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
