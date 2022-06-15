Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F21754D421
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 00:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350216AbiFOWBz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 18:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350238AbiFOWBy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 18:01:54 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E144C562E4
        for <stable@vger.kernel.org>; Wed, 15 Jun 2022 15:01:49 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-3176d94c236so32157b3.3
        for <stable@vger.kernel.org>; Wed, 15 Jun 2022 15:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=h/tExdrscfX2XkOYQK2IcWElTdzHYcIsKUzNfWv7mZA=;
        b=xz58kLaB5wSeBtoZA4R+4aGfdfUAWSRrjCmCy/9Mqg1utxRV3vvZ5IzGdZTY0FGJp+
         G0ezrTH2S2/QpXOqA22SY3IRWi+2qZEz+pTczHoQQlKiThqaqkdxIlzE5OqqGaAL0ANM
         qOak6XHwXN0JiX6QcWjk+UZ0dkFL1CJYBhOgvbTmY/9zaYcZAxizCr3YBvDqelwakQKz
         6Vu9e7/b5LmzDA7s3mVTptBO9Vg1+Q1IZ3fcwLkn/f4UCaxu3AdpTORXJ+QXOvvEyEVJ
         Wun1/K/XbY2Cd/cOnFXU4aSBkavMJ79fqywhirtUU2TKRTr/hdiP2R3b6WX745H4fvnL
         ybrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=h/tExdrscfX2XkOYQK2IcWElTdzHYcIsKUzNfWv7mZA=;
        b=1N7m9KSfBgRKGdrDYqI2FVJdlmOm7834Vhyte5CRJ3Twtix76ODsbGN2PatTWGq9Pu
         ssJ1z52Y4JtbVxk7SOpHyvt6ZGgFyw6s7qlqdU1ggtnnRhCoV9Uo18yfnnh3ziTn/Fqd
         i1sA5+UZpsUj0ERdzfvFaOSbl3TFV90GAnXg5qv9Y4ZN5Rrf+tkBLcv2eyanpKGQ2hwX
         YA/zpE2B6MQfncDR7nfvmXwvptEtwkrPfJDTkfyEefWvByrQRyNf92WilJ1QPLgKts1i
         7QpDxikx6rd9wESQVPsyfy25iiLSDh4q/qmTMoiU6U0awuhvk9mdK3Qi5SsUkqB9V589
         J71g==
X-Gm-Message-State: AJIora9QX4puVq+DNCph9qmfqmzErym/nTuwALtgA2kTBbLrwsdWkVJ+
        u4YnJAyc3J5oKjY49uweCQNw5pEWdL1dgziKhc2N/MBznOzwVcM+
X-Google-Smtp-Source: AGRyM1uK0KqH/MNtIwvu4W06eVOT0ANza0kiLVaN4B8xZ+HErU5vDuw0Oh+enKf0abtzh1xz3jQKIJINqH237fyVJHI=
X-Received: by 2002:a81:a006:0:b0:30c:37e3:846c with SMTP id
 x6-20020a81a006000000b0030c37e3846cmr2034981ywg.310.1655330508891; Wed, 15
 Jun 2022 15:01:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220614183722.061550591@linuxfoundation.org>
In-Reply-To: <20220614183722.061550591@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 16 Jun 2022 03:31:36 +0530
Message-ID: <CA+G9fYvThAyMv6szcXTyn8RGKeh5RNi-MM_REzzPe+yryP4OyQ@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/20] 4.9.319-rc1 review
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

On Wed, 15 Jun 2022 at 00:11, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.319 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 16 Jun 2022 18:37:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.319-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.9.319-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.9.y
* git commit: 2b5bd1d9ab58138d38f9f2fcbf7d484e3c85d6cd
* git describe: v4.9.318-21-g2b5bd1d9ab58
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.3=
18-21-g2b5bd1d9ab58

## Test Regressions (compared to v4.9.317-168-gbb08155cd099)
No test regressions found.

## Metric Regressions (compared to v4.9.317-168-gbb08155cd099)
No metric regressions found.

## Test Fixes (compared to v4.9.317-168-gbb08155cd099)
No test fixes found.

## Metric Fixes (compared to v4.9.317-168-gbb08155cd099)
No metric fixes found.

## Test result summary
total: 95256, pass: 83420, fail: 191, skip: 10403, xfail: 1242

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 261 total, 255 passed, 6 failed
* arm64: 50 total, 39 passed, 11 failed
* i386: 27 total, 23 passed, 4 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 12 total, 0 passed, 12 failed
* powerpc: 36 total, 16 passed, 20 failed
* s390: 12 total, 9 passed, 3 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 46 total, 44 passed, 2 failed

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
