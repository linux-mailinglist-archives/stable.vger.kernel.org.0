Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13F71F07DA
	for <lists+stable@lfdr.de>; Sat,  6 Jun 2020 18:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728836AbgFFQMW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Jun 2020 12:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728844AbgFFQMV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Jun 2020 12:12:21 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 707A7C03E96A
        for <stable@vger.kernel.org>; Sat,  6 Jun 2020 09:12:20 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id i27so4478060ljb.12
        for <stable@vger.kernel.org>; Sat, 06 Jun 2020 09:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OG5llYWkn5ZpZagpX7W+tCCaDr6jjTc5m5YMMo8l7Zo=;
        b=RIMhhhmoI8UwYKTaRLxkh0h69EFG+8vPgB0xAZcBNFa4lnNxKESC4KSXBt8gFrhAUE
         Oi+JRFdXlVPE34BG7/HmvYmzlnC+hDguRK/3Xj+fX/PSPcMnlccucMCKj3+aODceoNyE
         ypeL5bCX59z1VGqnVEkm5Cvy1e6gj0CXNxmJrezyXpcb6OJwFAwfVV2MtNqUk162Pjez
         7O9akbngW5USEJsCP3ZLJOHqa8N2maMpTB/bobZ5wK/F+qoXkn/SIDO/GEslzgB5+r1X
         NnR/t82w4yUl3Mu1uOPLVDcoZuhkJYXBfjnhcAn3/wMgF24LKVjWlHWYpH2shiAhSX2d
         3whA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OG5llYWkn5ZpZagpX7W+tCCaDr6jjTc5m5YMMo8l7Zo=;
        b=diu5dswNxv9g024guCmqKZJGgR1ZyoWDSYF4BkXmyY+ouiUYuucllgHnhIfr6iK/Ap
         QEa0aJb41kfORiU50cGsSvomeSUBXc2FWd60CowoA39fPOzLJ5jxy6y9Xodk8SD3cr1N
         nSpWUkiMFalen633o0z5yUs3waTpwUWYG7I/yaqpmdECDE471xmvgB4fggyuGrcgWeD1
         pgo0pU0dp8Lp59LYhTC3aJAxl9DZY3WSRI6b+6XGo/Xfibj6LJRuuHgWTpraGC/4XUD4
         pVCCqbWdJ5EVGEEmTPYq2PE05pWq7ZB+K+x5FAdhHpXcTSrCu9lMq4uRy8JuXSXnIIwh
         0Bqg==
X-Gm-Message-State: AOAM531lYLx+eIUer1PErTHOOFGgLEcPwIMQExdlqTCN4gPdCS6K7682
        hvDw79n9bxyNAlydaR0HRCvLgBWx0LOJxrAtl9iB6Q==
X-Google-Smtp-Source: ABdhPJx1bJBffMprTiS1CSYX4PIv3MJoz0FvJRUKQinahJ0Wo/qcO1CalKfwe4bKmuLz4AUd5ISsCSvhslEIpIVUUWI=
X-Received: by 2002:a2e:9c91:: with SMTP id x17mr7774513lji.366.1591459938611;
 Sat, 06 Jun 2020 09:12:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200605140152.493743366@linuxfoundation.org>
In-Reply-To: <20200605140152.493743366@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 6 Jun 2020 21:42:07 +0530
Message-ID: <CA+G9fYvDNVD0h8mKCsg+v2J=+dDuC4fcHT2Qk+u_1FMFHtWtZw@mail.gmail.com>
Subject: Re: [PATCH 5.6 00/43] 5.6.17-rc1 review
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

On Fri, 5 Jun 2020 at 19:48, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.6.17 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 07 Jun 2020 13:54:56 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.6.17-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.6.17-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.6.y
git commit: 6266fb28693fc3d724b6a365a86e04a846a4f991
git describe: v5.6.16-44-g6266fb28693f
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.6-oe/bui=
ld/v5.6.16-44-g6266fb28693f

No regressions (compared to build v5.6.16)

No fixes (compared to build v5.6.16)

Ran 33592 total tests in the following environments and test suites.

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
* libgpiod
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-dio-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* perf
* ltp-cve-tests
* ltp-hugetlb-tests
* ltp-mm-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-open-posix-tests
* network-basic-tests
* v4l2-compliance
* kvm-unit-tests
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
