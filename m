Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 727465ABC96
	for <lists+stable@lfdr.de>; Sat,  3 Sep 2022 05:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbiICDd5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 23:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbiICDdz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 23:33:55 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48AF9E2C73
        for <stable@vger.kernel.org>; Fri,  2 Sep 2022 20:33:54 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id og21so7262436ejc.2
        for <stable@vger.kernel.org>; Fri, 02 Sep 2022 20:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=hp6nv6h7bty1ARLn1E+z6KwR5eZiuL+MItLPO1Nzzt8=;
        b=GaJOygzrJaHGChNu7cINHp0pXLkfGcJr5SxOXk50B6ZnX5cK0S6tYm1Sj4PrjR5fBH
         0R8J6Z60gd4mkCsd0loYB7htt5jO9It1P3X6dTgCUfq5GCzjia+18e88Ryy4V9wnFcPt
         2lMEduSxPTRj3wQtiYWLnCHtriO8n5BgAO3pzui1GBg0UnAhBdxih/ffyoTeAKTmPtA3
         SYWNPqV4JqjZAgJ5HBAKZKgH30A5NmI+9jHEUv5DYcEJ5YvDO1Qcd+Sz146Vgxjyp4+M
         IUSh8AqL8O/vrtsSBJT5+lpJtk8BNUmm+wLDHrQKWI6cX7yuIIJrHd8GSJakxQqLRB3w
         Ss1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=hp6nv6h7bty1ARLn1E+z6KwR5eZiuL+MItLPO1Nzzt8=;
        b=Rlbg9D7K6G3Vb9lam+6yg9nFYPfzvMueFQ8OiAMVJf3nQhayt3IWca4tSlDuMwVHlX
         DZQHSJW9UzUTT6vA+L9mxd+kGY3HAyRRONQjrpma/BQEsxavvzQ+Gjy2SYRjKna5TbDb
         i17nqzZyvkvacCazSF1r2kIf+XKLbOk4j54yaGEapT3GnF1MeV7Gx/R71czmCVDyCk+u
         rHAXIP0Z8XguSUCpZRGCfcyAnDrAdRh61Dictz3+JKIB0abunjxQNCmSKDaDa7S1C6Rr
         g9Lfu/gTzkzvRFD3YR/tMPdwAdbPpeNB0SpyHItg8wHywBI2ARgWZA6WtE5+n/jbvNuS
         W1AQ==
X-Gm-Message-State: ACgBeo3oyfTc8zV7+KJMqi42b5WE9RGPNfvOCahwSRVIuDbEDeYI5lVR
        4OmXsQdzeKRZbFOfFQVUQkXrvEG4pN9HfcFWdP27FA==
X-Google-Smtp-Source: AA6agR4qnIVh4QrhKfBstj8mL7plaDZwIluX24qYlrj+31jsVoT3h3420nWjX6jaWumXyvrbHeHA9RLb1LO7sjirmq0=
X-Received: by 2002:a17:906:da86:b0:740:7120:c6e6 with SMTP id
 xh6-20020a170906da8600b007407120c6e6mr24895516ejb.44.1662176032507; Fri, 02
 Sep 2022 20:33:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220902121404.435662285@linuxfoundation.org>
In-Reply-To: <20220902121404.435662285@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 3 Sep 2022 09:03:40 +0530
Message-ID: <CA+G9fYtST3tfAMOsnRhLDumH+zBDTRLbA-_XnAVNqT=f0v6p4A@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/73] 5.15.65-rc1 review
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

On Fri, 2 Sept 2022 at 18:02, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.65 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 04 Sep 2022 12:13:47 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.65-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.65-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: ad2e22e028e72136a55cb6c301a29aa0178fe7d6
* git describe: v5.15.63-211-gad2e22e028e7
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.63-211-gad2e22e028e7

## No test Regressions (compared to v5.15.63)

## No metric Regressions (compared to v5.15.63)

## No test Fixes (compared to v5.15.63)

## No metric Fixes (compared to v5.15.63)

## Test result summary
total: 107640, pass: 94949, fail: 685, skip: 11690, xfail: 316

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 306 total, 303 passed, 3 failed
* arm64: 68 total, 65 passed, 3 failed
* i386: 57 total, 51 passed, 6 failed
* mips: 50 total, 47 passed, 3 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 59 total, 56 passed, 3 failed
* riscv: 27 total, 26 passed, 1 failed
* s390: 26 total, 23 passed, 3 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x86_64: 61 total, 58 passed, 3 failed

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
