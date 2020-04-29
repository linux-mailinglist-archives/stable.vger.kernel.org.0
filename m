Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0E6E1BD9C8
	for <lists+stable@lfdr.de>; Wed, 29 Apr 2020 12:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbgD2Khx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Apr 2020 06:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726621AbgD2Kht (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Apr 2020 06:37:49 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97C25C03C1AD
        for <stable@vger.kernel.org>; Wed, 29 Apr 2020 03:37:47 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id w14so801645lfk.3
        for <stable@vger.kernel.org>; Wed, 29 Apr 2020 03:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lj4j79tnCYDlEcvjLDpv0XR6ZlHSfVEAZcBALQUVIQ0=;
        b=BANeQxnxebpQRx3AFFNwooA+uI2syu3/qO549U8zjxTzPq8ZbZN/AAQhrD5MiJ6iy8
         Nvcm6JOf7eHmfomhGQz/Zf/kYRLvRfHzL7KMwdbH9hQui0Ga8/JLdf7wFcutQNe39ypf
         dxz35uQlP1Sl/55HIHxbSteRXGVNXP0flSA+nlftcAZv4anHWe/g0W7mDtx99SuWiskJ
         U4aPIqCc7mEPGybMEYXCzEA0P4PIIBGOLkjsbU0/8bJJE3oD0+Y1bImrzSuTIasBvv9J
         enDIuwg1FAjhldCtVaPyih3m5LCjahdco1l1mOXxexCpUQBnYh4035vOYSJgSO28bIi8
         arAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lj4j79tnCYDlEcvjLDpv0XR6ZlHSfVEAZcBALQUVIQ0=;
        b=hutFftyZarH5/0U/3Gu8TOzPMh7pB62gfeVpLTgPxy0zqdLEKupviM/7fRcFtW6Hr6
         307wMw8uW2G6G9u8p9PW1AcenumgmJlytqm3Lpe35J+8c7R5HOlu+U9EQrQCSCtZfk6K
         Si3037bAsrOFMsXl8yJjnoo2goM9hvoCX7y7spG6OOQ07Sg7y3xDoow0iCRR8vrWR45F
         6BKlSjQkQXMJpimjrfv9TfDJFPD3tE9/ZaMtjJPhBAgSh48SeHfUlMm2CvI5mIC1Is7+
         nYN2pgO/JfOXDtoNKNL7zkQm6rbR9ZUmmiQYuFspDvRjUh8b5MsRdSUX92yrbNtkPyMl
         wy5g==
X-Gm-Message-State: AGi0PuZ7tqD4s5Xtw0ABk2zbAJeAwl42vnfP2kW5KKz8kLeRCPCwtcMr
        gETvgJrTzKk1P85ECWjidIdmRk+bZMs5ot601ESlwg==
X-Google-Smtp-Source: APiQypLRPDHRAeCt9fjJvsjdoTC7CcuD5B0AWpu2eU4mlIJmtyg3ZGkbYE8EzyoIhMfD/OUeE4JzcbON9J8KCv/i/PQ=
X-Received: by 2002:ac2:5559:: with SMTP id l25mr22193559lfk.55.1588156665879;
 Wed, 29 Apr 2020 03:37:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200428182231.704304409@linuxfoundation.org>
In-Reply-To: <20200428182231.704304409@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 29 Apr 2020 16:07:34 +0530
Message-ID: <CA+G9fYvCkCer4unQoeKaMCwyAnei=-Hq5TPgtp798v7BchXJGw@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/168] 5.4.36-rc1 review
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

On Wed, 29 Apr 2020 at 00:01, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.36 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 30 Apr 2020 18:21:07 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.36-rc1.gz
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

kernel: 5.4.36-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 388ff47a1fba8fa27be759acc4f846a75df6bde0
git describe: v5.4.35-169-g388ff47a1fba8
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/bui=
ld/v5.4.35-169-g388ff47a1fba8

No regressions (compared to build v5.4.35)

No fixes (compared to build v5.4.35)

Ran 32617 total tests in the following environments and test suites.

Environmnts
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- nxp-ls2088
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15
- x86
- x86-kasan

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* kselftest/drivers
* kselftest/filesystems
* libgpiod
* linux-log-parser
* perf
* network-basic-tests
* kselftest/net
* kselftest/networking
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
* spectre-meltdown-checker-test
* v4l2-compliance
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-native/networking
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net
* kselftest-vsyscall-mode-none/networking

--=20
Linaro LKFT
https://lkft.linaro.org
