Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99C8B1457FE
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 15:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbgAVOjh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 09:39:37 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:32828 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgAVOjh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jan 2020 09:39:37 -0500
Received: by mail-lf1-f67.google.com with SMTP id n25so5539799lfl.0
        for <stable@vger.kernel.org>; Wed, 22 Jan 2020 06:39:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vi2NQT28oOTulL4e2u3KlnzSIcg6jJLKiLYxBeCTb9g=;
        b=mGpcizWuJT1IhMCUKcEeDHMORQ/+PAiz5GoPI0skGW+l3SqndJWfRLJBPRx6T2Jbg2
         ns8aAOMKQ1vapu1nimEXwP3DbGKpjvvArOu/44PMiUlp/Bb0+hIyk946ZindGjNZHQ5H
         /X6k7YGR+UU820qiB7NRG/71zmrBDZumc8kqLPIqHqATx4uWr/TGsKNIlEv3bfWgK5ar
         dw3uKTNFwZuwKM0pXNUKFETdTgNs6lg0kn0EV64CFdCeC69BtAPab6UrLDGH98niWg/+
         DTPhz/3OskZFGZZmmf/252Z+gNkdcxRGiVkXa1BQBcOpmgFCq5uq5ssgiqDdARvdXhFp
         G9Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vi2NQT28oOTulL4e2u3KlnzSIcg6jJLKiLYxBeCTb9g=;
        b=sLfNgnnX4kq5a3sHq+Xi8vjQheubP8sgYRaODC1CAWWbnUg+No+ZP43OUcmj+rlDL9
         0ouUb/aHsQW6jdtz5d2rErrtd2Mjzd6COkhfnuBCqMOeYGDucJLMpw+zJUKAqDURC848
         LmUalvX8enUpgMDLt8bPMR9YLAL851slZxq+u+QYsO2yb2zL1D0UoeEwodhtf4nox6S6
         edea4toKIgG4u7FoMY5eLAEQNUsNmknLMDIlyJmviAcL4VMCO+U+GS/gC7AT6e3WpiDu
         mwGi7MvoPbhQbQKLdl4Ce7awKsJIChFtsGJmu6W+PYsSuDBvgCS3T5GuhGngmJS15Uyq
         c5cg==
X-Gm-Message-State: APjAAAW18EOY9x6bdB2uXQqalZkSq2ulL5tZ47CJjln14qmDG1WmHwt7
        U2n64i1iYHumbtD/SlGIAe6AWud7+Qo4BKF9ILYF8A==
X-Google-Smtp-Source: APXvYqzejEDzfY3XflFUtUk2OorwGb/NIuWGBiQ7Ihiv8ylxHeh3mXh4KChE2tYfEb6syoF2D9QUKixC5PRHCnLSzgQ=
X-Received: by 2002:ac2:5b41:: with SMTP id i1mr2015999lfp.82.1579703975417;
 Wed, 22 Jan 2020 06:39:35 -0800 (PST)
MIME-Version: 1.0
References: <20200122092750.976732974@linuxfoundation.org>
In-Reply-To: <20200122092750.976732974@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 22 Jan 2020 20:09:24 +0530
Message-ID: <CA+G9fYvBz7__pkgAk11iZkR1cLH3qd5L0pJ=t8heox3YxFuy2g@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/65] 4.14.167-stable review
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

On Wed, 22 Jan 2020 at 15:08, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.167 release.
> There are 65 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 24 Jan 2020 09:25:24 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.167-rc1.gz
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

kernel: 4.14.167-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: bb5af942ee10d2c10d2fef949267311a54bae868
git describe: v4.14.166-66-gbb5af942ee10
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.166-66-gbb5af942ee10

No regressions (compared to build v4.14.166)

No fixes (compared to build v4.14.166)

Ran 19891 total tests in the following environments and test suites.

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
* linux-log-parser
* ltp-containers-tests
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
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
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* kvm-unit-tests
* ltp-nptl-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
