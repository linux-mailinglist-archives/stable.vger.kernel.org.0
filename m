Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8A055AA98
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 15:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233232AbiFYNnV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jun 2022 09:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233189AbiFYNnL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jun 2022 09:43:11 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83F2326F4
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 06:42:59 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id ay16so10100511ejb.6
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 06:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=plxdF0YqEyR1ZHWgV3NsfHZmuI78mEESWQ5gKNQ5Y4g=;
        b=OA4cANuaG0Ny6pDB5jI8En/wEmixtskB14QAj1CfqS4HK9N/h5oXHiDq/9pg8SSsVU
         g4l6OurzaGqnVxuCj+HgBS2F0V1rSEUhYeztifoeXj1Z9Ir6D0W8wmZEUfEuBB0Kq3oh
         iDZIFmghDNAu33cpdyF8ICk9bwAuEXEOUbdNbA5xKzxuzVU581bM5YBvDqo8s0qZd9zR
         6v6tAA/gRPD9Gq97fFU7+/BJxO21juAM6E7+PN8UwYhn6wTF8CnPWaZHAGR81KXaZ/U5
         4CEMdFDQAmdMwuzRX0FhchkcGGM2L5eydK3zxPjNxsZNuHDtI0jvE2sz8rZ9Auixx3Uv
         WsiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=plxdF0YqEyR1ZHWgV3NsfHZmuI78mEESWQ5gKNQ5Y4g=;
        b=Uy8Pr4hD7aCd1Mp8ZSVuc261JXfJJfmBsccyjfLk4uUeOVXDOtnmr1gjPq17g+mX1K
         Q+M+hMU+RgSYcP83QT29GqDEf6OgCcfwmmByp58BG04nxyo1DG3VQMilppR1fRlYx+zW
         xQd/tZZnTzqy2c54WbfPluxVlvYalhr2k1QZx7SOXp53hZ1Vt/cd/gauMHZ0dZY5yk5E
         ANHS73Ruh4hL8DdHTjvVXz4lmELM1Z9KByffduMNntN286Y4KcXX8OmHSJkp19bJ5fl2
         Gu4ppgnxTlLNqjCAi7a7pG7xXTetSZ1sAsNP2MkG/2p0jbXbwAamVH6+fQZtM1J6knJf
         EL4Q==
X-Gm-Message-State: AJIora9UJzPS5WM/1PyItnyw2XhyQzRlFnI+VuLPiCcGp9+p/nGndfnx
        mcXcNTiAfUxgZVloxFTtCvGDpRykeKGn39CjkqZUZw==
X-Google-Smtp-Source: AGRyM1ua+DxoaB9Q5PY8tQ1sjQSkueV53MOBf3rf9IJjJPTp0N/PdVFdfj/AIqv1RuqsgbfPpZmAy1gw5x0O5uELqLY=
X-Received: by 2002:a17:907:9712:b0:726:22e1:6761 with SMTP id
 jg18-20020a170907971200b0072622e16761mr3916080ejc.48.1656164578007; Sat, 25
 Jun 2022 06:42:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220623164321.195163701@linuxfoundation.org>
In-Reply-To: <20220623164321.195163701@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 25 Jun 2022 19:12:46 +0530
Message-ID: <CA+G9fYvCthUD+0jSHt96Uh+8qB7uSddD7uZz_mQTbDSg1VbHFw@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/11] 5.4.201-rc1 review
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

On Thu, 23 Jun 2022 at 22:54, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.201 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 Jun 2022 16:43:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.201-rc1.gz
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
* kernel: 5.4.201-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: efc2c248e27628cb56d6643c2f1d2c32f5864c12
* git describe: v5.4.199-252-gefc2c248e276
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
99-252-gefc2c248e276

## Test Regressions (compared to v5.4.199-241-gbc956dd0d885)
No test regressions found.

## Metric Regressions (compared to v5.4.199-241-gbc956dd0d885)
No metric regressions found.

## Test Fixes (compared to v5.4.199-241-gbc956dd0d885)
No test fixes found.

## Metric Fixes (compared to v5.4.199-241-gbc956dd0d885)
No metric fixes found.

## Test result summary
total: 121268, pass: 108045, fail: 397, skip: 11943, xfail: 883

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
* perf
* perf/Zstd-perf.data-compression
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
