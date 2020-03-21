Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAE9C18DDD4
	for <lists+stable@lfdr.de>; Sat, 21 Mar 2020 05:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725932AbgCUEBr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Mar 2020 00:01:47 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:38493 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbgCUEBr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Mar 2020 00:01:47 -0400
Received: by mail-lj1-f193.google.com with SMTP id w1so8669026ljh.5
        for <stable@vger.kernel.org>; Fri, 20 Mar 2020 21:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=J1e25ok0Cea0GbmYDetYeX++8jPK1S3QLqovpWb3HI4=;
        b=H+tIkewn/XgD+BJbRf4UwEw/eMrZSzyA81TwwOKB+dl5o3NDCkLFWOcyFy7q7YPGKM
         Is9ITF5b80J5JSChudWaRAfsq4jcZwfgY8f/B+8OXanMIJaadNQb997bnu5n/BI9CvB8
         nsE0BdZHUcPvXKQOMY0Hjoln5xsa4Or+ti6tn7o/W9xVWuTKRELrLosmZuc9urwEVE82
         AoGC1nxuYYXrv9rbHW1EdfOHBH38AfILwoBS545iekubSUz93MXbPu4rSAICBBUdhFp/
         82ZQYlxdn6t7Ae9N+ZgeqmNfiKgc1suML9oGi87E3gCXrRdShAtr+414m0TeyTKh7RAm
         0y4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=J1e25ok0Cea0GbmYDetYeX++8jPK1S3QLqovpWb3HI4=;
        b=XoA+R229N2nXnzyXcQbl2GbYqWcIhabFCbPjASZSgumVJcSWyVPXheBkoHeYjNvIs+
         Gzm1w/L6++ZeJ8w+Ih9Icm4hdgOici0ixYRoN4lQAvawbhvC7AE2v8lFYywtI/Dcz86t
         SZWW93eWnqLKF7r56g2z8OAnRChNcQIM2MQ5XXD0cJCvXSFEEWYsdvwv7d/Tw35Zhqm+
         6+PG9a00AUw6Xmh3OxV7xdxVOk01T8L8qxd9tXFuOVea1V4uiR+4jiNT7dSDh1fcNeeo
         S9A3VNHyczi7iBM6GyPo13fAmKQ+3/BEeabxDXqJhsIRns//iXbCn1JafNZog+adzIhP
         vf0g==
X-Gm-Message-State: ANhLgQ2BRcthKGfciQV0xtkkm8SRgR8vXubK0ecLL1dm+j76IKt4waCE
        BZ1Um1adQHvzu2GhxYfZescRy7ExUojOm1zcyCoQAw==
X-Google-Smtp-Source: ADFU+vuWFzlEGhYuPi6Q3O+WLo3d/JBv9KurrvtbDu4WG1NvtbLYydrx80UO0NaF3VBzAAKiB5Mjn4U2YrkBDC5gEE0=
X-Received: by 2002:a2e:3309:: with SMTP id d9mr7458543ljc.73.1584763303443;
 Fri, 20 Mar 2020 21:01:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200319123924.795019515@linuxfoundation.org>
In-Reply-To: <20200319123924.795019515@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 21 Mar 2020 09:31:32 +0530
Message-ID: <CA+G9fYvJEAHcfqr2NrGdxdkW2JJEUHRxmGF0uY1xTevW-jEAww@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/93] 4.4.217-rc1 review
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

On Thu, 19 Mar 2020 at 18:35, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.217 release.
> There are 93 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 21 Mar 2020 12:37:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.217-rc1.gz
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

kernel: 4.4.217-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: 2f57fed8dba0810ba3a6cc7ee0b8018efd4c81ca
git describe: v4.4.216-94-g2f57fed8dba0
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.4-oe/bui=
ld/v4.4.216-94-g2f57fed8dba0

No regressions (compared to build v4.4.216)

No fixes (compared to build v4.4.216)

Ran 18231 total tests in the following environments and test suites.

Environments
--------------
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* kselftest
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
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
* v4l2-compliance
* kvm-unit-tests
* spectre-meltdown-checker-test
* install-android-platform-tools-r2600
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

Summary
------------------------------------------------------------------------

kernel: 4.4.217-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.217-rc1-hikey-20200319-669
git commit: 7673c791bfb045d15ddf3833701a4af7980de307
git describe: 4.4.217-rc1-hikey-20200319-669
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.217-rc1-hikey-20200319-669


No regressions (compared to build 4.4.217-rc1-hikey-20200317-668)


No fixes (compared to build 4.4.217-rc1-hikey-20200317-668)

Ran 1637 total tests in the following environments and test suites.

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
* v4l2-compliance

--=20
Linaro LKFT
https://lkft.linaro.org
