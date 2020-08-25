Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4931D25123F
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 08:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729160AbgHYGoo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 02:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729122AbgHYGom (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Aug 2020 02:44:42 -0400
Received: from mail-ua1-x943.google.com (mail-ua1-x943.google.com [IPv6:2607:f8b0:4864:20::943])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93871C061574
        for <stable@vger.kernel.org>; Mon, 24 Aug 2020 23:44:42 -0700 (PDT)
Received: by mail-ua1-x943.google.com with SMTP id 68so1212459ual.3
        for <stable@vger.kernel.org>; Mon, 24 Aug 2020 23:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IncfRTMkyY0Ndn61cCsSb/vz7XZW8P5xUH2QUoEMtgI=;
        b=U2f+9EwwPmBj3o5AyuANCbeyeA6nErHxI92w+QHd3pX1gHtveBh1OVMeE3/FP0drV3
         gL4XiOWIkRuuNfo1aT/QV+aff8bAD81+qobtYuTKcPyWIn6KnMtI6QYB9HuwsQYpjj7d
         L1eVGSyro5f4XGF9JvTEgVDWwHF5nlMwtjBMVKlaB/5bgN0/5GGfkGncTMewoD+mpybM
         OG74JX7vohFsKqeYoz073lYV5val0dGQWXba2o6BECMzuuFc4yQIZSdS9mc2HgAy4LkQ
         58KJz668ZOHZv6J1XkfF2YjDG4H/0zVX21l3v8sH2pK1GBLLgZlW/I+6CpJ7gQYBUDJi
         mXXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IncfRTMkyY0Ndn61cCsSb/vz7XZW8P5xUH2QUoEMtgI=;
        b=QFEqz1DdSHe0BZdOqmpizq6CkqqZJY9SuG6bctMaQ3D6WUA5dtYAmr9yPoEFduGMXL
         aAR5pBRBLLSUWrgMySm6aRvSLenv6GKLTI1L4ktGXhp5+8frHOK7kcb0zXaxFcBEoxZr
         FTLJ/VgvcPNykdSfundz3Ck4VGIK5eRqVzhGSMOBgvI0L8EIzYaBQiSuq1mH08hJMOCq
         4/NpVlOeMV2NAHQWL6nhMpSGeCJaPyuEmvsbDQyz3AmrRljGFAzSdsaxfGrDcYbDx8q3
         p3r8Xqfk3Rlf3IARFffZ8KivHxOiV9FViaBWioBjR+eMJCV+JULvNfyUIabz9UqH3Psk
         Rj5g==
X-Gm-Message-State: AOAM531nhsdeV4yE3qM1+nimL1o2h0TcB2am5vvDTH9+O4C5envldEGS
        SxWKAAzj+QzaVoQ89YQ0YMTKP+gKqBlftURdL3ZIDw==
X-Google-Smtp-Source: ABdhPJzSz7OrpNQSzxREytVBAgzWqJ2Cr4oVVqRcGsgwpHSSppfWRl6QRRrQcg/AwholOhVUmldkPYSvTalodxxvHM8=
X-Received: by 2002:ab0:462:: with SMTP id 89mr4715989uav.34.1598337881688;
 Mon, 24 Aug 2020 23:44:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200824164729.443078729@linuxfoundation.org>
In-Reply-To: <20200824164729.443078729@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 25 Aug 2020 12:14:29 +0530
Message-ID: <CA+G9fYshbGAyaX20O0kM9teYqD9nHHfGpjTYH_sB81=6oCrbhg@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/73] 4.19.142-rc2 review
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

On Mon, 24 Aug 2020 at 22:20, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.142 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 26 Aug 2020 16:47:07 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.142-rc2.gz
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

kernel: 4.19.142-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: d06cb8bccfe117b0d29cf8960e38a41911a945ed
git describe: v4.19.141-74-gd06cb8bccfe1
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.141-74-gd06cb8bccfe1

No regressions (compared to build v4.19.141)

No fixes (compared to build v4.19.141)


Ran 33301 total tests in the following environments and test suites.

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
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
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
* v4l2-compliance
* ltp-controllers-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* network-basic-tests
* ltp-open-posix-tests
* ltp-tracing-tests
* ssuite
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
