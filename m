Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11EB458E955
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 11:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231980AbiHJJMe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 05:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231978AbiHJJMc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 05:12:32 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D8E86C28
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 02:12:30 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id z2so18278273edc.1
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 02:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=z5pNp3gRQvVGwmJ05VLiZxLH4XIgr85IvV8mJcL1QgY=;
        b=sZFAANe8L9zIk80k8inK7awd8NGAgKqrCZtHegsT391lMMZ9WWE81x2EKGWnk3TbY8
         G4KhPjpU0E2d8xuf5AgOkqmTpZSacHuAzky2qmmbC3NqwxuTvoXb6XqinrytfPQOEhRG
         eBpDLZsH+6eOcbq9KTjcYs/wDZNfU7FRgAERpbGtTOlrE50u/pglmUwucIt7cfAU/JKo
         4i4R7KD1GMOzhgZfg7YTKw/uaONLuSZCNb0fqR72RhgnxkEtY/5oNuVIAdA2eEiaNN7I
         CfaRR07Xh3Nqhg2z46PXB2/bqpWfncXdQmDUxrPGv0Pf0jRDTaEziGN/Y5U85nfbq/pw
         xooA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=z5pNp3gRQvVGwmJ05VLiZxLH4XIgr85IvV8mJcL1QgY=;
        b=IV9SmspG8zcjVsn02PpFr5JYZqgIy8ETQ1iZLT+f2AvyVRdk0JOhQCkgQopx9mTJZh
         UfUanYXrDCccVA5TfdeYoH2GBb+ZOclJYRAkxsvfhQ9IN0L7si1Y60iUXv/gSaVMzjSs
         n6lZZQn1FgblHjfuYJ078DBE0shM9UnTX3NxSYECMXncV3LS5fCtlIP5Hdm3Kkw8B6NE
         MXkzGLacXkpIeYzaH6l4cPCkWnN3+gUZpDR17WotQpitn8+mEJ3O6Oprh7hnutKzU/Kf
         by79kskSvpm4BwwjVep5vkZHeM45AWzj306WqR7SRJtWOtMZSw/VG7w7GDBrH9L9EMx9
         2j5g==
X-Gm-Message-State: ACgBeo0SjDZs3BScKF4cLWYkK21eNGDSvaxTUxJcY4Aq0Q+d/0ahgOil
        bdvQgZiGRPKZlz5Jr8AOonHHu3/++48eqzJBgirnkQ==
X-Google-Smtp-Source: AA6agR4aUb5x82C6o4gs+Pwtx0SzXu4JYSeBbIZgTd0G10sFnrg7Djkfx1EPnpxj2/DRvrHj2+1iYPO4k7B2yOI6TxA=
X-Received: by 2002:a05:6402:2387:b0:43d:3e0:4daf with SMTP id
 j7-20020a056402238700b0043d03e04dafmr25868474eda.208.1660122748984; Wed, 10
 Aug 2022 02:12:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220809175510.312431319@linuxfoundation.org>
In-Reply-To: <20220809175510.312431319@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 10 Aug 2022 14:42:17 +0530
Message-ID: <CA+G9fYvYuXjfTD8J9fSz=NAxL3=Ksb23Jr=4Z+Ebq=3+tjQ73g@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/15] 5.4.210-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 9 Aug 2022 at 23:33, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.210 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 11 Aug 2022 17:55:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.210-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.210-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: 0bf8828e9254e4c8917e2556001411f431ba0a70
* git describe: v5.4.209-16-g0bf8828e9254
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.209-16-g0bf8828e9254

## No test Regressions (compared to v5.4.207-123-gb48a8f43dce6)

## No metric Regressions (compared to v5.4.207-123-gb48a8f43dce6)

## No test Fixes (compared to v5.4.207-123-gb48a8f43dce6)

## No metric Fixes (compared to v5.4.207-123-gb48a8f43dce6)

## Test result summary
total: 97031, pass: 85084, fail: 452, skip: 10716, xfail: 779

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 302 total, 302 passed, 0 failed
* arm64: 61 total, 57 passed, 4 failed
* i386: 28 total, 26 passed, 2 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 54 total, 54 passed, 0 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 54 total, 52 passed, 2 failed

## Test suites summary
* fwts
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
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
