Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02BF5230423
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 09:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbgG1Hb7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jul 2020 03:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727883AbgG1Hb6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jul 2020 03:31:58 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C68BC0619D2
        for <stable@vger.kernel.org>; Tue, 28 Jul 2020 00:31:58 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id 1so5017084vsl.1
        for <stable@vger.kernel.org>; Tue, 28 Jul 2020 00:31:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZbFCXvxP+fFHGR4N/FgG+HjU9RmHsV1+bMr4E/Gbzz4=;
        b=HiYjCKJ7qFiquKjeAi7xfxFQDgvUCQ+Y/xpb3aC0T02t3qOFfixU4TbXF+sBtFkuA9
         /dvL6yzxt9qBuGXSWLtO3q96Nm11IG9KiFmtoGQErPRmVG8bxmglI3oIbXwP2YophnOw
         nqILny8rMxCHUBb10ViKuLo6/rfGYsetOjhaGRGfRdK3vZUsKKyUHD81jOHgJvyFikUM
         DGNg57rlZJU5MGw9kJ9C4FrOW8XJN1UaIE8G6Xx0xZaJKWWCxhRvMPCnr2tjJYjyB/Vi
         dYIV9lPP3JaR+4as2vaAWb9H2THCBRDzv3cbGt4Hj05sV770Q9MkPpwodXIQUu/HheT2
         ByUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZbFCXvxP+fFHGR4N/FgG+HjU9RmHsV1+bMr4E/Gbzz4=;
        b=FFJQBshuigEAuBgXEb6FxSsz4CyayFB2WU/zlqrP0FxPJT0JXD/xPJ6V/lsLkS7nUT
         QAxlcZIpvL0DlIlBZwGI6dy4af8miA6s25/QR9VrUMgFSrYF9ESvNXcajKFEb42OImRj
         w04RdkRnn0J1a2aeQEsR10dvNLTF3rkbomknsPsS2/tu7du1VTylru0OnilAjf8NvN6h
         ftCTJtU9tTpmTbAp8dhhtVsvyOBTWujewVaY8J60vmEic6uCgGKdRTHFK2P039g9xsH9
         ue9Bp312AU051iD+sMdHp8yoHlhkoveit2Q0WhyltSiwWPjBLMFvZFjClRb1Uivn/tT1
         Ruwg==
X-Gm-Message-State: AOAM530ifd1xQKsRbnFXbnBk49HwR7UkGJtMib7fFKY+Rw8MlEAoFTnD
        5VNyatflMeMTGQuvSndftOUmBbsGrvmF8CcdZxf3mA==
X-Google-Smtp-Source: ABdhPJy5KcCcYrS0tQ9VwURE39nUC89Gqy5ZFM+Ty7HbgwYuTRut4e4O6KLZKzMWG6dwNLbDDoHY+UPqvoo5g2kBFpg=
X-Received: by 2002:a67:fbd6:: with SMTP id o22mr18393761vsr.120.1595921517278;
 Tue, 28 Jul 2020 00:31:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200727134925.228313570@linuxfoundation.org>
In-Reply-To: <20200727134925.228313570@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 28 Jul 2020 13:01:45 +0530
Message-ID: <CA+G9fYt10HsK+=LpunPzguWoQB4WbMaBkTuSCh1diE0QFmfGyA@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/138] 5.4.54-rc1 review
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

On Mon, 27 Jul 2020 at 19:48, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.54 release.
> There are 138 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 29 Jul 2020 13:48:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.54-rc1.gz
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

kernel: 5.4.54-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 7a4613493cc30754cf5159b126623d26314454bd
git describe: v5.4.53-139-g7a4613493cc3
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/bui=
ld/v5.4.53-139-g7a4613493cc3

No regressions (compared to build v5.4.53)

No fixes (compared to build v5.4.53)

Ran 35091 total tests in the following environments and test suites.

Environments
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
* install-android-platform-tools-r2800
* kvm-unit-tests
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-io-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* perf
* v4l2-compliance
* kselftest
* kselftest/drivers
* kselftest/filesystems
* ltp-containers-tests
* ltp-controllers-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-mm-tests
* network-basic-tests
* kselftest/net
* ltp-fs-tests
* ltp-open-posix-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
