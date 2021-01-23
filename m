Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 195C33013B5
	for <lists+stable@lfdr.de>; Sat, 23 Jan 2021 08:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbhAWHWY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jan 2021 02:22:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726714AbhAWHWI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jan 2021 02:22:08 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 158DAC06174A
        for <stable@vger.kernel.org>; Fri, 22 Jan 2021 23:21:28 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id ox12so10921919ejb.2
        for <stable@vger.kernel.org>; Fri, 22 Jan 2021 23:21:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0LlK4kArWPPYmr+BkU5sS/aSbMcNMXvRAtCkrMN0odY=;
        b=pPvVLDvD4D8xPL7/9o+VtClMyUcSYUjxz+/zgGs7bLp7/7BhDVrBScq9vgQW+NYJbk
         eGlpYvj1h0B4oxrVn31+7cvOLIW5zD8DOyOmRoSyaazyW/Ve26NIuZvFwUSFNViNw0Gq
         bDCUuCCs5i/oF+HeKO0MIUvwtjEubpk5IyzyybpF1TeyAcCLKrw+R9Ya7KUw5GFgoORP
         e/jf7HS0Cfxtr7A24l4TQkR3Qw6iJUtvRyTZ5YXjZfZQw6BOYdI6rQjR+7164R4iRHQM
         bFC8/fRTsnOeBkJIJYOofKPCBvtkOCsGMmoKdlkTxQa7iTE3h451Mac4moaIfw2DSTIC
         lgrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0LlK4kArWPPYmr+BkU5sS/aSbMcNMXvRAtCkrMN0odY=;
        b=ZJ9A0mbShnEqrp6LfBIxVJlpjXfrQYuVtqe31X/7+oOwgZrrVps/CMZKpTwp8qqnLR
         P76xEnUoLufT5LmplvhQUm/MUFWTg+7+1NERHM+r/mVUdHijs8oxF2truWRd1CKr7EXD
         JEy1zGS0eneU3UdBvqPXZXZYWB7wpFkNaQ08mT1PTrttNrSOyBUe57iAum2flh1XST+6
         okdgHTUZRhrW8TIrPPtUOpXKt+ha9SH8vLLf3s9LebVdb1p7pxiqJAYqXhiJK0oumgq9
         7LbfCPfLeYZkq7xlbvBq1znCpys4E6WuArLYC7CDXOiBJSvBlNilEPGH2HgHZmWbLFTo
         dHTQ==
X-Gm-Message-State: AOAM530j7IEYujHMeD2UsAvZtvbdIqbXpZ8Y9602YMRkjt1q/iftT6ff
        5tk0UK6Xz6B8nZ1hBYDuO/zSov8KAkeIuvwp0wQ98g==
X-Google-Smtp-Source: ABdhPJyId+NLQaIG+IaiFAfEd459rne/YYdvgQHSvrUFDOEpywkRlVh8yrOI9yU7kItPchhtil3gMYNtuyV9C36hbtg=
X-Received: by 2002:a17:906:39d0:: with SMTP id i16mr5323802eje.18.1611386486678;
 Fri, 22 Jan 2021 23:21:26 -0800 (PST)
MIME-Version: 1.0
References: <20210122160828.128883527@linuxfoundation.org> <CA+G9fYu41fj0V_Toc6jadedX4--NG=BHKS3D5dZ45tR-0twnPQ@mail.gmail.com>
In-Reply-To: <CA+G9fYu41fj0V_Toc6jadedX4--NG=BHKS3D5dZ45tR-0twnPQ@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 23 Jan 2021 12:51:14 +0530
Message-ID: <CA+G9fYuRku-A2j7jDLJZziW2ERPA0tMj62M2m6GX+Z-h7T0HQg@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/48] 4.14.217-rc2 review
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

On Sat, 23 Jan 2021 at 12:03, Naresh Kamboju <naresh.kamboju@linaro.org> wr=
ote:
>
> On Fri, 22 Jan 2021 at 21:40, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 4.14.217 release.
> > There are 48 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun, 24 Jan 2021 16:08:17 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patc=
h-4.14.217-rc2.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git linux-4.14.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
> Results from Linaro=E2=80=99s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

>
> Summary
> ------------------------------------------------------------------------
>
> kernel: 4.14.217-rc2
> git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
> git branch: linux-4.14.y
> git commit: 10fddc03bd61fb44e84e0fd3550f78e950cbe2a2
> git describe: v4.14.216-49-g10fddc03bd61
> Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.=
14.y/build/v4.14.216-49-g10fddc03bd61
>
>
> No regressions (compared to build v4.14.216)
>
> No fixes (compared to build v4.14.216)
>
> Ran 39231 total tests in the following environments and test suites.
>
> Environments
> --------------
> - dragonboard-410c - arm64
> - hi6220-hikey - arm64
> - i386
> - juno-r2 - arm64
> - juno-r2-compat
> - juno-r2-kasan
> - qemu-arm64-kasan
> - qemu-x86_64-kasan
> - qemu_arm
> - qemu_arm64
> - qemu_arm64-compat
> - qemu_i386
> - qemu_x86_64
> - qemu_x86_64-compat
> - x15 - arm
> - x86_64
> - x86-kasan
>
> Test Suites
> -----------
> * build
> * install-android-platform-tools-r2600
> * libhugetlbfs
> * linux-log-parser
> * ltp-cap_bounds-tests
> * ltp-commands-tests
> * ltp-controllers-tests
> * ltp-cpuhotplug-tests
> * ltp-crypto-tests
> * ltp-cve-tests
> * ltp-dio-tests
> * ltp-fcntl-locktests-tests
> * ltp-filecaps-tests
> * ltp-fs_bind-tests
> * ltp-fs_perms_simple-tests
> * ltp-fsx-tests
> * ltp-io-tests
> * ltp-math-tests
> * ltp-sched-tests
> * ltp-syscalls-tests
> * perf
> * fwts
> * ltp-containers-tests
> * ltp-fs-tests
> * ltp-hugetlb-tests
> * ltp-ipc-tests
> * ltp-mm-tests
> * ltp-nptl-tests
> * ltp-pty-tests
> * ltp-securebits-tests
> * ltp-tracing-tests
> * v4l2-compliance
> * ltp-open-posix-tests
> * network-basic-tests
> * kvm-unit-tests
> * rcutorture
>
> --
> Linaro LKFT
> https://lkft.linaro.org
