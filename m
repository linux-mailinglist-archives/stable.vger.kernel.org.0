Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E935955AA9E
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 15:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233136AbiFYNux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jun 2022 09:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232992AbiFYNuw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jun 2022 09:50:52 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AB6BFD1A
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 06:50:51 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id e40so7087645eda.2
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 06:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1oChDUl+z+6MFfIqQ2ZFGNeOpX6xbMaIIo1qtxHJ0fM=;
        b=l31g3bMLcLkvEmn5xrCrKCVe7r2aZoIJ9xFjhihxmyVmRHM8gmYNkjA1hRShS3JtRB
         aii3y2FxkT6o3yMJtZ+AnczCLSo9eMFhA9muRNz0s+UyNQb+/bRtkijitmNb6Gk/lBNO
         cGVzXxaEeLE2ScLAtZ5MTmIo9AamyFjLDFSUMOxO/5z0OXJK+zX+Zd0T+gtpYtOwncIJ
         sNzFVEEz0g05MSLPK6i7htcwlg5gRoRz4Z7FN/UqWS8T3DUJtrVL+RxrxNpAIbba61Ks
         vCXHjCgI35LTTpaV5Su3Yok3vgiAh0FeC+XQ0tC43Z9qmFAfCT5xf4Od90SV+SSuht8E
         lNuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1oChDUl+z+6MFfIqQ2ZFGNeOpX6xbMaIIo1qtxHJ0fM=;
        b=LAJs2jLo4rN7MqRBYfk6ozC0pwIRuynMCkrwsqKsM7Zwn+girA29oFPTsbqhZ9tgSt
         WXGnWL0GYmEQYh6dnpzLyQXCkax2BbbxMMQfuFgPL7F58BhDvsgHxhxJrrfFL1hwpt+S
         Apl39gpeOwP8DnRZuXqGPd2zRREsADSszc8Q7cnIT6BxLls5LN8VZZmgtJnwQJhNGvxr
         KU6rbVTbD6Wy/wnoJ5NDfxuYJvNTd1tJ9acUd9LM9Lm+8tJIAekEuy9Tk3oL900AB1RX
         M7a6b+lu4a90l0scb3wyE11Lg6NOxpaHbgVqY5w4n/niDIFDP27xlaB7iNVunaZC/eHb
         p/4Q==
X-Gm-Message-State: AJIora9e6hWfi+UxtK8liGJ/t4lY/R396XNQVZvgmLGYoxehO5Hm/ErN
        3v+CqEwNYfU1gJY2jjS8ZNEYgI5mCRG3xy+Dltm2SpVsHCXjrw==
X-Google-Smtp-Source: AGRyM1t1jJEsJXujPGzER8vQrkNRGYfBQTEL3Un2d5pTkxO4YUgLGqeoEyyPrNNYA9NwD6R/Jn1eRmfb+TnbBY7bEbE=
X-Received: by 2002:a05:6402:3707:b0:437:61f9:57a9 with SMTP id
 ek7-20020a056402370700b0043761f957a9mr5087505edb.1.1656165049954; Sat, 25 Jun
 2022 06:50:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220623164343.132308638@linuxfoundation.org>
In-Reply-To: <20220623164343.132308638@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 25 Jun 2022 19:20:38 +0530
Message-ID: <CA+G9fYuWKJ=OF7pq2wQHtxmsbLpW10onSSXRS+5BON99zBHGAw@mail.gmail.com>
Subject: Re: [PATCH 4.14 000/237] 4.14.285-rc1 review
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

On Thu, 23 Jun 2022 at 22:29, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.285 release.
> There are 237 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 Jun 2022 16:43:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.285-rc1.gz
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
* kernel: 4.14.285-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 948a36f89e96c3d3bcaa8643911949a6115da893
* git describe: v4.14.284-238-g948a36f89e96
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.284-238-g948a36f89e96

## Test Regressions (compared to v4.14.284-228-g0ecf242ba512)
No test regressions found.

## Metric Regressions (compared to v4.14.284-228-g0ecf242ba512)
No metric regressions found.

## Test Fixes (compared to v4.14.284-228-g0ecf242ba512)
No test fixes found.

## Metric Fixes (compared to v4.14.284-228-g0ecf242ba512)
No metric fixes found.

## Test result summary
total: 109413, pass: 96739, fail: 194, skip: 11203, xfail: 1277

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 289 total, 283 passed, 6 failed
* arm64: 52 total, 45 passed, 7 failed
* i386: 27 total, 23 passed, 4 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 16 total, 16 passed, 0 failed
* s390: 12 total, 9 passed, 3 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 49 total, 47 passed, 2 failed

## Test suites summary
* fwts
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
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
