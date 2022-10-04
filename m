Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E20875F3EFD
	for <lists+stable@lfdr.de>; Tue,  4 Oct 2022 10:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbiJDI7W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Oct 2022 04:59:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbiJDI7O (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Oct 2022 04:59:14 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8563B46225
        for <stable@vger.kernel.org>; Tue,  4 Oct 2022 01:59:12 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id f1so9910757ejw.7
        for <stable@vger.kernel.org>; Tue, 04 Oct 2022 01:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=iG0zlM7aW1gOo1SQMFsTTxTlLmPagwqXgMLfYfdkB0o=;
        b=fMzClhTEwND1wuApImHzh8PZQUy/+oh9pt3x550vVZze2LMNEZVw6QZAGBt8vjMX8F
         P7JbLtGJnUreomcTFUg7pujs46lAhhNgajKXsNH9eKJ3EOyViBnFNBL69zWTTtS6Cc8D
         IaMtMXxtRWlOddCK7bhymLPshGmY4PxHQzUv3Z0bppUK5DP/tIg6PcQWirC/x9cDtnFm
         dUvGxjDqDh1Rn916QekBhuPFKqUEls3PjXzrqHuVt5jcYZJhhHlVSWTCBfMFPYjSEleS
         v5uZlBZBCy2lRxDqPb+yIXlFSJ+52FDPlPL/YNRnP91uF8MYoxjReZqSA2dEfM6qm2Il
         7f+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=iG0zlM7aW1gOo1SQMFsTTxTlLmPagwqXgMLfYfdkB0o=;
        b=Lb/btbeRA/7i8zndluKsPOKbtd+qxm19sWUhoBn2Oiaw18zlR72v9GSafAVGIdW1Cw
         /HU5jTNuds/LgG5lghECranqS/yPMRhRatmo03jW+pX2x8EOvypKPdY3d32Z+1ILevsY
         YFzSzl9tQkGC0nD7Yc9gfdtnmSMC8ufia2XxyTQ9i3vfAbyGwBA2KNXlU1JCg9nVTXzl
         yNs91bhVSAYC+aR0JCf9lVz5jkvSg2JYMBIihbHIESIaxX6U/CPTzusbTwMMwllQ1DUr
         hX9Vykw/5IVwtbYJInYr1zYfJBtctb4nEg/PSrynK99nmKM3Pv7H2xdOA4f1J6prKR1p
         FnSQ==
X-Gm-Message-State: ACrzQf1y3AgDpKTbTMES8i2D8p65uNVmxY9EWp7iI8EDRjLbfwfbfzQz
        ihyzbgIHbH/NhRKigQnxK5BasSzENj9CSnBI61p0IQ==
X-Google-Smtp-Source: AMsMyM7qja4wEcr67clX+6IFbKpa0vfERMBNObv+dQ93XJbI7yBr+JTD+FEnv/p8MYpoQJ3X02Sx8E+RuimevA/jHj0=
X-Received: by 2002:a17:906:da86:b0:740:7120:c6e6 with SMTP id
 xh6-20020a170906da8600b007407120c6e6mr18136380ejb.44.1664873950735; Tue, 04
 Oct 2022 01:59:10 -0700 (PDT)
MIME-Version: 1.0
References: <20221003070715.406550966@linuxfoundation.org>
In-Reply-To: <20221003070715.406550966@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 4 Oct 2022 14:28:59 +0530
Message-ID: <CA+G9fYvx4AgyzRxG9XuLC2Zq17Bia3TJvm-7sB_+ia0T+56-Dg@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/25] 4.19.261-rc1 review
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
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 3 Oct 2022 at 12:55, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.261 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 05 Oct 2022 07:07:06 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.261-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.19.261-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: 22f1795c5b7e877ba2a4c701f802752ae685a164
* git describe: v4.19.260-26-g22f1795c5b7e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19.260-26-g22f1795c5b7e

## No Test Regressions (compared to v4.19.260)

## No Metric Regressions (compared to v4.19.260)

## No Test Fixes (compared to v4.19.260)

## No Metric Fixes (compared to v4.19.260)

## Test result summary
total: 91802, pass: 79419, fail: 761, skip: 11184, xfail: 438

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 322 total, 316 passed, 6 failed
* arm64: 61 total, 60 passed, 1 failed
* i386: 29 total, 28 passed, 1 failed
* mips: 46 total, 45 passed, 1 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 63 total, 57 passed, 6 failed
* s390: 15 total, 15 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 55 total, 54 passed, 1 failed

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
