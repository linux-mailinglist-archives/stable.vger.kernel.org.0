Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88D8619BD1B
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 09:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387449AbgDBHyP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 03:54:15 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:47041 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgDBHyP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 03:54:15 -0400
Received: by mail-lf1-f65.google.com with SMTP id q5so1864000lfb.13
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 00:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8+9G4M4fPPKqyjj0sFBu7xOpvf42HPywIxllN2E1ZZg=;
        b=KdyEFz94YKOC4f+rXyzOXeiUnbNS/1p2sIpVQq8VSiUZsfGVB/bR6KQWQ2gpqyUk2O
         0INeEPSuyuP42WrwTHj4yqg+GUDhsxyD3BxjbIAQ2q4AxHkNuQwbC5ngn72BbjJvFGUg
         G4tZUfBUBo6nAi/AptI7TS9lm59OkTA66Jr8nGzEP1aysRdCMTeq3T9F7VFYTR/Bl1W6
         eGx0/SOs0my/MAsMYDdix4qw5borl4pTjVMz/THhQ8HScZ8aFeggICinlGTuIAjANEd5
         pk3a8XjL4euZQ4SC5PnYC8Tc2jlQu0FIta/xpkcttgOT2gl16N3jTjDFy7+B337NRAd/
         g/cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8+9G4M4fPPKqyjj0sFBu7xOpvf42HPywIxllN2E1ZZg=;
        b=Xdra/rRsC2vFIp5t9oCRt/B/1xLOEST2grWlwanrg3s8d58YaLjdvMMzxrE0Fy9PjF
         gjt4Y7RDWTgs18d/s3DXmzl/N9BEwrpjxj5hymzjLyiJBcGlYWG0VRbLxD/Tlzikoyn9
         RuRIpTe1NoCI0Wca/RwQZE82d5XxwkQU1hyEMLOInlMyqKBeGfWCG2hxZsZhuEz8hEJ7
         RuGlcPKjn/4sfymtWJ4eSMavrl/INjk1W3tx9R2laFMBwzq9+4odMx5ZPp8mR0754icj
         qw7Bei01ns66Iici/0kTH9VBqeihGCzjFxGm2hq3RrF5rerntg+u+lXJ5KUOTX9ePAN0
         Y2uw==
X-Gm-Message-State: AGi0PubsIuYFv3DqoblznWPDM0vE+wwsrv4GkLVTAp2GlX5Khnwq7jAe
        cHwlk+/PhHEJ+awnfWLM60pVuMdLEUj/FNU/4Ck5oQ==
X-Google-Smtp-Source: APiQypLGmvOLWPH4fecZAAUfR1XClrEvPnQEMnQD3k8OwsQJ12DwYu3fZsy9Wo7n8y7yO6PHZ7tvycwUFHzWlCAyIro=
X-Received: by 2002:ac2:5183:: with SMTP id u3mr1379665lfi.26.1585814053017;
 Thu, 02 Apr 2020 00:54:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200401161552.245876366@linuxfoundation.org>
In-Reply-To: <20200401161552.245876366@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 2 Apr 2020 13:24:01 +0530
Message-ID: <CA+G9fYsR9ssXj2QeNALzUuP7_yOqDakoyED9c33pYX7pXF592Q@mail.gmail.com>
Subject: Re: [PATCH 4.14 000/148] 4.14.175-rc1 review
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

On Wed, 1 Apr 2020 at 22:11, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.175 release.
> There are 148 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 03 Apr 2020 16:09:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.175-rc1.gz
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

kernel: 4.14.175-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: bc03924ca6eab72bec9fb6f455ea41bca1fa5ccc
git describe: v4.14.174-149-gbc03924ca6ea
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.174-149-gbc03924ca6ea


No regressions (compared to build v4.14.174)


No fixes (compared to build v4.14.174)

Ran 41452 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
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
* install-android-platform-tools-r2800
* kselftest
* libhugetlbfs
* linux-log-parser
* ltp-commands-tests
* ltp-containers-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fs-tests
* ltp-io-tests
* ltp-math-tests
* ltp-sched-tests
* perf
* v4l2-compliance
* kvm-unit-tests
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* ltp-open-posix-tests
* spectre-meltdown-checker-test
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
