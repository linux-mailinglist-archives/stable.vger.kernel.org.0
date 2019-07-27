Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68A78776C1
	for <lists+stable@lfdr.de>; Sat, 27 Jul 2019 07:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727512AbfG0FfS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Jul 2019 01:35:18 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:36187 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbfG0FfR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Jul 2019 01:35:17 -0400
Received: by mail-lf1-f67.google.com with SMTP id q26so38558172lfc.3
        for <stable@vger.kernel.org>; Fri, 26 Jul 2019 22:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PzolGi6g/TcuDu8SL3iyFaFmwaFjqKwFAI80D9n/s1Q=;
        b=VGgXuS1Y9NES4hVTBbGA4O4397PVfo+SH0nSYNBaZA3UekU18/WJZh4K4ONF1sF86q
         30NqvPEha+oMSIPWg0Dw3GLgYq7uk870F5ZPMzfJsc6QATcb/OSb6IqqNWsfv7+uw72N
         ecQVde47OY0UBdCOa2sIfEDdYR+TT7+xyq7xByJpkizW0I+4dKZMgOxwv/61zQYOPW8G
         g6ws2uYOHjGwkCRjqSrB2G5nICZG0SIGRZfzHjcu+hqpPD6HH5NHBcsDCyLlz3RZMNQi
         ZOHwQVItlba9czw5zGI+aIVETOCjNq9WBhYVNGJbH8Kz4xGYyBH2wTalou8N2UhFwpue
         wfrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PzolGi6g/TcuDu8SL3iyFaFmwaFjqKwFAI80D9n/s1Q=;
        b=BkY0KlB/44HFVDbw5GcwgJLiYPkdWN+jrP3vVQanGRYXozs5KYxOv9K6HH5K6sabAt
         cYXI2fwSFPK0D0ASyHSMIFtkU8vfyvV+rXXK9CbYxrbS4ZDzM/NeeiMBKa2tj5u/b1uU
         bjagKzqb/ji2jL0bd0ZLicImlyIEHm4TFY1vd0zSegQdqtsOewrQexBdXVzFzxuzKN1v
         mX/FgSszk0qlTevU24LiW2ytCsmvJURF/6ZtJOo/by8NpMB+vtshz8xgsYcsgGx6kGNi
         jm9H1CUFWXEFXuVXOE0Rl9g+T/FB8QebGYOCZfi4kbP/KqCcakZsXqJy01i2Q+V5mw3V
         0Pwg==
X-Gm-Message-State: APjAAAWFvPbRdpDDyPYQcIPy0zzuqwB+RlxFBD4MsK0fhXEKlSsFmGT4
        begdIHRP4x0HEfUmfNuhAB5+XQFB0Mjl6Zmu+vDBGA==
X-Google-Smtp-Source: APXvYqwnC3I49Q9Qpb94zyDJQeM8/85gk5segHmTrCFRL7t2meMzjC83QZLqr4w5cTUZGnFRlBqjwetertyfeCKYqO8=
X-Received: by 2002:ac2:546a:: with SMTP id e10mr47166003lfn.75.1564205715628;
 Fri, 26 Jul 2019 22:35:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190726152301.936055394@linuxfoundation.org>
In-Reply-To: <20190726152301.936055394@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 27 Jul 2019 11:05:04 +0530
Message-ID: <CA+G9fYs8BSxWnE2csOg93jNNFhqMFLavWh8FO3cpBuxy-U3QSg@mail.gmail.com>
Subject: Re: [PATCH 5.2 00/66] 5.2.4-stable review
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

On Fri, 26 Jul 2019 at 20:55, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.2.4 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun 28 Jul 2019 03:21:13 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.2.4-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.2.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.2.4-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.2.y
git commit: d61e440a1852a64d8a2d0d358b9582b19157e039
git describe: v5.2.3-67-gd61e440a1852
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.2-oe/bui=
ld/v5.2.3-67-gd61e440a1852

No regressions (compared to build v5.2.3)

No fixes (compared to build v5.2.3)

Ran 22512 total tests in the following environments and test suites.

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
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-fs-tests
* ltp-open-posix-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* kvm-unit-tests

--=20
Linaro LKFT
https://lkft.linaro.org
