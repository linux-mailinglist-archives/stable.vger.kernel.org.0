Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09727552C7E
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 09:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245011AbiFUH7x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 03:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347890AbiFUH7w (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 03:59:52 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7756167CF
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 00:59:51 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id p69so11420930ybc.5
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 00:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tWwF4ytRWfOwG8af/YByItsQwpXVQu/cHXdztBQ/QOM=;
        b=ybupSzX96lOxodVhFXvSlU+/swUoCIZBYBKIaDlpNKzjrpQwXsCCiPg1I9wsxXSktP
         FATk16ld2MYLc451qcRj9Kt/pA+7jLBODAdRvoQ5t/eXlyUwNkY4shdqCLfqoUtcHDH/
         alw4tLbL7hllg22z+jnIpUHpEOH+rYAqa0z0IWd3pr5JBY7mvbmo92Jo+EalnYEakL2K
         4p5HZuxutdf9f5v3dDFphiRqqgGjvMubcoyvNdtdW9+Zs5en/TgcJUmEkluavbR0mZ3G
         0morwoOWD8+mxxdI4Bra/5aXQqUVQuZalbg5/gLNTcJXUjalDbnFmqZeVYsx1I46BK76
         Eneg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tWwF4ytRWfOwG8af/YByItsQwpXVQu/cHXdztBQ/QOM=;
        b=4ekzCTl4LOYGkmgVF26ykU4o24oD4vkNx579DRv70TLTcW1sUdx5oYCdqCT6Uwg9wM
         1U3CZAGewF5bh3O5j6+TLp8w89R3fwkmskkox9hQg915PQmvsSIGnjPR341k8bm69DZF
         C+CwfEM0MJpGMCUKIDYUUruYv2hUtCkXfTsj/uMz/4uZU2+OoZUDHEPoHePnV/IfgN7p
         16zSFv0SusSeGnPBFSGWXxlmcybGVi48/7RS81p38TDA/ONX+b7EdZa5GZ7AmWJOhVs3
         LVmnMS6v+Z9D1gf5iJoZq/92kDRzGaLhD2FsMF3FbZy4CF2f54ilo6CvDAbRugYtbnft
         8Y2w==
X-Gm-Message-State: AJIora+YW/NMGcU1nZ4FR29XHrIQMxGylDIOwvtMIesIkBTkCyIjHZeT
        Oq4Dysl37oonb0mGpGsmTJTroZSg/Tf2TUXAS/Kx3g==
X-Google-Smtp-Source: AGRyM1tl0A5pwz4xRSxLxmfnF2AbtXs3Hbo6NWh2A3Fc5yFoS1FOivwilEGpCpvfJEVXQwPH98mvxbuyAaRmZvxDXAE=
X-Received: by 2002:a25:8311:0:b0:668:fbcd:f3dd with SMTP id
 s17-20020a258311000000b00668fbcdf3ddmr11093626ybk.608.1655798390443; Tue, 21
 Jun 2022 00:59:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220620124737.799371052@linuxfoundation.org>
In-Reply-To: <20220620124737.799371052@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 21 Jun 2022 13:29:39 +0530
Message-ID: <CA+G9fYspTNKgYD2o2wAaQ=V+n+1W_ZGrWShMLjin+fGwCOTZeg@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/240] 5.4.200-rc1 review
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

On Mon, 20 Jun 2022 at 18:41, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.200 release.
> There are 240 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Jun 2022 12:47:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.200-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.200-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: bc956dd0d885f095b41747a151ae0caa1b9dcdd4
* git describe: v5.4.199-241-gbc956dd0d885
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
99-241-gbc956dd0d885

## Test Regressions (compared to v5.4.196-11-g04a2bb5e4a0b)
No test regressions found.

## Metric Regressions (compared to v5.4.196-11-g04a2bb5e4a0b)
No metric regressions found.

## Test Fixes (compared to v5.4.196-11-g04a2bb5e4a0b)
No test fixes found.

## Metric Fixes (compared to v5.4.196-11-g04a2bb5e4a0b)
No metric fixes found.

## Test result summary
total: 119849, pass: 106680, fail: 213, skip: 11709, xfail: 1247

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 313 total, 313 passed, 0 failed
* arm64: 57 total, 53 passed, 4 failed
* i386: 28 total, 25 passed, 3 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 54 total, 54 passed, 0 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 55 total, 54 passed, 1 failed

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
* ltp-sched
* ltp-sched-tests
* ltp-securebits
* ltp-securebits-tests
* ltp-smoke
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
