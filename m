Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBD5322050
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 20:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbhBVTlN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 14:41:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbhBVTlM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 14:41:12 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32CDBC061574
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 11:40:32 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id jt13so31275615ejb.0
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 11:40:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=b2K4+601JlQBwRzsBgNPHctuvMqlSDSENE5cSmeswoY=;
        b=XcYcbPBFw/kdAISJ4TOCzsdZp8PqjqWF28/04zDpXRfxLakS3xdp/dgum24oSNqwFJ
         tAFvxwQGCb7I8I2KMRZuJDSGEk3W8Kc0v071E5B/BVMl9UIlybq+KH+3U0COhnr4AIU0
         4q9kFPjZi8In/DYFMIuixA/8yWUll90MTv9p5ARp9yCucShg5GXjHZKCCISexUJKZ05C
         hXfDtdgrryh6uJhh90a4dGcD4sQ7MjO2siXHJzw3nwwaGt5+SDFn7k05+CzfHu55R6lJ
         S7PCnqjGHjqBpqq4UBl7+RfiyvxcXsi/aBh9oOpUScCjkFd6vOW0vzgHGuKVmMThcwZK
         COvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=b2K4+601JlQBwRzsBgNPHctuvMqlSDSENE5cSmeswoY=;
        b=HW4t01CKHlz9ks0CSbg/zDuBnXFCJD+2wvg9b83awYz4XxAjFJh/xeH+i42AkiSLhP
         BLmq2w5FgY6xc0WGn9QhI44yF8ZuJBS5XOAWfGZYJ/rsQsi9kekscxIsEnRoneJ8hPMu
         31BFtRjvO15nq6lr7nbZ3D3ah5eXVMDChGTYtdclGwiqdmLoGuHmt0qDq2jBmtX77DB1
         Nr6yPlRgbYF4yjJM2Vp18GCPFa4YA/ycknSfFbNxnHUHYMR3/aE7kmMKzvyoY0B2K/ur
         p0it/7sxIz31+aw6Hetrr2zg+zHRLaskOxdwxunJPQkTsnsKSg1h4cOz51xBBmG4KVi0
         jERQ==
X-Gm-Message-State: AOAM533JvOphMCKXACuKIiStUYWfry17Q4LzDQPfQH1e7m9J1FxUoZ6s
        yWXP+hqDI4iB/eQb6CrAraMjESVIK00ffdShr5wktg==
X-Google-Smtp-Source: ABdhPJwwREW3hdQAJRU+vH6xlBqebKFFQ7dT8FNSQr7qrLhPE59yq6USTJQ0uDEhlNqacnnBHW64blrz6FYDYVugLog=
X-Received: by 2002:a17:906:444d:: with SMTP id i13mr21753229ejp.170.1614022830820;
 Mon, 22 Feb 2021 11:40:30 -0800 (PST)
MIME-Version: 1.0
References: <20210222121013.586597942@linuxfoundation.org>
In-Reply-To: <20210222121013.586597942@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 23 Feb 2021 01:10:19 +0530
Message-ID: <CA+G9fYvky9VTyPeOqnDBsNzP_to-+uCisCpLTiUoJTCUtsPvfg@mail.gmail.com>
Subject: Re: [PATCH 5.11 00/12] 5.11.1-rc1 review
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

On Mon, 22 Feb 2021 at 17:43, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.11.1 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 24 Feb 2021 12:07:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.11.1-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.11.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
1) We (LKFT) have upgraded clang-10 to clang-12 builds and following
three new configs enabled.
CONFIG_CC_HAS_ASM_GOTO_OUTPUT=3Dy
CONFIG_CC_HAS_ASM_INLINE=3Dy
CONFIG_HAVE_KCSAN_COMPILER=3Dy

2) on qemu_x86_64_clang-12 a large number of LTP tests reported failures
on stable-rc 5.4, 5.10, 5.11 and Linux mainline.
reported link,
https://lore.kernel.org/lkml/CA+G9fYuE4ELVDju=3DLESHnphL4Z2DT5YQjdh9rNgr5D1=
x5gZxgg@mail.gmail.com/

Summary
------------------------------------------------------------------------

kernel: 5.11.1-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.11.y
git commit: 6380656c9227c27a989f750aa7a0c81039d28607
git describe: v5.11-13-g6380656c9227
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.11=
.y/build/v5.11-13-g6380656c9227

No regressions (compared to build v5.11)

No fixes (compared to build v5.11)

Ran 52054 total tests in the following environments and test suites.

Environments
--------------
- arc
- arm
- arm64
- dragonboard-410c
- dragonboard-845c
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
* kselftest-lkdtm
* kselftest-rseq
* kselftest-rtc
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sync
* kselftest-sysctl
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-dio-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-tracing-tests
* perf
* kvm-unit-tests
* libhugetlbfs
* ltp-controllers-tests
* ltp-cve-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-ipc-tests
* ltp-sched-tests
* fwts
* kselftest-intel_pstate
* kselftest-livepatch
* kselftest-net
* kselftest-netfilter
* kselftest-nsfs
* kselftest-ptrace
* kselftest-tc-testing
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-zram
* ltp-syscalls-tests
* network-basic-tests
* v4l2-compliance
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-firmware
* kselftest-fpu
* kselftest-futex
* kselftest-gpio
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kexec
* kselftest-kvm
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
* kselftest-vm
* kselftest-x86
* ltp-open-posix-tests
* rcutorture
* kunit

--=20
Linaro LKFT
https://lkft.linaro.org
