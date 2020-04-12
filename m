Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3E7E1A5D94
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 10:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbgDLIvg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Apr 2020 04:51:36 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:37252 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbgDLIvg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Apr 2020 04:51:36 -0400
Received: by mail-lj1-f196.google.com with SMTP id r24so5946948ljd.4
        for <stable@vger.kernel.org>; Sun, 12 Apr 2020 01:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pUaWyJBANBIsSu7R/tcWw2JGAIRnPcaSbBQB9PvP+EE=;
        b=tebMGg3/T7EnCmpjv9uu+uJzLAgBtO+1Vr0hkW97KsHIs2vgInARxQjy4sQ5s1lOU9
         dyUbwL8eniOKOKutdRX1jszpB1KSqrdKReN/+5qFzU9JeW57wHGeufp2OKl54ojtYhjd
         OlFTN/G5B9evz+5yTBtpiVmrilPU4JhdjErcuEeYeb70kK+7UGwLs3FKPRC6U4vvjlks
         rwavAcGPBNGe50Tg3JTUaI5YIX69y0GUNBz/nGZteB3Yyh/4A8gR11aFroPTbgR/hjaO
         Wo+xMWNcYpSSArbqdLAJcKrzK9VRykp0Zo2KhwZfHR3Kf1bUyK1HaLcz5UUJbeYZJ1dF
         DR5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pUaWyJBANBIsSu7R/tcWw2JGAIRnPcaSbBQB9PvP+EE=;
        b=OMvv+KUwOKwCCii5WfCpBJ1Y6oRAAFSAzVabtGDUnrVdsEkfsL7hmsoZKPVAB91TkX
         7CpknKbOuTCKxmHm5FhniTesnwpjA+qMWvXcI7vOTpLveei7mEUj8vn01UhGRMPB77kO
         WCRYprr35wd8Q6L+imK7QlDxWxTcggQ6r2NO3eCGjD2no/E8bITSrj0B7bMY3CpY2sCJ
         63eJ2ndSDVN638WDI+T/tbvo0Iv9U7pq0z0mqw6PcBcG9BmW4Kpo6wTikSmBveEB4Fom
         6vLBQzH9/nDl9a52GhtKjlxzzEcJ8jJJplUoPtD3LL7i2vuW5IGqjAnDBu1AWtipE2/8
         A9Fg==
X-Gm-Message-State: AGi0PubnHzjw2/zmeBnZOCjYXepzs12JniyfJlqIKeXz7IkyS3MlnYyY
        t8jVb/LpJO4K+nQuJ5cLHn7pIjIufXHbbavuX2HKdA==
X-Google-Smtp-Source: APiQypJHGvxCXtrEW6SrynlvYzXZK5Z6Ab3LG5+qUTAVclUsUTIdEB9LH6XDqMt3XPcsEr3E8tuIzalu61iDCm4YVzw=
X-Received: by 2002:a2e:a495:: with SMTP id h21mr7498580lji.123.1586681495507;
 Sun, 12 Apr 2020 01:51:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200411115437.795556138@linuxfoundation.org>
In-Reply-To: <20200411115437.795556138@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sun, 12 Apr 2020 14:21:24 +0530
Message-ID: <CA+G9fYt1VxRP3ssQrO1zvCO9hdLO+eqC_X0i8kkos3DQesge5A@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/38] 4.14.176-rc1 review
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

On Sat, 11 Apr 2020 at 17:45, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.176 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 13 Apr 2020 11:51:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.176-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.14.176-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: 42fb2965c7ca26057bc47af5ef45f170bbf2cade
git describe: v4.14.175-39-g42fb2965c7ca
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.175-39-g42fb2965c7ca


No regressions (compared to build v4.14.175)

No fixes (compared to build v4.14.175)


Ran 32276 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
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
* kselftest
* libhugetlbfs
* linux-log-parser
* ltp-commands-tests
* ltp-containers-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-sched-tests
* ltp-syscalls-tests
* perf
* v4l2-compliance
* kvm-unit-tests
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* network-basic-tests
* ltp-open-posix-tests
* spectre-meltdown-checker-test
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
