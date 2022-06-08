Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 779385439F7
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 19:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbiFHRKL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 13:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbiFHRJR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 13:09:17 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D788D3F29CC
        for <stable@vger.kernel.org>; Wed,  8 Jun 2022 09:56:04 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-30fa61b1a83so210172247b3.0
        for <stable@vger.kernel.org>; Wed, 08 Jun 2022 09:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=43r9NgjYb+5ZaATZ+bTiI6OhgNabJvGH+SU7HbLzWDQ=;
        b=csb9EQHy1p9NEA6pqYKSm30BqC//Xp8Z4UVlws468guu2H7slv2F9SqU/7RFUJdGjF
         BlFrcVzm3sypxTIsZ0aF/79RGBm68Iz2vmC+YNmDxtMjOZxSu80JafRdSs/HXAnJCBqD
         IEW/KvER4p3HJlVNnG8NLDH+Y793o+BdmlJKAr3n9poP1TZIK7mL1MRLHFEHSEcumbaa
         +G6vVmWbNpj7lVWIHIXiT4EQHxgEeCeJbuyHfjttzXuAusgB2k1nkZNC3iOx8xRKVQLp
         APxpYjaWpHMwRI7XLqdyGJir+c15SR1XWtPcSIJ2FaRKlZGj734FyliM2OWC9RBpHw2m
         lQSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=43r9NgjYb+5ZaATZ+bTiI6OhgNabJvGH+SU7HbLzWDQ=;
        b=Q5JGIzv8IkAzboVSLTYRszWcVoLKu7v8NeGGp2IS4A4gkOpxf5sg+2I9cGfWi+GNCw
         IP5NHOlR8so+mJOwe0FTCIbsLXjtjW2hr47r325hFCKMgUwKSRTlPsBo3HX3OOvgE+oV
         9PlPg5OLGBXry17L8WXZTshs61DgOj8JOFtW0NBC+JkjmpBEDGa7sB4S24t254YxAoRd
         LKaHwZ3VIAKwlN78FREGx4p0vTbVAaOmn4bepBDraPMqdeLCJGEhpWLOyQ36F7AuUNKb
         ld0I5JR5AH/lOPFveuDcG9EMKmQfxpvlP1X6kKevN5m+Y3d1puzaNKexFulJRw9aWrN5
         M/Xg==
X-Gm-Message-State: AOAM533TY+c/rd4LOiOz2x6y74zwkfY4BAf3nYVZicCIH4jRyq2p0/Xl
        QQuZ4WPKRpR3ApGm6hNUllt423nEFMyi+e3JMUK+iOz170OKXA==
X-Google-Smtp-Source: ABdhPJwFlWkwIqFwWY5hXlLXRmLAB0nlz1illGmoX4IOlfi1fcLg1Uw4I1/zzVm8axdb2c2/k+LJxQ+oZvIDYrYQWIM=
X-Received: by 2002:a81:b343:0:b0:300:4822:e12 with SMTP id
 r64-20020a81b343000000b0030048220e12mr38927275ywh.376.1654707363812; Wed, 08
 Jun 2022 09:56:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220607164908.521895282@linuxfoundation.org>
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 8 Jun 2022 22:25:52 +0530
Message-ID: <CA+G9fYvZE0J6_0tRrWxPxMxS8s7kRa66JwTX+huL761uzV5RXQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/452] 5.10.121-rc1 review
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 7 Jun 2022 at 22:49, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.121 release.
> There are 452 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 09 Jun 2022 16:48:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.121-rc1.gz
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
* kernel: 5.10.121-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 08871e799a04f665596bafc8f6eec44c04286815
* git describe: v5.10.120-453-g08871e799a04
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.120-453-g08871e799a04

## Test Regressions (compared to v5.10.120)
No test regressions found.

## Metric Regressions (compared to v5.10.120)
No metric regressions found.

## Test Fixes (compared to v5.10.120)
No test fixes found.

## Metric Fixes (compared to v5.10.120)
No metric fixes found.

## Test result summary
total: 137538, pass: 124480, fail: 212, skip: 12042, xfail: 804

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 314 total, 314 passed, 0 failed
* arm64: 58 total, 58 passed, 0 failed
* i386: 52 total, 49 passed, 3 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 51 total, 51 passed, 0 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 56 total, 55 passed, 1 failed


## Test suites summary
* fwts
* kunit
* kvm-unit-tests
* libgpiod
* libhugetlbfs
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-cap_bounds-tests
* ltp-commands
* ltp-commands-tests
* ltp-containers
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests
* ltp-fcntl-locktests-tests
* ltp-filecaps
* ltp-filecaps-tests
* ltp-fs
* ltp-fs-tests
* ltp-fs_bind
* ltp-fs_bind-tests
* ltp-fs_perms_simple
* ltp-fs_perms_simple-tests
* ltp-fsx
* ltp-fsx-tests
* ltp-hugetlb
* ltp-hugetlb-tests
* ltp-io
* ltp-io-tests
* ltp-ipc
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl
* ltp-nptl-tests
* ltp-open-posix-tests
* ltp-pty
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* network-basic-tests
* packetdrill
* perf
* perf/Zstd-perf.data-compression
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
