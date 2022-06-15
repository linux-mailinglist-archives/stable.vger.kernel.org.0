Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6032F54D0A0
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 20:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358156AbiFOSGI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 14:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358129AbiFOSGG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 14:06:06 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0119C50B25
        for <stable@vger.kernel.org>; Wed, 15 Jun 2022 11:06:02 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id h27so21909939ybj.4
        for <stable@vger.kernel.org>; Wed, 15 Jun 2022 11:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LWoNMw+t5sISDKPfmS/uBjaE6K11uOqPgrXVRArfKdA=;
        b=ff5DI+ro3jbKitYSIhf9pNkWiGw74HA3Bev6bXhgRe5lNgjAsd+iH40hcRxs7KoiK2
         l2atdhEuA03Nu7T9WjopOFxG+qTHb/tmlHzx4YQ37W70dHi4ZQtIqtivnkWgpglVj0Oa
         6PVmfQLEADLqcMq89dENw8FVQjAdmxyymwVeiFV4ZSvnJZ0fKqwEiw97D3QkplESbw9U
         oXvUKZQUM4GtO+5q8Su+dZqJwBDmT31T+9/6P3nLNlJhQ8G4jwzGwa81dOAJ2PUn/PWH
         6bPdoVo2cLzXEFqGkYBWuJgaJaFIuGGryPqsdXHW+YW/ZMoIGx2eKqGABsmYMtX+tuJO
         tdtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LWoNMw+t5sISDKPfmS/uBjaE6K11uOqPgrXVRArfKdA=;
        b=gqnerQ2Uupb1A70jLz0TyttHEXSr90guBMR7M4/VPgDm46/dim6moapFSc5gfCfGdL
         y50YM/1T2u2cq/M/KK8GxA3WKBlvFOAjrSH8WozxiH64W99r3gBLACXIa05gu5/pKhb0
         BWSn8WCdPIztJE+ahGfJ9t/9ikUHdnCX2u7Vv0UcYjBFGhYJBck8Q9GF3dIHn7abrrTf
         twZQBYfHnHPbeE/rGG4Tt1lWmp0QAeSC+BX7g1RcKyWvsZH28cv05Q3TXoAQL+Ew/lTX
         IGrKRKKbEtnkfbAQqKh/eHSl3HuJYmSl15Ea85chcXZUGMHJzCtPQR0G+X1lN70wKwhg
         N3xw==
X-Gm-Message-State: AJIora/KYO/uyhOhe0WNxSmz2E4iJX+I5yYlTeJBSsHm2+ToLifigChz
        YKQCzM8kOxGy8O0REEnQQJ75dhFJUXG/bE9JYavu3g==
X-Google-Smtp-Source: AGRyM1vRbuit8z7ENCK6VzmAG6N9BoA8xgYpdSwHjzW9Fxdf9zHlYAVzuowAMUgsb6pFz0IwfLCCwNkEYfr+MIEX20M=
X-Received: by 2002:a25:a286:0:b0:664:862a:f693 with SMTP id
 c6-20020a25a286000000b00664862af693mr1115170ybi.389.1655316361012; Wed, 15
 Jun 2022 11:06:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220614183720.928818645@linuxfoundation.org>
In-Reply-To: <20220614183720.928818645@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 15 Jun 2022 23:35:50 +0530
Message-ID: <CA+G9fYsZArO68-ewBJgBikh6K9e4hE2PrD9H7bWUbzuxpBpTHg@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/16] 4.19.248-rc1 review
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

On Wed, 15 Jun 2022 at 00:12, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.248 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 16 Jun 2022 18:37:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.248-rc1.gz
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
* kernel: 4.19.248-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: 3a3ddc084a29f6b9346b3f7de410b1c5353cbcd0
* git describe: v4.19.247-17-g3a3ddc084a29
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.247-17-g3a3ddc084a29

## Test Regressions (compared to v4.19.247)
No test regressions found.

## Metric Regressions (compared to v4.19.247)
No metric regressions found.

## Test Fixes (compared to v4.19.247)
No test fixes found.

## Metric Fixes (compared to v4.19.247)
No metric fixes found.

## Test result summary
total: 103967, pass: 92252, fail: 235, skip: 10777, xfail: 703

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 298 total, 292 passed, 6 failed
* arm64: 56 total, 54 passed, 2 failed
* i386: 27 total, 23 passed, 4 failed
* mips: 27 total, 27 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 55 total, 54 passed, 1 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 53 total, 51 passed, 2 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kunit
* kvm-unit-tests
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
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
