Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E71AE49B7E2
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 16:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350246AbiAYPpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 10:45:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350209AbiAYPnl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 10:43:41 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE392C06175E
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 07:43:38 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id h14so62822282ybe.12
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 07:43:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AHVjPyP0zobXdRDa43qD/kD1aL4KPJboAuGZz6+aIjI=;
        b=ygikGyqVHBJmTfHxK7XieVj92XekOdFFlgasst6xAxLkPV3c5M0aZYNW6r8NT3/sby
         HoPC45WxkAGmpOK1A6RkJGo4ukIe3A9jEcF7fb6YBj3o/U2dMDIKKmSqUbIvBhj6uDaq
         xbD0pnOLiMeHTfIOmjrhUGIccpcDNqpZseooBtArlY+6DBvxAm2PRK/1etDUZQwL4P6E
         fMbx8Xf/kIU/sjFY6jHWVeBSgaeZ1aETEsRCvb6E6SzRE9BKR+0zdQc/EytfIuTVvdPs
         bf4ATv3EFiIpasWvxMV9u4cbWjBUXo/dSwFn3HI2gaIxzlyVRtNeTLzT7XxASn2qQNrP
         12sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AHVjPyP0zobXdRDa43qD/kD1aL4KPJboAuGZz6+aIjI=;
        b=6RgNH+eweXOIBb/XdDAmptirPOGKm4irKITUKe0Us35Joag3Xzr3mt5XvzXSQZiY4l
         UVtN3o89koMo0dCaQCVtUbnCHI6Ij8MevXkqiYMZLRgbijCO6XrKIHx4XdyUVlSabeEB
         aX1qOa5fVXtCAz0pc8dqIGEJilHThc81CftEN3bMQNBtC48GW4DxpEO+xCHlTzlvpp66
         Or1foQDg8kieFAsWaCC0cuD6yJiD4W4eQxT9pKSs9RnKYCKH4gKKclJ49TDgSp2etR6F
         DCFauKB5oDvMZxNlS7EOOTY1lfCyCMcdDqFd99yk1KURmIS+uLi+xkSCKm8iTOa1xyqx
         RIVg==
X-Gm-Message-State: AOAM531VxqJl2YL+aUJZzPNjt6qsRsTM5PlLM6YArIZ67EBvemqGdPWz
        /imJ3e1JiGcKG4DnD6L9Z6A9BI1unSinOD2xsbz4tQ==
X-Google-Smtp-Source: ABdhPJxNWWiaiZTODDbtzjMbT4J7Q1rdDBNOkDTVYuj7XVuBoy+B0C3gGRXPzxpFKC1O2ri8RN9RSXGHota036mfvKE=
X-Received: by 2002:a25:4284:: with SMTP id p126mr31673740yba.108.1643125417675;
 Tue, 25 Jan 2022 07:43:37 -0800 (PST)
MIME-Version: 1.0
References: <20220124183927.095545464@linuxfoundation.org>
In-Reply-To: <20220124183927.095545464@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 25 Jan 2022 21:13:26 +0530
Message-ID: <CA+G9fYub82jOA2x=wAjx9T36jUnX5TxL-2dVkDOFwdsP5yQ-kA@mail.gmail.com>
Subject: Re: [PATCH 4.4 000/114] 4.4.300-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 25 Jan 2022 at 00:18, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.300 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 26 Jan 2022 18:39:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.300-rc1.gz
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
* kernel: 4.4.300-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.4.y
* git commit: 5b24bd65b9e3c88e7fa0a702a1b7932378185687
* git describe: v4.4.299-115-g5b24bd65b9e3
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.y/build/v4.4.2=
99-115-g5b24bd65b9e3

## Test Regressions (compared to v4.4.299-10-g5f58931b34ba)
No test regressions found.

## Metric Regressions (compared to v4.4.299-10-g5f58931b34ba)
No metric regressions found.

## Test Fixes (compared to v4.4.299-10-g5f58931b34ba)
No test fixes found.

## Metric Fixes (compared to v4.4.299-10-g5f58931b34ba)
No metric fixes found.

## Test result summary
total: 51089, pass: 41245, fail: 231, skip: 8346, xfail: 1267

## Build Summary
* arm: 129 total, 129 passed, 0 failed
* arm64: 31 total, 31 passed, 0 failed
* i386: 18 total, 18 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 30 total, 24 passed, 6 failed

## Test suites summary
* fwts
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
* packetdrill
* perf
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
