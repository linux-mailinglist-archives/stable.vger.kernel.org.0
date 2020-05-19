Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15C931D9106
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 09:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728476AbgESH1j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 03:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728456AbgESH1j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 May 2020 03:27:39 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E186C05BD09
        for <stable@vger.kernel.org>; Tue, 19 May 2020 00:27:37 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id u15so12597695ljd.3
        for <stable@vger.kernel.org>; Tue, 19 May 2020 00:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xxSaOAYdZ/P2LPa+RkxvFduPUE3GNPCNdQNl0HbVXo4=;
        b=gxYxckCxwAOsiP0lqJ2lop9PNhRWiEwE+1jfsiCpw0NMUNN6IvKfT1w8vrcllcEiaX
         D8GItZdIjOsDIMpYGv8pPAHt3o6gCpnwtGBeHkfGJJKo4C/1KYxEvcF7VDiJEDhMaw+c
         xp0TJKiPP9TtgnzikV5mCSSNzj+tJUXJunutHPumUH1ApXdygADZhMMU3fBJ9UFDy1ms
         tI5rYxF90N1ZT5P03oIEeasTl3jfcreawB5Hk0ilTnLIFqHa9OYHlZsaf1EIDYnB78Oy
         DkA1+hLUYzVMAqF5t9cgDypf9dnT07ek0POQpiNlipC+9Gw2i8MWmZO9/+zOjJuda2is
         /dYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xxSaOAYdZ/P2LPa+RkxvFduPUE3GNPCNdQNl0HbVXo4=;
        b=iLepdl5u1naW1kWU4OoWxTSr6ibOiwIQD6sfUMAonSFmkhWltbizyaySIEiHuy71OQ
         w3y0Bjjg+sj4raxuep69tE0DyLGCopLwDnbvYKjM+3xXQPdzVdgEia5lXUaxNQszKgIN
         Od11UDnXS2tJN6YYqGfjDLKp+/gnkhsgIf7FdU6Frs8Hsd6Mivr0lj2+flcC3KJEqbHw
         uoLZE1kSoTabvqCyyepel//zapxBRtpNsF30r0nuSNFjK+RUnkks9ol5D+ubHtYmALZu
         9eS/Tv/r+HbRNCbXyYg6AsG46Ubt7ESKZQCQYlVhG+yStpxtLRP4z1Avfxhy6QFRoiid
         bYbg==
X-Gm-Message-State: AOAM531YxqsUi5Ns+wQoV5w53oJgA4E2Aitu5L7lkwHEjDCHRbUHmDG3
        zbQIij9lD4khX+P6sXY9igg+7mlizB/DyN/sC+sZ6Q==
X-Google-Smtp-Source: ABdhPJxukUp8JTGuGFk4m+6IZKXWul5pdOxr+SBVghfnSi1YvwZzy1DtbuljqEBS7ZNm23lLZlhAZiXCzRmYwKLD4uw=
X-Received: by 2002:a05:651c:1a5:: with SMTP id c5mr12523269ljn.217.1589873254659;
 Tue, 19 May 2020 00:27:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200518173513.009514388@linuxfoundation.org>
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 19 May 2020 12:57:23 +0530
Message-ID: <CA+G9fYvT4rBSet6yjdFXeVcJGaFw6zvPZTKxPA-7_=P8Ehkx0g@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/147] 5.4.42-rc1 review
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

On Mon, 18 May 2020 at 23:30, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.42 release.
> There are 147 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 20 May 2020 17:32:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.42-rc1.gz
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

NOTE:

While running ftrace test on arm64 hikey device the following kernel warnin=
g
triggered and long with this rcu_preempt self-detected stall on CPU
also noticed.
Please find full test link below,

[ 1313.494714] WARNING: CPU: 0 PID: 458 at
/usr/src/kernel/kernel/trace/ring_buffer.c:2477 rb_commit+0x2c0/0x320
<>
[ 1313.770237] CPU: 0 PID: 458 Comm: avahi-daemon Not tainted 5.4.42-rc1 #1
[ 1313.855515] Hardware name: HiKey Development Board (DT)
[ 1313.939230] pstate: 60000005 (nZCv daif -PAN -UAO)
[ 1314.022148] pc : rb_commit+0x2c0/0x320
[ 1314.104229] lr : ring_buffer_unlock_commit+0x30/0x128

full test log can be found here,
https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/build/v5.4.41-148=
-gcac6eb2794c8/testrun/1441704/log


Summary
------------------------------------------------------------------------

kernel: 5.4.42-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: cac6eb2794c85e7777fb0caac6fa75b6364d81a0
git describe: v5.4.41-148-gcac6eb2794c8
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/bui=
ld/v5.4.41-148-gcac6eb2794c8


No regressions (compared to build v5.4.41)

No fixes (compared to build v5.4.41)

Ran 33314 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- juno-r2-kasan
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
* kselftest/networking
* libgpiod
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-sched-tests
* ltp-syscalls-tests
* perf
* ltp-containers-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-io-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* network-basic-tests
* v4l2-compliance
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
