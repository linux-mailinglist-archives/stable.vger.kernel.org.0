Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA66A9AA46
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 10:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392411AbfHWI0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Aug 2019 04:26:36 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:42511 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730759AbfHWI0g (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Aug 2019 04:26:36 -0400
Received: by mail-lj1-f194.google.com with SMTP id l14so8065962ljj.9
        for <stable@vger.kernel.org>; Fri, 23 Aug 2019 01:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Ei2fflkWmYx29L2DvfP6gO0YcKa8w1PsJQRnQ3bwOOw=;
        b=cuh/+hjrQKfDst0VBgf43KbUa7s/BrRVbEjQT1+J8T65JN4Wc5H7RFWOkmWwB/aLB2
         SoTc0msWBlb54IdeTFq0YwTCGUWKWksRacojaOKMjbqT7A9WIjQ9J/IuV6FeA3qNYNZL
         RAcBfY34UiFcbyBiRpELJrR0/3wHd6VMAx0p4EIatyuWohEtU4xhyGMfEDuVwUhZRO6R
         95WOgrTQ1uGmeZ4blE3hHT/T4QnMCZ4P/c4dWcGQ1bsnhTatnNGJkWW8u0o7+aVe1ccF
         yRWJPq0Mdf0XlqgHx+LUXLg1wjmulqFFTlXzjuLgYAWQi3N3CtymS528FiT+DGsUHGXD
         CFGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Ei2fflkWmYx29L2DvfP6gO0YcKa8w1PsJQRnQ3bwOOw=;
        b=l7NxkRyb5o4PevJIkJaUtOb3ZpxHka6+878vJXoTvfoc9dcC+SrBMRHhGullZDYNU0
         ei04Cg11IqBAXTTrKMQOPf9ASH1pmEiiSFXFYzIzD04R5bFFVs5G6pr9TfjEqi9z7FfU
         hkUnD1w5nSW954L3JXXLAUlpiQv6QYtdxD1Gu52nk+Y8f5W4fMyXisI7RH2/e/Nd6QpG
         QSgaHTDMS20hDLv/re7ReCUjdvX2BZN4ysdaZsF+epXZzVY/uos+73ru9C5kXldq0sFb
         aPIhnt6gPVckyh+rfPYAs31MJfRni/4sa5iLuyAPsDhxhe+kxIMfKZmhhOpMTFq5oYPn
         lIVQ==
X-Gm-Message-State: APjAAAXhMvRfKaS+mZ4iGu3mOMuuU6+2EtLEQHjxVvQ0x3SNR7GIrwZy
        aaPLe9hNkkOYE687FtB87Qq1U4Nz+SU6DsVWhOj0Ow==
X-Google-Smtp-Source: APXvYqy3KR8PkNemNTvSsvAPKbwWz5AYA4idh215gAMbHm3HrR6/fvRPnTIsNZj57xRG2aedNB37kQBnWN7B7ReL8jE=
X-Received: by 2002:a2e:8559:: with SMTP id u25mr2128013ljj.224.1566548793811;
 Fri, 23 Aug 2019 01:26:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190822171832.012773482@linuxfoundation.org>
In-Reply-To: <20190822171832.012773482@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 23 Aug 2019 13:56:22 +0530
Message-ID: <CA+G9fYv90rOtmxHpvvs2_TssLj9Ngp_vJh5sjoz0nj8y+mhNzQ@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/78] 4.4.190-stable review
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

On Thu, 22 Aug 2019 at 22:53, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.190 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat 24 Aug 2019 05:18:13 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.190-rc1.gz
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

kernel: 4.4.190-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: f607b8c5ce70dfa9966f5f1f560bc7888aacbb63
git describe: v4.4.189-79-gf607b8c5ce70
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.4-oe/bui=
ld/v4.4.189-79-gf607b8c5ce70


No regressions (compared to build v4.4.189)


No fixes (compared to build v4.4.189)

Ran 20031 total tests in the following environments and test suites.

Environments
--------------
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
* kselftest
* libhugetlbfs
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
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-timers-tests
* network-basic-tests
* perf
* prep-tmp-disk
* spectre-meltdown-checker-test
* kvm-unit-tests
* v4l2-compliance
* install-android-platform-tools-r2600
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

Summary
------------------------------------------------------------------------

kernel: 4.4.190-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.190-rc1-hikey-20190822-542
git commit: 1ba22f5aa4da73b8aba0abbbbb0d9c225dd0c34f
git describe: 4.4.190-rc1-hikey-20190822-542
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.190-rc1-hikey-20190822-542


No regressions (compared to build 4.4.190-rc1-hikey-20190822-541)


No fixes (compared to build 4.4.190-rc1-hikey-20190822-541)

Ran 1550 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* libhugetlbfs
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
* ltp-timers-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance

--=20
Linaro LKFT
https://lkft.linaro.org
