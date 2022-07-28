Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E33AF583A40
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 10:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235099AbiG1IUw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 04:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234950AbiG1IUv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 04:20:51 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7363DFE9
        for <stable@vger.kernel.org>; Thu, 28 Jul 2022 01:20:50 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id b11so1846925eju.10
        for <stable@vger.kernel.org>; Thu, 28 Jul 2022 01:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=b8yaGykLxy3JXgAVB99MNI414UbxUnFpphZzzQcU4IM=;
        b=sRGDS4/DJdbYg3UbPttpXR1hJehsQSxGyURnB6pco2hLtFGiQKUVuS6pzvclVoAq+R
         vzx+BUyQtPIw0zD9dVI0Qsi5p+eZts+X5sL+Ohy4cgPn/WOxgLW90IYSnxFB5py0amTS
         6wjg2NkJyJHh0bUXJ6uWkqeXB6ttBSAm6yugu2UrUSEqwO/SUZfTcHt6xcUUgKUhgzQc
         9F5cDXoyVOwlj8Ee41///K7NeqUuW2gVUcPx9KSsAyr4AevWtcmnXQu64eXxC6EzHKqX
         RLyFjmfw0e3TkzZOsuHSL6l7snjKsI8UNPHleG01nrYipcVfaeRn3nBCjj0w346+aCzK
         3zcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=b8yaGykLxy3JXgAVB99MNI414UbxUnFpphZzzQcU4IM=;
        b=zEF2gxxNKcBx1LdvN9AQomOnyoovyZoftpV66Wuc/IU8YXuxjISZp+xlgxKY6T/oKr
         oScdevL8mqDJSMv0Qy2V3tvq4xsabJd7zsydPF3YjkQbzVhM2bNgXFV/pIx6tFyA1t5c
         1gnjNpZEq9C4/2GX0C5GJZ6e40MACYIzEa1/nR9Q5GIPXBiA/Wuga+r+eIgLMnkdOkvo
         lOUJvy7TUqLFYDAN4U11nqzE1i4HGQacCb8q9eI5RHmVz7mE2FJmN/Q397DdfcdTRmZ0
         B+0Pbq5hLeWt/Fa+YISWaOkMNz293EYdoo0QqW2bizmaUFgQ79cMFfhbK05y+8G70f5J
         l2PQ==
X-Gm-Message-State: AJIora8d+xrS+AYdlOCHwJzMVybpSRwQAaRts4wx2Lu+81P8AlBX8ojY
        4W/dBsAtdGFMbm3aRIVGGwBNKHXIi7IsGBJs6YeFIQ==
X-Google-Smtp-Source: AGRyM1tyV3Y/sjzyFu9itiyDXCvn6rfhxdEc566pCiXbN7NLo+tvxxivyTL74rRpWihOr23c9JRpZmuxTIfJXDm0JaE=
X-Received: by 2002:a17:907:87b0:b0:72f:ceb6:5fd2 with SMTP id
 qv48-20020a17090787b000b0072fceb65fd2mr16476753ejc.448.1658996449106; Thu, 28
 Jul 2022 01:20:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220727161012.056867467@linuxfoundation.org>
In-Reply-To: <20220727161012.056867467@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 28 Jul 2022 13:50:35 +0530
Message-ID: <CA+G9fYv0sqJuPeKHXp5Wq0AWyp=KtSd4RqJnwy8W4p2WJHtS2w@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/105] 5.10.134-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 27 Jul 2022 at 22:02, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.134 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 29 Jul 2022 16:09:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.134-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.134-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: d2801d3917f2749cb2ec1788ee94021acbb8c2ad
* git describe: v5.10.133-106-gd2801d3917f2
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.133-106-gd2801d3917f2

## Test Regressions (compared to v5.10.133)
No test regressions found.

## Metric Regressions (compared to v5.10.133)
No metric regressions found.

## Test Fixes (compared to v5.10.133)
No test fixes found.

## Metric Fixes (compared to v5.10.133)
No metric fixes found.

## Test result summary
total: 131801, pass: 119019, fail: 509, skip: 11715, xfail: 558

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 308 total, 308 passed, 0 failed
* arm64: 62 total, 60 passed, 2 failed
* i386: 52 total, 50 passed, 2 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 51 total, 51 passed, 0 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 56 total, 54 passed, 2 failed

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
