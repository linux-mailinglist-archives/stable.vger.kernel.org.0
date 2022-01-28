Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1060E49F863
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 12:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237001AbiA1LiY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 06:38:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232502AbiA1LiY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jan 2022 06:38:24 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 769C1C061714
        for <stable@vger.kernel.org>; Fri, 28 Jan 2022 03:38:24 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id k31so17635333ybj.4
        for <stable@vger.kernel.org>; Fri, 28 Jan 2022 03:38:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=oQ5s0T8kS0O7cDsVNaD75NNx+JQisRNysvdNyX8OTIQ=;
        b=kNNyjtFGM8aNqZ7leMkYWDjfeYjOe+ql0/yN5cwCy5j0Mvjp7bBWnjKn6GYI8Fl0n+
         z2kwd1quJcIVyEp3vJFpSR+HVlBvfZXbuibn6I0Ihy8uZQEhOOoRAyldr66+GA1G70gh
         bvgiLO3ozg20vPkrb9YXozTTTZJLMFSL6YEWsa4/uqoV+cKvssROyTfw2leQlGa/LX6U
         sHgYxIifmgxHJigiQCT0tnVuaeDgewPu/Zoh1WrW//K7V/yJ9q0Gvyg18ft+lpTsC7+S
         964RkDkMTrLX26DzIpsUbwEjtjrIDbbnHXZhIsUZe5wXnTiFUEJBrc5X+bTxJWRW9WCU
         h51g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oQ5s0T8kS0O7cDsVNaD75NNx+JQisRNysvdNyX8OTIQ=;
        b=ukp2xAhZCOJKD/y/RB25QGhCxHNF1DB2WBQ2WVFfx5hQlstUJwSBmZEVq1KokvT1i7
         VaYRKjBNDDb0II+TDuj+d4UXEmZ10De/5SpVKiJ06XwGNL6LrWrDWfPIRx3ytj19+ICV
         g5XjCC4ruqC11YgAlGMo1wCawxkB02+6Itx4MnoO8WLPkZilqysnmyr0jDcg6W3vQISD
         MTmUiMu0No2ztHd+zSIn2lysZSPpHcB3o9FFKJMkkTNG6FpNNcOR6YOdcS0Tc+K80PQI
         T0SGzMj4fInD4aFyosI0DCVkn0XiO88FmfwVgSrZZ6nMu0gmwca0LV82xAPffJyH3wyb
         kH6g==
X-Gm-Message-State: AOAM530ULrCPEDeem81vb8SgGJZWvjsfTcufFGJMl07WXhCv3jju4uVM
        Ray1kv1m1A6zOpFUxEzLanqA9SU/ppPtuapBOSAYFrmYTZrCVg==
X-Google-Smtp-Source: ABdhPJxaDzQR1NTvecMwVrka8of4rYbeNcMr1QpLf0DAg2mDM/y1ANt/9RD+bov9+2q8/4PSv6hkDXcNN/MVbbNCD8s=
X-Received: by 2002:a25:5143:: with SMTP id f64mr12951957ybb.520.1643369903499;
 Fri, 28 Jan 2022 03:38:23 -0800 (PST)
MIME-Version: 1.0
References: <20220127180258.362000607@linuxfoundation.org>
In-Reply-To: <20220127180258.362000607@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 28 Jan 2022 17:08:12 +0530
Message-ID: <CA+G9fYvdOyz-UyUnQSXy2M7jOOXCoO=3e5YqLQ4Ec3ULv7DNvg@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/11] 5.4.175-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 27 Jan 2022 at 23:40, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.175 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 29 Jan 2022 18:02:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.175-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.175-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.4.y
* git commit: aa3124a3444fd7cfa588271ffdc7d3cb77131142
* git describe: v5.4.174-12-gaa3124a3444f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
74-12-gaa3124a3444f

## Test Regressions (compared to v5.4.173-317-gb9fb58c8fa63)
No test regressions found.

## Metric Regressions (compared to v5.4.173-317-gb9fb58c8fa63)
No metric regressions found.

## Test Fixes (compared to v5.4.173-317-gb9fb58c8fa63)
No test fixes found.

## Metric Fixes (compared to v5.4.173-317-gb9fb58c8fa63)
No metric fixes found.

## Test result summary
total: 60336, pass: 50071, fail: 423, skip: 9268, xfail: 574

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 258 total, 258 passed, 0 failed
* arm64: 36 total, 31 passed, 5 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 20 total, 20 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 34 total, 34 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 52 total, 48 passed, 4 failed
* riscv: 24 total, 24 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 36 total, 36 passed, 0 failed

## Test suites summary
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
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-vm
* kselftest-x86
* kselftest-zram
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
* perf/Zstd-perf.data-compression
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
