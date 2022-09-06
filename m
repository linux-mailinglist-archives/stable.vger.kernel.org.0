Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA08E5AF676
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 23:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiIFVAR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 17:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiIFVAQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 17:00:16 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CA99A2DAF
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 14:00:14 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id z8so16795381edb.6
        for <stable@vger.kernel.org>; Tue, 06 Sep 2022 14:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=jotNFZZpx7q+Hddf2s2cEezz+cM8xu236TrRMUfn/lo=;
        b=E1thR/XoXOaJz29LuoXaL2MBxixwTlI88dRgIbu0hFZjVdGcGOkAVvQWfCXnh+jG3X
         nt76pa8Fkui4H2sYo2Ta1ee/FESoT7G/B+L0HGcwlBIGm47T4ZeIP9JncdZQCki+FHYR
         Q9PeR2+rUeCNmWXkvnf4ICXOIfUhlDc0rYnQlLp8PtI3f7zkyVRmBkn+eynlAylN5zk8
         Wfihyb/ri81bYPkOffY5O2gS7CNSgdiZhgy4AK+Gf1yyc1LBG9/t5FBPvVMKvqWwr1DM
         bB/TC6wXmp5jia7jdh0K5JpWBy4BteKG9H3G7M3P2JmAzhYvXupmly/8KMuVFGiRSd7C
         9sZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=jotNFZZpx7q+Hddf2s2cEezz+cM8xu236TrRMUfn/lo=;
        b=xIU4bnPmp3+BCAtGr2etg1mBxNoBgSTOLb0ejXeN1Z2N2kjQp4fWf9Wpmk9Mt6wwPA
         wqW5PLr3O1glcAwIjX8nHgQOZV0vtjp3SR5OpgYOj3iFjFHnCcygocEv3r4iTlF9WWuE
         wJJvTc6HNj2ZSwH7gas8TmI8TLducoRtSiggfcPKvazmTcFQHuP5oyfeL+9ctM0W8CU5
         RwB4cOHXcH2VhcqHUhg7lEKRpgMJOzAMdRvQgUJ38XwKSrRGHCxvvnK1pWPSIPYxInt3
         zX3+HDCicNtluo4BZd3CfuXtL0I/wNLm+rPB1fgeYoj6M3YaOkLi7T65EjRXdZvYQFMR
         jzHg==
X-Gm-Message-State: ACgBeo3dsxHW4vK8sf91ZFrfP1a1A0wqA8S1Vowx9Hh7i5KJzzb39v9L
        ybQJuGbt2s0olFaPTYi06RsPqR0y/8/984k6iPsjgA==
X-Google-Smtp-Source: AA6agR4QXokKI4S7GBxBJzWo+uW5DE0GDwh3Weqo4J3fenJg3A+nQwByYRe+jQLT9dyryE9LxXFguqVzoKYkNCv/j0Y=
X-Received: by 2002:a05:6402:27cd:b0:44e:c4aa:5ff with SMTP id
 c13-20020a05640227cd00b0044ec4aa05ffmr396335ede.193.1662498012786; Tue, 06
 Sep 2022 14:00:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220906132816.936069583@linuxfoundation.org>
In-Reply-To: <20220906132816.936069583@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 7 Sep 2022 02:30:01 +0530
Message-ID: <CA+G9fYsxAwv438Mmes4ZsotM+Sg4Su_F6jfKAkKrxj5BoU=CkA@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/80] 5.10.142-rc1 review
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

On Tue, 6 Sept 2022 at 19:03, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.142 release.
> There are 80 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 08 Sep 2022 13:27:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.142-rc1.gz
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
* kernel: 5.10.142-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: c5039c99f55583831340c6e37ef2284c6e0f2f80
* git describe: v5.10.138-208-gc5039c99f555
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.138-208-gc5039c99f555

## No test Regressions (compared to v5.10.138-127-gc59495de01ed)

## No metric Regressions (compared to v5.10.138-127-gc59495de01ed)

## No test Fixes (compared to v5.10.138-127-gc59495de01ed)

## No metric Fixes (compared to v5.10.138-127-gc59495de01ed)

## Test result summary
total: 82101, pass: 73607, fail: 517, skip: 7728, xfail: 249

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 333 total, 333 passed, 0 failed
* arm64: 65 total, 63 passed, 2 failed
* i386: 55 total, 53 passed, 2 failed
* mips: 56 total, 56 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 60 total, 55 passed, 5 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 24 total, 24 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 58 total, 56 passed, 2 failed

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
