Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 796B8414172
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 08:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232532AbhIVGDJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 02:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232490AbhIVGDH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 02:03:07 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97AD1C061574
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 23:01:37 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id u27so5442041edi.9
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 23:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3syTq4/tzib2rK7RtXh5Ih809sKUxv/VFh4jqrn6bPw=;
        b=t133q1qIttr1oqi0+lGQF1VbjoN90XY0e/6wWGK4YnDfSjYHxUIaMq1OOJpAFhxmhk
         HZ4l3RCaEqoOscfzclIGtf9Xh+6yDU0HZuAgMYfFVvzV9NVe5MMdPefwJ28r92b+vMbx
         q+cTG6UvQBUTxNEVNbqQiF1/NWvkrcywFi+4lIuWFt2LaLLpGqurx00OMOx5YI2rVhHE
         7romj6OD5DXLKQjHsqCKDd8VOdFZQAd6qM3zTsVHjYK641elxOOi80dRdZEMjQ60SFYN
         g+wF2stIplUemRbEXkIH4ZRa/V23kj6SJRd3yvWW8w7m9kCWdGdI0VdzVnqqZnFYf++a
         vbKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3syTq4/tzib2rK7RtXh5Ih809sKUxv/VFh4jqrn6bPw=;
        b=eAeG5qamXLpoK8xjoTkqrIgEryh5asvOr5FXGX9dkNGP4V6XULr2+bpGVL0Ax5TwxX
         Mvy3WL40eish52WByi3Ornbk+hBHWdDE7lM65q1JGOk/aBtSQFEG6vtLiIu4FujNvuC/
         GSrS2+l0mEYDf9sWr0cAwfahnmaxrmxzjEN2oq4j+EUbW+9IWb7Z0oDidUdVfVldyiHd
         ak92zZW1ks6LKYrEle6osgJn4JvXgdrjJYyN0yeNVNxLfmPr/dSt/UvzQXyemcBqU7JH
         upv36s37L4ktoqnOjPGw2MZt+qYcgFpY2RMXBq5x2xZJSuUz+Gl9PPEnlywC8dsuV8I3
         CywA==
X-Gm-Message-State: AOAM533/eG3QFmwUeXGTrOFPPSCnd6Mfx90RCgWYANKaSbBWmFRe8Mwz
        dI7NDphH8rq955A4ycW9tB+os0r7qV6jemTeg5qr8A==
X-Google-Smtp-Source: ABdhPJwvyS2lDI0AYf1Luaq2MnWWnNA0X0qAWgXLfF81S77yco4h7JewtZ2s1EjHG533Wbei6c6A87aAkqwndJWCnm4=
X-Received: by 2002:aa7:db4d:: with SMTP id n13mr40623760edt.398.1632290496032;
 Tue, 21 Sep 2021 23:01:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210921124257.592357088@linuxfoundation.org>
In-Reply-To: <20210921124257.592357088@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 22 Sep 2021 11:31:24 +0530
Message-ID: <CA+G9fYsroqC5g2GaoUw+DKuLZZs6vyKS5cAzsv-qW_ULX_OT4Q@mail.gmail.com>
Subject: Re: [PATCH 4.9 000/174] 4.9.283-rc2 review
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

On Tue, 21 Sept 2021 at 18:19, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.283 release.
> There are 174 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 23 Sep 2021 12:42:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.283-rc2.gz
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
* kernel: 4.9.283-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.9.y
* git commit: 92ec5706360024e85585ba08e42b7350d6cd6c48
* git describe: v4.9.282-175-g92ec57063600
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.2=
82-175-g92ec57063600

## No regressions (compared to v4.9.282-166-gfc76dad660a3)

## No fixes (compared to v4.9.282-166-gfc76dad660a3)

## Test result summary
total: 64756, pass: 50432, fail: 535, skip: 11682, xfail: 2107

## Build Summary
* arm: 129 total, 129 passed, 0 failed
* arm64: 34 total, 34 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 18 total, 18 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 36 total, 36 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 18 total, 18 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* install-android-platform-tools-r2600
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
