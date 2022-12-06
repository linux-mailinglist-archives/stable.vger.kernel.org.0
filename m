Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF0A564414A
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 11:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234173AbiLFKbg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 05:31:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233993AbiLFKbb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 05:31:31 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FCD0193FD
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 02:31:30 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id cg5so13369773qtb.12
        for <stable@vger.kernel.org>; Tue, 06 Dec 2022 02:31:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K5U7G8Lu2Ggn0XL2IuT7TVHn/1PFLVfrrCtYcS/Vxxg=;
        b=B/jbe1V6IZFy+n6KSHw9cFejqlXUrDiXPm97QsiSYZpXEM8WYlSPlZ0tNRgWzmY8Ty
         PxilBNovn2cwAEW0Qi5dASyBvIZbskSRuZJgk24eJXj+zux4RDPYGtvATItq0I1SGy9o
         B1ZLlNQ6xZaAh+n5Xx8rtlO/w2YTDoSzNKd5i6AKGLFDSrmOLMX9QC4yigWKt5gpeA7G
         4tWYpIga3DVp/yVfsw6XkOUIbZmrtLBgRLhNwBaWfRvaJv2Qszxch4AY/HLvjxXzOT12
         NYfOtQWPW/0jaNuu6+/hxfT1LOIc5d2q3ds269GPM/tsWL6O9Voroz7jGFs84QpAueMC
         BPkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K5U7G8Lu2Ggn0XL2IuT7TVHn/1PFLVfrrCtYcS/Vxxg=;
        b=CCygFPjguwhQ6siTFkNe0TwkZOiFVar7U3olfGRphLgfosI+b3jUCIMpvCpGse4Kqx
         gyJGRtHCuU5xVJPuEPuDehbx1Robd6OvP+9vf1kN+JYC80SggCo9HTMQQk8w3nyMWKt3
         BCAaE5kraTSgEosVoss45N+Df5Cjhpb8fyyuAtnM0nqkxgaCL0r4IJqNHbd/LBwSZJHr
         87ZRSXt0fCIVJXkZ3vbMFSUcM0Xu9vQkNbhpJwbqxtZGyY3uIHJVYE+LC0N7KnQaMtTz
         Gaxwt0aD+noJ4XVENZR5hbspSpPAv0FKWqnAquS/C7BEZ/L7AWdbdHIAbIJFIfLRPeyl
         FA1w==
X-Gm-Message-State: ANoB5pmRLdjYDuqAlbwEPQHI957mLHg9aN80UVuH+SGtVt1GRC4vvP3O
        Wwe9XCQ5T/ryRVSOx9pEvXhFNq9OBlZ4k5Sfd0dszQ==
X-Google-Smtp-Source: AA0mqf6WNrNi1e3dghxVEkL8WAQNZJJoRcfwITynys5vNGpZfxNhrYD9IGJxY3M6rHPSsCmhcyhL72n9kkExSu8BeaE=
X-Received: by 2002:ac8:4649:0:b0:3a5:8ea9:34f5 with SMTP id
 f9-20020ac84649000000b003a58ea934f5mr79976918qto.420.1670322689032; Tue, 06
 Dec 2022 02:31:29 -0800 (PST)
MIME-Version: 1.0
References: <20221205190806.528972574@linuxfoundation.org>
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 6 Dec 2022 16:01:17 +0530
Message-ID: <CA+G9fYt-EU-J23nss2hB=6YTq6gpshBMsG878uo7KfuS-nppTg@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/120] 5.15.82-rc1 review
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

On Tue, 6 Dec 2022 at 01:03, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.82 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 07 Dec 2022 19:07:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.82-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
RISC V build regression reported.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
RISC V defconfig build regression,

Build error:
make --silent --keep-going --jobs=3D8
O=3D/home/tuxbuild/.cache/tuxmake/builds/1/build LLVM=3D1 LLVM_IAS=3D1
ARCH=3Driscv CROSS_COMPILE=3Driscv64-linux-gnu- 'HOSTCC=3Dsccache clang'
'CC=3Dsccache clang'
arch/riscv/kernel/smp.c:195:23: error: use of undeclared identifier 'cpu'
                        ipi_cpu_crash_stop(cpu, get_irq_regs());
                                           ^
arch/riscv/kernel/smp.c:217:15: error: use of undeclared identifier 'old_re=
gs'
        set_irq_regs(old_regs);
                     ^
2 errors generated.
make[3]: *** [scripts/Makefile.build:289: arch/riscv/kernel/smp.o] Error 1

ref:
https://lore.kernel.org/stable/CAEUSe7_2g6fde2JU7_yA9QCK+FfdLshCRnDd81FF3=
=3DSJwwDAzg@mail.gmail.com/

## Build
* kernel: 5.15.82-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 0ba3dda3cd904c39dff762076fae4a21634b8db6
* git describe: v5.15.81-121-g0ba3dda3cd90
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.81-121-g0ba3dda3cd90

## Test Regressions (compared to v5.15.81)

* riscv, build
  - clang-15-defconfig
  - clang-nightly-defconfig
  - gcc-11-defconfig
  - gcc-8-defconfig

## Metric Regressions (compared to v5.15.81)

## Test Fixes (compared to v5.15.81)

## Metric Fixes (compared to v5.15.81)

## Test result summary
total: 119887, pass: 104751, fail: 2682, skip: 12101, xfail: 353

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 147 total, 146 passed, 1 failed
* arm64: 45 total, 43 passed, 2 failed
* i386: 35 total, 33 passed, 2 failed
* mips: 27 total, 27 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 30 total, 30 passed, 0 failed
* riscv: 10 total, 6 passed, 4 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 38 total, 36 passed, 2 failed

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
* kselftest-drivers-dma-buf
* kselftest-efivarfs
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-lib
* kselftest-net
* kselftest-net-forwarding
* kselftest-net-mptcp
* kselftest-netfilter
* kselftest-openat2
* kselftest-seccomp
* kselftest-timens
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
