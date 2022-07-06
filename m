Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70665567EEF
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 08:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbiGFGuA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 02:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiGFGuA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 02:50:00 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE4D183BB
        for <stable@vger.kernel.org>; Tue,  5 Jul 2022 23:49:59 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id y2so13164561ior.12
        for <stable@vger.kernel.org>; Tue, 05 Jul 2022 23:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uFDUO2lAtaxUOCJBS2ybIr+5lde/InUJE8Yl1U+lpWs=;
        b=wQhWsZSXlYZuc3tsKlLEY8XAEjPfpGE2UyUV+CBOptqTUv2bzGDoxw+POl3QYd8cfQ
         h13vT8ZBNDjIVgCySlXafLhltyfjaRyFoO0PmcfExZ7h00nhrPQWTf+cSScpLcgTkN8o
         Nh3NevvAS6oxyjJOlp9pd3ADcyqkacvZZkQXr1WAG+Eqw0cb1VjmoT4KRQcPUYltO6J3
         QhxTET39/MzUpkLRnEJDog/dSKRxph/5TSC81EoOzrgjAwAalrI0z0GwwodSQqzLjh+y
         y69DHlokDfiyfMKsikhziXr0jjLlfL405IPE5SQHHr2LjdxSLFUgducWnnTepAYdFqHK
         p/cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uFDUO2lAtaxUOCJBS2ybIr+5lde/InUJE8Yl1U+lpWs=;
        b=T0o7hOfsHj9cMXOFr5nYAGgL364GSbm6IFpRgjCrtDudAh8kSC/fHkiuZeNM+LDF8Y
         emFJtI76g/DsQW+yevFOx+C7mf7tZQQ0H8+lBY38GPKCScQfCss6UKzILO5g/DeUGfOa
         eX+OjKtW0DQ2oALN7lX9LT87mDUue2YA4Yyj8VVAay9xYjGU+7iohjNViLztZPE99gjx
         XQLre8gazIo5cMcaylN6e7HOh9HtJu7o/k6lslSEL6my7KjCF+9Qu3mmp9WyXH/gJlMi
         HnGCPqskjTPNeWpO3pRx7vq5mMBI5PG5Wx1VZow64VfE66eY9kw+JnUqToPNKTm909qo
         +Uqg==
X-Gm-Message-State: AJIora9ujpQ00/uaME107T1FaUVnQ8biXAzs7A/eM8td9jVleVWzhMyi
        FtKIN8nr39djHDciXPw/xMZaq+B8XryVzFqp56a5PgdLrXF2xg==
X-Google-Smtp-Source: AGRyM1tI4BnB0IlXUrHASo+brHHOLx1UgGRWVVnIaNTUbtgW7nOuQQCrO9CknvMTDJrOqBfgm1faDTCdr/sPMdxyWE0=
X-Received: by 2002:a02:606f:0:b0:335:ae88:68c6 with SMTP id
 d47-20020a02606f000000b00335ae8868c6mr22946278jaf.320.1657090198340; Tue, 05
 Jul 2022 23:49:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220705115615.323395630@linuxfoundation.org>
In-Reply-To: <20220705115615.323395630@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 6 Jul 2022 12:19:47 +0530
Message-ID: <CA+G9fYs4NHw8c5ROriWtTr5rZK=LtBTTNfE_YOoYvdB-k2k=4w@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/84] 5.10.129-rc1 review
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

On Tue, 5 Jul 2022 at 17:37, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.129 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 07 Jul 2022 11:55:56 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.129-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.129-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 29ca824cd19ac67c8cffb76d419103432e92223a
* git describe: v5.10.128-85-g29ca824cd19a
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.128-85-g29ca824cd19a

## Test Regressions (compared to v5.10.128)
No test regressions found.

## Metric Regressions (compared to v5.10.128)
No metric regressions found.

## Test Fixes (compared to v5.10.128)
No test fixes found.

## Metric Fixes (compared to v5.10.128)
No metric fixes found.

## Test result summary
total: 127412, pass: 114362, fail: 281, skip: 12114, xfail: 655

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 308 total, 308 passed, 0 failed
* arm64: 62 total, 62 passed, 0 failed
* i386: 52 total, 49 passed, 3 failed
* mips: 48 total, 48 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 51 total, 51 passed, 0 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 56 total, 55 passed, 1 failed

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
* perf
* perf/Zstd-perf.data-compression
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
