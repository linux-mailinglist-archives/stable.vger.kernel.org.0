Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 049EC5BB95B
	for <lists+stable@lfdr.de>; Sat, 17 Sep 2022 18:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbiIQQ2f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Sep 2022 12:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiIQQ2e (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Sep 2022 12:28:34 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B1E2DA83
        for <stable@vger.kernel.org>; Sat, 17 Sep 2022 09:28:33 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id bj12so55628384ejb.13
        for <stable@vger.kernel.org>; Sat, 17 Sep 2022 09:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=kGPtTbWnqzfzSMv1jEwmY9ZgCYSsz4cFmet6Dy+GISk=;
        b=XLwkf8IQKFqTI0Wy3o1v3gYZOdyKLq6F9jBv5Yg+BEpjzq/PSVr41gN36ixALKXAcc
         w5LSqksnWn/7zWPu2bPmQJYs5WCsbFR0nAVKsTY0iBTIkgPoWdOusVLH6UbJwRsH7TCn
         Ec9Fn4YaXu4p37nFlER7KLdH43Dogh14cpe/jfKaE+jkXaKUoFKkHZRJSWetyC11a5E0
         Xrw9vtIp2aAXLqHxnYz7HEfGq9BFP8IW4Rs7rd+aTv7c2rbOYUnj9yxVrKwm7VQUacZ9
         YyHAmayOk58eapO8lXXHrtM4E0ZGpvzQD98ECJe1WYGXKReEfa4wLYOTqUIHwuHF8v/x
         VQLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=kGPtTbWnqzfzSMv1jEwmY9ZgCYSsz4cFmet6Dy+GISk=;
        b=VEeHBBvVqvgKyEPh7GvPtJpBlDCqMzmTlj1qcY5lbFsZlL8zq62ix4oJoE0fczCwmp
         OMKUvmX5pTq0MO7TGh2XvKs4fqz5CRiT5fjAZR/H8zw4FukFbbulWK+OnxwbFx+zCZkr
         KFtuY4oh10HotxBVBMCLmiAD+nkJ8XiHykaU6J4LSIAJDfeAHpFlZJPuzFlS6j+l9ci7
         6twiKmYxlcTDKsljG6gxjVLo/0khPLFbH2yP6/V+JEz0D1n30xpAMR/SJx8XU7hyseBA
         TKaYQnQ0M1eTs5576HsBiqsO5OkLxn2faSY1ed3eSXnJWPshZtOBmvkhw01QLQonMyCr
         fcLg==
X-Gm-Message-State: ACrzQf2DdwY1GKgESeichiLj/jWRyPfLXUsSrAY5nwl8gTTaCxgLi5De
        FzNW1NxvXlbLbqa+TlfD+UasjKuDIpFfdAT9KTmPdw==
X-Google-Smtp-Source: AMsMyM5Nq2KuXnDUzzD/O8pvL3P9D3pnmsn9OHGtnGmnRyA5CscK8qAg+IEvQuturEHpOpkm5PtXgdMtYn5g2wP9Ks4=
X-Received: by 2002:a17:906:fe46:b0:73d:939a:ec99 with SMTP id
 wz6-20020a170906fe4600b0073d939aec99mr7149813ejb.169.1663432111772; Sat, 17
 Sep 2022 09:28:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220916100443.123226979@linuxfoundation.org>
In-Reply-To: <20220916100443.123226979@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 17 Sep 2022 21:58:19 +0530
Message-ID: <CA+G9fYv2LgxbubYXUYAjmdhzq-gmNexs3WBvdw4rYxdzu-c8Pg@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/14] 5.4.214-rc1 review
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

On Fri, 16 Sept 2022 at 15:39, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.214 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 18 Sep 2022 10:04:31 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.214-rc1.gz
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

## Build
* kernel: 5.4.214-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: ba0de553122f5be5dde3102746a1060fd2737e63
* git describe: v5.4.213-15-gba0de553122f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.213-15-gba0de553122f

## No test Regressions (compared to v5.4.213)

## No metric Regressions (compared to v5.4.213)

## No test Fixes (compared to v5.4.213)

## No metric Fixes (compared to v5.4.213)

## Test result summary
total: 95829, pass: 83292, fail: 734, skip: 11384, xfail: 419

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 334 total, 334 passed, 0 failed
* arm64: 64 total, 59 passed, 5 failed
* i386: 31 total, 29 passed, 2 failed
* mips: 56 total, 56 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 63 total, 63 passed, 0 failed
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
