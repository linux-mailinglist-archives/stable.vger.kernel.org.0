Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7AE515D567
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 11:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729026AbgBNKUs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 05:20:48 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:40577 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729070AbgBNKUs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Feb 2020 05:20:48 -0500
Received: by mail-lf1-f65.google.com with SMTP id c23so6406297lfi.7
        for <stable@vger.kernel.org>; Fri, 14 Feb 2020 02:20:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zdYB2B7OuoC4Ps/XqRamzLL6q8baUMe7exacSZ+1de4=;
        b=RlILicjdn1cPwyNfeb68szLO6/DFJNQdG/2vdT1WzcD2wM1rionHoNVgKlriJ2Oy7q
         ZYUtozluOgdxPLVZ03c/u8G3eBzYZTS5WUCFp0BTSB/VFmWY5efsdG2peOk19wsrC15C
         CLS2e09tzGqpAf2Rq904WWasxflcbxxHPZL/bEPYvorfFHSOaFOA1xKCk2lpw0ugZIAG
         WPfFqAYyIngm1cdbGY4k7nS3PzqE/AwoKkgZpwWiE2QPJKlwGxN4x1E3vXh2NZZj+/sn
         n1cKeBU15pRtqumfwdmBos2QGXLW+gCuCi0NFmnJuL0Al4QMmBNExEbGxx0G3KQjMoBP
         P+Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zdYB2B7OuoC4Ps/XqRamzLL6q8baUMe7exacSZ+1de4=;
        b=LVY/xDXPH/qXxRBLeL8tyzBY6Jm1qJEYgmNKN/Ar9RmAwDrGA30JAfs+97uH4TrDK3
         u/qbtG1okAdKld+zUFcEhX4bDfmJpdYPhBM5Pe3ayBmieug4yM6+Px18rpGlq+T1FeJy
         UIfM07RGe0ewl/VYiwH3SGR0pG6/WCS748YgUoNjF3CDJjl5Ru7gaOs53NGvLytnx01T
         tRpd8Lwb6aOBrFsHSo0zVUaJqLmSZIPtOBR01WCf+nucHKZdPHtmr2ZjXbSGy4/RxZC6
         hSjtqCsmLYgzd9UjBOmrVNPspGsGeWgq5BODrPOuhUdBRUZzYditVIS2c0abC1wEPyxR
         nYQQ==
X-Gm-Message-State: APjAAAVB//GZDA9HCw3EYlz9++qN2X2Wltn3uWLX451/fU08/aDORmor
        4PhwlAiSoT/x6OV3A1RFv1JHarPsYdZHu2RQfjfQwQ==
X-Google-Smtp-Source: APXvYqwomPblKBxxrTkpgoA5C5NCHLpN6W5FzU7EqmPxia2QpapeUfiT2MTzWd8akHZjqoiq6wB+X25gf4xs8fhauK8=
X-Received: by 2002:ac2:5467:: with SMTP id e7mr1284820lfn.74.1581675644621;
 Fri, 14 Feb 2020 02:20:44 -0800 (PST)
MIME-Version: 1.0
References: <20200213151901.039700531@linuxfoundation.org>
In-Reply-To: <20200213151901.039700531@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 14 Feb 2020 15:50:33 +0530
Message-ID: <CA+G9fYudhnZ9dmSk_ujQa4A8MA6N_HWjEyJV3CLDcBTceN-nLw@mail.gmail.com>
Subject: Re: [PATCH 5.5 000/120] 5.5.4-stable review
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

On Thu, 13 Feb 2020 at 21:00, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.5.4 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 15 Feb 2020 15:16:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.5.4-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.5.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.5.4-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.5.y
git commit: ed6d023a1817c7e6a969bda2fd46d6a161cfd914
git describe: v5.5.3-121-ged6d023a1817
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.5-oe/bui=
ld/v5.5.3-121-ged6d023a1817

No regressions (compared to build v5.5.3)

No fixes (compared to build v5.5.3)


Ran 24221 total tests in the following environments and test suites.

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
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* v4l2-compliance
* ltp-commands-tests
* ltp-math-tests
* ltp-cve-tests
* ltp-fs-tests
* ltp-open-posix-tests
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* kvm-unit-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
