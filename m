Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACE188E25D
	for <lists+stable@lfdr.de>; Thu, 15 Aug 2019 03:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728766AbfHOB3r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 21:29:47 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:32789 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728597AbfHOB3r (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Aug 2019 21:29:47 -0400
Received: by mail-lj1-f196.google.com with SMTP id z17so899117ljz.0
        for <stable@vger.kernel.org>; Wed, 14 Aug 2019 18:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=RvOwjjY7otqdF7V2jX7F/q1LWtt/pfm8AQ70t8iL1p4=;
        b=FB8/+DBa87FGkeIWkRX38+zd72ro78+vHRMPdJ5P0St5uI6DEOn7NoZs+9iZCFFLnT
         1g45Q5VqV9OZrIjqveYLNjx0s48hhI+h3BrE+nmkVYGIrJSapp7HwwXpYTvHDJ/TeoIu
         RQdJ4DBsVvonwDpIPdDFTakHvKUNUNc4VkEBCZHlWjQIph1X5+c/dwVucCeEG7Xv+xPs
         dH0VBZujQ7ICi4j0rsybVpul2F1IRzj2oTInMiWRKtmRPJRoXwi1gjL0VDFlTMyzg2IV
         cjRchJ2m3Srg3Mj7/SXnXPcjUt7zs8J7mf2g5oOwnHFuD23VbGOpalUSeDEp12UP3Ch0
         5x/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RvOwjjY7otqdF7V2jX7F/q1LWtt/pfm8AQ70t8iL1p4=;
        b=PiHAKq2Tn7cmBOB0eDLbTgCxyMjqIYGuvLkaN8+JdvOub8QWxR/QQUBs2MS758FuAj
         GEpiSON4Ff38wMpP/aSV+ngnvBSJbGJzEf+4BAolyk1aY55357L+KT8KRC4Mg5qT2jWS
         0uMepRu4WzYrl+nfU8XnyzJI6kyDt04I5v4TUTGnsuYhotVnHbmuNFetcazY57nZCbkk
         0JnND2n5NhJYoEe8SyiJpqzqcMBRarTlP6NFF1F5KpnP3S76+gAlevGegejx7lGZYapg
         Dr4GaNlNluKs4gw8SlBjDZgxiTyyL9P+wBL69XhTxc12ucO0HBFHVHC4I6JqTuUFz49k
         wK7g==
X-Gm-Message-State: APjAAAVL2boLA+jz7/a840eP0LqUB3q0VP+Ipt03c+kY7qlFzV2F4p+E
        P5VvffUBj4tRKNoDWJxZR0WkT7svwYY6VgOg/tuUnw==
X-Google-Smtp-Source: APXvYqwa6MlJAEpKb0pGDIAPwZb6GyqWVFKTj6VJ8ZbjPPMhzIohKIEmH6GwC1f1pxIqZPcm5DPByfe1NpSYKFxt+/M=
X-Received: by 2002:a2e:8495:: with SMTP id b21mr1263168ljh.149.1565832585629;
 Wed, 14 Aug 2019 18:29:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190814165748.991235624@linuxfoundation.org>
In-Reply-To: <20190814165748.991235624@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 15 Aug 2019 06:59:33 +0530
Message-ID: <CA+G9fYu0EwyEogaTAJkEZsAU2WVq+uBS30146jb+aKFHzZkLeA@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/91] 4.19.67-stable review
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

On Wed, 14 Aug 2019 at 22:38, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.67 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri 16 Aug 2019 04:55:34 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.67-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.19.67-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: f777613d3df0e7226d30d0e0ba97e9419e3064f2
git describe: v4.19.66-92-gf777613d3df0
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.66-92-gf777613d3df0


No regressions (compared to build v4.19.66)


No fixes (compared to build v4.19.66)

Ran 25307 total tests in the following environments and test suites.

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
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
