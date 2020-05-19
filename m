Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 329301D9206
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 10:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbgESI3T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 04:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728115AbgESI3S (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 May 2020 04:29:18 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27348C061A0C
        for <stable@vger.kernel.org>; Tue, 19 May 2020 01:29:18 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id x27so10352884lfg.9
        for <stable@vger.kernel.org>; Tue, 19 May 2020 01:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=p+XoVit7LGOjjY6u1+Jrt54E75IAgdqCJEY4iPDPDiQ=;
        b=zL7BEAXNG80fzsY+ZK8t5byed/+Mt4CFH0DsvwfTxAx4gqbRWsdz+4VnFvIir+eqM2
         0wnShYzPeitZmzrrh/+fu9zXNEtAifvmcwMQJmpitbdDNsSA2rKoQ+gBX8Qn+qadS/eo
         Z6oO0NP4JfWnEubc0ZWhCuG4AAQYRxrDvDKj4giYJE3LII8H+syaZ/xaZ4br31hoQ0+6
         wkztveeqbqlN7JgUt2QOiTCueuh8GZbyrT6hmVbuWUiSnYxHGFRGvH1/LkMy7UGBgLSM
         3Rt4jfdA2uFcnHtiX8W/2kzUIm6WN1dNmZQtePoTlMLR0aAdhkBoFBjXYBp22huGM+st
         oCMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=p+XoVit7LGOjjY6u1+Jrt54E75IAgdqCJEY4iPDPDiQ=;
        b=I+Hbo1x+RhjXi7ACkmRP+ZRO3bYBdbtLF8Yb71AZReSxrFUTP35XyG6AYRltJ47AcP
         rlq9/2IKcAkzwJXWznXO6egJ27juTLeD/Dqw+2D8qxQ6XtZkuOYj4kyKGlgC7uuFIWkT
         rX5C4BfpEICoqGkdtxwHSHQgnb4PJ0ci3+KnxaZ1efsakqPoMiOhOdm9NmiwSvjmqMEB
         30BRZPXq+GnBCUKOoWySMeP3IxziEei5bs7q0zWirjtI8pr29KJetMEtlyqc9dwjo5gf
         xzil49o5Li7YxkWZGi3B63j3GAAQXr1G0x36wGKk2WbyorDjHacKlLYCIZNoy1KIiziG
         cwhw==
X-Gm-Message-State: AOAM531CSNFfarGGAp3IKVaOPCu02vyLFpz3ic61d1v/0lvoKd9kG8WH
        mgbdKKeqAsJT9Y3v/FMNfkq8bjULxs1GX8yufFh3MQ==
X-Google-Smtp-Source: ABdhPJyhpsiHB9AMkoVjVYhMXWKpaAjLucwJpMpktnjOqlp27EtpX8ESukkgGvewFCHkngTXwtdRSBmUzClOsKzSEFs=
X-Received: by 2002:a19:8453:: with SMTP id g80mr14616265lfd.167.1589876956314;
 Tue, 19 May 2020 01:29:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200518173450.254571947@linuxfoundation.org>
In-Reply-To: <20200518173450.254571947@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 19 May 2020 13:59:04 +0530
Message-ID: <CA+G9fYsoqa1KdvG+PfxAQTnan+XJFcvXnoaPfONK0DD70HFUww@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/86] 4.4.224-rc1 review
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

On Mon, 18 May 2020 at 23:08, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.224 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 20 May 2020 17:32:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.224-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.4.224-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: 5614224b8432edc87094945490727479494da465
git describe: v4.4.223-87-g5614224b8432
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.4-oe/bui=
ld/v4.4.223-87-g5614224b8432

No regressions (compared to build v4.4.223)

No fixes (compared to build v4.4.223)

Ran 18965 total tests in the following environments and test suites.

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
* network-basic-tests
* perf
* v4l2-compliance
* kvm-unit-tests
* install-android-platform-tools-r2600
* install-android-platform-tools-r2800
* kselftest/net
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems


Summary
------------------------------------------------------------------------

kernel: 4.4.224-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.224-rc1-hikey-20200518-727
git commit: 59657db1accd5fa3cc599da31d1501113075794c
git describe: 4.4.224-rc1-hikey-20200518-727
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.224-rc1-hikey-20200518-727


No regressions (compared to build 4.4.224-rc1-hikey-20200518-726)


No fixes (compared to build 4.4.224-rc1-hikey-20200518-726)

Ran 1813 total tests in the following environments and test suites.

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
* perf
* spectre-meltdown-checker-test
* v4l2-compliance

--=20
Linaro LKFT
https://lkft.linaro.org
