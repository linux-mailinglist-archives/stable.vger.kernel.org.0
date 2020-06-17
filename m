Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85CC81FC726
	for <lists+stable@lfdr.de>; Wed, 17 Jun 2020 09:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725929AbgFQHZK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 03:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbgFQHZK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Jun 2020 03:25:10 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED5BC061573
        for <stable@vger.kernel.org>; Wed, 17 Jun 2020 00:25:10 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id u25so676906lfm.1
        for <stable@vger.kernel.org>; Wed, 17 Jun 2020 00:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NBcvyI8n8mcl8pFmre/YEhhWOCxkmqr93q9SNpHj6AY=;
        b=TCeAAJHU0EBOzLN4IVmZFmkJhthcHcN4UVfGDvgGblyACZg9SzIIlwFEkXtV7J0csc
         EbSYK1ijp2RZv6cBdg2CZG8hjmoq200sCpHSv23DAjmmzQiUnorC7pf4UvFhb4/f8D+F
         iYWEsHY69Cz5LJ1DPCE2PJ4dtQWjr4RHHhGJrAv1iRT5NLst1fNKo5VORSkLdX0NrxhT
         TiJX7vqAwBYT1o05XLldvJbQK78OWbIv20PDQN2PPX0MI0aKlykA6NSckCxtxJ4ZwQKH
         z/zYJBj6B5ZzKoczj2tCzxT0GRM7NfwMUyrgGGEaBvgyADfhY5v3QVP99FdcXpxXe/wR
         2Nww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NBcvyI8n8mcl8pFmre/YEhhWOCxkmqr93q9SNpHj6AY=;
        b=DhpxUqTtioAZ7Sxdiz3b2g9LMyZjc2512iReHJb7jFNZEE8Kg50EnCzZJY495a2pDG
         6YsuqZhDGpq3w+UEs+lBOwrj+1r9knVon2ARfUJ2r5Awe95g3uAXjZQaCnPutZ8OhtiQ
         Ag2tISQ+5dTQDEfgCv9SliFrFHj7Op3tSBrpVCB30yjBvTLTHJi4ypVrx0gYz9HKEl3F
         AxyaT4tMA1WGjaZz88VLgB8DpsQiqrPlfQf+yryIcfjFyRcxdfyhJ+FpIkE8CV6i8ZcQ
         be9KOea74HriwGh1dhciiEEybv9gCCqqfdSK4H7nbGfdKK8HBP0gIQQLz3TItsI0cm8f
         CIVQ==
X-Gm-Message-State: AOAM532ykjlhTA6uONv8DF02HIgVjEt0iKRfsI2aBG0A2xQjJne6Io56
        3uLrt5zWtAhFFcYk+aMwUc63w+Sk7WfsorXxpeOfvw==
X-Google-Smtp-Source: ABdhPJyU7JeiKPrBiW/e15v4R/wbxTaFvBmDKHV7eA18MzDsA0i4Crhlnxn2+q7mBbv8Gi8oEnu3vETuUmCeAxhnKm0=
X-Received: by 2002:a19:2292:: with SMTP id i140mr3714997lfi.95.1592378708022;
 Wed, 17 Jun 2020 00:25:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200616172615.453746383@linuxfoundation.org>
In-Reply-To: <20200616172615.453746383@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 17 Jun 2020 12:54:56 +0530
Message-ID: <CA+G9fYsBwdUZtXTqoLJNm=8XPy+Hq4rUbZSmyGg=rLWRdF_j7Q@mail.gmail.com>
Subject: Re: [PATCH 5.7 000/162] 5.7.3-rc2 review
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

On Tue, 16 Jun 2020 at 22:57, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.7.3 release.
> There are 162 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 18 Jun 2020 17:25:43 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.7.3-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.7.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.7.3-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.7.y
git commit: 55b987cbccd9e2536c0ceec2c1be7207560add0e
git describe: v5.7.2-163-g55b987cbccd9
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.7-oe/bui=
ld/v5.7.2-163-g55b987cbccd9

No regressions (compared to build v5.7.1-25-g00f7cc67908b)

No fixes (compared to build v5.7.1-25-g00f7cc67908b)

Ran 31881 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- nxp-ls2088
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15
- x86
- x86-kasan

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* install-android-platform-tools-r2800
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* kvm-unit-tests
* libhugetlbfs
* linux-log-parser
* ltp-commands-tests
* ltp-controllers-tests
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
* ltp-cap_bounds-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* network-basic-tests
* ltp-cve-tests
* ltp-open-posix-tests
* v4l2-compliance
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net

--=20
Linaro LKFT
https://lkft.linaro.org
