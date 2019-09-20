Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7023B8B3E
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 08:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732507AbfITGsv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 02:48:51 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:35126 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732492AbfITGsv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 02:48:51 -0400
Received: by mail-lj1-f193.google.com with SMTP id m7so6005428lji.2
        for <stable@vger.kernel.org>; Thu, 19 Sep 2019 23:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=173BRYZ9x6alpIPcRk5BJ9zuLWX/VdslH4Vu4ViMU1Y=;
        b=lbD1WO7yB7R0dOyl7OmpRWseR1LK7WwUOgSugKroU0fSXGSeZ1Dlk+VAzDSRFbQVwD
         SlblZ8+sDwPbsEmvVhpD/mPFN4SYlJcFbDpH8IUpKLWcCKWL7jHVSbCFuiMlWdrO7KRU
         xdDi4MZTA/kevzKBc7/hdNiR903uJlSS3kWLhDpFI3kALsHwFlFnlEEnCBKrswZA5pGb
         AJbPp12YrXk2nCYfRDOeA2BwZ7moqQi4LWb0RGLx/WDCzgbF7gUcM+amuBLaoCv+Cg3s
         oZReIH4ghk6uP4WtG5+DTOmAzBfQ80GUrSipGL3XPQKGl/Ww0nCHHAHNfN13/37lCqS0
         Frqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=173BRYZ9x6alpIPcRk5BJ9zuLWX/VdslH4Vu4ViMU1Y=;
        b=YUgFLCK2IJNHhhLegEYzmAgkcP+zAwBQoNM1vm0rFtKZbwU3BDJ4Rr5mncsisSiO3T
         6aM1bQPWSd7m+PGyNmL8vIqdm2BOf/yryMuufkf2vto1Ag6bbETlcUK0W/vEeoPY3Zzk
         61V3er//7qShSoYvCPM2C1UzK78klgn2XFOda7Vg3H5pFkT8CRkJ0o5YZgLFR1o86US2
         X7xIN1zMdamIMPigjdpTcwzsrh10JXqlhMVcxGa/24oHo2fD3MlIkMJ6MoGLYDhC2jiW
         3pF3D9ivvOEuQVsrCPUlTw26aPg5rnwvgGjrgbw3CXLWmjYrQzrFLbbMf8Bc9/f9/YqU
         /3EA==
X-Gm-Message-State: APjAAAUeBbR/43A4aqOV6z0WTUEXEDFzalmECik7XApE77uYZ/lYde1g
        cVacalS0hIxt3Que9ZObqLeEEQ2lwwjIYlkIgcz4QCzCDlQ=
X-Google-Smtp-Source: APXvYqy/EI/T6YZeS+T/wiUshJbbv0BS+oknh5gi9c07Kohq2IOkrIK8RpvPqb0wVdusqLrUrRHO6ouMOf3JGWpsZ1c=
X-Received: by 2002:a2e:a178:: with SMTP id u24mr7912665ljl.149.1568962127988;
 Thu, 19 Sep 2019 23:48:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190919214800.519074117@linuxfoundation.org>
In-Reply-To: <20190919214800.519074117@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 20 Sep 2019 12:18:36 +0530
Message-ID: <CA+G9fYuxXBBPU6HfQBa+zhQRzTS+DzUcXvw4zt6-Fz_fBS0wiQ@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/74] 4.9.194-stable review
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

On Fri, 20 Sep 2019 at 03:50, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.194 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat 21 Sep 2019 09:44:25 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.194-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.9.194-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: febb363e252bd50629d7efc675ba30286a33f209
git describe: v4.9.193-75-gfebb363e252b
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/bui=
ld/v4.9.193-75-gfebb363e252b


No regressions (compared to build v4.9.193)


No fixes (compared to build v4.9.193)

Ran 21866 total tests in the following environments and test suites.

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
* kselftest
* libhugetlbfs
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
* ltp-timers-tests
* spectre-meltdown-checker-test
* v4l2-compliance
* network-basic-tests
* perf
* kvm-unit-tests
* ltp-open-posix-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
