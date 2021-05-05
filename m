Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17602374879
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 21:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234820AbhEETK6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 15:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231422AbhEETK6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 15:10:58 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CA43C06174A
        for <stable@vger.kernel.org>; Wed,  5 May 2021 12:10:01 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id c22so3307022edn.7
        for <stable@vger.kernel.org>; Wed, 05 May 2021 12:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZO07fig+Fo15/ubZmeE90l3nz6ipAJGihh+nah7Dgv0=;
        b=DzvzdqvDVmxJjpAX4SXcy0AlCU9CDGmdRMaTZw/0Vbbu7xAJyqAozASEXYWfeozqXn
         uSPA0Wih4PR+FgaEBBDpXS2XLrminqNIj53L3/e3Tm83Vj9vIc103Q+QtBrqkll7BjGS
         LKql8BeHIe9EDkuQUKe8M4U1fYR1PHNbQmHqv0kGVnrEM/U1r1kpDu6XbRH0DVpBL45h
         TbhjJj5Lbg7gQ/5D8E46cjp5TrebWIrSVvM3MyF0YtQWa8k6/v85qCYxJ9gkJmPe7tv0
         7CVxZmfWQEW3ja5XbWUYYnqn6syXfVPoiIjJQoryRV0WOHAUeBJ63LeZBEGNggQCOJF6
         VgsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZO07fig+Fo15/ubZmeE90l3nz6ipAJGihh+nah7Dgv0=;
        b=PzRiTon1ywL8fVEeNQ/UwXh9sJuNDRGpU4IXozshg7MCb04cJZ9xu7t0HfBa6zH/Ql
         8ANNy2nP40ykxRVyVnuSvzFhWZyuc7+yq1MvCH8GNmcauiGxQf2YS6LcbMv6cwrsAnw3
         UBn50hqN+Dos2A2fB1xfHe4n+g2fJO/ZHZShUz3NCuGPjHHblWKVQHPWCbIAEak/HCw4
         +LLOzLEPn2bkuSNw8SwZ4Nfjtoa5+HEEJ1LbA15ZzB2+nFFQJoRvi9X+h7QHncSgRo6v
         zRtbGGPAqPN3sJWkMSv90HeY3ZSDIURuzd7c7j2BV5PN6+sGJHbi7Qv1ifvqJYvWUJ69
         xVsQ==
X-Gm-Message-State: AOAM532aXSnTplI/JcMzaBgOzXe/3Cp/f/zvwfkgkAQQ3Lc/eeiPyxBB
        C2TGyp3rI6qAAsP6nNSUZuHXDxgVw/j05f+t/m+1nA==
X-Google-Smtp-Source: ABdhPJw/ZWK8GQkFpFJ1Vo2+TpOXsAVEna4Zq8RcaplWS6HPtiiT9beWpoSz5eiVNCL6fdYgWlgaOPIZsMvkJ+RKZLg=
X-Received: by 2002:a50:fc91:: with SMTP id f17mr597143edq.23.1620241799760;
 Wed, 05 May 2021 12:09:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210505112324.956720416@linuxfoundation.org>
In-Reply-To: <20210505112324.956720416@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 6 May 2021 00:39:47 +0530
Message-ID: <CA+G9fYvFpBd+5Sc8Py=m_XopbDXT_PSUWWid3-pCXzStB4P5hQ@mail.gmail.com>
Subject: Re: [PATCH 5.12 00/17] 5.12.2-rc1 review
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

On Wed, 5 May 2021 at 17:37, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.12.2 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 07 May 2021 11:23:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.12.2-rc1.gz
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
* kernel: 5.12.2-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.12.y
* git commit: 77358801e46cfaa306e7b1bcf5d8cf99a21b40d2
* git describe: v5.12.1-18-g77358801e46c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.12.y/build/v5.12=
.1-18-g77358801e46c

## No regressions (compared to v5.12.1-8-g3a4da71200d3)

## No fixes (compared to v5.12.1-8-g3a4da71200d3)


## Test result summary
 total: 79811, pass: 65944, fail: 2758, skip: 11109, xfail: 0,

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
* rcutorture
* ssuite
* timesync-off
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
