Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C34DA493A98
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 13:42:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345580AbiASMmA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 07:42:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241190AbiASMmA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jan 2022 07:42:00 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D043AC061574
        for <stable@vger.kernel.org>; Wed, 19 Jan 2022 04:41:59 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id v186so7058771ybg.1
        for <stable@vger.kernel.org>; Wed, 19 Jan 2022 04:41:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=M03QfIAmQlSzz1G93ziHitODMCSyEGAasy8TlQfj9XU=;
        b=f7nRxfYzqOX3nAnuHa9PdCbV8dfnPwCQwU0u54aopKVrFI6UQOs9ulERZ8D/cF8Zi0
         5EmXJgwZHX+nlC8rYqFCpXB2+c8DFdeJbCSnhh+IZFXYeg1Rx3ywwFlWZfB6rodGdb8T
         0FotKY+uSNfUOL1RY2GkncriXNksHDUQ6Wp7ytS0m+XYEMlxoQB+0aDjsxBrW+30ukTF
         sEHiPuKl+hQGNXC6ESEY6hMKTXa3El+rFhMrvtk6n73TsQit0XSVY3n6kBUo+n0W8iWv
         1QWk2cB7uMFZm/wY5eu4lh1bgB+6foSelMdM6yx3cp0M8qgKQcOAphRyv85xdXaRPuF0
         OfAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=M03QfIAmQlSzz1G93ziHitODMCSyEGAasy8TlQfj9XU=;
        b=BeaR1xbiB2x3QP4eUd7npUhqoUzalwnaL55aJmVWbHLh4QrpRE0d+oJ6vGwO3//CpY
         8B6KsjH9oDeokewm5a5lzuhlOEI2+LYJLwUTi4xmp1P39qIVWR259pRoeCtNwgkKR654
         64I8UwzchdDkmJxVb/k/+buoqEpYt7PIdBnIDCAM+HXGUTv0VBHqe0CxmlO9SMzyE2oC
         vOsmqzZOl1ElsU3LfKSVhfSNbO+gxevOSXWexLIQrzozqyj/s1ncPtUM7Yzg6PQocVjI
         CNM+rGwfP5P5p1mL+lVu3GzKZ+Ua3kdehob7djLZWe7++jpuYZulB27TVDXa1POecz1u
         pV9w==
X-Gm-Message-State: AOAM5335PiWM6tcCtZ6z04wsiJIjxhrIBpfO8wFyy2BrvHpnm//OGMvm
        7R5t20bj5DYvjr1jnKv6K6mH6HmTSHxgiQmu29Kdm+iyGpS8UQ==
X-Google-Smtp-Source: ABdhPJyCidEeBcdXNQciNRvfRxwUy9R9ZMp0Wi3lBw/cmseuIe3E4Qtes4ApDLSL/KrsGkQlVIb/lUh9L/eW8f669AI=
X-Received: by 2002:a25:c0cf:: with SMTP id c198mr7564294ybf.146.1642596118771;
 Wed, 19 Jan 2022 04:41:58 -0800 (PST)
MIME-Version: 1.0
References: <20220118160452.384322748@linuxfoundation.org>
In-Reply-To: <20220118160452.384322748@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 19 Jan 2022 18:11:47 +0530
Message-ID: <CA+G9fYswNbttxD6D2q79pFXeebnkk1Aegd-wnKMVEFiSFvO3Yw@mail.gmail.com>
Subject: Re: [PATCH 5.16 00/28] 5.16.2-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 18 Jan 2022 at 21:41, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.16.2 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 20 Jan 2022 16:04:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.16.2-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.16.2-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.16.y
* git commit: 979dd812ffb543a3f6218868a26a701054ba3b8c
* git describe: v5.16-67-g979dd812ffb5
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.16.y/build/v5.16=
-67-g979dd812ffb5

## Test Regressions (compared to v5.16.1)
No test regressions found.

## Metric Regressions (compared to v5.16.1)
No metric regressions found.

## Test Fixes (compared to v5.16.1)
No test fixes found.

## Metric Fixes (compared to v5.16.1)
No metric fixes found.

## Test result summary
total: 95183, pass: 81363, fail: 867, skip: 12040, xfail: 913

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 263 total, 242 passed, 21 failed
* arm64: 42 total, 42 passed, 0 failed
* i386: 39 total, 36 passed, 3 failed
* mips: 37 total, 31 passed, 6 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 56 total, 48 passed, 8 failed
* riscv: 28 total, 24 passed, 4 failed
* s390: 22 total, 20 passed, 2 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x86_64: 42 total, 42 passed, 0 failed

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
* kselftest-membarrier
* kselftest-net
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
