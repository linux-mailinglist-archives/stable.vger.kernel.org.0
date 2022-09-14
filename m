Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 334FA5B8860
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 14:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbiINMiF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 08:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiINMht (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 08:37:49 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 143F4248DA
        for <stable@vger.kernel.org>; Wed, 14 Sep 2022 05:37:48 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id r18so34371655eja.11
        for <stable@vger.kernel.org>; Wed, 14 Sep 2022 05:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=4vhXZxa/4U8THtr7Gu92trHCX/TXLqdoSgOR1ukBIXI=;
        b=b5EAzMwvysidgQRkjaUX6jgksQ/dr0GYJYaRoXEY96iQN8BpsecBCeKfhQL8JQ2IVM
         WNEouKq+qJxPsUwzbw7MFlFnY5mFpYJtEbHQb3asA1KiaNZvHZUYxQWJRiW2MVdMW0qH
         eniPlDCRdW/c2fUZzIOYEndU4imfKQJjlN4qM2rZ9QHtlWra+OpkZJeRv2r7dUlrGjnj
         aH9vHiAtWjJAIPiCWah4GOEKwlcPv7sKE6Mwn6r21bmBI+rT7GPJX8xf5q3Z6iymNyCa
         6LYzlArKVSCCYq71uWm3pKF+LvzqmjsVhXZnUJ/KzY6wr7FstbHxR2pet5KiAeivTxG4
         OvTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=4vhXZxa/4U8THtr7Gu92trHCX/TXLqdoSgOR1ukBIXI=;
        b=XmT7a8GgpXsXMJslv2a5f+AgaDQOiuG4r6s9QYEiWZS2R1mc8bnBY3YCWn75Cn5xom
         ctbJxXR9ZQzKaW2Y/aPO/0X+WgldzUzJFUulnrEuXxw5dmLAK+L3kf4qqg3hs+jeARx1
         hl4EqkZLRFwbejXqY8vvuncuPFG1M7PYJwnZ0J8QAZfCsKmvt9426PadDoXoMvP/+gaD
         oYeCElbvU3bRRN8YJI6S7+xT2HrgS8urA7uHKGY57ZS6EiPku9/NIme/6boqVXlE9urA
         5FWrD0IfsAZJ6ihewEW/jVXvPQqiRrjo6db41fWb3mcno7kD4yrQ8M7T8k4qqiaTNnL2
         oq4w==
X-Gm-Message-State: ACgBeo0yMUMizvXPNJQepRDZultZlWFSWfAAPX8vYOHBLj0ZjlJYmFRY
        UAz33iETfYnj3cIUlCmR84c22c7xezWsBiDd0NbUkg==
X-Google-Smtp-Source: AA6agR4+lMQL0bBfP7UTjFi/ZEO2RPk4PohVP1+d8cKZIrP3EyA6ozgX7oFwjHMZ5zu6fyG7HLu3r0XdTsBo0V3X5Mw=
X-Received: by 2002:a17:906:da86:b0:740:7120:c6e6 with SMTP id
 xh6-20020a170906da8600b007407120c6e6mr25519522ejb.44.1663159066474; Wed, 14
 Sep 2022 05:37:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220913140346.422813036@linuxfoundation.org>
In-Reply-To: <20220913140346.422813036@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 14 Sep 2022 18:07:35 +0530
Message-ID: <CA+G9fYtVpr+yP-FEw-io_Lvb5XYr0JfLdeVbmeiqVnrzYGKY+g@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/61] 4.14.293-rc1 review
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

On Tue, 13 Sept 2022 at 20:04, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.293 release.
> There are 61 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 15 Sep 2022 14:03:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.293-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.293-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 20f32db14e38e76b2820affe8a16ca9f48c7933d
* git describe: v4.14.292-62-g20f32db14e38
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14.292-62-g20f32db14e38

## No test Regressions (compared to v4.14.292)

## No metric Regressions (compared to v4.14.292)

## No test Fixes (compared to v4.14.292)

## No metric Fixes (compared to v4.14.292)

## Test result summary
total: 65342, pass: 57030, fail: 537, skip: 7392, xfail: 383

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 313 total, 308 passed, 5 failed
* arm64: 53 total, 50 passed, 3 failed
* i386: 29 total, 28 passed, 1 failed
* mips: 41 total, 41 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 20 total, 19 passed, 1 failed
* s390: 15 total, 11 passed, 4 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 51 total, 50 passed, 1 failed

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
