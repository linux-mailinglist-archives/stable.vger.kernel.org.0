Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA262FAF07
	for <lists+stable@lfdr.de>; Tue, 19 Jan 2021 04:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389732AbhASDKA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 22:10:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388359AbhASDJ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jan 2021 22:09:59 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6983C061574
        for <stable@vger.kernel.org>; Mon, 18 Jan 2021 19:09:18 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id ox12so2138323ejb.2
        for <stable@vger.kernel.org>; Mon, 18 Jan 2021 19:09:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=t54WlmjcCx9kj1gC9gsGEd0/hsb8LZYYV5WeKOb7cdI=;
        b=RFIGTAvyFf5/eOWco39I+d2vN+7BF9R1HcBZHwEPY3tYiw3Gsev2AoZ5U/rHZ1Qkl4
         z5xZOYfsS2pYz0splenD4F0jwyMimF9IJiUpbjjxZU5aARKRk2r+oabciMY0TbZdxaIj
         Df0f50yDx0qWQZliLZNhJu4qnKIcuaX/KMnfi48l4wu8+pvDzMO4cA+NY7AeufkM2yVz
         ycPdw475EIpXXqYkU+BIv8z8SIhpXW7ceSroVhf2K2rSxdWAYzzBypfZ1jrNAX9f2rL5
         5PIYy5d69CuktI9EkNterwQ3mievkUjkUSh8BnCH1Uv3St/MXsm3d4XWpEe84J1bjkkv
         WXSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=t54WlmjcCx9kj1gC9gsGEd0/hsb8LZYYV5WeKOb7cdI=;
        b=W0n1HoSB0GhDOGzt0zmYE6yURScqP+mSbI9v1YE3+EdEx7PZbh5yZP4lW5ai5l4Orz
         eVGa3v6uEYI/82wYCgxKMTZHTA40Aa0eppmRX0Geo/ibYw5RiwZ3hSDpTLOEvtcBjEsb
         c09ETpn0xr9okIoW/ZQoH93MDmTkN3QZS6V/bottvrUQjAGRJS/y9gvFCLXcJU4bLpJx
         HaoFnj5Y19ryiCH4DBfv5lyOKE4Ghz+42Oo5m3Bqmc/Fhb/HzVyvm+E9xyKGSaCnMt5p
         6TzCzMa8Rtj/nWZ81WfrWuUgMymRoEwXXPz7Kz9JzIiRCzx1zdpmG4/8h+VCaeX78lvj
         tFKQ==
X-Gm-Message-State: AOAM531C/W03ROtQQrTCDZnbV5rtFvBN67du8Xfxi04JnxhoSUDrj8ZQ
        x0zWhPyEj9QPWz3qRm5QPfx5zwYdbOuC/r+N+Fr26BQbagMWOKD8
X-Google-Smtp-Source: ABdhPJww0NChmTLUsIx2ZDsQOgsWxALB19p/v9/fCEi2kNskMoBxrNK/FIRoNw5T7ce0VDAxuvmrlpQLNsh2A83GhPg=
X-Received: by 2002:a17:906:4c85:: with SMTP id q5mr1592443eju.375.1611025757185;
 Mon, 18 Jan 2021 19:09:17 -0800 (PST)
MIME-Version: 1.0
References: <20210118152457.528300594@linuxfoundation.org>
In-Reply-To: <20210118152457.528300594@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 19 Jan 2021 08:39:05 +0530
Message-ID: <CA+G9fYumt13mSEO+aKoq5Y-y=a9MZ93EVMRzbd=A2WjouBX=Xw@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/75] 5.4.91-rc2 review
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

On Mon, 18 Jan 2021 at 20:56, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.91 release.
> There are 75 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 20 Jan 2021 15:24:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.91-rc2.gz
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

Summary
------------------------------------------------------------------------

kernel: 5.4.91-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: f07bbbcbb287be51052321bcb6b6d4edbdf810e6
git describe: v5.4.90-76-gf07bbbcbb287
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.=
y/build/v5.4.90-76-gf07bbbcbb287

No regressions (compared to build v5.4.89-63-gaddd8d79e8f6)


Fixes (compared to build v5.4.89-63-gaddd8d79e8f6)
------------------------------------------------------------------------

mips:
  build:
    * clang-10-allnoconfig
    * clang-10-tinyconfig
    * clang-11-allnoconfig
    * clang-11-tinyconfig


Ran 52358 total tests in the following environments and test suites.

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
- nxp-ls2088
- parisc
- powerpc
- qemu-arm-clang
- qemu-arm64-clang
- qemu-arm64-kasan
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
- x86_64

Test Suites
-----------
* build
* linux-log-parser
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest
* ltp-containers-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-sched-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* perf
* v4l2-compliance
* fwts
* kvm-unit-tests
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* network-basic-tests
* ltp-open-posix-tests
* rcutorture
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
