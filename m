Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0EF8E250
	for <lists+stable@lfdr.de>; Thu, 15 Aug 2019 03:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbfHOBVJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 21:21:09 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:33290 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727659AbfHOBVJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Aug 2019 21:21:09 -0400
Received: by mail-lf1-f65.google.com with SMTP id x3so631284lfc.0
        for <stable@vger.kernel.org>; Wed, 14 Aug 2019 18:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JZPCN043N9GEqek5mxHs+Qf7/zLwL7LgxbhrIxmUh8U=;
        b=AWVEbabn0NUK0uYJCzSEJkGUlWOy+/SnRuc4aYW5szYO1BN+wK1zWj2BobHTVKkdOw
         +JxLa0oX2IabnuX3tax7z3bpL/EoJS+pbKHH5kIJkWi2ankY1qg4UuM1gzJuAbs2KGy+
         E53aurEKBv46t2n2qZBKD57GqjROeu26D3kPP/cnybZ4w87LPXTqIjlABLqWJWOcMS13
         unNdMJDaHVxCZnYa7sZtDOPazHjYJSyad3zMZGA5SkuKcP5HDYcbsSWf5Q6QI06S/5k3
         v1Y+ualpTAJRzRmxAC+xT7f8+Z4DXWjY88x9t4VpcKL1lU3xxPJFQcZu7ymXj2Zcv4GI
         SbYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JZPCN043N9GEqek5mxHs+Qf7/zLwL7LgxbhrIxmUh8U=;
        b=qrE+sca4q3GkdQYwRwoJSwtvN7Pkk51ToWo1zNmnc67TCWTM+4qth2txZEkfJ/NFYp
         CcnY80Z2sZAxhJFzJeidFPXcB9PyvAPbinHwGVzSBYG8VJAXNYohBauAvLr0zsFumGuq
         cYlgamcW0WgcvGfq9JvPI4Y/Gxfpsref5MO2YFdnuX06JD7a3KHzCQCYcL61MfdFty0Y
         vIuUcaKmKfWfzVk9pvWJc4ezv2Ca/eyNyGRVchy6vGQxE6VrFnod2lu0aBBSnrcYesYR
         JjeOjv/lbWZjtL46na228/dr3/1I1tNps8LbZ1Zpeyx6RUOvaql2OREAPWTlyoSSpPbN
         saqw==
X-Gm-Message-State: APjAAAWtaViQs52XOklH5faSMNQ3wBDzGAXKb7mcLMZ3fMJ0TZomgK+1
        EYV5NFxaQpRb52gX1IbIj68ozCg/+exUOCbL3TmmwA==
X-Google-Smtp-Source: APXvYqwpDHPCFfKaN00wSnMPkT2gbB14aOVopHgPcnU75PZZn4kUGDVZp13eUSQoY1cxsCIZ5nTgEjPlyZWF1Pm8+zw=
X-Received: by 2002:a19:5218:: with SMTP id m24mr1140535lfb.164.1565832067115;
 Wed, 14 Aug 2019 18:21:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190814165744.822314328@linuxfoundation.org>
In-Reply-To: <20190814165744.822314328@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 15 Aug 2019 06:50:55 +0530
Message-ID: <CA+G9fYvyrJdGT=bWHHLi35XRZi5jRcBCDPx+KQJwqHknqbaAMg@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/69] 4.14.139-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 14 Aug 2019 at 22:42, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.139 release.
> There are 69 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri 16 Aug 2019 04:55:34 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.139-rc1.gz
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

Summary
------------------------------------------------------------------------

kernel: 4.14.139-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: 736c2f07319a323c55007bcf8fca70481e9c7175
git describe: v4.14.138-70-g736c2f07319a
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.138-70-g736c2f07319a

No regressions (compared to build v4.14.138)

No fixes (compared to build v4.14.138)


Ran 23727 total tests in the following environments and test suites.

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
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
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
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-syscalls-tests
* ltp-timers-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-fs-tests
* ltp-securebits-tests
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
