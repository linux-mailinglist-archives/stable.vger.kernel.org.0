Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 681EA2B765C
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 07:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbgKRGhO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 01:37:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbgKRGhO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Nov 2020 01:37:14 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE2CC0613D4
        for <stable@vger.kernel.org>; Tue, 17 Nov 2020 22:37:14 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id q3so744493edr.12
        for <stable@vger.kernel.org>; Tue, 17 Nov 2020 22:37:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pI61Nd6GBPHCLI78RmRCtnCqtxJQnNHXGrGEOXgmrNU=;
        b=bOdO+jYI5+kNnk5c5jZlqFhUbG2BRBeNHSywOEei60Bcq+HjULM1by8HR/DKHCHIk2
         f0njjM5ZKsY9udhHypXji5lZtrEmr1fs1cXNA4F7z/ea2CPESU22mgcfoPh4zMQSOrkA
         8qyfsxVSkY4+ZTRJzMVWsB74Xg1j5C4aSzZpCvElXqNWkW48A08FHiSt3VFv0sNnlqNX
         XWn/rpc7g3PTacZy6xG4i32J2W9ZYUkykWrXRHZbMSEnOnoczFSpJz0rnCqTydVzGSHA
         gjfnh207Sz6Lsatq7Bfy8GeyByOjlH0eyMHx4qKvWL3vVhCORvQPMiBQ324N274LwDLz
         ftcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pI61Nd6GBPHCLI78RmRCtnCqtxJQnNHXGrGEOXgmrNU=;
        b=T2b3nAW4iWS/O3DO5xS7iu8xFldQ1p+S6BTVgTCj86/zU8/SJ2Ytb7lIV+iokK1iVd
         UL4h4+N+263Fc4a8TTxn23UgThfPaDrsPGAHcAt2uTs/2zjSx/5VD2W9RtS38HVC/RfG
         EQDMFxwpQwrQ49wJUBeXKM+w6U1s8GILMULhpwpteJFrpPALNvckwmn4SwnPPTG0DeXk
         0P3SHuZh4c3DmlzTjfjTb1/AqHfp3oQlrgHguDEkYLcPjA3d12xAI0MZQCroygKtbAnK
         fS0rNSW4qz4yqZ1Rd60p8EaFTw1xVFe08XI9aP7gn4+WOmDwMGAocx5e3FJD76B3xpzm
         RFcw==
X-Gm-Message-State: AOAM530YtFB6/1T8STSdRNYyzUOpUnVMgUucRht35VK7pUgolK4qjlxs
        PJn+2fW7SwgPKPF51I/VPlj1+ia+dKZLUxwEy86TCZqIZvqfXlfa
X-Google-Smtp-Source: ABdhPJw/I6WWtYg2c89Ok8CKXNPpAhdF7WSNYTPlFt0UoYoRDuEt+4DuyEbJiKzA1XuVU9EJ42uC35cv+1qSp3eCxs0=
X-Received: by 2002:a05:6402:1644:: with SMTP id s4mr6954834edx.221.1605681432613;
 Tue, 17 Nov 2020 22:37:12 -0800 (PST)
MIME-Version: 1.0
References: <20201117122121.381905960@linuxfoundation.org>
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 18 Nov 2020 12:07:01 +0530
Message-ID: <CA+G9fYu7TcV0KwZA-OTTTzEO3xEo-S6N8g2Ko1j3XVcv2P6oxw@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/151] 5.4.78-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 17 Nov 2020 at 18:55, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.78 release.
> There are 151 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Nov 2020 12:20:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.78-rc1.gz
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

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
This intermittent kernel warning was noticed on arm64 NXP ls2088 while boot=
ing
which was reported on stable-rc 5.8 and stable-rc 5.4.
WARNING: CPU: 1 PID: 441 at kernel/irq/chip.c:242 __irq_startup+0x9c/0xa8
https://lore.kernel.org/stable/CA+G9fYsfEVK86ask=3DfL=3DM5juerbz+BwbFGcAZ_U=
xWrPHXYpA1Q@mail.gmail.com/T/#t

Summary
------------------------------------------------------------------------

kernel: 5.4.78-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: a3746663c34792114dfa71148be3dcc3f3f089ea
git describe: v5.4.77-152-ga3746663c347
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.=
y/build/v5.4.77-152-ga3746663c347

No regressions (compared to build v5.4.77)

No fixes (compared to build v5.4.77)

Ran 49989 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- nxp-ls2088
- qemu-arm-clang
- qemu-arm64-clang
- qemu-arm64-kasan
- qemu-x86_64-clang
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- x15
- x86
- x86-kasan

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* linux-log-parser
* ltp-containers-tests
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
* perf
* v4l2-compliance
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-math-tests
* network-basic-tests
* ltp-open-posix-tests
* ltp-tracing-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
