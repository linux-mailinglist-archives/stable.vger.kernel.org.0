Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA84914C572
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 05:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgA2E5V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 23:57:21 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:40110 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbgA2E5V (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jan 2020 23:57:21 -0500
Received: by mail-lj1-f196.google.com with SMTP id n18so17004967ljo.7
        for <stable@vger.kernel.org>; Tue, 28 Jan 2020 20:57:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EUiBQW7fFVKAo1Q+j3dYSwSL/GbxhFJ/cd0sx4ZZX8M=;
        b=WU4ddS7yQY5pA43m4G8GfPo2GM2cN2qCFZVE902mOGOrfGU79U8aBUkllYtcmZuCoK
         XTZjbBsEaC3+uxicB0qyZ2DlL9lpgsCVuN+2dQPX/mUWqWlEYdKVL4qQpC5uoOhS2Jkh
         DZ+u0wxmeaRssMD/q0EDtxPOATZWop78AVwDYlM4r5r3ojnVRZUox8zNy/XAUSaYmdsb
         V0j0X2B2jKuzdKk4riVn/eCjBkOnUbBql1xw6Du7O+mcl8KPahsuDSgCRK3/AlbJUGUo
         r5GKSuxdVQnbocBe8P98MNm4qj91NCeXb2SzfSK6R/nx5CsWnc2UtXBO8SPtVWaeUXdJ
         3kuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EUiBQW7fFVKAo1Q+j3dYSwSL/GbxhFJ/cd0sx4ZZX8M=;
        b=knWQT9tsQxWB1GQzIB7T0BJ1i12aNz9SdVUBBsNzoDFqxPoGg2nKg3wjI8pNTzi+yq
         LOaNb7Isuq1So3AceZG8+i14IaVsGPLb43ZrKYT4wLSfzvh4DtAD0VlLnUKXV/f/Ho6N
         uIT5acbaxu8hbmoval48Jf3d+D155TWoalfkOBJxLv5lu36EOf1lkd09CAcnVRy0pBFp
         h1vJ/5hBQDgLjRCtcU78LES4Pq53b+ltpxy8M54vqyIarDSzog4X13NRgZOAfSS5aY+k
         xfFuZnXwoRiQLIfxnTxGsyN/plaGrjIMYriVjzuvsZleMWBFLhi9f7sRYwTneW8eULrt
         +SNg==
X-Gm-Message-State: APjAAAVcH3QySoHk7GbFbBUC5pvq5n54YFBRjyVLvuT4TaJwr0nMWLd9
        2mpyOEJOh2FUjyTHBj9+I5frJsZOVSfhQbGMiDFEjfpIIpw=
X-Google-Smtp-Source: APXvYqyG+F/zK8PjyVYNIQd8MApGS74OfzMLTN6xzkwsjIkqLp6SevlBEsGODFEo41/GcjBAafvPYCfMXH/S6lUBUIk=
X-Received: by 2002:a05:651c:1072:: with SMTP id y18mr6803647ljm.243.1580273838666;
 Tue, 28 Jan 2020 20:57:18 -0800 (PST)
MIME-Version: 1.0
References: <20200128135817.238524998@linuxfoundation.org>
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 29 Jan 2020 10:27:07 +0530
Message-ID: <CA+G9fYtgz2NyCjRpF3aQv2nz1j6+4ETT6ZFNLG2bhRUPH8UxAg@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/104] 5.4.16-stable review
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

On Tue, 28 Jan 2020 at 19:31, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.16 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 30 Jan 2020 13:57:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.16-rc1.gz
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

Summary
------------------------------------------------------------------------

kernel: 5.4.16-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 4acf9f18a8febb1cd7bd9c284ee494fdeb40ad96
git describe: v5.4.15-105-g4acf9f18a8fe
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/bui=
ld/v5.4.15-105-g4acf9f18a8fe


No regressions (compared to build v5.4.15)

No fixes (compared to build v5.4.15)

Ran 23853 total tests in the following environments and test suites.

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
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-hugetlb-tests
* ltp-mm-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
