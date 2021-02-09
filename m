Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AAF0315152
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 15:13:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbhBIONi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 09:13:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbhBION3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 09:13:29 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79794C061788
        for <stable@vger.kernel.org>; Tue,  9 Feb 2021 06:12:48 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id p20so31723241ejb.6
        for <stable@vger.kernel.org>; Tue, 09 Feb 2021 06:12:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=o7r5VTOX4WdnX/SzPWDQXdwpbigYsu03P8j3XVKX7zw=;
        b=OZd6MNoz2jScekGV5bUxQngcHPV3hDabhbYgBggJW+T7ZMm7yS6j1IoL1hgO3saFju
         it29wzTd/ExjNEgFQ919Ps7grKLUvfrPtY+LSBwPt7C4SnG9Ui4908RU8Wo4ljS8uK5D
         XXtT9vv/4chxZqx3HJukMzMBwCF3KnCTm9y2lFXRP2fO5BKTB/+EknPSlvbdAwDQ64cL
         lXlV6J2gSwg9tNMXzKU9LImBoS3KpNV5kGmhrRXQrDFbs9HQiP5f/6cl5Fdcq2mER++a
         8vsw/1Uyj9fEwz3oDL/w3kOFgYNCBDNLbX8b482EiOw78wZ2bCUQbyzCRN0JoRyXFOUE
         aqgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=o7r5VTOX4WdnX/SzPWDQXdwpbigYsu03P8j3XVKX7zw=;
        b=Qf7835ZgGJJDUsYTqv+ika7cN7+oNKfYvx28mPt9kLcuB9A68p+N9lJ1VesmviXA4U
         kr8wLdcTsYJ4EpcFOKDlyHXPHBh0fulH6BgzZ899lma+4dN0yfvlHjhTNgeAMXlQtiuZ
         9AH/mE5u1cnpReP9j3hk2kra+ZX756btgzxM757UWNZiS69uuzUF0J6WC0Da+tpm8yp7
         HDCzZETzYAL8PQafHJPwhRKQR3lBVHLar+E3sDCSl3XDX0ManJHbKEbf2cnvU5coATOy
         GTgK1unUCHs1awFe+Sxfs5j80OPq9548o+pXRqIr0tcaNdQOmaZDArqHehvUt6PxVEkj
         6HwA==
X-Gm-Message-State: AOAM533fvIiHLpjR866upBJCc2I2ah3S5ZcDCZaYaLaSICe3/IHnYMZa
        NvHISVhY0IxXUzAQtqySscGgQu2fI0f77H7rTRz5UQ==
X-Google-Smtp-Source: ABdhPJyd72W7zAU+gYv4MhJQuAjN6uNzRBtr5oQY7NmOEhDNQffbrxx+UzXvTT8x2h50DpkR0DP05TtyrJThJO5Uwfk=
X-Received: by 2002:a17:906:6943:: with SMTP id c3mr8088460ejs.133.1612879966954;
 Tue, 09 Feb 2021 06:12:46 -0800 (PST)
MIME-Version: 1.0
References: <20210208145818.395353822@linuxfoundation.org>
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 9 Feb 2021 19:42:34 +0530
Message-ID: <CA+G9fYu5OOQmbogVtH7ASif06AZdizHM_4LRRMkOGDYDg5Dnbw@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/120] 5.10.15-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 8 Feb 2021 at 20:44, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.15 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 10 Feb 2021 14:57:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.15-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
When compiling under OpenEmbedded, the following error is seen
as of recently:

  /srv/oe/build/tmp/hosttools/ld: cannot find /lib/libc.so.6 inside /
  /srv/oe/build/tmp/hosttools/ld: cannot find /usr/lib/libc_nonshared.a ins=
ide /
  /srv/oe/build/tmp/hosttools/ld: cannot find /lib/ld-linux-x86-64.so.2 ins=
ide /
  collect2: error: ld returned 1 exit status
  make[2]: *** [scripts/Makefile.host:95: scripts/extract-cert] Error 1

This is because
2cea4a7a1885 ("scripts: use pkg-config to locate libcrypto"

This patch will fix the reported problem.
scripts: Fix linking extract-cert against libcrypto
https://lore.kernel.org/stable/20210209050047.1958473-1-daniel.diaz@linaro.=
org/T/#u

Summary
------------------------------------------------------------------------

kernel: 5.10.15-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.10.y
git commit: 21cc9754fccca82f1b3aae7baa6cddfdf4384802
git describe: v5.10.14-121-g21cc9754fccc
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10=
.y/build/v5.10.14-121-g21cc9754fccc

No regressions (compared to build v5.10.14)

No fixes (compared to build v5.10.14)

Ran 55235 total tests in the following environments and test suites.

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
* kvm-unit-tests
* libhugetlbfs
* ltp-commands-tests
* ltp-containers-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* fwts
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-mm-tests
* ltp-controllers-tests
* ltp-open-posix-tests
* network-basic-tests
* perf
* v4l2-compliance
* kunit
* rcutorture
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
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-lib
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
* kselftest-tc-testing
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-zram
* kselftest-
* kselftest-intel_pstate
* kselftest-kexec
* kselftest-kvm
* kselftest-livepatch
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
* kselftest-vm
* kselftest-x86

--=20
Linaro LKFT
https://lkft.linaro.org
