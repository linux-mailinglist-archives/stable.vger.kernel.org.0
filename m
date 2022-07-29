Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB481584ABE
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 06:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233823AbiG2EZn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 00:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiG2EZk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 00:25:40 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4FA977A73
        for <stable@vger.kernel.org>; Thu, 28 Jul 2022 21:25:39 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id z15so4417318edc.7
        for <stable@vger.kernel.org>; Thu, 28 Jul 2022 21:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BheXqPnhOLt2IMNV2xWB3SWJU/Ur46AJopM+n6Fj6zc=;
        b=Z1UZJHRRoS7XtmrnTmBGffyagC5KDymIdt5bnnSDJGl3pv3jeXxeVII2PuwIlmG+i6
         aEU3ZD2795IBbp4R00aKn243ZBvWDR17CZlrFSfUJG4ns8HzGHXzUhbXvpL4QEgE6jcL
         hN+CvTacOOI6rJ1PCvsmWYjMS8LmrwMm+1mZTLY0Cg9TLb2CqbPUfy0OsZvuT/8wDBXX
         hW//Fe/xFfmZ73pH+vLEVqe/4LD0rYpa3xsowUN3eWJXbFFrri/m8bAU3JbHBXpbqtLc
         wUaXYtIw9RnluLuXCGll7f/bkXrNZHo9eX7GU4uXDFbp7AxspaqJUu/TqRcnShYtkDse
         n9Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BheXqPnhOLt2IMNV2xWB3SWJU/Ur46AJopM+n6Fj6zc=;
        b=Nm7OO44vcFE+UgAqCzFYeDJKYoTUepGKcjYTGSIzRxBnNj8CDx4fohjEc70dBxdyO/
         AOborUDbrExbl5zPRqIpyLpz92cx6YLEwTxrvHh20bMD5XBFTxac7cn7GYkqEZwBknhX
         5fTmr58d5TdJF4ZfrW8hQk3eJgb55BBMRPXIZ7Dy80WoogTop1ZQEZTPzwhRKqQfsohI
         DwjZqQM2y6Gq4KORexKrre5XMRn1sm99eG1Dfh4NsuFrNSHLuNDHfhuW0qSz2XrkVwhz
         qUc78STd3G40M/PLm3EcM9dnrmZrDNCX3veSwxdftEWGdZCOcS6v8xKFao2zdj0r1hJn
         emmg==
X-Gm-Message-State: AJIora97S4Ow8QKzupEiFcmQT0bF9KA9ToxdspQAICCZ5CjYN76Rs/Pf
        QZCN9TfNos3mbNurXrovvDvWzBih5n5Uuxj+CNxV0A==
X-Google-Smtp-Source: AGRyM1uAWabekOEiuMnZt/UmvjPKgjeulSdFYFLjFdXobcTZukwl7ZCDoI0UrdElC/mjD0yT8OcxkJMw6UBwCqaRPCc=
X-Received: by 2002:aa7:da93:0:b0:43d:1d9d:1e5 with SMTP id
 q19-20020aa7da93000000b0043d1d9d01e5mr1020049eds.55.1659068738042; Thu, 28
 Jul 2022 21:25:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220728150340.045826831@linuxfoundation.org>
In-Reply-To: <20220728150340.045826831@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 29 Jul 2022 09:55:26 +0530
Message-ID: <CA+G9fYsdeJK8ELEvyCT+WFHLYuPvBBKo-MW5NNU6CNkecCxOiQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/101] 5.10.134-rc2 review
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

On Thu, 28 Jul 2022 at 20:36, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.134 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 30 Jul 2022 15:03:14 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.134-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.134-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 3dbf5c047ca925a0666cd82f39563e9921294ca6
* git describe: v5.10.133-102-g3dbf5c047ca9
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.133-102-g3dbf5c047ca9

## Test Regressions (compared to v5.10.133)
No test regressions found.

## Metric Regressions (compared to v5.10.133)
No metric regressions found.

## Test Fixes (compared to v5.10.133)
No test fixes found.

## Metric Fixes (compared to v5.10.133)
No metric fixes found.

## Test result summary
total: 119905, pass: 106363, fail: 551, skip: 12232, xfail: 759

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 306 total, 306 passed, 0 failed
* arm64: 62 total, 60 passed, 2 failed
* i386: 52 total, 50 passed, 2 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 51 total, 51 passed, 0 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 55 total, 53 passed, 2 failed

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
