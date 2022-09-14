Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 005DA5B886B
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 14:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiINMkV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 08:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiINMkT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 08:40:19 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31FF74CDB
        for <stable@vger.kernel.org>; Wed, 14 Sep 2022 05:40:16 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id go34so34407316ejc.2
        for <stable@vger.kernel.org>; Wed, 14 Sep 2022 05:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=TPfAaBjr3N4ZA4fFsfhCiDDxW/9qZ7TPMaA5+wfPO98=;
        b=MH5oAZAsTiZP7UtJKkP76Pc0ayffX/wOdmQDfl8SoUI8+t1bGt+ggaY16JDvDG9RiI
         IiVoqY/U9K5HJ0NNK0/sG7J432I3CAd5CxNKSjfWNEN7vQYNQaU9IwsuMJwCsix2thdk
         bvT7B+5Xo/ETvXFLWXcr+0wuhXSCRM02wFkWKmZ0DZjDOgWn6avEAifer7i0tQ5TOJkJ
         V9fGz5oBv1sOSKkM/WK/9GnS1r0ckUKtRV/6mdI09Ql1iMA/ctNRikJuS0IgOo5cOcEH
         oKovng6FkvV9pbEJSfflGx7Ig5NtSU3Ofey1M39Pvw8PgONSfTDCoLI2GjQ1BYjEIdxo
         xGkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=TPfAaBjr3N4ZA4fFsfhCiDDxW/9qZ7TPMaA5+wfPO98=;
        b=C7RSG/EX0rS06jHZoRxYYkgj2w6jF5RK4qjL2JdA/wu6OIPo22kgupHXwmrEV8YwbX
         nvW+te2u/K6f6tMYKmUAbD9YPf/i74Txeuljy1craoH384N/OaNQJoCEvsn+yZAW+Bpj
         k9RSLANRIvh02H00gGkMjGbZt/rrDqfX1rrvdm4j23VRlq0J+jBxgp6UpQk+2DtksF8Y
         jwfj9XJAJIvqOFNwC0Q9+kd1EFx+W8totyC4ponBlH+wxZk2JwLvfJyWEX6/7GVpIYsy
         98UrpAAz/hvyY9NLjE3rTabZPikWacbm5uDRQa/0AzTOEGU6fsSLcPJZhiB5wPwBebXC
         /VGA==
X-Gm-Message-State: ACgBeo1vtyxkwRnjo9wB5clbM2SNOv3Uku+/c2AgDVMdnwrAB9Ew4+uo
        8PQSs9fQqsqJe8U0uOrTDWZzXd/jn5KsGravERodFQ==
X-Google-Smtp-Source: AA6agR64R/DK3oqoCvgUc8M8pWz2IqL2nRxSUSA/YbkVJ8ImSTDBxTU4qP59n9jZs2MHFrMwyt8rbwhLnDU8vj0hbyI=
X-Received: by 2002:a17:906:fe46:b0:73d:939a:ec99 with SMTP id
 wz6-20020a170906fe4600b0073d939aec99mr25693864ejb.169.1663159214813; Wed, 14
 Sep 2022 05:40:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220913140342.228397194@linuxfoundation.org>
In-Reply-To: <20220913140342.228397194@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 14 Sep 2022 18:10:03 +0530
Message-ID: <CA+G9fYsNB+xSQT7bmv03sam+8jstb5dg_=JE0TLPaD2XAUkacw@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/42] 4.9.328-rc1 review
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

On Tue, 13 Sept 2022 at 20:07, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.328 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 15 Sep 2022 14:03:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.328-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.9.328-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.9.y
* git commit: 1573700dfd1f3ba21b839c8189562e7670ecadf4
* git describe: v4.9.327-43-g1573700dfd1f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.327-43-g1573700dfd1f

## No test Regressions (compared to v4.9.327)

## No metric Regressions (compared to v4.9.327)

## No test Fixes (compared to v4.9.327)

## No metric Fixes (compared to v4.9.327)

## Test result summary
total: 51324, pass: 44556, fail: 464, skip: 5952, xfail: 352

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 282 total, 277 passed, 5 failed
* arm64: 53 total, 46 passed, 7 failed
* i386: 29 total, 28 passed, 1 failed
* mips: 41 total, 40 passed, 1 failed
* parisc: 12 total, 0 passed, 12 failed
* powerpc: 45 total, 19 passed, 26 failed
* s390: 15 total, 11 passed, 4 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 48 total, 47 passed, 1 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kunit
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
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* packetdrill
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
