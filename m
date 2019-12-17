Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D48312251C
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 07:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbfLQG7D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 01:59:03 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:42673 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725856AbfLQG7C (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Dec 2019 01:59:02 -0500
Received: by mail-lj1-f196.google.com with SMTP id e28so2776228ljo.9
        for <stable@vger.kernel.org>; Mon, 16 Dec 2019 22:59:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=gCXcM3Z6W9NAgGoD2kjwa2E6lbe4ZAp9ODtTpFpt3dQ=;
        b=wHdoCC/h0wg6psEP2+R23RHzaHMOGSxMEOYkmjmH3D4EcnZdgxHDniHTSAM8IwgwK0
         I878YahTYLCNNny/7XuqDgBAjz1usaXHNkOKsD/8PE+EzyOlk1tSGgpzVQf+CZtPVfM2
         WZT0t7DVecRgYpPrkGWvpGfH73VQy6Q4ehTZ1FykPILfQ2zEVLpSxKlBX9HMyy3akaju
         e7ONTKNTzAz4cV7qoiYqfXRE6kdov8s47ZTMWJyOreun+MDgCSZdU78cDz5Z6L61CWKj
         EAkgvndG4y1FvBkVFbdsPJusTrac461vpg0Sm8Apak0dPTVQXD7d/WCeFaYCoRhON6uK
         2Nsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gCXcM3Z6W9NAgGoD2kjwa2E6lbe4ZAp9ODtTpFpt3dQ=;
        b=Uwjti0/PEb73Zesn2SpX+IC3a0uck7JkrhVR+IooW5CZrkl785qCVvP11/OhZuKdSU
         pYH4rqQKk2KhgdfUBe6CWApeZL8Gz0xVVtXpYoWyuhFHYvT/VqYKGkPnIduxp46/sRmo
         vYmoQUlgpe0KTiljDF7fncdIeniNM2SLZI2ueJy8kyX9Mc696qb3Lcten6t6pmByp/68
         MlTUCGQvrd6v4vrvX/aUym73qpw1aWclsERYIfoDkxHJus4ltvFDqrzlINnLGDqm9MT4
         dTWhd4QV9HT3B78qz8OTtoIdtjewwBpSEOdnJ2X+A55Ti4NOXLLFEIa9jRmzcAU+9Zkj
         v87Q==
X-Gm-Message-State: APjAAAUcCaiF/6oPE0QtL5BGNwomS4Srri0B9wEBHwn3IEyrZuOsr5sY
        eilzX63hW5R7uQDKjthrnqdtUa1hNoeHh/c2zlvR/w==
X-Google-Smtp-Source: APXvYqxxAVMifNBzKSK3bNCGn9iU/1vJhkx8xuXmf6znmTVVbeyqCP86sufC3b0wLUCJ6sbTx1Lu/TAyo3GiQEqMhKo=
X-Received: by 2002:a2e:854c:: with SMTP id u12mr1949721ljj.135.1576565940259;
 Mon, 16 Dec 2019 22:59:00 -0800 (PST)
MIME-Version: 1.0
References: <20191216174806.018988360@linuxfoundation.org>
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 17 Dec 2019 12:28:48 +0530
Message-ID: <CA+G9fYu5hZ43W6N9Kw-my2sB=Kn7rvH5xQs+3z5n_varti3KAQ@mail.gmail.com>
Subject: Re: [PATCH 5.3 000/180] 5.3.17-stable review
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

On Mon, 16 Dec 2019 at 23:38, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.3.17 release.
> There are 180 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 18 Dec 2019 17:41:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.3.17-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.3.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.3.17-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.3.y
git commit: 5770ae7aea0c5937b7ac1e2007f4c04adb0f58d4
git describe: v5.3.16-181-g5770ae7aea0c
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.3-oe/bui=
ld/v5.3.16-181-g5770ae7aea0c


No regressions (compared to build v5.3.16)

No fixes (compared to build v5.3.16)

Ran 23086 total tests in the following environments and test suites.

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
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
