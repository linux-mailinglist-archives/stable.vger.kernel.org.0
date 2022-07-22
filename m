Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67CE757E77B
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 21:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233720AbiGVThC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 15:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231784AbiGVThB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 15:37:01 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E28D1ADB0
        for <stable@vger.kernel.org>; Fri, 22 Jul 2022 12:37:00 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id ss3so10142915ejc.11
        for <stable@vger.kernel.org>; Fri, 22 Jul 2022 12:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9W/4o6EfnGEwcuq6LL3x9yV4yD4TMmlvYfYSl/PJ+po=;
        b=OUrpMUo1mPHxCgem1t33sG/aMPFP0rgndCMXXZg/xPhFvx/uJYQRPdDXzmVY8//emD
         EFfcjXa0xHrrokvrGFHKEvOq6PyLMeYi9Px++Q1u9z23a5dZVMwPoOpZ/7nT0ZE+iCEQ
         KPKv8+fgZMzF60dkAZNSKBbh+XkBUlhWoRaGjF/wrx3v6r1ddzWbjgect1rmrc0gA5Ds
         ZgNt9y9cx8r6UXN9udC2y+Mp0sdAsuJBzqU9HReOcPS8lXrssTRK8kfrmMrV9mBRqMfU
         OL+/CTwarPGXQMoFxD8tAHY7seUIh78xZdfwwPrSL3ivyrJMLRXLdotAkRh6/y9f8psg
         +06A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9W/4o6EfnGEwcuq6LL3x9yV4yD4TMmlvYfYSl/PJ+po=;
        b=hfmKRRZGyoszdwutz63mfdYORiJmI6HIhx2lKxJCtuOur63fSvcUGHafHrIax9hYS5
         GwPGyy9v/eOMDmeaN9Nn7MOhRFelywO7cZlfvqhNmB36oaiNXdseEm49UHniIvlQHhOm
         8wG41in4XDpoJTElJ/skMT3c5/Wiuq1LxoGtsXz17pGOvFUW5iatEOjuaAMtPpZg1mvQ
         kNIVjMIsX2A2vu/cFAxQdsGBKKXk+Duj6UfteXwV2qXLJs7mI8tUka2VNP1v22lWc7kx
         pkV/+k9kXnJKOhTT0HjhMolnfBVPMBR0f1plKgcGv92PzqVXANvgY+wlll454C8XmKHh
         gq8A==
X-Gm-Message-State: AJIora+9eydjfm7boZv0CttOzUAKTYNqHPVxh1A1uuJBaMM9NWwJqgfw
        +ZQXNNIH1aDjwRzMFVfHQH/BiewG8XRHjAMdbT4qu4bshQHrMA==
X-Google-Smtp-Source: AGRyM1toX1qxA/Y2sQze7fN7WWkk6TqYES76pKd7tls/ES17kIur8GJebyxRwlYo4tOwxeEXQE4zm+qv2gj0Pc0sytg=
X-Received: by 2002:a17:907:7fa7:b0:72e:f88c:db16 with SMTP id
 qk39-20020a1709077fa700b0072ef88cdb16mr1077472ejc.366.1658518618331; Fri, 22
 Jul 2022 12:36:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220722091133.320803732@linuxfoundation.org>
In-Reply-To: <20220722091133.320803732@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 23 Jul 2022 01:06:47 +0530
Message-ID: <CA+G9fYuu1QroLm-9a7vXmq77pS03q=fBCfjhfURbAZVNA=a2rg@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/89] 5.15.57-rc1 review
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
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 22 Jul 2022 at 14:43, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.57 release.
> There are 89 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 24 Jul 2022 09:10:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.57-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.57-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 377c0f983cd943f563003e5be4947692afba815c
* git describe: v5.15.56-90-g377c0f983cd9
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.56-90-g377c0f983cd9

## Test Regressions (compared to v5.15.55)
No test regressions found.

## Metric Regressions (compared to v5.15.55)
No metric regressions found.

## Test Fixes (compared to v5.15.55)
No test fixes found.

## Metric Fixes (compared to v5.15.55)
No metric fixes found.

## Test result summary
total: 140090, pass: 126270, fail: 474, skip: 12514, xfail: 832

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 308 total, 308 passed, 0 failed
* arm64: 62 total, 60 passed, 2 failed
* i386: 52 total, 50 passed, 2 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 54 total, 54 passed, 0 failed
* riscv: 22 total, 22 passed, 0 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 56 total, 54 passed, 2 failed

## Test suites summary
* fwts
* igt-gpu-tools
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
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
