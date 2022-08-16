Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0D35962D5
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 21:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236819AbiHPTHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 15:07:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236802AbiHPTG7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 15:06:59 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1F9265665
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 12:06:56 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id b96so14742534edf.0
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 12:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=V2QDhboqj77NKyf66QBCtHxywV+jAWhOSGInRii+7N4=;
        b=aTywxyO/naqkVaqu6CsWqQ4PPO1CIio2rPyfPGFiE5xXLbboCCP+GlyftE+iVUXVwM
         xCT4teWH/35wMCxXLGl9VM67w3ZAu7K5K+DZMf6AYxALhnZ3cHcjnHETO/5VY2YIpTYs
         vyHGr9tS0lFduaUaISt5aB9HoqoqBa0GdIFmvB3t3hPBhaFsKRX249jqHqynZijUICQo
         Wgxp1bJ+9KPw3TKB+z0A+UGC18WLh/fOvHaNlYMa9w/zliE2rjGA0smTad+/ku4oUtSa
         YY/YZBCq3sfFPKk0m+pm+MCaDnWAmvdj46sqYIu9SVm5wF9Wns9VC/G9Xc2xsb8FeUKF
         /9Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=V2QDhboqj77NKyf66QBCtHxywV+jAWhOSGInRii+7N4=;
        b=G+pXs8A7/wGSZZJKNGoE6+2PhEiMHubbCYO1bFId2PnZaMh9ID4WWweaekbyWY2UN2
         jS4JqoNdI/4DAVdmpv6vQlUIy6SVc0jZ4Cn4A+9myH+9GzOQdmKw9CTEtvwmpH87/C4v
         ykcD4qj1391U8OSeZOxuuw/L8Nk3Y81ywx3FUp+S8/oJIhhW9BINHrtXnG0pgXUX5VLa
         my0qUibdTn2J6i8DkSttQKYFANcJ+9hAJwDhar4t4/mS09gQglWobDQg811tpqh2+blq
         6YyD7JTt8KJzLmDvByseHDIY1CAk4YhZJr80EJeZk282tD6Vaf1G2DApNJSDLKzZgepp
         j0hA==
X-Gm-Message-State: ACgBeo04pA/S2k/VUR0hrT8XXia85YTTeKjtjaP3AMFttmRixjf94chL
        3xQuFB4IvErRSmbOJZIHapQ8KzN7eLt+4BwXMKThPcf4h+UOJQ==
X-Google-Smtp-Source: AA6agR5fGmH4oIbpN4madkpDFFRAdm9WfqzBUZxCUTtSorjB1KybIseJG1izt8/W9M5fY7evnKt8ozjCokAmLEmvkQU=
X-Received: by 2002:a05:6402:447:b0:440:d482:495f with SMTP id
 p7-20020a056402044700b00440d482495fmr20496006edw.264.1660676815431; Tue, 16
 Aug 2022 12:06:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220816124544.577833376@linuxfoundation.org>
In-Reply-To: <20220816124544.577833376@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 17 Aug 2022 00:36:44 +0530
Message-ID: <CA+G9fYsCgoqrz0inj2Lx3fPX2SbvPhvvW=s_Qfo1CWS1OrOMBw@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/778] 5.15.61-rc2 review
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 16 Aug 2022 at 18:29, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.61 release.
> There are 778 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 18 Aug 2022 12:43:40 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.61-rc2.gz
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
* kernel: 5.15.61-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 8c2db2eab58f308a0d28c81153b59bfa5161050d
* git describe: v5.15.60-779-g8c2db2eab58f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.60-779-g8c2db2eab58f

## No test Regressions (compared to v5.15.59-31-g9c5eacc2ad1f)

## No metric Regressions (compared to v5.15.59-31-g9c5eacc2ad1f)

## No test Fixes (compared to v5.15.59-31-g9c5eacc2ad1f)

## No metric Fixes (compared to v5.15.59-31-g9c5eacc2ad1f)

## Test result summary
total: 114082, pass: 101253, fail: 610, skip: 11565, xfail: 654

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 306 total, 303 passed, 3 failed
* arm64: 68 total, 66 passed, 2 failed
* i386: 57 total, 51 passed, 6 failed
* mips: 50 total, 47 passed, 3 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 59 total, 56 passed, 3 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 26 total, 23 passed, 3 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x86_64: 61 total, 59 passed, 2 failed

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
