Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D98225D46
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 07:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbfEVFEs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 01:04:48 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:38036 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfEVFEs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 May 2019 01:04:48 -0400
Received: by mail-lf1-f66.google.com with SMTP id y19so633711lfy.5
        for <stable@vger.kernel.org>; Tue, 21 May 2019 22:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wQ83vV6Xzy7wYFkYEqzCiPkq4lX2zxIRrExWbBkR//4=;
        b=hEJmk03cX0a0Qi5BPpCuVpLOWj/NGj8cbmDyxMxgFxrUqddQDWTYojzGgFQpijPAZz
         Eai8a3aPOX1H8V49tjYtGGmVisNq+NjWY/aFM+Uh5/8zLRI+rm4Kc1ameaz37+Jg+QCU
         ECt5tkhKGDiVSscse8r6u9heWT9P3RwF0uvp+A56BnQJjfpmKjlyKByFqmcgm3aqbAG9
         m57POEzusllyL20cHUsGgVvSfqIGlu3VWhnE88IRQckQXxs7o/0oSqIMigfCbL5gm6jb
         x02TryiJfFxE43hiZMZhb5tozag1eqWQ7kXSvoRvMv3aec1a1XKVA8mTr8gpz3QpHLbp
         PeyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wQ83vV6Xzy7wYFkYEqzCiPkq4lX2zxIRrExWbBkR//4=;
        b=FbuMm9OEa5kKWv9MiHYOIsNxP5ui5p9gbN36/DV573TeM0XATB0fCftQHSMWDyoHlH
         fCRz92kGWyb2Me0G8n7NdBb85luuXxfKz6C8iNsSlu5eQ3ZQp88Bx7051nFirIucbTxl
         W4eJBHhlwF0x0XPLxFEu02ZNFS+/uuozXSFYN9JGgQejqLA3fIb8XHSjQmsebKiskPmC
         4DZn7WUGlXTzXWvgdtveuj+Xg0NRChxDi+8YjlfQbbR25TSwknyOax7kG66oYbLvSDec
         b17fKlw/1BNoRaXDwE+ZyG3Ac7ssMWPdaUnU0zNzXlr8bSqJjncASxkhJcFt6peTL+kD
         juuQ==
X-Gm-Message-State: APjAAAW24Y+V8RIMMkyMgBZEWApDv04GCzOP77+nzGzUeMFNHp7b8pVl
        jwMO0kiCl0U7TAg1CtmlQ268DQlQ0gb9D/ChJPBSo3b6N6E=
X-Google-Smtp-Source: APXvYqw44ADoIV4ABsrg3W7afaX2YDIuemxMPKVCdCPTEPdveseKVKDQjwZMKF7MDLpdHtuNkmH4cIymAYXrAXdSZ64=
X-Received: by 2002:ac2:490c:: with SMTP id n12mr13591539lfi.4.1558501486489;
 Tue, 21 May 2019 22:04:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190520115247.060821231@linuxfoundation.org>
In-Reply-To: <20190520115247.060821231@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 22 May 2019 10:34:35 +0530
Message-ID: <CA+G9fYux5rxbm64DUvy6S_xsVoSzAnT0t=nV4tdS4SaUP5aH5w@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/105] 4.19.45-stable review
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

On Mon, 20 May 2019 at 17:51, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.45 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed 22 May 2019 11:50:49 AM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.45-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

4.19.45-rc2 report,

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.19.45-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 84889965d346f29e8d1614f9c3cb35c389a40eec
git describe: v4.19.44-103-g84889965d346
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.44-103-g84889965d346


No regressions (compared to build v4.19.44)

No fixes (compared to build v4.19.44)


Ran 21466 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
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
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
