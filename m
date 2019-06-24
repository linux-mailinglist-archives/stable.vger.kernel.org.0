Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD4551795
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 17:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729946AbfFXPsK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 11:48:10 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:33173 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729466AbfFXPsK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jun 2019 11:48:10 -0400
Received: by mail-lf1-f68.google.com with SMTP id y17so10445824lfe.0
        for <stable@vger.kernel.org>; Mon, 24 Jun 2019 08:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=RZEdkpcm2DoHjvk4iUfPQvATQTAXaYA2G42qvscInT4=;
        b=dawHkGuwoexp/U6hls2tL0rd5MvFhGfNSloIQ+uyh77OZa7CX83DBpFsVz46qXyLqT
         N9cKp33Sgbij/OFfl5O8Vb/6gDUmUBgod/uZsNoo1a5W0lJ4JcxR1jRVIHNYSfgdZRmT
         3cba7yDMHC72BKn3lpDbP1L80zDGHeOzLQXJRS/MmBKjVkdZ3aZ0jV0uWTFATqjHyWZE
         SegzHVNZvsVD9EQdsLJqCrXXfjG2P+DLZqM2k3mgQyAoGfYZyYQx8ktPllYpNu8qwhNx
         RuUQuEPB98VMSi50jhKHSHv+z/Sh7ypGJuiNBktpxD2+tstBCGrmM0ca6tsB8vGIN0I+
         vi8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RZEdkpcm2DoHjvk4iUfPQvATQTAXaYA2G42qvscInT4=;
        b=AAaK2ylzmxEVbcIhhNyeJPIvDUiPKzVn2MgKDi7bcLuWLPv048D9W9B/ERI0iJ/5dj
         szOa6hLigyx7uYoR4AVzPxabzzcCGKDShgSF1sVWzmkUYL/b4TaSFUl4Ttme6CHZVC1O
         G6hK8s52Bn1YGvmBe7zbBsWVmD+2eLRrSClQjfcOUc5fPFUuXKIKyL9pN/TQMmBgwxLn
         Su9CSgwqQ/Cla2fRvly4nWge9ztk3CXFeOx45//HPAAZe3g6T7jKqwInJ0PCXRomm1uL
         9LqUBc+h5cNt53NbnALNsJmymYeLhoSoTNgm+QEK/MjyxWTL98w7z7pVgs4pTteM0xfs
         Cv8Q==
X-Gm-Message-State: APjAAAVhuqmfA9cylhTxbzpc+Om9i1SvIGR9rFZcjYngDHko8o6ufX/p
        Oh/NXhSy4xRY41HvRIchU23P5SxK66WNrY76WuP3oVIgQnShKA==
X-Google-Smtp-Source: APXvYqxNqQUU12xxGQ7h+SpiZ3wpTHj5k3ZD3y0Vai59zG1U4M0mk/lKZRcyrF3ostVcAQAs9MKINZgIvPFiMFrQTGw=
X-Received: by 2002:a19:671c:: with SMTP id b28mr8802495lfc.164.1561391288073;
 Mon, 24 Jun 2019 08:48:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190624092305.919204959@linuxfoundation.org>
In-Reply-To: <20190624092305.919204959@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 24 Jun 2019 21:17:56 +0530
Message-ID: <CA+G9fYvWbPPYeT+odDHhpq6QeOKOJyfo7cOeX_FBuFMUZ3POdA@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/51] 4.14.130-stable review
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

On Mon, 24 Jun 2019 at 15:29, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.130 release.
> There are 51 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed 26 Jun 2019 09:22:03 AM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.130-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
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

kernel: 4.14.130-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: 57f3c9aebc308dc826ec1191e750fc853e79fb3a
git describe: v4.14.129-52-g57f3c9aebc30
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.129-52-g57f3c9aebc30


No regressions (compared to build v4.14.129)

No fixes (compared to build v4.14.129)


Ran 23741 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15 - arm
- x86_64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-cve-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-timers-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* kselftest
* ltp-dio-tests
* ltp-io-tests
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
