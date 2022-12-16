Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C321C64E972
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 11:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbiLPK2i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 05:28:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbiLPK2g (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 05:28:36 -0500
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADC673B9CE
        for <stable@vger.kernel.org>; Fri, 16 Dec 2022 02:28:34 -0800 (PST)
Received: by mail-vs1-xe2d.google.com with SMTP id m2so1837702vsv.9
        for <stable@vger.kernel.org>; Fri, 16 Dec 2022 02:28:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J6ucSlUIJQ1T3Xb8zYhLtjAYkfGqwkT9BaXxaN/wQuo=;
        b=gMfd2gTvW04YnqnIMeJRl/g9+viviOSHV1A9IATAforecynFRMDvhmK5Q1b6ATS32H
         PUYk/qWTmUHDd8cjI8jpr+qXRVptrMAhzOiHSlQP/GNEZ1t9isqSSjM50/DPF4Zhsimd
         +ko8TnAWVKtNQMsDe0G34TF94hVrbbiK+agt6hol8Wp0jT1bwJbGrTo+ttqZQ7bJWaB/
         1zQKIHV32EHo1ttz7QgZgP225V3BPjhiiuDra/wMJlG/qa4kSMzRSWWiomJeZI7tfQMc
         +7ozw44233/ReTAxpCs32keIFtSLZJH61LzJglNLjAnjfg6jV60fePEggccq3Dq8mDOF
         BXfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J6ucSlUIJQ1T3Xb8zYhLtjAYkfGqwkT9BaXxaN/wQuo=;
        b=EeMlsWoLnhEw1QdvIHJ6xKXUqoOMj4D9PhBiM57SSb9FBVH08/xKTihLteGEjSUvDW
         3bM6Ot88la9ktaZPfyEOci2SO0LbHdjzGkOeIAYxexIeZ8sEF8wawoz3M/2SUNdJuTqs
         y6SrMfpZc8+pY1q0tIL8kTW568g17wOL2/NU2Oo7GmXQFVNYhWZDmpkoOzCee9rERgY2
         H6nIXDmVYvPzdv+Jf/yHVFfY9frFS8suFxyg9bVyQpP3igf0V3t4BnBNhYKWeAItqPjk
         aAyFivfb6bgc8H2xH+Y63P7AMWFOPnfvtTvWtQ5GjWK1IEStnNZqlS7OxJa5iWPX8JhJ
         KQaw==
X-Gm-Message-State: ANoB5plEemISAkkjhDaZBTK/A2gSSqwsEPFdZYprwPZYaKsb2c815RAA
        LpvDP/i0qN/GWbbh8z559UKdmVwJ1Y5VVGVMcsagZA==
X-Google-Smtp-Source: AA0mqf6TJQJ9eK8Gx851LWOtKrRuasSPlzLPwyKt2bRX8shUEn11JHjjCB6Smgy0dJKYqIaxfXPORs5xGOIxACVX4xw=
X-Received: by 2002:a05:6102:21b6:b0:3b5:21d5:5a0b with SMTP id
 i22-20020a05610221b600b003b521d55a0bmr1434849vsb.34.1671186513626; Fri, 16
 Dec 2022 02:28:33 -0800 (PST)
MIME-Version: 1.0
References: <20221215172908.162858817@linuxfoundation.org>
In-Reply-To: <20221215172908.162858817@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 16 Dec 2022 15:58:22 +0530
Message-ID: <CA+G9fYueQerxtbA5ztU+UmS8fuO-3mdCtmyxozTkXq7ph-snFQ@mail.gmail.com>
Subject: Re: [PATCH 6.0 00/16] 6.0.14-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 15 Dec 2022 at 23:43, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.0.14 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 17 Dec 2022 17:28:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.0.14-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.0.14-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.0.y
* git commit: 8173f9d249ceafc174d1a8ef6e57cc081050e705
* git describe: v6.0.13-17-g8173f9d249ce
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.0.y/build/v6.0.1=
3-17-g8173f9d249ce

## Test Regressions (compared to v6.0.13)

## Metric Regressions (compared to v6.0.13)

## Test Fixes (compared to v6.0.13)

## Metric Fixes (compared to v6.0.13)

## Test result summary
total: 148752, pass: 129979, fail: 3354, skip: 14961, xfail: 458

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 146 passed, 5 failed
* arm64: 49 total, 48 passed, 1 failed
* i386: 39 total, 36 passed, 3 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 38 total, 32 passed, 6 failed
* riscv: 16 total, 16 passed, 0 failed
* s390: 16 total, 16 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 42 total, 41 passed, 1 failed

## Test suites summary
* boot
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
* kselftest-drivers-dma-buf
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-filesystems-binderfs
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
* kselftest-net-forwarding
* kselftest-net-mptcp
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
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-cpuhotplug
* ltp-crypto
* ltp-cve
* ltp-dio
* ltp-fcntl-locktests
* ltp-filecaps
* ltp-fs
* ltp-fs_bind
* ltp-fs_perms_simple
* ltp-fsx
* ltp-hugetlb
* ltp-io
* ltp-ipc
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-open-posix-tests
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* packetdrill
* perf
* perf/Zstd-perf.data-compression
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
