Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 524F144D4B2
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 11:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232257AbhKKKJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 05:09:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232671AbhKKKJY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Nov 2021 05:09:24 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8818EC061766
        for <stable@vger.kernel.org>; Thu, 11 Nov 2021 02:06:35 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id be32so10643451oib.11
        for <stable@vger.kernel.org>; Thu, 11 Nov 2021 02:06:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wuvwDD3Iz+0nxw7WCXIhtGkfBZuUHKSOA7fghzk+kgY=;
        b=vTj1VAUsYvk5iVlZ1V2Wa64PovAtmyVuCpE5RKBzj615OjkMwAIVbuE4huWtU6ZACE
         Z8ZUgCgNGacNyfoCGkkil9b5m9KkZdWReNs21vtTGjGjsptyEIHaKs9yVyxKflBms/LU
         b+ecuodvaCyqlElgLHPBjmUaH3R5o1t026vxAt5NrV9+zgH6zgOsWVKETDt1Yh6sV7nz
         WJtcBGM3MgGE4B8AfssJ27jPhw4xdQAvOcEGj3hF9VlK/hfALL3vBhGGHRwsrJdVXKfp
         PwZgJlrblicxmHvNr82W0NfIpzP74OGcpQ9CgG1dwUrqAuAPCvLkKY2AWjQjGN63Y/il
         TQwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wuvwDD3Iz+0nxw7WCXIhtGkfBZuUHKSOA7fghzk+kgY=;
        b=l01/zSXxnZpKTKW9A9t9Cg1nu93RBlegS4CV2pgdQ2GthTBYjygyKRYs3ACf0jSfsG
         q/KA0Giolac80bAgiiVA6OpkdK+C5/lPGEL8L3N1hASw+55HLzQeDhC8o8rB/TJZ6F+L
         kFJlbGf2co55BE2oR32Ls9Q/DIEjUff8Kt7xKmT6JPEcXoB5DQOc2dCwTDfevXX9L7gY
         YJD/rEvz72xa8AcUP6QKHAMJbkRztEL/IJG95GOs9l70h5jR6ZztQw7g5OMAQgDpi72T
         BbFmFPtSdTU/Xo5rVO39jWDxwBtsS7uGV+0/SSsFn5oqThLLv77vkxP6v5UrRemLVpIs
         FDNw==
X-Gm-Message-State: AOAM531FHme6GPuuaZu9uY9HyhOPFSx4bor67w+q2k8RF9XHNiy5dCmm
        oDT02e0P3EOrAWb9asyAIt7C4ZAenX5PnvM9CK4L/sAVO1fEjw==
X-Google-Smtp-Source: ABdhPJxt4ATY9UUF8VNIV+A1QdL3lmH3fStFIQG1zVT5abHDxLCSBYj7WiHjDyuyq+CdPOBzzoNVF9yiGeXVzgCmv8E=
X-Received: by 2002:a05:6808:3097:: with SMTP id bl23mr5266037oib.0.1636625194783;
 Thu, 11 Nov 2021 02:06:34 -0800 (PST)
MIME-Version: 1.0
References: <20211110182003.342919058@linuxfoundation.org>
In-Reply-To: <20211110182003.342919058@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 11 Nov 2021 15:36:23 +0530
Message-ID: <CA+G9fYtFejMyeAnNL5pXTOkyXeOgFwy94d5hdbWd2x+PxCeEjg@mail.gmail.com>
Subject: Re: [PATCH 5.14 00/24] 5.14.18-rc1 review
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

On Thu, 11 Nov 2021 at 00:19, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.14.18 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.14.18-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.14.18-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.14.y
* git commit: f4613872ae53b177f31fb92c5ba342bb4a0c3731
* git describe: v5.14.17-25-gf4613872ae53
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.14.y/build/v5.14=
.17-25-gf4613872ae53

## No regressions (compared to v5.14.17)

## No fixes (compared to v5.14.17)

## Test result summary
total: 94576, pass: 79818, fail: 1089, skip: 12781, xfail: 888

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 290 total, 268 passed, 22 failed
* arm64: 40 total, 40 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 39 total, 39 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 54 total, 48 passed, 6 failed
* riscv: 24 total, 24 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 40 total, 40 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-
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
* kunit
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
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
