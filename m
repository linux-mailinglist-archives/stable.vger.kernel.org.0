Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A12BA35AC85
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 11:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234571AbhDJJnp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 05:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbhDJJnm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Apr 2021 05:43:42 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17E52C061762
        for <stable@vger.kernel.org>; Sat, 10 Apr 2021 02:43:27 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id w23so9274059edx.7
        for <stable@vger.kernel.org>; Sat, 10 Apr 2021 02:43:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VpR8JjIwnxm/ZAIy3uRS/88GZbMJ/pI4zWXZzyOtEU0=;
        b=u3UlBGleT6AaiTDz8PaCtGYEAAhE8mlwZM9q+EASI59PTGNVBznJtHq8TXYLnCqomv
         5eBDoAUiK0fPFVXQQtFEN7b/loVECqsyPWkcDX6sHtr63QG1mf2ZErrmStvQMKtVpuU/
         NfrV5i65wHH4lyduJU2WWJXPGacGpoJHKjMNqJXsnSvPtvWsEyVRdWSV+fNGl4M0tNIN
         JbdlE9EosjbxTYziOyQY+Yq3S1L2Qc0nUua9OrC9YwkD/KDkVqeQ7iHJd4UL4f+Iq1MZ
         MB2PhERXiNJVfxFj1+EmOqusbEVXL1lM7AT9b6JhUR0rpFdQCtrGStLwMDyCPM/4fR36
         XesQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VpR8JjIwnxm/ZAIy3uRS/88GZbMJ/pI4zWXZzyOtEU0=;
        b=PVHA/jzT1cljI28dab5z5NjwpMZ3HDAqckoeEWZTvwSRT3TJ0gW6HQW4Zla+bo8H7i
         3hYEC1yrF7neQ2ZE/+dzbmXk5Zn8IgqxFr78MgRknzHppgUeHK8092eovnMT0Vs8FKoy
         x0dVNjV7Id9/M6Vez7Sco69jgKgT7K8jlG+QWqB8IxYOVokNgwdrChohCraAnyDj684J
         WlrHhlKIsg4CuGDDtS5MGtMjY7GEu9CSKrJdQBgkizwmAN2Wz+/r+FRoRoBTdW9b2eeg
         BsNoWB467d6kbLCAo1RsADx7wq8Q22cpNW4ceFI1XH0/ICxTSFFktUeBKBfmCRjAV5AP
         TqNQ==
X-Gm-Message-State: AOAM532oW5LVBCHDRv5yx+Bx7XRm/2vCYU2ltS9IAzfcxB5j1PywyNAA
        ST6aMxJu6Kr5nfB1r0Or+KZOi//ZtyFz5JCUg2OdSw==
X-Google-Smtp-Source: ABdhPJyJ1fcTpuG7v3v8uphQjkiGgkiqynDUZGQU3X2IrDiG7Ypir3QF9VWnE9iYXQLWULS+IwSa9++Aa5ZmojK34Rc=
X-Received: by 2002:a05:6402:5113:: with SMTP id m19mr21551946edd.78.1618047805707;
 Sat, 10 Apr 2021 02:43:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210409095259.624577828@linuxfoundation.org>
In-Reply-To: <20210409095259.624577828@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 10 Apr 2021 15:13:14 +0530
Message-ID: <CA+G9fYvsxfoPyM7ew8e05bsQVsS24oNNz5epH-AxtJ42VHC1Og@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/13] 4.9.266-rc1 review
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

On Fri, 9 Apr 2021 at 15:26, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.266 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 11 Apr 2021 09:52:52 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.266-rc1.gz
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
* kernel: 4.9.266-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.9.y
* git commit: d263ac9a21bc26cb10dee0ee34109289ac518725
* git describe: v4.9.265-14-gd263ac9a21bc
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.2=
65-14-gd263ac9a21bc

## No regressions (compared to v4.9.265)

## No fixes (compared to v4.9.265)

## Test result summary
 total: 56309, pass: 46531, fail: 617, skip: 8921, xfail: 240,

## Build Summary
* arm: 96 total, 96 passed, 0 failed
* arm64: 23 total, 23 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 13 total, 13 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 36 total, 36 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 13 total, 13 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
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

--
Linaro LKFT
https://lkft.linaro.org
