Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99EAB584A8B
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 06:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbiG2EUV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 00:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231183AbiG2EUU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 00:20:20 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 060C3E0D7
        for <stable@vger.kernel.org>; Thu, 28 Jul 2022 21:20:19 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id z23so6434210eju.8
        for <stable@vger.kernel.org>; Thu, 28 Jul 2022 21:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=V8052OoxCFZxQ2QICzkskmVQe7EcqjGGCErAAWmTSW0=;
        b=iYz7lGmX21ViArn3L+5F4D8aEu6cP9H36SJhD5LEYjyYcuMp4hG8tPE34HD/jvpypt
         4hEm3XgLESxVBHDCg9PsYDMV45dXntcASkiHTDVhUxGHU4b1AxbLNSBFQzgrpvHP4vmQ
         CgnPW6d11jXyKJwB0QYSPtJ5Tinq2Zeyi+H4N0VxVcti8M+nBBoUNfgcoLvk9JFeSJDe
         MBk/E2Gf7b2kdSisfkLX9fl/ZzS82eeozI5DO0k38enNdfqtw4rRtMbzDhVspKLLBMzj
         cpaIjiqxDw0YM/DlZ4KQuED65sQBVm/2mIlDkdty8BywbBauwwsPbo4XreXaaVZ5ztie
         FeYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=V8052OoxCFZxQ2QICzkskmVQe7EcqjGGCErAAWmTSW0=;
        b=xm2MSnPO8ruyZeduZnvsOh0lrBQWeJzCmsyGKGRMzGw0k6eaAFChH8wL9BCK/4Ot2q
         dTbQt3XssLoP7h46TZaVKpg76sKP0ifwE5GK4SZGP6XVOX+/bc8FI7CQ2h6wgMpH4XDo
         pTbFYkL9QhwI0wEYXHG3Vexd2nJ/LVl4m/llffQbKWM+GW9WCbqaRH5qhOeqMe8NeVL6
         HvcLtJYPSN8UnmqezKWejExDmntNvajrFbKZmtkJHglR5PvkAGXAXOiTx3rUopFzV9vZ
         BSzdbZLqJFm9A1LxVI3g1fOB7vItd6E1gdY36vUvxJvVTC3rDJgMeKOn2Z3PfFTcIeEf
         Dw9Q==
X-Gm-Message-State: AJIora8YwjoT2wh1SsLeCuQjB/HvEWb0IqUgTWLLwRHxyjtioFF0bxRk
        HM5gtEGeVduMpw7praAh/iuKmAZ7sxMjQPeBeDFI5oRwvQiWtA==
X-Google-Smtp-Source: AGRyM1sWz+Tv5x2i1J81fNxFl6ON0UfdY7EaNTDy4Qu9b9tROEHnpDH1OQW+Mk16tD52daJZyOxkK1ldjsSR+r5QF+4=
X-Received: by 2002:a17:906:7b88:b0:72f:d080:415 with SMTP id
 s8-20020a1709067b8800b0072fd0800415mr1504167ejo.169.1659068417403; Thu, 28
 Jul 2022 21:20:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220728133327.660846209@linuxfoundation.org>
In-Reply-To: <20220728133327.660846209@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 29 Jul 2022 09:50:05 +0530
Message-ID: <CA+G9fYvQQqRx93w9NiE=p4fAtMp3Mmqz7TP0iP5LqVBZ_na4dA@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/202] 5.15.58-rc2 review
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

On Thu, 28 Jul 2022 at 19:03, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.58 release.
> There are 202 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 30 Jul 2022 13:32:45 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.58-rc2.gz
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
* kernel: 5.15.58-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 77a604df16d58def44e0577eda0f18f8232f9a41
* git describe: v5.15.57-203-g77a604df16d5
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.57-203-g77a604df16d5

## Test Regressions (compared to v5.15.57)
No test regressions found.

## Metric Regressions (compared to v5.15.57)
No metric regressions found.

## Test Fixes (compared to v5.15.57)
No test fixes found.

## Metric Fixes (compared to v5.15.57)
No metric fixes found.

## Test result summary
total: 139113, pass: 122939, fail: 682, skip: 14705, xfail: 787

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 311 total, 308 passed, 3 failed
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
