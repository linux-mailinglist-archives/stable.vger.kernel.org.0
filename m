Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 494CD1C5AFF
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 17:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729544AbgEEPZJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 May 2020 11:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729437AbgEEPZH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 May 2020 11:25:07 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F29D8C061A10
        for <stable@vger.kernel.org>; Tue,  5 May 2020 08:25:05 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id z22so1707883lfd.0
        for <stable@vger.kernel.org>; Tue, 05 May 2020 08:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=J81iVlUhIvyatMmRwxzUMXaJb0pLdaqKSdM5bNfAaIk=;
        b=Q4SrV2Zbs6qOTX5X3znnPe1LmgiKGGUdvhgMsKxVtGP7E8b4PW0LmNEOLqeDKKX+nX
         ww3akYS/734SFNsrtn4qmlv0nVzoAR2MvVpSXyADL4n2ki6e/dLwLniSMuqRm3FhjfR9
         A5VlZDuXQxKuqnABG8XU4k1SskP+w0vly9ysT/UVtkQd/QvMkMij9dPiyJtzVbhHbexm
         WVjd12qtZvoHhwdf1xZphSz6Bznc+bpcV34qp8qF7nas5Ub6AJFxDcpoZwfdmAza+wXs
         p1crHGAsCzsvw4qecX0SwohV5tcnBRzg7POYETXK4qumcA3+flaYbJKHe87uXkBP7Rv1
         p7kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=J81iVlUhIvyatMmRwxzUMXaJb0pLdaqKSdM5bNfAaIk=;
        b=G9hFGRgTd5cASRwvXnPa/0EUm981OQlBMJkZfEmlHETSx7JxyyMriP1k7Ubmo78p6U
         Ua6eNO+rRoT5v4Ss6/2d3kZsC3aOQgYRLK7bJIbCa/AmmX/GAEt2qJw3nT4xC8WsQ8KL
         BOIql6FsK4camDlqczPYVvl8IG+q975usWlHH22wgCYkjC/1i+VzU25CayLhAmsAe4cw
         Zj0F4PO4L+3hUc4Ic15+drRtAJuvsAsCskDTKpyYK2ZaoiPPSztPYANz8cI1vCibE5XT
         +DUGniDhxJ7ttTdXXS7may5SRnEstMxmSM9aK8e0YpSEg+3fpQ12KEq1aDYmdKjBBWNq
         MMDg==
X-Gm-Message-State: AGi0PubJmhw62ENE/GoQ4Am/OcwltELtVMSykqNxM6UazCgAq0xNKWId
        e1TvbYYmrLYwSURXRjmqQDEMNNf0YcZj0/VqmnsxCA==
X-Google-Smtp-Source: APiQypKaRjJ2sNzhMfa96iWw2PhBxaUs8+uF4/HkoKZjdlzRn9i/hpxcvyagt62n8Ns948aVGS1/pINMYcRJcEbBHxo=
X-Received: by 2002:a19:d:: with SMTP id 13mr2061183lfa.167.1588692304320;
 Tue, 05 May 2020 08:25:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200504165448.264746645@linuxfoundation.org>
In-Reply-To: <20200504165448.264746645@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 5 May 2020 20:54:52 +0530
Message-ID: <CA+G9fYvnZrQo9yiBFLHQCZjSgxzmcEphS0bxyy-xx4txPYfzDg@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/37] 4.19.121-rc1 review
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

On Mon, 4 May 2020 at 23:32, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.121 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 06 May 2020 16:52:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.121-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

NOTE:
kernel warning noticed on stable rc 4.19 and 5.4 while running
selftest bpf test cases on arm64 devices.

NETDEV WATCHDOG: eth0 (asix): transmit queue 0 timed out
- net/sched/sch_generic.c:466 dev_watchdog

ref:
https://lore.kernel.org/stable/CA+G9fYu4gE2vqSmgyYMfdMS-ZDfQiY1vhk2Jbni+wDJ=
FjLHVKg@mail.gmail.com/T/#u

Summary
------------------------------------------------------------------------

kernel: 4.19.121-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 2e3613309d936ae445288baa881ca1775f300f6f
git describe: v4.19.120-38-g2e3613309d93
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.120-38-g2e3613309d93


No regressions (compared to build v4.19.120)

No fixes (compared to build v4.19.120)

Ran 28318 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- nxp-ls2088
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
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-ipc-tests
* perf
* ltp-commands-tests
* ltp-containers-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* v4l2-compliance
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* kselftest/networking
* libhugetlbfs
* ltp-cve-tests
* ltp-dio-tests
* ltp-fs-tests
* ltp-io-tests
* ltp-open-posix-tests
* kvm-unit-tests
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
