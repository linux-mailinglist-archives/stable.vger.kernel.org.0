Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B680309335
	for <lists+stable@lfdr.de>; Sat, 30 Jan 2021 10:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbhA3JVh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jan 2021 04:21:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbhA3JVR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Jan 2021 04:21:17 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65AE1C06178A
        for <stable@vger.kernel.org>; Fri, 29 Jan 2021 23:08:20 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id hs11so16278996ejc.1
        for <stable@vger.kernel.org>; Fri, 29 Jan 2021 23:08:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Ry6Qb3LtDfSd8utk83ksKXuJR9WO1Rwondq0p79UHag=;
        b=nr3Dg1AM1IDiDMNREal00hrpmRebINposmH2kVBoZi0e4mAxIfBPWHZssv50YXobRk
         gR6kTbTuZjgG49Z9NfDIIH/WAd4G6TZxxNJU0LQNU4i3molOCIBAHjnMIeOLIwZG0i9U
         kHDkZofzGvo3Cwo/rZkeWvmAEe7ZRAFWhP7A/wvOqGVVKITaGzCmWXi38RjOXDEJ/RQz
         WTCBtHZ7zm+SYnAPM+6T/YgrQubUW/0HvCptmiqCxWLH4R6/Mrzx468M9Swwcr5ROUW9
         JeJTfcEU6WaN32DRUqAjU/A1Yc/CnXpt0Tult5ufIezA0D9QdcpWsQdr7dPq8Fw0p6RJ
         kh8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Ry6Qb3LtDfSd8utk83ksKXuJR9WO1Rwondq0p79UHag=;
        b=icEHIUPjSY2h2oB6Sdx/1sGxD89EPcQpo+rsitm3WrVa9Tqcpr2YdINYFl6KoquB6g
         w9ee/y26lO0jjwNdn03/F6fobsUOU4WqogkqNMy8VDbLjRCE+qRG/BdvZPVM+I5mnaNA
         pnVtbin2N5dEom4NUGQYbk4izJuit9CBYn+NfoPC8AhgjqrO6piVSpbPZnpUuwabnsWC
         qqGqBNlU2GdVxkJORmhpgjSoVE245cVzoWoQ7S3T25YSIVstkoaB5OLjI88VFlZ4qlhM
         VqJGjKEtR8PrRC58I7oz/qFtNozz5DiX3/Rdke7ihg3/xiopg5Tou5Q48GjU+/X/uwHd
         4Vhg==
X-Gm-Message-State: AOAM531lOQYygR9j+XA95o1WHCYTmictsfXQ0MCU8mSZusLvkwLe5w+K
        /7Torwdl7PIb+nfgVxzfFfnDiK7sx0ankqtZXuX3Dw==
X-Google-Smtp-Source: ABdhPJwa0vF9IXr7IgGMxj3dC3u9EUGRKpCpOMCnhJ31ixpyPyjFuHnEeTbRp4b+8C4zViRQTlfNy3w0S/GJafv5ZyI=
X-Received: by 2002:a17:906:4c85:: with SMTP id q5mr7872486eju.375.1611990498869;
 Fri, 29 Jan 2021 23:08:18 -0800 (PST)
MIME-Version: 1.0
References: <20210129105910.583037839@linuxfoundation.org>
In-Reply-To: <20210129105910.583037839@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 30 Jan 2021 12:38:07 +0530
Message-ID: <CA+G9fYvEDbj2o0MuBFikeNGJvc3oVDeZqn4-_ej8gKr7T5ZJQA@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/30] 4.9.254-rc1 review
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

On Fri, 29 Jan 2021 at 16:42, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.254 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 31 Jan 2021 10:59:01 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.254-rc1.gz
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

kernel: 4.9.254-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: 1aa322729224bcf6471557d67a263fb060158de6
git describe: v4.9.253-31-g1aa322729224
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.=
y/build/v4.9.253-31-g1aa322729224


No regressions (compared to build v4.9.253-28-g02d9a5638c82)


No fixes (compared to build v4.9.253-28-g02d9a5638c82)

Ran 40883 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
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
* ltp-tracing-tests
* perf
* v4l2-compliance
* ltp-cve-tests
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests

--=20
Linaro LKFT
https://lkft.linaro.org
