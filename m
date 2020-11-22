Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6556D2BC437
	for <lists+stable@lfdr.de>; Sun, 22 Nov 2020 07:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbgKVGFi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Nov 2020 01:05:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbgKVGFh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Nov 2020 01:05:37 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BDA1C0613CF
        for <stable@vger.kernel.org>; Sat, 21 Nov 2020 22:05:36 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id f20so18715166ejz.4
        for <stable@vger.kernel.org>; Sat, 21 Nov 2020 22:05:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+5dYAQDfwRInP462lOAOwrFPeGo7A/RzKlGBRG25OYM=;
        b=rrmpUWoGlptfJ6uwKQpNscZruqW1SzIGm6w0tSb6A45umwFNwjqpeosVRjFbqWVKUl
         JHdOYIoqx3A8xguTIus4pPHiOQtFxSIvnrIa1iMDdx3JXTG/y8/5ScYlL7aigW6lKGpY
         mjcDpH6WvO6lhlZMk4dfeyX58pEakGSXezlPSzjJZi4+bKraUpnm3lgIpMvg59bFn4bP
         MkW9/mvSCVqgCfCFo7JoKSQMn/QW9szsF9iSuvl8QMLpdTKtjrwL0XfX1y+Msy3OnGBy
         Vn/9coyMERKGHJbkMFDxR24OljT5Uxi7DRi1YPlYS2hwGa/hWdW1lc63As9JRtiBfaT0
         SM/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+5dYAQDfwRInP462lOAOwrFPeGo7A/RzKlGBRG25OYM=;
        b=ARXF7ebUUd5w5taKoCFwl6m4a3yVHh8824VtaRdO8fPSnCALCsuzkgXT5wmNex83Lk
         NcsJBvKmu56SM9E6rlZfQO788U3A6cLDzV3mAlX6OW41gqpVQroFiuAPQNyEmZ3XcUR3
         +uVohL9wTDQ8vxg643FrRPwQpMzs8mWnyeezzuoyx1chFvZ6/sNNWN6sHnQNQxqiFcLD
         AbCl044o3BOLYAQ8I8iWtkbJ4SzC+u6tLpHTAG+IGDEhMh/Jy+A9LoUzq1/wclIufSms
         yxoYP3Xlz9NaCKNvYvj4nnc7TyClm0br0j51+8Ss2IXWu+CLfIw1H3j698basGuJHdlj
         3Y0A==
X-Gm-Message-State: AOAM533uyRYO6aPfqJHyCzeEJdchFvE9Bnafn+DdiR2yVqhPfu/wl9z+
        rTadlRkd7kGU+IvnMEuxHnNXmc4qSMSAZ72IWGH7hg==
X-Google-Smtp-Source: ABdhPJxGLC6K+4LPSL9P5U8zk+It70+uRsbmGJ4ABMpWl04LS+5aziFYkqRdn5ztCQQ5XhlqR8yX2yijssyQqR4JE60=
X-Received: by 2002:a17:906:af8b:: with SMTP id mj11mr22597008ejb.170.1606025133062;
 Sat, 21 Nov 2020 22:05:33 -0800 (PST)
MIME-Version: 1.0
References: <20201120104539.706905067@linuxfoundation.org>
In-Reply-To: <20201120104539.706905067@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sun, 22 Nov 2020 11:35:21 +0530
Message-ID: <CA+G9fYuaLYDb18vT+Mt7+VnXQsCSVnTJxsAZn2iMOwOiX7A-Zg@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/16] 4.9.245-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        linux-stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 20 Nov 2020 at 16:34, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.245 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 22 Nov 2020 10:45:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.245-rc1.gz
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

kernel: 4.9.245-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: b75776b03db0bcff278a791d60b6ed02df615c1c
git describe: v4.9.244-17-gb75776b03db0
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.=
y/build/v4.9.244-17-gb75776b03db0

No regressions (compared to build v4.9.244)

No fixes (compared to build v4.9.244)


Ran 40992 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- qemu-arm64-clang
- qemu-arm64-kasan
- qemu-x86_64-clang
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
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
* perf
* v4l2-compliance
* ltp-cve-tests
* network-basic-tests
* ltp-open-posix-tests
* ltp-tracing-tests
* kvm-unit-tests

--=20
Linaro LKFT
https://lkft.linaro.org
