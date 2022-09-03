Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75FAF5ABF17
	for <lists+stable@lfdr.de>; Sat,  3 Sep 2022 15:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbiICNRO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Sep 2022 09:17:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbiICNRN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Sep 2022 09:17:13 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0774C5A2D1
        for <stable@vger.kernel.org>; Sat,  3 Sep 2022 06:17:11 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id kk26so8686891ejc.11
        for <stable@vger.kernel.org>; Sat, 03 Sep 2022 06:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=A5m8u+5uqpMKc3evmGG/jgqJU35MvPMmTk1hUbHuCGk=;
        b=qB8jdXQxchn89Bu0ekr/PJuXP7eAYQBkGL7teXX4wPmcDt82q2QxWc6rLrdDh01rxd
         3qRpP1b00RxbxrQiEaAzcLdPywaNx9+6Wlv32MMe0rbm7PswCXjcdSD737rmmxt8p3A8
         bGaQW4VvimINPMv3fzan/GOtN+E2ovNU41YBVHX+iHfUH3uR15IuoZzYfzUdnlOZR5v0
         CNMovQ/ftX013YeduwOgbTpvXxWZL5+JWgD/I0//Ckr9BKYeimHgyRRTQhYdcj+s0SlE
         j2qM3MUrv5JllRBtjuwg+OBuVT6WacdQ7RxXsKncG9Lnzo84ycqf3EjMhLBekrLQV6lK
         l4Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=A5m8u+5uqpMKc3evmGG/jgqJU35MvPMmTk1hUbHuCGk=;
        b=rtbz1LrcZfEVVGzSoqkJugtT38XRDNw5V3aOiqXqEstGqCofIEDmiicPL1zw1FcNHf
         uKClC3+MBPZwYb7ktBTnK4cW95o0pRY0O93G0ZAt/4QNtWQK26o0X7sDcTOLKQb3aIYJ
         wFl2LyngF2sYmwXBGvVNV+CLuCvx7+7CT6VOoss19l7x/QZHVxSyOqKUwfaUZothCQ5H
         OYCvBOon2gjYFj4bBKl+lroqAvI5D/clLyNwxpRih36Sz0yCSSMDrlfLS83C4R6VHjtf
         2XePv/G5pF78VRt65x9+huTBa/Guwy88E6entGD7wxGGF2NUsnLlw/Uz21R9j4Tgus9e
         GYMg==
X-Gm-Message-State: ACgBeo3uvohZpyBX8Qhu/kmNVgct3CLPnYdrbZ8qOeBu9lxZFOZKOgnW
        4JkDztqJIB6/4UxXlCYt3cgFsKWaW7HkByEfll+MKKBN4Yl1EA==
X-Google-Smtp-Source: AA6agR6c9PpLEdImSQnWD6Rg4iCJM+DbfGkZaUPrOb/hrM2d8IMYI7tO12oBCbKkFjb6RvqqcbT4urKiY9EhhksUNwo=
X-Received: by 2002:a17:906:cc15:b0:73d:d87f:f039 with SMTP id
 ml21-20020a170906cc1500b0073dd87ff039mr28291031ejb.253.1662211029422; Sat, 03
 Sep 2022 06:17:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220902121356.732130937@linuxfoundation.org>
In-Reply-To: <20220902121356.732130937@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 3 Sep 2022 18:46:57 +0530
Message-ID: <CA+G9fYtFEgczDg_6c67oYrR97V0KQRAtsM9pOQbuJYzjE3Prig@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/31] 4.9.327-rc1 review
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

On Fri, 2 Sept 2022 at 17:50, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.327 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 04 Sep 2022 12:13:47 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.327-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.9.327-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.9.y
* git commit: 24fc65df6e8a89f1c917a8aef1636e5c17901edb
* git describe: v4.9.326-32-g24fc65df6e8a
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.326-32-g24fc65df6e8a

## No test Regressions (compared to v4.9.326)

## No metric Regressions (compared to v4.9.326)

## No test Fixes (compared to v4.9.326)

## No metric Fixes (compared to v4.9.326)

## Test result summary
total: 78542, pass: 67880, fail: 721, skip: 9575, xfail: 366

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 250 total, 245 passed, 5 failed
* arm64: 50 total, 43 passed, 7 failed
* i386: 26 total, 25 passed, 1 failed
* mips: 30 total, 30 passed, 0 failed
* parisc: 12 total, 0 passed, 12 failed
* powerpc: 36 total, 16 passed, 20 failed
* s390: 12 total, 9 passed, 3 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 45 total, 44 passed, 1 failed

## Test suites summary
* fwts
* igt-gpu-tools
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
* ltp-open-posix-tests
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* packetdrill
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
