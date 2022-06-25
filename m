Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B85455AA81
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 15:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233122AbiFYNaL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jun 2022 09:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233112AbiFYNaK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jun 2022 09:30:10 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4560E031
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 06:30:09 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id z19so6972018edb.11
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 06:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iTnUk3tlSD5g6S5C+WLw8gY5BOAyXktdvyU9ZJ/9+5k=;
        b=hHVcjb60Z3OquJI8ZQ8LecR5U8CGQVjgZEalXcUFN/kqmjuC2hfQfNtFWd/j0Ubhgv
         XZU/A4AyBvG4flFG1V+0vrAvwyoO2DpSH7PJl/+nMljE+IaNSaQMukcWLvp+8vL4eRNI
         uWAF47elndqR/rKf6JpWosZpjnGKKwtKUVC587DYSeiOITP4y/uzk3AUS10tyzwe5WhF
         BhTbcbWA8a/Gt1f8ieJ1gGU8kRbpNng1VkwiNMsKeLzJ0Jl9zehUPJKrvshOseMwghuj
         k2ZjCAIq78gFG0qzFfQ5SsYa37UmdgAgP8IxYM6+s3EO9P/ZFjyjezp51KGmyAALPtlM
         y1vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iTnUk3tlSD5g6S5C+WLw8gY5BOAyXktdvyU9ZJ/9+5k=;
        b=ei+Zlu+ofAo6UGx1/Jy2W+4DrnuzLNdfHePwsJa3LNQSrl9R3CssCoskFw3b/kHWYy
         5Nb95mIvBI7WthLMgZy5bvCh4wUQwRMSNfcWsEHQ53QuGYuPH0vRTsSg0ii7LweEHkyO
         zlZsV2yR/Peq8bW7tjCVKouQL0GzmvEkZA/IyVCJPVFSVebPPoo4EqEJHmUhfolM1ub0
         J8UGK+ojQa0gPkXeK08V7xc/ldmMVnPkdQKKoAWBSD8boGTj62W3I6+akOfbhpuifAT7
         8lPLAdMDoPTs0gA+/r/ZRG//TByQiWyfevTAWufKiqy4tf9rewAji3szOagqOQgsjZ3L
         EFng==
X-Gm-Message-State: AJIora/39JE5Jwtgr1DR9f2kM2wqwprIrFNTtaZvrvxmqUVSIpHYIKlw
        pT0ghyitua2M7ej/WsoC60mM70dH3ID3Wl0bI8dFMg==
X-Google-Smtp-Source: AGRyM1tnungB/nyPyifCtd2guTjt6ergSboKn3H/iuJVbwI6R32i69otIxTEegIbhLWuR5TtmkUJlagMTXrYroT59AI=
X-Received: by 2002:a05:6402:3591:b0:436:c109:1fa7 with SMTP id
 y17-20020a056402359100b00436c1091fa7mr5020464edc.208.1656163808252; Sat, 25
 Jun 2022 06:30:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220623164322.288837280@linuxfoundation.org>
In-Reply-To: <20220623164322.288837280@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 25 Jun 2022 18:59:57 +0530
Message-ID: <CA+G9fYue1yjXmRmaSRcURRORLLun-ykH=COFtCt7+sa1wwgEYg@mail.gmail.com>
Subject: Re: [PATCH 5.15 0/9] 5.15.50-rc1 review
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

On Thu, 23 Jun 2022 at 22:42, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.50 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 Jun 2022 16:43:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.50-rc1.gz
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
* kernel: 5.15.50-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: add0aacf730e0bba8de6382b896a9a55b022cb59
* git describe: v5.15.48-116-gadd0aacf730e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.48-116-gadd0aacf730e

## Test Regressions (compared to v5.15.48-107-g3797b8fe6025)
No test regressions found.

## Metric Regressions (compared to v5.15.48-107-g3797b8fe6025)
No metric regressions found.

## Test Fixes (compared to v5.15.48-107-g3797b8fe6025)
No test fixes found.

## Metric Fixes (compared to v5.15.48-107-g3797b8fe6025)
No metric fixes found.

## Test result summary
total: 131039, pass: 117719, fail: 417, skip: 12312, xfail: 591

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 314 total, 314 passed, 0 failed
* arm64: 58 total, 58 passed, 0 failed
* i386: 52 total, 49 passed, 3 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 54 total, 54 passed, 0 failed
* riscv: 22 total, 22 passed, 0 failed
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
