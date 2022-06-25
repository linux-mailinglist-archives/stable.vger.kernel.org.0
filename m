Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5FA55AAA2
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 15:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233183AbiFYNxe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jun 2022 09:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233193AbiFYNxd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jun 2022 09:53:33 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51846101DC
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 06:53:32 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id o10so7100343edi.1
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 06:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PlnmS3frLfts4lN6mux0s5tjQ529vDFTw9G/utyKOLc=;
        b=QoEbCPuiaybxD9vKnJxJ/OJcico0ecxhqrFPj8xcBa73OLiOAszuAu983vNRjesdoi
         mhuqvdgj4tcKrctX6u8Kc+6SYX8dfMsMriQc3zW+gRANolixXnj2H22fqHfzhn6wbb02
         HNMUe09HsIGGS8COFHRaJR9KRHCCL+gfSB38BrQ7a4YbejZd694v1jpslFQf1Ln2cAGB
         0YZNfNsMUQs2Nvx21sYNhRHVLatnmIVsbelwc0lRR4Vvtf10H96m0dJ83VMKlwKbqRl3
         gQMbyBate3ax2U4z0bzXqrOOh6xCT0bONVPs2u3/qIjjFwjuLzTYAfgf/e8l9J8Nobv0
         xVlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PlnmS3frLfts4lN6mux0s5tjQ529vDFTw9G/utyKOLc=;
        b=L5uoJ1fb5InkxVutdp0pGLArn5U53kMEGR9xQZg9bRXQ3ntWbJ/jK+NiDsutyZmYhs
         jfeRPCgI4n/GT6FA8eIQSUmN/x4y3MrsYLHO9kWAR3WkDlWD2VficKh2RcbAlSdYwCzw
         5ZyTBIYL5sRXDH4hPTnwnevkeF08Oulrjo6Nbdai3UWqmwN2ugFeugEnNGFZs/pp25eu
         zCdx92+mlHa61mbWu4p2puXfkrwrzpHjwqvPKO3XpeZFbfqWkMaPHTqBV9cJpmSJ7tTw
         mrKqHtluo+sYmlIBV4RuikBvzZ37Of8pGLi0rrlmL5TOD4/KBjEVjR70CGclo54DDW9a
         j91Q==
X-Gm-Message-State: AJIora/TJcVBu6RubkaR+fgmvpaWAYHIAe1107zqP69qa15x0Eqh257m
        N+y3MwratPtohh6jQPMuHr6oHSJiXB7lu2uYwVDmBg==
X-Google-Smtp-Source: AGRyM1tk7lYHdyaf5uKBTwTbZaP8Ldp9jV7HNokyMHx7y3dvVaHlZvkzUQlTKkZlNEYBDyHOFarjG/rSaIKsisECPJI=
X-Received: by 2002:a05:6402:50f:b0:435:7996:e90f with SMTP id
 m15-20020a056402050f00b004357996e90fmr5160813edv.110.1656165210770; Sat, 25
 Jun 2022 06:53:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220623164344.053938039@linuxfoundation.org>
In-Reply-To: <20220623164344.053938039@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 25 Jun 2022 19:23:19 +0530
Message-ID: <CA+G9fYuGmGKz0y8LV=LEfs00L98FDDOgRrvm-jS_5+JzgS-yOQ@mail.gmail.com>
Subject: Re: [PATCH 4.9 000/264] 4.9.320-rc1 review
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

On Thu, 23 Jun 2022 at 22:17, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.320 release.
> There are 264 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 Jun 2022 16:43:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.320-rc1.gz
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
* kernel: 4.9.320-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.9.y
* git commit: 00d9858d20e4c4b5988b85df09c79010e037e456
* git describe: v4.9.319-265-g00d9858d20e4
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.3=
19-265-g00d9858d20e4

## Test Regressions (compared to v4.9.319-251-g5de156af25f6)
No test regressions found.

## Metric Regressions (compared to v4.9.319-251-g5de156af25f6)
No metric regressions found.

## Test Fixes (compared to v4.9.319-251-g5de156af25f6)
No test fixes found.

## Metric Fixes (compared to v4.9.319-251-g5de156af25f6)
No metric fixes found.

## Test result summary
total: 104551, pass: 91428, fail: 204, skip: 11519, xfail: 1400

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 261 total, 255 passed, 6 failed
* arm64: 50 total, 39 passed, 11 failed
* i386: 27 total, 23 passed, 4 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 12 total, 0 passed, 12 failed
* powerpc: 36 total, 16 passed, 20 failed
* s390: 12 total, 9 passed, 3 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 46 total, 44 passed, 2 failed

## Test suites summary
* fwts
* igt-gpu-tools
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
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
