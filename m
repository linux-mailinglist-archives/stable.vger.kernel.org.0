Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A555145D01
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 21:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbgAVUWA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 15:22:00 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:40367 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgAVUWA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jan 2020 15:22:00 -0500
Received: by mail-lj1-f196.google.com with SMTP id n18so495340ljo.7
        for <stable@vger.kernel.org>; Wed, 22 Jan 2020 12:21:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SlE70b9GGvg8Ik4bLAYKDMNh9X9O3cEIpNzQoPhTPYI=;
        b=bCqidwoCk+OIE0ZI+CE4W2w0NLFTQOV8nbURBEy6IU6TNwZL60tIfObVGJ/dQnYSnt
         +bsfk4ZN/ECzjHzdhYbVVu1phdqX8VqAR3ZUgPJiazPotTKeSCr2mEg3UkTp918K+mwl
         4wx8A+HT0ub+/MioSwUoY/eaUSxVlo6UkPViztK3rSUZpsy5sE3mD2c9tZzfdZ9WDRov
         kPnYquChZRi7Xq+myJsRX9fdS2iDF7SPsCV63yKqNTgDS9NT8dgJRH4cPbN5jGuTwc3C
         y1yxfgRlq+G0YYQaWVUJFisye4Sk2JJNDpSdr9I9pySxRHBa/uySjI7F0TBb+kHQey5G
         aTYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SlE70b9GGvg8Ik4bLAYKDMNh9X9O3cEIpNzQoPhTPYI=;
        b=aanQh6rDWRP4YlOykkErDP3uVzPMHjJhXbo96PntDSQZ2PK31ii1y0Vn7j/ZmG3y45
         89B3OMe2fCDZ5AgTz0s+WvKTPrUIkoZUASn7bNFfOPwGDNsNUp5Tc1BAWZRGANyolayY
         i7xK9sbAf3rK1GrWyet72U5L6uYErFzj9DXTl5gRNp8wf5duP340XT4A/uOlAT/VCVL5
         UBeVrlADMu9zjYXFy8dM0L8Wat1y9o51Kh/bRbXh+Yye64PhMPaaBfW+pBcyYKi5Da0z
         seb0u9exzvyVBQStodEfkExSWKgQoGSvsYZ1xeBdg4F/mkIdg00wa0W9FsUer2X2gZm1
         Gl8A==
X-Gm-Message-State: APjAAAUrxBsw2eXCypbF5WuRyGfwj+AZrWPlAtgzVId7+K3QsMk67sxu
        QzCgoTlfp/pwMihTspknkwnBNS0pOled77/E2Agm2A==
X-Google-Smtp-Source: APXvYqxAyOGy3TmikKcAXOITTYIlBv8awZbFxrro6cVwaB6Gi0h3uw1y0ZtvzHEEISpymMnzseO8lYsGGSECl4Jxquo=
X-Received: by 2002:a2e:965a:: with SMTP id z26mr18377280ljh.104.1579724517965;
 Wed, 22 Jan 2020 12:21:57 -0800 (PST)
MIME-Version: 1.0
References: <20200122092751.587775548@linuxfoundation.org>
In-Reply-To: <20200122092751.587775548@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 23 Jan 2020 01:51:46 +0530
Message-ID: <CA+G9fYt5FzE_ZpPJvRavoowaKTDwH76PhUu8ak4VGkfueiy67A@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/76] 4.4.211-stable review
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

On Wed, 22 Jan 2020 at 15:01, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.211 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 24 Jan 2020 09:25:24 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.211-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.4.211-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: 14fe1f1189f56887f53ae61e2e3218be16f0c2db
git describe: v4.4.210-77-g14fe1f1189f5
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.4-oe/bui=
ld/v4.4.210-77-g14fe1f1189f5


No regressions (compared to build v4.4.210)


No fixes (compared to build v4.4.210)

Ran 15214 total tests in the following environments and test suites.

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
* linux-log-parser
* ltp-commands-tests
* ltp-containers-tests
* ltp-cve-tests
* ltp-dio-tests
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
* ltp-open-posix-tests
* ltp-sched-tests
* spectre-meltdown-checker-test
* kvm-unit-tests
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-fcntl-locktests-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* v4l2-compliance
* perf
* install-android-platform-tools-r2600

Summary
------------------------------------------------------------------------

kernel: 4.4.208-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.208-rc1-hikey-20200101-645
git commit: 45aaddb4efb9c8a83ada6caeb9594f7fc5130ec3
git describe: 4.4.208-rc1-hikey-20200101-645
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.208-rc1-hikey-20200101-645


No regressions (compared to build 4.4.208-rc1-hikey-20200101-644)


No fixes (compared to build 4.4.208-rc1-hikey-20200101-644)

Ran 1568 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
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
* perf
* spectre-meltdown-checker-test
* v4l2-compliance

--=20
Linaro LKFT
https://lkft.linaro.org
