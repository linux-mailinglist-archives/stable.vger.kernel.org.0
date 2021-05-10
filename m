Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66030379849
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 22:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbhEJU04 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 16:26:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbhEJU0z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 16:26:55 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8878CC061574
        for <stable@vger.kernel.org>; Mon, 10 May 2021 13:25:50 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id j26so16563615edf.9
        for <stable@vger.kernel.org>; Mon, 10 May 2021 13:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=F9XsT5hBAtjR+cllhpzT7Fpo7FEhxvpGbm50HALgfk4=;
        b=cBwkRg0CUiOA5r4bXrcnTLAXJNuQ5IBPf33t+JKWJ0Mq9MXreTJom6XnO3s9mGMCx8
         QA5OXbIT9fWIAs7XhumQYjg3TIK0ilKHkvn4n/yj5OqkI+FsWzZafjEfJOGSnOiq1iUe
         AIJ/rgFYNBFWFoDSGQtz5/uCMZ9zgov4dWjbIltWWFbyytZrzmUbjjv16cq8q4Tatl2G
         FpmrZxLCN1tOJ7eC6zP4+ajlgJ3UHWatLu/mT1XuB1ifphrRs/DNzchYTjX7KrNPcToR
         ftu5v6GuF/iATMVfLk3vnNNEviCX5XidPaoCdFp68S1oTRebdK4DottsQd5VyFAJAFYq
         yrog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=F9XsT5hBAtjR+cllhpzT7Fpo7FEhxvpGbm50HALgfk4=;
        b=tboovA8mE7zojL66a6c3g23Xeu3Jnefi1Dp57WdyH8IJGl8wv41X9jWK1kuuZkmFxn
         /J+7424tmM5iotKlY5RGXgjm5KIXIlBC/YctDad4BLfZMo64my7N6j0FeKgvA1BDJpAi
         mYnJAH4Hj0SezDSL1b6OCnNo+nbILjXaieFCsyifCAX9VWmpsXKq4WCXXJ1DfPjwoZ41
         8DgbHJ923JhacMgqYCmbK0Tn2iRMzCB4xsRhD7NQWh5ExCqXyOUeFNTf/FqD/N2mW78v
         BB6/CGASQcexPsX0D8aCT4OAd+bWl/rVyfVtH91zCRWtOulGXj5QYICO3lya3tf61xVq
         Yvyg==
X-Gm-Message-State: AOAM532hvjozHj92NTNuDqlECGltT8rNHIDAcJu6no1IdPslLQRqnGCx
        9d9lEzXHxnUCV1ZSg+TdmFlp+ulpmfQJ2QVu8woV7A==
X-Google-Smtp-Source: ABdhPJwrgch9adtXpwlW74y+pDWwMxWfa7lQm77Ez9wejvwOcz8CAI2+aCGwWjHWycu6jHkNIE2RflKFyH4qs9ijIe0=
X-Received: by 2002:aa7:c349:: with SMTP id j9mr31138778edr.230.1620678349003;
 Mon, 10 May 2021 13:25:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210510102010.096403571@linuxfoundation.org>
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 11 May 2021 01:55:36 +0530
Message-ID: <CA+G9fYug2C5rD6nMw88=SZH1okNJJcfAdKSWnFL3c0O=Vgb-tQ@mail.gmail.com>
Subject: Re: [PATCH 5.11 000/342] 5.11.20-rc1 review
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

On Mon, 10 May 2021 at 16:14, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.11.20 release.
> There are 342 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 12 May 2021 10:19:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.11.20-rc1.gz
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
* kernel: 5.11.20-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.11.y
* git commit: 44eb32ead9ee049c1d607d49a1eea51e191dbaa6
* git describe: v5.11.19-343-g44eb32ead9ee
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.11.y/build/v5.11=
.19-343-g44eb32ead9ee

## No Regressions (compared to v5.11.19)

## No fixes (compared to v5.11.19)

## Test result summary
 total: 78342, pass: 64452, fail: 2356, skip: 11275, xfail: 259,

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
