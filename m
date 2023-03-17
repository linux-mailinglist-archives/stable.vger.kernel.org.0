Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76F856BDE9F
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 03:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbjCQCdZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 22:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjCQCdX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 22:33:23 -0400
Received: from mail-ua1-x932.google.com (mail-ua1-x932.google.com [IPv6:2607:f8b0:4864:20::932])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA4B2C64C
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 19:33:21 -0700 (PDT)
Received: by mail-ua1-x932.google.com with SMTP id v48so2469140uad.6
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 19:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679020400;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/29vahDq+IahclEIO3DqdUneYi5GpXJQJAJm71A3XfQ=;
        b=Wd5ZkxLw4+Tx76Qi2UxtLWnf3DstimMl1Ge1JEgwOOJYirLkItALIyA2uSTUYLLVi5
         Pky2SYJEzblGGzw84/aDoERI28pvsdNlQvUkwszvIRjo2a3R06RprL3jFk+6IighMIyr
         7kvmq1Hz5ay6OK8U3MJoDCL+d+gqkMdQfTpNZoXt5m1rgRevF4+YSCZdwot6SXaPpM1Q
         w9mTg88avKFa2zBMiVzV90x4wFORGAa29D8QKPDMOPVc9EgNuYPy5XN8buraRNZIahnu
         HrcpW/ksBlMg593JBZ9dTftmfouy/AsD6p3oaxoOCqN6DwENu7xfEZJu3j+n0GFfxnjn
         CQKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679020400;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/29vahDq+IahclEIO3DqdUneYi5GpXJQJAJm71A3XfQ=;
        b=Dh6WTegkqE18SwTESiaSJXKpm617G+ET7Lk9q/cMMbIR37Z0l/nJadb+JTR8bv7OFx
         hQ4Pa7zIJnPWITwLzKRuPsBLqaAR7BNOtbTaSQE6cdOlfbQllQ+a04JjkrJvT0lKUWgX
         mTHhrTRV4Z8HpgTy2FapuuKqK5szyojrgYSuU5yAxLMJZRrNGtCfwudB6rwMhrAqTooi
         z5w1HCSA89bNUdChvbP1l0ubnpqKnKFqL0e5/Twcsb1S1Agvz1OmktWtYusSSRebDJYD
         qy5lCgb9OeTMR2+BCFiDUageWFLioNoUk/0tDZ6EcWq740mhzTAjE+z7TNcoqu4aPcHM
         VqjQ==
X-Gm-Message-State: AO0yUKWK2V2r5nv+7KhEOjaFRWlkTRtwi0yjNDOLwjbWNCjL8t9l9yzN
        OkQ34E0+zhNZvz2L1RN/Fd3VgeB6OVkvRuOkRNi/VA==
X-Google-Smtp-Source: AK7set9UurZSx4mwUvtzm0f7zfh1TxXciq/dMpK0gv4nD8/JSRYoaikln7SYbfdD14YxI53hbDtfO2TLXOkokgnBll0=
X-Received: by 2002:a05:6122:c8f:b0:401:7625:e9e3 with SMTP id
 ba15-20020a0561220c8f00b004017625e9e3mr1275144vkb.1.1679020400302; Thu, 16
 Mar 2023 19:33:20 -0700 (PDT)
MIME-Version: 1.0
References: <20230316083430.973448646@linuxfoundation.org>
In-Reply-To: <20230316083430.973448646@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 17 Mar 2023 08:03:09 +0530
Message-ID: <CA+G9fYt9KrMohHLEpbPc2CxzNS28hnss7=qnCYGvpbi34_p7rg@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/91] 5.10.175-rc2 review
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
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 16 Mar 2023 at 14:20, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.175 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.175-rc2.gz
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
* kernel: 5.10.175-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: ba6c29f68bb2cc2c8bf9fbffe4856db450c9447f
* git describe: v5.10.173-96-gba6c29f68bb2
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.173-96-gba6c29f68bb2

## Test Regressions (compared to v5.10.173)

## Metric Regressions (compared to v5.10.173)

## Test Fixes (compared to v5.10.173)

## Metric Fixes (compared to v5.10.173)

## Test result summary
total: 134577, pass: 112556, fail: 3872, skip: 17830, xfail: 319

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 115 total, 114 passed, 1 failed
* arm64: 42 total, 39 passed, 3 failed
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
* kselftest-seccomp
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
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
