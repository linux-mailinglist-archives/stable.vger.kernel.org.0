Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 240456D10E
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 17:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390802AbfGRPZL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 11:25:11 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:46156 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727740AbfGRPZL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 11:25:11 -0400
Received: by mail-lj1-f194.google.com with SMTP id v24so27812986ljg.13
        for <stable@vger.kernel.org>; Thu, 18 Jul 2019 08:25:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Phbwpm8Cs54VrDP8syQ/LKcqloBeAwMnZ7zJiqdPC+M=;
        b=t6EqTP3+Uu0U26MXMut5Wn20epycsMnRmv8tSBQuWyYgi3HDHif45NN3X9BxZAangr
         DGo2U9pFC8RDOOiMuAUamQG6qdkLVN3ggeObjWYWvuMDxFDGsLCuqpeoptq3il0GiRo7
         6ktzRubXu2DEYFX+fSPM3rYzHksPnw+UXIzuJzTePbECmM1k2mgkDqZmM0RU98+B+Hie
         qlsIQV/GWzftCiwXo6kJVqTITvcK987GMLoziDZIMbOiYU5+pi6/DTUNOnvwAeKOTLfC
         NYhzvMDmtg3b0jac+ZhZBKvcGWvK+zpgdqaRSJ3bt5yLIz1xyVY8cWyPReyvN4ykq96y
         xUVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Phbwpm8Cs54VrDP8syQ/LKcqloBeAwMnZ7zJiqdPC+M=;
        b=jzKlR2G2FA/fDAs+8UsMbBlF9WBtObCk2GFn3ZJ5KlprrrEpJuVLXixpBmeANuJ3kD
         wRmNuerXLrw/zcIKCMVxagv3srW956Ymw0P9+ttfm9k81PDJYvmF7F3Vd9jPkWzQ9pdk
         4A1gbcy+bMZIXY8GhVxl64iOSN8cdE5h7mmRkYWEJFmCbQ+MKUFARe+nxxf0gXnr8Yd9
         Ix5e6gyieRVRoZ74HiRakhgxRFk2243j6uIWVBLgR1zEbpGBLbQ7QG4HlNqvtrE9EAwb
         ZiDnH7yBF3QQLJO/QaRMi4CVfuNB79OugKuImnajpXvqQni5G207sAE29k9+NX2O6t8/
         sIfQ==
X-Gm-Message-State: APjAAAXBbXMCthVvFP99g7R3Py4pJ8wb1/0m/+lUa5jkV0S7pdEnSaKN
        nuu30b4s3mnrL7KhIMvHcDt/T2HNrj7fedqffAiMSg==
X-Google-Smtp-Source: APXvYqxPBaO3C0+KRms0eshLfU+4cPDd974EWv5ZeXREua525SIVRAL3TokzKgh5by1KnPnoPL5obWEaZ9F7oqX7qHk=
X-Received: by 2002:a2e:b0f0:: with SMTP id h16mr599808ljl.21.1563463509527;
 Thu, 18 Jul 2019 08:25:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190718030053.287374640@linuxfoundation.org>
In-Reply-To: <20190718030053.287374640@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 18 Jul 2019 20:54:58 +0530
Message-ID: <CA+G9fYu78ax1Az8sw0Sx5BZAv9jyrxbAggggjr2oox5yhsN=4Q@mail.gmail.com>
Subject: Re: [PATCH 5.1 00/54] 5.1.19-stable review
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

On Thu, 18 Jul 2019 at 08:34, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.1.19 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat 20 Jul 2019 02:59:27 AM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.1.19-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.1.19-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.1.y
git commit: f7d61f5b654edb3890d2a2a2c0a9769ba92acd6f
git describe: v5.1.18-55-gf7d61f5b654e
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.1-oe/bui=
ld/v5.1.18-55-gf7d61f5b654e

No regressions (compared to build v5.1.18)

No fixes (compared to build v5.1.18)

Ran 17581 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15
- x86

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
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* kvm-unit-tests
* ltp-open-posix-tests


--
Linaro LKFT
https://lkft.linaro.org
