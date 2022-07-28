Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52565583BC6
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 12:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235740AbiG1KIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 06:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234937AbiG1KIt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 06:08:49 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0FD2A96D
        for <stable@vger.kernel.org>; Thu, 28 Jul 2022 03:08:48 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id j22so2337761ejs.2
        for <stable@vger.kernel.org>; Thu, 28 Jul 2022 03:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5S5jjFPg+8R+2tlByEvVLuWXp3ngjrRt0G1NZh8FJZ0=;
        b=F/g+jqgAKlBrdUUtnu0gPvO/qG+p5hslWLrHNAI/JSnPX6M/qeN9YXQNt8ck7HWTja
         XXzBJsyDpFPIW/F+DhNc/oAWtWe5EPKvHkB+XwusEp/cc9Am5DH5OpBOX9Lq762epyeA
         lFZ8jKJ2jo8kdG5VvfVtfR7fAFW94/JtGDW96z9T4QeJ35VMWfsimUV8GmZ1r1i0ZiTD
         JnFyaG23Hzz10dLJxnDeisAvcLR/8gXfL7Ah4oW+03ntifAhKZhGdQ4+ulRND9AbwpPX
         SRqYDiR934OiEE6nt1gAxsLUbNESTub2G63fWxcQOHMzHEXWbB+x7GgfoeQ3AyEOwFrR
         kkFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5S5jjFPg+8R+2tlByEvVLuWXp3ngjrRt0G1NZh8FJZ0=;
        b=hAHlntIgYCY4XOf+fqhyvkwuE42v3Xlc/0J1K9xPnxgQb7L7LEBYWnY1+tn5KID5zo
         1fXgLiu767uxyzfI64DObax5/A07ncrOZE608mLOyG0JcvHMO+L/IN86ErzTIskFvLuq
         D1rPDbtF0SKZjQL1WBqiJN6AODJYRYc3wRZK6KNPkhKlbqyUWmsrG4USwIlW91q4rbQ7
         Qb7zZIn2Z8vF2Ev3eLRpzjArSCRnelit7FZYyVLUEhNvd0Ay+BCng9yqstwZ4FFSflzR
         F4KyVEl00epLYOqrkyoCHcuMFpkMPbvy6kbpzGVWI/nNwkl5kWQtnCY6OEYanthajIeu
         2wlg==
X-Gm-Message-State: AJIora/WZaJ5gVY6ENyd0PdKzq7RRmbHCdHK/mGXIqJkjeEzrkG0Rdtf
        35xbKvuFfU6uoGj/nCpV9184u7ZTB6RYHGnTw1ravA==
X-Google-Smtp-Source: AGRyM1sTtDrve8cAvAXLCI6yux5bsYlH/3R7hC8AA1P2GwKoIDZOgZ28ICjw2wM9HQpi2Ahx7jpKhJPSk0dbGwX1XeI=
X-Received: by 2002:a17:907:7294:b0:72b:1ae:9c47 with SMTP id
 dt20-20020a170907729400b0072b01ae9c47mr20587494ejc.253.1659002926982; Thu, 28
 Jul 2022 03:08:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220727160959.122591422@linuxfoundation.org>
In-Reply-To: <20220727160959.122591422@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 28 Jul 2022 15:38:35 +0530
Message-ID: <CA+G9fYuhNz64Ov4yqz-YSP8KjHY=vdyTRcfDdKuc02Y-LJESMA@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/26] 4.9.325-rc1 review
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
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 27 Jul 2022 at 21:52, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.325 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 29 Jul 2022 16:09:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.325-rc1.gz
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
* kernel: 4.9.325-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.9.y
* git commit: f3e4570fb8c30c0abe735f2a6b0601cb82660ecc
* git describe: v4.9.324-27-gf3e4570fb8c3
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.3=
24-27-gf3e4570fb8c3

## Test Regressions (compared to v4.9.324)
No test regressions found.

## Metric Regressions (compared to v4.9.324)
No metric regressions found.

## Test Fixes (compared to v4.9.324)
No test fixes found.

## Metric Fixes (compared to v4.9.324)
No metric fixes found.

## Test result summary
total: 68055, pass: 60210, fail: 223, skip: 6314, xfail: 1308

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 254 total, 249 passed, 5 failed
* arm64: 50 total, 43 passed, 7 failed
* i386: 26 total, 25 passed, 1 failed
* mips: 30 total, 30 passed, 0 failed
* parisc: 12 total, 0 passed, 12 failed
* powerpc: 36 total, 16 passed, 20 failed
* s390: 12 total, 9 passed, 3 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 45 total, 44 passed, 1 failed

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
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
