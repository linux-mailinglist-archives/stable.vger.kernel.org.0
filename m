Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F19CA5EBDE9
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 10:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbiI0I7b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 04:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbiI0I7W (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 04:59:22 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19481A2205
        for <stable@vger.kernel.org>; Tue, 27 Sep 2022 01:59:20 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 30so12271944edw.5
        for <stable@vger.kernel.org>; Tue, 27 Sep 2022 01:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=6rS0/ChZuqVBYTELA3WptGZlwUxaalQ08AWo3cS66tw=;
        b=kzLb7hk2+2vOwXDeLEo2waKWNiTBrEgBXeS96zG23jlrgUDJVUbMWP6Wp5n4uaKSMO
         1PG/DslP6Ujnnvq8DR3IsN3+LlWe9pz9Ct1vOwZ7JwRheOdzjvzGopmF57lToHwzcZxx
         KgJuSpqRI1dLye0BCOp65TLBdszwt2VABawM7A8m9YI4Fp6eQlAqgvF683LLx117uGys
         C3ellgbDpovANX6KmllsGV6g89DubxxQoh+PbGK65xO+A8xfG5FGKSXlM2RpCM1KZd0v
         b47NMbOPGNzhrm5lXy5yE28zwPQQWyjws1O/RwfkniXQPt18RWdSwZh2kZfGbTeJAMGU
         V/Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=6rS0/ChZuqVBYTELA3WptGZlwUxaalQ08AWo3cS66tw=;
        b=FL6uMOIcXuuICedc2IyxMLB05CI8/91gbdfNtkcAZDSKo0woz+S5B4hfuaRmErve4e
         +VxrXEJeOkv9cHvjN/Lg2FyiDUOjO6JsfCzX5i2/ROxROvXUfMnE0DWkkc8RpVhUyTt3
         0MMAiZh2Db7QeXWr/VPwMINIeylkoQPIFW9fHq48Rr90SWkGREQh/no8FluTqThbIEfQ
         1zPzH4Gqa0lnxyVQlTTlCmnkB5xo7f+vLT81Rd2qKBbMCR6xy8J/fsTXkII6Q68u8QSP
         XRd1/rEws/hHhF9a0M7YkZ0yHGUyTNHeEdnnTYmcgyIvR75fRuwzxEdF0oqeDEc2h3jB
         K/5A==
X-Gm-Message-State: ACrzQf2DJS6Hd1Ei0Ri/d4pMo9zROYuybr8lbSCUSz9tcFMxEz6ShJmA
        8clcyAxZAO9R2QrZx1je5xJtZqwteLiRzRtTogw2sg==
X-Google-Smtp-Source: AMsMyM5qBK8hMo8IsjYOiCeMJ/9MecGYPq8OjEjpXwR+gKT89c2vHGwckrWENTSXy3+ipluQogkPUEspLLV8mhRNAOE=
X-Received: by 2002:a05:6402:27cf:b0:451:6ccc:4ea0 with SMTP id
 c15-20020a05640227cf00b004516ccc4ea0mr26898277ede.193.1664269158448; Tue, 27
 Sep 2022 01:59:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220926163550.904900693@linuxfoundation.org>
In-Reply-To: <20220926163550.904900693@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 27 Sep 2022 14:29:06 +0530
Message-ID: <CA+G9fYu=ydivmC6Hv77NyHEPkR+c_rsUbycMCKBhtvLEM_k+Nw@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/138] 5.10.146-rc2 review
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

On Mon, 26 Sept 2022 at 22:07, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.146 release.
> There are 138 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 28 Sep 2022 16:35:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.146-rc2.gz
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

Following new build warning noticed on all the builds,
net/core/dev_ioctl.c: In function 'dev_ifconf':
net/core/dev_ioctl.c:41:6: warning: unused variable 'i' [-Wunused-variable]
   41 |  int i;
      |      ^

Due to patch,
net: socket: remove register_gifconf
[ Upstream commit b0e99d03778b2418aec20db99d97d19d25d198b6 ]

## Build
* kernel: 5.10.146-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 2b148b97fcdfb026b1536a9c78b013e28c5f0689
* git describe: v5.10.145-139-g2b148b97fcdf
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.145-139-g2b148b97fcdf

## Test Regressions (compared to v5.10.145)

## Metric Regressions (compared to v5.10.145)

## Test Fixes (compared to v5.10.145)

## Metric Fixes (compared to v5.10.145)

## Test result summary
total: 95427, pass: 84769, fail: 681, skip: 9693, xfail: 284

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 333 total, 333 passed, 0 failed
* arm64: 65 total, 63 passed, 2 failed
* i386: 55 total, 53 passed, 2 failed
* mips: 56 total, 56 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 60 total, 55 passed, 5 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 23 total, 23 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 58 total, 56 passed, 2 failed

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
