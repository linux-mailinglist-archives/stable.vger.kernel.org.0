Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7F262DF2D9
	for <lists+stable@lfdr.de>; Sun, 20 Dec 2020 04:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbgLTDSG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 22:18:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726882AbgLTDSG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Dec 2020 22:18:06 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B94C0617B0
        for <stable@vger.kernel.org>; Sat, 19 Dec 2020 19:17:21 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id r5so6321834eda.12
        for <stable@vger.kernel.org>; Sat, 19 Dec 2020 19:17:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NOqBvgFKmLKDvg0GnR9LA/BsC6RX8/kf376irSoDDoo=;
        b=A36IRKFEDouVtmkwQz2qf6aNo9bvig/U9FYoOZcon91hFVX8dezSQRWljKyT6Zyo8g
         F25cGJVJvKbv9HnG4A3pvMoHQURGYmq+W0u4m+WQUSvZG/aC/RIxxthVS8drUagV4WCT
         E2ljJntL2zBjlsL6NYcXcNr0gDV/uCN6FBPcUUjPsOuV5iTuh06nV6yEB3u3FsZXoLwp
         Fv5M+lR6JcCGhLiquhPavFjxni38wR/xRrEszzTOiVYVqJsb/iu5Hv3SQ85/mi0OPO8G
         dNf/JXFzSrVoal+xGnmZaCls990HOalqurfWstBCwQRXVW3/PnDbh3nwxPYNQJETi7U9
         CtEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NOqBvgFKmLKDvg0GnR9LA/BsC6RX8/kf376irSoDDoo=;
        b=MKagG6qKhqsoQhKT047pDhm5HUaVjcCmC9WGRsbwmAAOboVHCJmTKl8dyerlTQKvYk
         0CZnQxe3DqW5flpu3iftgsrc/6uFGlWE/ImXCg4Yn2UmeMbvlfn8iGYI6mWT2DyCpNoP
         mZ+McVMPS7h6hR3cVYNXn0b/oHlusqDKLlbyE/dRyjJhbUapLrdkSfomFEuQhxiNd0U/
         jlqQ11WsC7nKLGJkJ++8s0xQ1DQwe7pEAzOFDX1SFN7lXIBmcUfz4DdeSmKqilTB5vRW
         dpCqpxXTicBTr8TqIydMybmYCzyy+iE+kVLzmx7tfCaTZSeB0lNyTv/yvtvtdHR1RSXK
         ZY6Q==
X-Gm-Message-State: AOAM532Kbt+3niean70XaiJ1bfBgyyGYP8YudjTbh8bv+TzFOe7lfKAe
        Hnk1sQt8hFtOliTdWB0yXLEQBKf7TSZbxhUanjZMXw==
X-Google-Smtp-Source: ABdhPJxBOBH57qliq8Qa4g56UDYlU+0++R4T+s2V4UTmE9phzQ13htz507EXu+cBPteTe+b6QfydS15DmisuFx3Su/M=
X-Received: by 2002:aa7:d75a:: with SMTP id a26mr10683531eds.230.1608434239991;
 Sat, 19 Dec 2020 19:17:19 -0800 (PST)
MIME-Version: 1.0
References: <20201219125339.066340030@linuxfoundation.org>
In-Reply-To: <20201219125339.066340030@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sun, 20 Dec 2020 08:47:08 +0530
Message-ID: <CA+G9fYs_Dsb6hsHqna5S6VmBN8A-8YruVMFyNFfy7fxauosZ3A@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/16] 5.10.2-rc1 review
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

On Sat, 19 Dec 2020 at 18:26, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.2 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 21 Dec 2020 12:53:29 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.2-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 5.10.2-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.10.y
git commit: c96cfd687a3f1d1d461dd4a73eb51410c4fd45d8
git describe: v5.10.1-17-gc96cfd687a3f
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10=
.y/build/v5.10.1-17-gc96cfd687a3f

No regressions (compared to build v5.10.1)

No fixes (compared to build v5.10.1)

Ran 51496 total tests in the following environments and test suites.

Environments
--------------
- arc
- arm
- arm64
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- mips
- parisc
- powerpc
- qemu-arm-clang
- qemu-arm64-clang
- qemu-arm64-kasan
- qemu-i386-clang
- qemu-x86_64-clang
- qemu-x86_64-kasan
- qemu-x86_64-kcsan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- riscv
- s390
- sh
- sparc
- x15
- x86
- x86-kasan

Test Suites
-----------
* build
* fwts
* install-android-platform-tools-r2600
* kselftest
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* kunit
* kvm-unit-tests
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fs-tests
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
* ltp-tracing-tests
* network-basic-tests
* perf
* rcutorture
* v4l2-compliance

--=20
Linaro LKFT
https://lkft.linaro.org
