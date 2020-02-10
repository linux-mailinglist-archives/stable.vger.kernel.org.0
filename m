Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75B57158307
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 19:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727538AbgBJSym (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 13:54:42 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:37478 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727477AbgBJSym (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Feb 2020 13:54:42 -0500
Received: by mail-lj1-f196.google.com with SMTP id v17so8522373ljg.4
        for <stable@vger.kernel.org>; Mon, 10 Feb 2020 10:54:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Ngh4wdnpF1Cx1oQG7VgSpvLbPvkRbaYoX2AHFYUBti0=;
        b=W9z/jdyEHX20NItRoC07h7Zt8u4FYBOKsgFXbiIEHkRC7rkNfm9xG0pO8sdlZaTsaB
         VVpzzWqCkxrYqkaUvqkJV3LX20Hhob5HjJHZqlRABPjbb8MXhSL83vFg9Rq93FBgvFID
         slGHZcEjoCwYiKw+U69sijtcKeqFLJ0fJC88w6BX2UeqBisj0yp86OrK5cApFtAgP3Zl
         ceBIGfsb6esLHXtFXd1DR6jLP0pJzfOLSTPtYNjDRfiq6JS48IjLNGaMMz42djoj7tWS
         LIl9ESCIKgNHbH5LxmAI2sWZA5ZQPHhzx7cuZKbPFTx8Wj5GENLE9h6us4SkU8MT6osg
         LsqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Ngh4wdnpF1Cx1oQG7VgSpvLbPvkRbaYoX2AHFYUBti0=;
        b=ppBsbSnOJ3Zcz+7z5w2HVMIjr5mlCc0JeJiahBdABr0y37OeV5AzjuVwAHP5ywpHIc
         dLVfUv2DYr6D8xUra0CmOIxi5zyTsyc9zQeAzLPbuPHI+nmjskXcVBHNqforT/Jvnot1
         gwSHr6fASW+bQTh6XcOh5TdyQOShxqggWP1fvusavmvTBQf/gsgFW33UeonlB1uq8bkX
         QKgd7eUF1xoQT25/3DE/rsAUicaIuPtbPMB3gQVavIG8KoQ9+VZck0aiVEhgsRXSe6bi
         phxtiG459NaSFlb0MsuU1hLleoZ7GuZdXIXaRwCBG17EidwJ0OLO62pLJ0RuhAisTROD
         01jw==
X-Gm-Message-State: APjAAAVj7Bo1zZQSHkcbyxvYtSPbkdIUdF10rV2ZpaikYah6wG12GYNw
        o6PMboZgOARRPO0KBmDu5+T9dUzjWfMnWb0JhkHMRor6b9Y=
X-Google-Smtp-Source: APXvYqyt2GMPK0khC/g9gLasGmxWoeQvc05qWaltYZ/9S8lxU/dOWvMzIuNCcYpMv/JgJ5PoTmyhXkvER7tvfFG3bNI=
X-Received: by 2002:a2e:8e70:: with SMTP id t16mr1780333ljk.73.1581360880521;
 Mon, 10 Feb 2020 10:54:40 -0800 (PST)
MIME-Version: 1.0
References: <20200210122406.106356946@linuxfoundation.org>
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 11 Feb 2020 00:24:29 +0530
Message-ID: <CA+G9fYs+M4aw4Q6-3Mcm-8JQct=eWiMEWtOAN0dba2MwQWhyRg@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/309] 5.4.19-stable review
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

On Mon, 10 Feb 2020 at 18:09, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.19 release.
> There are 309 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 12 Feb 2020 12:18:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.19-rc1.gz
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

kernel: 5.4.19-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: a28430b8529be97d763450b3af54c3958cf9308c
git describe: v5.4.18-310-ga28430b8529b
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/bui=
ld/v5.4.18-310-ga28430b8529b


No regressions (compared to build v5.4.17-404-gdb4707481a60)


No fixes (compared to build v5.4.17-404-gdb4707481a60)

Ran 21744 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- nxp-ls2088
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
* linux-log-parser
* ltp-commands-tests
* ltp-containers-tests
* ltp-math-tests
* ltp-cap_bounds-tests
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
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* spectre-meltdown-checker-test
* v4l2-compliance
* perf
* kvm-unit-tests
* ltp-open-posix-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
