Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBD3625B9F9
	for <lists+stable@lfdr.de>; Thu,  3 Sep 2020 07:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbgICFCv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Sep 2020 01:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbgICFCq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Sep 2020 01:02:46 -0400
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E4CC061245
        for <stable@vger.kernel.org>; Wed,  2 Sep 2020 22:02:46 -0700 (PDT)
Received: by mail-vs1-xe41.google.com with SMTP id y3so1046208vsn.1
        for <stable@vger.kernel.org>; Wed, 02 Sep 2020 22:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=z7HUFQqmgdU8aA4cxSgMuOMzfLXK0ilDk0Apd5kUyh8=;
        b=SHpt84o+XBRzfnfl7PXACuPew2iCK770L2IfH6IBn/R8rpPFYL5TD6U748C/Q7wWFs
         +K8WIOTb+zKHcampOpiDSzBzqfeEGgIRzcjuW6TP6UxbjA7HdPc0UezGIYLO6Sw+SoyN
         dhQ4N0xkVkkuJqWE7G7PkvZar/Xe+zaUEFjLfjgbl0yFvSiq2CmsF3gucGBoiaPnBzVa
         Pa9TlDlTthKaM3zypFy2CYf7lBviK14HfXZ3HjLIIHj+pvXFSFfCWt5dYv9noN5493MO
         svy5fIj1uYT6pPbSZYSltO3oNHiBPKRVNffKf+xY7/5reF3qxYCu4xHfnEBjGV4Sqllr
         n5HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=z7HUFQqmgdU8aA4cxSgMuOMzfLXK0ilDk0Apd5kUyh8=;
        b=LP6Um2SrH+WMDDcFTa3hC3BQGoQaXCA4qew9uY7kup49Qig3qFYnU4vMlNQhgYfOom
         UdqmOtoDvJNJzxiUyCJMNLiG1TLsna8YTNb92A5Y+J4Q1LinrpWdq6C2hbza+58c37o4
         XV6ZghF9j7W+SsWCd8CODOaNBwGpXhC5uVui2pQULKJ0fQgT0aFxhZrCJajxn6SruAEG
         8fD8+l92zS6S+iNSyBYnX1jJi+yLjaEvquc6cbhMuoqvgpEx7EAZcl1PTqpBXOCnXjQo
         wndPmBEN6sME1c6yALuHjOM3ku2KPmz/Jc7NY/qomkmgO6FEsDLcJue9BgvKirqGUlaw
         IlKA==
X-Gm-Message-State: AOAM532NhoLS9jr9uoXua5AA9cJ/jCbpD4jWhcaiOqhZCJH9mHizPfBP
        s9u45JcnFoTG9YJ86MvVuK0iHzxIoUJNIJJryA1b/A==
X-Google-Smtp-Source: ABdhPJzmz6sTvss+05sD4rC3K2xrvF2iwZDvzg+8Ejpym6/zbGwz8nJMesRTw1l7ivkFrMKNB+a7X1BgW/+nme0iAjk=
X-Received: by 2002:a67:1204:: with SMTP id 4mr569860vss.40.1599109365380;
 Wed, 02 Sep 2020 22:02:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200902074814.459749499@linuxfoundation.org>
In-Reply-To: <20200902074814.459749499@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 3 Sep 2020 10:32:33 +0530
Message-ID: <CA+G9fYv9XKBtKDKR8POjibYN_tkdorT3TFe5fhvehji_SOQ2Rw@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/61] 4.4.235-rc2 review
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

On Wed, 2 Sep 2020 at 13:18, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.235 release.
> There are 61 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 04 Sep 2020 07:47:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.235-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 4.4.235-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: 279089e8e4d583d11574ccfa4a5ded543cba96cd
git describe: v4.4.234-62-g279089e8e4d5
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.4-oe/bui=
ld/v4.4.234-62-g279089e8e4d5

No regressions (compared to build v4.4.234)

No fixes (compared to build v4.4.234)


Ran 17120 total tests in the following environments and test suites.

Environments
--------------
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* kselftest
* kselftest/drivers
* kselftest/filesystems
* libhugetlbfs
* linux-log-parser
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
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* network-basic-tests
* perf
* v4l2-compliance
* install-android-platform-tools-r2600
* kselftest/net
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* ssuite

Summary
------------------------------------------------------------------------

kernel: 4.4.235-rc2
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.235-rc2-hikey-20200902-803
git commit: 4e984a08e49b4aa772d7681bfaeb091bd7a7b4b9
git describe: 4.4.235-rc2-hikey-20200902-803
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.235-rc2-hikey-20200902-803


No regressions (compared to build 4.4.235-rc1-hikey-20200901-802)


No fixes (compared to build 4.4.235-rc1-hikey-20200901-802)

Ran 1822 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* kselftest/drivers
* kselftest/filesystems
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-cve-tests
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
