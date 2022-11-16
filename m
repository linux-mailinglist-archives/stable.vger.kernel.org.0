Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8C1462B3C3
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 08:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbiKPHLP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 02:11:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232125AbiKPHLO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 02:11:14 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A081F608
        for <stable@vger.kernel.org>; Tue, 15 Nov 2022 23:11:13 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id 136so4291834ybn.1
        for <stable@vger.kernel.org>; Tue, 15 Nov 2022 23:11:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Uo+F/dwYBu2BhWYicwDQ8MtuLYkYaCVTN8Id6vfMvJo=;
        b=R4KqyeGLPbUUjCItTraIjdotOGDD1uGF0L7fGq0fcAywAJ9m4Ul9f0o6VELMAm47i7
         w3gTfXPJp2s0YdtwLIiR4aM7hXal2+2yvToqSATcgFDNS0E9Ho8EdKcDRi5hxONV3+XK
         kiQ5+4YbgYMtccXaG+V4Sa3mEmIA7ObdfhTu8p3bfdELWR0JUQffWy/MtfqFkQTAC2jq
         MWK1YxOFNQ4/V8FXjzpMQgk/S2U+Ro0MCZ6M95SR3TadmkxlJ6ru95wXZYS//qbpqzpX
         aHd9ODCvGEUxA0GHbMfViNtPNEE5+29AMmZgY9Bdy81pHPdlv708bCa0mcnIrU0Iozl2
         X1qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Uo+F/dwYBu2BhWYicwDQ8MtuLYkYaCVTN8Id6vfMvJo=;
        b=22dCh9+RedKSGBEfXYPb7lWJp3BM+hlZAHlbyZXILPF3LeGCe7XBAIxM4yHe19zsq4
         SEReUTPAHa2wrvUcLwpw9zFZxPm7wcvGFUhSr9soEP8iGSx+mJZateO2fIuhQhXcYQU+
         Y4CXK6zRT/7esxS2PtZTO/xP4QxrLP+xDoVQhMzFFj2KzBcNb4JIkcKOfBVDWAWVWRqW
         jAmX9yk0armuMI2PFQSVOR2pF+/W7sebyZtXe/OiLYBEHPJM9NuFZlPVXV2r4GhX/EXk
         mgqQHXRthVxG4WI81yLqJPgc3LmhFkcw7/UvHb5sfFmvKvI5oEfOClaY8+un+shd9ssl
         O0xA==
X-Gm-Message-State: ANoB5pkPWL6R94tTEuP64RaIIlhYUTrcmDzQqGS7DbC2OObDoOtihyRi
        aSx0y+YXIe8wYWW6frzEmSQn3d11QBepV5+1QGI8TQ==
X-Google-Smtp-Source: AA0mqf71t/B31O1SMQbQNqK9FKEIDd2aMNyebi06GCPBX950F0v4uWiUqlAfmoD5JhIL9YHK+qvFTNEtmIs8gqnYaik=
X-Received: by 2002:a25:bb93:0:b0:6e4:c5c4:a62b with SMTP id
 y19-20020a25bb93000000b006e4c5c4a62bmr4081097ybg.560.1668582672799; Tue, 15
 Nov 2022 23:11:12 -0800 (PST)
MIME-Version: 1.0
References: <20221115140300.534663914@linuxfoundation.org>
In-Reply-To: <20221115140300.534663914@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 16 Nov 2022 12:41:01 +0530
Message-ID: <CA+G9fYu9iacRZf1gQeVi84GyNTM+x5GMurB9PrDt3P3h5-2+yw@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/130] 5.15.79-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 15 Nov 2022 at 19:34, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.79 release.
> There are 130 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 17 Nov 2022 14:02:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.79-rc2.gz
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
* kernel: 5.15.79-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 0963ae7afcba623c33f520314e776e107c35c45f
* git describe: v5.15.78-131-g0963ae7afcba
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.78-131-g0963ae7afcba

## Test Regressions (compared to v5.15.78)

## Metric Regressions (compared to v5.15.78)

## Test Fixes (compared to v5.15.78)

## Metric Fixes (compared to v5.15.78)

## Test result summary
total: 98827, pass: 84513, fail: 2937, skip: 11065, xfail: 312

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 285 total, 283 passed, 2 failed
* arm64: 80 total, 77 passed, 3 failed
* i386: 62 total, 59 passed, 3 failed
* mips: 54 total, 54 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 60 total, 60 passed, 0 failed
* riscv: 20 total, 20 passed, 0 failed
* s390: 24 total, 24 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 67 total, 64 passed, 3 failed

## Test suites summary
* fwts
* kselftest-android
* kselftest-arm64
* kselftest-arm64/arm64.btitest.bti_c_func
* kselftest-arm64/arm64.btitest.bti_j_func
* kselftest-arm64/arm64.btitest.bti_jc_func
* kselftest-arm64/arm64.btitest.bti_none_func
* kselftest-arm64/arm64.btitest.nohint_func
* kselftest-arm64/arm64.btitest.paciasp_func
* kselftest-arm64/arm64.nobtitest.bti_c_func
* kselftest-arm64/arm64.nobtitest.bti_j_func
* kselftest-arm64/arm64.nobtitest.bti_jc_func
* kselftest-arm64/arm64.nobtitest.bti_none_func
* kselftest-arm64/arm64.nobtitest.nohint_func
* kselftest-arm64/arm64.nobtitest.paciasp_func
* kselftest-breakpoints
* kselftest-drivers-dma-buf
* kselftest-efivarfs
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-kvm
* kselftest-lib
* kselftest-net
* kselftest-net-forwarding
* kselftest-net-mptcp
* kselftest-netfilter
* kselftest-openat2
* kselftest-seccomp
* kselftest-timens
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
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
