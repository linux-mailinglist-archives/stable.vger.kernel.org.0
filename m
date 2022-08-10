Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8BA158E830
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 09:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbiHJHwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 03:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbiHJHwK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 03:52:10 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8863273935
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 00:52:09 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id kb8so26253526ejc.4
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 00:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=XVSnkMwhvdCAXSk0pnxudE8JlTnO8bAUtjVsNUeiSVM=;
        b=lqD2J2w7ql2U9DSaPmtI+q9+2IieXSsyZaE8hMpCS5L4qtH8XNJTKmFFz3vNrEg2F2
         iT1mye2RdOc/OnBXu7c4j31KTg/uZ1cMZIJq0eIpznKw0/mO1R0GqZX3BISoMxZganGm
         R10hJdwagRVs+GoryDoLebVTwSJbRnFECucYX4wFM7nFjT35y+4aUktEkW/UqfCJJsYO
         Ii/diHJ35elEpai0Z9godoYitWjZpEP4wCSbto026aXcbvfEhEETOdlCEHgv1ElOpmRu
         3siFlfsh+H3je262C3Kmcz2ktGK2FaR2qgLfMy7wP8649coZ5pPqjwoNTxGdxWaXq0HF
         /e0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=XVSnkMwhvdCAXSk0pnxudE8JlTnO8bAUtjVsNUeiSVM=;
        b=QRytqtAtNx0K8y0iTPEMuHcZC1Lu/Mk5pI5xfEsCYPwJ4tdtKTGFrTDyaV4oQ50Bp0
         mCXol10uIzunjor0WNzotcEo7zzXnkqTRB1h66Q4MAfwM4chyfdQfjo9QCTSRlTe1m41
         Sj2JIbQ9l6+Fd/HWpy3I9Mq+20Kcl54+X+U9aERilKLIeCLQRDW2AfDVeXN586tEu/N9
         RrHn2wQKFdKFn3DQoWdwvu/kdSZ0A3RkmKqnsU9b0TwfRE78gGSL1nvGKsegfd9NoMBo
         I54Mp3/fZ6LPRm2YmTUtcSygwWYTd+4ckV51euPfgeAL9moGhIxjQPXYc3jFjfS8nh+I
         +r2g==
X-Gm-Message-State: ACgBeo2YMuGeqMY92RkTqgAOVurfn7If5caEwRB6vzPGb9zmC4iVAGvd
        Q8aw9XMBv8hl8zdIndycJ9dhIFQgil4Q1EgRWohb4A==
X-Google-Smtp-Source: AA6agR5lF83OUgtGOqZ4wYoHWdo8ZvYE0AxJjNzeXk/fXVsk0StAuquZINiLHEedp6/mxH1jhW4/3Kr//SzVhN1E5ho=
X-Received: by 2002:a17:907:86ac:b0:731:5180:8aa0 with SMTP id
 qa44-20020a17090786ac00b0073151808aa0mr10285234ejc.366.1660117927843; Wed, 10
 Aug 2022 00:52:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220809175513.345597655@linuxfoundation.org>
In-Reply-To: <20220809175513.345597655@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 10 Aug 2022 13:21:56 +0530
Message-ID: <CA+G9fYsE4qzpAjayZdLQe5Jnh90zfXQpgQof1dKu9QGbTpU_ZQ@mail.gmail.com>
Subject: Re: [PATCH 5.19 00/21] 5.19.1-rc1 review
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

On Tue, 9 Aug 2022 at 23:38, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.19.1 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 11 Aug 2022 17:55:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.1-rc1.gz
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

## Build
* kernel: 5.19.1-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.19.y
* git commit: 8054ca35012635b5d3f63311bd312e7149d80b38
* git describe: v5.19-22-g8054ca350126
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.19.y/build/v5.19-22-g8054ca350126/

## No test regressions (compared to v5.19.0)

## No metric regressions (compared to v5.19.0)

## No test fixes (compared to v5.19.0)

## No metric fixes (compared to v5.19.0)

## Test result summary
total: 134782, pass: 120620, fail: 1758, skip: 12404, xfail: 0

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 301 total, 301 passed, 0 failed
* arm64: 62 total, 60 passed, 2 failed
* i386: 52 total, 50 passed, 2 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 60 total, 54 passed, 6 failed
* riscv: 27 total, 22 passed, 5 failed
* s390: 18 total, 18 passed, 0 failed
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
