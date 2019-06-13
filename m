Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E04BA44C28
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 21:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbfFMTdO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 15:33:14 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:44682 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726969AbfFMTdO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 15:33:14 -0400
Received: by mail-lf1-f66.google.com with SMTP id r15so15983931lfm.11
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 12:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=c9ZNNyY0aAgnUGlU2N1cfSpPm/+6YLQimoPRphvJFXk=;
        b=T/UfiqqvExYl/77DaBCENt4/KwiVFqR++QkCiJMg7LELwUVu+6ClbtetN5vJlzCGDk
         g4HQOTUeAaURetk43QAtIIUMmU/Q+qetq97dksnw4ThW+jqpdgQVxYy3tnVKOhEFa64Y
         x3GgLj9x087kAXy+E4XsaB1ckMtaSRX/d+8zz0eGXIyb4TGWyLHvRXyW+wLiiJcA4PzD
         BDcMq83kYBdnIlIoyo81svAvBDRrzauFwQAoEuDN9tEOUAVhaqUbtkN/UlUW7yQGTklr
         +PumEQnCVmLEO2mEWBH5ntDudSpYMF58bn0dFf/wnyd0etFVq+8uNCD7dFm1AOa8fvTv
         PvQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=c9ZNNyY0aAgnUGlU2N1cfSpPm/+6YLQimoPRphvJFXk=;
        b=F6E9+CNNVkxvavV2BPPnL8INlH5BOr1mPKz92WaCnP57D6kQzi04X9UglTCkafAYZq
         v/dYJ/JW/QhgEqp5FGlcfjGKsun1ZrCNG+c9mH1/Wdz/RVe5YM1Q6VYhxfI7i6lX4E96
         HvoLakB4sNeEo830/PGU/OVoap431WNTXh8Z+8riMqhuGShQs9GSUUP9adQW6zLbb0Z4
         KlqlTZPJ3NkUL5bdzYqZx0jtGDchfUNqblW/nGne/ENe9ho9JGdk2SGQkNaOEWvZGeZP
         PaYvnpNyQpgBJm0dvyx+0a+zcjcsIpB99wAqfnI6bJAX/84buWdi80wLWAcSs8PrmKPg
         Urig==
X-Gm-Message-State: APjAAAVbJrqAwLWWfP5VCUtGB0q9l7cC2Nq6PrpMwbW9Gz5WjVsVpmJg
        D3jIdsaivHodbo3zE09ZRJLNQHuqHnDljc5CYQkxJQ==
X-Google-Smtp-Source: APXvYqwRB6uP1sroftuO9L0AaS6dUuyFNvHR+Z9Yo/AKZ2xpY8apXp+LvGfgfzRji42EqljK9X75u1HWzR7rdpBKU7Y=
X-Received: by 2002:a05:6512:51c:: with SMTP id o28mr29191232lfb.67.1560454391745;
 Thu, 13 Jun 2019 12:33:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190613075649.074682929@linuxfoundation.org> <1139f9d4-1a0a-b422-276d-546e7cb1bc85@roeck-us.net>
 <20190613153744.GA15226@kroah.com>
In-Reply-To: <20190613153744.GA15226@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 14 Jun 2019 01:03:00 +0530
Message-ID: <CA+G9fYtP0pQ=5TH1R4UEJVKd5jcGVApo-RRZ+Ud6Bjq7BE_Z1Q@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/81] 4.14.126-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     sashal@kernel.org, Guenter Roeck <linux@roeck-us.net>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
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

On Thu, 13 Jun 2019 at 21:07, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, Jun 13, 2019 at 08:11:33AM -0700, Guenter Roeck wrote:
> > On 6/13/19 1:32 AM, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 4.14.126 release=
.
> > > There are 81 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> > >
> > > Responses should be made by Sat 15 Jun 2019 07:54:51 AM UTC.
> > > Anything received after that time might be too late.
> > >
> >
> > [early feedback]
> >
> > Building mips:nlm_xlp_defconfig ... failed (and other mips builds)
> > --------------
> > Error log:
> > /opt/buildbot/slave/stable-queue-4.14/build/arch/mips/kernel/prom.c: In=
 function 'early_init_dt_add_memory_arch':
> > /opt/buildbot/slave/stable-queue-4.14/build/arch/mips/kernel/prom.c:44:=
14: error: 'PHYS_ADDR_MAX' undeclared
> >
> > The problem affects v4.14.y and all earlier branches.
> > PHYS_ADDR_MAX is indeed undeclared in those branches. It was introduced
> > with commit 1c4bc43ddfd52 ("mm/memblock: introduce PHYS_ADDR_MAX").
>
> Thanks, I've dropped the mips patch that caused this.  I'll also drop it
> from the 4.4 and 4.9 trees.
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.14.126-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: 743300ca6410e30133ce3d09a668fe6477d3a67f
git describe: v4.14.125-81-g743300ca6410
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.125-81-g743300ca6410

No regressions (compared to build v4.14.124-38-g2bf3258a12af)

No fixes (compared to build v4.14.124-38-g2bf3258a12af)

Ran 23674 total tests in the following environments and test suites.

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
* ltp-fs-tests
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
