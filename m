Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A377712800
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 08:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbfECGuE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 02:50:04 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:39020 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbfECGuE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 May 2019 02:50:04 -0400
Received: by mail-lf1-f66.google.com with SMTP id d12so3650292lfk.6
        for <stable@vger.kernel.org>; Thu, 02 May 2019 23:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1kSepQ57Np35bAbZP6a06Oga5L1IXObYQ3D5v/bThhg=;
        b=U8ZFZuY1aRDo781JTWMxR/vTWPAssGZIy0MYIb/A5uuH8Y35wfYa6AaDdVe+wQx26Z
         FwdlIRq5AR1Nvxf32GmWlpWr+29aDb0TC50I8iQVovnaApdAjwjTostWI/Tvc7mv7+s8
         Cl8FG3rH11duhW8o8NOHrfTQMwDDqkDy5XYpb13CNXsxmgFb3Z1Hs0TfVOEa4NEbexF8
         NKjVfwerfuphBg2aghM2JmGaJtHzc7krROAzlua2iqtRZU/Mhcm4i/oJIOLNOIEegMlk
         ooUyyr7vHa2xMo4+uQkeORpU/KdjytwMpSqDLv5gmmPbU6z6mLfcFJ1V3o7YYHjQQWKf
         RfiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1kSepQ57Np35bAbZP6a06Oga5L1IXObYQ3D5v/bThhg=;
        b=sDhbxqLoxNzuotPkI7gglCpwH+OC0U5um95opX3Z8B86VRTO4yvxhzR2x7eB92i/fw
         TDeOf8b1sJhWhm4kFcjnX2ye9cWmiXrblj4xA6UXkAJ3GeEPnWVoqVVG6b75DZltSXbs
         oX/wXZrmak4G8y7eAEfeZPAtWgUKp3CNO54H5+A9nA+YoWs+kxzQAP8KPOBQyG+ZF2z/
         Ts0jygAKjbvbOmn9yAD7KUpRjcGcFKAPMC4Q+47/bEXPhQT/OyqT7gM4jjCRXBMT+Dnw
         OWjSodSC4L3Ntm7W0xsvxhb1LUtpTeCCSYlLvkR/PMMlOKGQAGqg0FHjf7YmM4REnPfe
         wBKQ==
X-Gm-Message-State: APjAAAWeLW3zgT1ANEQCO5czp//lCgHgtSWd8jCpL1m8bk2Y53gRZFsW
        pjZ4TceAsEGw/cJgnDXJYNX4Of+koWAjd+DPl3g34w==
X-Google-Smtp-Source: APXvYqz93pCSH8atc4z9XsP6Fr93k4FFm93v2txrcLTOJhLE09pHuXR0cvMGS07Dpw7ojno2PdVA8mj3GY0cthWcHl8=
X-Received: by 2002:a19:6f4d:: with SMTP id n13mr4165736lfk.57.1556866202694;
 Thu, 02 May 2019 23:50:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190502143339.434882399@linuxfoundation.org>
In-Reply-To: <20190502143339.434882399@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 3 May 2019 12:19:51 +0530
Message-ID: <CA+G9fYuu37iYrWuY_+jYjawjmFmjvMTOXJCFKT7k853-_ruiew@mail.gmail.com>
Subject: Re: [PATCH 5.0 000/101] 5.0.12-stable review
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

On Thu, 2 May 2019 at 21:00, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.0.12 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat 04 May 2019 02:32:10 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.0.12-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.0.y
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

kernel: 5.0.12-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.0.y
git commit: 17f93022a8c96d740be0f8dfc01e1ccaa70eea5f
git describe: v5.0.11-102-g17f93022a8c9
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.0-oe/bui=
ld/v5.0.11-102-g17f93022a8c9

No regressions (compared to build v5.0.11)

No fixes (compared to build v5.0.11)

Ran 22922 total tests in the following environments and test suites.

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
* ltp-cap_bounds-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-timers-tests
* perf
* v4l2-compliance
* kvm-unit-tests
* ltp-commands-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fs-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* spectre-meltdown-checker-test
* ltp-open-posix-tests
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
