Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B990247DB2
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 07:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbgHRFIf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 01:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726306AbgHRFId (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Aug 2020 01:08:33 -0400
Received: from mail-vk1-xa41.google.com (mail-vk1-xa41.google.com [IPv6:2607:f8b0:4864:20::a41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14B5C061342
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 22:08:32 -0700 (PDT)
Received: by mail-vk1-xa41.google.com with SMTP id o2so4052890vkn.9
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 22:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sZJ3/gyYdiik+KpeaHCJ05p1bjMwQXfEEDjU78/km6Y=;
        b=IG0mHLZ9iuVrpBMaPoS9puVxVwEj+Y9VBMJsjBNq9rtwmIG6T8lW/Natd2y5Z3NqZH
         twjG7wnwFT8I4RE4cs75TmIUwKFx4KBInMrlnlYWWokWiypHTgH/UMaO8dTmmhh62w/9
         YFE7babolaSKLIZ2r9hKRUkpf6g7Z+LKOo4fRiM/Hsef4ER+Ud/5z4llC9iKLwYpuv2F
         r905GlEiEgfIh0jWJ/nVmuwksUdMsLgpCU8PzuxXc3MAlTurqWeFHl9gxzKIpue24tDI
         qSQ6fMA9haVeWgi/+xv2+77JAvbsRjT3NdKLU3DoIm6nSmCo6wmbOKoftmCVxHKCnc0f
         /uOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sZJ3/gyYdiik+KpeaHCJ05p1bjMwQXfEEDjU78/km6Y=;
        b=spZH7A6V/jEh5DSsdUZEgoCIWWuYXhkhu0fo6UYD2Fq9rgb9IJoS2zV77HuKm0cinv
         I1DSXIY5ElfFSbBSEjs6LdC1LncGHkpktj7w9V5dWYLkuguAfDVohxtuCTv6NDYvESMp
         W6NCV1F10Ntj06GDXMsoljDRyKar4aAfRI3eGHq+84+h4Gq5djT3mdxaDcZIHhJmtjQ1
         DOuDBEmYWQ96h8jfsp44z7XdofX8AbDvuB0XIxQq6BRBgr98MRtdOlFMqJai82lLzbot
         D1Tw2XxU0rCEULjQcuMZWUgKivrQGWpdaVNHcjp8jTgZSZ3LhelxeOiswffJ+evB5knq
         cQDg==
X-Gm-Message-State: AOAM5335WYXFGgl25+sKRO23+5KCI3WXoWq2YuYY5DMv85H6gtPCRyTU
        jCOsyTirNGH1Ju0yCfMvWVJYGQnPLayHPqi3uGfRCw==
X-Google-Smtp-Source: ABdhPJxLmM8l840nc97KipawJ7NbABrAaKbOIIoUZLgHCrDls9rk7kXMXMG52gfPbwQrLW98LC18nkD23FMHXaU74F0=
X-Received: by 2002:a1f:2fc1:: with SMTP id v184mr10187699vkv.42.1597727311418;
 Mon, 17 Aug 2020 22:08:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200817143833.737102804@linuxfoundation.org>
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 18 Aug 2020 10:38:20 +0530
Message-ID: <CA+G9fYtidMe-oYY7ZZi-cYMz1HYxdsLAX-6oJHerfr1SD6taXw@mail.gmail.com>
Subject: Re: [PATCH 5.8 000/464] 5.8.2-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 17 Aug 2020 at 20:49, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.8.2 release.
> There are 464 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 19 Aug 2020 14:36:49 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.8.2-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.8.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.8.2-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.8.y
git commit: d74026bb5bef5450a546db519c5dc961c8fae71c
git describe: v5.8.1-465-gd74026bb5bef
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.8-oe/bui=
ld/v5.8.1-465-gd74026bb5bef

No regressions (compared to build v5.8.1)

No fixes (compared to build v5.8.1)

Ran 34528 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- juno-r2-kasan
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
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
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
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* perf
* v4l2-compliance
* ltp-controllers-tests
* ltp-cve-tests
* ltp-sched-tests
* network-basic-tests
* ltp-fs-tests
* ltp-open-posix-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
