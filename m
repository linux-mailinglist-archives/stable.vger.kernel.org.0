Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE73C3C3418
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 12:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232433AbhGJKYd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 06:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232387AbhGJKYd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Jul 2021 06:24:33 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75A4DC0613E5
        for <stable@vger.kernel.org>; Sat, 10 Jul 2021 03:21:48 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id l2so18012473edt.1
        for <stable@vger.kernel.org>; Sat, 10 Jul 2021 03:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OsB17046kAGFUij38FDSUBpfXfT4eFoHXsTibPpT9vw=;
        b=CnmFiNsS2uUZ11MkMM4duy/de2N5uQAKS74GG2kvOewrNZf+gLhzD45NSwWXDXs+Lu
         nP9oFQNaWWgO5yqWQWVFNiRL93nvgFLOmMGVqStmvc7x9BuV9aus0NgqTjHkFf2j+/xI
         K9q+iiTSalRQsdSOtvLoRqLbOXp20yxeWu+VevNG+Hw3MvxlQln3/WG9rNTdeibxER2x
         BArYMmdGHtsgRcCdhISeLsHvYLEMAFL8QoA9zMEvCcLOAA4K+PUmCdgyEPP5rotAJfMr
         WeM65jwOLl/ARpYqaaPU5pwtaZ4FD3ztP0rg7jLbgYT4hEVG5ugJikrGOtp1KBL+gNhs
         IIQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OsB17046kAGFUij38FDSUBpfXfT4eFoHXsTibPpT9vw=;
        b=GRfeF9zGjC69QUHbgZFBZQBhIE4pETW9Qt2yWqhmlkwYwdmInv1mx6jzefK+GLgZdb
         mv90EAaluQDlulTKj7ItzNOpr2/A//qVQVenvuin0Iqxfl9vKsRRqxHVjQkT9rXX3oXh
         lA8NQtdxPa5HA+UB3Fsowewld4I0tzzUtAXkminFhuRws7YzIeyPyZfWVUYkqLdulM/K
         4INU3fptj9ewJzmwxmqGiCTZTCwrJsKBlEvPErgufG1rRKhkh9No2kuRo3keYpk0EVWR
         h1V9yL1mVZbWiYYDCdICPB9FX7j6XfPWa2DHGUB5cf5yLiJKhi4NCao6+b2Qvw6DmF/W
         11jA==
X-Gm-Message-State: AOAM532vFbpCiwvs55TxgwbhB9JpUWGZhQcDDwgY/nAviBdBTqut3n5p
        apvcKvDun+PbsvlxBdnAJ4BASSCBhv/zPlcRL7PweQ==
X-Google-Smtp-Source: ABdhPJw+4ngycHeXgGGR9OaIQ6knRR1IRKFPIlmIljKcYASPGRhjKVvzfUTU/dVZIVg6fkAOJFFc7F66B91/e4NqMBE=
X-Received: by 2002:a05:6402:90a:: with SMTP id g10mr52999706edz.365.1625912506668;
 Sat, 10 Jul 2021 03:21:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210709131537.035851348@linuxfoundation.org>
In-Reply-To: <20210709131537.035851348@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 10 Jul 2021 15:51:35 +0530
Message-ID: <CA+G9fYtf2Zhxp0oQc_7WTyMJ=m5C_PWPwSs+mKoYHORXvmi5ZQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 0/6] 5.10.49-rc1 review
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

On Fri, 9 Jul 2021 at 18:52, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.49 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 11 Jul 2021 13:14:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.49-rc1.gz
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

## Build
* kernel: 5.10.49-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: 5b40bcb16853d5fa948446202f43ea3fbcc14f33
* git describe: v5.10.48-7-g5b40bcb16853
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.48-7-g5b40bcb16853

## No regressions (compared to v5.10.48)


## No fixes (compared to v5.10.48)


## Test result summary
 total: 80634, pass: 65802, fail: 2163, skip: 11403, xfail: 1266,

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
* x15: 1 total, 1 passed, 0 failed
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
