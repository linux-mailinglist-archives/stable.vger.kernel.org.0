Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 002E654B87F
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 20:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346420AbiFNSXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 14:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346696AbiFNSXQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 14:23:16 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2902C1CB09
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 11:23:14 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id r3so16566460ybr.6
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 11:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dmnIWK6mirlXwJXaZSyRAZoPFqhnuf2/pbD4ANzuT0U=;
        b=okheJ6IQnFLB2erX1IakOUr+rBIdEQWxQSKYXwIbbYBr8rp6N3GAgjw1Y6s69Imd74
         ab10/CG15zbK4tkQwSTNav0ActlOlDx0ZTE1Ipyos9bHrSCY3ZVcrRvMtgq8lWOBsY9F
         xjWUOSVFFR182Xv+PgoN6umk/FbYHr1mznzCl8wy0QCvw8lD+jRipGNFSVqLruwnA36A
         DP/dum8a0nfNPpjhUl6PzwwR+Ov3a8JIG2sK8u2A4o8PyWNzeyHJynkCYc/+YFzgKu7D
         rbqld1ghYtjTP7jKm3U/4yAZt/DKpK3d4XFRKZ37MqcfRQ/fh1zhL4HZGVlZOeKDsspH
         zBZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dmnIWK6mirlXwJXaZSyRAZoPFqhnuf2/pbD4ANzuT0U=;
        b=JHXBUuworlpA9USy6kOmM94DRJXrNYzkIzpjpJW/b37ar0sZkXAzIIKkEK2Bpo34kL
         byqmG2HMxgzeQ24b5Ap2OrSUSUAeWeY/iwMkIf+Ib1HQBnFRHw3dqX4PZbby5Cevju4i
         4a3Y+RVpveX9y3usLHmj8edEmwlQPgCFvRViX88BipoNethqugtnxuLOap3vm5OY87RG
         AWTxtS5otUqIw2dyrBLjhLC1yX2Kpnaov4Ah/efuMM6syWD2aeMMcOuDr/FyyGn440On
         Tea+oj9+VIh2UVLl4RnsfcK/uxN2cBzr+7qqDtmvXm/rkWcEsB4jWk8UXr/J24bJ+2Da
         4MbA==
X-Gm-Message-State: AJIora9Dxr+BCV3uzrksdaPFw2D/aARbAh80UnylP6JiHUJo80GEPMTA
        P9lHPQfF1G5BmjW65uunp7hoaN2x1ZXVAvw5B5b2Fg==
X-Google-Smtp-Source: AGRyM1tW+hX0CjexB3Y5s8MV72G7o7V6FzH58eglIAzW44nLFLJgA+e8/BIRaSqkXf/0V4SsEa1tLTWH/HkG9Z9E3Bg=
X-Received: by 2002:a25:6546:0:b0:660:2a80:d6b6 with SMTP id
 z67-20020a256546000000b006602a80d6b6mr6173171ybb.617.1655230993165; Tue, 14
 Jun 2022 11:23:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220613181529.324450680@linuxfoundation.org>
In-Reply-To: <20220613181529.324450680@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 14 Jun 2022 23:53:02 +0530
Message-ID: <CA+G9fYvUzFC9mV+xAxPjvCnGORNRS8aB0i=AFK-Kw-_Z+DTJdQ@mail.gmail.com>
Subject: Re: [PATCH 5.17 000/303] 5.17.15-rc2 review
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

On Mon, 13 Jun 2022 at 23:48, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.17.15 release.
> There are 303 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 15 Jun 2022 18:14:43 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.17.15-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.17.15-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.17.y
* git commit: a554a1e2ef7fa48cebd9cc2349804974247c0958
* git describe: v5.17.13-1076-ga554a1e2ef7f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.17.y/build/v5.17=
.13-1076-ga554a1e2ef7f

## Test Regressions (compared to v5.17.13-773-gd0f9b2818e1e)
No test regressions found.

## Metric Regressions (compared to v5.17.13-773-gd0f9b2818e1e)
No metric regressions found.

## Test Fixes (compared to v5.17.13-773-gd0f9b2818e1e)
No test fixes found.

## Metric Fixes (compared to v5.17.13-773-gd0f9b2818e1e)
No metric fixes found.

## Test result summary
total: 124576, pass: 110952, fail: 475, skip: 12213, xfail: 936

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 313 total, 313 passed, 0 failed
* arm64: 58 total, 58 passed, 0 failed
* i386: 52 total, 49 passed, 3 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 54 total, 54 passed, 0 failed
* riscv: 22 total, 22 passed, 0 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 56 total, 55 passed, 1 failed

## Test suites summary
* fwts
* kunit
* kvm-unit-tests
* libgpiod
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
* ltp-sched-tests
* ltp-securebits
* ltp-securebits-tests
* ltp-smoke
* ltp-syscalls-tests
* ltp-tracing-tests
* network-basic-tests
* packetdrill
* perf
* perf/Zstd-perf.data-compression
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
