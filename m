Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92AC85EBF95
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 12:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbiI0KUJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 06:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiI0KUH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 06:20:07 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6C1C97B1B
        for <stable@vger.kernel.org>; Tue, 27 Sep 2022 03:20:03 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 30so12536133edw.5
        for <stable@vger.kernel.org>; Tue, 27 Sep 2022 03:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=kg4wzP7dI4MPJJBqKBHwbPOCwSqMZKp1H54qferqwdo=;
        b=C+bCu7NlsojnDd8u7g7J3rBBZ/wDTCG87AtNjFqRk167LyvAF9oPm89e31O1aLGPgW
         O0QLVM1zQtmklPtlZOpQ6LlqPnwnYyDBFU82iOewwSL355zGu9kpS07Fj7n5YBEDYGsc
         45L2/zEzjfDPbd8tp8Lw1jStboTKbVZyBagDUgH3iA1Az5adU1G3dH8iqAInk/avSbYg
         rRqJSIc9RgyGClE1FCgX2+hrLEvi1ry8hK3ZdSqOuoXdp1BTkehws9iwOUci73gbL6d5
         +yp7TACjlsKncujUp1Ymi1U/QwxfKoXF5O10bdYr3q1Ct41r6uPkGEIB3rM7+vIIMY/P
         nszA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=kg4wzP7dI4MPJJBqKBHwbPOCwSqMZKp1H54qferqwdo=;
        b=cfhMn9UQrcx4KKT/+MhT7YXEfH3jsXdOILV50b4Va5mmr3j7mMBQDT2h+97JdYWpVl
         FsffyCq56L8GiKiJWoNr0Lf4VK7T4FfpZk4oey9zNG32n2a0jGNk2ww/0z8cyIyHqQjU
         FnhI5P7A8+UBm1zIu4PaaLeOMg6qEym9e5IA4fyaGwjgXihGwnQwVa84bdwBCBU+xrx7
         SXNkEpb/MJgZaAEyaY+oMQiYUriaVEzeft0cr3BjDAjPi/r4YqJKf34WfzxwHMO+J7ra
         UH+PlV5EREmF8ImjLmpjjH6IeJdM1nSUXioiMN7DFFZmmTv4mQlcadWSTWjKEIBwKz5L
         jCVQ==
X-Gm-Message-State: ACrzQf3ah36EU5DtFNk7vs9i2o2Cxg3GJXuEczKsQEsWF61FQJ/mjXK9
        MpjrjuF+fwDt/N5+bkRTqnfSf+FuIm2f07P4EmFh+Q==
X-Google-Smtp-Source: AMsMyM6m4BBIa1LbwbPWa0/OXhMnb5e10al3HpegCgBMzIDmEpJ3z+SdxSpxeOnYBc0gKIZTiecG35utDPbyVWY2epQ=
X-Received: by 2002:a05:6402:2989:b0:44e:90d0:b9ff with SMTP id
 eq9-20020a056402298900b0044e90d0b9ffmr26708279edb.110.1664274001877; Tue, 27
 Sep 2022 03:20:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220926163533.310693334@linuxfoundation.org>
In-Reply-To: <20220926163533.310693334@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 27 Sep 2022 15:49:50 +0530
Message-ID: <CA+G9fYtKxzBcEdSDJkN-4=bPQDg9bd8sprwXigm+mLnWZmXF9Q@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/21] 4.9.330-rc2 review
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

On Mon, 26 Sept 2022 at 22:06, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.330 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 28 Sep 2022 16:35:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.330-rc2.gz
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
* kernel: 4.9.330-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.9.y
* git commit: f631754acd7bd6586aec88964a9882d05e5a604b
* git describe: v4.9.329-22-gf631754acd7b
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.329-22-gf631754acd7b

## No Test Regressions (compared to v4.9.329)

## No Metric Regressions (compared to v4.9.329)

## No Test Fixes (compared to v4.9.329)

## No Metric Fixes (compared to v4.9.329)

## Test result summary
total: 38356, pass: 33768, fail: 305, skip: 3945, xfail: 338

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

--
Linaro LKFT
https://lkft.linaro.org
