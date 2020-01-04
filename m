Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 258821300C5
	for <lists+stable@lfdr.de>; Sat,  4 Jan 2020 05:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725862AbgADEcX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 23:32:23 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:43688 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbgADEcW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 23:32:22 -0500
Received: by mail-lf1-f67.google.com with SMTP id 9so33117934lfq.10
        for <stable@vger.kernel.org>; Fri, 03 Jan 2020 20:32:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4qpFDUneEzUOUl7vEL3+bTMu+7P48c2INu38tVs39oE=;
        b=CY+tECQK3KrtQp0WnMCREsQ2RgUoGep6ltShRhscVJIsQhnIrnfr4eid6jhvA89sRe
         4sOst9wl5oQBQtC3LktXTxXeTxq+Uh48bx/AzqXDcgNd28HvDIqKPub5cbTlzn9xTxy0
         YDNi9ad9PauKcBfgyFKJ3k1cPwidoE2Jk3z/B2kTtUT7kUCtbOlKUQnFc4mj7NqZFxWy
         5mdVCptyqgKtUbijxRdb0wAG1d5gT5zWw8bKoQd3pTczRvYgb72RsAuaO7Zk/cpWA+Lr
         Pu5z7XxigzCET/0WqbqxQro/C8tzq0EV2KDVKLOcexudh5yV7NbdtQG/0P+irkm+kIPG
         AN+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4qpFDUneEzUOUl7vEL3+bTMu+7P48c2INu38tVs39oE=;
        b=OYiHGc1MffLXofcZgagy37frDRT7wcSJhWpWaIPx/ojD6Bji6d+Kh0h4H2gkGBOFCh
         zQUVxmlKpAO49wJA7wgnKGIrEv8jeLRVu0LeUks7NPpvGq68rBT1ubLP3EXIh8LwqRh4
         94FrHFVPyYNBbwmJ2azA3HIOLkYUpRE1F0Yw/fgJgYJGygCqCoxy/qK0bDT02mN+YmWH
         EIA+dPphEaN1XF0pTa06BoYdL+1ZnozHkQMsmGsRJBHkxo+Lulmz2A0ER5wcBHkYtUZk
         GmblDthmK46ajArM9+sWTc819161ghfc81doOG56AkXIxAp2gNmfx4xWe0y1Xotzy/20
         548A==
X-Gm-Message-State: APjAAAXPzWCf1rn5kuXkLKJ7VD6rEDIgOtfP7i+Z6Sp2L9otPLbCy3sy
        XrJR6HLP508RimWMKD53ji2kANUGq1sFMUQ3pfDPDQ==
X-Google-Smtp-Source: APXvYqwsInCSpOoIg28BvtcZy6rk++6VfgPKPFA4EK1CHJtqDv811P8YsosYeSq8HuPxXMfjHxWD8USK2D8TtMzV674=
X-Received: by 2002:a19:8a06:: with SMTP id m6mr48587188lfd.99.1578112340329;
 Fri, 03 Jan 2020 20:32:20 -0800 (PST)
MIME-Version: 1.0
References: <20200102220029.183913184@linuxfoundation.org> <72f41f89-bf68-d275-2f1e-d33a91b5e6cd@roeck-us.net>
 <20200103154156.GA1064304@kroah.com>
In-Reply-To: <20200103154156.GA1064304@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 4 Jan 2020 10:02:09 +0530
Message-ID: <CA+G9fYufgU0ZQC-+vVhHhX31wBq=O32jwq2zyqsZEZCvjeMG4w@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/114] 4.19.93-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
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

On Fri, 3 Jan 2020 at 21:12, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> Now added to 4.14 and 4.19 queues, thanks!

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.19.93-rc3
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 9ecb5b1714ae62e5f10cc711b473d902b465735d
git describe: v4.19.92-115-g9ecb5b1714ae
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.92-115-g9ecb5b1714ae


No regressions (compared to build v4.19.92)

No fixes (compared to build v4.19.92)


Ran 24071 total tests in the following environments and test suites.

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
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
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
* ltp-securebits-tests
* ltp-syscalls-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* libhugetlbfs
* ltp-containers-tests
* ltp-fs-tests
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
