Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D480959AC82
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 10:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343587AbiHTIK2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Aug 2022 04:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344484AbiHTIK0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Aug 2022 04:10:26 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D30A6EF36
        for <stable@vger.kernel.org>; Sat, 20 Aug 2022 01:10:21 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id o22so8049493edc.10
        for <stable@vger.kernel.org>; Sat, 20 Aug 2022 01:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=1+lx3KfzLA3Bl+2mHK+2ai5gW3qN56may3qT3AObQ0Q=;
        b=fx7VUWO2slXaKYm765QUsT+4fEO1cdEgTMvl6KQ+gBQdWPFocKfZ5EIvtHNSVNtyvd
         KP1Yl1tzvWZffTTvKPc+/B0wnU4c+fmU0nqrmC+V0uWJ+nKoGbmr+Z/pQl1tYljmHxk0
         OMdF54TgxFw73D+LhI4K5tTnIwndbCgGaau15CBN+onJOK+aaxCmDdEYuKwzrC9f5um6
         mTHGpAf78owAEpnxzuUNwac8o+72nn9AekEbZnBmQhNBdX+8ty9qI7f9nQcvW1l4jBss
         ssfQnILrbQSzPlsfYUXel661Ny73BEOmpTnA4o4iZuMRj3LFWcFgsaKy1YGZRYlZqfDA
         8spw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=1+lx3KfzLA3Bl+2mHK+2ai5gW3qN56may3qT3AObQ0Q=;
        b=sZZc5HLFsvdLXcvtpctfgp7ozrV0poeeGDRP1Wm0wmyT7L8GdnioVJ6K+1K70pWD8c
         qXsK+YrqCxm7nya+DOjepwSLVLhCgqQs7HUJISp6GS8HiQ8plJrQ1PoFH6FDHl6hJkGK
         JwwL5GJ369d/wYoce/wn4QAS4Jmp5X7cJGNG8J2d42mhktdGZQTznNKQ8MxiVtgLPMA9
         j0ON1+sH+cboBbTcujTGFaYfAGcRP+9xvwU7b8kg7NLhMj44EIc/qDZ/XYqKJhsIpEE1
         2mQJ8rPjXym2q+D9X425EgOGcmIzk8k+NHvsLD6icVpnJn6GYGlSEs5dOum8H+ivw9+n
         Ceog==
X-Gm-Message-State: ACgBeo2oS+GkdHh+d1jTRILVSXfbfZQw1d1oxx9b6Uy9pqgMtDamrySP
        DjwvrkW30OHEcG5CG8FHsT3cSy04D95Bih5+cLkN5g==
X-Google-Smtp-Source: AA6agR7WXe0PWfc39N6UpvpYHu32jxaWcRJJG1j4FYXEWbqmNIfVQhpiksNqua1pirBB/TuEltpR/QT/TSOvKkyuCRQ=
X-Received: by 2002:a05:6402:13c6:b0:446:1c68:915b with SMTP id
 a6-20020a05640213c600b004461c68915bmr7795778edx.208.1660983019184; Sat, 20
 Aug 2022 01:10:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220819153710.430046927@linuxfoundation.org>
In-Reply-To: <20220819153710.430046927@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 20 Aug 2022 13:40:07 +0530
Message-ID: <CA+G9fYu783oU+cQA2akFBXMncE6UXO8B9rvNCt9Fg19GnHuADQ@mail.gmail.com>
Subject: Re: [PATCH 5.18 0/6] 5.18.19-rc1 review
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 19 Aug 2022 at 21:10, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> -------------------
> NOTE, this is the LAST 5.18.y stable release.  This tree will be
> end-of-life after this one.  Please move to 5.19.y at this point in time
> or let us know why that is not possible.
> -------------------
>
> This is the start of the stable review cycle for the 5.18.19 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 21 Aug 2022 15:36:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.19-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.18.19-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.18.y
* git commit: f06dacf3d236cd8b16b2a869572c0e849f2aa156
* git describe: v5.18.18-7-gf06dacf3d236
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.18.y/build/v5.18.18-7-gf06dacf3d236

## No test Regressions (compared to v5.18.18)

## No metric Regressions (compared to v5.18.18)

## No test Fixes (compared to v5.18.18)

## No metric Fixes (compared to v5.18.18)

## Test result summary
total: 138885, pass: 123740, fail: 932, skip: 13421, xfail: 792

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 313 total, 310 passed, 3 failed
* arm64: 76 total, 74 passed, 2 failed
* i386: 64 total, 58 passed, 6 failed
* mips: 50 total, 47 passed, 3 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 65 total, 56 passed, 9 failed
* riscv: 32 total, 27 passed, 5 failed
* s390: 23 total, 20 passed, 3 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x86_64: 69 total, 67 passed, 2 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kunit
* kvm-unit-tests
* libgpiod
* libgpiod[
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
