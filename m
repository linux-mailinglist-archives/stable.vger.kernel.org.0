Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95B3B59BD98
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 12:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234458AbiHVKby (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 06:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234168AbiHVKbx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 06:31:53 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C436A2F3BB
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 03:31:51 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id u15so11544499ejt.6
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 03:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=UEn91Kh68Jon3KjovjIqpiYSJJBvwvMM4suWzr1io5I=;
        b=gfpJdUoIAslNoiUavsi9lHP9QxRxwRzXeFaLgFyGL+CdRrW0NY9FQCPlBrljMmbJ/k
         7DqKUOpnbzQY+SNiWdWLUS8GCvpBkcQyUlrZtTi1aBRaj8IWMJritckXZelkrFmjuKH+
         P4X/NaQqsHehmdGbYvduzo6LvQBE6vSbTC0o0lzjLd6jw0yIcEGTND5RzkPPJ/Kbfsml
         Q0a3hCm8tnwrkBlbmFxYAPS3106IuKcxDu9EtuDYkWmLIKurQHyHbTts1ICQb87/xmcf
         sXcrVGOJK6Tz8l3dvDloBJ6kmnMkVp4P3Uw0rUij2hfdLkC0birOrNiwnnPvRf+R5yDG
         rIgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=UEn91Kh68Jon3KjovjIqpiYSJJBvwvMM4suWzr1io5I=;
        b=e0E0C3e/R+yTBQcDvc3rpsLMkLxYb+RtNRXD1ns5fetdGVvG5DjB9dFDsBgBvtZ2Lh
         xKyJ14Z79BwIh68ESuaPBrv7fJsEp8ac5ng+tkjS7xSLNMyycZqPFFFzc02RAMQ2jHop
         176RByw9RCMpnMdi+PTWyqAiPr6RxaVPH9sv4rpNl8/dQGazxIUU/INPMei9y+9ZrIhK
         P3MiWxoKztctjs1aVFXJotPM2E9xeiNUkb++ZUtcpmcoBqcrlQJIytzE67SKurfWbreR
         gpW2RDpQQfeTlS0JdkaMKQA1gC1QYWwrXHtgBWcyKe/5Mx2qlLymdSL0UriCeD1f+8Ab
         OFdQ==
X-Gm-Message-State: ACgBeo2cvZi2l4nTPSc/HOgsi05YnXrfVRMMpa7kg41UtI+5AkNqPP0R
        1PH6lFp+I3+8Hd3Etki6NCW55NZzy/7HA2HPO+zcVWBiutMP+g==
X-Google-Smtp-Source: AA6agR4fRoH9cmiSek3SYhtT4L3f0Sg4GbSLSShgBnbG4vvbFm4Y7uVPGkauBJx7LyH/93yfYIf7UxaJ/rZU/ZTOtik=
X-Received: by 2002:a17:907:2cd1:b0:730:a980:d593 with SMTP id
 hg17-20020a1709072cd100b00730a980d593mr12309967ejc.48.1661164310135; Mon, 22
 Aug 2022 03:31:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220820182309.607584465@linuxfoundation.org>
In-Reply-To: <20220820182309.607584465@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 22 Aug 2022 16:01:37 +0530
Message-ID: <CA+G9fYverjZAJnBCYL1sKgrHYS1q=xj2L5hbPxoP+O5xDxkwpg@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/10] 5.15.62-rc2 review
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 21 Aug 2022 at 12:30, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.62 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 22 Aug 2022 18:23:01 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.62-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.62-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: decfb75fa34c3fc79f494f44b36d56d1d744edd5
* git describe: v5.15.61-11-gdecfb75fa34c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.61-11-gdecfb75fa34c

## No test Regressions (compared to v5.15.61)

## No metric Regressions (compared to v5.15.61)

## No test Fixes (compared to v5.15.61)

## No metric Fixes (compared to v5.15.61)

## Test result summary
total: 140302, pass: 123315, fail: 681, skip: 15459, xfail: 847

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 301 total, 301 passed, 0 failed
* arm64: 62 total, 60 passed, 2 failed
* i386: 52 total, 50 passed, 2 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 54 total, 54 passed, 0 failed
* riscv: 22 total, 22 passed, 0 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 55 total, 53 passed, 2 failed

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
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
