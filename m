Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADCC5A0343
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 23:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240735AbiHXVXt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 17:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240783AbiHXVXm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 17:23:42 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4571E7B29A
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 14:23:41 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id u9so6961140ejy.5
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 14:23:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=A2kk3oH6ZgjIg5ImjgLbFi4dMOHdw3cz12ar0HLiZeg=;
        b=T21RsIJpp+xKHQiDQTQT8kcxtT8s6QLQZD57IplVHHHthyg33k2ZZAiVKAtlw5KOsP
         VNNIRl21l4a6j7JJDUsuNJ8ISVanjp0Cp7mcIw8wi+7+ORgoRmGmflaSB43NJVM8xJok
         gv/V3h5uBlgAV5XtRE937GW8kwM3JnXDEGjcKvka3vAdGjVnPs39PuN3J6c2qzS5fxAk
         j/rRU+kWP0xvzfKNrwImtvcDqmbrnlbiUlIEGUocPY7A2MVVFIVhaR2+hkaVt+MaQ1GT
         bv593Bkm7gWySsPV2oR5rx1K8Sq1JSmfvyO+uc5mcKRLdcKtgoyu2fIUkrmPCGJil/Nh
         /f4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=A2kk3oH6ZgjIg5ImjgLbFi4dMOHdw3cz12ar0HLiZeg=;
        b=fK8uNVPymtY3U8OmLo/JN5WckSQgHfhEbzXZ0SixjyKkfurRQ+3fbhsP3Ep5LPvXnE
         TCen7E+XNcexnIyTLkGEOQUFixRAnXEBFn0BTqrStfbBKPHGi+JUSo5hqlMwuyMV4q2C
         u7z51Rn7VYom7hOVIvKuVgrMcS3PgzQSu6HAwQJBvEA2DBoDB+ZcKtH7ZG/WkssqGnZy
         jdQokywFL2EBzqAO5yH8e96xwusDKmhF0x69vel4gUcQPrimtJOP2nYEmeqi8O/1Y429
         XTCFg+K+aBRUCk6tFNEQRhOrR8tFHtOey6NmweU8+g59xt1f0GtvFqaXrIohhfsEYDth
         FaVQ==
X-Gm-Message-State: ACgBeo0GvXKM3WIAi8Eq2HnnSgpG0tAf9E2k9H7/RoQfyJZkePx52i1o
        UcAvHBq4dNKMMQkFEynBOcazEO8CT+CXNEPmnHz3jA==
X-Google-Smtp-Source: AA6agR6P1TOV2lFPufHzX/Iwm2PdGXudt6c9ck6mBKv6BEX8oCWp7OXEffF23YqO1jU/CqzZmBRTzZK9xPM4jlkKBRE=
X-Received: by 2002:a17:907:e8c:b0:73d:8146:9aa1 with SMTP id
 ho12-20020a1709070e8c00b0073d81469aa1mr495505ejc.253.1661376219619; Wed, 24
 Aug 2022 14:23:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220824065856.174558929@linuxfoundation.org>
In-Reply-To: <20220824065856.174558929@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 25 Aug 2022 02:53:27 +0530
Message-ID: <CA+G9fYsBwosupoqi6qkpxSOQ7FYOiBz6jrN9Q5hjNQoX5DZZbg@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/157] 5.10.138-rc3 review
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 24 Aug 2022 at 12:31, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.138 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 26 Aug 2022 06:58:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.138-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
riscv clang nightly build failures also noticed on mainline.

## Build
* kernel: 5.10.138-rc3
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 6cf5e7f41f7878702ceba99c95ed66a8e4b825ac
* git describe: v5.10.137-158-g6cf5e7f41f78
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.137-158-g6cf5e7f41f78

## Test Regressions (compared to v5.10.137)

* riscv, build
  - clang-nightly-allnoconfig
  - clang-nightly-defconfig
  - clang-nightly-tinyconfig

## No metric Regressions (compared to v5.10.137)

## No test Fixes (compared to v5.10.137)

## No metric Fixes (compared to v5.10.137)

## Test result summary
total: 96180, pass: 86425, fail: 871, skip: 8788, xfail: 96

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 301 total, 301 passed, 0 failed
* arm64: 62 total, 60 passed, 2 failed
* i386: 52 total, 50 passed, 2 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 51 total, 51 passed, 0 failed
* riscv: 27 total, 24 passed, 3 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 55 total, 53 passed, 2 failed

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
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
