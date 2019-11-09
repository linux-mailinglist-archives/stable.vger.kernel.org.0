Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1B9DF5E66
	for <lists+stable@lfdr.de>; Sat,  9 Nov 2019 11:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbfKIKS1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 05:18:27 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:44119 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726143AbfKIKS0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Nov 2019 05:18:26 -0500
Received: by mail-lf1-f65.google.com with SMTP id v4so6356023lfd.11
        for <stable@vger.kernel.org>; Sat, 09 Nov 2019 02:18:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3+NVeki4QXRmDvfiyIJYr4zxCjUPoykqmFp2TiLzguE=;
        b=ewREG9XAwS8dZ0Fb0/yOMrj45G18VDDKEaOp9uJdjG7DEtzETwUV37lsiOk/3SNWE2
         rWJnUANbMC1rcBtVnXTiIxdfbG3gZrCsjpYvupeaG01cwZtLQIL388Hvje5JonieUoco
         JdxOZebtT7eiw69lVDpgKxWXytxn9OKEKwKk/rEbDxCUsMEo8TPZpa0fTcTehsCa+xnF
         7Irbq/atCIKMX8PF2G5mMEjLaPi4iJpbFVrK4ZFiWZjSuPCOvLHaeDC1KO9Iwc0whcL6
         KaGcIKIAsg/lzJkmzaAr7XvbBs7IIyhaYGrVJ2USF2LD1bHu88645tFOnpUvkOGPHijC
         s+CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3+NVeki4QXRmDvfiyIJYr4zxCjUPoykqmFp2TiLzguE=;
        b=iWb0Ef1PEj4XHjjLODhUK5m0f91Ddm3EAZMHgcawY6UIXCUgWH9MsnevAdybXhHGTL
         rZjppN/IFYYz0xKhVshM/TkhPVstw/zrOZfNDt4KVB9xsjt82DQIbDTG0NE/yAs+bI8p
         h3W2Vpj/RhjBziFMJOQVVfwtf/jOYSTpz06+a0ggooUZDs1e8gV1ay37pUBjIya5zhao
         5J9nyuIBCKGd1znFP+Bi/gNdBVKj2HagaiThMfKPnFaZG3MmwVIEwqBwTE2IQgmWjLxM
         xej/P14SLPMtruOeKBquHXAh52Blz/sKE0htN4WyBkP4fRgYxQmXAhsYQ69k52pVkYLh
         G2pQ==
X-Gm-Message-State: APjAAAWKomiKZFFBnhNVsgfLz3yvCAZegSI6ilMpGRH9q+ns2eLM3LOy
        lGLUNt3bOqpXisXtTObb1yEYZEO3IHeSjm9hBCRjsQ==
X-Google-Smtp-Source: APXvYqxlvJl8p0NKPpcuBR2RXsokC7co92PAr1AcJelUWSbW2X/KCWZYEG27Sw7t2tlQx1DzP8uGcrlUbo7FvcXJhkg=
X-Received: by 2002:a19:9116:: with SMTP id t22mr9004218lfd.99.1573294703965;
 Sat, 09 Nov 2019 02:18:23 -0800 (PST)
MIME-Version: 1.0
References: <20191108174618.266472504@linuxfoundation.org>
In-Reply-To: <20191108174618.266472504@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 9 Nov 2019 15:48:12 +0530
Message-ID: <CA+G9fYuBnNRP9Y_6ed=HtKZNpnGARn0=VWKOp4Ehg-f=fvnbTA@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/34] 4.9.200-stable review
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

On Sat, 9 Nov 2019 at 00:26, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.200 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun 10 Nov 2019 05:42:11 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.200-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.9.200-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: e0ad85ece3979aa8efb65ef7e22c924cd63dc859
git describe: v4.9.199-35-ge0ad85ece397
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/bui=
ld/v4.9.199-35-ge0ad85ece397

No regressions (compared to build v4.9.199)

No fixes (compared to build v4.9.199)

Ran 23538 total tests in the following environments and test suites.

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
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* kselftest
* network-basic-tests
* ltp-open-posix-tests
* prep-tmp-disk
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
