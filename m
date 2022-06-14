Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE9254A998
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 08:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232702AbiFNGjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 02:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232644AbiFNGjA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 02:39:00 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D13A52D1EF
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 23:38:56 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-2ef5380669cso19547407b3.9
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 23:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=v/qC1W0WmQAv/ae3McCw7es70L5UDxMvwvdNzZcKUaU=;
        b=HbM6PUKw52fcE+pp/1haWkOQay1aPgeLJRKfg+jWuYRkost5q/53euLwlo/uZp9Z7z
         AkgwVgVV9QKtzy6UoOMYWwzH9f7FRXnbazuSOjy6IcDLJXLsABXaSqGYObJMD6lvTjyL
         sWducAUG6Rccc+fW7tY965B6dbVLKWsonqr6aOCfX2h8ARou36Cr2n4pRW0SZdfRBOpF
         YyW/SUJMQ2XeOl/OzJv0sUr6thh+xECqTDCXpTVAt2Pvd0itoC+yDilVsLx3SO9f9o44
         xeYp28Hy5PU4ivDTwALJsTGOzRpjcit/NrUEoaxdXsT2DmoJwUn/DNmtMzTqsC3j8zuA
         COpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=v/qC1W0WmQAv/ae3McCw7es70L5UDxMvwvdNzZcKUaU=;
        b=OKZwm4W3tlT1b2EX+NKXEDLI7WL5t3aC53Dgh1mJzkTHpvLjaAFm7kd8kA5idAhHRB
         Wp4YaPKn8K9m0ET6RBHblFvlUy8JtEvkX3l4MU61z3+9jpzXC5lUv+p3iEWzdun8yLvk
         gRDWYDTzzcOrAY+T0TkmPOEGabfJGt0Nggvu7YSUm86I7tHwz4hAnkQWkrCXvv3UxvW/
         FpwNxq/3Duij8ba9cDkn2Zom10ZONihCW8D3fZDJ27RPQ9LwnPPbTNzXceQGSg0ZOKLi
         sJAhoHPj4o98oe7DiO3SoMw8KOPGuEIWcaPo2N/H4J8gjy27C6etHn36ghW3SdHsW6v/
         EG9w==
X-Gm-Message-State: AJIora+Zc7+EPZCd9jZvVQh5KASvZumDp5I+AxlLmzWSBIZchbw5/bVn
        re05RJ7HDm6Voqwchc21afeonX91o+NU8fR1L8kWGw==
X-Google-Smtp-Source: AGRyM1tmHNz4yrGNa3pc540POm8ToXiasQ91c2XlHvmymbqCfC+aF0179npn8tPG5v4vrpsWk8NYDAty6kb7ym3epLI=
X-Received: by 2002:a05:690c:442:b0:313:fb25:3a6a with SMTP id
 bj2-20020a05690c044200b00313fb253a6amr3870303ywb.376.1655188735925; Mon, 13
 Jun 2022 23:38:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220613094908.257446132@linuxfoundation.org>
In-Reply-To: <20220613094908.257446132@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 14 Jun 2022 12:08:45 +0530
Message-ID: <CA+G9fYuVSL=1GaKrq7dwM7=B5WsowvM_AbEj4-dgELTRuV_DuA@mail.gmail.com>
Subject: Re: [PATCH 4.14 000/218] 4.14.283-rc1 review
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 13 Jun 2022 at 15:52, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.283 release.
> There are 218 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 15 Jun 2022 09:47:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.283-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.283-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 3cf64075b816c66f6770e4ec7ca94954f1bfcab4
* git describe: v4.14.282-219-g3cf64075b816
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.282-219-g3cf64075b816

## Test Regressions (compared to v4.14.282-141-gdb03c39d5674)
No test regressions found.

## Metric Regressions (compared to v4.14.282-141-gdb03c39d5674)
No metric regressions found.

## Test Fixes (compared to v4.14.282-141-gdb03c39d5674)
No test fixes found.

## Metric Fixes (compared to v4.14.282-141-gdb03c39d5674)
No metric fixes found.

## Test result summary
total: 102185, pass: 89921, fail: 183, skip: 10568, xfail: 1513

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 293 total, 287 passed, 6 failed
* arm64: 52 total, 45 passed, 7 failed
* i386: 27 total, 23 passed, 4 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 16 total, 16 passed, 0 failed
* s390: 12 total, 9 passed, 3 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 49 total, 47 passed, 2 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kunit
* kvm-unit-tests
* libhugetlbfs
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-cap_bounds-tests
* ltp-commands
* ltp-commands-tests
* ltp-containers
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests
* ltp-fcntl-locktests-tests
* ltp-filecaps
* ltp-filecaps-tests
* ltp-fs
* ltp-fs-tests
* ltp-fs_bind
* ltp-fs_bind-tests
* ltp-fs_perms_simple
* ltp-fs_perms_simple-tests
* ltp-fsx
* ltp-fsx-tests
* ltp-hugetlb
* ltp-hugetlb-tests
* ltp-io
* ltp-io-tests
* ltp-ipc
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl
* ltp-nptl-tests
* ltp-open-posix-tests
* ltp-pty
* ltp-pty-tests
* ltp-sched
* ltp-sched-tests
* ltp-securebits
* ltp-securebits-tests
* ltp-smoke
* ltp-syscalls-tests
* ltp-tracing-tests
* network-basic-tests
* packetdrill
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
