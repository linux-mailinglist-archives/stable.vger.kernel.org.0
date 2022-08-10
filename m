Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A87258E8AF
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 10:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbiHJIZs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 04:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231451AbiHJIZW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 04:25:22 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C14EDFFF
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 01:25:21 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id x21so18104059edd.3
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 01:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=nbqAsyz9z6bB6QA6vWSugiDElg43hTOGFFgfozHm3AQ=;
        b=qwjPN5kJN+YqUEgcEd5RNxjvkJufZEP1pmxUrSsk9g0CQb2zCisfSy4qWjPVl6ZxPn
         46SiZDV3JoVt1zHLPxRWFIgr/doPX5EGgwFX4J7/nf2LkVn7ilanCp72hmN7aZbLCXWh
         XJBtM2S0Pf1stUCMZQ+utGYN1yov7EMdiWe32dlMRKuV25zrH6ueFOvz6V98QbOsjPWT
         ETWrbBj0/px4ddZNr1p+SJgym/JahUr+nVRv+eVsjtMiTcQZTaoB6IVDGVZbO2cUb7zo
         yRHJkTX5grd4g1ryDa5M/1u5ywtEcwxBB1xiRyAO1CPyjTeiK6Rm4yS8QOVDG06ZfM/9
         gP7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=nbqAsyz9z6bB6QA6vWSugiDElg43hTOGFFgfozHm3AQ=;
        b=aj8zaVfUTCZMMGOTHwfbXTwwm1nFLorDCvIxkQDfrEbnijgvoGyyPWlxqTU5UGEcGC
         0aZnlmcRhy2/bwSufXJ2tVVmnB2Z4pogW6RLmDZ53EG6apue95GLPYwMhwZAd1dUn7aM
         5pjR2Wm9EdzRznkeJWgt+05G8PnHwxGCUOTjLhMHxxHUhq+Iq3KX2h+2GEiR5ZWqzBW1
         4f/jHmuppWCjlqZwxMfiAEWXlZrqwsweWAgtqhqo5D2Ye5sslgVp+527snZ2L0lJKqRz
         FylJoODQmPHY5VeWaqj24Bvt5F1mVqFjq96/qgbRJPqFuAHjsq8YdaYROqdQ9Q/NY0R0
         xlrw==
X-Gm-Message-State: ACgBeo1lS1T2D16iGrNIK/9FItYmE7UM8AWeXmKAYQkbNTHJfbjJ3KoJ
        yUeLPRKdks0JLxzKKpoRKyoNEm6SlPjF7te7wl5kLQ==
X-Google-Smtp-Source: AA6agR5PFq+2RmZqmuJGsirwLqVekGzCqhnVl5AAzlCaTRPW3O/gngZbz2svEcUJu7W/0M23IurHskzsV1MmdYog28o=
X-Received: by 2002:aa7:da93:0:b0:43d:1d9d:1e5 with SMTP id
 q19-20020aa7da93000000b0043d1d9d01e5mr25868835eds.55.1660119919628; Wed, 10
 Aug 2022 01:25:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220809175512.853274191@linuxfoundation.org>
In-Reply-To: <20220809175512.853274191@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 10 Aug 2022 13:55:08 +0530
Message-ID: <CA+G9fYvLSEb8Or+vM+vSmopny7AAWsudzMTjeka-WdsLYSeEVw@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/23] 5.10.136-rc1 review
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

On Tue, 9 Aug 2022 at 23:34, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.136 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 11 Aug 2022 17:55:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.136-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.136-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: cf6f87a93412e15617900d8213013eb3a6ca08ed
* git describe: v5.10.135-24-gcf6f87a93412
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.135-24-gcf6f87a93412

## No test Regressions (compared to v5.10.133-168-g4fd9cb57a3f5)

## No metric Regressions (compared to v5.10.133-168-g4fd9cb57a3f5)

## No test Fixes (compared to v5.10.133-168-g4fd9cb57a3f5)

## No metric Fixes (compared to v5.10.133-168-g4fd9cb57a3f5)

## Test result summary
total: 112413, pass: 99753, fail: 530, skip: 11427, xfail: 703

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 301 total, 301 passed, 0 failed
* arm64: 62 total, 60 passed, 2 failed
* i386: 52 total, 50 passed, 2 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 51 total, 51 passed, 0 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 55 total, 53 passed, 2 failed

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
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
