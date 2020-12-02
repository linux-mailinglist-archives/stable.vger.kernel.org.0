Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCD492CB4E5
	for <lists+stable@lfdr.de>; Wed,  2 Dec 2020 07:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728602AbgLBGPE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Dec 2020 01:15:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728601AbgLBGPE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Dec 2020 01:15:04 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A945C0613CF
        for <stable@vger.kernel.org>; Tue,  1 Dec 2020 22:14:18 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id d17so1355386ejy.9
        for <stable@vger.kernel.org>; Tue, 01 Dec 2020 22:14:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EuICHgSSDwR0PQ8D2vWp77EHBQ0KIkrC0mpkYP8zoyA=;
        b=QGKkzN4V47I8IDWe3smCmOlOTISqCu6/q4DKaO9lz5hEvD0QIaT5Dbf49OcuJ+7mgc
         AxaEa6mMWNG86kTlKDbbLPxOzE9yJOwH5FRzsV9tPigz+386yx0C/Vn5taUMO3wiEYHP
         XOasFdH0I7P5zlNUfAdK9IuYw0IsSQayOFmxjWljZY6vuuO/8B+LbKxDJ2C9j/kMJ7mZ
         J3p1tXL0s1e8YXRI2E2mdy+jxJl6l8Yhp/YcqnKNEuK+QczY6e0QmGOPyxRdRs3wUP1c
         X7HBeNCzRYAx5YbNHD458uXNErZ6Z0Fsel/Rv9iG6H3QzENYzpGNfuxtK0PXSPctiM7H
         F1IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EuICHgSSDwR0PQ8D2vWp77EHBQ0KIkrC0mpkYP8zoyA=;
        b=YTNU5N+4ThnnI5O8oKJcKwGSfchaiYo42ZqqGhtK0knWGjvpBHpdYgVSfqNlK5sNMV
         qc8Ecvc4SNI4Ksyu6RFhVxQNOG9mGe4iHwJzkliUrnxuFOEZ2/G74rEhpDVD6m3Jihg2
         iTEPFhL8dy55jIxFxkDMJwPGc1ZkkuDfu7DrBDDNpjHmGD5FH0yQrLupU8cE5jef6n2U
         sWu3Q1FANzdwlB6FTfzOWvrotD0rkxtdjEfFsWSf7YeLEvWKA6NwXqcUpTL5qXuXt9hH
         JqfVhtGgx1kO1PWvLDIYEJvTE+V4lrudaOFAszXrEbLJXCiJTubj3ptJtF98h5ZksSg8
         co5A==
X-Gm-Message-State: AOAM532KSjFHNNLwRAt3xwDURNxBaxozNGEnRhxohl4z/P9k0KIJXLR3
        dwVnQ9Mc3usw2H1lzL3xCickJKyQe4KOC0DBMVD+2w==
X-Google-Smtp-Source: ABdhPJzdZlJea73AeLYu92Y+ZvWcNM20R9dDfFH6P6h9mr+p04eyH5vuUFiGhuF1c2jj46FSLBD5ysR2FJI3XmqAyUQ=
X-Received: by 2002:a17:906:bd2:: with SMTP id y18mr836262ejg.503.1606889656578;
 Tue, 01 Dec 2020 22:14:16 -0800 (PST)
MIME-Version: 1.0
References: <20201201084642.194933793@linuxfoundation.org>
In-Reply-To: <20201201084642.194933793@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 2 Dec 2020 11:44:05 +0530
Message-ID: <CA+G9fYtERgH=zTCzBeN40eQtdiO5Y23bsmSjmn2Htc7EsD=xqw@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/42] 4.9.247-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 1 Dec 2020 at 14:26, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.247 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 03 Dec 2020 08:46:29 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.247-rc1.gz
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

kernel: 4.9.247-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: c2b4ff37ba1a5a9bbb5160e311d472b8185fb347
git describe: v4.9.246-43-gc2b4ff37ba1a
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.=
y/build/v4.9.246-43-gc2b4ff37ba1a

No regressions (compared to build v4.9.246)

No fixes (compared to build v4.9.246)

Ran 24845 total tests in the following environments and test suites.

Environments
--------------
- arm
- arm64
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- mips
- qemu-arm64-kasan
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- sparc
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* linux-log-parser
* igt-gpu-tools
* install-android-platform-tools-r2600
* kvm-unit-tests
* libhugetlbfs
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
* ltp-tracing-tests
* perf
* v4l2-compliance
* ltp-syscalls-tests
* network-basic-tests
* ltp-open-posix-tests

--=20
Linaro LKFT
https://lkft.linaro.org
