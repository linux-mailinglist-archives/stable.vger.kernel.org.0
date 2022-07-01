Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABF3562B60
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 08:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233903AbiGAGS2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jul 2022 02:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234793AbiGAGS0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jul 2022 02:18:26 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B181117062
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 23:18:25 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id h5so828815ili.3
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 23:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Bdwz0tYqpNDBeePHz2QEf1aIGJX1PgK1kxd0heP96Lc=;
        b=VWGWEZ+f/esEjS6qMTcvIIhVIjRk2ToZdpmNICJ8GOC2UpbqBEUoHs9xcs96ZrQsVW
         ISy+Ya3GqpqtWvJ0HFGHGtH3PbCmPGLdMw2kWVdp06/3BZP5AG6x7rET+Y7helaIAs2Z
         VPxuZ/O41PSVT8vHq2AbirK8+KKC/riDeT07d74YKjAXT9AEXgT7QHXdHZeiAeuU6FxP
         7CF9V0GAVafMZl5zhT/4TZus2HsGhX1+2Ct04PrX5qYULrM1uqKNgODQCIJQU/2UKXvW
         1j3wRPNsQ1p8mMutIK9+USsqE1VnLdCjYQ6vB+LRQIbjmJXrp+hA/nyriN+OVMKAuxY7
         PhZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Bdwz0tYqpNDBeePHz2QEf1aIGJX1PgK1kxd0heP96Lc=;
        b=6gBvqMnl35JfDRg+t9WQQmDz7Yo7lrtXVYE2+f2LYGC5yZZQSX0jck31Wv4Xx5KJSe
         /GhqzrX96uom5GgyQhPvUQnn4lRhdV6J20RNqDel8rR3v3lfHys42Cvn6B83h7fBG5Rg
         uAeHyiBurn+qPpSo0WKpyrgH1PB3H7igkq5BfCDcAx1voEWXVoTyDrkYYL66oVF/F8FA
         G4ysBNt+bFz4mR6ymSoNBk5XptQ6PpDnmvTvmY5MabWqSaIwEONEgcu5l/ToQOUHfBpv
         zqR+xmxc0egDwxulE7SGjijHeuu0yHAYTgnCJAF3Be69mUyL7ugUAmWS0aj9YoICBU95
         oOKA==
X-Gm-Message-State: AJIora93BvsfSlTEnwrYgthiaLu/RwgqwDrw4oz4o1ZTwqTXKMrBQp1s
        sPX/ZQxE1bUoyaZeLep2JQHXLLMldKxulPzAhhRH4A==
X-Google-Smtp-Source: AGRyM1t7T4d76Qu2AlQn8AGSEL1RDiUs1IGOGVVu7+nxP23ba3mV5D32I3xZd2A9jTqLWt2RpqLWNR5vY3x15Ub++tM=
X-Received: by 2002:a05:6e02:1c27:b0:2d9:4d66:8541 with SMTP id
 m7-20020a056e021c2700b002d94d668541mr7436043ilh.176.1656656304863; Thu, 30
 Jun 2022 23:18:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220630133232.926711493@linuxfoundation.org>
In-Reply-To: <20220630133232.926711493@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 1 Jul 2022 11:48:13 +0530
Message-ID: <CA+G9fYuVx58oCN0_JCnUn8vUqdZfKkexOeGhumX1=qviP+vG2Q@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/28] 5.15.52-rc1 review
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

On Thu, 30 Jun 2022 at 19:25, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.52 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 02 Jul 2022 13:32:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.52-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.52-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 49249bfc4d1bc5a4f6c82471a12a13bcc78a40c4
* git describe: v5.15.51-29-g49249bfc4d1b
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.51-29-g49249bfc4d1b

## Test Regressions (compared to v5.15.51)
No test regressions found.

## Metric Regressions (compared to v5.15.51)
No metric regressions found.

## Test Fixes (compared to v5.15.51)
No test fixes found.

## Metric Fixes (compared to v5.15.51)
No metric fixes found.

## Test result summary
total: 132820, pass: 118669, fail: 310, skip: 12977, xfail: 864

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 308 total, 308 passed, 0 failed
* arm64: 62 total, 62 passed, 0 failed
* i386: 52 total, 49 passed, 3 failed
* mips: 48 total, 48 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 54 total, 54 passed, 0 failed
* riscv: 22 total, 22 passed, 0 failed
* s390: 20 total, 20 passed, 0 failed
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
