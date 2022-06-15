Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 678BE54D0B4
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 20:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346215AbiFOSNC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 14:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231737AbiFOSNA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 14:13:00 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 172DF1FCC1
        for <stable@vger.kernel.org>; Wed, 15 Jun 2022 11:12:55 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id h27so21940522ybj.4
        for <stable@vger.kernel.org>; Wed, 15 Jun 2022 11:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Z16pRFrlVSPEJ9xrRNhHHI7LBf4bDfmCRp35UKvSt4k=;
        b=VtyKmitPcYg09JDzUVBPZ5S6YIFz+6XPx9B0hLW3bW2qQhyex8WgwfIRtF1/yr2XsH
         TbqLRCneP/SNdXsZpEcPik0sjLzLAPZ7hrBV6BNbYpcU9BKUHtLSxO+t+SsnZ3HKT4Dq
         TBJXZ7KB6kZljE9nylvVCmaRl1PHG0ZfMaLZtGM/ZMFPa+/JX0z2t4P4raOsz/qJGwNH
         1ZZ6pxqW6Z72rgouQd764O6w2DID43cIlK/wtgu8Vr09F/foL+askZvuhzoqqFyVSXX9
         h9pkmUJzOuWkKBXeFgnh/NtiZ9hAqshYLUKbED6rT3qIqlXdklYzQU6q97RO4MOFWiTK
         t3hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Z16pRFrlVSPEJ9xrRNhHHI7LBf4bDfmCRp35UKvSt4k=;
        b=kizZguu2a0GDQrc/OWtZW0EUvicsFC0z91tEzEto9ZJhAYVGwD4de7QwttjWUioAx4
         UIsPwEePDUGPhnlDrclchI/3eyUZJRuHrz5yIfV2z7D9uQ8/5yyPnd9auDrIuzbBB3ca
         Taeocxo95XaJ8puxlBhQ0kn9PvvCh5RylZ+zGbZXlCoFZpPCDNS7qmY3aKLRs3fKqZj0
         CXGNtupqFBpzn8IL9NJeFDV9Z5pYonmXdEEFxjrmRsInK80AP34UFoCgGeR4u6FoFKgj
         ogH84F3bE8BBfV1qzu8bnDK64fprwPaVeZ7YkxHNpyTvWhXkuUd5GeOaZ1B4Ew9TSowZ
         S3WA==
X-Gm-Message-State: AJIora87XNa8TqZQkAAm2xY7qg3aMCg8L7UIIRqejSiEWAGXjXasfeY0
        8NDHxhI3ZkqaMa6ShKXtGOXpqQCjSh/nq7AwNodYt0HY3ITVwprv
X-Google-Smtp-Source: AGRyM1tJLtrGpehLrr2n0Fe53ACsL/DTs7nIGPdRBRUjYBRB5lguCaNgS5P5xgX1OhBN63gsXLn61AZR7kNeVBdquzU=
X-Received: by 2002:a25:d913:0:b0:664:67a5:29e3 with SMTP id
 q19-20020a25d913000000b0066467a529e3mr1310128ybg.592.1655316774128; Wed, 15
 Jun 2022 11:12:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220614183720.861582392@linuxfoundation.org>
In-Reply-To: <20220614183720.861582392@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 15 Jun 2022 23:42:43 +0530
Message-ID: <CA+G9fYu6voXw7-DKw6+un4yaKwx7Uw4BB9GeuR-gMYJX6CM1Jw@mail.gmail.com>
Subject: Re: [PATCH 5.18 00/11] 5.18.5-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 15 Jun 2022 at 00:16, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.18.5 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 16 Jun 2022 18:37:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.18.5-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.18.5-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.18.y
* git commit: 0e32b2c68ea4d90e0ecca45afd07dcf5d594de7e
* git describe: v5.18.4-12-g0e32b2c68ea4
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.18.y/build/v5.18=
.4-12-g0e32b2c68ea4

## Test Regressions (compared to v5.18.4)
No test regressions found.

## Metric Regressions (compared to v5.18.4)
No metric regressions found.

## Test Fixes (compared to v5.18.4)
No test fixes found.

## Metric Fixes (compared to v5.18.4)
No metric fixes found.

## Test result summary
total: 127841, pass: 115630, fail: 544, skip: 10874, xfail: 793

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 319 total, 316 passed, 3 failed
* arm64: 64 total, 62 passed, 2 failed
* i386: 57 total, 50 passed, 7 failed
* mips: 41 total, 38 passed, 3 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 65 total, 56 passed, 9 failed
* riscv: 32 total, 27 passed, 5 failed
* s390: 23 total, 20 passed, 3 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x86_64: 62 total, 58 passed, 4 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-android
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
* kselftest-gpio
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-lib
* kselftest-membarrier
* kselftest-netfilter
* kselftest-nsfs
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
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
* kselftest-zram
* kunit
* kunit/15
* kunit/261
* kunit/3
* kunit/427
* kunit/90
* kvm-unit-tests
* libgpiod
* libhugetlbfs
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-cap_bounds-tests
* ltp-commands
* ltp-commands-tests
* ltp-containers
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests
* ltp-fcntl-locktests-tests
* ltp-filecaps
* ltp-filecaps-tests
* ltp-fs
* ltp-fs-tests
* ltp-fs_bind
* ltp-fs_bind-tests
* ltp-fs_perms_simple
* ltp-fs_perms_simple-tests
* ltp-fsx
* ltp-fsx-tests
* ltp-hugetlb
* ltp-hugetlb-tests
* ltp-io
* ltp-io-tests
* ltp-ipc
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl
* ltp-nptl-tests
* ltp-open-posix-tests
* ltp-pty
* ltp-pty-tests
* ltp-sched
* ltp-sched-tests
* ltp-securebits
* ltp-securebits-tests
* ltp-smoke
* ltp-syscalls-tests
* ltp-tracing-tests
* network-basic-tests
* packetdrill
* perf
* perf/Zstd-perf.data-compression
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
