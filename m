Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97C8E5B876B
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 13:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbiINLn6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 07:43:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbiINLnz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 07:43:55 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66E157CB69
        for <stable@vger.kernel.org>; Wed, 14 Sep 2022 04:43:51 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id z21so21815120edi.1
        for <stable@vger.kernel.org>; Wed, 14 Sep 2022 04:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=dBoAabtEYZbE61p8ixZqhbfi6v1fC0mMtx/SBVgEc2M=;
        b=sHvAp2aTweHTIcaeOmkfU8XAulg5LrFD112mhlRHaBg0SmNyw2CwQgln4vDxB5/Z7r
         cpCx6Tlxx8ZSeF3x887UAfevWZD0SGyQMVbN5KHOkgmbFruBWgCT31GfJueAA3yAzdkG
         5TJHgNo7KNy+gV6G4Spr0pta7QLSnORDKb5XW5MbFVwz+3RNPpNiByZ/XEHO4w/QHPkC
         cvz+sllfvxbW8hXn3L9YAKT4FZ/kyuz+6+Z52Q5SC2nFQonP/ihccYr6j5KXGWIqBwA/
         T72ravaUMoIL2Ie/tLRkkelsyjz2yGVXI8ukfRi3H2tl/HXlJE2Or8U9qh1NUfJg7rum
         wYVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=dBoAabtEYZbE61p8ixZqhbfi6v1fC0mMtx/SBVgEc2M=;
        b=j5gA0VTf6AhWed9v8IqX3H6w2V6Jita3Z0Kbavli8K4VndcHW2HcCdbZhLVQdWYwzp
         STnM1MlUtu/Bfx1m7R2X6K+tyZOQTw5qePfZ9sd8friQnuksa2jwlzFuOFzXWnZ8mTmv
         XS8kQFRNz1fuh4/fX+27APS+xC5JBo5DylkuwQ1PzF1Wjjkti/3ahZopHvNUZ8+v2w0H
         SiXoUK2wq9eRJmL/ekzbbBdLTTSkq8txCIvbIsbfVDOe+WaLnELlGA2q4pRNKYv1tu5r
         cV37Mb6Fk4sJkc0XobXUO5yP1ZRoYIW/P/JmDpFhCek9VNmzeSwex3yN9paCwqlwlQr+
         nyZg==
X-Gm-Message-State: ACgBeo35PAbwfMfVQlzxelvFeLMA2Ia5RgoWdu40kX4VVtVvtmNpbgA0
        jepetko6awm7AfXZ/6jBCCwACOywiX4Uq9HXzd7GJg==
X-Google-Smtp-Source: AA6agR6zzvnSkoFjBcd6qfZAossbSm+ZrKtgclV/8+IusICYRTxXIDGMtN+Um8dpbgsHzuvGbvUuYhtyuPCGD0qPvoI=
X-Received: by 2002:aa7:cb87:0:b0:43b:e650:6036 with SMTP id
 r7-20020aa7cb87000000b0043be6506036mr30743027edt.350.1663155829987; Wed, 14
 Sep 2022 04:43:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220913140353.549108748@linuxfoundation.org>
In-Reply-To: <20220913140353.549108748@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 14 Sep 2022 17:13:38 +0530
Message-ID: <CA+G9fYtwEF-YMrccLbd+kwB7EF=7irZK1o3eeUmUOg5hRvxFug@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/108] 5.4.212-rc1 review
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

On Tue, 13 Sept 2022 at 19:56, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.212 release.
> There are 108 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 15 Sep 2022 14:03:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.212-rc1.gz
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
* kernel: 5.4.212-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: d95c3e78edcd4138c5c7410aef523eb18bc05e1b
* git describe: v5.4.211-109-gd95c3e78edcd
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.211-109-gd95c3e78edcd

## No test Regressions (compared to v5.4.211)

## No metric Regressions (compared to v5.4.211)

## No test Fixes (compared to v5.4.211)

## No metric Fixes (compared to v5.4.211)

## Test result summary
total: 85999, pass: 75685, fail: 649, skip: 9286, xfail: 379

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
