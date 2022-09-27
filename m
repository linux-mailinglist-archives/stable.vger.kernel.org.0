Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E00575EBD5C
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 10:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbiI0Idd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 04:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbiI0Idc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 04:33:32 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E232A8952
        for <stable@vger.kernel.org>; Tue, 27 Sep 2022 01:33:30 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id a41so12196119edf.4
        for <stable@vger.kernel.org>; Tue, 27 Sep 2022 01:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=VTXV7aT5R11yPSl13EAHJwJP2TKui3gFrJyt6UxcJIg=;
        b=Gi6/JYHJ0hnLxKiFkRwbLYS6VNogPTBrgAmNcIn0aTFtZ5ArPWCpLtzCB9HLVIc9AL
         5GlxlOcV2pUoAfqbZXRcPSjZgiUYh0inwUlkn+E1FyVhIHd0lGphlg3QJ38FSbALQVzQ
         Bxy2wOaD3WpeI9aEXGKgdSJ5WP5+nIi6UUN/Dtvkmsx5L6gexvQeAceWkGdvdA2bDcr2
         sdXYG5QmjJfERJ3jJA00b1bxmB5l10AN7nrKvFuO6myWftF4B0W5OZjaoKQRl3X3sPE3
         ECd7t9pnp+0DHMrjseL4nhlLfPFodz2QL5TIhXa39bUmXVuEiQP1WkD64wcvt5DorHkv
         8rjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=VTXV7aT5R11yPSl13EAHJwJP2TKui3gFrJyt6UxcJIg=;
        b=MbYnjNG4x1d7DO7BEM81uCBXgDM0si85xoHbt9rNdEWqTzKfh3wO/ur+XM0pjT9D2h
         cllaA9i/3cvHSbdgT2NdvPmAlySxz7mncDK29feslaTSFmBF2VR5lbwUrreC7emyg5VQ
         e0DcQcJkmhv/pJI1pbtVqQ/xVpNr1RzpBtI9hDYGeZNbhXuFjU5Lg67RJvynwSaroXfp
         MVjngizLVI0wvjXHiAwj3EhAXQGpLfIlXKT1trWEtkoCBhCyJkSdBKdEPT3KUGld4p1R
         S+Z89Qs06csEU/Ba2kYfGd/j5jYbQoKx0qAu7hGyvqA3CIJ+12DCSn+wQ6MPaFtq5p8J
         Brgw==
X-Gm-Message-State: ACrzQf330lQlmUZGmvbtv25bicWrbvTjd74Lh9T5fArlmVpfqWkmqTAt
        5nbkJ/U5Ocwk+V7Dpno1rXNI/mee8i9INAbSPiERBQ==
X-Google-Smtp-Source: AMsMyM6GGOfUNT9MJr+yLdS+k05XCxUHmRj3Qj3ApsCdkVhD5WehDKt+rRZGhTtu7Z6FtEyaykEgz4Xd1wStXh6G8AQ=
X-Received: by 2002:a05:6402:1298:b0:457:c38a:2f10 with SMTP id
 w24-20020a056402129800b00457c38a2f10mr768435edv.264.1664267608964; Tue, 27
 Sep 2022 01:33:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220926163551.791017156@linuxfoundation.org>
In-Reply-To: <20220926163551.791017156@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 27 Sep 2022 14:03:17 +0530
Message-ID: <CA+G9fYtYKN9jUe615NsTecTeAg-3EZDjWPa7N2c+oAd-Ze0rnA@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/143] 5.15.71-rc2 review
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
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 26 Sept 2022 at 22:07, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.71 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 28 Sep 2022 16:35:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.71-rc2.gz
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
* kernel: 5.15.71-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 0b09b5df445f9effa9457d604de74e4c3b6606e9
* git describe: v5.15.70-144-g0b09b5df445f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.70-144-g0b09b5df445f

## No test Regressions (compared to v5.15.70)

## No metric Regressions (compared to v5.15.70)

## No mest Fixes (compared to v5.15.70)

## No metric Fixes (compared to v5.15.70)

## Test result summary
total: 105358, pass: 93051, fail: 638, skip: 11351, xfail: 318

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 339 total, 336 passed, 3 failed
* arm64: 72 total, 70 passed, 2 failed
* i386: 60 total, 54 passed, 6 failed
* mips: 62 total, 59 passed, 3 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 69 total, 66 passed, 3 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 30 total, 27 passed, 3 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x86_64: 65 total, 63 passed, 2 failed

## Test suites summary
* fwts
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
