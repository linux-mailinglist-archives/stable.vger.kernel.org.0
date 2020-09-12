Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 379012678BE
	for <lists+stable@lfdr.de>; Sat, 12 Sep 2020 10:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725817AbgILIHM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Sep 2020 04:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbgILIHI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Sep 2020 04:07:08 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 771D7C061573
        for <stable@vger.kernel.org>; Sat, 12 Sep 2020 01:07:07 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id j185so6692379vsc.3
        for <stable@vger.kernel.org>; Sat, 12 Sep 2020 01:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CDZH2yx3hPs808I2LrHJaGugWVB/v76tWmgxKeMP3h0=;
        b=oOB65dxKJx2wi0D+lgVztvj3BE0u8G7VjGZUppjVh3WoZI34U7dPbC96pWnUZ8QId/
         P1+Le0XKO1Msp+XJ5sFanGqvgxUjaRZ6mmZZDoXx2UWX0NVLUrpBDUgn3NtzG+8RoToF
         iPmxcpa37EHy6N46JnoNp4cCUMd3pslLTLAtU6bN77OvSWn+34vi3B26/QQ1puIh38/B
         Y6RoV7usdIouo6xlmLAS627ygEuicO6GEZ488eu/I2pWNTjQIGrVT8dUlQmq9SXx8W3n
         akf/Y29/xJUIP7pXIxGtVye17Z5a1UMdWgfJZ3Yxv+X40UfdWfIDz5GmVpjxbu9rpIhf
         A9EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CDZH2yx3hPs808I2LrHJaGugWVB/v76tWmgxKeMP3h0=;
        b=umMFENqzHHMM+M3Kf+nl46o7LWz5TwgolazG15/kQw5iwWRZh02+y3HzqdL/QhmmVS
         qgI/BkE/kiWWUQpsMT++ePkK2tAn5brFIpiHUIwoV5KU59anze3Mx6eTv8s+QiGWf8Bs
         bGf6J1bsNfNokcVcr1GRpbdEDTjuEU8tg6k9e99rP7O72cL+Xcpi/ge9n1W5yKVaGlfN
         1rU/2A2of6ssLjBbHK/+bGHyviTbVne9Qvyj0p4n1hck6ixDTG7gMZiDcOH0tlCm42nC
         0oVvt5kwOFtcC7yU8TYie1bb5iJgdBUIJ3tRTwrQ+9s8pCSWjvVO3Vz5jdRHwP8Ch0U9
         qd2A==
X-Gm-Message-State: AOAM5303un6JyWE+anykh+L/SZd9nwhrLsqKlRmlg5FY+Bm8VsdNGBtI
        lne5MknfCmA6xGu1bEUWEIFW5bMZxdICkRpPhZfrQA==
X-Google-Smtp-Source: ABdhPJyJPzXkgRFli+FHijgzDmn5KPpA6VURPC4qi6Iqx0f6uPkoPayyMv/yjEL+m1DYlBemD7bSKLEiM8NO9JYbDQA=
X-Received: by 2002:a67:7c52:: with SMTP id x79mr3045305vsc.21.1599898026206;
 Sat, 12 Sep 2020 01:07:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200911122504.928931589@linuxfoundation.org>
In-Reply-To: <20200911122504.928931589@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 12 Sep 2020 13:36:54 +0530
Message-ID: <CA+G9fYsCVApK+_Mo96y8QY8oNZ+4J7-w0HK_TQmnho5nYPUu-g@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/71] 4.9.236-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 11 Sep 2020 at 18:27, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.236 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 13 Sep 2020 12:24:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.236-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 4.9.236-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: 59285d12c5e318944255026d4ae511ff47d57106
git describe: v4.9.235-72-g59285d12c5e3
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.=
y/build/v4.9.235-72-g59285d12c5e3


No regressions (compared to build v4.9.235)

No fixes (compared to build v4.9.235)


Ran 14979 total tests in the following environments and test suites.

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
* kselftest/drivers
* kselftest/filesystems
* linux-log-parser
* perf
* network-basic-tests
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
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
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* v4l2-compliance
* kselftest/net
* ltp-open-posix-tests
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
