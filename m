Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B09262741BA
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 14:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgIVMCe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 08:02:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726533AbgIVMCd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Sep 2020 08:02:33 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8980C0613CF
        for <stable@vger.kernel.org>; Tue, 22 Sep 2020 05:02:33 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id y194so10113244vsc.4
        for <stable@vger.kernel.org>; Tue, 22 Sep 2020 05:02:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZEZI6d89xtcDpCUxbSSBtDGiHmLzirfqGGVXHJyGnUw=;
        b=kpZ21DETq3qmsqIXgENyGBnedGKtG0o2BqY2UGvygheJzJ44mOIazFKrsSHMsKDl5k
         5v+8V1bPNg8dpSSv90R6SznSPRI7NhE1PaAaV5skoXyZWxgUpot5RyIJwmMKawMfsD5D
         N4d4HncBU4Fbs38tvty9FDE7O8FY1TtFjbnIAFqzizmubQ1vyhAFkl0/mL/0lkLh55I0
         FiMEzBtKi7qVWGH5em6tOqHKjB54CiA3wR3VyPY0It5Hm5BPqLRmnmzwnZXBEVL4cG00
         bLG3r26HEqzu6nooZmcqF6H5uSNJGJbjUsBwVq/UjhIlAWgBZVzDtTop+f4ABUrLD434
         votA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZEZI6d89xtcDpCUxbSSBtDGiHmLzirfqGGVXHJyGnUw=;
        b=XQn64ZDSqZzYWZT4MD7Pdd4TYU5uQ9I8lJs1WLkEiRJn0TTKjJSTc+reXlPnQVbxkw
         Lmu/t+487RCSd2W0fuurRwZVJ/9bgsW3AN/m8JyGuv4WxmMcIC5VJZaa4+oj+Iz/v0Sp
         9OI1B0DunvtXP1GilutVLR2OuAMW1I85i43s0k479XF1V21xjAvM4DpWujoAGbH9thBa
         XYqavr7OGg2ebyq/7/mYIyz9C3tS87C12oOw9m/57BGJmobHXHjkIBqG2FpSgmBoSMs4
         xO6nnNiUrC3OWRvh+TZbrpnR5AUako0QbnWmXXWmc/XcDMIR3upuY4TU+4RohLAgEv7T
         PDTw==
X-Gm-Message-State: AOAM530ljiyEEGB8E5GUceJywK1u3e/UraKauq6rdUwaew7JrhlSpCc7
        JAAv+XhOIuwVQ5uyFJq+wdivozKadZASrQryV87mqc0SOIbIwLnU
X-Google-Smtp-Source: ABdhPJwbo9LgmtKpB2tssrPZSBr0qZOOaG8yki+KLaZUb2syRELosYEkNIWqTWCXQt8GikRG8EBVsVDRuPk+4aCC3Cg=
X-Received: by 2002:a67:80d2:: with SMTP id b201mr2994191vsd.12.1600776151680;
 Tue, 22 Sep 2020 05:02:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200921162035.541285330@linuxfoundation.org>
In-Reply-To: <20200921162035.541285330@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 22 Sep 2020 17:32:20 +0530
Message-ID: <CA+G9fYstmfZAfx4ZDsbfHHs-7Ys6Kdcb1K++TKyztE1YJ0pQ+Q@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/94] 4.14.199-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 21 Sep 2020 at 22:07, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.199 release.
> There are 94 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 23 Sep 2020 16:20:12 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.199-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
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

kernel: 4.14.199-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: fbc0d5c8464b4a7bd7ad25355d983c3b815a2723
git describe: v4.14.198-95-gfbc0d5c8464b
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14=
.y/build/v4.14.198-95-gfbc0d5c8464b

No regressions (compared to build v4.14.198-60-gec572a7e7f50)

No fixes (compared to build v4.14.198-60-gec572a7e7f50)

Ran 25204 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-kasan
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* linux-log-parser
* ltp-commands-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* perf
* ltp-cap_bounds-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fs-tests
* ltp-io-tests
* network-basic-tests
* v4l2-compliance
* libhugetlbfs
* ltp-controllers-tests
* ltp-open-posix-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net

--=20
Linaro LKFT
https://lkft.linaro.org
