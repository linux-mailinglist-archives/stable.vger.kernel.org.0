Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A95A28C8A8
	for <lists+stable@lfdr.de>; Tue, 13 Oct 2020 08:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389323AbgJMGep (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Oct 2020 02:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389308AbgJMGep (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Oct 2020 02:34:45 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67411C0613D1
        for <stable@vger.kernel.org>; Mon, 12 Oct 2020 23:34:45 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id m17so21019844ioo.1
        for <stable@vger.kernel.org>; Mon, 12 Oct 2020 23:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=paHAJhzKzmhLfcdIHo035oJdcdUZuP38fHZCd2BPlRU=;
        b=eGoGR0sRMZ9FtzdZgYZeRWQb3ToLNb+y2C9Gjp4K5BtS4fdVu7P3RZY9aXZxu9Xtm4
         e0bdQLWiyxpbnzgDKR+X1LXQDtp9vgbQy/joXZDhiu07D7jRVHh647e33yKhbAiVYqFD
         D9tV9ElWWn5qnYg7k9MvA7aH0O4/ZPmZKC0ybizNyT1f/Oi92PfRUIYidIRGjTGD4/BE
         D4/WL5sAvEdT8zky3MZTbNRIoDS6CqPHLnw2aIBdjuBMrmdHRYr/ecOEF0l6GhbpWWYu
         RjHJnSmJhqpyqI5qlNMQgq8fiuX6SprnXqyv8Idk42xkcb/VOZtrjoh1wJKUlrusOIzL
         ZrfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=paHAJhzKzmhLfcdIHo035oJdcdUZuP38fHZCd2BPlRU=;
        b=Fta6HGXbxDqW/CyMMb1aCEE6ImkVqQrktt6145ABJh4GuGXQEJvefNnSmse5z9Onv+
         bYycTK5V2Yml1+9E3I+9OV/GKHcnk6Sqm6Y3uZlddscovZQiUMvF2XadEmUbyoNqYzLT
         1sZd4uMFfRumuoAcHIRmRFHIUQQLdQXJPvcDGTiMwLByW8rPJ5RdPt3dwVFTAqn7fxqt
         xFzd4vFvluBINTQlqctD/G1E5zciMCxsP4fL5k+2Bbqw9q9pRqQzkU6NKiJKpQfF/OXc
         OzOTfnEtU6xCmJJvm9oArmLYyAAX8m5ZzJtsURnLT6OrBNCNAv4DHCwv4PhAcmUQnmRM
         pIog==
X-Gm-Message-State: AOAM530hO0MxqsmIJ3fKyZTAtgmESaJEnSABhnvQQ1Day+2JTkg7J8BO
        dAbVBMk3rbkD68IRH2mcNjpz8ceGTIQfGab6RwL9HA==
X-Google-Smtp-Source: ABdhPJyH6IiHa5B8u6iWcy3GP82gfpxfmqrlWPhucVsq0mpliopYqRHHOe3Y/Bk/h75z1S/YsENSavAoEpFIhulYU4Q=
X-Received: by 2002:a05:6602:3d5:: with SMTP id g21mr12054993iov.111.1602570884579;
 Mon, 12 Oct 2020 23:34:44 -0700 (PDT)
MIME-Version: 1.0
References: <20201012132629.585664421@linuxfoundation.org>
In-Reply-To: <20201012132629.585664421@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 13 Oct 2020 12:04:33 +0530
Message-ID: <CA+G9fYsKsbAa_uXxakPZFyKVEsGPBF5DdqvEgiED7zQ8oOtPDg@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/54] 4.9.239-rc1 review
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

On Mon, 12 Oct 2020 at 19:04, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.239 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 Oct 2020 13:26:14 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.239-rc1.gz
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

Summary
------------------------------------------------------------------------

kernel: 4.9.239-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: 132affe7fbd620235ac2d7fefa7051090b58f392
git describe: v4.9.238-55-g132affe7fbd6
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.=
y/build/v4.9.238-55-g132affe7fbd6

No regressions (compared to build v4.9.238)

No fixes (compared to build v4.9.238)

Ran 25800 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* perf
* v4l2-compliance
* network-basic-tests
* ltp-open-posix-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
