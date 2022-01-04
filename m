Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E71934841FD
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 14:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232035AbiADNA5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 08:00:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiADNA4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 08:00:56 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD7AC061784
        for <stable@vger.kernel.org>; Tue,  4 Jan 2022 05:00:56 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id w13so74034661ybs.13
        for <stable@vger.kernel.org>; Tue, 04 Jan 2022 05:00:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PkcRppSYV/Op80xRnLwaZbvaqOmgOdKBtzH+TM2RJPE=;
        b=wBWXv0D86aXI6i4pIfqFupPf3o7e9m0oN/TaPVE/4RNLJbLuZWeqYNfCD7kZkT0R8K
         MGjY5O2KM1OALUMbJkaVjkyEMyOhyQKzvVxRqeeFHd0+XR4Hi/6HL7LzpcFjAPJjiMKc
         pM2az0Xa/jE8/6w/AYNst0//sY069wXxQ0gn8TuU1zLJ7uanLxySEz/W8YWxED7jX3oe
         Y/HH0JbIVhKIfrSCU28FYF3xjtjMsC8PzigsPj0Sav4jXXmap7VS9shGZ+dentNoPb36
         uVm76NJW852XDPYfnV/pHkye5Ond4+L6gPr4z+NOkHr+JaNFbN0FEq0HexklyfbH42Av
         m7xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PkcRppSYV/Op80xRnLwaZbvaqOmgOdKBtzH+TM2RJPE=;
        b=4g0j1lkGfwLbQCqbwI1fUcBji6XDD4m3651pZyz2y6x8W3HyAVd7rfuOAzgN+StINq
         Sst1CpdnL+owxCWPmpzk73kf0+yLmLZBRpOimF6RcF1NzIf8lo9IkP5vxkzmOG7P5TRy
         fbV3ppqdHPCCotewBEr1Gz5mrM8gtxsKaJx1HEOG7Vc3Sin/xvPu8v1iwZYWo1r7ZaTC
         8AncuTI9GRzawnY4toS+vOtpxNVwYptItz2IE2lX+bQb9ApqWf9kG9VXcgwKMkz6fupW
         SXooCPGm/fLvZYRKgGmDHCbsOZQ6jtsIS4DAatTZ7e50gWwDBhan8QLwEY+ziC1O/I5E
         1HRA==
X-Gm-Message-State: AOAM533LV+pHE7HQeqnUv3d8zudA4czOWYqF/P5rOCgOdWFHCzPqle4F
        B6MvGpzqRK+ASFSjf9x2dcErFKcZlRRl7QzCzQl/zg==
X-Google-Smtp-Source: ABdhPJw7XGdryR/EMgGTWh0Voijrjja+wLHEPTmtwPnmXMN/cUVV2OYslYyM7LbJekkzHOsXV7N3icUZVldpKYA9WsY=
X-Received: by 2002:a25:414f:: with SMTP id o76mr48286740yba.146.1641301255629;
 Tue, 04 Jan 2022 05:00:55 -0800 (PST)
MIME-Version: 1.0
References: <20220103142052.162223000@linuxfoundation.org>
In-Reply-To: <20220103142052.162223000@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 4 Jan 2022 18:30:43 +0530
Message-ID: <CA+G9fYudUP1FyZp7vpYTHKh+SSNhOxvPnyatmByiCWzeCQbtvQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/27] 4.19.224-rc1 review
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

On Mon, 3 Jan 2022 at 19:56, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.224 release.
> There are 27 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 05 Jan 2022 14:20:40 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.224-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.19.224-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.19.y
* git commit: 3285af6cecfcf350536b55f95214b08192ff25f2
* git describe: v4.19.223-28-g3285af6cecfc
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.223-28-g3285af6cecfc

## No Test Regressions (compared to v4.19.223)
No test regressions found.

## Metric Regressions (compared to v4.19.223)
No metric regressions found.

## No Test Fixes (compared to v4.19.223)

## Metric Fixes (compared to v4.19.223)
No metric fixes found.

## Test result summary
total: 73951, pass: 59880, fail: 643, skip: 11816, xfail: 1612

## Build Summary
* arm: 130 total, 130 passed, 0 failed
* arm64: 35 total, 35 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 26 total, 26 passed, 0 failed
* powerpc: 52 total, 48 passed, 4 failed
* s390: 12 total, 12 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 34 total, 34 passed, 0 failed

## Test suites summary
* fwts
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
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
