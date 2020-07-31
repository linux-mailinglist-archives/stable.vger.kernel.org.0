Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26E672344FF
	for <lists+stable@lfdr.de>; Fri, 31 Jul 2020 14:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732980AbgGaMAr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jul 2020 08:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732979AbgGaMAr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jul 2020 08:00:47 -0400
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E05C8C061575
        for <stable@vger.kernel.org>; Fri, 31 Jul 2020 05:00:46 -0700 (PDT)
Received: by mail-vs1-xe41.google.com with SMTP id n25so1923521vsq.6
        for <stable@vger.kernel.org>; Fri, 31 Jul 2020 05:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kNFpZ5tz0kbxFO/B7KbevfpvofQcxfQQW09ZNgbiZJM=;
        b=W9E2eYN3ZhtNTy+5a5OtCcZ6EA95cpLsSyLthUyZqJmNKEzzsnH6xZ+hlPqzu03m/N
         lvt8zu1gAbNoVDtQDz9M6C8QWD6OATfbb/k/1o/ZzHNw5Up3Dn9SlrNhYQVeyyLc0SP3
         PVQtFlbpAnNqlTcCXZ6VUhEWLaEey8dcQRXTj+6WbY5nZXlJ0xAaMk8NihvFjxNF5wR/
         Z7H30xPs4YmZVQYkmJkeu/p7KHG51S6Sl8IZTAuXaSfmTzN27C6UFWRooSC1dQKq3Bhj
         Z2NKflujhn3nvUiwmNxRm41gLsJhA3yz+OZoWOL8/3VG3rTcmaFTXj/r5Ua/retL9tSi
         Sxnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kNFpZ5tz0kbxFO/B7KbevfpvofQcxfQQW09ZNgbiZJM=;
        b=FDh1IXpjQ5hazKHjRipSxiuUwNRT3GVmHAsIMiQLbGhqSSDDYMIi4BPczFjkEzAA01
         05tbaObrOH6cccQfEwTl9IkyC9UkKfewe4xPc9USBtYwCKQOogZ5cjaPg/S3ECKbKaOU
         PjZdzFq3Pa2xDqQ9Jxos+XWT+ogZUS6tDMkP2tcQpmUKThdFcRgb8VQTocLgTHVbDngD
         1/D3jjj80ZU5kizTJMZicR4Mh0HuzprG8vNwCJ9gBtNm6OD8EbWpfZqMQm+fR6wc/dim
         5YKaPID4AymBz2xwFmQ0pPmpFV+rhBEMW+kF4AOwLNIBpBbOIRIT0SaBfK4Im3Fxb8sp
         Rvpg==
X-Gm-Message-State: AOAM531T8583HMsBSF0lvZ4aRMHx/TmZtcrh4RJiSx9d2yd0szM2dJUP
        wL4w5+nG03F3sntYhAcXwxlpRaB4mp6LxNeTlIjv/Q==
X-Google-Smtp-Source: ABdhPJwwpd17+j0Pu4qHHsMnovOKvdYX5SqOPJq/cw0Lr89plEbJckQqs92ETPUQUV1Lj2+QKIvGDFBZ1/tDn+YKsKc=
X-Received: by 2002:a67:504:: with SMTP id 4mr2774823vsf.22.1596196846003;
 Fri, 31 Jul 2020 05:00:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200730074420.449233408@linuxfoundation.org>
In-Reply-To: <20200730074420.449233408@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 31 Jul 2020 17:30:34 +0530
Message-ID: <CA+G9fYt4M0ZwcE4gZ82mGrGN0wtT0=-+kT764vpJLx-AGZBv9Q@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/17] 4.19.136-rc1 review
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

On Thu, 30 Jul 2020 at 13:38, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.136 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 01 Aug 2020 07:44:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.136-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.19.136-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 62c048b85133b227b3af4b3d3c52853b2ea1f1d5
git describe: v4.19.135-18-g62c048b85133
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.135-18-g62c048b85133


No regressions (compared to build v4.19.134-87-ga2eeabffd1f3)

No fixes (compared to build v4.19.134-87-ga2eeabffd1f3)

Ran 36200 total tests in the following environments and test suites.

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
* igt-gpu-tools
* install-android-platform-tools-r2600
* install-android-platform-tools-r2800
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
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
* kselftest
* kselftest/drivers
* kselftest/filesystems
* ltp-containers-tests
* ltp-controllers-tests
* ltp-dio-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-mm-tests
* network-basic-tests
* kselftest/net
* ltp-open-posix-tests
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
