Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E43ED442904
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 08:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbhKBIBS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 04:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230411AbhKBIBO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 04:01:14 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EE2EC061764
        for <stable@vger.kernel.org>; Tue,  2 Nov 2021 00:58:38 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id r4so72209560edi.5
        for <stable@vger.kernel.org>; Tue, 02 Nov 2021 00:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DE6vv6137Wma3IBrqsj7AHboxsRjxAALHxrkgjeJlPs=;
        b=uM50o2FnOXduHUZUcFmJmXV7S476NPG5U1TbfnzlScr1+6zMy5SoTvgxQjkla2oLOx
         HqfbDtwSWx/rE9z22MKBQ18PAff3IF/5OjtZtruOoXVLo0AFAxIdZklV2VxVaXTg6IC5
         JibsUXvhtzFUAB0zDpEaJltIhxBXZVgb6nRVqyPcBRGklDpFbF9xi8oQYou0yA2lFpHh
         HPbNRBuAMpuhc+2PidsVy1LyYGv5nn5kZ86sXJngn3PmIc6DCLjtgc+XJ3qb8goWUuuY
         HzKeexzmfU34Atom2LnEXPxrwZEtbqow/rf0CtnMrgg3DPxSlxMOFjhoYvKL3Mbe1RjX
         WdhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DE6vv6137Wma3IBrqsj7AHboxsRjxAALHxrkgjeJlPs=;
        b=UUlqe7ThjLFQMM7qqQII4IGBNC9CFDbVJc8r0dRDrfpROdskYYIiYnEzPSvnVo1bUI
         uSgU7YSEJ4PUK/twnmbDDxWLAjEX8c/p6esFuQJYhC6dRgFryJnKNafq9brsJoUIDI3p
         3DOvrFT6vcbK54d85B9uiOc0OtFOf3YJJrT4dHfdlQ7MbRPKwYVZ4L4Da4ZgjCmtZIUu
         6/xC4QPm1ImpFFqvYi3UpLum8RwTDYpj63bW2cfAHpdKcyxfvU1sxIckyUjtpadDHCj2
         XRRtrBZIj9z2v0whrk3Hshfj2wdQwvvBuh4Y2Vfu2Tya2At48kO/z1QtyrG9H2bGZXak
         n63Q==
X-Gm-Message-State: AOAM530Q8QKNeA4bjj8C6/zB+jG0h/4+1hPmU4J6Ih9eW+GxJZfHc58D
        4tYOUlUaT/JEB/UZnmkEOmiP4uFnl247gfAysAMrgw==
X-Google-Smtp-Source: ABdhPJyz3fTD+3tcx51chhWmDHyxkKtgsvWvEJdCs2Dos5bUsI8B3I0ybz7ZUldakgWbUSqIwowtIch/EmwvU3aEboc=
X-Received: by 2002:a17:906:c7c1:: with SMTP id dc1mr44311153ejb.6.1635839917048;
 Tue, 02 Nov 2021 00:58:37 -0700 (PDT)
MIME-Version: 1.0
References: <20211101114224.924071362@linuxfoundation.org>
In-Reply-To: <20211101114224.924071362@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 2 Nov 2021 13:28:25 +0530
Message-ID: <CA+G9fYtmu4qTACYr3n_mzTcAMr65znbx81yXQpfPNKFP7z5ixw@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/35] 4.19.215-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 1 Nov 2021 at 17:13, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.215 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 03 Nov 2021 11:41:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.215-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
With new gcc-11 toolchain arm builds failed.
The fix patch is under review [1].
Due to this reason not considering it as a kernel regression.
* arm, build
    - gcc-11-defconfig FAILED

[1]
ARM: drop cc-option fallbacks for architecture selection
https://lore.kernel.org/linux-arm-kernel/20211018140735.3714254-1-arnd@kern=
el.org/

## Build
* kernel: 4.19.215-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: a75679fb6ddbcf7814a3f96f09dcf0d89b430956
* git describe: v4.19.214-36-ga75679fb6ddb
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.214-36-ga75679fb6ddb

## No regressions (compared to v4.19.214)

## No fixes (compared to v4.19.214)

## Test result summary
total: 74931, pass: 60213, fail: 776, skip: 12291, xfail: 1651

## Build Summary
* arm: 260 total, 210 passed, 50 failed
* arm64: 38 total, 38 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 27 total, 27 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 22 total, 22 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-android
* kselftest-arm64
* kselftest-arm64/arm64.btitest.bti_c_func
* kselftest-arm64/arm64.btitest.bti_j_func
* kselftest-arm64/arm64.btitest.bti_jc_func
* kselftest-arm64/arm64.btitest.bti_none_func
* kselftest-arm64/arm64.btitest.nohint_func
* kselftest-arm64/arm64.btitest.paciasp_func
* kselftest-arm64/arm64.nobtitest.bti_c_func
* kselftest-arm64/arm64.nobtitest.bti_j_func
* kselftest-arm64/arm64.nobtitest.bti_jc_func
* kselftest-arm64/arm64.nobtitest.bti_none_func
* kselftest-arm64/arm64.nobtitest.nohint_func
* kselftest-arm64/arm64.nobtitest.paciasp_func
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
* prep-tmp-disk
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
