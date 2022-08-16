Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8475D59581F
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 12:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbiHPKZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 06:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234061AbiHPKZO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 06:25:14 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F13F684EDE
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 01:15:06 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id j8so17513232ejx.9
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 01:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=T1hC+4yFQUH4qgK9gud3ypzghlmARyu3cwDIo1GGebc=;
        b=fsQtfO8w4EmdTySO70hlROW+fJHevfQFkEyHCuHQ1L0BKSCMsadpaVFAyY9YzxciEM
         ZXArEpKN9d8DpPokGSjtxZ5B+kc+NVe4kzmk2H/X46RzxdvHJxALC+koLgCnzdPwylBl
         kEX4A9/PoopQqgUvvoQ9qaYMYBBuvEhamCA5DRhwuPBqvfrWfYua8m3MhZ/BtrJn58er
         pG4pXDEUjxmczhAeMJfUCppGZ6pxSOZWtj9hZXMaOiEoLmgV/5I0EvsUk5cByx0FtUVu
         wjcjbtQCil/l4NA+++nTJHios0BcJBiqq8jEcERg4+PH8eIWqJj55FE4pYlpAti945ZD
         Cs2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=T1hC+4yFQUH4qgK9gud3ypzghlmARyu3cwDIo1GGebc=;
        b=z1qqW3rUh44N700/oeqX+saEyhMcQ4TkE/FTjIdyQSl6nvqzvmrBOW39i5ipXnJxud
         o7Zc+xTUzMsIbZIZCBMD1ONj1nlQmmsvSHwcxQsTjNxebwpZ4VWgCdz6lbrEVx8SSB+1
         3OikphMEC83CjOoJ6fSGaVN/km9Som/URmS9tcTuJ1o6AIlvSKKfEjFVW7zckbYbedOa
         Fb4Oi7pNhE/C1pkVo5eUUkM3H+HgmRBQmScdMO26tUEnFlwQP1UMHXtj+CVrIxZr+AFU
         rxSSL2ErGlowfd27kR3kU3V+9mAvcRVetK82CogfiFgo1Znl84b+i4r0bGcpNw024YWF
         q5pA==
X-Gm-Message-State: ACgBeo2uUzaELF8YD1w5fRZMGcwSausu41N1ya8SP3NuTkVTKjXsH2Cx
        FeotFG8m61c/nkvNFFMhr/PVn+lEASbuSmSQNrlnCA==
X-Google-Smtp-Source: AA6agR52TSsA0htngy2rFuGyWB0Nl2gGNzbftZs2wwGHTbpGvlm5zLLLa6G3qnBX9PiXXNhtzHfMcFlMNyEDjZmdw0Y=
X-Received: by 2002:a17:907:86ac:b0:731:5180:8aa0 with SMTP id
 qa44-20020a17090786ac00b0073151808aa0mr12791312ejc.366.1660637705317; Tue, 16
 Aug 2022 01:15:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220815180429.240518113@linuxfoundation.org>
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 16 Aug 2022 13:44:53 +0530
Message-ID: <CA+G9fYu6_GrP_H5T1QYy9cZy4G4N3=iyCYG=6Y4sgn6UY3412A@mail.gmail.com>
Subject: Re: [PATCH 5.18 0000/1095] 5.18.18-rc1 review
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

On Tue, 16 Aug 2022 at 00:25, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.18.18 release.
> There are 1095 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 17 Aug 2022 18:01:29 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.18-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.18.18-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.18.y
* git commit: 56bd9e4c28e9ed65e07e7148e65adfdf1f1c5524
* git describe: v5.18.17-1096-g56bd9e4c28e9
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.18.y/build/v5.18.17-1096-g56bd9e4c28e9

## No test Regressions (compared to v5.18.16-36-g732bf05a92ab)

## No metric Regressions (compared to v5.18.16-36-g732bf05a92ab)

## No test Fixes (compared to v5.18.16-36-g732bf05a92ab)

## No metric Fixes (compared to v5.18.16-36-g732bf05a92ab)

## Test result summary
total: 93607, pass: 85358, fail: 732, skip: 6930, xfail: 587

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
