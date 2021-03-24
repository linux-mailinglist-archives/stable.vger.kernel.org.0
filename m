Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B719347FDA
	for <lists+stable@lfdr.de>; Wed, 24 Mar 2021 18:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237348AbhCXRya (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Mar 2021 13:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237316AbhCXRyW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Mar 2021 13:54:22 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 508DFC061763
        for <stable@vger.kernel.org>; Wed, 24 Mar 2021 10:54:22 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id o19so28634067edc.3
        for <stable@vger.kernel.org>; Wed, 24 Mar 2021 10:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0O3XVWgr0o1t2JRQjNX8lAcMEj47llKGhs9kF4uAMek=;
        b=obMYZ+6maCFpxGHBiuUAfhkIVHbEV6FgPDliUGCIWFbA1JLhAFmcKjE2chAByr1uO4
         fEOnNLHEmATymbStksqFHPWasMm21+oKUeB4otW83/6BGMBC4UWP6W1/yFWdcuIE+KUt
         es2Mffq9vNRvfWqybwksXGHIiUtWHyusnSA3eESpE5xsPagHKpnLGiEc6X3ao7+tUqpL
         7/dSwphDqe2mobXY8ygB00/oEtnYcAmjybfQosKvVgQhMMeTyB7ZF5nXj8z0aHJrr0Kb
         P7FNBC4JfUh/FmWkm8OMr7mwo1XzAnlG5CfIESLBu9vGcJWo6CLXMTRF4ZtkA6wLLg/G
         KNsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0O3XVWgr0o1t2JRQjNX8lAcMEj47llKGhs9kF4uAMek=;
        b=oudErV+ZdHsxNTE4rr/bJGmN4gWuGtTzhCCEZ+iHZf92s3vQDGkJk4mI/DPghPll9c
         CgAIXOlXku+3jf0ITs1Ka0CsTXOvXTZtd9YrM3379P8RvIYwwWcV22EnFCcw4WomSRW9
         G/d5tLk17BtUqLdnuFP2n2pkfdAZsW3c89XeLxxr8WLfelWX6rGfOCHxxDIAf5By0/zR
         ls4Zb63o4K+GI/Jg7qgnO4mNjRDTzBn7ISRk+Hq9CNg4KAtjZfrURhIi/SGoJQEMlrT+
         n3H7SdASTqUU9KYOJ7bS9PMbetDKWrFCaplIvO94IqIcF1cyynNcQWWY4fp2G1c/qq+d
         syhw==
X-Gm-Message-State: AOAM532kextAMnbQl91cmfAFZxMNy4NLntOpnhBo2MNlM1PejzTbkIgj
        h0tKkTpByRaxFYljkC+fi8NMq/iEy2Io1HF6Y8c8pw==
X-Google-Smtp-Source: ABdhPJxcpK4W6UasRvlPuOOUwwrlR/ykkPKVRlwUAhjWYubVTQH17b99pV6T6tTPfonfUY/VcH2xBA5okEE2suVwvZM=
X-Received: by 2002:a05:6402:13ce:: with SMTP id a14mr4778417edx.365.1616608460865;
 Wed, 24 Mar 2021 10:54:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210324093435.962321672@linuxfoundation.org>
In-Reply-To: <20210324093435.962321672@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 24 Mar 2021 23:24:09 +0530
Message-ID: <CA+G9fYvYrY=FgN5gZYkTvwGfG++_GBJ7u+BWNjmp90kxtmKO-w@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/150] 5.10.26-rc3 review
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

On Wed, 24 Mar 2021 at 15:10, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.26 release.
> There are 150 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 26 Mar 2021 09:33:54 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.26-rc3.gz
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

kernel: 5.10.26-rc3
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.10.y
git commit: f6bd595b6fdae1933a752242cfb77a1a0bc3117d
git describe: v5.10.25-151-gf6bd595b6fda
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10=
.y/build/v5.10.25-151-gf6bd595b6fda

No regressions (compared to build v5.10.25)

No fixes (compared to build v5.10.25)

Ran 65251 total tests in the following environments and test suites.

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
- qemu-arm-debug
- qemu-arm64-clang
- qemu-arm64-debug
- qemu-arm64-kasan
- qemu-i386-clang
- qemu-i386-debug
- qemu-x86_64-clang
- qemu-x86_64-debug
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
* kselftest-kvm
* kselftest-lkdtm
* libhugetlbfs
* ltp-containers-tests
* ltp-dio-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-mm-tests
* ltp-sched-tests
* ltp-tracing-tests
* fwts
* kselftest-
* kselftest-android
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
* kselftest-zram
* ltp-commands-tests
* ltp-cve-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* network-basic-tests
* perf
* v4l2-compliance
* kselftest-bpf
* kselftest-kexec
* kselftest-vm
* kselftest-x86
* ltp-cap_bounds-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-open-posix-tests
* ltp-syscalls-tests
* kvm-unit-tests
* kunit
* rcutorture
* kselftest-vsyscall-mode-native-
* kselftest-vsyscall-mode-none-
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
