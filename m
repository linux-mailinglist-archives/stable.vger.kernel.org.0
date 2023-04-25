Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6166EE2FD
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 15:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233908AbjDYN2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 09:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234179AbjDYN2t (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 09:28:49 -0400
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC6F13FBB
        for <stable@vger.kernel.org>; Tue, 25 Apr 2023 06:28:46 -0700 (PDT)
Received: by mail-ua1-x931.google.com with SMTP id a1e0cc1a2514c-771d9ec5aa5so24394320241.0
        for <stable@vger.kernel.org>; Tue, 25 Apr 2023 06:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1682429326; x=1685021326;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NllGsEqMzGXu5viPglJVIsvFzhqzi9wZzRT5T4cie1g=;
        b=aFz1aUGnwzHfKAw8AGjqrko6/GHBuCqp1CXO0/iH5CpNa1uoCGBSCCKyAPxxIuO0GR
         UriBUsaukmAyHoyquBb9jJmV7iJYmbgwHtnpdn5/EPMReLL4N5j/KEaqNwxCAVk8IJl2
         rlPjH+3vw0K3RjQu0200b4uYdmHrFeB5kFUaEBO0wbq8o2Jcefh7MsIyGPKxyoVIqJ5z
         ezLOAKeDSZ1noRKILSNzCxRec/+H0TJbwsSVBY9OxTnBfv/7DQA7SsuD9f+nBbiMBCff
         9PpxIPQnDkVsKyyYYgzKlnSxp5aQpq8TzCttLabaV985Zl+21axRC4Hzl/14/ilcu8aV
         dBuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682429326; x=1685021326;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NllGsEqMzGXu5viPglJVIsvFzhqzi9wZzRT5T4cie1g=;
        b=fBNm0/kY5mMg9EM2uNfAPX4XPv0Pi+9YMNvGHt/EZfvlMPfP1qI2r645iBhnCfqulK
         aDR0Pg9DsrznqL5v/uqj7oud29hmoedYdHZ6wUGrfKL88LVOe19Jr/psoXfV5tPwr6L2
         3LO8opBchIjsJXu3T5IhUoEGUpukMx8f2OyeiknTAKaoH4YOamxAWuuM13sqCIsgW6q8
         NYSxdIyl5AeX79sLaZbSdvlVbCyWKxg5f1YJYLTGfXDtymF17OVIAbXkAEJrkGQa+TYA
         SRSo64E34Kb/2Ktgb78DzRRlqRbzdyoYGYKU00Yy6YzoblpSEoVWtP/T0RRLsTRC5JhE
         i9hQ==
X-Gm-Message-State: AAQBX9dVVcMMX/NccsOJ96LgTzOYU22vEAD47Al1wdg30MEhhzzX8lBm
        9DKTAs/JsfuYQrOvZ0TIU3oQsOLjyPQBnUSkhmzlqg==
X-Google-Smtp-Source: AKy350YZDg2Qz7ZUktgKpEL/E4vTcNsr9+rfN1Wx1fe5fqzCaxSmSF6LO3mNMYif8dTF0FZzozSeHEopJ1vPOiVVYUw=
X-Received: by 2002:a1f:3fce:0:b0:432:e55:b103 with SMTP id
 m197-20020a1f3fce000000b004320e55b103mr5640565vka.3.1682429325574; Tue, 25
 Apr 2023 06:28:45 -0700 (PDT)
MIME-Version: 1.0
References: <20230424131127.653885914@linuxfoundation.org>
In-Reply-To: <20230424131127.653885914@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 25 Apr 2023 14:28:34 +0100
Message-ID: <CA+G9fYtFuBxa-zifr9VjPhpYLoZL=o1soggkFLADWPfawcb4eg@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/68] 5.10.179-rc1 review
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 24 Apr 2023 at 14:34, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.179 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.179-rc1.gz
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
* kernel: 5.10.179-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 1ef2000b94cb2a0bc4a1e822fd21885e80d65646
* git describe: v5.10.176-363-g1ef2000b94cb
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.176-363-g1ef2000b94cb

## Test Regressions (compared to v5.10.176-294-gabbd2e43cd45)

## Metric Regressions (compared to v5.10.176-294-gabbd2e43cd45)

## Test Fixes (compared to v5.10.176-294-gabbd2e43cd45)

## Metric Fixes (compared to v5.10.176-294-gabbd2e43cd45)

## Test result summary
total: 130665, pass: 104853, fail: 3680, skip: 21897, xfail: 235

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 115 total, 114 passed, 1 failed
* arm64: 43 total, 40 passed, 3 failed
* i386: 33 total, 31 passed, 2 failed
* mips: 27 total, 26 passed, 1 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 26 total, 20 passed, 6 failed
* riscv: 12 total, 11 passed, 1 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 36 total, 34 passed, 2 failed

## Test suites summary
* boot
* fwts
* igt-gpu-tools
* kselftest-android
* kselftest-arm64
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
* kselftest-ftrace
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
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* perf
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
