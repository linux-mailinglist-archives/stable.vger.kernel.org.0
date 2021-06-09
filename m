Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F07F3A0E10
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 09:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237024AbhFIHvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 03:51:16 -0400
Received: from mail-ej1-f42.google.com ([209.85.218.42]:35700 "EHLO
        mail-ej1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236113AbhFIHvO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Jun 2021 03:51:14 -0400
Received: by mail-ej1-f42.google.com with SMTP id h24so36988248ejy.2
        for <stable@vger.kernel.org>; Wed, 09 Jun 2021 00:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZaUhYQdmHuTDdFcVZfmGKuIBgkyJArjyQg7xZ0rZjR0=;
        b=fB9ycC44mqSk3FiHu2I06fiq6qXf6SVQaSqz7QfhrYPqxhOaRROYWpEeXp0XU69Eqn
         T+1qgJCxQ9Ro2XnKqQaLrv2dCydFNhJ23BfTNWyW/A/bVOQX0v9fjN/HxF2gwBSJ1A8r
         O8426UMzUxm6OSrz9bKS5xsId+nNxdaLUi+FezDZAOelOaH089mJWNjwzt+VQmtj3FU1
         FNDemF1YjP0ywuUjDeutHK6XlUsYNrH/YfOL4S8WbBld7Mm+aax3kgjgBPFJJBlmtbQy
         BbujKR4bQcJ3wUnm1sgkE7bAKqiQpyPtbVDZsWRSXGktQ3lsWVrkKrJRd69SMDOyPRPb
         VTRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZaUhYQdmHuTDdFcVZfmGKuIBgkyJArjyQg7xZ0rZjR0=;
        b=hgsT1OnLRErRnRDfzkrFdeoaNsDNSMN4nAqw2rMFXdDhVd25XvNJBqGy+9sOYEQhi7
         Xt9prWBIo7GWc60RMpLoXaI6nFqW4yhEKo5Gtb3xy6rojlErtHruOUG8Itq1N3wnNYPN
         pPpze2L+O9oNkHbsb7LjTWq2gFMjb1T/A/5gLwOnPOMI4YEPTtFIqH9LX/FArXCN9Kvl
         o4ZwmgcLyyIuLRLwWiz4XmVOlOCmv3oRXD1eef7Odi3Z9PAXouSm4HsR6nl/wG6qeCja
         HH859SGdfBG84kv77gCHw/ePZ/sps26a0txTa+3tVAbvA0JBSkEz6iY4YvOf6aa4RKCr
         pSAQ==
X-Gm-Message-State: AOAM532uuBwX3pycT7NiShDS3zRkPDjrpyCfg3U/SVXxVggh+CdD0jnL
        Wx2M3EhFtqqoygi9EuFGWzG9jdaPVu7krEmE8aTjDQ==
X-Google-Smtp-Source: ABdhPJwMCugsafbTBevGFnpMAd8HDSzVGWNXSsbMCG4QgbU73182JWiqTEbmJFg4Kycl2OorHwxLmx9Akb6/tN24cdA=
X-Received: by 2002:a17:906:9d05:: with SMTP id fn5mr27082879ejc.133.1623224899013;
 Wed, 09 Jun 2021 00:48:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210608175945.476074951@linuxfoundation.org>
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 9 Jun 2021 13:18:07 +0530
Message-ID: <CA+G9fYtNRXXw1KrF2ByqPi5VoVqt_oZgd=tbm=xsgDV1BndwDw@mail.gmail.com>
Subject: Re: [PATCH 5.12 000/161] 5.12.10-rc1 review
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

On Wed, 9 Jun 2021 at 00:15, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.12.10 release.
> There are 161 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Jun 2021 17:59:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.12.10-rc1.gz
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
* kernel: 5.12.10-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.12.y
* git commit: 5a0a66f4d8172bcb8ac3bf155bc524dc467c0071
* git describe: v5.12.9-162-g5a0a66f4d817
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.12.y/build/v5.12=
.9-162-g5a0a66f4d817

## No regressions (compared to v5.12.9)


## No fixes (compared to v5.12.9)


## Test result summary
 total: 76414, pass: 64280, fail: 496, skip: 10934, xfail: 704,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 193 total, 193 passed, 0 failed
* arm64: 27 total, 27 passed, 0 failed
* i386: 25 total, 25 passed, 0 failed
* mips: 42 total, 42 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 18 total, 18 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x86_64: 27 total, 27 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* ks[
* kselftest-android
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
