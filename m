Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA2B59F3E2
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 09:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232474AbiHXHCs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 03:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbiHXHCs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 03:02:48 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE99891085
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 00:02:46 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id gb36so31674089ejc.10
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 00:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=oWq9c0HUGary6VDyT4IqyiRTNFMx4EDo8kr85IlkjXs=;
        b=acal2sP2PA1dESB5cw7h1DToG62KXwbUB9I+/CqgedOqZQ7G2mYfo/+c45DGas+3J0
         8nrXfNRTcyuFyfQjW7AZLQmzZslJIC6JUdAlasSsgpZc+jwOAWrHFsS+97OvTfxqCdgI
         fVfu4DPghmhXfSb4onK6ETNEfC2o4h6p5yt0RT01xDLWaisBFHJeJC7lVbNMlPOIi/JU
         +zCouDq614pEZ20U4O51xjvO/+wBDWTMUDSq/ErCO8faAuQtgiMULTfo1CDLhmifpkbO
         pB6lyzCJH3mZTcAQlvJge7lMqiEtWIcUQVJ+/QQ3XZxn4uYRQFjwZekqE/U8v3M+BZMA
         MY8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=oWq9c0HUGary6VDyT4IqyiRTNFMx4EDo8kr85IlkjXs=;
        b=N+OYWRHtvREtocBpSCKl8Qpe21Xm+CXA0Yxw3GzIto8OBiPz0QQlQ9c2vu5ED/XcJB
         vKN8rv0xrXYCTh6t69sYKvhPaPmYOgMjRmOptAQtC4vNf+uJYeMegX9xgmRhUhzCdGwj
         /xz1J+BwBY1FMQLb4ptu12hFRtxQbum+7U1Gg79LYGS3V/TduFetfysEUuUDnydmv6CW
         VD2fG6QpZQIjMmcTQMgfD6JkIkr6gEFgQf5UYttu+FBTmxlgqfsEW3HraOY6FTGMrW3S
         Zi+s4aWYXinsLZj19xrBqhGJSsLbdKaatbQGzqoQDzQM8IKhsG0dQjnddf/c5K4CMh2G
         S+Pw==
X-Gm-Message-State: ACgBeo2EfzYAF65CprkP4rKTK9l8w6R46I5e3EIelYkYT1Y9t/OPLK2V
        9iwGmE4XQwIya8XAHN+QPk8FU2IigsBsBFOz0jG+6A==
X-Google-Smtp-Source: AA6agR4zuuJLAasqxhy7mo/NBc5Zwx/qEuwwVx4URK+ln/Atot40LHxahrVbahVa2hJJDyWN7hOyDbrV0NJtB8uPt/8=
X-Received: by 2002:a17:906:fe46:b0:73d:939a:ec99 with SMTP id
 wz6-20020a170906fe4600b0073d939aec99mr2026495ejb.169.1661324565291; Wed, 24
 Aug 2022 00:02:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220823080115.331990024@linuxfoundation.org>
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 24 Aug 2022 12:32:33 +0530
Message-ID: <CA+G9fYsqqMkKas4nGRF5Tx2C86vmnTXoG9aphH0dtbgrzNgDLw@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/389] 5.4.211-rc1 review
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 23 Aug 2022 at 14:45, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.211 release.
> There are 389 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 25 Aug 2022 08:00:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.211-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.211-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: 1cece69eaa889a27cf3e9f2051fcc57eda957271
* git describe: v5.4.210-390-g1cece69eaa88
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.210-390-g1cece69eaa88

## No test Regressions (compared to v5.4.210)

## No metric Regressions (compared to v5.4.210)

## No test Fixes (compared to v5.4.210)

## No metric Fixes (compared to v5.4.210)

## Test result summary
total: 64174, pass: 57363, fail: 716, skip: 6017, xfail: 78

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 302 total, 302 passed, 0 failed
* arm64: 61 total, 57 passed, 4 failed
* i386: 28 total, 26 passed, 2 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 54 total, 54 passed, 0 failed
* riscv: 27 total, 26 passed, 1 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 54 total, 52 passed, 2 failed

## Test suites summary
* kunit
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
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
