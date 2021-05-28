Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4E4393D0B
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 08:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbhE1GYW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 02:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbhE1GYW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 May 2021 02:24:22 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E21B3C06174A
        for <stable@vger.kernel.org>; Thu, 27 May 2021 23:22:47 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id jt22so3656045ejb.7
        for <stable@vger.kernel.org>; Thu, 27 May 2021 23:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hZG+K5o9x93608ffGiO2O9Ngv/oiNofV4zjyg74md5k=;
        b=QzQjFN9gxYe1wOtfY73V1aFqAd/0OGyHo7JPgM4uCoHhui/jHJFbqE0K0F4HiiF5eg
         I5el5Fv3VFvR/wZOc9gR017FPTNzuzxbGVfvnFDe5G68q7N1Ztccq5sOvudQCAn+eOGA
         1kCfP85tcSWhbab5FWiLw47XTXa4moF2k0Dkg3UyheQfqq+zRif7VkcxjDpBSXReSyPV
         IAl2iTd9ETItZwG+wgt24aMrFxfaLEd0QNQ6lqq/3m1k9LogB4CCyVVsnrp+P4Sbju8Y
         /5qzxuRFUBbjlP+JOpaq3tS815XTvWAajnHLHFgUd16P2qT9PjbR8daeI9/VVMe+fRug
         8YiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hZG+K5o9x93608ffGiO2O9Ngv/oiNofV4zjyg74md5k=;
        b=T/1XmFdBfPkNCflA6ubSFHprePkVnR85OgDSUFE/lDnCY0y6+Y5HNm5ed2C9nowtRa
         Rw1z3KkUK9tWj8uVt/1/IchBW8bwXfV3xSQjmFo5AkI4vgt1LuyDNVa4iu4+SgyHRhCw
         r1dkUO8o345QYQKuPcvXLTskNAlArH2yIGvHprFyBVVy3+Gf+wsBhm8LFBGJsXBs0rXd
         ShkpgrBwhgg7iDG8+OB9M4X619DYnaX5ESn08jhPbn3OoLIfbVnlYgG/p1XpFyOLN3Am
         DcBAv74Wltoh2/dJMNu/Nn6LaJHkghaARTQm+GU0+RUwawbkv7mAYSrbwN0nWYqxhRrm
         wiWQ==
X-Gm-Message-State: AOAM530UDq91S98b3ZCqbrjyotzbBWyy9SucbizeSk4OTx+drXFclnyk
        LKFG24Xf0MPftlA/sqUjHZsEy/hB1QI5a2hiNfRZyA==
X-Google-Smtp-Source: ABdhPJwSRHmAcY0UCICO1Np4fXcde1DpMd+W6fvPIBm31r1yRnjRKQVkc1c3255Db5m+nKHx1gciOgN3/y84TitM/TY=
X-Received: by 2002:a17:906:c211:: with SMTP id d17mr7572074ejz.247.1622182966154;
 Thu, 27 May 2021 23:22:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210527151139.242182390@linuxfoundation.org>
In-Reply-To: <20210527151139.242182390@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 28 May 2021 11:52:34 +0530
Message-ID: <CA+G9fYuk3Q0x4_LiFZQv96D8hYWcs3Vdb7bKEgJn6BkmrdnwOQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 0/9] 5.10.41-rc1 review
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

On Thu, 27 May 2021 at 20:43, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.41 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 29 May 2021 15:11:29 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.41-rc1.gz
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
* kernel: 5.10.41-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: ec1cc3ee7be23032bad8bf00052c9b75fdfe9971
* git describe: v5.10.40-10-gec1cc3ee7be2
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.40-10-gec1cc3ee7be2

## No regressions (compared to v5.10.40)

## No fixes (compared to v5.10.40)

## Test result summary
 total: 78784, pass: 64361, fail: 2504, skip: 11224, xfail: 695,

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
