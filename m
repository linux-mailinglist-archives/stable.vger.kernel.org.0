Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC5816D113
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 17:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbfGRP0V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 11:26:21 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:33472 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727762AbfGRP0U (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 11:26:20 -0400
Received: by mail-lj1-f194.google.com with SMTP id h10so27797582ljg.0
        for <stable@vger.kernel.org>; Thu, 18 Jul 2019 08:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CvCb/Hmkx6VKaXRPJlJzKW0Bo+SUrlZLU15Pll+9TIk=;
        b=NvRZKap8ZGUt47uiwGcUsy0F/83GA/Uxu1DH6rqinTOpMf0NBJFsrlOgRC2baCzCar
         Tm53U/YxJuqfYcbJZCqeuG0u3movLgnxtfJnt4RHhk9QneSernRgFkwa3gl/Xo6TtbGu
         nbiIqvDVvhpwq1hhp1k7ZEgz2tf5al71jagv4x1Ez6FCCuvpG6fqBdmVm6IRxhzLRzCA
         SV2rSQ9ZWvRheeQAG4r4SfbnQ352iuFkyMAKq/s/n8FqlilL2YFAy1U9BpUsWcNGryL0
         SiXQe2vQERueNLKLKdvcXwP5/ju1O47m9h0PF5Jok4wpmVwnpvCnKxJ7UdGJpBq20391
         mCkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CvCb/Hmkx6VKaXRPJlJzKW0Bo+SUrlZLU15Pll+9TIk=;
        b=sesCJL5aIj6dPGrVwBzEHiIU1vVRiJMYnN2BREiGEk6mrqB8Mw61EOyDhF/PfVWtBo
         jMyUV6z/G55ETRt+DgxdJ8bSP0dn37DzQf6koOYdcBjJrLU3ilNz2OdDdTceJPejuSwf
         kxpPVzBkb4y3fGKfQWbyrsRm9y6vCYYYPgZT0LncFi5mCCZ0FgTXppQI/7mifASyHlCT
         IHeXAXXwLjEYozzy0XwElV1DwsrPyVKuachcpI+mJ5aK3IuYIWnqG44iCawFyk5SuC6V
         bQGOJKYZ8ric3DRZytmHdybcAj4IpEKLDYotK73iuKgE3CzLcynK+Yqm0TsiwvRfNBoy
         433w==
X-Gm-Message-State: APjAAAWJiJ6vMOzIE2oBZQ9pFUtAxGuFheaJMvqzIy4Xkh+pm/mhy13a
        1hW79omwq3V7Cta5pmfin+NX4Pr0zLDRXVHvA0YBPw==
X-Google-Smtp-Source: APXvYqwce8BgCXnf24IeZGLaVZRArDi+XxHTVDu1zFe9lREC3QLVMnkwgkPM7fbSJpVBOhL/hmZ8MqTZOPajzDktoyQ=
X-Received: by 2002:a2e:85d7:: with SMTP id h23mr25025059ljj.53.1563463578698;
 Thu, 18 Jul 2019 08:26:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190718030039.676518610@linuxfoundation.org>
In-Reply-To: <20190718030039.676518610@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 18 Jul 2019 20:56:07 +0530
Message-ID: <CA+G9fYvEPFEfiM9b4ZHzwP8gW4MBFFg_-LgBq==9=Bm6Ny4BJA@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/40] 4.4.186-stable review
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

On Thu, 18 Jul 2019 at 08:45, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.186 release.
> There are 40 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat 20 Jul 2019 02:59:27 AM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.186-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.4.y
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

kernel: 4.4.186-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: f046b75a1ffd3ca49e30f811d72f9b907e11a5e9
git describe: v4.4.185-41-gf046b75a1ffd
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.4-oe/bui=
ld/v4.4.185-41-gf046b75a1ffd


No regressions (compared to build v4.4.185)


No fixes (compared to build v4.4.185)

Ran 20136 total tests in the following environments and test suites.

Environments
--------------
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
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-timers-tests
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* kvm-unit-tests
* install-android-platform-tools-r2600
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* prep-tmp-disk

Summary
------------------------------------------------------------------------

kernel: 4.4.186-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.186-rc1-hikey-20190718-499
git commit: cbbe9f9a965018d031c8824a93a085280fd747bd
git describe: 4.4.186-rc1-hikey-20190718-499
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.186-rc1-hikey-20190718-499


No regressions (compared to build 4.4.186-rc1-hikey-20190718-498)


No fixes (compared to build 4.4.186-rc1-hikey-20190718-498)

Ran 1549 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64

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

--=20
Linaro LKFT
https://lkft.linaro.org
