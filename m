Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBBAB322449
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 03:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbhBWCuT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 21:50:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231534AbhBWCuK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 21:50:10 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83EB0C06174A
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 18:49:29 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id u20so31661453ejb.7
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 18:49:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CfI5Orzqpl0UFRDRtAf3SjN4CK4rVpdEg8l0nOy7egc=;
        b=yzkZjIj15C+3y3OOFo/YbE9xfibE8DrNCs7ATl6kirtfoC6WAp7BjpWeaVZ6ruhEMT
         tutbEsFT/gVG4FMJ9GOmelvpVC9Uytz/7vTlTPctN/Xyyk+2Elf7MxhkhLELPpu2HGoS
         SJR3gPsLy4MrSaJxizMuQLVT/q8evyGZjgYEHC8Ig9OsNdhlUHJ+3O9yzNefYAfDF0fd
         icCkdBmJr5yMNV3CCWYflhHWhLc48e9ncSuPDSAJjHS0ND7acv6fRI1m/1tgEs+CKS9w
         xKzTiO+Wm9JWXNTn55L00SnivA/b76OkYWuyETf8ARHn23fLuL9d0PSShwUMsjITafc9
         rLDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CfI5Orzqpl0UFRDRtAf3SjN4CK4rVpdEg8l0nOy7egc=;
        b=qmJHFFyZzSKhpIeHPaH4wNJSDEMDOgp/tYBees5XGwA/P4lsHhsUcdeUyRemHCPhso
         J8cM6QgmQYrkNvJa+YAbPJBfVOwL1Yzstj2sBswXdrf2+ZBogwHsTbcbLjzyaWZ+Vuc9
         3kIU9487lnLB417sntmalFIihBPy2RCAXljtQOHM8SCpbTqNR1ZCCvBBek6UZPBJ2vZb
         5XwSPur9XnawUm63zgZ5yAwYWLSoSgNQTBpyohG1Khn+F9Zca+TgFOlURd4KAo+fJzj7
         6n8UFf/nBVimKK5wmfENMp72VSGqzksgm9mjN3byv1PgKgRdU6MscKFn3o/0xpqds3Gg
         hh9w==
X-Gm-Message-State: AOAM532tlsuKaFAW9extD8fHi6meBtzxGS2nw2MXWRAz6PqFc3YCNG6V
        SqK3ouTCQqK/gW9kwY36p9g+TTGtEtKPBQPUSNRGnQ==
X-Google-Smtp-Source: ABdhPJysFwLWL3u8idc5E/Lx7XKpE3tW2+JCHlZXQcrpLVrMOv6Ua5cA9UrM9un4si6wAjiLnaQRCB+sxuJN+Yn/Ymw=
X-Received: by 2002:a17:906:d8ca:: with SMTP id re10mr24078192ejb.18.1614048563015;
 Mon, 22 Feb 2021 18:49:23 -0800 (PST)
MIME-Version: 1.0
References: <20210222121019.444399883@linuxfoundation.org>
In-Reply-To: <20210222121019.444399883@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 23 Feb 2021 08:19:11 +0530
Message-ID: <CA+G9fYtJCkE=XGb9mzU6-G4WWG+MYMm5NitjWqFSSAZx=-Ckdg@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/29] 5.10.18-rc1 review
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

On Mon, 22 Feb 2021 at 17:44, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.18 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 24 Feb 2021 12:07:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.18-rc1.gz
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

Summary
------------------------------------------------------------------------

kernel: 5.10.18-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.10.y
git commit: 905cc0ddef721db27341d7ca4f85bbcd82bbb6e1
git describe: v5.10.17-30-g905cc0ddef72
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10=
.y/build/v5.10.17-30-g905cc0ddef72

No regressions (compared to build v5.10.17)


No fixes (compared to build v5.10.17)


Ran 54290 total tests in the following environments and test suites.

Environments
--------------
- arc
- arm
- arm64
- dragonboard-410c
- dragonboard-845c
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
* install-android-platform-tools-r2600
* kselftest-
* kselftest-bpf
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-firmware
* kselftest-fpu
* kselftest-futex
* kselftest-gpio
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-lkdtm
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-zram
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* kselftest-android
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-intel_pstate
* kselftest-kvm
* kselftest-livepatch
* kselftest-ptrace
* ltp-dio-tests
* ltp-fs-tests
* ltp-io-tests
* network-basic-tests
* perf
* kselftest-kexec
* kselftest-lib
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
* ltp-open-posix-tests
* v4l2-compliance
* kvm-unit-tests
* ltp-controllers-tests
* kunit
* rcutorture
* kselftest-vm
* ssuite
* fwts

--=20
Linaro LKFT
https://lkft.linaro.org
