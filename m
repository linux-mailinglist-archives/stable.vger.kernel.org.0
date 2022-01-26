Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D61A49C96F
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 13:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241164AbiAZMS2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 07:18:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241135AbiAZMS1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 07:18:27 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE67C061747
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 04:18:27 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id v186so70907850ybg.1
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 04:18:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pzG5gVW6OLq5ALyV/2L4JM19C/owtDngOvjGjJb1zUc=;
        b=L3hHvkd7KUwErnOcM92GqbjApftKtzquie/egc6t2z8SQGI/s9MNw4JpN7JvRuQxYb
         mZNlnszAP0qOhleOc8lkXILqo7pyBoN9k6gaw3wQ3VnL1jWP3qW4yp8q47kE+yBucPnR
         d+O4Egyqhw8A/aK99ymGBZsnTIkkbCXSNC4Uq4lyuVko7zQJveqvfz6d1mK++Y9Ef9OC
         jBC4VXJ5lZG+1ULRLGJHcrFxyrBpXmN8HghFFV7T16OV4beyS47/zZph+x/YqmRpcxb7
         WIWonDc6lBJKWmG+rsPGQkaZ3KH9jjcR+r2TA45Szyz66lb/pQwJxxzUmqwPwZBIFxZK
         pIqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pzG5gVW6OLq5ALyV/2L4JM19C/owtDngOvjGjJb1zUc=;
        b=dVogr/8Wc0NVMj2uTHoTtk+MIlq0skOnCHt0lDcLRvxxjDjg9i+Bvd7elj2+ZKmjog
         UOwOs6+JieiNmMU4jRAyQvGpF9w7oM2K4Jv+zbRcHvEnsfz8RzKIJPijwLu/CyUp7qcR
         9ui1D+Fy72SRA1os3Oyfh4vfVYfheGfisu+TNXHVLAb7lmEsaGUvp3aXRM2e/MWv7W97
         FgDzktrXT0ZOl8Fs03KbSA9huE2eH9ulQ/4GGc7+LKi3HqxOPWF3HZOb8FWI/SAYSOg3
         Xo3gXhRWYjI/7T2S0znw537nJ7yKjmFqoWs7tVhs1D0oLkVLBvQ+UON3GSxwzCzHqvzq
         9PIg==
X-Gm-Message-State: AOAM533kDOPYUmDFITUY1UtWzmT+atBe+a2UIrwo2nduQCsvtIaLEwP5
        Y06q4zJze1raJzo3xwNkPc7rCGn1hkx1sKuPDMeakA==
X-Google-Smtp-Source: ABdhPJwmj1lMbjnaTAFe/3Wp/1OQf1qyC+XG34Bkqxme3NBMyJ3bVD/LHNzKufsLk0VF6lL+TECDhvMXKhPy1FMPRFA=
X-Received: by 2002:a25:4284:: with SMTP id p126mr37690485yba.108.1643199506486;
 Wed, 26 Jan 2022 04:18:26 -0800 (PST)
MIME-Version: 1.0
References: <20220125155257.311556629@linuxfoundation.org>
In-Reply-To: <20220125155257.311556629@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 26 Jan 2022 17:48:15 +0530
Message-ID: <CA+G9fYthP97HFYPV3+7rH0KQeVt0scGRw9rm+zGvFR6D1cg_QA@mail.gmail.com>
Subject: Re: [PATCH 4.14 000/184] 4.14.263-rc2 review
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

On Tue, 25 Jan 2022 at 22:02, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.263 release.
> There are 184 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 27 Jan 2022 15:52:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.263-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.263-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.14.y
* git commit: 1cb56422263318b84ec74390135d405f17a73e5c
* git describe: v4.14.262-185-g1cb564222633
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.262-185-g1cb564222633

## Test Regressions (compared to v4.14.262-187-gb75a88cc2107)
No test regressions found.

## Metric Regressions (compared to v4.14.262-187-gb75a88cc2107)
No metric regressions found.

## Test Fixes (compared to v4.14.262-187-gb75a88cc2107)
No test fixes found.

## Metric Fixes (compared to v4.14.262-187-gb75a88cc2107)
No metric fixes found.

## Test result summary
total: 80406, pass: 64815, fail: 659, skip: 12790, xfail: 2142

## Build Summary
* arm: 250 total, 242 passed, 8 failed
* arm64: 32 total, 32 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* powerpc: 52 total, 0 passed, 52 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 31 total, 31 passed, 0 failed

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
* rcutorture
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
