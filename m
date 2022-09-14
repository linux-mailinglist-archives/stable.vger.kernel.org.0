Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3025B87CC
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 14:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbiINMIk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 08:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbiINMIf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 08:08:35 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 354847F272
        for <stable@vger.kernel.org>; Wed, 14 Sep 2022 05:08:33 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id z21so21911318edi.1
        for <stable@vger.kernel.org>; Wed, 14 Sep 2022 05:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=lZMFMwTKaDoN92TfUg4rhrK9/Vgy+4VnEfl6Q6soKkA=;
        b=Hn/YxHcMcexyeCivKAehCl5/+na2OclQbiYfbBroysxs+34y+JauV0gR66de50jf/c
         BG8n8xBxZ5rDZneFPm0vaT9F/oE++uMDLPL4JTlZ9goAhlCTw40ceZcM47ohFVSigADQ
         OGpS372DBJnPvMiKx+1RDCbkYBDxrIiBdWzaGZqk9DJLtgPTnf4NqLUIKLAT5CAAu0zA
         oZEbrSsKMMZwUdVwuQ23Tr4cXw7s90JBkBdbn7TWHPPtcAyRmBBeP07g78tuhhBjsr3E
         mPDUkmAFxAKZDNxgnr3lK0p8ja/r97OpgeBrMKhRfEPHtAdGzOqunLGLlEPUK7eR5dk1
         mWaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=lZMFMwTKaDoN92TfUg4rhrK9/Vgy+4VnEfl6Q6soKkA=;
        b=TVKG4Xg3LVZ8//6dRnU2P0fzrtvhImkd4mVbSSpd5RAHsc+E6oBZ9aIQG1zclTSqrq
         ALaJuPJqhDv2003W/UaUYBc9oZBN3gOx487dvi2fDr1nQFihQgAGYB0ifr8ChoF/pv3c
         zw2ju1EAM8yMxcUWjgg5DkokzAWK0NlUE9La17PDzZJ2Zpfi9JFoHVz4Q8K+kT8tyyiO
         LOGES97jiuX2cZiKPYZmy9mzISMJNt2euaLKkn2nuDn1cdwAY4ccLojIhNHWnFgNg1S9
         LKgK6af8aZ2ZgwOsZu4dPl4fnj/1LrpWtwF1ij5d1XqilwLoWZfgP8snkCqtgTX8gV25
         UxCQ==
X-Gm-Message-State: ACgBeo1xQT0YY1gJx+BM2nMlwhc5nY+DeMIQXrM1ikp1oaXm4Mt6FaR0
        3gwUqLJYc5B55XVhnkIyiOj4mJbarvx41xOikNYW2w==
X-Google-Smtp-Source: AA6agR7brk1D9/tNrUFcM5Rdp/wqUtemwORlPUUMyoFV+2N+hxIAfa6fGua/P1lEfG96DCX0AFasYZeR5McMSqAIixI=
X-Received: by 2002:aa7:cb87:0:b0:43b:e650:6036 with SMTP id
 r7-20020aa7cb87000000b0043be6506036mr30833799edt.350.1663157311552; Wed, 14
 Sep 2022 05:08:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220913140348.835121645@linuxfoundation.org>
In-Reply-To: <20220913140348.835121645@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 14 Sep 2022 17:38:20 +0530
Message-ID: <CA+G9fYu_SFbbkKThMQBob6cyGeYHdavxcO4uav0LsjWz_8OPAQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/79] 4.19.257-rc1 review
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

On Tue, 13 Sept 2022 at 20:01, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.257 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 15 Sep 2022 14:03:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.257-rc1.gz
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
* kernel: 4.19.257-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: fb5836fc4e4c065ff678b2ce8f3bb039506bbd9b
* git describe: v4.19.256-80-gfb5836fc4e4c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19.256-80-gfb5836fc4e4c

## No test Regressions (compared to v4.19.256)

## No metric Regressions (compared to v4.19.256)

## No test Fixes (compared to v4.19.256)

## No metric Fixes (compared to v4.19.256)

## Test result summary
total: 82375, pass: 71763, fail: 655, skip: 9554, xfail: 403

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 323 total, 318 passed, 5 failed
* arm64: 61 total, 60 passed, 1 failed
* i386: 29 total, 28 passed, 1 failed
* mips: 46 total, 46 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 63 total, 63 passed, 0 failed
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
