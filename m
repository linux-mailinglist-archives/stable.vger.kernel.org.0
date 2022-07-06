Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E999567FB3
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 09:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbiGFHUP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 03:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231423AbiGFHUO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 03:20:14 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9227613E06
        for <stable@vger.kernel.org>; Wed,  6 Jul 2022 00:20:13 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id l24so13224385ion.13
        for <stable@vger.kernel.org>; Wed, 06 Jul 2022 00:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=loTq7rEvgKrqQnwoGVcHxXoIsT4GorDsH+IvPT1Ky3k=;
        b=D28CKGi6mwprrzxUSa4VMGwMIJRO0z5T4j/d1LFCs3m2aIZGkQ6T5XZ8E7ecOeAxYX
         yqiJtNJXVxILtzzqq1OH7+HZ5ZqEpl5XvAtTUKERQ18gcUer4KCbR90dm6HFSW8M7yWw
         JqG0U2b4Qzk2XrdKrXzGEyXvIN5d4fd/utdiNpxvqZ9KPTj+OGXYuzWxDtlDC5OLak0U
         vJLHjorcrOpA+CFuVNQjGAzj/H98VsHEti8WcavXzCbrlXVMa7958qSjXEX3L7YqFoXy
         kQrzhlf79+awGjPwVv0dLVoLZGRG8KJwHMgMLBkj9Juqrbh31sre9nWsMxOwP4ivmHdR
         ivLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=loTq7rEvgKrqQnwoGVcHxXoIsT4GorDsH+IvPT1Ky3k=;
        b=O04R/DtfWu1DaaBIHAEmu3cqVpTSfo01m6ZPvZSrKueCK5/+AFBELyUPQ3Sp4WZEF+
         gSctQ2sPOQs6sYtvHjwiBoiv62aSGW6RNJzgnF0hwrUY7wFc0ULvdSWsZG6IPRJGncBb
         F9WwDMBjVUo4ywrGzsX0cVNvWyzaqa8xSX3YWnhVkYOSsBPBtfDVDU4y+swt+uJqAJNn
         rE4eRqu0OLEkdGgQ4LioRSzQgdw906W1TzdVNTKx0Qv2V8tHCBdZee8hdV4NqpFNNGSA
         5GMSfFGfQ5zQEqdnLKv7R6p4CqVoNIUeXRuXdANGrwqKFyfY0t0Rd2xLZbV8LDv9kSar
         ZVBg==
X-Gm-Message-State: AJIora+mv5/ULDBrxgWKcb/Y9wzU3UeutHJkYHQ8HGryhj4i5gvY7+7U
        utuCZLlIKwfb13SZ6fEJzAsyuMJw0qO7KPRv3p+ciQ==
X-Google-Smtp-Source: AGRyM1u10IN+LBw1SfVxu9FfDpV16jurdbtW8izFjPpUX5UC511ao223aouhdpZVBlSHvpWhRTafkgAstU6WSbbOGv0=
X-Received: by 2002:a5d:981a:0:b0:672:4ea1:5f55 with SMTP id
 a26-20020a5d981a000000b006724ea15f55mr20367382iol.186.1657092012859; Wed, 06
 Jul 2022 00:20:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220705115606.709817198@linuxfoundation.org>
In-Reply-To: <20220705115606.709817198@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 6 Jul 2022 12:50:01 +0530
Message-ID: <CA+G9fYsuCHiVCzENy3+kVmA5rRvq5k7DtY3S7fgn84eR2ej0Lw@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/33] 4.19.251-rc1 review
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

On Tue, 5 Jul 2022 at 17:33, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.251 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 07 Jul 2022 11:55:56 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.251-rc1.gz
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
* kernel: 4.19.251-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: b9f174a70c6f609b6132c3a65883b16d552984b8
* git describe: v4.19.250-34-gb9f174a70c6f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.250-34-gb9f174a70c6f

## Test Regressions (compared to v4.19.250)
No test regressions found.

## Metric Regressions (compared to v4.19.250)
No metric regressions found.

## Test Fixes (compared to v4.19.250)
No test fixes found.

## Metric Fixes (compared to v4.19.250)
No metric fixes found.

## Test result summary
total: 110465, pass: 97549, fail: 274, skip: 11512, xfail: 1130

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 291 total, 286 passed, 5 failed
* arm64: 58 total, 57 passed, 1 failed
* i386: 26 total, 23 passed, 3 failed
* mips: 38 total, 38 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 55 total, 54 passed, 1 failed
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
