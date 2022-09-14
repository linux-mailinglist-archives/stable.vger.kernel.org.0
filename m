Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B24B45B86F4
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 13:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbiINLE6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 07:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbiINLEw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 07:04:52 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E993710FE0
        for <stable@vger.kernel.org>; Wed, 14 Sep 2022 04:04:49 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id u9so33898340ejy.5
        for <stable@vger.kernel.org>; Wed, 14 Sep 2022 04:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=BkGxRfmkfExHV2aUTPcC2G3xgPJhHhdFuff0nSQ2sO8=;
        b=raXhuHmQeTxI3aDkMv97ohycDh0eeQHKARc1hvSuIRCmh95Bu1Ph5GmBM3Lu5JHU1U
         9cwBCL06fLh9ekNU+JRGZ0meOEfoxUE6x7PI9pXNdKplvRvYcwQRh6NMqRCHfhBFWQ10
         efkhvF8RV0EPzsNoNJajRfHoPJZNRC0WrcXWQxgi8qp9n6vIbAggKjeRPUCiGzRyntAQ
         byEEg1Nd03uc43R+6loHIrqksjJ2EOZpoheFTBiKiLAZu0W4EE1HO0guiS4mj8GZUmIG
         P+ZmrZwZPqbwjjkK3KZSggj86rI8dlh+3cQf89DuHvIr2OQazD1FW4CbIoebNbYowxyR
         Esjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=BkGxRfmkfExHV2aUTPcC2G3xgPJhHhdFuff0nSQ2sO8=;
        b=tpaQTdVUZK6oUDNiKlF2cZz84k7W1J3yYOM6kT3lO7gW5Zj8tGg+RBMblp/Q9XlpSh
         eset+hMh9ajxToOs6bdeg1MB3DbZyQvgZh9lJLzmbYRpSRH7tXJlw6n0TykeXIAV571G
         A5+hJ0UXCqCUlSOc0iAutScKOvVeQHbr8OlM6wpv9A9LexYga4lVW8P0ccC5pJXiFVcD
         cjFZE/kk+iBcHhehQoZlzssqMXMrfmIHTpgPsXrTJ+w00YYfgSRt0GKcBFLYaaQjITwj
         L943gO25mPHm9fQrvR8+RYs1+yoWdCw0c5huo5jhQjLT8GM+lxawaceZbwhLtyzcztA4
         wsjQ==
X-Gm-Message-State: ACgBeo17Wx4LT+kX2vV1VTMS3snETDsQxmcyM4tujpCT9Ym25j1hiXJK
        22/nAWVXbjgMSyaiJFYl1LMpCIgoJCIeQo7SHrhgRg==
X-Google-Smtp-Source: AA6agR4nhfIDLJlZrUEPfOkhtbggnGTzI+uI6k14+XG/bKpGXG4GssitGlu3JpdjuaWvWVzAbgf8kqmbdkB/nNFG1do=
X-Received: by 2002:a17:907:3188:b0:741:4bf7:ec1a with SMTP id
 xe8-20020a170907318800b007414bf7ec1amr25811390ejb.448.1663153487670; Wed, 14
 Sep 2022 04:04:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220913140350.291927556@linuxfoundation.org>
In-Reply-To: <20220913140350.291927556@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 14 Sep 2022 16:34:35 +0530
Message-ID: <CA+G9fYsLqc_YwN0uYoSS8ktzDOojS1o8NG_hoswcnfk95pD1kA@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/79] 5.10.143-rc1 review
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 13 Sept 2022 at 19:52, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.143 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 15 Sep 2022 14:03:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.143-rc1.gz
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

## Build
* kernel: 5.10.143-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: c8d43c9a1242725c78f2bf5b0274413727673ac2
* git describe: v5.10.142-80-gc8d43c9a1242
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.142-80-gc8d43c9a1242

## No test Regressions (compared to v5.10.142)

## No metric Regressions (compared to v5.10.142)

## No test Fixes (compared to v5.10.142)

## No metric Fixes (compared to v5.10.142)

## Test result summary
total: 103035, pass: 90648, fail: 769, skip: 11310, xfail: 308

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 333 total, 333 passed, 0 failed
* arm64: 65 total, 63 passed, 2 failed
* i386: 55 total, 53 passed, 2 failed
* mips: 56 total, 56 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 60 total, 55 passed, 5 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 24 total, 24 passed, 0 failed
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
