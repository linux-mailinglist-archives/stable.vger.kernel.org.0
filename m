Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26FAB57110A
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 06:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbiGLEAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 00:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiGLEAv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 00:00:51 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 730A52E687
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 21:00:50 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id n9so4155997ilq.12
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 21:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UDmz6J2xhATtjIjVKeT6M6oqCXmwom6pKSeUfa8N9a0=;
        b=ppFHoPSihEH+cJRqPAwQbyu8Quh8JEwtIR+IITVx1xLtjukCLWDpAyfti9U3+neANV
         AQxuJgzxHbyneCD0oBpTQW+ZERzW3+MKVkyBUgx/DdQkdlkH4mpn5w//xUneUz496w5l
         XujTfn46y3Yly7NzQvdC4Rn063A+mJ1wOOsYliBYHIQPbz0z1Mz5dcMCU/MW7pfjDq/U
         aRmt8GuPoQRfQDNSUUJrt57vdQHjFObJoKMbwp+LA05pBV26zfYucc2m7XUaJ3qld5p/
         GmYN8hKlv8vr5ZUJJ2b+VgwF4y4Yj21Tijur+7967E4CCV2lc0vWUr3YvnLeoxNOQScK
         Y5Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UDmz6J2xhATtjIjVKeT6M6oqCXmwom6pKSeUfa8N9a0=;
        b=pABVp2cY5vQYadOtbEaH9hv/lbAcNxB3V7pHuOXELNQp6EKiICnqRZf0NvoJB33FWv
         pzlPh4sbAmqekxuI3citl2YGhJQZ86KfgjAs7H8sfBs7NM/SruizkU08lmtPixHNSqD0
         JKXQfi9JiWFRIBbSs+wdvljz2H5lzg5GToulkoEYLpaTp2LbMwla+Dtmch6xUsptXcP1
         xj0RHc0aqRSxrAEGAqJKNDSa0V6G+4J7E78OkKrLCWBx9+B6Cywi86tehlD0YS8m693T
         G8i3GAhxdUWozjVGlw5My61uUU6rbvtYkyRYWRp2edOyVFA3p8NkiCXsRLRoD74LwtcZ
         tmlg==
X-Gm-Message-State: AJIora9ebxvqwSJYicOKvrMv394uatzGxseL6ETAt4Ww00m/C8VmQcrS
        sybte/L9dwRYA4NWH+xwN8EDUaSurLOMkuzyi0edHw==
X-Google-Smtp-Source: AGRyM1tV0b46UlWN1tsUlSpWFqz33NQJ/emgfIKDa39gC71vWyd6HgvP+aQusq2UPmpT9xZZJNdsMlqUJIKptMITPgw=
X-Received: by 2002:a05:6e02:170d:b0:2da:a903:4342 with SMTP id
 u13-20020a056e02170d00b002daa9034342mr11957859ill.92.1657598449691; Mon, 11
 Jul 2022 21:00:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220711090541.764895984@linuxfoundation.org>
In-Reply-To: <20220711090541.764895984@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 12 Jul 2022 09:30:38 +0530
Message-ID: <CA+G9fYsMKggHKyPT5PtXqr7AbrCPXrZd_TE4oitVzMnnvMbhcw@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/55] 5.10.130-rc1 review
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

On Mon, 11 Jul 2022 at 14:42, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.130 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 13 Jul 2022 09:05:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.130-rc1.gz
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
* kernel: 5.10.130-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: b344d768cea41307cf893102087e3134995cf1ea
* git describe: v5.10.129-56-gb344d768cea4
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.129-56-gb344d768cea4

## Test Regressions (compared to v5.10.129)
No test regressions found.

## Metric Regressions (compared to v5.10.129)
No metric regressions found.

## Test Fixes (compared to v5.10.129)
No test fixes found.

## Metric Fixes (compared to v5.10.129)
No metric fixes found.

## Test result summary
total: 133598, pass: 120651, fail: 512, skip: 11641, xfail: 794

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 308 total, 308 passed, 0 failed
* arm64: 62 total, 62 passed, 0 failed
* i386: 52 total, 49 passed, 3 failed
* mips: 48 total, 48 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 51 total, 51 passed, 0 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 56 total, 55 passed, 1 failed

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
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
