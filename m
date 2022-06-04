Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A00753D821
	for <lists+stable@lfdr.de>; Sat,  4 Jun 2022 20:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239501AbiFDSkS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jun 2022 14:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239497AbiFDSkQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Jun 2022 14:40:16 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A847A31DCB
        for <stable@vger.kernel.org>; Sat,  4 Jun 2022 11:40:15 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-2ef5380669cso110248457b3.9
        for <stable@vger.kernel.org>; Sat, 04 Jun 2022 11:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qObx7yCQ7FjlnpZUTDh/T1TZApLND2G3LRPTQ/AToI8=;
        b=mIPAFb7rBnPov3pwMLPKgP9nxV3GISZKpf8AZupjYwu5wqHfm/qMpPJbS7adyM2fBj
         40yNTkLPsCvaa832yM7uLCSPr3SgVLYYKcGrVEfMvgiRhWqUuUU6wrZy1/KX5OZa3g2r
         yNNk3jM7lEHqaPAWd3vdUMRn7LwtWle4u28rzbB4NfWow6Pha8vgjAzShRpIsuor5r3L
         PN2/bVwx8k8/ZYXRSwZqjrbAhW0Q1uWEdirWLKKUsMes+VzozepDQWUX4uUrQqYRjjRG
         a9C+AC1YJNMn5Gytp/hd6f3kmn7oCQYjKRNKTkcfz7FZCdTS6BLTMCHM5sY9wn/wZTiS
         +xAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qObx7yCQ7FjlnpZUTDh/T1TZApLND2G3LRPTQ/AToI8=;
        b=mU7vvWE5XdCRqfZsk6YaM0WhHTe4NorRv0HtZeivWC8xuDlVW/ExLHXRu0qHAQc0VH
         DNMHN9Z2l+djo5DcQ2Aq4H7YbFauBvo5kFhwl8PLHEOMUd2c8Vr1bAi9iFsCTGHs3WZw
         cwuFvLVyuB6MopSS86tXw4UU8KBr02bNQ0GWzXM4WQ0eoIhTvAWMF/K//ROCSPMVvgPe
         f3BW1GGOY2er8XjiIiLE87GqB0IPp87eeNw+DDSi3v9Cqj7UeboL/KTy5IdNvrjNS5EZ
         tzfBEjxOIVvZuW3GhcA8nWqaXcngUCGb2/XYfDo6fA5Z0EF1WZWw5WIuqcdZM7oOS7ir
         N07g==
X-Gm-Message-State: AOAM532F9Rbol83p7+meTSDMnq3LwcBqYE6I248kNYPQKGL7Of27Y998
        K/fdXPrCDvQkbgql06ow+K+RgZ+oLHzQdupPgHzycA==
X-Google-Smtp-Source: ABdhPJyjCFaHWMexdIe+Zyk6GS5EXThdDggrA76G7Y82t0ED50ArvlljBnQ4vaNUG5mfuGr29p5oEGhTbo4Z6ZZ/1IE=
X-Received: by 2002:a81:b343:0:b0:300:4822:e12 with SMTP id
 r64-20020a81b343000000b0030048220e12mr18071981ywh.376.1654368014821; Sat, 04
 Jun 2022 11:40:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220603173814.362515009@linuxfoundation.org>
In-Reply-To: <20220603173814.362515009@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sun, 5 Jun 2022 00:10:03 +0530
Message-ID: <CA+G9fYvJEdMKKFO=OYynVPBbCqTFb4naMRWMEzQ+Tub0y5Y_eg@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/23] 4.14.282-rc1 review
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

On Fri, 3 Jun 2022 at 23:11, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.282 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 05 Jun 2022 17:38:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.282-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.282-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: f412febea824d191dc7d71faf706d9312f5cac7a
* git describe: v4.14.281-24-gf412febea824
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.281-24-gf412febea824

## Test Regressions (compared to v4.14.281-7-g6eab7c1004f3)
No test regressions found.

## Metric Regressions (compared to v4.14.281-7-g6eab7c1004f3)
No metric regressions found.

## Test Fixes (compared to v4.14.281-7-g6eab7c1004f3)
No test fixes found.

## Metric Fixes (compared to v4.14.281-7-g6eab7c1004f3)
No metric fixes found.

## Test result summary
total: 111312, pass: 98345, fail: 140, skip: 11289, xfail: 1538

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 293 total, 287 passed, 6 failed
* arm64: 52 total, 45 passed, 7 failed
* i386: 27 total, 23 passed, 4 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 16 total, 16 passed, 0 failed
* s390: 12 total, 9 passed, 3 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 49 total, 47 passed, 2 failed

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
* ltp-syscalls-tests
* ltp-tracing-tests
* network-basic-tests
* packetdrill
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
