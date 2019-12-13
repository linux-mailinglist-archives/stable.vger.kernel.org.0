Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADF0911DD46
	for <lists+stable@lfdr.de>; Fri, 13 Dec 2019 05:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731995AbfLMExs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 23:53:48 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:44498 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731967AbfLMExr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Dec 2019 23:53:47 -0500
Received: by mail-lf1-f68.google.com with SMTP id v201so941978lfa.11
        for <stable@vger.kernel.org>; Thu, 12 Dec 2019 20:53:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xcxpDcAG9VP48qgpFfm3Wi/PAqquqxmDaKMk1UlnOxg=;
        b=ToyqCs9Bkqa/Ql8gmVASxVt9LufhuncYxrJBa1mArqOslsUjfHGw3KE3rPE2i1JN8G
         I6QlzKmbfHc7ekqabx35sulGtOchCt4knLVS9uzZYU2WoiGgGd4wTBtNtN0kwIoIJflL
         SAXN8K9aoIwSXsxUdcWFUznPJ0y5iDHiqsnhsGs55IPbEtZJuVgbINalTDOSXFfzM1OY
         IXh9heXVGwKm1gTkWzY3fU6thiko9eSKhHhEaGmwcjRxlZbf7A3qheqDbHS1YWViWe3x
         /wORwmgtWx9nlsNmWi65kKVZx1IppYzVz4SIdecXbOU1xyFFm3/7p4wrpNuZMc6P6YYW
         URqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xcxpDcAG9VP48qgpFfm3Wi/PAqquqxmDaKMk1UlnOxg=;
        b=bTtMx4z6jPtKv2qYId+Lj4y+7AaVA+99AEYz05fKRL+4SFbLEWA8gONpRvdhRVFQ5w
         PCLsYREKviieUxWHGlCJmgbFTNzrVRGsTbPpEEdKmKrvgH5j8hcwADEpdaGu1a0ISZn9
         CCsS2Gg9tXsgY5iM11ScQU8cssR4pEs/6HC2WA+L57mvrf3b3AVn+esUqXb3AFlHj1ZV
         +cq0+U+XdkDnDokg28QCTKGfEe2DGTgKibfN+Oq6pn+pH6oigryHbRp1ALQx41Xwnq/3
         yQx/QDJyYDxji3bfR8mswC+bH9lRStyOgDrB246VHdpdceqXKG/eSVEOWJqAVe5KcAn/
         tRew==
X-Gm-Message-State: APjAAAUFK8QUBFF7E+ta3uSAMPi0Xo3mhWJaG44sDrb5rP3VtT4Cw62Q
        uYEPx/ZP1uKUityBNcVNiqKG//8hW8hBMmzDblTVfQ==
X-Google-Smtp-Source: APXvYqzM5rCiHFJ12SU8esnq1jWwMppBjAxP3AGA9bAzKUzqNGpi+SsjbPvkMxeDW1kdaX48kPNGuvajyoGBowMfyFI=
X-Received: by 2002:a19:8a06:: with SMTP id m6mr7222605lfd.99.1576212825129;
 Thu, 12 Dec 2019 20:53:45 -0800 (PST)
MIME-Version: 1.0
References: <20191211150221.153659747@linuxfoundation.org> <20191212100456.GB1470066@kroah.com>
 <20191212121805.GB1540720@kroah.com>
In-Reply-To: <20191212121805.GB1540720@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 13 Dec 2019 10:23:33 +0530
Message-ID: <CA+G9fYu3_Q5NxeU9wig5U4Snt8e9K+-dfRNPCHBZidq5j5RfXg@mail.gmail.com>
Subject: Re: [PATCH 5.3 000/105] 5.3.16-stable review
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

On Thu, 12 Dec 2019 at 17:48, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, Dec 12, 2019 at 11:04:56AM +0100, Greg Kroah-Hartman wrote:
> > On Wed, Dec 11, 2019 at 04:04:49PM +0100, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.3.16 release.
> > > There are 105 patches in this series, all will be posted as a respons=
e
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> > >
> > > Responses should be made by Fri, 13 Dec 2019 14:56:06 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >     https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.3.16-rc1.gz
> > > or in the git tree and branch at:
> > >     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.3.y
> > > and the diffstat can be found below.
> >
> > I have pushed out -rc2 with a number of additional fixes:
> >       https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.3-rc2.gz
>
> That was the 5.4 patch, here is the correct 5.3 patch:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.3.16-rc2.gz


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.3.16-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.3.y
git commit: 9f27b7f4a193786bae731a293fc61de389cd549f
git describe: v5.3.15-116-g9f27b7f4a193
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.3-oe/bui=
ld/v5.3.15-116-g9f27b7f4a193


No regressions (compared to build v5.3.15)


No fixes (compared to build v5.3.15)

Ran 23837 total tests in the following environments and test suites.

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
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
