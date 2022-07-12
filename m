Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 264745712F9
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 09:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbiGLHUZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 03:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232295AbiGLHUY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 03:20:24 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C667C4AD61
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 00:20:23 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id e5so7068806iof.2
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 00:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dUycJyqDvenYYYH/VqTOnjl4Z/h/l35IjPCMO8le1w0=;
        b=rn3yo0SNQxTTe2djtvKV4iHBn+WK2rumDmL20iZIniXfgSLBBtxAlo7xjpdNQkYbRS
         Gv/Y1I/RlFjd2TCQQSbSouOHYg8IjXrEPV2AkjmbzvM3mOKVaTPXZDk8PBbErnnhliDl
         VygEGtWeVUBD5RRVJzSDV6JxJ22096aH8Ajk64LzW71GHpxngkfbdsnzYiRDQjoru3zH
         Xi0t8wDRrT4RBGbO/UeRiibPWCM625Ee7Atr2k4Yq+wlewhCs7p9oUc9kpRYb0k/gza0
         urScJoSCTft05BwxIL7Bzam+mz7gMCDz+a7rsJuYSmTv0W2sm2POpcEA0HWxRJ9i7vFi
         Xj5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dUycJyqDvenYYYH/VqTOnjl4Z/h/l35IjPCMO8le1w0=;
        b=h2AQiaeaE7djSba+kGRRRq82nuIcAzRqHHdW33oxEmKoQzQkBodsAfZpihCnY0J6wG
         EIlcXfqq5JRSAvgGyjWiTiI54BBgHMqubHDnXzGWAYjgTQq0xo0yZK8ZAcED97qH7Zox
         RRiG285H+Uk0qetrgeL79k2DeAHiOC7vsWwVKE4HPUYlv3ZJud8hugbDsMFueS//jo6O
         Kxe/KKB8Za80wWFYRI+NmtOq+WA1ts3BcodG40/3ab/3/G7ki1aGW7UeIz5L7/f9vHqf
         RyoQV5e4UCnjC6lua5bUl5UF/UUDoN7daTIKjk89OrghA2KCy7ghf2lYaTDq/KleLQGu
         GXQg==
X-Gm-Message-State: AJIora+NVOa3TqYasZnqnFj/DpdTCc90BR/ZIJbWlCdkqj7hIaxixPg7
        FrtuKV2haqJaVo67GWzn+tnucx2LcvDA1tlnPv4eJQ==
X-Google-Smtp-Source: AGRyM1uCVCcBdBZex3+7eaJmEPPDblxetp7yokgtzcPuYJRhJWujGBDjqysiV98LpokvG4pDXRIg52/d6PstZEvsNGQ=
X-Received: by 2002:a05:6638:14d1:b0:339:e8ea:a7c4 with SMTP id
 l17-20020a05663814d100b00339e8eaa7c4mr12563553jak.309.1657610423028; Tue, 12
 Jul 2022 00:20:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220711090536.245939953@linuxfoundation.org>
In-Reply-To: <20220711090536.245939953@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 12 Jul 2022 12:50:11 +0530
Message-ID: <CA+G9fYtzTye0FnFMWvVjFKPRz9Z3-btLqrtAqgOL50bzz34bng@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/17] 4.14.288-rc1 review
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

On Mon, 11 Jul 2022 at 14:38, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.288 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 13 Jul 2022 09:05:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.288-rc1.gz
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
* kernel: 4.14.288-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 0dbd49ddbfc0631c761f1b19f1b733f0c1f9e642
* git describe: v4.14.287-18-g0dbd49ddbfc0
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.287-18-g0dbd49ddbfc0

## Test Regressions (compared to v4.14.287)
No test regressions found.

## Metric Regressions (compared to v4.14.287)
No metric regressions found.

## Test Fixes (compared to v4.14.287)
No test fixes found.

## Metric Fixes (compared to v4.14.287)
No metric fixes found.

## Test result summary
total: 106769, pass: 94030, fail: 194, skip: 11257, xfail: 1288

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 286 total, 281 passed, 5 failed
* arm64: 50 total, 47 passed, 3 failed
* i386: 26 total, 23 passed, 3 failed
* mips: 33 total, 33 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 16 total, 16 passed, 0 failed
* s390: 12 total, 9 passed, 3 failed
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
