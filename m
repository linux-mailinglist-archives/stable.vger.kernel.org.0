Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1A68273D96
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 10:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgIVInH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 04:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbgIVInH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Sep 2020 04:43:07 -0400
Received: from mail-vk1-xa42.google.com (mail-vk1-xa42.google.com [IPv6:2607:f8b0:4864:20::a42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1255DC061755
        for <stable@vger.kernel.org>; Tue, 22 Sep 2020 01:43:07 -0700 (PDT)
Received: by mail-vk1-xa42.google.com with SMTP id h23so4076783vkn.4
        for <stable@vger.kernel.org>; Tue, 22 Sep 2020 01:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Yt2FxXE40DyKIruZmHohfNff1jL798z67O1KGA8m0Y8=;
        b=ndFHNcvNEMnehkfCV1OOZdQbE2xfjSG+EfDb44NKj597KtxIwIXpiHBUbscuWbZuT8
         WJzZisjD9TGop1p33rn/JjDBG8csnUps2NqkDllE9iCaNKcXpIb1W2rKJZAX+RcpSczn
         sjLYtxPPWf9G3o+7Wx8HUBbjCf4jZ2CVbgyYnqJgUBogMad/50h0dEMRb2Lz8/L5LkaU
         eCFj2xnyjcNc76pM8YpBGaCd1erkN5f/Mqc1fvQYWUw/HTTxi8tMVH4CI6A1/fFGCvk7
         boJ5HqcqrX6hNq5E8lM1ClL0lzc1kN6fwGVoiH927ymcGHUswA0Wufvm5cEmUH5XIlSu
         A7Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Yt2FxXE40DyKIruZmHohfNff1jL798z67O1KGA8m0Y8=;
        b=AKSfGpE3aI1y9yUXpmh1Ojlhw3w3bFfC4nIx4hGWSleYCBOot+e0b48pZaVwoytjNS
         43vZq4i97JG67sQkYu3EWdAWsdhdSKTeamoU1SIBddu6dzSGHUZeTCZxdgzB7lfxsHXj
         eVBgMTKw2UAg9Id2WunBTWvuAEfkrcHDs6wfmZEzAuoYBmG8G2dORExqKnUSUMsjhOW4
         dJbMTmO/tVVBFyI2u5EGd0d7TW7N+TtlX/EkaQeCaN16T0H+UnL+Mzj+Dgi+7YQ2fxT6
         aTdWyXM6Uzcr2MfLRyYuzrCkWoJjJBlSPLl8LIRIJ23nrlXa1IH/izm/oIvsw5F1YOFd
         vkEg==
X-Gm-Message-State: AOAM532NwiKW08dVjOWyqiHLt0eSY3MxklVzlFsBE/XDoHiQ/aWfdFGT
        TJ36mGo7x0N6wPnq3Gv4UIan5Mn5L9GkChR3FaraaQ==
X-Google-Smtp-Source: ABdhPJxwQb3I5pggb+9DJ5yYVy6lm4pH19RHEfP2KivZMCXx2KqbsyivqSF4SuHqCBvVy/KgWzkh0yLt7pZP0Koz88U=
X-Received: by 2002:a1f:fec9:: with SMTP id l192mr2498639vki.21.1600764185993;
 Tue, 22 Sep 2020 01:43:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200921162034.660953761@linuxfoundation.org>
In-Reply-To: <20200921162034.660953761@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 22 Sep 2020 14:12:54 +0530
Message-ID: <CA+G9fYvTgD=PtDG+zqrBnhB1zT3OeQ_B0rKOF-jdOudSRX5C6Q@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/49] 4.19.147-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 21 Sep 2020 at 22:11, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.147 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 23 Sep 2020 16:20:12 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.147-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
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

kernel: 4.19.147-rc1
git repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
git branch: linux-4.19.y
git commit: 20031549a4cc9e0c3576a84631ce04afddf88f07
git describe: v4.19.145-129-g20031549a4cc
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19=
.y/build/v4.19.145-129-g20031549a4cc


No regressions (compared to build v4.19.144-9-gdc4669f837af)

No fixes (compared to build v4.19.144-9-gdc4669f837af)

Ran 31968 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- nxp-ls2088
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
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
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* ltp-containers-tests
* ltp-fs-tests
* v4l2-compliance
* ltp-ipc-tests
* ltp-open-posix-tests
* network-basic-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net

--=20
Linaro LKFT
https://lkft.linaro.org
