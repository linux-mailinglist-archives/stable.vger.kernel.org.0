Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C69B362046
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 14:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235518AbhDPMxG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 08:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235027AbhDPMxD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Apr 2021 08:53:03 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CBEFC061574
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 05:52:37 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id bx20so30992540edb.12
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 05:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KTkYOAU15O6ddpvrFVWV/b1BQ82JMUlbrUjNluG6qEo=;
        b=v209aRrcikMtJ/aXzByV2BH5ZeO5XaIB37LtCoVmRq38grUUtiEP9lhSQ/d27p0fdO
         4qA1nv6bifpm1geNYr/llU7/enlg3ghsx35eIDsxI/Pai1XVHcciwkyv0vFqGWrfZirS
         jEIvOjxTsPA8JeNpLOSuDN28t+lsktl4Ywnd7jcNPNgXXmBKXq/c2hqfaGnDOoqSUGmD
         DT/8HfZ1xMQRP7qT8FfbuNLoDULQ0nlN5oaRn2Lrrje1OG5A2yIf5DnqF1L0gsnG/4Lw
         6VLEqNShuM6PwcavM3tJLO8K0PTQToOoavD79+l68oOC4yn6qTG0TfPWbZSkQC2e1W6T
         VsEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KTkYOAU15O6ddpvrFVWV/b1BQ82JMUlbrUjNluG6qEo=;
        b=pvLvgnh/aLdXYPLMF19GnbicyWPecjNqbTk7wCeCu/ilq8RQj2oNe5pejdWzVs5aXh
         2HXne8loPoR9prVVAfJ+zpb+hUwHF9KJr/Xq+qOAiXkGZoOTaT7xoCWKK8P5aXWooByb
         tflkl9yENI0LD/21BW5Zex2g8rrdCBUJiM4Y5VjhV9Q0ocDJ7JLlvQUH4++a3XzHqB9Y
         kUvyw0m8rqwwEyEcokPQB0zWax6e9KYJJgQSWpAbcUH3yrzlkWBO+A+dI4gYSq047Hwt
         oFQpSXJm5vDlqgDO3vr3cBxnnaCmZQtuzleg56pkvBFr112GDWKo3APGRRcXWiWYM8nD
         Xqbw==
X-Gm-Message-State: AOAM532vrtui96nJBLDe7ifZlAE7o/JaCcVMQYXoATMv24UvDTpPeG0X
        png5Mop4v/hku0m2KtA1KG5MKuJaIWsugnyo9R6SOg==
X-Google-Smtp-Source: ABdhPJz74ERMYu2Ow/lALdeVQZ7YXVRrSfFenIfahNCkLsDbtmiuy+mej1TaJ2PYtdu5Ez3mTy6VbDiRz19EWPNZkBU=
X-Received: by 2002:a50:c3c2:: with SMTP id i2mr9707333edf.23.1618577555985;
 Fri, 16 Apr 2021 05:52:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210415144413.352638802@linuxfoundation.org>
In-Reply-To: <20210415144413.352638802@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 16 Apr 2021 18:22:24 +0530
Message-ID: <CA+G9fYs9S357Qj9vtHjXuPTvEDsFnD8zmEptTF-rh76KyUVoNw@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/38] 4.4.267-rc1 review
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

On Thu, 15 Apr 2021 at 20:20, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.267 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 17 Apr 2021 14:44:01 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.267-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.4.267-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.4.y
* git commit: d5830a9390f6eccae1c50d2f4a82473ded6ea346
* git describe: v4.4.266-39-gd5830a9390f6
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.y/build/v4.4.2=
66-39-gd5830a9390f6

## No regressions (compared to v4.4.266-35-gafa6a544124b)

## No fixes (compared to v4.4.266-35-gafa6a544124b)

## Test result summary
 total: 44985, pass: 36787, fail: 370, skip: 7578, xfail: 250,

## Build Summary
* arm: 96 total, 96 passed, 0 failed
* arm64: 23 total, 23 passed, 0 failed
* i386: 13 total, 13 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 36 total, 36 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 13 total, 13 passed, 0 failed

## Test suites summary
* fwts
* install-android-platform-tools-r2600
* kselftest-android
* kselftest-bpf
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
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
* perf
* ssuite
* v4l2-compliance


## Build
* kernel: 4.4.267-rc1
* git: https://git.linaro.org/lkft/arm64-stable-rc.git
* git branch: 4.4.267-rc1-hikey-20210415-988
* git commit: f84c762ec9c5916bcd6a9bb420e560756fd14261
* git describe: 4.4.267-rc1-hikey-20210415-988
* test details:
https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4-oe/build/4.4.=
267-rc1-hikey-20210415-988

## Regressions (compared to 4.4.267-rc1-hikey-20210412-985)
No regressions found.

## Fixes (compared to 4.4.267-rc1-hikey-20210412-985)
No fixes found.

## Test result summary
 total: 2480, pass: 1851, fail: 69, skip: 546, xfail: 14,

## Build Summary
* hi6220-hikey: 1 total, 1 passed, 0 failed

## Test suites summary
* install-android-platform-tools-r2600
* kselftest-android
* kselftest-bpf
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-firmware
* kselftest-fpu
* kselftest-intel_pstate
* kselftest-lib
* kselftest-livepatch
* kselftest-lkdtm
* kselftest-membarrier
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
* kselftest-zram
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-cve-tests
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
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
