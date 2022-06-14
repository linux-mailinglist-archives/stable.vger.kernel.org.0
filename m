Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4DB54BA70
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 21:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345205AbiFNTS5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 15:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345569AbiFNTS4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 15:18:56 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E4F029CB5
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 12:18:55 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id k2so16790665ybj.3
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 12:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=L41K/nUtMkPg9Dl41+V+fctc/ODExmLTkg28LyUd9jg=;
        b=IJvjWedukeuMVjpF0p63qatrkqjklIBem4zgC9bAO9lDEAHYfvBXBAw9GYnSm1y5U/
         yUbHJTtezIIE/p3dNBvQPF4KcBvzvUnatd81kvsIQH0sraXbOqvOaD5a4DR4asx0D8oP
         QPe6MA5ZDobUOB+PiyNwz+AB6gxiZFTVXNWqv6QQf+LrnriaJVagjw0pQk56Rpd+QWlE
         RzUDyML5p5lfOeGeTVPnOQUJ3vZzPpB6hWTSp+YNye5WL9sO4IxVc05u3NrDmV8obP4n
         wLEK4DEqyGBeZQY4lhWWMIGMJ2CQllfszNTgQW+OPn4lP66r6WzvbhsG18tXBSfWojvk
         ysRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=L41K/nUtMkPg9Dl41+V+fctc/ODExmLTkg28LyUd9jg=;
        b=dW7lVLIYFKawbNpWlmK4N+reTl1KrRMyZhvTQ1qsfkw1PYbmCP+vdT90S54qdWl1Xo
         V0tyi3jCb8X3a7ULK7yhRSCaaUEceNQht4U520R1KGLkuWVbeBou7ekr1dLqP8QVbg0b
         ypqqL6hTPJm+LqCjzMLxZjBrtL68HAmO+Co5U9tWVXU7zcPOxut1UFi8tFJTZrfLqsAv
         /tlr0omW/VhmMS0oS3KTZPWx/hbTXEKd/bEHlSJ9+6lrvHMaX0wCnpIQdwL9Y3i80OF/
         fpHponKamYPIVPT3L6UR9CgswCoMzlVDx+kYTWkQJP7c+27f6tKVX0dclOKXRZTnBkni
         KsoA==
X-Gm-Message-State: AJIora986UPBxgbdUWdLkOjTGV5p03PiO6zp5uMmiGIXv2/key5Z3CQb
        AjRkKYwh7p6q6WL3aQDfz3XYHZ9Cwqt5y/qTjVa/lA==
X-Google-Smtp-Source: AGRyM1tLmNKUE/nn5Hq+v60Q8Xgwu9+LVEi00wqLdfcprAC0aeIyhG82f15mH2ue0Cxj5pXOJ7FoHyPe0lgFGK/Oqkk=
X-Received: by 2002:a25:b51:0:b0:663:4ff1:d20d with SMTP id
 78-20020a250b51000000b006634ff1d20dmr6308855ybl.608.1655234333980; Tue, 14
 Jun 2022 12:18:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220613181847.216528857@linuxfoundation.org>
In-Reply-To: <20220613181847.216528857@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 15 Jun 2022 00:48:42 +0530
Message-ID: <CA+G9fYvcLh55sHHh=_9Or-BQcjOPuNdd9XTwgBuxxT=Esvynqg@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/251] 5.15.47-rc2 review
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

On Mon, 13 Jun 2022 at 23:49, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.47 release.
> There are 251 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 15 Jun 2022 18:18:03 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.47-rc2.gz
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
* kernel: 5.15.47-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 677f0128d0ed8a3d320b74e8e35b214163070d47
* git describe: v5.15.45-920-g677f0128d0ed
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.45-920-g677f0128d0ed

## Test Regressions (compared to v5.15.45-668-g53f46ca17ebd)
No test regressions found.

## Metric Regressions (compared to v5.15.45-668-g53f46ca17ebd)
No metric regressions found.

## Test Fixes (compared to v5.15.45-668-g53f46ca17ebd)
No test fixes found.

## Metric Fixes (compared to v5.15.45-668-g53f46ca17ebd)
No metric fixes found.

## Test result summary
total: 128456, pass: 114638, fail: 265, skip: 12605, xfail: 948

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 314 total, 314 passed, 0 failed
* arm64: 58 total, 58 passed, 0 failed
* i386: 52 total, 49 passed, 3 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 54 total, 54 passed, 0 failed
* riscv: 22 total, 22 passed, 0 failed
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
