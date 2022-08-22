Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A37659BDAF
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 12:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbiHVKjm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 06:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbiHVKjl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 06:39:41 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 882C22E699
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 03:39:39 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id gt3so7840742ejb.12
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 03:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=B8pLnsqFOp817XRYb/vm02deQ/vqjCuD0oAUsC/zdZk=;
        b=Y8+1EQQEZF8mV38epQby0B2TirDJWZ2imPKnOUObslc06UkKZ7SFnpVSZq3aRE0kuL
         X5mwD4equcMF8hQeA6nAAxCKhAWxRVBdi1BeK//4BMZqQhycgOJaE1++g+SGXwUNgxgC
         MPzPSSTeayQUDqAbv8m5r0bXGqGgPUFiN+0EVi4tGfXK5lbLkxG5bRlmE5HwzM1oamg3
         /bDjyXFoAn5Cbd8QZgTfn70QlBflbcVOsvIjZcbElyLgi/IrVxqGI3Gjm9uqS8jL1e7N
         KAIprkPsHvZewRmvhcJXaXhqGyazD8FKglgA0P9omq4b1NLteRICmnrsd223Zuzcev24
         zgkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=B8pLnsqFOp817XRYb/vm02deQ/vqjCuD0oAUsC/zdZk=;
        b=RkR9rfntXNeQfIhpejM2bFyJzxpijgbGkysJaFZQPpXdK9aUIJiCSAzPkFnbPRyUgH
         oEDV8hSly5sf58hwvKDxr6N/d8lnFHNI6tQnHtbH6t8Q72Qvi9KUyAIDimxUL+mqlDf4
         UaC7J/tDoemESs0CriHTuWN7NqjSy1NWBQsRpfo/jfSa4ivpspYUcSCuqajs0Q9EWxBK
         Gq3buQn1T1aAQ3ktu2lWmsY5u4kB0SJfZvJ61m1Omt3tkiMLaMnTrd8rcHgy/AjI8cuh
         KPznNufyu4cO++7+1mW0skwnonD822aimHK7AsHJfve5o1VQxIzzSNuOoNL3EySr6RfB
         f1tg==
X-Gm-Message-State: ACgBeo17oiVpnsll+qNW8vUDNp9WST1M8XvOAr0AD7Gu6cLE5BhfEYUD
        pRIJ2vwpvfPBPDE+mSVGo7aUxEagk1xJn9TsXMrs0g==
X-Google-Smtp-Source: AA6agR7UYsWI6RAl+mETEou8egftd5+12GtoWKr75gZFL0maYHt/Um7l6zoh+RBXUNNu023PyfZCYBwyD/8S1s3rl8A=
X-Received: by 2002:a17:907:7389:b0:73d:81b9:ed2 with SMTP id
 er9-20020a170907738900b0073d81b90ed2mr2833345ejc.448.1661164777962; Mon, 22
 Aug 2022 03:39:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220820182952.751374248@linuxfoundation.org>
In-Reply-To: <20220820182952.751374248@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 22 Aug 2022 16:09:26 +0530
Message-ID: <CA+G9fYu8GMuQrAYTf05Le=mhZWAWpnFP1xTBCPk9TrGcDO=kBQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/541] 5.10.137-rc2 review
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 21 Aug 2022 at 12:31, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.137 release.
> There are 541 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 22 Aug 2022 18:28:24 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.137-rc2.gz
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
* kernel: 5.10.137-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 879ffc7efcbe48e91264fd3bd3ec52cbcf69114c
* git describe: v5.10.136-542-g879ffc7efcbe
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.136-542-g879ffc7efcbe

## No test Regressions (compared to v5.10.136)

## No metric Regressions (compared to v5.10.136)

## No test Fixes (compared to v5.10.136)

## No metric Fixes (compared to v5.10.136)


## Test result summary
total: 123695, pass: 109086, fail: 570, skip: 13312, xfail: 727

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
