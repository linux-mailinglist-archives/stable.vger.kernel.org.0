Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE47E1AD08A
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 21:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbgDPTnb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 15:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728143AbgDPTnb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Apr 2020 15:43:31 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06550C061A0F
        for <stable@vger.kernel.org>; Thu, 16 Apr 2020 12:43:30 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id u15so9192378ljd.3
        for <stable@vger.kernel.org>; Thu, 16 Apr 2020 12:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uwSGpCllokSfqNGL6oss9wyAqUMAat2WrC0cAMBjDAk=;
        b=v3X3C0Za2rryzPItLIrreDK5DGHhTkL1mY1pAW56x8wepKCDn00DQKL6hhYNLUJtIS
         PRVT6262ISLBiZuTuXfFLAFGb2zzHA1AwxrGM11aauK+wz7vAH7uni7cB0f23LeIgJC5
         xxrm/7Y0lNkQ8U3OxIuYarwGx/1/qZ8hbarOUOrLMJeRARh+IuZYPw9+PLcOPk4UQu9u
         d2ZYcUuRP5yBT9Yic1aAZ38qOnnrmUaC+KTG3EJudjWkVdOCCHltLxVEHlqDAJXv9nKw
         t2UN47Xp8QNSsi/sajAxtDcJ4hASk0Hh/58EIGBgu1qwrruKw7+sY2oRDuDCj0qtXtkM
         I61w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uwSGpCllokSfqNGL6oss9wyAqUMAat2WrC0cAMBjDAk=;
        b=aFi1BTAtLgup4swzYBSRyDQ3N0RuJ+wVukFD/wMrcXDPmW8HXvydDUnkSfjoEVG1TL
         OPlsgWKTBSqPj5o4OO/iGmsR9Ap7/kkJot0OQB6ORSLI0rqXe/VaeiZWOc2fFHKIG70L
         c6YwFnZ8LITD+rDyh1i/n5wWPKwafaH6lGGaYEmghUd3ZtnMNnlZ90ZwbdAETK/T9RJ2
         ESF0kklYYQOUoAag2eaj4JZevc4KfoEF4RVj0PnBCfOdiiYPjA4uMwsUeE9M27EcQiO9
         jgZsLsFjZFxhDnULFTzsDLSyVk53K4n3vswJsEitxfoxuiN8zzoo4XB2Wef8zBX9xMmP
         XcEg==
X-Gm-Message-State: AGi0PubEez5ENILAWmNK8JeCUmnGmBGpyGG4Tz0dWs9akPUPf9CGZACS
        bjqwklp6lLJpd27p2yUt6C1BNflSJbywprFNtNXghQ==
X-Google-Smtp-Source: APiQypI7zn0Ag3wpPXIq0cMKQBUYTA9vu4dBllapgvop9p2++y3RxipMd/76W4XD8OEmCb32OM6oErVgvTGFJuUGl9w=
X-Received: by 2002:a2e:6c05:: with SMTP id h5mr7329953ljc.217.1587066208330;
 Thu, 16 Apr 2020 12:43:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200416131325.891903893@linuxfoundation.org>
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 17 Apr 2020 01:13:16 +0530
Message-ID: <CA+G9fYsbb6Axbheg8urRH_Dhbm27sWqiy898WDAZRVo8bj+jZw@mail.gmail.com>
Subject: Re: [PATCH 5.5 000/257] 5.5.18-rc1 review
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

On Thu, 16 Apr 2020 at 19:05, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.5.18 release.
> There are 257 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 18 Apr 2020 13:11:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.5.18-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.5.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.5.18-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.5.y
git commit: 23ca98930364cb8a4bdc5a27feb6d7fe29668e47
git describe: v5.5.17-258-g23ca98930364
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.5-oe/bui=
ld/v5.5.17-258-g23ca98930364


No regressions (compared to build v5.5.16-45-g95e8add082c3)

No fixes (compared to build v5.5.16-45-g95e8add082c3)

Ran 33449 total tests in the following environments and test suites.

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
* install-android-platform-tools-r2600
* install-android-platform-tools-r2800
* libgpiod
* libhugetlbfs
* linux-log-parser
* ltp-containers-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-syscalls-tests
* perf
* kselftest
* kvm-unit-tests
* ltp-commands-tests
* ltp-hugetlb-tests
* ltp-math-tests
* ltp-mm-tests
* network-basic-tests
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-nptl-tests
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* v4l2-compliance
* spectre-meltdown-checker-test
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
