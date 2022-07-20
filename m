Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC40F57B3A6
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 11:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbiGTJUQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 05:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiGTJUP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 05:20:15 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0168658F
        for <stable@vger.kernel.org>; Wed, 20 Jul 2022 02:20:12 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id k30so22947131edk.8
        for <stable@vger.kernel.org>; Wed, 20 Jul 2022 02:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=O2r9z+0U5AsjCxNa2HdHqFngARMmBB8Z9POgFg+P13I=;
        b=f0UOaGtGTCkFlY/00QapnpK8E7KfxUNb8JEWYsiqJn5COOj44+DiftxxaLUtzwoIcP
         WFtA5Scp9Yu9gD36UID3q2l/k4jsn2GxwvwzQ/yrCLNsyGFqbjWrFeqn5BdRTP+TD/u1
         d2UuQfXsiWXwDY060ny+aI/baI2ZXw5M245BylBQQ0TyhOGGRXEJZBNNG5Zm/FLxIGfq
         7sgESxU8Z6tFO90H4asylV4rqjDyb6inxocGXubGs6GKN2EoyDj4UweYI4nAwQrRsp4v
         8TOb9Yh+JXlV6JbBqXVJOe2qvihenas/Dw43GNVt/8McdH8fsUB4JkpLCQHEMIcyxNt3
         WDPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=O2r9z+0U5AsjCxNa2HdHqFngARMmBB8Z9POgFg+P13I=;
        b=Omqjd6XJlONE3sDnoen19rwdF/1oHJQiAMmgt6FcbzrgZBlZx1M1d+HI0iAgRWuQkp
         nNWyggKz4ulPPXPsFSfCy9Gd3DPLbZpzSsJRGF3oX+/gqeF7Ca9ArBx5brLuL4Luw8HD
         pYRlI0Nngxqu26mVmbvAUZtHW1KqkwFVKsWalwKfMkZ5L8Ihp4C4LoEpqmlV7ZT/iWxV
         iAuYkxAEfsPJoXJTB15xKoa2KwZvCHJf4MWLmEdneyEQx/2h2BhUwQU0FMPBxqlWBR5z
         sVXb4SRohZ5YBuh7hCNjyNOA8QST0oW2eluuMFRqJ/UxzYwv5Kg6LSLhzmXh2+GnPyQg
         G/7A==
X-Gm-Message-State: AJIora9M9JeOVuK1PM7Zc+9qLIumOLFbWRH4a/T2LhIdc5qpIJ6px8bc
        sh2RpzfXvRLjgjPO6XZiX1r6Q/g9gCPCsYF73JcrOA==
X-Google-Smtp-Source: AGRyM1uQ+Yzb+l1WvKL8FeRQbaeWtLAC03zjwV6uEYGBdb/fRWwzFsS/c5OxywP1OFCE1GYGRthalDiUnl40djHAkBk=
X-Received: by 2002:aa7:d5d7:0:b0:43a:6eda:464a with SMTP id
 d23-20020aa7d5d7000000b0043a6eda464amr49724122eds.193.1658308811167; Wed, 20
 Jul 2022 02:20:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220719114656.750574879@linuxfoundation.org>
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 20 Jul 2022 14:49:59 +0530
Message-ID: <CA+G9fYt0YHSETSiPCFpsjR5U_z+UH+KZXAviXSdu2Ns8C=J0+A@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/167] 5.15.56-rc1 review
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

On Tue, 19 Jul 2022 at 17:41, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.56 release.
> There are 167 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 21 Jul 2022 11:43:40 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.56-rc1.gz
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
* kernel: 5.15.56-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 91c6070d5cedab812864b5440077d94efc003953
* git describe: v5.15.55-168-g91c6070d5ced
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.55-168-g91c6070d5ced

## Test Regressions (compared to v5.15.55)
No test regressions found.

## Metric Regressions (compared to v5.15.55)
No metric regressions found.

## Test Fixes (compared to v5.15.55)
No test fixes found.

## Metric Fixes (compared to v5.15.55)
No metric fixes found.

## Test result summary
total: 139212, pass: 125349, fail: 352, skip: 12676, xfail: 835

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
