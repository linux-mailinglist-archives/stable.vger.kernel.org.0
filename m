Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52C4754B3F5
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 16:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241290AbiFNOyr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 10:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231607AbiFNOyo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 10:54:44 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC9F20F6F
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 07:54:43 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id w2so15579547ybi.7
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 07:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BnX2PXmAa5CmcHNKr34lLc/yKhRdA6qLpTj2Oet80hY=;
        b=VvJdqcL3UKSIR2Q0os5TLMDwm9FDQfrDEFHrc01YDAW2bnYxeXBMEDV65VR407LajM
         75R0AaJZudMw7eXzkFdXq5MVZsjCK9C7IOrDkdtWxrz0lBRVUrXBPkf/55Xt0ABpOaTC
         uuyf+JDBDgNp+TmimS/L45rSY2XXqHAio9Bu1j2P+PFqkXV2bBtVfxmjJRaYbazHblG/
         0ICpOg2/QfIbkzahqM4im6ipZuVNIVCUGbFq9gDuNCzsG+rSkg+x0JZn99tVrwkSwoof
         ta0PD3jlih49gamqD42U8BBREDm5HrtE0tjQRHrVQd4S1jXIuMl8Ssr/fsjfLmeP53RS
         HG7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BnX2PXmAa5CmcHNKr34lLc/yKhRdA6qLpTj2Oet80hY=;
        b=5M1cvLaM4E8Qs1vaTcO7vU6OdkNNcN/J3qTsvKS0z78WuPnZ//ZJHo/GlZldqVpkg6
         qrGjcd/Wic/yLLozCLNjFHGN8VDzvaqRweabV3UoE42Y+TOEUc6XHi1VaRtPnNcOkNyh
         eh3Yez5MPFY77cZ/IFthFTCFIX7W6wcbB3TmqQTM2kGJCdlmpsDNhAqXaUMjv8prifi3
         QXtH5nRFo+GJOYwuFGFcm3oq427oHznnLkjxdsTPJ19fBUgYmQDXbt2YBOMAnJnnwh7y
         2MtY/PMDM+KbRZ4YV7i3Ki9+fqVhb9dpCm4v99QCyaMku6GLSUOLcr33E8x5CkltsHIx
         8olw==
X-Gm-Message-State: AJIora+LJcK4GUIFQdCjEv+AJAYvu6Bxm+LvSUVXFOc64HH1GSqdhx/X
        CtMBuSmKBrw9QQdgsSTJodPv39/7JADtr9C5S7t45g==
X-Google-Smtp-Source: AGRyM1uSNXw4y0oDSzJUdYck26DosV0PNnwQTmYSiPmk5a1a/iw/izDPEntZHZ1sfTyU3neALM16sHfP2KEU6d6RlfE=
X-Received: by 2002:a05:6902:682:b0:664:e437:9b6 with SMTP id
 i2-20020a056902068200b00664e43709b6mr5624890ybt.490.1655218482907; Tue, 14
 Jun 2022 07:54:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220613181850.655683495@linuxfoundation.org>
In-Reply-To: <20220613181850.655683495@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 14 Jun 2022 20:24:31 +0530
Message-ID: <CA+G9fYukAcS14PAYz_ae9HhFerz_1QGKP6mwWor_NK3g7Fw5=A@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/173] 5.10.122-rc2 review
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

On Mon, 13 Jun 2022 at 23:50, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.122 release.
> There are 173 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 15 Jun 2022 18:18:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.122-rc2.gz
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
* kernel: 5.10.122-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 355f12b39acea720fa2fe8ce6ef486377e1d0b6a
* git describe: v5.10.120-624-g355f12b39ace
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.120-624-g355f12b39ace

## Test Regressions (compared to v5.10.118)
No test regressions found.

## Metric Regressions (compared to v5.10.118)
No metric regressions found.

## Test Fixes (compared to v5.10.118)
No test fixes found.

## Metric Fixes (compared to v5.10.118)
No metric fixes found.

## Test result summary
total: 126949, pass: 113862, fail: 232, skip: 12179, xfail: 676

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
* igt-gpu-tools
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
