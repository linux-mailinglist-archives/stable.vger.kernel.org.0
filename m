Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61BD7567EDB
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 08:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbiGFGov (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 02:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbiGFGov (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 02:44:51 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56BA31B79C
        for <stable@vger.kernel.org>; Tue,  5 Jul 2022 23:44:48 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id d3so13157904ioi.9
        for <stable@vger.kernel.org>; Tue, 05 Jul 2022 23:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2IzNfa/vbKDQoeuVf66JOAoxqYDPZGMAf+JWm59layo=;
        b=w67yh27am51h7Z7k+mAplbD/DUh0gnQVoPr9Cl6sfq2gI9i99lO1J/sNFiuXLxVqOV
         yQEzjVf0Qg23uplwNJQ3nVvcy0Y15sc7JtGIX52VLP5WkLct1GusnEJNZiOqG3SU+EGp
         LqX2WsCN9x6cPqXSvAQMZYhGg5qI2I2UKc0uYU3ijmVftGDi2HSndE8vv7pf8ak5O+zU
         taGYDW56zgUpbp2qBOmcwBHsELDDgAf3YW184qGKBIjS8OdS1xYaiyaCHOWJtQd9td+T
         GqZybggU10D/cXpGXqEroHa8AL/29SHneux/Y3sI9GJ1GFL5wpqkhix/BsmGyWMtn/uv
         ziwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2IzNfa/vbKDQoeuVf66JOAoxqYDPZGMAf+JWm59layo=;
        b=5qZNE6xF/c/h297uKL9MNZjXOzstuxrytLllf74ZbcTOymes1y1kufdpWAmL8ZSFG8
         QXi7BFBbV4BVkCrftyx7oRgxEA7/HjUkUsOemC/fpPhRju3su3mTGWLqnYnNnJnn5Teb
         /sgfNbDYUXXjxuUzyE8VnEI6+alyRq7vFpkw3nooclC3IcFoDQsqGesCWVETzjfs+8wh
         +CrsXl/EJ5c+dUG9nlzn0Vz9mIj/+bhU8V0XKhBxScE/eyxI91xqfjJjE3K3rFYHkPmh
         ULxK8EMrsdJGTsY0PrWOYVBZk0PZpjfk8yrogPZR6fLRlDwO/9BPoDfndJcPt16ANkab
         5UWQ==
X-Gm-Message-State: AJIora+Kx+S56/3koeu9MUroyXoNeA+0cK4fOMjEaSdN3ErJhAfKZeM/
        GZHGTCBMx8Ia2l1usL/MV2wHddImgRTXuaRtLFIG+A==
X-Google-Smtp-Source: AGRyM1voCs7IxyO+W1v29uV1VpembdH2KW3MLHWFtlZS9R1CAgeyBu6QSWwkCFtOwglf3YUev+qqgkpGQtADL0c0vEE=
X-Received: by 2002:a05:6638:14d1:b0:339:e8ea:a7c4 with SMTP id
 l17-20020a05663814d100b00339e8eaa7c4mr24640693jak.309.1657089887279; Tue, 05
 Jul 2022 23:44:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220705115617.568350164@linuxfoundation.org>
In-Reply-To: <20220705115617.568350164@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 6 Jul 2022 12:14:36 +0530
Message-ID: <CA+G9fYt3o4uTM+oVyv55S4trvt26F1W_vNNMTPfZ509U-K4LpA@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/98] 5.15.53-rc1 review
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 5 Jul 2022 at 17:41, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.53 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 07 Jul 2022 11:55:56 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.53-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.53-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: bcb9695d82c0c96cd7ee1714e1652f06b1b4099b
* git describe: v5.15.52-99-gbcb9695d82c0
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.52-99-gbcb9695d82c0

## Test Regressions (compared to v5.15.52)
No test regressions found.

## Metric Regressions (compared to v5.15.52)
No metric regressions found.

## Test Fixes (compared to v5.15.52)
No test fixes found.

## Metric Fixes (compared to v5.15.52)
No metric fixes found.

## Test result summary
total: 126830, pass: 113520, fail: 294, skip: 12336, xfail: 680

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 313 total, 310 passed, 3 failed
* arm64: 68 total, 68 passed, 0 failed
* i386: 57 total, 50 passed, 7 failed
* mips: 53 total, 50 passed, 3 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 59 total, 56 passed, 3 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 26 total, 23 passed, 3 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x86_64: 62 total, 61 passed, 1 failed

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
* perf
* perf/Zstd-perf.data-compression
* rcutorture
* ssuite
* v4l2-complianc[
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
