Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D876A5F6DE3
	for <lists+stable@lfdr.de>; Thu,  6 Oct 2022 21:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbiJFTFm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Oct 2022 15:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232738AbiJFTD7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Oct 2022 15:03:59 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C1C101C8
        for <stable@vger.kernel.org>; Thu,  6 Oct 2022 12:03:02 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id x59so4151544ede.7
        for <stable@vger.kernel.org>; Thu, 06 Oct 2022 12:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=L4HFerM9Fp6en0oU9MHoqVEv3dK/9bv13dNE/Vzs2Nw=;
        b=hnFRMZCecA0/DdOE3N3vt5Tg04G7wJcDtSFXvn7CynJT0qJA7rWHA4mhN/IdgqZZI0
         FKx4Ooe9b/dzsvmPoAhiGGMHkqTLlMkJvKdd0hBlJmLnIn9P6wDB/mJT4VOvbBbknw/k
         pUm6S3MIJXApFac/eNitxbv38UPRFn/fAbHnUXtmWQJ1j+45PvLrFR4Rg9+1jQXXKpRc
         vNNAjOvtINdg1BjzohKbw65veISD1mnjwbzrj28fv4/rX+HioiutFtXTs/o9NIEh/QJ2
         3EJhS9wHe79+XlcLqhBhFjP4pH4Leoi31kbvz8ie1VAJeiXiQDb8tfRgAqvJ2vpVNcEp
         FPHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=L4HFerM9Fp6en0oU9MHoqVEv3dK/9bv13dNE/Vzs2Nw=;
        b=M5L/1tEk1FRWz/noCyWphObQHqn0Q6tDV13l+NrOvEGRE7J/4GVUMQ0xwAB810QnRc
         u49ltJ90CwXH/dNK66YedLoy5GdC0tOLEQDIBNMIbaMBWT6nqft2ptL71FDbS/94SKBM
         7RppVK6tc1ydLYpDqSzeWFNVWlQ/lFWjwCvYppuWTQFMrXcBWQ4mAOVBvjn2JeM+dwHf
         umQ5AXC4o5R2sZ0HSDrZYPUW6MNYXSUO7qMNPnKHmT8ENKp/32+JCByQhz8+zJMQmBep
         pBZKXyhAM2CgWkD+HXUuvl5HdcNLlXAKWpzWDal5UumvLT4CCW7lPtAqol5IzDVgrGDG
         f3sg==
X-Gm-Message-State: ACrzQf2U9UgEcsp++hOaS63SZOFnjsxEqDQBFA1qtPT5G2BXoNx6g6wY
        JkhXv2PN09B0LCrm/IGoTjAM3Yqu9kU80xQhJFAw0g==
X-Google-Smtp-Source: AMsMyM44Iobg6Noxy+SAyuWqHpJB3WjXv+l4qAWc0Z9Va82X4DIQn1eK4PLyJrlWXX6gGRxFL6zOpJEzJxy/nc4oRzo=
X-Received: by 2002:a05:6402:1555:b0:458:ed89:24e9 with SMTP id
 p21-20020a056402155500b00458ed8924e9mr1216787edx.55.1665082980642; Thu, 06
 Oct 2022 12:03:00 -0700 (PDT)
MIME-Version: 1.0
References: <20221005113210.255710920@linuxfoundation.org>
In-Reply-To: <20221005113210.255710920@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 7 Oct 2022 00:32:47 +0530
Message-ID: <CA+G9fYseK+Or9B5NPU1DP=FOa09Ko0ApdAs1DsHxm8hbqTcKJg@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/51] 5.4.217-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net,
        =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 5 Oct 2022 at 17:03, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.217 release.
> There are 51 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 07 Oct 2022 11:31:56 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.217-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
Daniel already reported build warnings on x86.

## Build
* kernel: 5.4.217-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: 6376bfa24632084363dcc5cd0cc8c5a1fdd4a721
* git describe: v5.4.215-83-g6376bfa24632
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.215-83-g6376bfa24632

## No Test Regressions (compared to v5.4.215-31-gd69f2dcfc489)

## No Metric Regressions (compared to v5.4.215-31-gd69f2dcfc489)

## No Test Fixes (compared to v5.4.215-31-gd69f2dcfc489)

## No Metric Fixes (compared to v5.4.215-31-gd69f2dcfc489)

## Test result summary
total: 95584, pass: 83145, fail: 750, skip: 11283, xfail: 406

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 329 total, 327 passed, 2 failed
* arm64: 60 total, 55 passed, 5 failed
* i386: 31 total, 29 passed, 2 failed
* mips: 56 total, 53 passed, 3 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 61 total, 57 passed, 4 failed
* riscv: 27 total, 26 passed, 1 failed
* s390: 15 total, 15 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 57 total, 55 passed, 2 failed

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
