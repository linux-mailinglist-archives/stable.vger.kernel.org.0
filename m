Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E10D5AF410
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 21:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbiIFTCd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 15:02:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiIFTCP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 15:02:15 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D688C021
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 12:01:59 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id cu2so25543238ejb.0
        for <stable@vger.kernel.org>; Tue, 06 Sep 2022 12:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=5UOqHpIX2ymZ1ZWJZa2X5c7mteo5YGPo854Fo8SNFiE=;
        b=bnMoFeDBq3MNXMP5q8vz3iI7cDhJd8DvFw1NXGJVRd0j2wOgWRMKqmIIcrfNUa3/Xt
         OE9zto1rYttYNTOumDc76M70yOMgsh2s1nI8/sHouf8j6JN722csoBNbskq4wtI2hTGs
         c/5507OkL1vJ4e/iwuVZYgjElI9ctwJUIWZidS2v4VV+FATnQLoq4n+wvhC5rFQ70W6C
         xILFA7Lkrm7uZfVp57xslMO0Cy6NlqHIJd9YaYAc+T8Zk/bZ8QQsMGyO2h1HLFrI+y6N
         vrd4Tn8HdLPlpJ/dQ0bUU3xi+Kk9SIPhxjjPS76USNLEcB9lUMdfYLC+Vo80y66CWQn5
         WrIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=5UOqHpIX2ymZ1ZWJZa2X5c7mteo5YGPo854Fo8SNFiE=;
        b=x8y8hCyFDKQnmuITwWYD300vjl6VeEFe55K2Z1JE4mDuifkl4qaz1yzdjqqNMzeor6
         7JNJ0ooT7AcTXCeqAuGb5jMSGulFDc468c4pjUrs/zckPT9ZLF2G1O2yYPiebI0IxQKs
         91y421yeICWct/+Ekfl5gIrrai7fTOGYjnHq45MMFfxcfAmMqwYQ0zrcDukAUshTF0tc
         +nOujq0cCEupnG44ZY1iLw6uoMCB0JWUibWfVqx9HOE7OPJgb5rCVJDyGnnCKmPFjXvp
         CNk+S+pstC9Jxvm6Nyk3NFdrvTor07xhwJ8LylUXnnnGXT/N+IE4BrklOFgly5+28DYp
         KLzQ==
X-Gm-Message-State: ACgBeo3kY/cs/kSOltYugleq7oJ9TMIrd5FOlS0T0oAyL0/VKGAAfW2N
        AsMHoq7icHxFHWntQJaIaG0xmJQpYgzpkPiceC/ilQ==
X-Google-Smtp-Source: AA6agR7u35Lld13jLy2nQPiqq7La303UBzoD4Rak4akBONfsuxGYkk5CIsqhZtdlzkdsaQ/uz52xQE5OMAy14Ab3qf4=
X-Received: by 2002:a17:906:9bd9:b0:73d:da74:120c with SMTP id
 de25-20020a1709069bd900b0073dda74120cmr37466877ejc.412.1662490917935; Tue, 06
 Sep 2022 12:01:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220906132829.417117002@linuxfoundation.org>
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 7 Sep 2022 00:31:46 +0530
Message-ID: <CA+G9fYt3bRF1oz0UARVxWYR9B7qY2uh62jQ_d5JUt4BfPH6YUQ@mail.gmail.com>
Subject: Re: [PATCH 5.19 000/155] 5.19.8-rc1 review
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

On Tue, 6 Sept 2022 at 19:13, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.19.8 release.
> There are 155 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 08 Sep 2022 13:27:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.19.8-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.19.8-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.19.y
* git commit: c0790038d4859e77589313023c61b0d7104e2d14
* git describe: v5.19.4-390-gc0790038d485
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.19.y/build/v5.19=
.4-390-gc0790038d485

## No test Regressions (compared to v5.19.4-234-gdd6b2254d7a7)

## No metric Regressions (compared to v5.19.4-234-gdd6b2254d7a7)

## No test Fixes (compared to v5.19.4-234-gdd6b2254d7a7)

## No metric Fixes (compared to v5.19.4-234-gdd6b2254d7a7)

## Test result summary
total: 103723, pass: 93459, fail: 693, skip: 9312, xfail: 259

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 333 total, 333 passed, 0 failed
* arm64: 65 total, 63 passed, 2 failed
* i386: 55 total, 53 passed, 2 failed
* mips: 56 total, 56 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 69 total, 63 passed, 6 failed
* riscv: 27 total, 22 passed, 5 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 58 total, 56 passed, 2 failed

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
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
