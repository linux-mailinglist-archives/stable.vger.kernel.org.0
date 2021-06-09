Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6605E3A138C
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 13:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239640AbhFIL5R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 07:57:17 -0400
Received: from mail-ed1-f53.google.com ([209.85.208.53]:40822 "EHLO
        mail-ed1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239629AbhFIL5Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Jun 2021 07:57:16 -0400
Received: by mail-ed1-f53.google.com with SMTP id t3so28349408edc.7
        for <stable@vger.kernel.org>; Wed, 09 Jun 2021 04:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cfMAdBAKjfU4ryCc+9LZO7m3/l9hziyk+MjjxRLu300=;
        b=l0WnzNrvswluTVlcdYymG2+Ku6Gpu1Y7bybyQLL+iDYxZCqdd2qxD5LBUwuJzvBoZc
         nW5GU61R5ghtpqdARJCtIgD3MBaGtwiaODZzJbhQ09cZEecQFxegkXZQmGs9AY+3v9Y5
         jkJOKkArbowMP3wLXv4AEs75n4ONRZ4gLYkfOGG3sAhnsm0QXZF7ssIpGwrzQc4GxFEy
         hN1f/my6Nsd/BcBeq087OKRpFKNS6R2tdrCrr7+VjDnSeiT3jb/iGyuBPcwt6V6+drbb
         oiXZZVfICrXaSYCtP4afvu1vBbIgdwkO2Pu9VoBMPblt3etdqPErolhofNGbhmG0emSN
         1Vqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cfMAdBAKjfU4ryCc+9LZO7m3/l9hziyk+MjjxRLu300=;
        b=NghBMy/EesyGgGuXejUt0iLSplQCIQ+si0D41by87q2allSGq/GmesVMp7fy1LECoX
         uOdahbLA4SjovJY4+ansnWyxsF70/tBhGmeLHmA3wG2912bKnj5lMqnfBcon7YtaTvOv
         JY24OXgMLKmaBcCHw2aAnul2x1tI13LgZmtmXcHo6P9YvpU9s6QRXm1GVzcW7chxDggL
         0fNScr+rxKwS/f2vP+UtNtGSJH/AhU/D9u5BIOccatbm6mxfXmAwNY+/AzKyJv8kdM7B
         th1gutpzlpGwDt+LDLgg4SMoxbhagzTUyVGEeo2D97keRS+F+hPQpx8T0Bky+bEpD1XM
         hhWA==
X-Gm-Message-State: AOAM533+deb/1rGO2xkOrLqcs2gBbly+m3crWtyIhe4sX3BIpxvIUs+I
        9u4y//EZg+yxvLSxoE/hdrLbJaXbTDD/jGmieLKGIw==
X-Google-Smtp-Source: ABdhPJxUVP5Gvqz4EmDFzDv25YAdnv40ufguE62/Okw/MmNvvYGh9pdyY+w0yBhXsllg29DYhCsNlPeGNtmxRqJQ7Wc=
X-Received: by 2002:a50:fd0a:: with SMTP id i10mr30633837eds.78.1623239644846;
 Wed, 09 Jun 2021 04:54:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210608175927.821075974@linuxfoundation.org>
In-Reply-To: <20210608175927.821075974@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 9 Jun 2021 17:23:53 +0530
Message-ID: <CA+G9fYvaXJfoEAibA232pujDvb+JY+9Gpyca87ZZCAa3uMaEJg@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/29] 4.9.272-rc1 review
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

On Tue, 8 Jun 2021 at 23:59, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.272 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Jun 2021 17:59:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.272-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.9.272-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.9.y
* git commit: 5f3a05577796b0a04f9705503ae9cfbfaa10cd8f
* git describe: v4.9.271-30-g5f3a05577796
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.2=
71-30-g5f3a05577796

## No regressions (compared to v4.9.271)

## No fixes (compared to v4.9.271)

## Test result summary
 total: 52318, pass: 40533, fail: 1073, skip: 9644, xfail: 1068,

## Build Summary
* arm: 97 total, 97 passed, 0 failed
* arm64: 24 total, 24 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 14 total, 14 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 36 total, 36 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 14 total, 14 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* install-android-platform-tools-r2600
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
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-vm
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
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
