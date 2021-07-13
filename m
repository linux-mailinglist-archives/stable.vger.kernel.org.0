Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 611EA3C6B41
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 09:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234014AbhGMHdz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 03:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233762AbhGMHdz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Jul 2021 03:33:55 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D43FAC0613DD
        for <stable@vger.kernel.org>; Tue, 13 Jul 2021 00:31:05 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id dt7so9946566ejc.12
        for <stable@vger.kernel.org>; Tue, 13 Jul 2021 00:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=loyzxLfCnzl/ksLrRc8pjpRGLW5+1mWDiDb2yYTqTXU=;
        b=L7gk63dKJFwvM24S/o75hPqOYi2qPripwdQa9Q9v6l3yrX9oJPlMdJDGvazZdTM69p
         k49U+BPDzzDu7/yEdfS80F1PNRTcpOjGRHrT1B/PEZvMTnVmcx/1r931wOX81mtK0gcn
         rZ0MDzWu1+AaB3p0d8ppj1ga3dkSA3JGFg4Dk1bjpKYo4uT3E/bMQZF7DV4CQ8nQTwyR
         BHUtnvBXjOpp9NaE6gp+lAQtSk5zFIO8SHU7XD4foqDtrDfjH/rQVTaoktGj/11kciRO
         xrY6wVIAHRgeFNjEvbJCm0osRHAZuyH5IxuBN1WG2BFGf8E0Do6rKd1mHJMytmLXqp8d
         WGBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=loyzxLfCnzl/ksLrRc8pjpRGLW5+1mWDiDb2yYTqTXU=;
        b=VQP6rwcNAWwY0s+Z3bxDRGfq+bv3jApEFhhf+L2QbT8Krdt9yM7fW+I2lDeqcCJB/z
         pcw7LucPLns/MpCofivaptegN1ZrDSTwZwWd2nQD2Aa2ZK/r0OqY/l9EEl4v3teWGiIe
         oIrt+BhdJr3y8auP/YwEYcc7gU+yllJyYLUMMG26sGEOB9fSJwPMwSoZBJ6vXHhC3x/N
         Uk07U4TOMPYoKOc8JZBC/wBVP5lQFwijotkbZN3E6+SsRxUTDLmNYFDXErq7IzdHyn5l
         qQCNLWRfmznY+gG4i9HjTvsMsihMquxciYVMBpk8PF5WMGo2+BJIXnRQm+8V7bjBw9f7
         HlTA==
X-Gm-Message-State: AOAM532fJ01jqszH4GyQvBei00VOMGaEbXYW20k4lN1GktFVLWZWqJFD
        gE3EfLF6nAIpyn2FVOk3rFFJ7pk+qbsZvzLdGhi9bw==
X-Google-Smtp-Source: ABdhPJxzpxq6YqcySERPId+6YvGbQO3SCZBhQ+Oh6ZYgLAV21CaKEN+EpPcZ02+nxnWqTQfI0O90fsugAcglry6Pyfg=
X-Received: by 2002:a17:906:e97:: with SMTP id p23mr4028453ejf.287.1626161464240;
 Tue, 13 Jul 2021 00:31:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210712060912.995381202@linuxfoundation.org>
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 13 Jul 2021 13:00:52 +0530
Message-ID: <CA+G9fYtxwUrQGvv=uMwadPBWRN_MNhv+tEENJdVhq0H3w6CrQA@mail.gmail.com>
Subject: Re: [PATCH 5.13 000/800] 5.13.2-rc1 review
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

On Mon, 12 Jul 2021 at 13:00, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.13.2 release.
> There are 800 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 Jul 2021 06:02:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.13.2-rc1.gz
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
* kernel: 5.13.2-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.13.y
* git commit: 949241ad55a91465aea61c7afa51c1ec7540d5d7
* git describe: v5.13.1-805-g949241ad55a9
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.13.y/build/v5.13=
.1-805-g949241ad55a9

## No regressions (compared to v5.13.1-800-g0e69649203d5)

## No fixes (compared to v5.13.1-800-g0e69649203d5)

## Test result summary
 total: 84521, pass: 69640, fail: 1673, skip: 12072, xfail: 1136,

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
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
