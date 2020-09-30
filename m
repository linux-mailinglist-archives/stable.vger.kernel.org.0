Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C86227E33E
	for <lists+stable@lfdr.de>; Wed, 30 Sep 2020 10:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725779AbgI3IFF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Sep 2020 04:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbgI3IFF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Sep 2020 04:05:05 -0400
Received: from mail-vk1-xa41.google.com (mail-vk1-xa41.google.com [IPv6:2607:f8b0:4864:20::a41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9936DC0613D0
        for <stable@vger.kernel.org>; Wed, 30 Sep 2020 01:05:05 -0700 (PDT)
Received: by mail-vk1-xa41.google.com with SMTP id k78so215188vka.10
        for <stable@vger.kernel.org>; Wed, 30 Sep 2020 01:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bJf9EcQGtx8i8vRwho8onBKbPOEqg4j6uiNOsbNhNao=;
        b=yhm2JF3v2s0OcWI+WA4E9BjQwwpL1RqLpWbnJY3yiop7OZR8QsYWBgDqhekQEPC9g6
         fxU2te0hgZ8h6FDQiQRiQOv3QSRjSYoK55HKp34koEYgnZNYGtI7R/qvFjc+2XzrZ6iT
         LHwGclTbk5aHGot1W1MAhCjsNH0fA1jA6G6oWtExl9WOcEUp/VPQledOTaKmBx5FZc/k
         RSwk8PIInhEclzY9+4huNuwRnLYwGJ7Y20WAYECC2eNR9sYnGrK+UNs01IpBzmXFtDzI
         Zy0Ak52mWTUkrt4WaHfScuOBmw9CdDHRJhrOnCXR2qjZLwgXrd7JxJoIIaxcA6Te/CnP
         GLvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bJf9EcQGtx8i8vRwho8onBKbPOEqg4j6uiNOsbNhNao=;
        b=M5FVveR2XgBMzdJKkuBKKrsqsjih4FrHw/x8ymZsLrBCuaQJkjQJaDCekFt6xDuVqc
         aqDDUMavOkE5ocZ/5UCOgAgTEPJ81TP3GdIOVRlIU/PciwQonTQX8WmJDVbTpyv8SKee
         m4xqya5Sqc/LyFDt8lMG4FApimGPxDYeu+QmzpSAnEXqMjccNlbef0NBArLlmhfJ8m90
         aUVkqvYck62PvVhTVvJCb/Ehex8HjoAHbWeSfczCw372ESUN9dCJ1SdiEIe9x00bRTVM
         7PfYczaXYxI+hZ/Vsd7NKWxKKN1/tXlQsXiK9SWKedfMZ2rcbE/9TkRN0wpS1J727mFi
         zLnw==
X-Gm-Message-State: AOAM530yqSlpVkJME8iGrqNnsmGm0rUd7NJ8OHvIWuXrel1O/cPpy5nZ
        iIgMYnha2V/DbuUGN0NRZbHjp9Wu8DbaprOvJ4+otQ==
X-Google-Smtp-Source: ABdhPJwfuBYnHEwK0CTYxYDHFchbWstcUrCB7pReooB//uy/Dl76Sy/fK27xYKCxzdOnyz/jNMUJgO0NPTv2ZnmDfYM=
X-Received: by 2002:a1f:fec9:: with SMTP id l192mr605959vki.21.1601453104561;
 Wed, 30 Sep 2020 01:05:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200929110010.467764689@linuxfoundation.org>
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 30 Sep 2020 13:34:52 +0530
Message-ID: <CA+G9fYveaJ147DokEVYPSJ2WZ0yeX=3soNnuak1LDC0Yzb_avw@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/388] 5.4.69-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 29 Sep 2020 at 17:05, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.69 release.
> There are 388 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 01 Oct 2020 10:59:03 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.69-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 5.4.69-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 256bdd45e196b3d68513dcd043370c3809a97654
git describe: v5.4.68-389-g256bdd45e196
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.=
y/build/v5.4.68-389-g256bdd45e196


No regressions (compared to build v5.4.68)

No fixes (compared to build v5.4.68)

Ran 27670 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- nxp-ls2088
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15
- x86
- x86-kasan

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* perf
* v4l2-compliance
* ltp-cve-tests
* ltp-sched-tests
* network-basic-tests
* ltp-fs-tests
* ltp-ipc-tests
* ltp-open-posix-tests
* kselftest-vsyscall
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
