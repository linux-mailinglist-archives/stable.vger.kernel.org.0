Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65CE25FB1A6
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 13:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbiJKLmb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 07:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbiJKLm1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 07:42:27 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B1767CB6B
        for <stable@vger.kernel.org>; Tue, 11 Oct 2022 04:42:26 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id w18so4306432ejq.11
        for <stable@vger.kernel.org>; Tue, 11 Oct 2022 04:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=w6W/H/BEABkNYv8rSt4AC2s3ra8YDJ2D0/Peqdd/kpw=;
        b=tout3259Te4xgphAbpEW/BHh68jKCYczko+1Lmq077QJf/uiNQEs73j9d2PFtuJXnA
         sv1/u2f+9EPbRgNd7ExREjK4uHxaGZdbGa6k7q9ojc0rA6VVe2aKb7S7I+lj0oYNUl6n
         g8peSY2vkdZ1Xjx+PpQYDqJmqi7+PpMy/skMNtw6nxcBQNNcGL9M6uHZq7tpVEYPgJl3
         AaspPCMqyRBmI1dyRMoTDJJk6ZezEOr2h6kt6F2THnP75hluPusvkJbJbL6DILTsczKH
         Sn+MhrQnN6bB+HWJDpWBodXw2crm46HIyyVIm7C1IVmsLRKRXxGMJ7fkogG6vOl8FeuH
         JNbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w6W/H/BEABkNYv8rSt4AC2s3ra8YDJ2D0/Peqdd/kpw=;
        b=7MYQnlBwvqGz9XVCzasQ3Zh3zRcPir4J9GjX7C5dW5ddVVV1z6XZHhTWoU7DebwOek
         Rzm7JT38yNacOUoVezb++uShpMWKJqbyT5ZBSs1IGQEiDaYUp24QFxUipFADMUsnr5IJ
         O/HaD4EIqUWH5dXZe7+fnryauEPfYS97DI4ExR8f7CI494M/MLpY1RHsRlumRMT8dq4x
         KS8h0XLKaUM8B7U9o9gJlao2OqYAm+qDxp3g55BXqrELG9uPgmkLMbdzk8vYQ9y+J29o
         clnz3cRWdMAv3EM7+QlrRloPHLEVDnqX2Z55B0/PEMOydUWMyxTDTcbJ0asprY5/K/fU
         WaDA==
X-Gm-Message-State: ACrzQf0P6tIl5pgryqJoCCU7UxZ/XhR4OvLHATpEVCP27CHhMkOEeAwM
        Zz5JZGX95uT/LzHtdJO3m/u5xvRtqirmFn2Cis2bPg==
X-Google-Smtp-Source: AMsMyM5+L/seIZvVl5ev76Qq+5th/iy/XuP9Q5UXT8jXzRUd6JA+CHoJRAvuhhecHqQrQiZEPZngKWL+4XN9ON3guDA=
X-Received: by 2002:a17:906:fe46:b0:73d:939a:ec99 with SMTP id
 wz6-20020a170906fe4600b0073d939aec99mr18894342ejb.169.1665488544466; Tue, 11
 Oct 2022 04:42:24 -0700 (PDT)
MIME-Version: 1.0
References: <20221010191212.200768859@linuxfoundation.org>
In-Reply-To: <20221010191212.200768859@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 11 Oct 2022 17:12:12 +0530
Message-ID: <CA+G9fYt87e4-5fYtVa--q9Motx8NkovDsur8x7KZ-HFpG5MYLg@mail.gmail.com>
Subject: Re: [PATCH 5.19 00/46] 5.19.15-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 11 Oct 2022 at 00:42, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.19.15 release.
> There are 46 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 12 Oct 2022 19:12:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.15-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.19.15-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.19.y
* git commit: 08ca61ba8d0a5e6dcc1bfc3b6deba6acfb199598
* git describe: v5.19.14-47-g08ca61ba8d0a
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.19.y/build/v5.19.14-47-g08ca61ba8d0a

## No Test Regressions (compared to v5.19.12-110-g30c780ac0f9f)

## No Metric Regressions (compared to v5.19.12-110-g30c780ac0f9f)

## No Test Fixes (compared to v5.19.12-110-g30c780ac0f9f)

## No Metric Fixes (compared to v5.19.12-110-g30c780ac0f9f)

## Test result summary
total: 110080, pass: 98721, fail: 747, skip: 10334, xfail: 278

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 333 total, 333 passed, 0 failed
* arm64: 65 total, 63 passed, 2 failed
* i386: 55 total, 53 passed, 2 failed
* mips: 56 total, 56 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 69 total, 63 passed, 6 failed
* riscv: 27 total, 22 passed, 5 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 58 total, 56 passed, 2 failed

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
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
