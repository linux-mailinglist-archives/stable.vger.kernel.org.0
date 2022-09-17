Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 582405BB969
	for <lists+stable@lfdr.de>; Sat, 17 Sep 2022 18:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbiIQQgQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Sep 2022 12:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiIQQgO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Sep 2022 12:36:14 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DA7B65A5
        for <stable@vger.kernel.org>; Sat, 17 Sep 2022 09:36:12 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id kr11so9652243ejc.8
        for <stable@vger.kernel.org>; Sat, 17 Sep 2022 09:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=WQI4cJcEXnwyvAdiytiQryhYdQIfRb5es/waxgkKm4M=;
        b=wBlfkgv4LaxynIDWKbuAPs8VqWFvBCnhHPWwZzYd0Cx+M/qZKwgxlLOeKV9H2SM/9p
         oz5rcD3XcPNWl5b5vmbczYEWRyHQDC0Xity8hAWVytBRQUhjJ8pCHJmVO6gS9eF4GFTM
         W9TzGMabUOLLqxRyYE3FwVKwfQYjS2vMfADgudcbMGmGnMg3h3X1b3HrIEpEmmFXmaVa
         MOs/XE+odq1ZiLUlHAmhmJY+aYh/2ovwlNxFb5DnxxIFsv2KYXab8fhdv+d4ddxRiosT
         SyvC+Rl3h52aKj4ldj80cKnlZz0FIPyVyabM4yXyZlBvkhLr7MxDBBBTczWqOJaYAmMW
         Geaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=WQI4cJcEXnwyvAdiytiQryhYdQIfRb5es/waxgkKm4M=;
        b=Do+FcLZshMLsAxgKud/nr11ovKbPRVRz+6cH5dBzi+0gI2QbDkreYWu6TmbB8sydve
         FmUOkZWFztxFaU3oo5C2sB4z/zGIVQYqo4OaXpwyNxbOtl+XB1LnEmUyBYlJYlwJXjOd
         pN5PzrcBDOrr9ghcDzDIjwTpm/hxgqDoUzg1jiwFrOkmoMuCzs2/ioSDab0P8QsMgj3R
         TQM+gmJ5cpyrhgg9R8p9g2EJBCiVmvlS+pKLWHc03cUSFav7SN/+ut5UF4sYByV6kMgU
         EonjWgDt5Di9pl6QhB+59HbsRBmDyVlal1Pcw3Pe5fOrP6Q1W46lO8UqlBSVv+BgM41X
         IjdA==
X-Gm-Message-State: ACrzQf1986tgsgwGDLxiW98L2s8TLVMjFUnhzlmgOgTmNRUetviAyHkq
        ncOcyhZgxCNx03v7TZUWmP4JE9aOLDhFOn92Fl/5qw==
X-Google-Smtp-Source: AMsMyM6vSHfmVsbR9y2/iVyZ6AzrDkauFvIakZZibUXEN9y2pEkr8KOwodc2haaylm1nVYC0Gimm3c47tPVgRoV3NfE=
X-Received: by 2002:a17:906:4fce:b0:780:e1d8:eacc with SMTP id
 i14-20020a1709064fce00b00780e1d8eaccmr2331074ejw.366.1663432570930; Sat, 17
 Sep 2022 09:36:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220916100440.995894282@linuxfoundation.org>
In-Reply-To: <20220916100440.995894282@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 17 Sep 2022 22:05:59 +0530
Message-ID: <CA+G9fYs=wbRVbtU4GoaRU==Vkc5mOymvhZP9SpLBgGcx5iKZqA@mail.gmail.com>
Subject: Re: [PATCH 4.9 0/7] 4.9.329-rc1 review
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
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 16 Sept 2022 at 15:37, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.329 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 18 Sep 2022 10:04:31 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.329-rc1.gz
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
* kernel: 4.9.329-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.9.y
* git commit: baa4a2e9ad839b9028f4de5fb09bcc2d2f24f2ed
* git describe: v4.9.328-8-gbaa4a2e9ad83
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.328-8-gbaa4a2e9ad83

## No test Regressions (compared to v4.9.328)

## No metric Regressions (compared to v4.9.328)

## No test Fixes (compared to v4.9.328)

## No metric Fixes (compared to v4.9.328)

## Test result summary
total: 77802, pass: 67229, fail: 701, skip: 9432, xfail: 440

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 282 total, 277 passed, 5 failed
* arm64: 53 total, 46 passed, 7 failed
* i386: 29 total, 28 passed, 1 failed
* mips: 41 total, 40 passed, 1 failed
* parisc: 12 total, 0 passed, 12 failed
* powerpc: 45 total, 19 passed, 26 failed
* s390: 15 total, 11 passed, 4 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 48 total, 47 passed, 1 failed

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
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* packetdrill
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
