Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF3593013A1
	for <lists+stable@lfdr.de>; Sat, 23 Jan 2021 07:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725766AbhAWG6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jan 2021 01:58:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725290AbhAWG6r (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jan 2021 01:58:47 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1752C06174A
        for <stable@vger.kernel.org>; Fri, 22 Jan 2021 22:58:06 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id g24so9056326edw.9
        for <stable@vger.kernel.org>; Fri, 22 Jan 2021 22:58:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qXe57RkgV0CANrKRbI7Iy/z3Nec5DdF0GM/x71Sm7Lk=;
        b=X5U7W3DDe0SzvDdRP9l9E8Hdxo0TolcZ45D4aNN2n6/vXcVSoA+iYoyqYzr4I3zXbg
         M/6W8yGAvocS1rJfqLBJEL8hVQODwpTUihs/4WmRqDBd1UOGphDcjKlUdQUDmr9/bZP2
         wCoPSMTntzVi6bxB+DQjHf+MevD2QUr1+iiPzGwjdkKgDIpUqvreh4vsOeFFgErJDxVb
         bAkU+49b7hWvlrZu51aYcykmrCYsdthHZV/fNsNeQ9L4fuSKELevUby02vRw3eYAFsWd
         +6FYmc8EdvrYMHinxHeG3jxZ7lYqwsp1cTv25Yz5Tbl0sJ7RVIkDgNoNam2dgDGeJLXB
         IxCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qXe57RkgV0CANrKRbI7Iy/z3Nec5DdF0GM/x71Sm7Lk=;
        b=TZxFl4Fjwy7YKkgbI2vvAsAxJoOcs+7QLJhpERlZgS3NjnaN3tPGoaT/y6AWcekwEb
         7m0iWj/JGzPRwiL2Ij1DgBQ4nRPaHQwm3yVfz30lF+TuLzEyrectkGqZUv4QfToORcS+
         7wjFbZZePY3Vs5NeFdEY3CGpStBrujF+j8c32u6qOWC5ZwTW/iD9rb03IwsrZqaI5ktL
         DBhF6HOQ71ZTuBLix4RdTLA/5aCdmIAl9okRsqOCwVoGiCn39nFltibpo91d550B4upC
         2nTIdsujszPjzaJikfOV0IxhjUJNMN8L52HAQXbjJELbHQqDac5SfpicL0Wv2onT0REK
         GP0Q==
X-Gm-Message-State: AOAM530SgYa8rXR/8uiADdbYz7LRFpxoeY3e5YLAp5c9TBbDSdHDQxS/
        RIAtpcjvxBFSPHLTcJvls1Zmwxp6CFujw4Kt384+SQ==
X-Google-Smtp-Source: ABdhPJy3j+ArzvSdpIbLkszAevz+C6aBh/J/BJvRaKbh7HsKjbXFKP1Az2ZafNrDqcoXsUM59wmeuIduR39UxxT81MA=
X-Received: by 2002:a05:6402:5107:: with SMTP id m7mr123469edd.52.1611385085357;
 Fri, 22 Jan 2021 22:58:05 -0800 (PST)
MIME-Version: 1.0
References: <20210122160829.171484729@linuxfoundation.org>
In-Reply-To: <20210122160829.171484729@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 23 Jan 2021 12:27:54 +0530
Message-ID: <CA+G9fYta8vpUaovHZPukuO3_2_VCDSJS5zu01FyZTkTYZAy-fA@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/33] 4.9.253-rc2 review
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

On Fri, 22 Jan 2021 at 21:40, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.253 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 24 Jan 2021 16:08:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.253-rc2.gz
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

kernel: 4.9.253-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: a4108af7f0fa9a58f591ef0bdc78216746dacbd5
git describe: v4.9.252-34-ga4108af7f0fa
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.=
y/build/v4.9.252-34-ga4108af7f0fa

No regressions (compared to build v4.9.252-36-g2d7bd2c1841b)

No fixes (compared to build v4.9.252-36-g2d7bd2c1841b)

Ran 39925 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- qemu-arm64-kasan
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* linux-log-parser
* ltp-commands-tests
* ltp-containers-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-syscalls-tests
* fwts
* install-android-platform-tools-r2600
* libhugetlbfs
* ltp-cap_bounds-tests
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
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-tracing-tests
* network-basic-tests
* perf
* v4l2-compliance
* ltp-open-posix-tests
* kvm-unit-tests

--=20
Linaro LKFT
https://lkft.linaro.org
