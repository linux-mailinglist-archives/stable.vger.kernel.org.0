Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A13E9A9B5
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 10:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389306AbfHWIJb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Aug 2019 04:09:31 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:41437 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389276AbfHWIJb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Aug 2019 04:09:31 -0400
Received: by mail-lj1-f194.google.com with SMTP id m24so8017574ljg.8
        for <stable@vger.kernel.org>; Fri, 23 Aug 2019 01:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1oC9ul/byHaTj9kHAFt1syinUgIIsihUipkOTFXN1b4=;
        b=g6xQgguIn8bkm+g/kORDgmq94PQSpmT9mRwB2slFoDsxvCtKMbAqIpSxU69hy9dGLY
         Iwsd533mpLn9km1zbGwGgNEiC54wgReNQW6p0lP8uodnTpHug2jHGqaYeUuWniPpFoNa
         9t+wY2hsx0HULPQpywmAKWyvWJnVkhEDJFxV+WqLfL4yNBXquK23I4Oq9g+9BX/sRq1W
         9qBZ5bpZ0gSZRiiaphmc+kKcor1P21KOcz0NNWHbtUDr5N15oeFVtXYqWVJ4CPKiuuET
         81X6osZDFIAlSIbRiewNJGoK88AUMLzFgtT/J71X3wFVAEfPJQW8W0DuSSvo/bjmCUpL
         VI2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1oC9ul/byHaTj9kHAFt1syinUgIIsihUipkOTFXN1b4=;
        b=CqJCS9kMU3DnD9JRs/D7n+gxIbcW6AerOqC2CRkqVC7Nmr8Ag9PQ5hjCReQKZ8/73e
         9Pc0YJtBijGKuPTsEFdnY3aeYkHr+8x54lTUVIF5dicSNJVr8voYuA01clmY1E8GxlL+
         3XeQ8wfJ7c6nuV4TGUdFyUAGkPD9WB+A45gr3+mNQTZI2cWJ1/JaCbC7CmNkTP3cB4yh
         zREj6vpBuyncoaZh+Kts/URQkG954yXT6FI6kyQt2suBwgkrpLoorkX9dnqV7p+57Ak3
         D5YOjUzboUIbliig+OqcJAPwLKVzfqdiZCc8JjaZygIhK/fydz+U7KBvLUbwbOcQ+24Y
         p/5g==
X-Gm-Message-State: APjAAAVeBXR7wWlTfWWKyXlSpED4zeJCyRXg6vmjxEsnWYGngZ/+ahk1
        mZjoh2E9x8KccFj5g4Z+9M3eu7eV2q9jObpRgYirHg==
X-Google-Smtp-Source: APXvYqzOceqFYC1iSqtfJx6cr3uKsvLAa0r7BzZjT2fFOV/Yn++jandiwJ+bVFVhqOEY+1t/OjeEWsM4x5TFGO6dguI=
X-Received: by 2002:a2e:a0c3:: with SMTP id f3mr2101512ljm.123.1566547769296;
 Fri, 23 Aug 2019 01:09:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190822170811.13303-1-sashal@kernel.org>
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 23 Aug 2019 13:39:18 +0530
Message-ID: <CA+G9fYtuPOCnmua59DDVCQ9ueJRz=Q0bgh_QYZ7Ct-OtH0DZ7A@mail.gmail.com>
Subject: Re: [PATCH 5.2 000/135] 5.2.10-stable review
To:     Sasha Levin <sashal@kernel.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 22 Aug 2019 at 22:38, Sasha Levin <sashal@kernel.org> wrote:
>
>
> This is the start of the stable review cycle for the 5.2.10 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat 24 Aug 2019 05:07:10 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
5.2.10-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.2.y
> and the diffstat can be found below.
>
> --
> Thanks,
> Sasha

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.2.10-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.2.y
git commit: f5284fbdcd34b923c32f702a0d46a00b9e744d71
git describe: v5.2.9-135-gf5284fbdcd34
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.2-oe/bui=
ld/v5.2.9-135-gf5284fbdcd34


No regressions (compared to build v5.2.9)


No fixes (compared to build v5.2.9)

Ran 22639 total tests in the following environments and test suites.

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
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
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
* ltp-fs-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
