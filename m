Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFC54DF0F
	for <lists+stable@lfdr.de>; Fri, 21 Jun 2019 04:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725936AbfFUCSj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 22:18:39 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37915 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfFUCSi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jun 2019 22:18:38 -0400
Received: by mail-lj1-f194.google.com with SMTP id r9so4527173ljg.5
        for <stable@vger.kernel.org>; Thu, 20 Jun 2019 19:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dTHPPGOwBa2FwhZr/ABNXZ8z65KGobDyyMuTtBj4fGY=;
        b=NP3m09PdLpDP7GTWWKWTx/AXHOWapsHVodgAXmFiSzcTk8VDI3pPk8sUEyMCwtq4h9
         OSnYDqui8WtcCdwDjkUJV0gY7cHEwL0qUw5DMLZtP6kK4yj68AaFSpz+gZCRO/Fi0eZx
         +PdbF2UQACqlpL+lNWGSrkND+sb90IwpgARI9F8gCW7KeUo0lE3wCAvQd1SZtOhp/XIC
         lIcP5fBtMJwrvADOjimBW/e0toSfOFiHkVCLJDxtiEAm+5FVZAkaomjxGkmjcil3l3e3
         rnZA9WhhbQItLYm0ndYzhXIlB55PvU81AoW6YeZ3+xvXoZphPnTe97pc/QwneAcI0A0L
         E4Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dTHPPGOwBa2FwhZr/ABNXZ8z65KGobDyyMuTtBj4fGY=;
        b=XHymH+0rGfgXoPwj3z/zImuMn980bonFdlJkf7Lmua7B24KvQMReh6oCzEMxO8lgnz
         P8zdKMGN/6nw6cPR/NQXHP6JOeXdPYV5rkg8P1jfksTE+ovuvAr5bnRJgRCULOk6sX/4
         4yuNQqHaM7rLgobDLPeqf1n1UgItpEa7QUdLYxsa643jY46UeiP15hanuZ9ECTn8qrGN
         +byFYKd+Z4WxheXx2OUtA8debYE6v4YuV7DyC4VI4G+xxH3fQpcUZWywpDb0N9VQLG2s
         w8HwrrAYWDCj52q6tzynBQ2v1NevNB+5TDTvSWUHoJ7Bi6VxVpS59owFMH8ykUaPr8uv
         kj7Q==
X-Gm-Message-State: APjAAAUb5vI1b+KiYKDVme6fdp5s8bXMt59hc4fgKox1ATyU2xu3RPq3
        EMEWit+dnR0M5tMa3v/YcdlNqU2ifqf7AOaoOP7HjA==
X-Google-Smtp-Source: APXvYqzouJwCr7psc+7u/bTqPqXAvLl4AsG+Q4VFOuozxFshhjP4aZNTQXTfoNwoctR4jMhX1Qze7PQGdpPmVUFpRug=
X-Received: by 2002:a2e:824d:: with SMTP id j13mr70202386ljh.137.1561083516657;
 Thu, 20 Jun 2019 19:18:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190620174351.964339809@linuxfoundation.org>
In-Reply-To: <20190620174351.964339809@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 21 Jun 2019 07:48:25 +0530
Message-ID: <CA+G9fYtGi8iaw=Uiuvtju92z7NHWf+AiFO2aF9egOORptiy98w@mail.gmail.com>
Subject: Re: [PATCH 4.9 000/117] 4.9.183-stable review
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

On Thu, 20 Jun 2019 at 23:33, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.183 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat 22 Jun 2019 05:42:15 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.183-rc1.gz
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

kernel: 4.9.183-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: b2977e94f62a4008b6cc418f3af3c1a04ddb8ce3
git describe: v4.9.182-118-gb2977e94f62a
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/bui=
ld/v4.9.182-118-gb2977e94f62a


No regressions (compared to build v4.9.182)

No fixes (compared to build v4.9.182)


Ran 23588 total tests in the following environments and test suites.

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
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* prep-tmp-disk

--=20
Linaro LKFT
https://lkft.linaro.org
