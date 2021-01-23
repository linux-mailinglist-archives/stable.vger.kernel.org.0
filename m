Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6A303013B1
	for <lists+stable@lfdr.de>; Sat, 23 Jan 2021 08:22:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbhAWHVr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jan 2021 02:21:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726702AbhAWHVf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jan 2021 02:21:35 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E381BC061788
        for <stable@vger.kernel.org>; Fri, 22 Jan 2021 23:20:54 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id hs11so10902944ejc.1
        for <stable@vger.kernel.org>; Fri, 22 Jan 2021 23:20:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=q9F4MZy2+rjw6cwWok88Kbc/G35pLhanS3iiCi+4GUk=;
        b=iNbkNNwkt7VoKoYZKVyMAAgx1CNI35LWQPRqCUQ7hQt7THtuTXXZupnyFvrLtFreEN
         NvhlcoE6jY9bgal533cfjkUkUeQ/+IX8vkL90q65qNOXmoLgXvAlPqKrN4PK7gSaDsVs
         9NyclRFXtR4k5HC1w9wmv7J7F5G2+QgYpaSaaPy22nrsyQnyc9WV/MzFcaKiLPKHUW+F
         t7v3X5WM9NKXPDwmjlbdwIsxQ7C6MSv4mQxT4CzJYjK5g60b80Gm9woPGc74fbzx4/kU
         /YOK8Ay3mfjCdDz2V1sez3YoPBAlygjyJe7ozip/MhJZCNJ7m1KQfzOtgc2qkjhVi8x9
         o7Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=q9F4MZy2+rjw6cwWok88Kbc/G35pLhanS3iiCi+4GUk=;
        b=Y09AeFbI8hi/5QtK3kTZ8AyZLitCplyPJ2pAViJ9ZF6K52LYXNdFuxZXJN4uNbtBct
         jQtzdEPTGYTNkmAzkBfL3pr9goTl4YR54bS1o/6vFVcM9jDmOItgpMGqE2tQqsicAuy7
         /TPMzX9tLO4bMIt3UN14kTSq0BhN+A1sOJBIhIoXr7uPYDFjLwezD8n0mmY60fxj/isA
         8AYore7LEQhKj1Sl4lwusYz3XGoJ3Fquf/sPbte5JBFAvGaLeSNvEIspeMKbrqdv8NE/
         M+F07idDAZpM/4C4jq4ShTOuKi/tY4YtmBTco9AeakuTm4ckz5EFcWlX5Fw2HVAJifXZ
         tWAg==
X-Gm-Message-State: AOAM53036zdNIYp6L3fbYLCh0VMRHIctScnV6pCmtZoiNTPKOoEsK9Ob
        O55GbwALvz2ncPloU1ciRVvDsJY7XBvHMHUOgQXTL9698nx/TaYz
X-Google-Smtp-Source: ABdhPJxcc2yEzb0Mmpf0QsFYi0UB+lbCiXdvH6o2KDk++Qq7ECmd/hH3BSVvzFxVJAURsj8IHQ8+W2oI2al6M6U0bV0=
X-Received: by 2002:a17:906:796:: with SMTP id l22mr5367434ejc.247.1611386453610;
 Fri, 22 Jan 2021 23:20:53 -0800 (PST)
MIME-Version: 1.0
References: <20210122135733.565501039@linuxfoundation.org> <CA+G9fYtr3QveGHTdx9qrLS6W=AfF+vU_nxuE-SnChued5ruWbQ@mail.gmail.com>
In-Reply-To: <CA+G9fYtr3QveGHTdx9qrLS6W=AfF+vU_nxuE-SnChued5ruWbQ@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 23 Jan 2021 12:50:42 +0530
Message-ID: <CA+G9fYuC7HMyn04yTzBcoyrJuz6=8cHDuJDWjsfKXyC1zAg9Gw@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/33] 5.4.92-rc1 review
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

On Sat, 23 Jan 2021 at 11:27, Naresh Kamboju <naresh.kamboju@linaro.org> wr=
ote:
>
> On Fri, 22 Jan 2021 at 19:47, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.4.92 release.
> > There are 33 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun, 24 Jan 2021 13:57:23 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patc=
h-5.4.92-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git linux-5.4.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
>
> Results from Linaro=E2=80=99s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

>
> Summary
> ------------------------------------------------------------------------
>
> kernel: 5.4.92-rc1
> git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
> git branch: linux-5.4.y
> git commit: eb6c2292de97c5c4e51d98767b4c7acaef0522ec
> git describe: v5.4.91-34-geb6c2292de97
> Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.=
4.y/build/v5.4.91-34-geb6c2292de97
>
>
> No regressions (compared to build v5.4.91)
>
>
> No fixes (compared to build v5.4.91)
>
> Ran 53090 total tests in the following environments and test suites.
>
> Environments
> --------------
> - dragonboard-410c
> - hi6220-hikey
> - i386
> - juno-r2
> - juno-r2-compat
> - juno-r2-kasan
> - nxp-ls2088
> - qemu-arm-clang
> - qemu-arm64-clang
> - qemu-arm64-kasan
> - qemu-x86_64-clang
> - qemu-x86_64-kasan
> - qemu-x86_64-kcsan
> - qemu_arm
> - qemu_arm64
> - qemu_arm64-compat
> - qemu_i386
> - qemu_x86_64
> - qemu_x86_64-compat
> - x15
> - x86
> - x86-kasan
>
> Test Suites
> -----------
> * build
> * igt-gpu-tools
> * install-android-platform-tools-r2600
> * kselftest
> * libhugetlbfs
> * linux-log-parser
> * ltp-cap_bounds-tests
> * ltp-containers-tests
> * ltp-cpuhotplug-tests
> * ltp-crypto-tests
> * ltp-cve-tests
> * ltp-dio-tests
> * ltp-fs-tests
> * ltp-hugetlb-tests
> * ltp-io-tests
> * ltp-mm-tests
> * ltp-syscalls-tests
> * perf
> * v4l2-compliance
> * fwts
> * kvm-unit-tests
> * ltp-commands-tests
> * ltp-controllers-tests
> * ltp-fcntl-locktests-tests
> * ltp-filecaps-tests
> * ltp-fs_bind-tests
> * ltp-fs_perms_simple-tests
> * ltp-fsx-tests
> * ltp-ipc-tests
> * ltp-math-tests
> * ltp-nptl-tests
> * ltp-pty-tests
> * ltp-securebits-tests
> * ltp-tracing-tests
> * network-basic-tests
> * ltp-open-posix-tests
> * ltp-sched-tests
> * rcutorture
> * kselftest-vsyscall-mode-native
> * kselftest-vsyscall-mode-none
>
> --
> Linaro LKFT
> https://lkft.linaro.org
