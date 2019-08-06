Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6706582A0A
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 05:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731387AbfHFDeb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 23:34:31 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:42134 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729170AbfHFDea (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 23:34:30 -0400
Received: by mail-lf1-f65.google.com with SMTP id s19so59766310lfb.9
        for <stable@vger.kernel.org>; Mon, 05 Aug 2019 20:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sNpnTfg8JfwPKSVuyQoipG5xr56fo0Xev0F1jYlnfGI=;
        b=IPAFhR+NtfHqGwjKSpezmceucyZumF0+1vXMkko/IeWxa5yi/hx7wNh2spw2c41B4e
         pInEJJUGrV7l6w9tV+zCKb8p3z4BJ8gQKV1hEMq1PpfYzeQqiBhjoV3Qf39jim8NE2v6
         tzQzlK/jLQDTs4tGQ1TKR4HJBE02hj1hIH1ctIVdNh9p9cLzjBD31o76rqEtOBCcbvFy
         Em1YJRGjvrWFUu6tBy0Ac/MO6sr0eGzkpGMe38jEAr41Q4Mjd0kytmW+q8W/Yv5s+ffP
         bCNQRvT5pNMBEbPC0c/VPa0ngvYMmp1b7+Hppkkp0a36V0vKky6BZdYsIaj3eGVbvbRW
         cgWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sNpnTfg8JfwPKSVuyQoipG5xr56fo0Xev0F1jYlnfGI=;
        b=tdTqecVn0W+w59LkuMIbFYk4wHHTWnFPvB1I4nC26bFwbW4VZm+lZlDJ+7K+a7uNlE
         yU8EX3H2aqCnQpCQ2VpJ3gR0N9WyRT3HVah2JPn71m0bYuZNk/TJIlzV7Il5WzVtcHnk
         pWqgd1Cw2ooqIMMxIcb2+pZ6a87VmyXU+6NtTzNEwnV6bMNLMHN21KPJ0+7L+VPTUZEj
         vmDDXZ4Fy2vih8NQ4196kCa6LdFz2Jhkc9txyuuUMwws8bCgCpVC0S6XdEDRcv3TMLNm
         3wjeR1oy/4XEI0BPvm1kowzqYOJw13E6N/5pqlyZttkA9C0r/hyYs1oSQIv8OTVg5d0d
         bGIg==
X-Gm-Message-State: APjAAAWkBf0mUfYU8eG6FPIEYdkFi75jao1JedKI8kQqjCKorDmYxZHE
        RXhZvUAQbymVDytSUR3bGA8AU0Ic06Lafe53U3MMEw==
X-Google-Smtp-Source: APXvYqy33KohcHu5HB9IQMx+PG5FOJYb06/CyzbDvnZ97McmEUCvpyVnahLwtEtQYmKesl0Pr5mOXE0uu+bGcLLQfZM=
X-Received: by 2002:ac2:599b:: with SMTP id w27mr688992lfn.75.1565062468554;
 Mon, 05 Aug 2019 20:34:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190805124927.973499541@linuxfoundation.org>
In-Reply-To: <20190805124927.973499541@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 6 Aug 2019 09:04:16 +0530
Message-ID: <CA+G9fYtBy9HPDBOK6Wh=BQcks765d3PRGMkZJKYHky2V9OW7sQ@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/53] 4.14.137-stable review
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

On Mon, 5 Aug 2019 at 18:38, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.137 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed 07 Aug 2019 12:47:58 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.137-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.14.137-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: 20d3ec30650b0c33377164def17390367716d4c8
git describe: v4.14.136-54-g20d3ec30650b
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.136-54-g20d3ec30650b

No regressions (compared to build v4.14.136)

No fixes (compared to build v4.14.136)

Ran 21564 total tests in the following environments and test suites.

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
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-ipc-tests
* ltp-timers-tests
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
