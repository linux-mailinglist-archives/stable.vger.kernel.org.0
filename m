Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB7895BB964
	for <lists+stable@lfdr.de>; Sat, 17 Sep 2022 18:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbiIQQeE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Sep 2022 12:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiIQQeD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Sep 2022 12:34:03 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 406642EF0A
        for <stable@vger.kernel.org>; Sat, 17 Sep 2022 09:34:02 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id b35so35639095edf.0
        for <stable@vger.kernel.org>; Sat, 17 Sep 2022 09:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=DDjDYWUo+H8UkWS6kECzl5VFx/Jdb4p8OsAYdr8mez8=;
        b=Zw4VYvDjVEPeBIQYxXPzslQI9LMjS6wh4RbnzwyewiSQ106YS7fHxJjtwKvwWSWFkw
         xmVNITq0cfVDWeb92PsW6MT18mkGAMpv7ogQMwdcxlsjp6FmyMo6iqe8utJCONVrL649
         gf+NANYedyW6OZFGDGr/zmlGMvZmhfZsbEDp1brmrP1BUVOZwAQRBulWCyEo49AK0vLq
         Djb723bKUrMUs+h+251XGqJW38Y6svRKLNP+5eiICVT+EKGxpCeXZf5a/ZgKjCgsTmcD
         EK3RTmdkmfDGpE1O4o7a7KCSa+TdvUl0HrzbjHh7X2Pxe8dWDyB0tulO9OWg3XVRCRWq
         dyAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=DDjDYWUo+H8UkWS6kECzl5VFx/Jdb4p8OsAYdr8mez8=;
        b=uPx7XdVo9N0qw4SGQEe8FVm4V/Cqg0IiEUvEagBq2jfE4Oh5Agu9mTY5Y07Vjr1jSy
         9Uu3VNsBUYqswn2YVu689hteDidSCdakawxUdiLeiGIu2fQFW31isssiBHMOlohIl/DB
         NhohxUX/qsqIF7d/DxEV+FiPzQ163RQJ6lc6PY5rMPs6/aBKYFXtM+BHZbGoysMic/fq
         d6vUx2d//lBzn15zugbMzVSN2Z9GyW46rsbajVHq4lgzWJIUP5IqAOLW3ww7uSttMS9M
         y00051W26HH5w6ugfOCAefRit6Nf+d1HiErCBvLbBxg2Ufeu6nGhMsoEdc+Dte9KzZuN
         4tPw==
X-Gm-Message-State: ACrzQf3bm/CxVUced/NCjv6koYjNj8/xvly9Yn8FiWTIHfUV7V8+oHBx
        COw56RD4A+iAfDsEpdbIPdW4RJpFb2AbAwuOOBk7pg==
X-Google-Smtp-Source: AMsMyM7+WOBaPtHyuIynIVQbJ6VZwpWRyqjshLiOE8oQK6lLWXKL/Impu7NQH/F3zCzJYTZimNPtlGfmCyXdIoi66Xg=
X-Received: by 2002:a05:6402:27cf:b0:451:6ccc:4ea0 with SMTP id
 c15-20020a05640227cf00b004516ccc4ea0mr8484673ede.193.1663432440665; Sat, 17
 Sep 2022 09:34:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220916100441.528608977@linuxfoundation.org>
In-Reply-To: <20220916100441.528608977@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 17 Sep 2022 22:03:49 +0530
Message-ID: <CA+G9fYtBqn9Rn0BdZDSgxLkMKEpr4qzb=QsD+61hrHjgXLMOWg@mail.gmail.com>
Subject: Re: [PATCH 4.14 0/7] 4.14.294-rc1 review
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
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 16 Sept 2022 at 15:37, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.294 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 18 Sep 2022 10:04:31 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.294-rc1.gz
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
* kernel: 4.14.294-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 05d41a0803cbf701df67dca7066c95bb32fe1365
* git describe: v4.14.293-8-g05d41a0803cb
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14.293-8-g05d41a0803cb

## No test Regressions (compared to v4.14.293)

## No metric Regressions (compared to v4.14.293)

## No test Fixes (compared to v4.14.293)

## No metric Fixes (compared to v4.14.293)


## Test result summary
total: 78664, pass: 68582, fail: 669, skip: 9208, xfail: 205

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
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
