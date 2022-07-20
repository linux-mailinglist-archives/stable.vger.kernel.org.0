Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33B9957B499
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 12:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234094AbiGTKh1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 06:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbiGTKh0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 06:37:26 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B4D4D4E5
        for <stable@vger.kernel.org>; Wed, 20 Jul 2022 03:37:24 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id j22so32316172ejs.2
        for <stable@vger.kernel.org>; Wed, 20 Jul 2022 03:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IQlS7BDnACDaCsMqM0o6ivue0vmf2zRpA7COhg03lwo=;
        b=JcBt/J1OouW1e2R9hMEn6injX76fjudE4aba4Z7ouSzPSHkB2cHlRYXC02AeUA2Syq
         smS3tqHA9TK/0E1xezqkq4a+N1EM/eo3qzgOt5TSvAhT1w5lGynWOP90/+LH3b8QstHS
         HPYglMvNFGn9/FLXXvrR4PqsDTqUdt55V+dyu/cvN3e4q3HU1+fQgXpzvzkrsc1v4TYi
         fFf1bfWJXNht6dBn9pKfd2f8N7A3cib1j4mvCENJQbDyYVYt/zBH2BP0H1YuSuvovuDO
         RWJLqdpQr+FcWuD5F99tgvOTc0qFd9YNnP5fp1eF7AqZ7F4FAD5EKSfOoWoVdP7BXgCV
         ywCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IQlS7BDnACDaCsMqM0o6ivue0vmf2zRpA7COhg03lwo=;
        b=ItQA7+yubGVmOoMMu83J3C2Tr/1DS+yiUsYtqYUfUoSEgoGb3WhqP70MzVxJ15cTG9
         qlxERGbjEixdosubNU3VkHoGteMhsR32XT86Tu3pcvUi0NdAe6IEWqzi49tLDXiozMWa
         LaZ1rmw88PpZ15rv1W/EI+Z1UOfqoWeDew5kROrOCFKIR4RyWtGIMpRXHnC3hAyrjCzT
         8LKMNlt27pqfBtbbyfaucMFeq7Z96UUFpjVuPdCF4qMCe1d64acjC8//eu4XWMUog5Gp
         RfayNZ2KlIebflxKpbFgc7ehTbA6+htXvL+x5sdBT5/uiTdsGwK0ZFDotgNFhhYBl0AR
         MKSw==
X-Gm-Message-State: AJIora8kM6GLcn1gqBCShne+SlQKeodnwbgobSm66JT7r6Xardx7wxW8
        VFVYdqN1vnts0Q0iTiVjokYtMSRQrdyqNQ2VB0GppQ==
X-Google-Smtp-Source: AGRyM1tX7i9qvwRtaWPlkB1jU+Ujio9VTofp9GoBleumYJMZajM8x6Z77tLffLe5uj3zQ0r1d7iOtk39WF8f+ycpKQE=
X-Received: by 2002:a17:906:106:b0:722:e997:a365 with SMTP id
 6-20020a170906010600b00722e997a365mr34590466eje.169.1658313442848; Wed, 20
 Jul 2022 03:37:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220719114521.868169025@linuxfoundation.org>
In-Reply-To: <20220719114521.868169025@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 20 Jul 2022 16:07:11 +0530
Message-ID: <CA+G9fYvckf9isc0eL7DfphD5tuV2jVSobmh9_acK4DZ26iLQcQ@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/43] 4.14.289-rc1 review
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
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 19 Jul 2022 at 17:27, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.289 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 21 Jul 2022 11:43:40 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.289-rc1.gz
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
* kernel: 4.14.289-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 5bd8b9267a7f243cbf509ea77626c97103c56fc3
* git describe: v4.14.288-44-g5bd8b9267a7f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.288-44-g5bd8b9267a7f

## Test Regressions (compared to v4.14.288)
No test regressions found.

## Metric Regressions (compared to v4.14.288)
No metric regressions found.

## Test Fixes (compared to v4.14.288)
No test fixes found.

## Metric Fixes (compared to v4.14.288)
No metric fixes found.

## Test result summary
total: 111096, pass: 98012, fail: 211, skip: 11584, xfail: 1289

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 286 total, 281 passed, 5 failed
* arm64: 50 total, 47 passed, 3 failed
* i386: 26 total, 25 passed, 1 failed
* mips: 30 total, 30 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 16 total, 16 passed, 0 failed
* s390: 12 total, 9 passed, 3 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 48 total, 47 passed, 1 failed

## Test suites summary
* fwts
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
* packetdrill
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
