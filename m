Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA9740F691
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 13:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243615AbhIQLMd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Sep 2021 07:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243563AbhIQLMc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Sep 2021 07:12:32 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6591C061764
        for <stable@vger.kernel.org>; Fri, 17 Sep 2021 04:11:10 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id c21so28399021edj.0
        for <stable@vger.kernel.org>; Fri, 17 Sep 2021 04:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=gPEcD6kHhhOp4xpo/yeBBwxKSMM2lHDzPZaDYndVP4w=;
        b=qiFcc9Qa5cNDauQUOeT4SDWk3NHhChgzsPlumoi7ggae4wEDToF8FIeogEmcICJwb1
         TNUbgsgUMo1/21hqVwLnkD2b1VasG+DXOI2WmmJUSHcstLU7W/ybDbRw4fcjyvFZbPD7
         QN4dw7eBsL4rx/ZosDE9sDRC5v0HWX98+533cm5bqkaQ2+cX1atKfBoWh39oWxFC3lQf
         LyaBwJaf4lGLoprH4OtocIbOFo7jMg+ErPnPNjfjOxyxQjyj0oJlcJN9z4m1IdvIxuO8
         huOECVdHTiX2TMR6a0FXbJNXKQ1VNFng2HbpWNpMwrjiLBGIa7yW8ksrHkirYQhTG2VH
         MBaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gPEcD6kHhhOp4xpo/yeBBwxKSMM2lHDzPZaDYndVP4w=;
        b=kzLZTiGl/YIbsN9rYkcg1oOJg65uc0lIPex4dcQc0/6GSiq7aAzPpi+gH28h9TXj4X
         30xQ1vEP68hrqwVCsM6x8DmOgp5kH7J0HH11Pn4zw5dO3yNDzc+akpxpc3r7EJoW95oA
         4M23iT8EVw3WuGvGBzAjMO21iUAajmk/SkoW4MfNWqNdivZaBlWUtik2F9VSFT73J2p5
         AKeE9TkwfRyvXkAQseEmQDF5Y+FfwCs8F7ypzQTAMspYUGqYAez3NffZJcrdr0YQup3R
         eaiYCAJge9LrxH9oXBZyjwoRlGo2Fyw9mPgJUFgKHIoLWwoCyKr2zSriKt2fdkmfJMqa
         +5qA==
X-Gm-Message-State: AOAM533tO/PLVr3rxtpJmruRK2rLP7hPDggH6e/3xh8HnvEkMdIKIKWB
        MRjV6pY56oQIl39GpqVJIFgBE2W7ESXOM7unnq6vIQ==
X-Google-Smtp-Source: ABdhPJxiewNmmMeYI37zi1TJCw0iBx4nAUotcS4CeNjjB92m6I8CE3P1ZMROUnidnBOCHFgIRWUv5oXpV5EpR+4AyvA=
X-Received: by 2002:a17:906:681:: with SMTP id u1mr11433574ejb.499.1631877069134;
 Fri, 17 Sep 2021 04:11:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210916155803.966362085@linuxfoundation.org>
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 17 Sep 2021 16:40:57 +0530
Message-ID: <CA+G9fYvUiVXwAGcJ0K6sx4m0pJEU0AKodo5KrWo3AbywRqRwZw@mail.gmail.com>
Subject: Re: [PATCH 5.13 000/380] 5.13.19-rc1 review
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

On Thu, 16 Sept 2021 at 21:47, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.13.19 release.
> There are 380 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 18 Sep 2021 15:57:06 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.13.19-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.13.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.13.19-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.13.y
* git commit: d32cd39db441202928dd0b4aaae98f80d3bcd7a5
* git describe: v5.13.18-381-gd32cd39db441
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.13.y/build/v5.13=
.18-381-gd32cd39db441

## No regressions (compared to v5.13.17-69-g9af0951786ff)

## No fixes (compared to v5.13.17-69-g9af0951786ff)

## Test result summary
total: 94139, pass: 78739, fail: 1134, skip: 13277, xfail: 989

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 289 total, 277 passed, 12 failed
* arm64: 39 total, 39 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 38 total, 38 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 51 total, 51 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 36 total, 35 passed, 1 failed
* riscv: 30 total, 30 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 0 passed, 1 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 39 total, 39 passed, 0 failed

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
* ltp-co[
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
