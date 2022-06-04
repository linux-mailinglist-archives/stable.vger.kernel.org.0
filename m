Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D492B53D80A
	for <lists+stable@lfdr.de>; Sat,  4 Jun 2022 19:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239217AbiFDRbi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jun 2022 13:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234823AbiFDRbh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Jun 2022 13:31:37 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F4533367
        for <stable@vger.kernel.org>; Sat,  4 Jun 2022 10:31:36 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-30fa61b1a83so104136387b3.0
        for <stable@vger.kernel.org>; Sat, 04 Jun 2022 10:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yFq7x3ezthL42YyRi4Hh6z4qGsAb2l4xTVLZJzOYTSI=;
        b=UjnIJ4nQ8hCSdb3GgVUP+rkneW9G3bVFikM3oskzeex/LksmgHJwCbZhTd1k7ckjXv
         2OFgM06D0vIKCFWgwPymgpxV8bk9ICqkBuN+6H+ded3pMM9H5K2WUi+k2wbs4eOj2Fg0
         89mb6dxWke34ffYuNAuy97HA24+CR2OE2ZujDqwDxPyovchidgH579Xs/JlXhoM0RG0Q
         47J86GKHHZe0VEWbZSczn344HRH4nkIDhe2znnCZvEBj6Rl0th93ciCC6a2iLJnPHGlM
         5KWdat7Qnd8dgWXZc6QzBmPlG+ojExxUT+V8E/VKUGVyjeOtIgGip4IlvzXBOQnetb9M
         27VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yFq7x3ezthL42YyRi4Hh6z4qGsAb2l4xTVLZJzOYTSI=;
        b=Ln4lC9v5GiGK0XDgnH72252wKkGuZlVp6Lv1fTSrR/i1yLpGnTLbiBbM9sgiqyQ/3/
         dbOPCAw1rTk7jT2/H0zuzzL7SAkkIe6i0l+CyHHMA4oRqEwws3VCyv6rotjWXQz8Ug5g
         ayCirdZdrfjyYK8y2JBUuKNNKg8rQ14x7fuJwtQo875zHaoEn2ojZA01ZCLVgQbEoqC+
         Ai679zG94W1MrbStOk3cVLU0Io/Ymxpck7QMvSt9Yr1C8/ygpFYZ+/xyD573F2Heg2ZM
         XLSWDdjsEFvGWXHxIb2d+FOvGGuE/aZG2z2T5p1bA19kI8G90MLuj7wcreVWSdT//X22
         hVKQ==
X-Gm-Message-State: AOAM533hMByx5PCVFkV76jQbHChMBCmhfqT0TA3S1JU05xxi8z/6VcM3
        txUsPS1/On7I0ybiQ64n1p7HgyB0oWUNCceTTlimRjGmSvv38g==
X-Google-Smtp-Source: ABdhPJxIuLQY29CVBqxKqP1FZt6ZDVKyyazmSVipVONuvr8/8pkS+mLkt5pgWWAoY88pDOoVSmGBPddr67xhuLG2d8o=
X-Received: by 2002:a81:b343:0:b0:300:4822:e12 with SMTP id
 r64-20020a81b343000000b0030048220e12mr17819276ywh.376.1654363895333; Sat, 04
 Jun 2022 10:31:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220603173815.990072516@linuxfoundation.org>
In-Reply-To: <20220603173815.990072516@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 4 Jun 2022 23:01:24 +0530
Message-ID: <CA+G9fYuTq5PG0wTCS22vEWWJLQKy8xBuvYHKFN7MKkkHGJzAPw@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/34] 5.4.197-rc1 review
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 3 Jun 2022 at 23:14, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.197 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 05 Jun 2022 17:38:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.197-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.197-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: 2b69e7392fd9509c34f22e22898d4fd8de4bac19
* git describe: v5.4.196-35-g2b69e7392fd9
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
96-35-g2b69e7392fd9

## Test Regressions (compared to v5.4.196-11-g04a2bb5e4a0b)
No test regressions found.

## Metric Regressions (compared to v5.4.196-11-g04a2bb5e4a0b)
No metric regressions found.

## Test Fixes (compared to v5.4.196-11-g04a2bb5e4a0b)
No test fixes found.

## Metric Fixes (compared to v5.4.196-11-g04a2bb5e4a0b)
No metric fixes found.

## Test result summary
total: 130079, pass: 116477, fail: 185, skip: 12140, xfail: 1277

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 313 total, 313 passed, 0 failed
* arm64: 57 total, 53 passed, 4 failed
* i386: 28 total, 25 passed, 3 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 54 total, 54 passed, 0 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 55 total, 54 passed, 1 failed

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
* ltp-sched
* ltp-sched-tests
* ltp-securebits
* ltp-securebits-tests
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
