Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9882157B48A
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 12:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238509AbiGTK2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 06:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238087AbiGTK2w (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 06:28:52 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4FF132D8F
        for <stable@vger.kernel.org>; Wed, 20 Jul 2022 03:28:49 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id m13so13003084edc.5
        for <stable@vger.kernel.org>; Wed, 20 Jul 2022 03:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HxeeahFnyrnq1to3tzfOP43nSOufg2cPA8exTdvP6so=;
        b=DGLGyt7ZUdRbQTHpOvawsrPyT+cOAeBxpKEBxUemapIUTCtgmMziVfaMUo67dDFh//
         N/4v79fPnDG/ydkr1XSRjiqDkD/isWsNsHKKqiAtxPmeti/1ZYk9+oG7e+hZHqrW7NO7
         IAP1bO5Vqlg7x6C+6zlZV4N3vSa1a5tEGyzNk6wlizsYFutZ7g7y1YZGXP5Do3q3ZY3l
         dIYnMckXVQ/DOr21IWG1WxfWrRiGfQnhj9aHvAdiwyTNkLxhpYeL52y+bBclwAD5YMkm
         J90k9opl1TvTtvsMvX4Y3Zc9dOKoPZXIjPgHtC6AFT72EzIm4fTkJGquNN9lk7WWi+wT
         GQFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HxeeahFnyrnq1to3tzfOP43nSOufg2cPA8exTdvP6so=;
        b=GD4mb3CDjYZuquKQOKQlBsrpZIzpOQuIIB+XxUr5uCNoUVM1UmA/4UHffh6dM3DSme
         sNCaoxE48Zd83/lz+7LqST1bQ2QLkW6eRHLTuUCON60ym4XRL19PlkMTC2SlgTIWzn9I
         UJKpI5W3IHx3gqDECYGnxI4Jj7eMz20FgnFpkq68jZ9n+mkqcf/zF+EGLftGIdc/0qW5
         H6/ekvh0su7A4JgKdMMdt2X5dcTk5x1jTWPirjwAt9Fgu0Tu2jJKkMLIvNp3+fwVzObA
         D7fA4CuwvzV3udMsa9KFM6hUDqgpK8rbatbSciFMuu9DMxhCnlDwSFSwo3C7/9Y4pIOI
         w0CQ==
X-Gm-Message-State: AJIora+xBCLWKOfI1ngvB6bUPlw1qOCP2qrDjXE1qOMFHCA/DSAxsLVt
        4424xIbQR2tYuUsWO0Ed1VFNwwyW8+CJ5yoHP94NulmTbJP7kg==
X-Google-Smtp-Source: AGRyM1v+RgpIAJBMsB0m6x3IAt/8edQ13VW4RHj9DNTPPXSKT+RiSUwrLYziGcQP0kAsm7NdkEzF389/y/5GLa5OdVA=
X-Received: by 2002:aa7:c6d5:0:b0:43b:a52b:2e9d with SMTP id
 b21-20020aa7c6d5000000b0043ba52b2e9dmr6653211eds.55.1658312928148; Wed, 20
 Jul 2022 03:28:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220719114518.915546280@linuxfoundation.org>
In-Reply-To: <20220719114518.915546280@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 20 Jul 2022 15:58:36 +0530
Message-ID: <CA+G9fYsTSDGqM1cW1f8aQ8fN3yT71ENpY-duX2vQzWi-Eq-9Cg@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/48] 4.19.253-rc1 review
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
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 19 Jul 2022 at 17:29, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.253 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 21 Jul 2022 11:43:40 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.253-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.19.253-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: 8b84863f2dd59d1663d4c8a38cf7a59fdef04dfc
* git describe: v4.19.252-49-g8b84863f2dd5
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.252-49-g8b84863f2dd5

## Test Regressions (compared to v4.19.252)
No test regressions found.

## Metric Regressions (compared to v4.19.252)
No metric regressions found.

## Test Fixes (compared to v4.19.252)
No test fixes found.

## Metric Fixes (compared to v4.19.252)
No metric fixes found.

## Test result summary
total: 113490, pass: 100359, fail: 274, skip: 11697, xfail: 1160

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 291 total, 286 passed, 5 failed
* arm64: 58 total, 57 passed, 1 failed
* i386: 26 total, 25 passed, 1 failed
* mips: 35 total, 35 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 54 total, 54 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 52 total, 51 passed, 1 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kunit
* kvm-unit-tests
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
