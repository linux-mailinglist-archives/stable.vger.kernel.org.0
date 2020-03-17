Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE092188EB7
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 21:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbgCQUJw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 16:09:52 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:33230 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbgCQUJv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 16:09:51 -0400
Received: by mail-lf1-f66.google.com with SMTP id c20so18381947lfb.0
        for <stable@vger.kernel.org>; Tue, 17 Mar 2020 13:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=o6SMg60n6dg5E5UNtnrzS3MRKvlSt5FGzxfh8BfptUY=;
        b=ke6ursww/qGx36NPHKodMebn0EUWWsMpVusLaZnkOpVW16yVEPxURVZvdHjJW5xlxc
         /fBVoTH4pSjtmzDRfYhTokDMC+zY+jqgErQtkwsLueAieSGDOl7pfuu+F/vGCUbbQpUe
         rfz3iGX8H5xNjpoSTrepPgyvUczTk8vou1/inD0ok/7yJ6Z7d/QDadu+uQrvFafHAZiK
         xpxIL7qfbmo2eGGt4T6v6HPURn64jNGobJsjjVKMnyr1+3GTdnGbmKqAu4iRGA1OifK5
         QAcvyl/yjB7vEKsAwoD5H8ETdTH+Dqhq+BehHn6yaPUE9teBuvehF4QAs4DK/HoTL6UQ
         rdOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=o6SMg60n6dg5E5UNtnrzS3MRKvlSt5FGzxfh8BfptUY=;
        b=CiFInfNZpUWqiLzQWr3kyfpfGhoSiMGv2vAqENZoYtfQs0dhMwtsKPZU8uixNWlnr2
         7ZckudoxRheVO8FIiza7JTpecWzKXLibeoJYe+df/SOt/WHioL/zuXC8n0MLzjB1HHmp
         clETKuP3C5/EQPVMe3Dm0t4m4+U/gmuT9Ox77LrJ1myyZa1puvVEWs1CPP7bH1susCgA
         W2qEHqnWg1I3HvNycqnC2YpBfNaToYuVeyLXVHhkr/Xs8Q8XgECxj9lQBXVyXkUVgGZX
         Q5qy61HlwbKJVba4pDbtL4xxLkNSl47jZ98nsMD73b+bocKogd3dq+zZpXkBh4htPS0s
         PIhw==
X-Gm-Message-State: ANhLgQ3+ptlB6fKBUbb4yrdMu3BjPXuB/Sx1xZGL4p/vPgamjMQ3t+5s
        4azHFQJyP+9fZhF8ax7E7E21E/Mtj2Kwb+bh67nQzw==
X-Google-Smtp-Source: ADFU+vv5pChAMal27PYi3RBLZVYCuM6C/nsMAuznRXnLPi7fU0rTV7p7aYC4q66wQ2a17tzJYUe9zl6GEKrM26yZajA=
X-Received: by 2002:ac2:43a8:: with SMTP id t8mr678007lfl.82.1584475788356;
 Tue, 17 Mar 2020 13:09:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200317103307.343627747@linuxfoundation.org>
In-Reply-To: <20200317103307.343627747@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 18 Mar 2020 01:39:36 +0530
Message-ID: <CA+G9fYvJfOc9VJMUs6yQN-3BVgHMmCM3L=fbAffwQHETYLV2EQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/123] 5.4.26-rc1 review
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

On Tue, 17 Mar 2020 at 16:32, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.26 release.
> There are 123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Mar 2020 10:31:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.26-rc1.gz
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

kernel: 5.4.26-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: bd9158ff941e0efcea216f7311abc7fe13e8ae39
git describe: v5.4.25-124-gbd9158ff941e
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/bui=
ld/v5.4.25-124-gbd9158ff941e


No regressions (compared to build v5.4.25)

No fixes (compared to build v5.4.25)

Ran 16905 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- nxp-ls2088
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
* install-android-platform-tools-r2800
* kselftest
* libgpiod
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
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
* perf
* v4l2-compliance
* libhugetlbfs
* ltp-fs-tests
* network-basic-tests
* kvm-unit-tests
* ltp-containers-tests
* ltp-cve-tests
* spectre-meltdown-checker-test
* ltp-open-posix-tests

--=20
Linaro LKFT
https://lkft.linaro.org
