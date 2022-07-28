Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF529583B78
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 11:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235016AbiG1Jp1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 05:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234673AbiG1Jp0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 05:45:26 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF5D1EAF6
        for <stable@vger.kernel.org>; Thu, 28 Jul 2022 02:45:25 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id i13so1448994edj.11
        for <stable@vger.kernel.org>; Thu, 28 Jul 2022 02:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0PGFqJ5sSwJz5+FanpjdC1l3+s9uEy4ZucSeUHVLRLA=;
        b=jFabNESMYWFqBWmSQ0Vwnofpi1D9/axdUDChv2uvnR9jHaM6K51+IeFWEV29R1PGMX
         kCqlMGjlTS1/dZd4+LYbt+wSsAqq2eHYUheT6qSdoIgYFVmbuBbpGtUkuo82kw7xuGaJ
         jZ7gl//WESp+4rRI0pfNEOkGkCbsl48ko3zAZTeZ90/l5JMwRk1bCSIIivBu/O87C32c
         6FAOLFBGXvooXiau/b0eg+omOzyWgfupNRDNrJFJQEGMVP1ZhsO8L8+v2qJ9q4h+W66G
         xVC8sCvaKurM74JcljdEWLEquiWfGm6pvbZTbOrdmsyJTz+Q/4Wmb9O6X+SrMm5rxDI9
         LjZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0PGFqJ5sSwJz5+FanpjdC1l3+s9uEy4ZucSeUHVLRLA=;
        b=VdohNfiTqksU5Emwf6IISasg5gsfmd+U1pDWZv+omgMnhC1DR84ZWL5LdT2V5eM3fI
         M2c+NSy2SnMB/nqiYpsp0UTcaXqWX6ZVItSnMSJDFKNrIWJJEDoM8OTjp5rihWQudmgL
         na64cSgJRrVpo88dkfKXEBdl/RIFaD+Gcqr3SCrkiSqySjCYwSrgjjwx8avNcZBO4lQH
         50fv9kV8kuYfqGW41iqPUD9r0Ktl7Uzhz2c2ajUiqmkHtQpsmdixPH3TIukdEB2WpPxd
         Qfq4M8hp0HO3tsZUaR9e613p7eTrp/3Diql42x8CPXjhJ44n3EvgYfKd9Tc68QS6FDGX
         PAkw==
X-Gm-Message-State: AJIora92QNOvx3Xcnm5jXYmhHKafKU8LGr/yw5ytNa+upzeXATPZfJn0
        +NUXx1vbF9W7TNqQD2TpR9ILTLOWgoQujVdOacbeKQ==
X-Google-Smtp-Source: AGRyM1s5b0erum6DedCypu3B9TEv5wCXsxyQt1uGtTfM2WDrh+EJTtUNUKLhJ79kGGmFoU+kIAuZRMxihUXEiYzGpaw=
X-Received: by 2002:a05:6402:2d5:b0:43b:d73d:39b0 with SMTP id
 b21-20020a05640202d500b0043bd73d39b0mr26844041edx.208.1659001523674; Thu, 28
 Jul 2022 02:45:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220727161004.175638564@linuxfoundation.org>
In-Reply-To: <20220727161004.175638564@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 28 Jul 2022 15:15:12 +0530
Message-ID: <CA+G9fYuW1YDzwJ=7EZ3XkAR4AYMo_9t04ghQfhkCR1=ynf63pQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/62] 4.19.254-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 27 Jul 2022 at 21:55, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.254 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 29 Jul 2022 16:09:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.254-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.19.254-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: f68ffa0f9e2ab245b3284831e972b55c677ce706
* git describe: v4.19.253-63-gf68ffa0f9e2a
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.253-63-gf68ffa0f9e2a

## Test Regressions (compared to v4.19.253)
No test regressions found.

## Metric Regressions (compared to v4.19.253)
No metric regressions found.

## Test Fixes (compared to v4.19.253)
No test fixes found.

## Metric Fixes (compared to v4.19.253)
No metric fixes found.

## Test result summary
total: 101463, pass: 89648, fail: 226, skip: 10464, xfail: 1125

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 291 total, 286 passed, 5 failed
* arm64: 58 total, 57 passed, 1 failed
* i386: 26 total, 25 passed, 1 failed
* mips: 35 total, 35 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 54 total, 54 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 52 total, 51 passed, 1 failed

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
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* packetdrill
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
