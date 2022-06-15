Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4482554D176
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 21:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233117AbiFOTSy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 15:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbiFOTSy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 15:18:54 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DCC73A1A0
        for <stable@vger.kernel.org>; Wed, 15 Jun 2022 12:18:50 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id t1so22238941ybd.2
        for <stable@vger.kernel.org>; Wed, 15 Jun 2022 12:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=H12t+DHpyBhOw3R4oFHJncs9g9Nr7NDEBiREhzQ1jWc=;
        b=ExYmd7/awgJyRNU3Y3Ai3d/7y2raEmJbvx1f8aokN6dwPhEfxj0A1OVBsXKi+7G2RV
         5lUy0IaqLEzjQsu4BZsrdL1fcjEjwXT2WmD1ZTc3iT0CUreVOMRZ4OnamILI8Y36MIdW
         71fTaNNBIRxbV+h6VqCO78bLshEAHc3miJahBhnUKir1KOQ2sPohAOXcN6bHXkzJKsct
         UKOTivQMJuX3xWxgBkEOU68KzttnuBvDQ+eHAI9K8i4SVk7Dqq7W/FV3G5qoBjEvq3PH
         FwPjxCz9ibthCUmQo6DVec+c4emmb9pTqY/tt7jGOEEdKZOtFiiZasgTqj2afpUw+o+F
         9aVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=H12t+DHpyBhOw3R4oFHJncs9g9Nr7NDEBiREhzQ1jWc=;
        b=G4a4hoD4AFnUnwzBBcdI/fMQE9Tg+z/MCMweU3LqJtM5dwyMAqznk2AHQp7w3/vMK7
         aS3l5nOPdkyXcfnIGew2d1mqo1NMQ3o2DmaV9BG9S3kK3v59RemyiJNzOGmxiETiRD9q
         zL0iLVGdLw519yIg7uBFXaDwQli9JNedcrlfx29MXxtj5t9yyx4RRdfl4D7RSg+4gktq
         RO4RcpfnJHvYg0PoutZoR88X0OTNHbdwmKjssQqOZg1+VmjRmFB5O1Js5Txpk+robJH0
         nyHJ8Q45Zv/A1zQePNYSGqSVNf8pMVHFmdYKO4ZxWhRl37kHi0hUAdI3hvVlYSpCe5B8
         LKmQ==
X-Gm-Message-State: AJIora+0x4fV1yHmrpndbuwCU17SecRkbV867ZNrN51upmohlGaF7i3q
        Cp2Yzhi1YD5wxBBz8hcJgSwEf45z3vomPlqWhI7RAA==
X-Google-Smtp-Source: AGRyM1ss0oJH0J3kS2j8J9C66FhtVMoaeocW0loaGvC+VbV7+FxsMqHLMSWJojsNu25QbMr4O1hu7I+yY/7DBn/7uWY=
X-Received: by 2002:a25:3b52:0:b0:665:f89b:708b with SMTP id
 i79-20020a253b52000000b00665f89b708bmr1391775yba.483.1655320729250; Wed, 15
 Jun 2022 12:18:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220614183721.656018793@linuxfoundation.org>
In-Reply-To: <20220614183721.656018793@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 16 Jun 2022 00:48:38 +0530
Message-ID: <CA+G9fYu0T78fGSRiaANnb5iyNhMNDDMrwuVcdcoLdOVrhL2F9g@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/15] 5.4.199-rc1 review
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

On Wed, 15 Jun 2022 at 00:13, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.199 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 16 Jun 2022 18:37:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.199-rc1.gz
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
* kernel: 5.4.199-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: d05ea6389e7ee572e3cf5bc2438811c06b8f7bc3
* git describe: v5.4.198-16-gd05ea6389e7e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
98-16-gd05ea6389e7e

## Test Regressions (compared to v5.4.198)
No test regressions found.

## Metric Regressions (compared to v5.4.198)
No metric regressions found.

## Test Fixes (compared to v5.4.198)
No test fixes found.

## Metric Fixes (compared to v5.4.198)
No metric fixes found.

## Test result summary
total: 114397, pass: 101834, fail: 267, skip: 11254, xfail: 1042

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
