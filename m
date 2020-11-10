Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 162D32ACE73
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 05:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729454AbgKJEOd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 23:14:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729243AbgKJEOd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 23:14:33 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6E8C0613CF
        for <stable@vger.kernel.org>; Mon,  9 Nov 2020 20:14:32 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id s25so15505310ejy.6
        for <stable@vger.kernel.org>; Mon, 09 Nov 2020 20:14:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lKAKUxf31iKD63H2Y0R9CiFoIGve/JWjHjtQtrBS0Ms=;
        b=qpjKOHz7zZkBpN3dcVFDE6jOGnqlRZeD0AQbAUu7wUCDsdxIKomXnAc0JLeLs1BZwD
         tJeAGb1RjAqUfA6Yl5Vz71rGCrJT/iBvHKyXSsC3AYpXKNtaskM+an+ZyFq36CWOQxOw
         Fw3qSpi2Y2hLl9w0sjkgNDz07joHaz1Cl/jZMKn0e7p3ODuhHXqA9xb11RI4+Tl14Elw
         Pj1DV7+wLXKcGt/gFsFRhIpOSN6rFGCMNuC+L1LbjWhTBA5txNSdILFFuehqG1AAFi6O
         9FFXQtE3wEyWAx/KTW4DvbnWU0555LQufuq58mG2YXVyMAm7zmWbj2Do5bGgW7FU0QLg
         rU7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lKAKUxf31iKD63H2Y0R9CiFoIGve/JWjHjtQtrBS0Ms=;
        b=fSs1x9bd/Tms8M5ozL2eB5Kf59UB8muAS9OTNQszDRbbSGiRcSl76PNKwrJB/+hKrJ
         r/XOI8CwYIL0z7qfKYAuQk7TKWOU9t+iQfaxwq3CgBfFTUgexfdfYQOluVppHVN3d0ei
         QCXiC7eflrrEjOgLs54FKWkNCcx+av6Vkb1itisxeTJ/M9F/51QGgY1jETFwIC/Jh7DU
         1uGyQALtoWEVDMdxeOKUgPNXvG3xgCGG4ChmV47FfGucCrcUa2r3yri96FPcj7XevN6m
         pQPqmVVZJoGQ8P8JJGYoVrEoijz5ybvsGXP3uab3KxI7yU/EGnq6AWfQHRFUdJGcCkT6
         cnVQ==
X-Gm-Message-State: AOAM531w4jtxTIgYe+l0Cbg6f4nu9u7R0euyq5QDf8BC/BmANgI81UZh
        7f5xKERybNfAousrI81Xy2XXDBloGvVfyh9TV3duKA==
X-Google-Smtp-Source: ABdhPJy+FZgfBxwY1B1vWiFkN+0yNyJwK9IFit8KDwpqVReFYXiMGHAwd/jE6zHcj3ul75tt87NPL7Zhuye5jc1lsnU=
X-Received: by 2002:a17:906:6987:: with SMTP id i7mr18844230ejr.18.1604981671363;
 Mon, 09 Nov 2020 20:14:31 -0800 (PST)
MIME-Version: 1.0
References: <20201109125022.614792961@linuxfoundation.org>
In-Reply-To: <20201109125022.614792961@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 10 Nov 2020 09:44:20 +0530
Message-ID: <CA+G9fYtTw1u_Lyg95fxv1w=z=hsRpDYVod0xGHbH0idj=uf-gg@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/85] 5.4.76-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 9 Nov 2020 at 18:42, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.76 release.
> There are 85 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 11 Nov 2020 12:50:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.76-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
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

kernel: 5.4.76-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 0972a1f5fd7d894036d1060885a60a3c7f702de3
git describe: v5.4.75-86-g0972a1f5fd7d
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.=
y/build/v5.4.75-86-g0972a1f5fd7d

No regressions (compared to build v5.4.75)

No fixes (compared to build v5.4.75)


Ran 37138 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- nxp-ls2088
- qemu-arm64-kasan
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- x15
- x86
- x86-kasan

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* linux-log-parser
* perf
* network-basic-tests
* libhugetlbfs
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
* v4l2-compliance
* kvm-unit-tests
* ltp-tracing-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
