Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18A751A1D77
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 10:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbgDHIdv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 04:33:51 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:38025 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726792AbgDHIdu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Apr 2020 04:33:50 -0400
Received: by mail-lf1-f65.google.com with SMTP id l11so4493997lfc.5
        for <stable@vger.kernel.org>; Wed, 08 Apr 2020 01:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tvILii5CJ06FrB5H/A/DS06RAK/9uc+M6yIejdDAIMA=;
        b=t69Xq2ikv0jem5qSN2MzA8dQVEV2UR6xjYO8782vc835XQW8CGHcD+gpUyar4QV3HC
         mtxzF0oQyyjBQIt7UnJ/m8Kcoc77JPuFSMAZ6k4BywAn7btMJ0F4kgh+ulk3Ku6AEmzj
         XdLrWRSJs+l88+fX8vG5/Lvx4UFUWDziy1lFu8nnBDttdn9ad6xSXKtbEFyAAPlmPKd8
         zf63GHwmxiLkHzjbAj+0vnYkFkIujG5PH/FcmxApf7V6B1Lr+xyscfawC+T1A5FdE9RX
         CX1rw/OquduBwcSBEtP5vJWkXu1jyTojOC93LM6ZDt/vftHnP5IclYcYLOJC9uMmddpl
         yKdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tvILii5CJ06FrB5H/A/DS06RAK/9uc+M6yIejdDAIMA=;
        b=S7KqsgbPWvsKf7qtAQ60RxcXnO1sWObQnSZ+pjpXV2F2qUto8pmxt4N7xYosZj8Naj
         G2AQZ24A9CFXBmP9rtRaoHXc8k1ZFVaqQjj7nNVYexSd6m+c1KKpSt0FW2Pb/u8uyBCK
         hQLuTj8IxIWx8yn6FNrNwyFbkkKYuOTfRII1XseZ0Kw/2ad8fnvpI38nfT2B1ihIRkHd
         1UfRmTwKq6EZdtRc5CY/4H7LJ420JS8A6LjRktu5DLBbHUmHi+D1aldKXh1p5iEICsgN
         JDMAHbpcSNFHVA+rUqe5IJNjwQwepaQaaKawU2Lz7UAAo0Ky4HkupNSlqcPB4wonO2o0
         Th/g==
X-Gm-Message-State: AGi0PuZM7HX4vyQib4acwvkpcpz8HOpTnuDuwsacl1rZOKpgHXZlBkhP
        K7HYYVeAz93AgzXg6tS155zqfkouFRYPKh/CaK1YLA==
X-Google-Smtp-Source: APiQypITME2yJfcGPeX/mq09A/VOU2OcgdoVkUCAOPRENd0OVCBzgf7+1A2Mzt/AOn4LG05KhuntnKaaZk1HF30R7YI=
X-Received: by 2002:a19:4014:: with SMTP id n20mr3760109lfa.6.1586334825919;
 Wed, 08 Apr 2020 01:33:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200407154755.973323425@linuxfoundation.org>
In-Reply-To: <20200407154755.973323425@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 8 Apr 2020 14:03:34 +0530
Message-ID: <CA+G9fYuAC3Aj_Vy0gg5FxM4_p70+Fh1vA71QdFe=PGSEE1cYow@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/38] 5.4.31-rc2 review
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

On Tue, 7 Apr 2020 at 22:08, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.31 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 09 Apr 2020 15:46:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.31-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
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

kernel: 5.4.31-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 23c04177b89f23d80a3b5dfa54a4babfc32bea3b
git describe: v5.4.30-39-g23c04177b89f
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/bui=
ld/v5.4.30-39-g23c04177b89f


No regressions (compared to build v5.4.30)

No fixes (compared to build v5.4.30)

Ran 25033 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
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
* libgpiod
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* perf
* ltp-commands-tests
* ltp-dio-tests
* ltp-io-tests
* ltp-math-tests
* ltp-syscalls-tests
* network-basic-tests
* v4l2-compliance
* kvm-unit-tests
* ltp-fs-tests
* ltp-open-posix-tests
* spectre-meltdown-checker-test
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
