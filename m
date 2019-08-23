Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE409A996
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 10:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732817AbfHWIE2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Aug 2019 04:04:28 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:42494 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732333AbfHWIE2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Aug 2019 04:04:28 -0400
Received: by mail-lj1-f193.google.com with SMTP id l14so8009952ljj.9
        for <stable@vger.kernel.org>; Fri, 23 Aug 2019 01:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VoF/algJSKMgKHWqGBpmdLixJOD0TiZXy6qPpZzkEGc=;
        b=VAdVakV+QVBl0S8hOWH4tSDl0EKbMKm24MZqZDksqfLD+Z8fcxIdCzyTvmb1EHBFDK
         2oJE6bWkxUzGbO0bGok5sT6lWbgyt/LTjDVhamqnmQLH/3VYwQnSVu3N31ieb+We97MG
         ioZ2XM5owl/yd+4W13HnRjJfewUwwpiWDjPMqpX/1ZU7BI2ijMa3167bFricdJRUfmsp
         SUnXyfkrPigxGTHFQ6JtlACR6gmZ5VV3beidJtt7Lz7gRSVCcdZ2RuA1yL8bWkLAupwP
         xQdb1y9JaJmg3n0SAGWaiBC5QGB61oFDxaqAiroYW3ukF0GaHqu5lINc/1t1m7gEDUPG
         XZ6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VoF/algJSKMgKHWqGBpmdLixJOD0TiZXy6qPpZzkEGc=;
        b=h7/75HPLVXYAr/SwM98RMStUDFYQx4tRwT7LiOAE6kmVy97Ir515WZs7ZjTY1d/Q1h
         kiphVFtHOPiIzz12P4cE69M4rOHKf7qQoAOAijgWWBxtXsBSUqsdtSRjMkl+8JdwApuY
         lSReM687MUwnAvvLXX7B+rYFeF7OowmzI8K+qWb8Y/f+c/xEZlPMSPHlO97ZK5kcVSB2
         yhL/eer/NcpoeUiSmS1QIlsH+ruS53bNjES71LzqWheDs8oVyLlwwpP/sflEvSpQvpVr
         t/MoMsARtrGCCLUAZig9kh2YkY8Vb8+lM6QVtevVFWSdiukk6HzEQfohCIzkRwlGWk6Z
         6ipA==
X-Gm-Message-State: APjAAAUmWWovfC7OX0/snEIH+Nh+110MhjKpRx6UA1WATYPGx+3USwq2
        AYXYnb5+/k47jfOBwDvHYwlsqHHB9iyIlwmry9YznQN3GsY=
X-Google-Smtp-Source: APXvYqxjqqsEJEwHw8o+bjvJ6VZROY48MGDnQVrLOGHJbr2VsrDNaIsvFdI90H4SXgj5zRFGvryDMI/aXKtREeSEXYU=
X-Received: by 2002:a2e:97cc:: with SMTP id m12mr2145187ljj.24.1566547465947;
 Fri, 23 Aug 2019 01:04:25 -0700 (PDT)
MIME-Version: 1.0
References: <20190822171726.131957995@linuxfoundation.org>
In-Reply-To: <20190822171726.131957995@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 23 Aug 2019 13:34:14 +0530
Message-ID: <CA+G9fYvufBFEuYH8+qeukguhkK_fz20cVpHz+EX8=oddqdtonA@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/71] 4.14.140-stable review
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

On Thu, 22 Aug 2019 at 22:55, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.140 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat 24 Aug 2019 05:15:46 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.140-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.14.140-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: c62e7b28b99c68e465814b56bc02089022f90fc1
git describe: v4.14.139-72-gc62e7b28b99c
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.139-72-gc62e7b28b99c


No regressions (compared to build v4.14.139)


No fixes (compared to build v4.14.139)

Ran 22435 total tests in the following environments and test suites.

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
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-timers-tests
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-ipc-tests
* perf
* ltp-open-posix-tests
* network-basic-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
