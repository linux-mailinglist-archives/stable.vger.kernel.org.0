Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1811FE20F
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 16:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727564AbfKOPxV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 10:53:21 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:45528 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727520AbfKOPxU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Nov 2019 10:53:20 -0500
Received: by mail-lf1-f68.google.com with SMTP id v8so8345277lfa.12
        for <stable@vger.kernel.org>; Fri, 15 Nov 2019 07:53:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2OlOWxrT9e9cqRQHfIhdq+hrzgQL9PDKv2E2QsxhWkw=;
        b=oCqwhElDuOFlNAldux08vq/obkK2FkurgT4WAR/I18XFvboljfqIN4Y2UOroQMXO2/
         QBaYKteZrWE9fnNvdVe5LkFbNIz2axssglBXYzDz1qX6Yt1YCe7GlinUeQpeOZ3MRxXR
         HYgVM7vC2h2QaY1+p9BUYsJlANeYwhBK1ez6sEXgxwBj6RgoivJui6QvrJ/DqpFR/R76
         w3YQwU5OmxvybybFusuDktF2zE3oOBWBbt8wr4F9bs3mTMS2WcojO9QUPRPJa5XzGhdS
         tTlKY6rJlExTVK79+zeKuug3u5d2FZLatRmv0mz+jKoGqumj8GxaluGrqZ52H2fdfKGd
         Qqhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2OlOWxrT9e9cqRQHfIhdq+hrzgQL9PDKv2E2QsxhWkw=;
        b=t3eRrNyNGsdqudQK6D1XKOmnTz+oqvrGRuECtOuQ9sZz12tCfHdg4RHPIIaZK0lrne
         0BO8psrlzkmjC4YrIN1VCPiLUludKO9gunpbE/zZss8ACj8aQyRzMP9mbYf/8JclEtnZ
         G//+aJrIqwwgD4Axlcsq6yy8ZbThmaB/z2+UFfcwz33EOQvnx1nhZj1/2/vef/NKfRny
         0NarZ5t3Q9Qr5vbHAdQsgaR5gGwOiefw3gqTlTIprXGfbBNIw04uFNGRa9Rl/TQoW/Sv
         L9+utSMdaAFHH8XiAelhWX56TDpdA08q/lfwNpC5uEtScGy0tGU/Z6pEDEFB5AkZ/58e
         t9fw==
X-Gm-Message-State: APjAAAUIMsnWrdRgDzq2d9xnu/j3vq/I2eX8qbZxRn/uWG6fAfj+p2iv
        zYfxLxUP1vlWHOjsmIkQvrmlF25UYfHggLld+xsO6Q==
X-Google-Smtp-Source: APXvYqyzh6WYDGRv8TzZnZV41sLdIoafTflvNw9rdLLIobn13xw5bW1oveli8wIecP6+mzIbaQo13nSrkjsL99I/qI0=
X-Received: by 2002:a19:6503:: with SMTP id z3mr11500998lfb.192.1573833198729;
 Fri, 15 Nov 2019 07:53:18 -0800 (PST)
MIME-Version: 1.0
References: <20191115062006.854443935@linuxfoundation.org>
In-Reply-To: <20191115062006.854443935@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 15 Nov 2019 21:23:07 +0530
Message-ID: <CA+G9fYugWXr+MdXDZ=E9QV4kdt7x0YgqJwO7DbKacx-wXQu0Qg@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/20] 4.4.202-stable review
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

On Fri, 15 Nov 2019 at 11:52, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.202 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 17 Nov 2019 06:18:31 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.202-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.4.202-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: b0074e36d782e84e6a2e08910103642762949d2b
git describe: v4.4.201-21-gb0074e36d782
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.4-oe/bui=
ld/v4.4.201-21-gb0074e36d782


No regressions (compared to build v4.4.201)

No fixes (compared to build v4.4.201)

Ran 18051 total tests in the following environments and test suites.

Environments
--------------
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
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* perf
* prep-tmp-disk
* spectre-meltdown-checker-test
* kselftest
* kvm-unit-tests
* v4l2-compliance
* install-android-platform-tools-r2600
* kselftest-vsyscall-mode-native
* ssuite

Summary
------------------------------------------------------------------------

kernel: 4.4.202-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.202-rc1-hikey-20191115-607
git commit: 493901fc04b1127d80037f3fb43e916a4eec9f10
git describe: 4.4.202-rc1-hikey-20191115-607
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.202-rc1-hikey-20191115-607


No regressions (compared to build 4.4.201-rc2-hikey-20191112-605)

No fixes (compared to build 4.4.201-rc2-hikey-20191112-605)

Ran 1538 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
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
* perf
* spectre-meltdown-checker-test
* v4l2-compliance

--=20
Linaro LKFT
https://lkft.linaro.org
