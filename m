Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF7F1F0A2E
	for <lists+stable@lfdr.de>; Sun,  7 Jun 2020 07:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgFGFoP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jun 2020 01:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726238AbgFGFoP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jun 2020 01:44:15 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A67D8C08C5C3
        for <stable@vger.kernel.org>; Sat,  6 Jun 2020 22:44:14 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id z9so16507367ljh.13
        for <stable@vger.kernel.org>; Sat, 06 Jun 2020 22:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UoU2bDdv+MdG+/9ThH3R0k+UfNqB3rI33QgE+dDEvlk=;
        b=m4mFjgZDGBJGlVvSY8+85jkJ1+IQH/pG//Xy5+jwnJhi5dPtnypPzdrIOlgR3JQpNP
         5F3+W0mL15lcKJdXadtDq0EnvYRVlZUlTDbIKtI0Zg56DnM/Qk/T5BxVSYQCx+2PTYOT
         p5YWu39/OXNXRPMz1VnPYYCD1/+Cc4/ln6MVi5ko5GcSS2u85jBG93xJ/OqZ//MBhkPm
         98tktpI9B1h8GCXdEt+G+M9Bwr7FXvomJjAj93tPW/Ed9wZvZ36gp2v97C5gh1raVJbD
         Y1UU1mtioD70eN3+y8pQas76fMcx7Dfswtadx42cz6wTzKIzVD0N2c1BFyKcLKnrnJ2D
         rxKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UoU2bDdv+MdG+/9ThH3R0k+UfNqB3rI33QgE+dDEvlk=;
        b=VdzcApz6zWr+vzvzxLRjh2id1Yarg4UcsrJD1B1WonTPXbbVJNYgSHWdMNmLD7I4qk
         J01MDIeZM0MXuIAGcOQ3CNmqldHrIc4nUAqXYhzr9uDZIvjczzex8Yjq3fYTRWPWIfEE
         DPO+LjJh3nkB76kRb0ZYHccWLhbZ3+Nvkj1pD8hfAIbyZGxOBlM2mW2uSvCRKBI5+te9
         scRSzUloPcvl5tAzzVVOuV+dnA2XvZ2vCihHCoYSJnzyEWBJXe61SzeGvSXKun0SOPQw
         PLhlHkaSZDanzXk3oZfVNs/R1y8mTepEgPMp7MLdBlkHrOTnrF0xV08hXTY4oXgElIdr
         N3rg==
X-Gm-Message-State: AOAM531nKQBpPLAQeInTwHyX1DNnPB6j2bGNqcrd7PApOn7rJRUG/0N9
        FXBqVEbjDWq07SAGKYAqwyFWPTeUVBMH5OZwYtmjiw==
X-Google-Smtp-Source: ABdhPJx8tZF4pxo4A3Y+o/D9PdaVeLWfZ8ESsIIJo/9NY/7ZyMIXMAFQehQ6BBWrn6V3JZxEWevDXgyHqk+fYPpTzUc=
X-Received: by 2002:a2e:9009:: with SMTP id h9mr8158978ljg.266.1591508652780;
 Sat, 06 Jun 2020 22:44:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200605140252.338635395@linuxfoundation.org>
In-Reply-To: <20200605140252.338635395@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sun, 7 Jun 2020 11:14:01 +0530
Message-ID: <CA+G9fYu-WobdAq_Xw_uHk4tiTi4=NLgYQrqAnd8DB+mtWYx=nA@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/28] 4.19.127-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 5 Jun 2020 at 19:50, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.127 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 07 Jun 2020 13:54:56 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.127-rc1.gz
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

kernel: 4.19.127-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 65151bf9f715983d62613a4d9196525eb64dda53
git describe: v4.19.126-29-g65151bf9f715
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.126-29-g65151bf9f715


No regressions (compared to build v4.19.126)

No fixes (compared to build v4.19.126)


Ran 32146 total tests in the following environments and test suites.

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
* install-android-platform-tools-r2600
* install-android-platform-tools-r2800
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-ipc-tests
* ltp-sched-tests
* perf
* v4l2-compliance
* ltp-commands-tests
* ltp-containers-tests
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
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
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
