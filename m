Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0265A583BC0
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 12:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235355AbiG1KGl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 06:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235129AbiG1KGk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 06:06:40 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55F1252DD3
        for <stable@vger.kernel.org>; Thu, 28 Jul 2022 03:06:39 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id j22so2328745ejs.2
        for <stable@vger.kernel.org>; Thu, 28 Jul 2022 03:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=43xfXpQViOqdLt5x8CjZrJCwOOiRmL1VaH4gAPbLUeA=;
        b=FBq8LmQr5tVRTbYfa9f/20bcMP/596IuK1s8yzievk+I8psalxhNCE9Aw0b9GOJGdo
         FHs1KufuQWJBcDLyRjyocOvrC4gofVmln5SQ2xMOLEXmDvzFdKXAwEy8qsdAykI0ls1a
         wWorvhgpx0PnP+SiHErG1QLJ5InXaSB7prVmIBEcj5HkPQTaw5EIYs9j2bpVcSDQEywf
         Dm+mQ50ZkIn/BTV98GSxOof/+vtgajSUrTatSG43V3MfMOP8sOlnkiym0L/hpyU/p0ky
         DYqmGxsWft+Y1ELG+drBGtIEwQyv4yXj+UO8q+Qd2sukTvF04RUA3/C7sNr/SFcp3PFs
         hdjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=43xfXpQViOqdLt5x8CjZrJCwOOiRmL1VaH4gAPbLUeA=;
        b=JApqVC705dMWlZD85Hy/bm199MDr4DS5SIH32wnRmQwDed6/FrcAZSkFlii3FzMP+T
         qdXzVPookYUN9rCNDagb3GS+1pe0VXikGFBmqOYltLQK+ht/XzaKCdaYwPOUjDOze/e3
         2ok2uamz4/rDCCnl9yRNHc30kyhKKENis7iA+Qlg6n3Mx9J31Ki7mv59hK8vtwwPMixH
         LNHxQN6AR/gzseETCWWXLQaV+kKFIEehq9PWOKc3Ox1HAvlwicjwBRTNPx1ssX6EGGOX
         lK8+sHmFUfxeRvAe3AxPY0O6s90C9/HIMVmP2sreIY2179gI/5mudJLzxnr3jdT4IYrh
         bJpQ==
X-Gm-Message-State: AJIora9t5DwgDsbMGfY6yaxeIa0ry+axRxxtD5ynoLeCKVDFq5eB0s4Q
        HY4Y2rjOmzbnDSC0JfzZV2/hOYmOC5qquzSMUPkxDQ==
X-Google-Smtp-Source: AGRyM1v7XRZ5iJPaSbE7alXsFVNxxAWotaRa+qCuu0y+HUszLXMLm9rmtFItx9b89IPTJS+RuBuQAmTX0ClhMsoQu6I=
X-Received: by 2002:a17:907:7604:b0:72b:4ad5:b21c with SMTP id
 jx4-20020a170907760400b0072b4ad5b21cmr19752738ejc.412.1659002797647; Thu, 28
 Jul 2022 03:06:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220727161000.822869853@linuxfoundation.org>
In-Reply-To: <20220727161000.822869853@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 28 Jul 2022 15:36:26 +0530
Message-ID: <CA+G9fYuyeR8rGWuz260S0+zpHMFrQqBmQdTYKRyJUs_JTQW9Ng@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/37] 4.14.290-rc1 review
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

On Wed, 27 Jul 2022 at 21:53, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.290 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 29 Jul 2022 16:09:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.290-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.290-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 7df53ec6e7ae929b9bbdd245504a491e962d6631
* git describe: v4.14.289-38-g7df53ec6e7ae
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.289-38-g7df53ec6e7ae

## Test Regressions (compared to v4.14.289)
No test regressions found.

## Metric Regressions (compared to v4.14.289)
No metric regressions found.

## Test Fixes (compared to v4.14.289)
No test fixes found.

## Metric Fixes (compared to v4.14.289)
No metric fixes found.

## Test result summary
total: 88981, pass: 78369, fail: 158, skip: 9183, xfail: 1271

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 286 total, 281 passed, 5 failed
* arm64: 50 total, 47 passed, 3 failed
* i386: 26 total, 25 passed, 1 failed
* mips: 30 total, 30 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 16 total, 16 passed, 0 failed
* s390: 12 total, 9 passed, 3 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 48 total, 47 passed, 1 failed

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
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
