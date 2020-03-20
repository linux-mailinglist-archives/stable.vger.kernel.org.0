Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8281818D4B0
	for <lists+stable@lfdr.de>; Fri, 20 Mar 2020 17:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbgCTQly (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Mar 2020 12:41:54 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:46039 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726935AbgCTQlx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Mar 2020 12:41:53 -0400
Received: by mail-lj1-f195.google.com with SMTP id y17so7088213ljk.12
        for <stable@vger.kernel.org>; Fri, 20 Mar 2020 09:41:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CaZ0r65X92Oxu7GzVKpyix0zMa0pOHAykHkKw8nV8IU=;
        b=tIwc6+70CRNkkxf9Bma96+ddMStZ0BSBedkphLIyty/Dmt7yi8/AE9ewVIL8DQLe2G
         q3bqK8nAKYXMpKYORMB4NnUYDcQaNu9gkP3HQQrNdSw2ys3oIZYjtenv0MotnBX4Eaz4
         Utl6axkQI963l56bqWYmooCw1vyCeDNn8L0ZJCtJ4nBRNvsxWts5Vnp23EkqRJ7X8hNh
         XlXcg8IOuxIh2qeBhRATDM8//GMVMAbzHCQJflwblAtv/9U72xdHUuOkQutneSK9TCer
         m+Zuja8hXxP2UTMg+BUyxrX78Qus960+IyTCDP0XrC1qqhVnMxJANA1wSyAiyQLuYAy7
         moaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CaZ0r65X92Oxu7GzVKpyix0zMa0pOHAykHkKw8nV8IU=;
        b=cXmhRDSELVaaKA96AVmHLJGjiKshjPHWeRM8UG4Pw6mqLAL/olC3KwnDf5tSRtTlvC
         kB0v1z8/4bFORVT2fiNhj7sktbSogYBGjatr/gDhCbwkZn/tzIPfevvCvG9xBhywTY9u
         SKQFF66GPOD4zoUNMhrAjxBZT4KTxSwqUw/EJYOZjZoWjOQYMrY8Qvp6EZOFzFKsoGDj
         9FqPv20eY3VPj6PDaR3EHkiSd+L8Gc41GVHzI796IWtNPKhbhrm+31SDdetWIkcEDVHL
         hnyAb6ZR8hedE5cUzsp6WL0kqzSK/qG8M9VB/yEOdUa03XqHIj+0ejl24eYE1SwipBDQ
         GWVw==
X-Gm-Message-State: ANhLgQ27GwwshYlSb2BYlnEMqNo21WmmlKxYZdRxqPsNWaxjZa1z36I3
        LrVv/uMTbShJIjD1SyDtF4I9DdptV/6Eg+HRbS4tag==
X-Google-Smtp-Source: ADFU+vvXj/1ErVqk4FcUHN8aEU2aBjr/TJ6KGh6YPa4D8H5lLAQ++EhwhU6eKk3SWeXmxyMwGYSzftbNLNrWo2EgxHk=
X-Received: by 2002:a2e:988d:: with SMTP id b13mr5879420ljj.217.1584722510255;
 Fri, 20 Mar 2020 09:41:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200319123902.941451241@linuxfoundation.org> <CA+G9fYsDw6JEznSHm2X=Wvq1dysGbGa4-VpXJyzKWZQxLMdagw@mail.gmail.com>
 <7a8c6a752793f0907662c3e9c197c284fc461550.camel@codethink.co.uk>
 <20200320080317.GA312074@kroah.com> <20200320081122.GA349027@kroah.com>
In-Reply-To: <20200320081122.GA349027@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 20 Mar 2020 22:11:39 +0530
Message-ID: <CA+G9fYtS0u1onCKCiZApRkZXzLMgW6X54z5OfHBOeE+v1=ApOQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/48] 4.19.112-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Faiz Abbas <faiz_abbas@ti.com>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 20 Mar 2020 at 13:41, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Fri, Mar 20, 2020 at 09:03:17AM +0100, Greg Kroah-Hartman wrote:
> > On Thu, Mar 19, 2020 at 08:00:32PM +0000, Ben Hutchings wrote:
> > > On Fri, 2020-03-20 at 01:12 +0530, Naresh Kamboju wrote:
> > > > On Thu, 19 Mar 2020 at 18:50, Greg Kroah-Hartman
> > > > <gregkh@linuxfoundation.org> wrote:
> > > > > This is the start of the stable review cycle for the 4.19.112 rel=
ease.
> > > > > There are 48 patches in this series, all will be posted as a resp=
onse
> > > > > to this one.  If anyone has any issues with these being applied, =
please
> > > > > let me know.
> > > > >
> > > > > Responses should be made by Sat, 21 Mar 2020 12:37:04 +0000.
> > > > > Anything received after that time might be too late.
> > > > >
> > > > > The whole patch series can be found in one patch at:
> > > > >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-revie=
w/patch-4.19.112-rc1.gz
> > > > > or in the git tree and branch at:
> > > > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linu=
x-stable-rc.git linux-4.19.y
> > > > > and the diffstat can be found below.
> > > > >
> > > > > thanks,
> > > > >
> > > > > greg k-h
> > > > >
> > > > > Faiz Abbas <faiz_abbas@ti.com>
> > > > >     mmc: sdhci-omap: Fix Tuning procedure for temperatures < -20C
> > > > >
> > > > > Faiz Abbas <faiz_abbas@ti.com>
> > > > >     mmc: sdhci-omap: Don't finish_mrq() on a command error during=
 tuning
> > > >
> > > > Results from Linaro=E2=80=99s test farm.
> > > > No regressions on arm64, arm, x86_64, and i386.
> > > >
> > > > NOTE:
> > > > The arm beagleboard x15 device running stable rc 4.19.112-rc1, 5.4.=
27-rc1
> > > > and 5.5.11-rc2 kernel pops up the following messages on console log=
,
> > > > Is this a problem ?
> > > >
> > > > [   15.737765] mmc1: unspecified timeout for CMD6 - use generic
> > > > [   16.754248] mmc1: unspecified timeout for CMD6 - use generic
> > > > [   16.842071] mmc1: unspecified timeout for CMD6 - use generic
> > > > ...
> > > > [  977.126652] mmc1: unspecified timeout for CMD6 - use generic
> > > > [  985.449798] mmc1: unspecified timeout for CMD6 - use generic
> > > [...]
> > >
> > > This warning was introduced by commit 533a6cfe08f9 "mmc: core: Defaul=
t
> > > to generic_cmd6_time as timeout in __mmc_switch()".  That should not =
be
> > > applied to stable branches; it is not valid without (at least) these
> > > preparatory changes:
> > >
> > > 0c204979c691 mmc: core: Cleanup BKOPS support
> > > 24ed3bd01d6a mmc: core: Specify timeouts for BKOPS and CACHE_FLUSH fo=
r eMMC
> > > ad91619aa9d7 mmc: block: Use generic_cmd6_time when modifying INAND_C=
MD38_ARG_EXT_CSD
> >
> > Ok, I've now dropped that patch, which also required me to drop
> > 1292e3efb149 ("mmc: core: Allow host controllers to require R1B for
> > CMD6").  I've done so for 5.5.y, 5.4.y, and 4.19.y.
>
> Ugh, I forgot, that broke other things.  I'm going to go rip out a bunch
> of mmc patches now...

[Am i missing rc2 tag ?]

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.19.112-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: d078cac7a42286ba7c97801a763fc42ad7baf5c1
git describe: v4.19.109-136-gd078cac7a422
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.109-136-gd078cac7a422


No regressions (compared to build v4.19.109)

No fixes (compared to build v4.19.109)

Ran 23963 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- nxp-ls2088
- x15
- x86_64
- x86-kasan
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64


Test Suites
-----------
* install-android-platform-tools-r2800
* linux-log-parser
* ltp-ipc-tests
* v4l2-compliance
* kvm-unit-tests
* libhugetlbfs
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
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests

--=20
Linaro LKFT
https://lkft.linaro.org
