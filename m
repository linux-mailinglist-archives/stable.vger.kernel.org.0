Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90F45644100
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 11:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233811AbiLFKKp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 05:10:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235468AbiLFKKS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 05:10:18 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4B327924
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 02:04:08 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id a27so13334246qtw.10
        for <stable@vger.kernel.org>; Tue, 06 Dec 2022 02:04:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ii1fTE+B02kfVtUTWpDYQosbbT5K+0NI1XuF1R/MCCE=;
        b=dhOEM8rgUZjh90uESoYUwHv02KL7KiHiuxQ7zoPPEy7IMGZSCCNVbsDKjeuSV/Lga8
         L2Ywmt4cZzGGfG488vrgGvB7YFHZazDfY50hSZd39cmCuzkEtIFrO/YVawXeqFpXzBS2
         Mc9aluVPH7oGA1HkQ/S4K7ri6o8wTBRDeLGptCsFa2RbXCi/Kyn5cZ6sYiCdzp20iYUy
         hVaWtZmLwlML86q2/2MNkrJv5Or6hSEPdk0wDbccTHUemsKSLsapMqMSO19kiue7y30I
         nEOUuaRV+X7y+V9T/MjkqXaVnL7amHB2GII9JLtuCBs2vynu9JJLXHsjsFMy3Vs5Q9PD
         qWlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ii1fTE+B02kfVtUTWpDYQosbbT5K+0NI1XuF1R/MCCE=;
        b=zb3YunX365fp4K+eUqZx5YiHiLFCn55JxrYPnf/hoKOHhm3LeAO44sUEMo8Q3+2bkN
         d1NF8urrB242bT4Ou5qg1CDuLPhexTtr7H89HbAKkpophUmd0NmUTF7pNuHxUFmP6/u4
         DsAYHbPEwKBJsObmcgIucB04oBl8WEISHYMyYz19Isp1uoYIlHoL2YXIS93p6XETjLbv
         ch2/nbkRPkvD6hNNAPoZ/TYyhG6laDX0EgY5qC5uww4VwqRBegi+6V08zusE+geMtLWM
         9cPo+KlL00sNIjMogUEf3/EeDZzoIjwXsbDArlBzqJiB9xQwRuvZzn1Nrs0VKh27oO8G
         0nSw==
X-Gm-Message-State: ANoB5pk2mmkzNII113pfvdvKOuQvo9RzTe/902xYE5oatWHdCMnh0OsI
        KNB6V+59KjYj+ysCIamCq+v5bUS42LQRhPqLfLk7Eg==
X-Google-Smtp-Source: AA0mqf7QpGTUSQHW2gfK/riBI5yp8z/XTE3+oNB2O8uaDwm3d0hZnLgAvycxQV9I897+5I6nxcYR3XMfQ5TE+FqHQLo=
X-Received: by 2002:ac8:148a:0:b0:399:a020:2aa with SMTP id
 l10-20020ac8148a000000b00399a02002aamr63446862qtj.247.1670321047785; Tue, 06
 Dec 2022 02:04:07 -0800 (PST)
MIME-Version: 1.0
References: <20221205190808.422385173@linuxfoundation.org>
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 6 Dec 2022 15:33:56 +0530
Message-ID: <CA+G9fYtR6RV8YkWe+QkLyFkNegLJgVHZafTAH8AnQyUcCnT_7g@mail.gmail.com>
Subject: Re: [PATCH 6.0 000/124] 6.0.12-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 6 Dec 2022 at 00:54, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.0.12 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 07 Dec 2022 19:07:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.0.12-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.0.12-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.0.y
* git commit: cdf2cb62aec478b66cd531a340a5e3b58a782252
* git describe: v6.0.11-125-gcdf2cb62aec4
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.0.y/build/v6.0.1=
1-125-gcdf2cb62aec4

## Test Regressions (compared to v6.0.11)

## Metric Regressions (compared to v6.0.11)

## Test Fixes (compared to v6.0.11)

## Metric Fixes (compared to v6.0.11)

## Test result summary
total: 137036, pass: 120940, fail: 3015, skip: 12818, xfail: 263

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 147 total, 144 passed, 3 failed
* arm64: 45 total, 45 passed, 0 failed
* i386: 35 total, 34 passed, 1 failed
* mips: 26 total, 26 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 34 total, 30 passed, 4 failed
* riscv: 12 total, 12 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 38 total, 38 passed, 0 failed

## Test suites summary
* boot
* fwts
* igt-gpu-tools
* kselftest-android
* kselftest-breakpoints
* kselftest-drivers-dma-buf
* kselftest-efivarfs
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-kvm
* kselftest-lib
* kselftest-net
* kselftest-net-forwarding
* kselftest-net-mptcp
* kselftest-netfilter
* kselftest-openat2
* kselftest-seccomp
* kselftest-timens
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
* ltp-ip
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
* perf
* perf/Zstd-perf.data-compression
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
