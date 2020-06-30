Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A92620ED4F
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 07:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbgF3FWU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 01:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726980AbgF3FWR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 01:22:17 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72C8BC03E97A
        for <stable@vger.kernel.org>; Mon, 29 Jun 2020 22:22:17 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id d17so6250084ljl.3
        for <stable@vger.kernel.org>; Mon, 29 Jun 2020 22:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9qTa0QzfsDsmvRz7fKgPnwC59SuVUu6TJ3V+opbP+k4=;
        b=w8pM9LlJOVX1fGUrk3Rkss+ak9nYoksk4J6M94Ungd5A1tb3glYYTk/6XssGlVq9Mx
         pzjfJdHsvwPu2MfTyEpkz/m9bw7Qu++JyMtSbv5VWVkVGCwbFcRTa5a4DTrxXT3NCST2
         0a51+egH5SNx8zII3jLk7x2jtOFEsC1Af4xdxUUlh8iZqJdfEKRqYQmIf1MySNNusWlq
         tbBkQS93j87RYcu8csugDk+JuRXO+BXeDxLKMna4pZim3rbuiU7U/c2gTG3tva0fyHq+
         dHf1PUFZpxRZaz7FtPWzcD3dE/oz5UTXLVdjYK26Z4dx75DVod1cDkAIUOg4MAcG1GiF
         5ZtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9qTa0QzfsDsmvRz7fKgPnwC59SuVUu6TJ3V+opbP+k4=;
        b=Lpt8KItOsz64Q9oseRtQU/cGd2M4cQ3qy0kyVQIKNs8zsY8Jc5jk/h/EHQbdDTAbqj
         G+HlJ3iXGPJBlBGadcVnwt5FkWn2xJq7SRH3H9iWhZksTqmE0UeAZ3+YdyuZQ/zKYzEj
         vyqZcbafpmGygVHJWb98R9+faWxRlSWCNC9lRRLonIiCoAfz2pXTYx9ufir+KFx+FcWH
         FFqaaudIprQBlhyIRqp3DKC2TXr+Ur1W0p07DX+ESc2CrZ+fWmVQ4PcYA6iaSE8TBew+
         PNfkWzKcarRNo3ErSZLiaE6cobgj4xS/0uN2cPkB5DeTtbK6/HouAwdJO7Mjn+DKiVm6
         RQyw==
X-Gm-Message-State: AOAM531N/G9ujj0I/znkQdR6n35d4ag3f4U0yTYm3Iim5T/DtUfKn2Pc
        XXcyfC0fSIkJcmsdkIZ+zSroNmxGrCxJnIgfzvoHhg==
X-Google-Smtp-Source: ABdhPJzbcG26GiwMn5Y85LLRVheOo7eBUCzTe4DBikJ3MwAAL14sldLdOTOQ9coABbisMAUnWXpnmguh9Iqy47lsMEY=
X-Received: by 2002:a05:651c:1a6:: with SMTP id c6mr1927013ljn.358.1593494535598;
 Mon, 29 Jun 2020 22:22:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200629152523.2494198-1-sashal@kernel.org>
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 30 Jun 2020 10:52:04 +0530
Message-ID: <CA+G9fYtVNQj2=W38guCJDPxGYW_Ec9zC9dswNyXNZngLPgxc9A@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/178] 5.4.50-rc1 review
To:     Sasha Levin <sashal@kernel.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 29 Jun 2020 at 20:55, Sasha Levin <sashal@kernel.org> wrote:
>
>
> This is the start of the stable review cycle for the 5.4.50 release.
> There are 178 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed 01 Jul 2020 03:25:02 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git/patch/?id=3Dlinux-5.4.y&id2=3Dv5.4.49
>
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> --
> Thanks,
> Sasha


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.4.50-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 7d61c4b6865ab9c9f22e4ddbc65645c0c4b0427e
git describe: v5.4.49-178-g7d61c4b6865a
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/bui=
ld/v5.4.49-178-g7d61c4b6865a

No regressions (compared to build v5.4.49)

No fixes (compared to build v5.4.49)

Ran 36125 total tests in the following environments and test suites.

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
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* kvm-unit-tests
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-mm-tests
* ltp-sched-tests
* ltp-syscalls-tests
* perf
* v4l2-compliance
* ltp-commands-tests
* ltp-controllers-tests
* ltp-cve-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* network-basic-tests
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
