Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1661F18C0A1
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 20:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727593AbgCSTnI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 15:43:08 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:43745 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725817AbgCSTnH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Mar 2020 15:43:07 -0400
Received: by mail-lf1-f66.google.com with SMTP id n20so2649750lfl.10
        for <stable@vger.kernel.org>; Thu, 19 Mar 2020 12:43:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hEyvsVPado7F0WDhXMyM74K/P3yaowt2+RSX42jlfiE=;
        b=KdpEOokF+jp3VWlzdvlnt1vtlRtlQ0kD3tO5T2dWEBANHPs/omObqJEymHhPgg6wOY
         HiRtFOwyQdHGobb/whEjsl53iRJ5yzvAOYE7UFzfUGHGJ9umdccv6VHwoJExljv43BWp
         D5QEhtNhwf8TfB7U64usKlG+urtHujrUJ3KpJlPwrVT12s9z2nmu1I2kLvH+CCqDsZ7/
         DRRrFTio7t+0hfTJJCCXGUsCA1x+9+FKAE9buti4S6ikx9CrPSDDS3Po+etFROlbAXpU
         igS6t8l4wLXrwFiKjNlqnO6xlq55Si49tz6qUPRj8Arnqg3YTn4fvuuVjZHh0wPk3G9X
         w8ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hEyvsVPado7F0WDhXMyM74K/P3yaowt2+RSX42jlfiE=;
        b=WZ2dbhIYtQN7zemQcvXmkHJDBDoeQijOokhMd+E0pzVagavxFueaD+R/cTtpLnvP9l
         eutCFDyJcnj/sZC10QXdUrJlbmHjzHmbA1JFAX03HETAYGZiWnviujh4IwrWY3y16mpW
         SApV5IWgKIWVSjbtlEHtOCsG3e6YYuEsbexF4U/GYXsrmCg/3a3qOcqW3c0spqxV38Gs
         6hCnM6YlGRufnLJRBAzCC9xWCEWlEoZVLQvFgX7CUB7Exw+lnKsZyAN1Z7/JnJOiS5EN
         q8a/zgm3/krRVzzRGekAPqVNTTayPVksYLY3LO8rkV+T7hVBcLWYIaoGWOt1lIYhx97N
         z+MA==
X-Gm-Message-State: ANhLgQ1WSqjillw35DXg3l/NKnjp8Mr/5xiIhMh0AtCYWYD4rGCkKf3L
        7gJumEYI5Y5pTPRyiKIYro1Pu4Alz7ezDb/ilaPVjg==
X-Google-Smtp-Source: ADFU+vuR1vbgAfaEOXIaj6t7Eg3XiOILIOF3cfNxnHalXSH2d3L615MBo1VcBUcRB8Z1FTKfpWKb79jNTP51gIQRzjk=
X-Received: by 2002:ac2:43a8:: with SMTP id t8mr3074856lfl.82.1584646985521;
 Thu, 19 Mar 2020 12:43:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200319123902.941451241@linuxfoundation.org>
In-Reply-To: <20200319123902.941451241@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 20 Mar 2020 01:12:54 +0530
Message-ID: <CA+G9fYsDw6JEznSHm2X=Wvq1dysGbGa4-VpXJyzKWZQxLMdagw@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/48] 4.19.112-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Faiz Abbas <faiz_abbas@ti.com>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
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

On Thu, 19 Mar 2020 at 18:50, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.112 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 21 Mar 2020 12:37:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.112-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> Faiz Abbas <faiz_abbas@ti.com>
>     mmc: sdhci-omap: Fix Tuning procedure for temperatures < -20C
>
> Faiz Abbas <faiz_abbas@ti.com>
>     mmc: sdhci-omap: Don't finish_mrq() on a command error during tuning

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

NOTE:
The arm beagleboard x15 device running stable rc 4.19.112-rc1, 5.4.27-rc1
and 5.5.11-rc2 kernel pops up the following messages on console log,
Is this a problem ?

[   15.737765] mmc1: unspecified timeout for CMD6 - use generic
[   16.754248] mmc1: unspecified timeout for CMD6 - use generic
[   16.842071] mmc1: unspecified timeout for CMD6 - use generic
...
[  977.126652] mmc1: unspecified timeout for CMD6 - use generic
[  985.449798] mmc1: unspecified timeout for CMD6 - use generic

Summary
------------------------------------------------------------------------

kernel: 4.19.112-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 8977fd00fd705a4e9273d09171ee66344cdc879e
git describe: v4.19.111-49-g8977fd00fd70
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.111-49-g8977fd00fd70


No regressions (compared to build v4.19.110-90-gad35ac79caef)

No fixes (compared to build v4.19.110-90-gad35ac79caef)

Ran 18421 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- nxp-ls2088- arm64
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
* linux-log-parser
* perf
* libhugetlbfs
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
* network-basic-tests
* v4l2-compliance
* ltp-cve-tests
* spectre-meltdown-checker-test
* ltp-open-posix-tests

ref:
https://lkft.validation.linaro.org/scheduler/job/1298207#L4037
https://lkft.validation.linaro.org/scheduler/job/1298945#L4132
https://lkft.validation.linaro.org/scheduler/job/1299973#L4232

--=20
Linaro LKFT
https://lkft.linaro.org
