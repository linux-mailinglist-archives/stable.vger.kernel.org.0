Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B250A552D31
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 10:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347633AbiFUIjC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 04:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346120AbiFUIjB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 04:39:01 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C0DF237CB
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 01:38:58 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-3176d94c236so123480577b3.3
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 01:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iDh+9LhH+7tiFhNIMTxT+tgZMwcqOqSYnB6tz36ZBuM=;
        b=cZWfvaBa7DUk9Ka+7zdYwrlUnbvZYH/z0ztWmH50eK9pcnb7YWPUMAFeT1BkGZ521N
         bmO9izfLOA72Mxt/3nXD9iTSoUKehZXNBFQQRe5atnVeCZbMJzj38rL5jkWqbtGIA/yy
         8xywKLzZOawg3kkg4DfNE5y13tabfeEXyr9oZQH68jp9ztngA4Kq4cSfBpSv2nE4IU3x
         VnGS3jeejQNzPo/S0qAudmZlHzvUqSt04SYdYvwTFKlxaUTwUpztsdQuuUn5DmArl8jl
         cdWd/hB8PqYTF0UVyQnr+4T8g235SqOejnyo9iND4FL6XWE7ucSEAdyxgonvK+cr66cE
         tAZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iDh+9LhH+7tiFhNIMTxT+tgZMwcqOqSYnB6tz36ZBuM=;
        b=qYTqcy2kV6VywhH31A3982HwIM5tfbuH3p5kfnJgUCjmet8qsTfVfuNZMi0ux7tYrp
         c7mJy3Zf1LYAf6h9xhULHRzutX4er15+WQdBeXDTx6ddckQmYZxTJH5kzkcM2JgeF2rB
         ui3ovkj8kgkRkyupsoh5j5bziqhqMymG5cJmKRKQNwP7h9zxOYULVuor6BGlb44Y5im9
         rz9L0wO+9EsTdxeB0t2t/53/ZcoWD+99Nb1I8sn7RTIhKIl2wVsZ7dGwACtExBCSVWuC
         LJviPcOqMJp42lXjASIuSitIwvOf6t34/lYyYdspsJqx9IuHU+bA5HS4H0ImCqFOv4m8
         VcVA==
X-Gm-Message-State: AJIora+7mxddfvMvczzql3su2IsA7n4ywJbkYlUk7Kg4/b+D670IA2qb
        iXPWCu0AWSu9dC8r/jk5yqJOrw09qhKmyTBR6mWfGg==
X-Google-Smtp-Source: AGRyM1v6TiGSjpc0+2bEY+4ZPExkxwwkypY/E4ibB/ZTz2624OuqSDhfJ143FwEfOhHihVxnOfufu1vCV9jmCBRiw6Y=
X-Received: by 2002:a0d:f242:0:b0:317:be2a:83df with SMTP id
 b63-20020a0df242000000b00317be2a83dfmr12187371ywf.376.1655800737119; Tue, 21
 Jun 2022 01:38:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220620124720.882450983@linuxfoundation.org>
In-Reply-To: <20220620124720.882450983@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 21 Jun 2022 14:08:46 +0530
Message-ID: <CA+G9fYst-M64OjAipip3FUZ+JrVJAh24+FT132JEbSDZxti95A@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/84] 5.10.124-rc1 review
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

On Mon, 20 Jun 2022 at 18:31, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.124 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Jun 2022 12:47:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.124-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.124-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 1432bd558ac04fc517d64312c7d2e7fbb4a76dee
* git describe: v5.10.123-85-g1432bd558ac0
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.123-85-g1432bd558ac0

## Test Regressions (compared to v5.10.118)
No test regressions found.

## Metric Regressions (compared to v5.10.118)
No metric regressions found.

## Test Fixes (compared to v5.10.118)
No test fixes found.

## Metric Fixes (compared to v5.10.118)
No metric fixes found.

## Test result summary
total: 128188, pass: 115128, fail: 258, skip: 12239, xfail: 563

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 314 total, 314 passed, 0 failed
* arm64: 58 total, 58 passed, 0 failed
* i386: 52 total, 49 passed, 3 failed
* mips: 37 total, 37 passed, 0 failed
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
* perf
* perf/Zstd-perf.data-compression
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
