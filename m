Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0EC6331E1E
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 06:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbhCIE7n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 23:59:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbhCIE7R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Mar 2021 23:59:17 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6002C06175F
        for <stable@vger.kernel.org>; Mon,  8 Mar 2021 20:59:16 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id l12so18100547edt.3
        for <stable@vger.kernel.org>; Mon, 08 Mar 2021 20:59:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NNsn0ufTvi2ZhdmZLPZ/mCVUGoeVfVXO8bsMlOKraZQ=;
        b=xcdYd9CWVObqkrOASccmMaIZ8RFtWwy5vhs2pCdLkc9ZH8p9QGMHu4IyKqEd2Gjvdu
         dC8y8QqY7JIZpqfSd+D1XBsnbAgrNmsCnhRyz7JddNyNP0/mrBG1CA0Mo+SbdFLR9GIq
         BLnUaeVWCguu6j5YnXLIJD4QRjQBP0OzCdu7K8icwXnz8RVeanZ1awFhl3o3xG1M/bzb
         ou/H1DhoicV9MZXu8TjT0AFYz/6NCBqdntJJotT/4YxdcOaDqILcPbUZfPlFFNTVgfjV
         JjqZeBHufAiJTuUPaSJng85nkxl7Ns+/XMwVf/z8ZNWvqPO4XmMsuRkXIQHSf2aqYpoR
         vhUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NNsn0ufTvi2ZhdmZLPZ/mCVUGoeVfVXO8bsMlOKraZQ=;
        b=MYynsU8pxGdIlFfOwr+eyJZ9GMVqxLgaO+69WrCPy5/Adh0eMFSOUGg1hKF6OIMRvZ
         V8ed9OsVDgM+17eZEHiwmTcQaBVYctVonY4n9/PWv83XdiH9V7m1WAaAtlWDJWNGsV0/
         4vtTh4sZy/lcd8Vxn545ZBnR7fnBL7dlKGowSCPgY6gqY8OEAm1Grn9duhEVVQRDnfNr
         sDxSkFvK9mrTCwiQF0FHBa/KpzFHzNJ5cmv42IMN5RVRFfxxB8IQIiWVWcvKtm2ddW0M
         ZQWPwUwfGfokhYFMRNRx7HptKbvtKy9WMmXgGvDWfgkQr72u76aEZK7BOrIMZ/7zel/2
         rvWQ==
X-Gm-Message-State: AOAM531eajzoAO79yInAYtO7x9/qnXTVTZqvBkPRrnuMVcYuWw6nJbTT
        Vyop3ldXiX3dG33soCmQid+W0x/t1rZC7dm/IGRV1Q==
X-Google-Smtp-Source: ABdhPJxWPym7XShOKgZ71XxnLgW+IYugTIrsXclVAT3z0F2KEkp3VlaPEtkKeRzo8Qtu2W+e1rb3CUQ9PRls/l+PSTo=
X-Received: by 2002:aa7:d287:: with SMTP id w7mr1970518edq.23.1615265955213;
 Mon, 08 Mar 2021 20:59:15 -0800 (PST)
MIME-Version: 1.0
References: <20210308122714.391917404@linuxfoundation.org>
In-Reply-To: <20210308122714.391917404@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 9 Mar 2021 10:29:03 +0530
Message-ID: <CA+G9fYupNTEE_o-wwn6eHaZRAPqPsHwLDkpsQTHz=tXf2_VAvg@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/22] 5.4.104-rc1 review
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

On Mon, 8 Mar 2021 at 18:02, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.104 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 10 Mar 2021 12:27:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.104-rc1.gz
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

kernel: 5.4.104-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 1d493929c06100abd14b955538afa461dc2c8b69
git describe: v5.4.103-23-g1d493929c061
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.=
y/build/v5.4.103-23-g1d493929c061

No regressions (compared to build v5.4.103)

No fixes (compared to build v5.4.103)


Ran 53363 total tests in the following environments and test suites.

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
* install-android-platform-tools-r2600
* kselftest-android
* kselftest-bpf
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-intel_pstate
* kselftest-lib
* kselftest-livepatch
* kselftest-lkdtm
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
* kselftest-zram
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* perf
* v4l2-compliance
* fwts
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-firmware
* kselftest-fpu
* kselftest-futex
* kselftest-gpio
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kvm
* kselftest-net
* kselftest-netfilter
* kselftest-nsfs
* kselftest-tc-testing
* kvm-unit-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-ipc-tests
* network-basic-tests
* kselftest-kexec
* kselftest-vm
* kselftest-x86
* ltp-open-posix-tests
* rcutorture
* kselftest-
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
