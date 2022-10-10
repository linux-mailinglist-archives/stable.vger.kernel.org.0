Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 552A95FA184
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 18:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbiJJQCL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 12:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiJJQCK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 12:02:10 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D5E6D9E6
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 09:02:09 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id bj12so25740976ejb.13
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 09:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Nwq4bMhUMj88l332uILPVv/eaSX1xTBS7cLpnqsyXvQ=;
        b=xSPe7cYNg+MpTivVRwY6eRBn/8r3s+sulx3x4zNf6jErlq3gMQUIXAGAfjtdYJBNPb
         THGXlsKqrvDrrsgMXBo36/ngZwyQ2eCifi2S6GgkAqw8j8AurmrSRpo3jUu/j8HyRW7j
         fY7qoF9PxYDYHrzPqg7XrKJbeqf6POxyPlflRoKS5FTQnynir00M+5fxngI4TDk2o1dE
         dAG/X2+zfedDTeT+veHDiMPaqQ4G1r2xAW84m6RVL/lJmd4nSr/qijy/s3XZoCUS1yi5
         mFOB52AYjQQscyA+xUInf1HD+x3iLxNl09kC/X6m/QthoTqsPFi5Sx9IQZt9XMV5USGk
         yWeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Nwq4bMhUMj88l332uILPVv/eaSX1xTBS7cLpnqsyXvQ=;
        b=NCh6+eLaIzs4yyyeDLQPzEZhyztGtwTfgNrYfytxWTwSCTm2CSdP5+Gu1bz5IN9b6q
         VIv7mJXeuLCw+3qgYxUFl9+Rpd0mjOpj8Jt0sBcPXWHNNA+LCVPbpzTfzpS6yhr/81rN
         k7a5XwadXtFbawxcjLzRtWHddWFSXa1RsSDCVVNGGmdwVBZDPMmZnwdnUanMFe+B7d0O
         HeRMxdp2THpxyX5dxOe78QEhclv36GMh3HI/a82cr1lCrScG75mDUBie3guYQfL1GuWf
         38z1jkd2S2eF1sM8ryJQ2Vwkkt8XXmXD7n0MCZcW3k/elRyjtP1roC4ctl4hIES5qib0
         P9bw==
X-Gm-Message-State: ACrzQf15xLv5gku0jT06MPG9WZAeATJrnxDnADx7pUqIY21XIScuPGfN
        7Ws17eO9Si+yAL9x6CCHtJPWcET8oNyMX+tTMLDZ7d4SeJy/uA==
X-Google-Smtp-Source: AMsMyM6UjqlmiGIqHRFrDacODsmCwKujwrsZhqJHxSFg09qxg4AhOfSzBLdpmJ57AvjVGnWGz9+4flmBBDcH+iziw8A=
X-Received: by 2002:a17:907:3188:b0:741:4bf7:ec1a with SMTP id
 xe8-20020a170907318800b007414bf7ec1amr15730725ejb.448.1665417727159; Mon, 10
 Oct 2022 09:02:07 -0700 (PDT)
MIME-Version: 1.0
References: <20221010070333.676316214@linuxfoundation.org>
In-Reply-To: <20221010070333.676316214@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 10 Oct 2022 21:31:55 +0530
Message-ID: <CA+G9fYvQHA-dfeFNQ8xcqSi46mdzPQeXbyXPR62m_BgS90aj9g@mail.gmail.com>
Subject: Re: [PATCH 5.19 00/48] 5.19.15-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 10 Oct 2022 at 12:36, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.19.15 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 12 Oct 2022 07:03:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.15-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
1) Build warning which were reported on last round of stable rc review

Following build warning found on few arm configs which do not set Kconfig
# CONFIG_ELF_CORE is not set

- powerpc: tqm8xx_defconfig
- arm: keystone_defconfig and omap1_defconfig
- mips: ar7_defconfig
fs/coredump.c:835:12: warning: 'dump_emit_page' defined but not used
[-Wunused-function]
  835 | static int dump_emit_page(struct coredump_params *cprm, struct
page *page)
      |            ^~~~~~~~~~~~~~

## Build
* kernel: 5.19.15-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.19.y
* git commit: 2e79dbde2710b3939943c5d2ea3028329b820e9f
* git describe: v5.19.14-49-g2e79dbde2710
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.19.y/build/v5.19.14-49-g2e79dbde2710

## Test Regressions (compared to v5.19.12-110-g30c780ac0f9f)

## Metric Regressions (compared to v5.19.12-110-g30c780ac0f9f)

## Test Fixes (compared to v5.19.12-110-g30c780ac0f9f)

## Metric Fixes (compared to v5.19.12-110-g30c780ac0f9f)

## Test result summary
total: 112321, pass: 100742, fail: 732, skip: 10568, xfail: 279

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 339 total, 336 passed, 3 failed
* arm64: 72 total, 70 passed, 2 failed
* i386: 61 total, 55 passed, 6 failed
* mips: 62 total, 59 passed, 3 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 75 total, 66 passed, 9 failed
* riscv: 32 total, 27 passed, 5 failed
* s390: 26 total, 24 passed, 2 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x86_64: 65 total, 63 passed, 2 failed

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
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
