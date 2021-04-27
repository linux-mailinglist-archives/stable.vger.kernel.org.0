Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD95B36BF54
	for <lists+stable@lfdr.de>; Tue, 27 Apr 2021 08:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbhD0Gek (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Apr 2021 02:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbhD0Gej (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Apr 2021 02:34:39 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59EB3C061574
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 23:33:55 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id u17so88028139ejk.2
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 23:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wQeJBb7P4jzMbZiET0RLzM0TgJeA/ZRBKtgvbmIz7yk=;
        b=ZnNu+WHk19FwZQHmqUr9ntjobqH95rc+XrcRuiWSPbalYsu+tigc/l8LnBiaYPSeX6
         +HqW9BMxBddX67udcEfM9xMdoijFMib5X+6bnFs9d3myGl+2i/xQB7e8DC8GXcw2Cbsp
         zdB9uzBia4o9F1CFfGk+GhQjngZh9fN6y6P/jgS0PHLXqY7v3wE4saw/oIIZlRBDwHam
         7s/UcTNr467fl7EOHrcKeHdoJ8Ar9vg31oQxrFHcRi3wCSVDqKUhyMI+x7C1KA55Tw7V
         Cg9JqIf8nYT72oC0jwKnreSIsB0NB5KS2wMec0uDlMWQ8nhtupjMAQIndGcrB4sFTfTV
         /O4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wQeJBb7P4jzMbZiET0RLzM0TgJeA/ZRBKtgvbmIz7yk=;
        b=JgF3zXu2p9QBf9PJaEa5SRvLFgMXw8p0+SkieGnSTBqFd82MBexwxVGuL28rqhIxO6
         HA/4WswvSfW3mt6quHbLb2LDT8Wmjr7q26jQ1l31yr+t1ZIOh7hfL2d0uiDn5KTFYYYc
         RurvLoNOKDeiI2yktdfbOm2N8J0mZuMYsnaeaXWvhVr0BWO5oZhahgWwl7ZNyAP62FIy
         egwH9C4BiSKPLWbG9/1wo2I0/lT31FDRjvbTrPnUVwfQ+e8M/rGSumHYsybT9+Y1VURN
         hHgMM8RvF4fx7GgAGtBmnV5YEvHXyRsTpfEyim/H62xE7SzXA7EoVDQ2eB0Np1vMd+K3
         vGKg==
X-Gm-Message-State: AOAM532XRBQNcTwzPp+P0fnfE0SSHDEWI7P1g1Bn+qDU7zwF447xwTHE
        /+zEJ/r68M3RiDkEndl0Mjapiyz7K/ClX1Vh/mlJ3h3TUbxln40d
X-Google-Smtp-Source: ABdhPJxc4N2oxU6/Dmx8yhgAUwd6Lg/b0IQprwOlKLZrOGIqYbgDf0VzDQ0uKJR6Ayuz/F3Fzsi0j7RrNRLArl0gsmA=
X-Received: by 2002:a17:906:c04:: with SMTP id s4mr1410776ejf.170.1619505233754;
 Mon, 26 Apr 2021 23:33:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210426072816.686976183@linuxfoundation.org>
In-Reply-To: <20210426072816.686976183@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 27 Apr 2021 12:03:42 +0530
Message-ID: <CA+G9fYs1p4iHa4X=beryFwhdzRGmX3Yc45fiauTrmCEpfsdPNQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/20] 5.4.115-rc1 review
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

On Mon, 26 Apr 2021 at 13:09, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.115 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 28 Apr 2021 07:28:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.115-rc1.gz
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

## Build
* kernel: 5.4.115-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.4.y
* git commit: f9824acd69029477e99bf0757f1589371108dba5
* git describe: v5.4.114-21-gf9824acd6902
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
14-21-gf9824acd6902

## No regressions (compared to v5.4.114)

## No fixes (compared to v5.4.114)

## Test result summary
 total: 77701, pass: 62177, fail: 2495, skip: 12776, xfail: 253,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 191 total, 191 passed, 0 failed
* arm64: 25 total, 25 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 14 total, 14 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 21 total, 21 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 25 total, 25 passed, 0 failed

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
* kselftest-ftrace
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
* kselftest-vsyscall-mode-none-
* kselftest-x86
* kselftest-zram
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
