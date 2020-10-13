Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 889BF28C8A1
	for <lists+stable@lfdr.de>; Tue, 13 Oct 2020 08:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389264AbgJMGaI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Oct 2020 02:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389261AbgJMGaH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Oct 2020 02:30:07 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C31C0613D1
        for <stable@vger.kernel.org>; Mon, 12 Oct 2020 23:30:05 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id t12so19246031ilh.3
        for <stable@vger.kernel.org>; Mon, 12 Oct 2020 23:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=oDZbvoWOdch3821MsN/+6eXKMXu299uHqliYU2ZBh6w=;
        b=NsgFcoS+DjKx/IIC6xDiOXJlxDapBwK/A9PGlvEPrckp8f3GXj2rp2MvnGRhQqE9sD
         DMVsu1I5uNvsJ0RhPYf26hiyPMhdqYMGxXaRG+BRgt3AuNTmL56oJSexNevpPLZRlLLP
         wTkl7xydotGDqL9Yqc1xMjVi5NbUe1qCHx/K4Nr1vEVo9Fff+2/YwR6Fc0xjxCT4nSg7
         gtdY/rFEBLucM1vtmbrjY74YRvxXuOXOyfz4Ym0M0LfELVlpTJXCCLtMqzKuIXPJqGVj
         Olfr3aDnlsDqP+32VyvfWpXHl4iJNYZfn2DaMMW5UPJq1H6wxqbufyUinBVt+jmAitGG
         pXHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oDZbvoWOdch3821MsN/+6eXKMXu299uHqliYU2ZBh6w=;
        b=FU/k4gWQQy77ZHJi4XAnVZOsrScdjoNOOsKBdJXCe7aW8I9DCtpFLbbgSqmgsOAzr4
         TB5bxXy4CDi4JXxBzAr9oYp+wBmzuNFLAYJ2vNgNTmcF6bjOxhpVoPcNcK70by7fptd3
         IVv3hLxkwJpH93K/hY/i8txuJaMvKf9SnE8ounFlGYiGpXjPqbICmNosIc2ReK/d1Di2
         qWNoLLMlCxapbeUgWst4EXq6PSsXwlsqLQcxuWnnuFb4nMbcZbt0umlco9QxkfWxFNTD
         p+Z9itYCaCddQPLnECUx254hwgk5ZwaYb4EDJv9Ulctd+++PhME9un4VoNP7CYD3sqLE
         3iDQ==
X-Gm-Message-State: AOAM533Te/Viww2Jnmn28toYnB3WMptBbeU6fA0yK7n5bjAqbIOpezVH
        +z8gzxdruyi5fbRuYMZ8fcinbAOvtVHIcxHYPTDAxw==
X-Google-Smtp-Source: ABdhPJywb0iukPd5w8S+HsWu3ZqiDmNBNuvcCBYYBK3xkYEegMuN8qkb1kTwbtN7ubMEw5kFNoqTzJKowUK88bkSmPw=
X-Received: by 2002:a92:9944:: with SMTP id p65mr1844893ili.127.1602570605067;
 Mon, 12 Oct 2020 23:30:05 -0700 (PDT)
MIME-Version: 1.0
References: <20201012132630.201442517@linuxfoundation.org>
In-Reply-To: <20201012132630.201442517@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 13 Oct 2020 11:59:53 +0530
Message-ID: <CA+G9fYtmtwEzDF3wdgS80Eo9Npx_v3kP93gR3dMFH3-giaJGBg@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/70] 4.14.201-rc1 review
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

On Mon, 12 Oct 2020 at 19:06, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.201 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 Oct 2020 13:26:14 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.201-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
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

kernel: 4.14.201-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: af37e8ff299b6807fa85fde68b814a94f56a76b6
git describe: v4.14.200-71-gaf37e8ff299b
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14=
.y/build/v4.14.200-71-gaf37e8ff299b

No regressions (compared to build v4.14.200)

No fixes (compared to build v4.14.200)

Ran 33137 total tests in the following environments and test suites.

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
* kvm-unit-tests
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
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-syscalls-tests
* ltp-fs-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* perf
* v4l2-compliance
* ltp-open-posix-tests
* ltp-tracing-tests
* network-basic-tests
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
