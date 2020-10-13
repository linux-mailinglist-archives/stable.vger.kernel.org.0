Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2341E28C85D
	for <lists+stable@lfdr.de>; Tue, 13 Oct 2020 07:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732543AbgJMFwV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Oct 2020 01:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732494AbgJMFwV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Oct 2020 01:52:21 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0BCFC0613D1
        for <stable@vger.kernel.org>; Mon, 12 Oct 2020 22:52:19 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id d16so2094391iln.10
        for <stable@vger.kernel.org>; Mon, 12 Oct 2020 22:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mHEtvI5RIFtftLxVkq35OIot0k+miq1zQnR4jmf9CRQ=;
        b=oXe553UciqDQd+T1PYtE1V6HctjSwpjdAxah0jNcrpmmgmsv5Zk4hRPLQ54lGFuatn
         OCvfFPcM19l8Inj5BtdoDOCM0/oJWGxU+W3Sh7TJI13i9GhD897MvCplOP1xSq4fOaGW
         ZWN3uznttZ7PCXAsSoTHBGPMFlGy+uDV+rOFjZDnHHsCl//+9Qe5jrgAPEmWLvxd1qf/
         VG2XjVQK+kBj4fgXbDmsr3SHMDdmm00MXGVRWdXjSgjBM9yHCIrSwEC3x7LXXA0uj5AR
         5Cq/mFeLZ2ILnhtjLL+0X/UvgxaXN3hpBBt1innyH3hNwglauPDW1WvYgqs7b0O/fpsA
         V0PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mHEtvI5RIFtftLxVkq35OIot0k+miq1zQnR4jmf9CRQ=;
        b=NiiO+l1WDW97G9PhfkqQ0c8BSdb8noisdMHCQCjwlv8dYJHOSM5zKSe/8OwX2Torlr
         vK3ZFP/JqiM+3ZsUOuPOtFF1Cjq+vWBrdte8atXL8CuSpx5AGqGmXDHXyL1FfE4vqGfT
         zF0raXE2yc9RDaTt7k5j9LMso1UhS+DnBOZAT7IzeMt0JFVZbTV1gt4QUlsEQBwbkADt
         aa1VUgEGjnlet05Oigxky7Vy/RMZYBT7uhyReka9CrhsRi8SjWi949P31NySSTWbBev7
         Oi4lGJjsGmikmJqxWAkc8LTAhAPJzDNZUV2erLPkBCSpN7q4OdzwXyp20RBgtxk8cjEb
         Wldw==
X-Gm-Message-State: AOAM532pSyWAXrshyhr2xsCNRVk0VolNk1eCRitKQ09nsGfWseKOhAuF
        u027lCGUpJf/Lf+MpeNzGlmCIGMAaUYPOzevlgGeig==
X-Google-Smtp-Source: ABdhPJyb9EYAx6Yvqfm+EMIdLYr96YMeeaUEXkwWe0qU3jxoSFRDpFeOCTdrQWwur1PZHRhjHzJMk1FIf4CKFY4yPNM=
X-Received: by 2002:a05:6e02:1208:: with SMTP id a8mr1809371ilq.252.1602568338756;
 Mon, 12 Oct 2020 22:52:18 -0700 (PDT)
MIME-Version: 1.0
References: <20201012132632.846779148@linuxfoundation.org>
In-Reply-To: <20201012132632.846779148@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 13 Oct 2020 11:22:07 +0530
Message-ID: <CA+G9fYsUfoU6Gthf1Q5HQSprx_igMBKvJsZ5CD1_f9==9Tt9Gg@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/85] 5.4.71-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 12 Oct 2020 at 19:11, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.71 release.
> There are 85 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 Oct 2020 13:26:14 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.71-rc1.gz
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

kernel: 5.4.71-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 228d88e992eb144f13037001b6b6d0289b9b2f00
git describe: v5.4.70-86-g228d88e992eb
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.=
y/build/v5.4.70-86-g228d88e992eb

No regressions (compared to build v5.4.69-58-g7b199c4db17f)

No fixes (compared to build v5.4.69-58-g7b199c4db17f)

Ran 35909 total tests in the following environments and test suites.

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
* kselftest
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-sched-tests
* ltp-syscalls-tests
* perf
* v4l2-compliance
* libhugetlbfs
* ltp-commands-tests
* ltp-hugetlb-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-tracing-tests
* network-basic-tests
* ltp-open-posix-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
