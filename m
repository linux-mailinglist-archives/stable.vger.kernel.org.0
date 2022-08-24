Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87CDF5A028B
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 22:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbiHXUN3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 16:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240155AbiHXUN2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 16:13:28 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BFF67C526
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 13:13:23 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id h22so25373485ejk.4
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 13:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=HgbqYZOjkQz+AVbkvY9xpQJX7wcETZRoC2bMvANI6uE=;
        b=ukFtpbOmBQulkO1xqsJXiSJmElXO89VlR2jsvOIKyOQ9KMcXV60uHy+QYWtqrkghLz
         gcs6NwPdiEQX2IprWNpFORcj+L6wxNfO4cdowf/d08oWnthL9JL4s72D4C0/UDisy2ve
         Ob70c9z8JjEGbLxUkiiW2fd5ljmnNAFJ81ILDyCDZvcduSfLpM5CvDb4H6yvfaZl+Xfo
         emI3o70UJATAcV0ZyoBwI2CTqB8ykUfCbpGXz3mFqL35Q9X5h4EKhY9ruaYJ6Q0/AVOb
         Q4tFEwDoN3rwfNFdbfJQuJrnkNk6l/dFe1/jnketvxk2hiUXk2jURcxtDCJmHERUfKRx
         xq3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=HgbqYZOjkQz+AVbkvY9xpQJX7wcETZRoC2bMvANI6uE=;
        b=eJaru5gQ26nJFZmEebI3pQORtPRSCLvjycHA5aEQkrX+sq386orCY3ReRlqxkJmgu2
         phoi3+DhbifEIYkq8mljgs856Xjkw6Qv3Xklkq7eOMnsCJvZ2D3Dpgquu2lIeNx6s/hf
         n+UAYLTJkO/p9EzO/04Yl9F+mDgk30EgN3FbZumQproMbEpN4s+OnFaUGsmeb6GikHWk
         i8dl81GhIufl6NatB7X3ws27/8GIRkkQLVgdFWkWM3jLk7vvHcYHGuh5g+/g0NemL1nv
         wWQgNWm1wwW8lv35sOGBD+purlWxTmpEeSoaur4WoA+08qxXTK/T66PwMyBvgURUbJuH
         7LrQ==
X-Gm-Message-State: ACgBeo0rVkp06UyHM60Ki6OMOfPwhKvTIA2vUAPo3U/dYvySlhLt5Vdv
        Exwo8YOcESNogWer69YdTiB6wI3elj/7mRmVbPMIVQ==
X-Google-Smtp-Source: AA6agR6e2GaA0iz7+Ch1T3xwmrYaZc//8OIuVBCRLQaTRoyiP6K8lvqDC9J0s37qGPahDxwhMlCqh42FkG2OjfBn3C8=
X-Received: by 2002:a17:906:9bea:b0:73d:cd17:7528 with SMTP id
 de42-20020a1709069bea00b0073dcd177528mr198282ejc.412.1661372001129; Wed, 24
 Aug 2022 13:13:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220824065936.861377531@linuxfoundation.org>
In-Reply-To: <20220824065936.861377531@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 25 Aug 2022 01:43:09 +0530
Message-ID: <CA+G9fYuTOvKfHz7t0GppiNqLx-9n-yycsLX-rdMQogrh9guX_w@mail.gmail.com>
Subject: Re: [PATCH 5.19 000/362] 5.19.4-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Nathan Chancellor <nathan@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 24 Aug 2022 at 12:31, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.19.4 release.
> There are 362 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 26 Aug 2022 06:58:34 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.4-rc2.gz
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

NOTE:
x86_64 and arm64 clang nightly allmodconfig build failed.
sound/soc/atmel/mchp-spdiftx.c:508:20: error: implicit truncation from
'int' to bit-field changes value from 1 to -1
[-Werror,-Wbitfield-constant-conversion]
dev->gclk_enabled = 1;
                  ^ ~
1 error generated.

clang-14-allmodconfig build pass on x86_64 and arm64.
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.19.y/build/v5.19.3-363-gafd9d04cfdb9/testrun/11542345/suite/build/test/clang-14-allmodconfig/history/

clang-nightly-allmodconfig build pass on x86_64 and arm64.
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.19.y/build/v5.19.3-363-gafd9d04cfdb9/testrun/11542345/suite/build/test/clang-nightly-allmodconfig/history/

## Build
* kernel: 5.19.4-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.19.y
* git commit: afd9d04cfdb9cff1b69e2ff10272ced56c641036
* git describe: v5.19.3-363-gafd9d04cfdb9
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.19.y/build/v5.19.3-363-gafd9d04cfdb9

## Test regressions (compared to v5.19.3)
* arm64, build
  - clang-nightly-allmodconfig

* x86_64, build
  - clang-nightly-allmodconfig
  - https://builds.tuxbuild.com/2DntPWhfYK6ESM6Il3l6aIvKqes/

* riscv, build
  - clang-nightly-allmodconfig
  - clang-nightly-defconfig
  - clang-nightly-tinyconfig
  - https://builds.tuxbuild.com/2DntPYts34sHJI5VZuK5zKzkXr1/

## No metric Regressions (compared to v5.19.3)

## No test Fixes (compared to v5.19.3)

## No metric Fixes (compared to v5.19.3)

## Test result summary
total: 106629, pass: 95920, fail: 1031, skip: 9541, xfail: 137

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 306 total, 303 passed, 3 failed
* arm64: 68 total, 65 passed, 3 failed
* i386: 57 total, 51 passed, 6 failed
* mips: 50 total, 47 passed, 3 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 65 total, 56 passed, 9 failed
* riscv: 32 total, 24 passed, 8 failed
* s390: 22 total, 20 passed, 2 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x86_64: 61 total, 58 passed, 3 failed

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
