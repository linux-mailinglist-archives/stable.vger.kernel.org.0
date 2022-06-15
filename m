Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D440954CF45
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 19:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355496AbiFORBX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 13:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357394AbiFORAx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 13:00:53 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50B854F9D0
        for <stable@vger.kernel.org>; Wed, 15 Jun 2022 10:00:44 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id w2so21595998ybi.7
        for <stable@vger.kernel.org>; Wed, 15 Jun 2022 10:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EeKp0clsQUA6dW+6qFFUJzrEz+TdOTimew8JgR0bKMA=;
        b=et/V+90f7nKKr5S5V5II7K0Z18Ceqm9B2OWuHnT5qV224pqU2c6OfRTYEhEYlbJ3cw
         RnQHWw8DvH4t+NcjNGh9D/zVQcpZCNqTLMmGATmElkNq0TMm0Jwup31R4E/PaofbwfGZ
         +8Z9iXoKGewQwyULPEwSnqOh7CE25+9MDvy081U1bBdwwC3xfOE3ncIe62F5JtLVICD6
         28NcVbwUhcmxTg7t0/+iLluLd/DAthY1Ccvkh+7dxVHLMFkonydf6t2mSzJlr/KpMaer
         5d9Bgwidf0j0IQ6ebNG/o8YQvba9f4hNnmEue1FBwwThM3cZjahvoA8xM7BYyT7zaC+m
         jMNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EeKp0clsQUA6dW+6qFFUJzrEz+TdOTimew8JgR0bKMA=;
        b=69qeeV1KxixRqcWqkfordWSUtw/AsFsKFtT1MVnSj950b5tRnkeZtINobHTivGSF9r
         YfzPFTz5pu0Iif65V1LpZQopyJ+yv4Ah0juiyfc9XC1BHeKsHCrD0DBXbV3iqoVnUAyf
         q1tpDyKGdVgapSxEFiV2geDhJEIjejeBXkOtO2zwmj+kW9d/R6CMSIh26PAaS7FL7xc8
         VgO91TEPu/4eIq03dTnXP6rmfTWI3zXyvh9rpgwE7pMAn4WkYH+2MiXa/yIQ97sI8cYT
         APwg88468+lwBI+waFYtEhlGy69cbSHaMOdipV/XUyCkNus6sYU9bRbFe5dMEu6o395M
         UXOA==
X-Gm-Message-State: AJIora92YPPi81nFbIF98fpqVMMyjG9+VPk5T5AXrJVWlIPeHkIxfrt8
        5iGUemR0riFQcjFUEvPDIgewLkSIEiPiCI7G1m4syQ==
X-Google-Smtp-Source: AGRyM1v2b3hA54fgRS4NKBKo+CNA62mj2BxK70qeaNL2CHESAP83JfajfFeLqwxjrTeSqYQze1aVU28N+x8laK8Zxw8=
X-Received: by 2002:a25:b51:0:b0:663:4ff1:d20d with SMTP id
 78-20020a250b51000000b006634ff1d20dmr851309ybl.608.1655312443024; Wed, 15 Jun
 2022 10:00:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220614183720.512073672@linuxfoundation.org>
In-Reply-To: <20220614183720.512073672@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 15 Jun 2022 22:30:31 +0530
Message-ID: <CA+G9fYvfof7stwFYqyy9fFLGB4+MHYWYPVt3XSiT3teHNdR+SQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/11] 5.15.48-rc1 review
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

On Wed, 15 Jun 2022 at 00:15, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.48 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 16 Jun 2022 18:37:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.48-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.48-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 2e65f63d5e2c817d883c4c8df2010aa23bd07ea4
* git describe: v5.15.47-12-g2e65f63d5e2c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.47-12-g2e65f63d5e2c

## Test Regressions (compared to v5.15.40-103-g293cfb310f44)
No test regressions found.

## Metric Regressions (compared to v5.15.40-103-g293cfb310f44)
No metric regressions found.

## Test Fixes (compared to v5.15.40-103-g293cfb310f44)
No test fixes found.

## Metric Fixes (compared to v5.15.40-103-g293cfb310f44)
No metric fixes found.

## Test result summary
total: 127914, pass: 114505, fail: 268, skip: 12412, xfail: 729

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 319 total, 316 passed, 3 failed
* arm64: 64 total, 64 passed, 0 failed
* i386: 57 total, 50 passed, 7 failed
* mips: 41 total, 38 passed, 3 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 59 total, 56 passed, 3 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 26 total, 23 passed, 3 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x86_64: 62 total, 61 passed, 1 failed

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
* ltp-cap_bounds-tests
* ltp-commands
* ltp-commands-tests
* ltp-containers
* ltp-containers-tests
* ltp-controllers
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
