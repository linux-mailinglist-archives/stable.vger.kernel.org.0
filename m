Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1103A75EF
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 06:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbhFOEeg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 00:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhFOEef (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Jun 2021 00:34:35 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 781A5C061767
        for <stable@vger.kernel.org>; Mon, 14 Jun 2021 21:32:31 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id g8so20213836ejx.1
        for <stable@vger.kernel.org>; Mon, 14 Jun 2021 21:32:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mFmkMOtTT5Ca5YN3hGAb6SzYhnTwaRHsH7DlxB176MY=;
        b=vlQ4MQxwZ7Ofoy+49dOjrABil9hMC6Is/naxF7TWdv1M/wFRYPm+56V7rDI/SBMgv6
         wV+71Sw0Cjp3nrIkbEIETQCFMMDezLm8+tgLiTmnEK3OkTpLPpOaYJp2YAyIpTwGkmER
         hzAx4+Vft7xn7B9pTJ8o+3EN57mx4cwLOQpB9ceVVwnop2uiWot9iCYvGe0wR9j7tQp1
         /PfSnZdizyo4B+tpx+UEcNWUBhnrTeA/kSRt0weD9s+v7Af78ao1dsjzKNhE9ymxXH9l
         ORfYVQPalLKNaHionX3MIjMnZHM3cjArh41j8zluyE8xVu5NJnFtBacg4Cy04PtUxson
         Zs1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mFmkMOtTT5Ca5YN3hGAb6SzYhnTwaRHsH7DlxB176MY=;
        b=csTd6NPBJ7keAy40PIsDgG2UYOixLLo440JTJZjde80UOLxdLmzLIeDEIkFK2C6nei
         9kklZzgeknFsomSNdqZYQQEWkxhjwWdx7qy/5F0em0o0IkuJ4C7qHzHHhONYG+A/O2Ip
         w/z5KTn1EVEtRCZQyyaT6uo5Pup1DOHFPTsYEc9Rwho9QQZQcqeK2UD75cTZXu5pf7Ir
         FLKrxnLfEAfBo0899yflBzN6tUe6fva6+SpqfNPRfWCWx7Bsqq/1UN1IIwcoTcIa9VQA
         26QSjhv5jXRZ+XpoiJu3mGHcOjqmU2dCvbXBfGiqqZVSEJrPG8j6ZqyT4V5g+o+7Kuuv
         9lhg==
X-Gm-Message-State: AOAM533FGV/Pw1wSaOAoe79nVb0h78quHTNF9jyZg4eiP7ff2RkJGcBc
        PdpZV1XxrREhStSp2ZGAPvZPyf3QJBOMX2HpEni7Mg==
X-Google-Smtp-Source: ABdhPJw2NvYByN4yjGVcgVri3outm0ZWfpRh9mbaVarb6ZMKEqd0MaUbpVvA/4Yj0Fl5StaewkX3i5V+tOls2hDTv+M=
X-Received: by 2002:a17:906:25db:: with SMTP id n27mr18250507ejb.170.1623731549733;
 Mon, 14 Jun 2021 21:32:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210614102658.137943264@linuxfoundation.org>
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 15 Jun 2021 10:02:18 +0530
Message-ID: <CA+G9fYv9V5h1e_JW+CmK2cHZaDt5JC+fZdom+-DqYMKeQ-eqzA@mail.gmail.com>
Subject: Re: [PATCH 5.12 000/173] 5.12.11-rc1 review
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

On Mon, 14 Jun 2021 at 16:18, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.12.11 release.
> There are 173 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Jun 2021 10:26:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.12.11-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.12.11-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.12.y
* git commit: 38004b22b0ae0ed236de37f13b323c9d89311f9e
* git describe: v5.12.10-174-g38004b22b0ae
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.12.y/build/v5.12=
.10-174-g38004b22b0ae

## No regressions (compared to v5.12.10)

## No fixes (compared to v5.12.10)

## Test result summary
 total: 83712, pass: 69169, fail: 1865, skip: 11956, xfail: 722,

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
* prep-inline
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
