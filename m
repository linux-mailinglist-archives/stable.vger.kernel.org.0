Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12FBB2503FF
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 18:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725601AbgHXQzP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 12:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728845AbgHXQzE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 12:55:04 -0400
Received: from mail-oo1-xc44.google.com (mail-oo1-xc44.google.com [IPv6:2607:f8b0:4864:20::c44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9FFEC061574
        for <stable@vger.kernel.org>; Mon, 24 Aug 2020 09:55:03 -0700 (PDT)
Received: by mail-oo1-xc44.google.com with SMTP id a6so2047325oog.9
        for <stable@vger.kernel.org>; Mon, 24 Aug 2020 09:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lknoJ2+VX8GYqMT/eq1gBsFGnIRMj9oaqv7IbsL0UhU=;
        b=RpTrmQQ93xX2fVDzR5a+Bt8HOtcLonAbsAg0q666eEOWboTjvsqVnmoEasVAi0dwRt
         1nrQFCr9J1JY8Zo3DOm9tyshKrjExZrFTw7cLhgaZwpUqgNEeGCuHvDvvhaF2EyxtAu9
         +Y1GecxUsfHggn+a6JTMzGnDYyAWVdgRImPn7vd0Eq2EFk203rl97LT8stDlJh6wIUAb
         Jpwiw4wgfKiBju7O2ZjX4re+dGef1WJvDhk+auSyyUV2jYgRja9LNDzeHG5GC0hiICFt
         m9Qxn1bKTIqEnCvV4ODKqA6V30NChc7xQDLbL7Szh+PvHdiAcXUzF/zYWoMwygtPIHJg
         qmMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lknoJ2+VX8GYqMT/eq1gBsFGnIRMj9oaqv7IbsL0UhU=;
        b=odXNtqXDsFeCLfdUBwtek5emEDKAU9jxI9M0iRohVXFfWbauXXoKQBtKJ1+LCwJ/69
         QjmIAOeIgezJOYlb781+teClZsLVtPVYxm0evReyfUvQpB0CiwhAV0Ifdb6Grher4iMh
         7aS/ysIWErRkkoVyFeROw7/jmE+LTk2imC0xkBbx1evxq5Jg/OZxh/Ex9Z7KX7tNjRi8
         3KeLusqSX5B4H5gEQCvRPXkaTbPbgskc/sdXC8f2MHYabjKDnC0XBzoQvy4+EzxY3uGx
         GipbV4nhhc8Tvbdm0hPzM9sY6QWcFT+lTMu6QeeoUq/2MPha91MxE8DiPD8dsCKC6mt6
         CMpw==
X-Gm-Message-State: AOAM531ISuSxUIPsN1M2shX8B9ETRGF24LnpmPzhaSOpVE47f/Vc3Z54
        kQf6ApODSe9svBbM1B66pYlCxD9sW/n90VLxtP1nPA==
X-Google-Smtp-Source: ABdhPJwVMrbGz+jxmBiGJy8I66Hiah1DCKGEIvv199HcdE8ekVWLoPux8+xQ4LPJOxPNWNeMCwFrzP6JCVuOgIRg3h8=
X-Received: by 2002:a4a:9572:: with SMTP id n47mr4308460ooi.37.1598288102682;
 Mon, 24 Aug 2020 09:55:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200824082413.900489417@linuxfoundation.org>
In-Reply-To: <20200824082413.900489417@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 24 Aug 2020 22:24:51 +0530
Message-ID: <CA+G9fYsjTHTZTk4w+fJ9Sp8M6+G+SXEiKtDe5x0sP7QdsPKH3w@mail.gmail.com>
Subject: Re: [PATCH 5.8 000/148] 5.8.4-rc1 review
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

On Mon, 24 Aug 2020 at 14:03, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.8.4 release.
> There are 148 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 26 Aug 2020 08:23:34 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.8.4-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.8.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

NOTE:
on x86_64 kasan enabled build this kernel warning noticed while running
LTP syscalls fork13 test case.

[  928.754534] WARNING: kernel stack regs at 00000000d9dac8ad in
fork13:28354 has bad 'bp' value 0000000000000000
[  928.754536] unwind stack type:0 next_sp:0000000000000000 mask:0x6 graph_=
idx:0
ref:
https://lkft.validation.linaro.org/scheduler/job/1703012#L6510

Summary
------------------------------------------------------------------------

kernel: 5.8.4-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.8.y
git commit: 8960c0bf1993f3bdce3a3de5f03aaf5755f661e5
git describe: v5.8.3-149-g8960c0bf1993
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.8-oe/bui=
ld/v5.8.3-149-g8960c0bf1993

No regressions (compared to build v5.8.3)

No fixes (compared to build v5.8.3)

Ran 40223 total tests in the following environments and test suites.

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
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* perf
* v4l2-compliance
* ltp-hugetlb-tests
* ltp-mm-tests
* network-basic-tests
* prep-inline
* ltp-containers-tests
* ltp-dio-tests
* ltp-io-tests
* ltp-open-posix-tests
* ltp-tracing-tests
* ssuite
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
