Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE2DB3545F5
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 19:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237578AbhDERVj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 13:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237464AbhDERVj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 13:21:39 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD495C061756
        for <stable@vger.kernel.org>; Mon,  5 Apr 2021 10:21:32 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id r12so17813885ejr.5
        for <stable@vger.kernel.org>; Mon, 05 Apr 2021 10:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IXQ9NqG6Tt5Pe4reuledmIffXjGOsE+SSrfZAgUcvhI=;
        b=oq/mJBO1nhi5C64fkN2PucUadzU31M31IP127ATnyAkvDQaVQUkeF64LfzpK+xilOg
         A9kJkSWHFkm4MiWP09BEWchQCo/YPu/XhTOU2EtaAZyqFBUGyxmuTaK/jBv1xAxIOETh
         UFU6yO5y+jPV7Sl9Ni3mEFauho6AbVgJCkSk0Z+9SM7CSuI1RQEP9Sa5geru5V73rRcp
         4qlMACmB2ATNaD5wnBTIdxhK3JHoGuZnz9KPTXDRPKvMIItXMPXBW+WJ+v15FxUEPWRK
         w8LjV1SrVPWhIyyrKHtk7NfIW7vWzLEAcCvqUEtTFXFw/9rZ1hhebN1Ro6JNjzOGzop1
         hk2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IXQ9NqG6Tt5Pe4reuledmIffXjGOsE+SSrfZAgUcvhI=;
        b=to5oNefnhF1zFaVipQMCoiuvql3EWnLmx+8M2rVfL3yJiew5F9zxIH4MrQJQNk3etX
         y7RObZzx2nfhfjsgLDw3veIb9Htsg0X/TMADkvGTADM2beCGKC/69ARi+WyFY2b6NO7S
         q7lPDVDdSZzpR01XhwGcoUb3BMBqAs0Yypr3gg4kHDHs+Aryxdf+IZ/pEa8tJwWkdwHt
         /ecyz33wG6yIBUW8O1YjlOIjSvzpe4wkvvBLAvovOVLB1ySoj/Rn+ajWL5+uatQ82WVH
         IMOCWof7n18pDpcpkZ5jsqvJauCJZrvALPtPrfw/8HblQavXfpT9ti/hGe93H+qOP9A0
         m3UA==
X-Gm-Message-State: AOAM530RIRp85vJe10+a9nMHUpH0tYSapB1TBAnXdxEFtQtgI5B05Oq0
        apeHRCYowgjYkOc+ZWwAIJsdU/vVB8tnuZtxeGnRVg==
X-Google-Smtp-Source: ABdhPJxT1NshyPaLb1M0x2V+YQ5+Iwj1JWUSVu3xdjMRcCAxowMJQg1grpPQdSrkG2ShtH/V7qeB6FRjpLc3lv32QSU=
X-Received: by 2002:a17:906:a052:: with SMTP id bg18mr29584552ejb.18.1617643291296;
 Mon, 05 Apr 2021 10:21:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210405085034.233917714@linuxfoundation.org>
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 5 Apr 2021 22:51:19 +0530
Message-ID: <CA+G9fYtt0XFfqut+ZQCsvN8UPS_9J8ATLPtVq=da6FkJo_zLPA@mail.gmail.com>
Subject: Re: [PATCH 5.11 000/152] 5.11.12-rc1 review
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

On Mon, 5 Apr 2021 at 14:43, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.11.12 release.
> There are 152 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 07 Apr 2021 08:50:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.11.12-rc1.gz
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

## Build
* kernel: 5.11.12-rc1
* git: ['https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git',
'https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc']
* git branch: linux-5.11.y
* git commit: 74f1df3016246d321c3f58de40c0d64f5d5861a1
* git describe: v5.11.11-153-g74f1df301624
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.11.y/build/v5.11=
.11-153-g74f1df301624

## No regressions (compared to v5.11.11-105-g79c43dab0491)

## No fixes (compared to v5.11.11-105-g79c43dab0491)

## Test result summary
 total: 76190, pass: 64219, fail: 1734, skip: 9997, xfail: 240,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 192 total, 192 passed, 0 failed
* arm64: 26 total, 26 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 25 total, 25 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 42 total, 38 passed, 4 failed
* s390: 27 total, 24 passed, 3 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 0 passed, 1 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 35 total, 34 passed, 1 failed

## Test suites summary
* fwts
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
* perf
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
