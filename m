Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5297A1AD5EF
	for <lists+stable@lfdr.de>; Fri, 17 Apr 2020 08:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgDQGMw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Apr 2020 02:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726764AbgDQGMw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Apr 2020 02:12:52 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2C21C061A0C
        for <stable@vger.kernel.org>; Thu, 16 Apr 2020 23:12:51 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id j3so791421ljg.8
        for <stable@vger.kernel.org>; Thu, 16 Apr 2020 23:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/FWw4e/+lDvAmu+pvQ9Pt7wJyGjaI+MJpbg/WlFhQoY=;
        b=DWs0AAfBddGnQrOocMzjgWXUFlNZRjsMFKpZZk1alBffd05xn0vWCArXbzrXfZ/LoD
         0MIuidiI9kFFFU9VG2rx0pZ9mqqEZ4VB/9MthpbhrjydeJA61GP5P9BCGKQ21OQqslps
         FHb25rrBesneEq8UVU+lYTV1Nv9Xyj+FlRJVMZi4JNvOBBh6QrNsp97BUV68PMAGEsrk
         wMyL54e0V5hqRNsHOVWpBx/Q51mdZSg+JvJ8rrugunPCO3poVwwe9J7xGwpFEHrGl46n
         7UcOLOXM2Mw0UbmwE+JPFN5ktFTFuEIFM5OPAeIM76dFhWY/ISjVGiva7Ar4sEsleH7z
         5PKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/FWw4e/+lDvAmu+pvQ9Pt7wJyGjaI+MJpbg/WlFhQoY=;
        b=iz40Jimm5D9F7gBjUPzA5qBwMjm4P2nsap9ZsiFugJFQLjoHK6xgGIswvUayVcfwbb
         NDL2sWt1XXd64V+FDAz1bLRMfWNQQ9be6jTUQRKHLkNP0zc8feV0yDZmBXMB+6wPKIXX
         P7VBPiwxuZRWspMO1dYMhtquWcRlnkIAId6hPXL4m2ef51zb98BEjgnOO6gAtE0iM50n
         max+ukdLFU6G4MRA3JOL7KmAO/rg8tuT333V3fhYhIRZzh+f21fpS0tjie8BeMlD1+PW
         ynL8x2bOYPrqYaXEfLojdWR5BhYkXRUOU7Zco0G4XyWNbNutf9gymXRR4/I7kMfQUGpJ
         ny0A==
X-Gm-Message-State: AGi0PubbBk8zT6qAGtEWBDLxLJsLP6U/EhsFco73CcgkqC0B7fe3FScX
        Y+WEAmhIlJ44sN1Im3jOPZczv85vl3Oa5P9W3xCnFg==
X-Google-Smtp-Source: APiQypKb3+zxnSo0/2D/NRf9zuuLTRuHXjegLXh+h+lcqb7FR4RKOujc/jxeRno9sG+zci/i/eKugeePtqHsRbEYKK4=
X-Received: by 2002:a2e:b52f:: with SMTP id z15mr1078568ljm.38.1587103969891;
 Thu, 16 Apr 2020 23:12:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200416131242.353444678@linuxfoundation.org>
In-Reply-To: <20200416131242.353444678@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 17 Apr 2020 11:42:38 +0530
Message-ID: <CA+G9fYsjyFQxJBYS+i94cStSGTKUHydLcC9XT=x94km5mySxxg@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/146] 4.19.116-rc1 review
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

On Thu, 16 Apr 2020 at 18:56, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.116 release.
> There are 146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 18 Apr 2020 13:11:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.116-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.19.116-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 287f80e07bbc28d3a2a25d2b53674c912d515376
git describe: v4.19.115-147-g287f80e07bbc
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.115-147-g287f80e07bbc


No regressions (compared to build v4.19.114-55-g3b903e5affcf)

No fixes (compared to build v4.19.114-55-g3b903e5affcf)

Ran 31564 total tests in the following environments and test suites.

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
* build
* install-android-platform-tools-r2600
* install-android-platform-tools-r2800
* linux-log-parser
* ltp-cve-tests
* ltp-dio-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-mm-tests
* ltp-sched-tests
* ltp-syscalls-tests
* perf
* kselftest
* kvm-unit-tests
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* network-basic-tests
* ltp-fs-tests
* ltp-open-posix-tests
* v4l2-compliance
* spectre-meltdown-checker-test
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
