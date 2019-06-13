Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F138944ABC
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 20:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbfFMSeI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 14:34:08 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:40703 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726786AbfFMSeI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 14:34:08 -0400
Received: by mail-lj1-f194.google.com with SMTP id a21so19535728ljh.7
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 11:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xFA1HvjWXfIYOquKURB1WrLdmnfWnV8ZvDcbMemW+N8=;
        b=VP/HMkwQRbTlRVJP4HZxL5ZrlUyNoXOASFkzmJAXy6pAi+rGne+NBBV6Q19NYkcwj7
         TubQZUFb2O4+3tJCh+ciz6LhGhoOz9nPjx0qWIdXGUpr4pKLl5FZrrhVGHoLPZMRFGf9
         wS4M7n5QV1iQUMgh0lMD9fH5dVErdb/zwhFIabayuCW7Bz8dIBBi/wrgZmI22Ozm7nxC
         bxh7+HlZohu0RGjQqgkcithlpCflgS7dKsYTsMhdMPFY4+rDcvTwO7Z0sYv1dd5chZRM
         I7kR9Rp6/tHIAc8QR1hya3i3krfOCH4Gxh0yIy3PsMSrWtsHTVedoCMccd7PvCpTALhP
         WBRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xFA1HvjWXfIYOquKURB1WrLdmnfWnV8ZvDcbMemW+N8=;
        b=emGLIle8gyowBdVOAEc8q8320ghDLGb8fnjvNai3IXmt0GJv0XvZOQZ6MiwvYe3hzY
         0JKpXswXBtIBblFy4/6XzQci6LRpSzRIXQ6fuqpCzD8/uQZPy5bWYivyBKPEJqdvuIZc
         8nSGOrk0puO2D4tjnUfUHUt+3nD5TZcyN6/4h4Oo7KslTyFdok5Pbu3pMJaPCAQxDCL2
         g29ba5TEe1MF8QINf9lEuaJSCO1hXVnMg0xdPhWCeFXQdvcHjUL1LY5P+oBIr+uczJ/b
         TscGqv3KBrabQ31s21RCtIfZ8QwLiHXaUSnLbLML2qyPxY2N6zzEcBbfphw55W+Rrt/E
         UlbA==
X-Gm-Message-State: APjAAAXc53NnO1EWd4/X/ug4dUR68CVoUxum3I/L70hsJQO49p331ICG
        B7HyqnJMwVhkG36g1XX8Z7gLCzGwmunsKXZ5QedplA==
X-Google-Smtp-Source: APXvYqwY9CVw6eH9mEgvZKHBnlWABTBw3k1y56NpDF8i5dWBU589aPHM5lfxx5SGbEj8cV2K9z88TjdKEmRWju2BHEk=
X-Received: by 2002:a2e:6e0c:: with SMTP id j12mr25106765ljc.123.1560450846392;
 Thu, 13 Jun 2019 11:34:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190613075643.642092651@linuxfoundation.org>
In-Reply-To: <20190613075643.642092651@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 14 Jun 2019 00:03:55 +0530
Message-ID: <CA+G9fYtxiMGO227KyPn-7Wtp_LPipGQAem0F0Ffpu5j8oWyrOA@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/118] 4.19.51-stable review
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

On Thu, 13 Jun 2019 at 14:09, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.51 release.
> There are 118 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat 15 Jun 2019 07:54:44 AM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.51-rc1.gz
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

Summary
------------------------------------------------------------------------

kernel: 4.19.51-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: c6c7a311e997d044523cae077b58b1849cb8858f
git describe: v4.19.50-119-gc6c7a311e997
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.50-119-gc6c7a311e997

No regressions (compared to build v4.19.49-53-g768292d05361)

No fixes (compared to build v4.19.49-53-g768292d05361)

Ran 24778 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15 - arm
- x86_64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* libgpiod
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
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
* ltp-syscalls-tests
* ltp-timers-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
