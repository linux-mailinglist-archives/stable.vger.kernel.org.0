Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECBD637481
	for <lists+stable@lfdr.de>; Thu, 24 Nov 2022 09:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbiKXIyi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Nov 2022 03:54:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbiKXIya (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Nov 2022 03:54:30 -0500
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 493DB9A261
        for <stable@vger.kernel.org>; Thu, 24 Nov 2022 00:54:29 -0800 (PST)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-3b10392c064so9907157b3.0
        for <stable@vger.kernel.org>; Thu, 24 Nov 2022 00:54:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kYkoA/GomV2J1R+NfO0IwXHjKjxsC0Vb0ETBF00zbXI=;
        b=ulH5JJlEBiyEJOyyzmDJEuovb470lZAyDOB5qNe/r+VBdnVulYNBQnNUSszcmHgA3r
         bkj8uWQEGyLTC9K961wA9Hd37J/TC5kQb7emkDeK9EoFNll5qYS4vk6heKtzV7LtZ5Ig
         yEM+B8eR3YKZQb7tMff3yRiIpfoqPEMZU1M0rBZ1BBG4FpNGBYtOtylj9MBmV5uQb/jY
         9OwNpq12jh2E0hIEl+Pn5X2NNRtgABUL0VAmJBQrPdTXaJaPvRJetpCOVks/qeuMyj4a
         G22/QjplaRtlbys6YMYSk5ljss+0SOoE6UMMY/RSLZfaElD1FEaXtS0xkEtbkRn18RxP
         IGDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kYkoA/GomV2J1R+NfO0IwXHjKjxsC0Vb0ETBF00zbXI=;
        b=DjypjsQjufpBPLl6CjbdSMw0y3ZhTyJX2SxAjq/rubVMMXAupBFMM64jIw8msXyHrW
         F/Qlujjn6/ESmw8qlZSvRNqy2BRXcwMsT+EJ0tNVZ4GJ05pWA18Y/ozrGUMCkQI5lCR8
         3j89SIzOBxCKHZ1t6aEChFHVPM1mvlX6kLqza5houwUj490MyAJ1KyyK0w0OiZJwrhzI
         IZyMXGVb2KkdwbFeTGYZGdv0ykvsM8bbS4I/JxuQCMHJgFlW0yVZ5dC/8WqWSFmr1nCY
         Zh5vHPlvxR/P/TGbwC8ldlL6TDRyuuqq3TxkgkvLn1L4MFa1Ahjd371eSA8JAgRMkZF5
         ZLGQ==
X-Gm-Message-State: ANoB5pmOHLPoLOGkMeC1ise4FS96A3UoI7T2dXhA/UPLOLQFOp/gJj7/
        hTCeW7TMPvUdmf3ICOKcR7hnVbhHsaoJ1hRvbcyRfw==
X-Google-Smtp-Source: AA0mqf7PUjfLOTXJ/tlxRold+GNACKzGQPvC5qgYTBuKsbjof9rmRRzeEIro6Uscs431x2P0gTzIHHNWktmr0hWQxqU=
X-Received: by 2002:a81:5945:0:b0:369:5494:75c0 with SMTP id
 n66-20020a815945000000b00369549475c0mr30631265ywb.448.1669280068349; Thu, 24
 Nov 2022 00:54:28 -0800 (PST)
MIME-Version: 1.0
References: <20221123084602.707860461@linuxfoundation.org>
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 24 Nov 2022 14:24:16 +0530
Message-ID: <CA+G9fYtnHTdCS=RWNULkzENX=mtRrJzc6e++PfeprmFqrQBr9g@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/181] 5.15.80-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 23 Nov 2022 at 14:59, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.80 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.80-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
As other reported arm: allmodconfig build failed due to

rtc: cmos: fix build on non-ACPI platforms
[ Upstream commit db4e955ae333567dea02822624106c0b96a2f84f ]

Build error:
drivers/rtc/rtc-cmos.c:1299:13: error: 'rtc_wake_setup' defined but
not used [-Werror=unused-function]
 1299 | static void rtc_wake_setup(struct device *dev)
      |             ^~~~~~~~~~~~~~
cc1: all warnings being treated as errors

## Build
* kernel: 5.15.80-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 1ac88d934860fc481995accb27454e4fe906d4f6
* git describe: v5.15.79-182-g1ac88d934860
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.79-182-g1ac88d934860

## Test Regressions (compared to v5.15.79)

## Metric Regressions (compared to v5.15.79)

## Test Fixes (compared to v5.15.79)

## Metric Fixes (compared to v5.15.79)

## Test result summary
total: 145866, pass: 126226, fail: 3335, skip: 15985, xfail: 320

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 147 total, 146 passed, 1 failed
* arm64: 45 total, 43 passed, 2 failed
* i386: 35 total, 33 passed, 2 failed
* mips: 27 total, 27 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 30 total, 30 passed, 0 failed
* riscv: 10 total, 10 passed, 0 failed
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
* kselftest-kvm
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
* ltp-fs_perms_simpl
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
* perf
* perf/Zstd-perf.data-compression
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
