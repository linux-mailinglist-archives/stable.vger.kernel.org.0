Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 495FD59F393
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 08:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234976AbiHXGYN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 02:24:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234984AbiHXGYM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 02:24:12 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 093A27D1F1
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 23:24:11 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id bj12so14526172ejb.13
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 23:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=xKUXcbAPBOq11H+4QEHn3yYp1D7gUFKGviI1AJuCBnA=;
        b=V6/Kg/74LzGP/QlTxxYXT6Yq4usDmUaqQssbNz872AmDRFKpvl/MNWPUTy03ovttw6
         g/wx13eAePIy3OzlnAqCyksvh/ER6CCUHhs0o6cwIyN47EmEunYuCssocm6v67LuzGzT
         HlgXPUHLOGqr9uU5EBIXjp4NHc/tCwpjwQcx9VAVaUBaWKh3qh6rEkFzfTANlP3AYMWh
         RGMTfdk0cyV7++i/CitmcxCpqwQD0WXUC1nXSpQUyl/LZibCCO4ghT3kT8po67yxwfgw
         6KEoJxqFLfcXGwqHDp34GnBn7okZSRGh6cc5gtq6VaZimyZFxogc0y4rdpkCHxP1ghVo
         P+Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=xKUXcbAPBOq11H+4QEHn3yYp1D7gUFKGviI1AJuCBnA=;
        b=BghSlcDO1B0RaF6e5WsFgD+/byNyVWp9I6Y4PrJ190+zy/3djQdcRhCEfRT+yaHmSd
         9QPmDUPDlD20OHCstBaa41OiBGBcgiW5qMGxgrrhzvyBk2VFRFOoFOCIL87+cdhAfSCO
         AlHaRJiV3TPpPKPaKsM2oJiBX9t2V0Uakm6ByiGVxo7V0rRS7R10ZnzAWkUyuC7Tfh04
         H0YIq0RN1bcnBfm65XW1ZdJMn/VJAhnppZDOT14kkDUSdlrdjOltW4aAaK6R7MLe+aOi
         Jnb1zi7eBLcRea3eQ9t5BEfyW5fwm+Xzh2oUYh9IE7tSPjtfn9OmWv5iJ1iLCvbMSkwv
         SO0w==
X-Gm-Message-State: ACgBeo22a4cb8tMffq+PvipnGs8qcC3G/q3R6quL1c4NuzHouEHTG7iP
        TdStjxk/GS5qMru+Zpkqtci/gcPgPCufdAlA1ppjzw==
X-Google-Smtp-Source: AA6agR4+ZMU9vx3INscM1LxzzEs5XsNmUEJwRDvLpufPS5vvdkpP5Fun0Zi1rveW8LYxokqLLXX4SbjxyCqm83kkvGU=
X-Received: by 2002:a17:907:7f9f:b0:73d:6e87:17ce with SMTP id
 qk31-20020a1709077f9f00b0073d6e8717cemr1896854ejc.366.1661322249442; Tue, 23
 Aug 2022 23:24:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220823080053.202747790@linuxfoundation.org>
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 24 Aug 2022 11:53:57 +0530
Message-ID: <CA+G9fYvjKT4QW_dj6xUcZm6J1ZcvTSA4ac_ovLZCThWCRGM0kw@mail.gmail.com>
Subject: Re: [PATCH 4.14 000/229] 4.14.291-rc1 review
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

On Tue, 23 Aug 2022 at 14:05, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.291 release.
> There are 229 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 25 Aug 2022 08:00:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.291-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.291-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 4d54ef55c38e2d37b9c16b20b9d1b3febf73a2e2
* git describe: v4.14.290-230-g4d54ef55c38e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14.290-230-g4d54ef55c38e

## No test Regressions (compared to v4.14.290)

## No metric Regressions (compared to v4.14.290)

## No test Fixes (compared to v4.14.290)

## No metric Fixes (compared to v4.14.290)

## Test result summary
total: 85673, pass: 77996, fail: 641, skip: 6721, xfail: 315

## Build Summary
* arc: 20 total, 20 passed, 0 failed
* arm: 561 total, 551 passed, 10 failed
* arm64: 100 total, 94 passed, 6 failed
* i386: 52 total, 50 passed, 2 failed
* mips: 60 total, 60 passed, 0 failed
* parisc: 24 total, 24 passed, 0 failed
* powerpc: 32 total, 32 passed, 0 failed
* s390: 24 total, 18 passed, 6 failed
* sh: 48 total, 48 passed, 0 failed
* sparc: 24 total, 24 passed, 0 failed
* x86_64: 96 total, 94 passed, 2 failed

## Test suites summary
* fwts
* kunit
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
