Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5678164C3B5
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 07:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237152AbiLNGPB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 01:15:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237124AbiLNGO7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 01:14:59 -0500
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E43101D9
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 22:14:58 -0800 (PST)
Received: by mail-vs1-xe32.google.com with SMTP id 128so16902677vsz.12
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 22:14:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gwP00HaRKNntjcX+wACKDLZ52in31pSO44L1T14/KNA=;
        b=mnGHwohdnQDmfaJjDf/nCcIiK+ONq6oZcCtN68MM/RQGpcGR3NXSt0FSJOMcDELSwc
         TAv6iZlAbYCEkxnSmAUn9ZokaH4MpyMAE5j2Mcg4n6uEzTlKQY2tKwmlPpYFwRLFPIIG
         eaxClv08CY9tsEvvoeBHY34QWV5o1/aPb+0w9eJPrVoCwpxL/zrFbaceNNGZSDnXdbYt
         cJxhftdotcJ3umGU5bmrZpPo9nvFVOEZM/AcehRjBYKvJ1fxqc1Ga5udvWj1tUjofADP
         wReQlmEHNKDciELJXT4+ryAWkOwbaoHZHUSTdc7L2nU4pbYjM+70vPXvqlhWjoRnieWR
         Oy+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gwP00HaRKNntjcX+wACKDLZ52in31pSO44L1T14/KNA=;
        b=nFFBNAdx4eXKzkPLAnj5szZ8nIZ4mlG1tzs8fC+XckajF13fEiytwMaChzizyWF3fs
         S4319rt6pgdhCCI1ucIWwMt5WWvZxo+oKdGFCO8Lzrs4j/vZxaT4cwuv3KoIvYmPLdIX
         VV/fgrsqpjHOMGNm9e6BpX1gwrwFzQkk5Kfntc/hxR4vMyUGmpg6vimCZoCkQEusZ6ff
         CBVlElgcZ4j17O58xCpVcLIb1hhfcAMeo0AMwzKQ5g60XKe9ENrSVeB6VJkHlmj630Pb
         lSHpz6rx2cL/BcX+KNfFm1l2YkxpM96BBeWjqNERqXk6wBKBMTL97dlDH+WywJVHvLXp
         eyRA==
X-Gm-Message-State: ANoB5plT5vM9Ue4LqmElQ17QGNm2FQTZPQq5CRMx7D7mJiZkXdmMBkKP
        +ZO/gLOuPds90JfIy8KhaZ66axh1F+tzJDtJkdwHHg==
X-Google-Smtp-Source: AA0mqf5znL8dl58w9Cvl0lnGwwvSC/YNoKpWfp7qIIZT3R+MvRjVoJg6HFabQPeHqMYglbunt+onIURScTHP+M1Qqo4=
X-Received: by 2002:a05:6102:3ca1:b0:3b5:d38:9d4 with SMTP id
 c33-20020a0561023ca100b003b50d3809d4mr1176068vsv.9.1670998497525; Tue, 13 Dec
 2022 22:14:57 -0800 (PST)
MIME-Version: 1.0
References: <20221213150409.357752716@linuxfoundation.org>
In-Reply-To: <20221213150409.357752716@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 14 Dec 2022 11:44:46 +0530
Message-ID: <CA+G9fYsaO+TVzsMZfZ1iQZHc7ZHQ44jRL2k6vhSNNJR+18rv=w@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/98] 5.10.159-rc2 review
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

On Tue, 13 Dec 2022 at 20:35, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.159 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 15 Dec 2022 15:03:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.159-rc2.gz
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
* kernel: 5.10.159-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 2c8c8e98b2ec8658a461e9400b1e5ab632957a17
* git describe: v5.10.158-99-g2c8c8e98b2ec
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.158-99-g2c8c8e98b2ec

## Test Regressions (compared to v5.10.158-107-gd2432186ff47)

## Metric Regressions (compared to v5.10.158-107-gd2432186ff47)

## Test Fixes (compared to v5.10.158-107-gd2432186ff47)

## Metric Fixes (compared to v5.10.158-107-gd2432186ff47)

## Test result summary
total: 143152, pass: 124378, fail: 2501, skip: 15776, xfail: 497

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 148 passed, 3 failed
* arm64: 49 total, 46 passed, 3 failed
* i386: 39 total, 37 passed, 2 failed
* mips: 31 total, 29 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 32 total, 25 passed, 7 failed
* riscv: 16 total, 14 passed, 2 failed
* s390: 16 total, 16 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 42 total, 40 passed, 2 failed

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
* kselftest-net
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
