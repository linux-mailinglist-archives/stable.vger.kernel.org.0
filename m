Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56E3249AF6
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 09:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725934AbfFRHob (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jun 2019 03:44:31 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:45329 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbfFRHob (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jun 2019 03:44:31 -0400
Received: by mail-lf1-f67.google.com with SMTP id u10so8454888lfm.12
        for <stable@vger.kernel.org>; Tue, 18 Jun 2019 00:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uOt44gNbqC0n9BpMxtizdXC2L3VUUEGukyH8Eh7hqjc=;
        b=kGqWnthDpDY939cuqtuCvndn4ukCZvXPdDzRRXuKMvkHkz6DpdyvgmUPi5y5n3riu1
         zZ4NjDlItaJ9J8IgfjiJExfRs/G5MMC6r6GeT4wZgY3B24wanL7NK2fanL6Gs/5IjlAh
         0c3+4O1e6EQQ2r+E59/mGRs+iePIx1NXSMVz6p0ITFLMkJiwhFsIrW0k/oc6wDIFb740
         Hvw7D0GiM/j5TABP1/4+yHv68syWV50AhYOjs7Or7MSBjtcL6vroH5WC+uYbG2D+4Jk/
         jliZIs27Ap9v5odQX1hd9h1kP1SWqwy4uC4UKIPCNmgQ7Vo41MJqKI3yr6etPPLg5avc
         AibQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uOt44gNbqC0n9BpMxtizdXC2L3VUUEGukyH8Eh7hqjc=;
        b=dm+vXMzu1QJIkjKliMtE/IRe49QBE9i2+R8LmntAd38nZGbv/k/rWo21RS0vMNxPpT
         v3WFYcJ9h94ML1WaRs4vPFUwn6P6g9lbKFIdlNTMaOpekDXRo+DUKuw9oGGPhQqz67Ux
         GM8H4jJQIde1Ow3FT6XRhx//qyT/VgYy6gwedyoLruEMxdXrPtqyCaAur5SoCa5HSRbl
         aL8vbKWCDULy1CMwNq3ZsWu9OBLl2/jZWB8Z4wCJhIZ5Nb+jSWeQXel1liad+8s1ej2c
         ekU0sXLtoLp0ZeMDuEkgBRh4LeES22DQbN+o2I1288sjOauTm1ni4hTh7QROvcHqNuFx
         /tkA==
X-Gm-Message-State: APjAAAWZwkSSPuBZIVEYXCS1NyF2qs681QfwwQB5n3EjxvgwqJkNtBfF
        cTD3ysGIMk8V+sfBvLIiipJsyuj2XhlXPKN1z2GomQ==
X-Google-Smtp-Source: APXvYqyqEt/ImBvxkLvS2rsbF3LkIy/Yu9CicO18EHNbC9J/KuJucNWlzfYzS1bsMwf087ySF0Zn54nNCBLPTFBODSM=
X-Received: by 2002:a19:488e:: with SMTP id v136mr56122136lfa.192.1560843869634;
 Tue, 18 Jun 2019 00:44:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190617210752.799453599@linuxfoundation.org>
In-Reply-To: <20190617210752.799453599@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 18 Jun 2019 13:14:18 +0530
Message-ID: <CA+G9fYtj0REFYMAmJPSkCNe4DVZ6_1SbQfMro9H3jPXq9gmtzQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/75] 4.19.53-stable review
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

On Tue, 18 Jun 2019 at 02:55, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.53 release.
> There are 75 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed 19 Jun 2019 09:06:21 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.53-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.19.53-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: d486e007abd08ab6e977da19580953578878bb41
git describe: v4.19.52-76-gd486e007abd0
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.52-76-gd486e007abd0


No regressions (compared to build v4.19.52)

No fixes (compared to build v4.19.52)


Ran 23439 total tests in the following environments and test suites.

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
* libgpiod
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
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
