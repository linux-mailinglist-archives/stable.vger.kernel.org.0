Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C272F4733FE
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 19:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237855AbhLMS3j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 13:29:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234487AbhLMS3j (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 13:29:39 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C47DEC061574
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 10:29:38 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id g14so54261167edb.8
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 10:29:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JVp+xWM4KFb2U5Tm2sWK0RVveL8ra0yv5BzRwMMdZQk=;
        b=hBZLbXLvI92rLqvMAnKAujm5/V/JDlnB3areZfiRGLNFPhm2QzYakzo3Tvg5xoCfAf
         kCxLrccvdx6Bm0tKCYeAOgB6V4DghsLj3jFts6M334RI7RBolB9Kg4v88J37K5lWT2wi
         dJhf5mDgnJdZklW0v3XpfqLG1gRnPbY9wsBA+zR1PZO6jpdjN/IZiyXduL0arYpky93J
         s1GA5KzB/mwXUb1NPqFRszFLg2b8ip0EUvuvPT9j9b0xKDlnGSGDfsrrHhWJoiuMVxRz
         btNgHZTWOrvor3tJklRuqQxpI6aA6xLdlvwR2uuaxtR2AO7DdAdSqoYSzM1+Ca3YpB7M
         1cvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JVp+xWM4KFb2U5Tm2sWK0RVveL8ra0yv5BzRwMMdZQk=;
        b=1ZnDepPsAaHt6mpUOZYboNj4XTUymupIgMmIMbjjyopIOxK+83On52JeWsiIjbY410
         YZVucRGxDVEtANYHKHF0UL1zoubyChArxrX/0//q8JK+05Ub9sKXARIc4GvSeEodt6U8
         SmIsF4N2Dm80+iJcfrYriJcFi8+FXHMoQxKamCfJ12hFNjWbgtligjZpifIJ+jXFSnyp
         2jEfeNZFe2Kt6unzWaqtBx9U9kIGZP1IZ/JNQSgv6zRZ+JzV8XZDV1ZleHINXVIT+Y99
         cC6G5UHrR4AI0FtSs49LyYoYPMf4zeMI1eRNn1FbvnHsHq4uUSfdHjVC9Y80vGMmEQAx
         Ee/A==
X-Gm-Message-State: AOAM533bfOJkCCYPGdNaOocaYTjOcAmW9CZ2R+4UFevV8/6ra1EmyQI5
        NdKWRlNRVl066z6cz0/f6G6NIk/7yZTHywDP9lgj0A==
X-Google-Smtp-Source: ABdhPJxog21TNQxLva1xrLe3ix1jmAP0WPS+rYpoedG974KVZVylJeGmyXpFaVgFi8rllCLkbAaiOuP0AUsjTBljW84=
X-Received: by 2002:a05:6402:4b:: with SMTP id f11mr535537edu.267.1639420177047;
 Mon, 13 Dec 2021 10:29:37 -0800 (PST)
MIME-Version: 1.0
References: <20211213092939.074326017@linuxfoundation.org>
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 13 Dec 2021 23:59:25 +0530
Message-ID: <CA+G9fYtxrPzTkPc-RE6U8ERtcngdqr9xqKDs=czYu6ePyn6QFw@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/132] 5.10.85-rc1 review
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

On Mon, 13 Dec 2021 at 15:17, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.85 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 15 Dec 2021 09:29:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.85-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.85-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: f6a609e247c6d6f15ec8c4a87c9aef37b7c8e5a5
* git describe: v5.10.84-133-gf6a609e247c6
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.84-133-gf6a609e247c6

## No Test Regressions (compared to v5.10.83-131-gea2293709b3c)

## No Test Fixes (compared to v5.10.83-131-gea2293709b3c)

## Test result summary
total: 83789, pass: 71973, fail: 330, skip: 10774, xfail: 712

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 259 total, 255 passed, 4 failed
* arm64: 37 total, 37 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 36 total, 36 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 34 total, 30 passed, 4 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 52 total, 46 passed, 6 failed
* riscv: 24 total, 16 passed, 8 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 0 passed, 1 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 37 total, 37 passed, 0 failed

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
