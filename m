Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D52BE54B45A
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 17:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236865AbiFNPRr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 11:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356485AbiFNPRq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 11:17:46 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B212F624F
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 08:17:44 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-30c143c41e5so33342517b3.3
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 08:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7DyoEzjGV1GYmzGysGFZNBfKhzd5r8NUEg0vY6kJrI0=;
        b=c5vsjZWcrvQMdJMihCATHQ26NxYx3zk7FgpMXe2lt8ToOICDMZEX2yNNAPzCh4+/ft
         R57jTDXcFivzHj7eYcWa+c8/qNo83v0HrTyBUvLY5xV5zDeiOIp2F7n/ncwCJx0T1FDF
         oVCm0X0LzTv5p9CL8/7bKn4ZHLjrzN7mMVPwX3wisjBGo2Gf5CUURPS993A5PEuyFUlp
         YnueA3nvSsk8viR+FaT5FHdA/ast5WQltjHD/ttPtIPiw613JZsvS9byorZgvwRLeX6p
         qlpL+ojlblTlZvCz6imfTD+o631xtSXEfZeRSJDjlEixAQ1g8fBH4p59rxZJkIIorCUa
         oQ8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7DyoEzjGV1GYmzGysGFZNBfKhzd5r8NUEg0vY6kJrI0=;
        b=at8QyTquEaKaEuEd4vanAbk7WoYrQDFGUNYIUX3n6S2uyJX4foMNXxqJa1U03xvbDp
         qmrtSqc/hH6Ra9rkNN89tCIjbMaDYEWRm9AoZMB1tBmuqC6SZTVnhuOCZG/3Pu+pOSs9
         v0MEdH1WMi6wN9AlNSir2YCLJF2Y7Pw9ZfXX4naaYvAUzXZdDurPAMwCetHpD82/Rz/o
         1YPPc0FarfEv0sHWAO5G+krSzpfPxLg55Fnus11VOenLx3UbkgmHRylE4nMFpIBO40Vd
         DB1AXPMxVsP3XWL++pwQjXjgWs7QlC1Ay2cTJUn4lVZgvlfPkTV3eugTuMpwLxoiiOSQ
         /47A==
X-Gm-Message-State: AJIora8qwA1lw2aDnThf/hg8qXgjQdHGPTQ8N2Vzgkcn4wnUjYeT9mTX
        5jLyArZi/9+kRfuOnEA/j/NCI9a19ZYMehtmCUmUuw==
X-Google-Smtp-Source: AGRyM1va1fPs9lpvQ8NxlplELbvn5d4WYQXs4FC20dWLWFtAzDyQWKVsUDMncwhK6GjYdh1QzAaeF7kxbaMSAZVp4MI=
X-Received: by 2002:a81:3a50:0:b0:313:7539:3420 with SMTP id
 h77-20020a813a50000000b0031375393420mr6417968ywa.366.1655219863652; Tue, 14
 Jun 2022 08:17:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220613094928.482772422@linuxfoundation.org>
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 14 Jun 2022 20:47:32 +0530
Message-ID: <CA+G9fYsGRjjfyj6Qw+VtpJ363N46hZLba5X3PHz_yX3QxcQVSg@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/411] 5.4.198-rc1 review
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

On Mon, 13 Jun 2022 at 15:57, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.198 release.
> There are 411 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 15 Jun 2022 09:47:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.198-rc1.gz
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
* kernel: 5.4.198-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: deacfea5b2321cbcf23622a0f37317ddabfdf76b
* git describe: v5.4.197-412-gdeacfea5b232
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
97-412-gdeacfea5b232

## Test Regressions (compared to v5.4.196-11-g04a2bb5e4a0b)
No test regressions found.

## Metric Regressions (compared to v5.4.196-11-g04a2bb5e4a0b)
No metric regressions found.

## Test Fixes (compared to v5.4.196-11-g04a2bb5e4a0b)
No test fixes found.

## Metric Fixes (compared to v5.4.196-11-g04a2bb5e4a0b)
No metric fixes found.

## Test result summary
total: 119666, pass: 106701, fail: 219, skip: 11909, xfail: 837

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
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
