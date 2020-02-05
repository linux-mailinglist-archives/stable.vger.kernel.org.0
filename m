Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE3A1524A6
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 03:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbgBECDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Feb 2020 21:03:08 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:38224 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727875AbgBECDI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Feb 2020 21:03:08 -0500
Received: by mail-lj1-f195.google.com with SMTP id w1so666842ljh.5
        for <stable@vger.kernel.org>; Tue, 04 Feb 2020 18:03:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LHnuyGIfX6fYhv02t7tNCctT4Vu0FVFSMgtbht1nPg4=;
        b=tHokK2VJWv9DFwK9Hpo89gftC36nsuBi9MlWxYJyShPVJLvflLi55DIXPRsHKTjC+t
         TGZstrCK4xEcQyfu2dQp6Swgo6i0ZIL+gtzWCCuq5Mu5wCtducyEgcnNTm0CJd23/6xx
         SwqIRNAiE2IpImTMRygXxLJMctqL5osUhRxhY8GV7YsoTlkSLqR1vZNYyKOeN6iFxPGw
         GCWFFKLgvt+oVISzd8n4fa5SsCBgva+KyTNzmhKTN8RvYNvpOQhrAHZ5f9HVrfzeqakg
         Nags0cOrZr8ahDpDt9cvrvz4GfJ8pRicN6siBXE4De9KDbg87kwcR19tBzlrcQI+tXvk
         CVsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LHnuyGIfX6fYhv02t7tNCctT4Vu0FVFSMgtbht1nPg4=;
        b=MqbB9B00A31zB4svCYcNhJCXk7Yw5/v05Fc4Ud2VtpMPSpA7bZq3Kg3MJz+iZz5t9+
         MHFmR7ZsX7OS0xlpuW8wdCYtI6zXFqkSm4GRuL7tugPRL0gvDMk1FBw38eU9WHQQ3wZZ
         4e6nhY/4MFdNVhumaJL66KE55jxKgpMkLis60N+vxWQkHR1ZskjmoXVJYhq20wCanK0D
         7jz4xIrZKc0ng97rxEBsdFGi1xVK4C6nr6po8k5q4ZDH4PZ+phQI13iOd1bI9qHynVZ2
         P4YocXIB3WakNxlzlBJNImU83fumvi0nnbGfZVPiqVY95I3GKL2Asxg2gUSyJomw4KkY
         DveQ==
X-Gm-Message-State: APjAAAWtsEAThpU3To8BJGghpb0u1Xv1h9MPuZjFxm7qrL4tI3DNK5YS
        j54/w6PChjuOtj1WKz8lB5lE6Tb3BLx+2qyr78pXOQ==
X-Google-Smtp-Source: APXvYqxJkaGaOKIUevDETw2wLDQ72vYdn6McchXmzJyPdTrB42eoHxTteyOCGp/L02ed8RNBtNkccykXLARWK7zPYII=
X-Received: by 2002:a2e:8e70:: with SMTP id t16mr18909666ljk.73.1580868184678;
 Tue, 04 Feb 2020 18:03:04 -0800 (PST)
MIME-Version: 1.0
References: <20200203161902.714326084@linuxfoundation.org>
In-Reply-To: <20200203161902.714326084@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 5 Feb 2020 07:32:50 +0530
Message-ID: <CA+G9fYv0jo8571dFpuN=DSdn9aVXNx7-jwn3V-DXFFPZ80-pAQ@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/53] 4.4.213-stable review
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

On Mon, 3 Feb 2020 at 21:51, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.213 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 05 Feb 2020 16:17:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.213-rc1.gz
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

kernel: 4.4.213-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: 758a39807529795c804023beb3dd12d9494760cf
git describe: v4.4.212-56-g758a39807529
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.4-oe/bui=
ld/v4.4.212-56-g758a39807529


No regressions (compared to build v4.4.212)


No fixes (compared to build v4.4.212)

Ran 4894 total tests in the following environments and test suites.

Environments
--------------
- i386
- juno-r2 - arm64
- qemu_i386
- qemu_x86_64
- x15 - arm
- x86_64

Test Suites
-----------
* build
* linux-log-parser
* kselftest
* kvm-unit-tests
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
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance

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
