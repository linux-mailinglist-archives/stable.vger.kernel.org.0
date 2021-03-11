Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F135336D2F
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 08:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbhCKHft (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 02:35:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231851AbhCKHfM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 02:35:12 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D859BC061574
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 23:35:11 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id ox4so28501691ejb.11
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 23:35:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jNGC0kwLbNM3zCmg/9YNMH2soHfOD4RAVferOYuy8O4=;
        b=d/UJ4uYG8pGnPZHiTejNuYmYpjbd6puGxWGK9ilt869UQMpaGukXYV+5jsbVfGouWJ
         ne1HV/mtitGhpioSHNzJiLVoJva5Z8M83UnwBzfqTIEYGoegjdGOuJWkEhKoXXB1SNVC
         YFa6m/3PD1UqfZyoF24sH9Ouy0WqeZ7m5P252nzLPVnbR255IyuFKCuegnXlKoD/sb6Q
         5OS41joBUa1ejDXRnK7rG+P6BFLjMJ7vnS6thiFIlKMfu1J7ELisS8QuM8Gp0zsxJ9F+
         g2d76zjddRBZWQRK3V08SOsYcgF/HgTKXlIXJcyQfMSGJoB9WRHMsu+QFQNMuHoclOoJ
         CSEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jNGC0kwLbNM3zCmg/9YNMH2soHfOD4RAVferOYuy8O4=;
        b=uG0/v+o+nLkc4zeYhY8OFUUP9XcTOtMDIZo6t9HCAcN+mUDw5WTaIaxA0iUEig6Mr3
         nZ3IEdKhR4rhIhEx1OtDpsWexLn20n6N0YzARDjkDiieTapOmZbQ/T278U9SeTK9iXsT
         L5P7gxA2DFS5y53UW+sXP8GUsPqSegypFfSUZIih8RqpYE76kDowpXf1CQNMdcYFoWY0
         /o17Cn5LZ0T40ay8AC+6J+ds+ghDG4d4ssfhFyr5z/o0VMQEePV8PkRlFv0J8Cy8sdOP
         kjJEgr8k9qUfkvwCsGHbjhMNDuHGgJfV09lxY8s4/VpfVtOn8/qmh1RK5+15jlWz2ZS8
         3iWw==
X-Gm-Message-State: AOAM5330/4Lj8pCCWLb0EKMLV2brWDQNY6n/QQ0Bz38kbkSg4YmJa8oD
        ZTNYIg3YXnaHnPpqp0DBWp5uitvM9RfubfLZ64oiBQ==
X-Google-Smtp-Source: ABdhPJyjLDrRWUJ1JQjnQx2AmwINC7mCGDtgvNC0Oc7DXaSPGV2NN06BZJOHtgMkgAkXhBanxA+I3fgVRk3y0MP+3s8=
X-Received: by 2002:a17:906:229b:: with SMTP id p27mr1835463eja.287.1615448109052;
 Wed, 10 Mar 2021 23:35:09 -0800 (PST)
MIME-Version: 1.0
References: <20210310132320.550932445@linuxfoundation.org>
In-Reply-To: <20210310132320.550932445@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 11 Mar 2021 13:04:57 +0530
Message-ID: <CA+G9fYsiskkTEov+W_E_QR0GbetJEz4i7NJtO_CBKLG71QJSAw@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/24] 5.4.105-rc1 review
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

On Wed, 10 Mar 2021 at 18:55, <gregkh@linuxfoundation.org> wrote:
>
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> This is the start of the stable review cycle for the 5.4.105 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 12 Mar 2021 13:23:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.105-rc1.gz
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

Summary
------------------------------------------------------------------------

kernel: 5.4.105-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 62f8f08c9d2fbc6c5692d90f64dd70e3a8edd986
git describe: v5.4.104-25-g62f8f08c9d2f
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.=
y/build/v5.4.104-25-g62f8f08c9d2f

No regressions (compared to build v5.4.104)

No fixes (compared to build v5.4.104)

Ran 53992 total tests in the following environments and test suites.

Environments
--------------
- arc
- arm
- arm64
- dragonboard-410c
- hi6220-hikey
- i386
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
* igt-gpu-tools
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
* kselftest-kvm
* kselftest-livepatch
* kselftest-lkdtm
* kselftest-net
* kselftest-netfilter
* kselftest-nsfs
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
* ltp-cap_bounds-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* perf
* fwts
* kselftest-lib
* kselftest-membarrier
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
* kselftest-mount
* kselftest-mqueue
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-zram
* libhugetlbfs
* ltp-commands-tests
* ltp-controllers-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-ipc-tests
* ltp-math-tests
* network-basic-tests
* v4l2-compliance
* kselftest-kexec
* kselftest-vm
* kselftest-x86
* ltp-open-posix-tests
* kvm-unit-tests
* rcutorture
* kselftest-vsyscall-mode-native-
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
