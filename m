Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 241A13E968A
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 19:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbhHKRHt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 13:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhHKRHt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Aug 2021 13:07:49 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B89AEC061765
        for <stable@vger.kernel.org>; Wed, 11 Aug 2021 10:07:24 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id r19so1468915eds.13
        for <stable@vger.kernel.org>; Wed, 11 Aug 2021 10:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3XQGC3d64b+I6TOaPbwAFaPjlDo41tWhOmrtKo7/ocU=;
        b=HQF3q65f2wid9sOwU4NV66gg39HYhl8qRYeeOoInwbjPuSUWfYJPtfCegTW8HLg/Tm
         kvpwW9Vcm1+DQP8CYmf5D03t5aHEn1Alg4eDSt0fMqox6A+YhhDPUCFvAmdmEZQRfP/8
         7s06Q0q+Dr4U6abpp1nYlEQxvQ5EHcHW71+SNzqbD9TKiAjnkeNsLGH/2OkKHUd9ASdY
         5Zz9U4Tv+XDf2XDdgHICWoUa/TDvA/1ETYLtAUUwFQlQbeiU5xUDOoE3qGw1OSOrSkbX
         Lg3Iy6acktcamI6mK2cRbkILzOJX+IOsBUO0eJz7tGnz3GZeMVi1I+vZOZJshsiMDnDx
         zpZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3XQGC3d64b+I6TOaPbwAFaPjlDo41tWhOmrtKo7/ocU=;
        b=j+zbVluqBU+3Zoqw7d92Jz5kwWyXobCwcvprXwAzQF/n8Y7sWD5IsQVn5kqF2clyWN
         8D9DakwdJLRBNN3AEgJkTBiRll65tIhijRDqYkFR1a+uMkgyeVVK4rMSqIc+0ItdAcUy
         xuKAqNtpMM3aWyq9+P9mUypImJgCdWfK446YhDTnzxLFBTAPh/F1u1vZCMF83VztWb1D
         mbRf3ufNF98FAWJFdL8HnNTMEFQipvG33o0RYD7bcjno2+8VnEeDyrg/SYHHdiXXeNY7
         K5OnqFjFEc4O+gP7g41s8Q8l2SYvc45JD9bkyo7X4Iyx9vw5mhWQVGI/v+sfuw2JDXwH
         mxSg==
X-Gm-Message-State: AOAM533/1/ZnHhUQKCPzDTvl70ObW5xFdh8VT8qmn4xWVfiulU7ibihI
        hi5tEFiOa7YQI0t6TmFbhyAT7ZsXFD+XL8WTKd949Q==
X-Google-Smtp-Source: ABdhPJxCes62ilnkIwtlPZaMP9n/Kc7mf1nsAuS/tFpdUbsGb7++QbvV0RXQj4zm5umVAQRXrnmL2mnk6E+IIXl0xCQ=
X-Received: by 2002:a05:6402:2153:: with SMTP id bq19mr1900509edb.239.1628701643169;
 Wed, 11 Aug 2021 10:07:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210810172948.192298392@linuxfoundation.org>
In-Reply-To: <20210810172948.192298392@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 11 Aug 2021 22:37:11 +0530
Message-ID: <CA+G9fYv7JPNoQEyjcgM_Cyaa1OKZtVx2mFV8DzvNGKADxeKziQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/85] 5.4.140-rc1 review
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

On Tue, 10 Aug 2021 at 23:04, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.140 release.
> There are 85 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 12 Aug 2021 17:29:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.140-rc1.gz
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
* kernel: 5.4.140-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.4.y
* git commit: ff7bc8590c20350dd180f3e751354836564c7342
* git describe: v5.4.139-86-gff7bc8590c20
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
39-86-gff7bc8590c20

## No regressions (compared to v5.4.139-78-g48ffc0f8906e)

## No fixes (compared to v5.4.139-78-g48ffc0f8906e)


## Test result summary
total: 78998, pass: 64186, fail: 798, skip: 12688, xfail: 1326

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 192 total, 192 passed, 0 failed
* arm64: 26 total, 26 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 15 total, 15 passed, 0 failed
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
* x86_64: 26 total, 26 passed, 0 failed

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
* kselftest-tc-testing
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-vm
* kselftest-x86
* kselftest-zram
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
* timesync-off
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
