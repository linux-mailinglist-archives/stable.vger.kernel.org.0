Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 668AE3080E
	for <lists+stable@lfdr.de>; Fri, 31 May 2019 07:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbfEaFUE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 May 2019 01:20:04 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:45649 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbfEaFUE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 May 2019 01:20:04 -0400
Received: by mail-lj1-f196.google.com with SMTP id r76so8286449lja.12
        for <stable@vger.kernel.org>; Thu, 30 May 2019 22:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lpIEXnI4bY/NCXcyk4dbMNdHV673RVAmZF9/JnONbSA=;
        b=YCUD3a3naBhRzIX/q67QSlEGpCPAG2YH/LPhS8VIJ6EGBVARoD5Hfieh61f85FOAvc
         tDNP+CX4huJEZizlc0TYh6KWVLPDEXAqjiS7RhXBH8zI1og76L/D2Xl+3fGlQAnoZGj0
         vdMpmQb0ITSBqUKR+8QGnhX//kAJVe5cobzGWCgdT09cnhS/DCmff9ybTZJWbEKqZJPA
         E7Uzq7qO4JPqX1I6Ae6woq3GiErGRRo9vfA8z5d6zFAn9bGbLsTnbUJcnYZyPmIcED6G
         5uD886+CLu+Gokhz96bai8aEKpFV3xRq4L4/YtS6M74i8g/hDeZ2e0YtPGvIRcWzpQqD
         Egig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lpIEXnI4bY/NCXcyk4dbMNdHV673RVAmZF9/JnONbSA=;
        b=P250j03zja1h9HKMsZQBo4Exholg0MZhBVQH81xjcSMm5Ydm96P5PlOXtw7Depw72V
         bnnYvqzurD3m4U7qBhGWfTPdwXhWznwvwMWg7DxaPlARM6y9UNQL97uL3vPylxy4iPKk
         9FjJhQJ9PH1v5dksuQpDrYbCaP1iUsZ+3Kt/iiAM5y4e36zYL3XI8NuXB8cZoJwRS2kM
         coIZKR/Q2Trj/CG1yvLoE8dSCMd3Uiv94RwcWQRV+Um6F1vEx0/mj2Bi1XU1PuqJuYux
         gwEPxOtih9CaHhOmT9fJtpJsI5ozfl6pfkn64bqwkeE7VdKmyjBAcfZE4gjxouHORsI4
         fxxw==
X-Gm-Message-State: APjAAAXrE0DFIXGbUc0Kc6EuiGXdM0jM7LqSzcpclaUrQx0o2ymgwHwm
        leUVyggnpT52lQ+sR6AeNrj20n/gwBxWmtDeIPzjUg==
X-Google-Smtp-Source: APXvYqzD473nPUHw27EoJtk6vGUSZ6iTI3uPDTo8kdwKv/0RAzIBQpiQT+vlul6rPcB3WCJ4t8qKUHh3cx70gajE8t8=
X-Received: by 2002:a2e:2b11:: with SMTP id q17mr4469480lje.23.1559280002186;
 Thu, 30 May 2019 22:20:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190530030523.133519668@linuxfoundation.org>
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 31 May 2019 10:49:50 +0530
Message-ID: <CA+G9fYsmLSNw+mGudczVHgB5TyXvA3H2ed_PgJ3RzmFzhYpnqA@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/276] 4.19.47-stable review
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

On Thu, 30 May 2019 at 08:51, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.47 release.
> There are 276 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat 01 Jun 2019 03:02:08 AM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.47-rc1.gz
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

kernel: 4.19.47-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: ce4f69c2c1a58809446ca1cc59521671d7974f8a
git describe: v4.19.46-277-gce4f69c2c1a5
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.46-277-gce4f69c2c1a5


No regressions (compared to build v4.19.46)

No fixes (compared to build v4.19.46)


Ran 25004 total tests in the following environments and test suites.

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
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* libhug[

--=20
Linaro LKFT
https://lkft.linaro.org
