Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 528D75A0365
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 23:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233455AbiHXVty (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 17:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232990AbiHXVtx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 17:49:53 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD1A11455
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 14:49:52 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id b16so23769513edd.4
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 14:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=0M2E2CBv1JpAO8KBnEyx4hFHR2QWIViR8P0YrfLF2RU=;
        b=pMPVm6Ju6mgGJShZt4yz4XgTLQgAo7kMU+nfTEch8KJTkh4U75Dgzu1t6x8n/OvWrQ
         mQXPzZznkL/0Ae4ov4GjaZamFNG5UAtkli9r/XqkUXirKKfq/slnOyRdJvl+WF2L3Dxq
         gOmBsXGwYTCs2yMNlab807HiD4YvcL/q0BreCUtWsrnyN9gZLhexZgG+sS8Ger4Ut8fl
         Fz7EXZrbFyXthZr1Uw/wrv3fifbr+W71b1ywK36+YTZLRg++TnyffRK4NfrFNOoteOsV
         C7WLO4qiz+rXDOECocE/cRJphiI8ithlMKY4XO6uCO+azmF7wXD0j9B/cu6HDY2HbW9n
         Kx3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=0M2E2CBv1JpAO8KBnEyx4hFHR2QWIViR8P0YrfLF2RU=;
        b=eSYYuUVNstfldCiwZ4BpyW4i2LniaEwP97cpyyl3zFuY3RonUBluqRBQLMMImBgla/
         3mKcpPgr8+agg6HLUBa+rJIn190koIvneUmf/JFM5ICA3JBBY0AuGTDVKveKzUtvzaqM
         R+h6GKt/g7/uI51M+5IAMDtLo9nS2yuyusxSlmCYHaHanqGsyGaIoAXuh8kwsKwv1Z0v
         TIr2q/LwF16mIvXxEkRNXJeDMVDJ+I2m/vPHfJoe74EvG0scpCiivl1dTYx7wBICENTj
         Nc444lGoJ+KE0Ina5WnPF5M2I5TqiIU0c2a2k49ea84cdow5LM29yTCYtcjjLgOLzasy
         789Q==
X-Gm-Message-State: ACgBeo0no5OORkaJLcCG0ePe8yjkyShGqoXOPXD7IZ6q4EueLWuLrSTv
        yMxe4yhGDOxSdTj0G0cFy5jeGfyqZ42ON+Dlcap0ug==
X-Google-Smtp-Source: AA6agR5O09ML+y+wkwpqTFZdyXLKvTKOvDCKzxGZhCBlRLzXqKLVaTrTyKDBulfYruq3gzai3YvRRCh/BgDxoWjudl0=
X-Received: by 2002:a05:6402:27c6:b0:446:73f4:b5c2 with SMTP id
 c6-20020a05640227c600b0044673f4b5c2mr764674ede.1.1661377790746; Wed, 24 Aug
 2022 14:49:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220824072526.750357674@linuxfoundation.org>
In-Reply-To: <20220824072526.750357674@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 25 Aug 2022 03:19:39 +0530
Message-ID: <CA+G9fYs7_Ly2YR2dcMhtN9aaEdY0aDBURgxzF8baMZgbd=C1fQ@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/98] 4.9.326-rc2 review
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 24 Aug 2022 at 12:57, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.326 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 26 Aug 2022 07:24:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.326-rc2.gz
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
* kernel: 4.9.326-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.9.y
* git commit: cac0256273b13936edab0c4b8f455911ba01a2b2
* git describe: v4.9.325-99-gcac0256273b1
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.325-99-gcac0256273b1

## No test Regressions (compared to v4.9.325)

## No metric Regressions (compared to v4.9.325)

## No test Fixes (compared to v4.9.325)

## No metric Fixes (compared to v4.9.325)

## Test result summary
total: 75829, pass: 67050, fail: 762, skip: 7840, xfail: 177

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 250 total, 245 passed, 5 failed
* arm64: 50 total, 43 passed, 7 failed
* i386: 26 total, 25 passed, 1 failed
* mips: 30 total, 30 passed, 0 failed
* parisc: 12 total, 0 passed, 12 failed
* powerpc: 36 total, 16 passed, 20 failed
* s390: 12 total, 9 passed, 3 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 45 total, 44 passed, 1 failed

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
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
