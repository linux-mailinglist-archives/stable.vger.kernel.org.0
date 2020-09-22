Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9BD2274215
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 14:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbgIVMbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 08:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726533AbgIVMbH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Sep 2020 08:31:07 -0400
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C37C0613CF
        for <stable@vger.kernel.org>; Tue, 22 Sep 2020 05:31:07 -0700 (PDT)
Received: by mail-vs1-xe41.google.com with SMTP id 5so10168452vsu.5
        for <stable@vger.kernel.org>; Tue, 22 Sep 2020 05:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jAfVW/Ktu2QKoPziUx6oPYo+81bR4uA7dIDWVIcXV5M=;
        b=Mn1spglw5nXsN+c7rr4ZUT9U4x0HXJyri++Ty0zUuupCxiWYu0eobX8wSS4WIU7ZUd
         vwYhQoYjd7L2imjbn5NsY5NltWRqv+6pxoPCE1j/tretZ3Bxkqp+ny0hZBHSqiyMCYok
         svWs/NWfm/OhwUNgVSOYtAVbrrTe/ITEpk/hofEMXx6hpUvGcBIli2SsXbBU25010YFI
         Han3eeqyt0VAXIKE2uR6gy7hS8NK7kHDUY3tnT/GyA/AOoKCA86XOJC8rlAY88cTM0So
         WLGAKkp5LBSPuytLxp3c6EtBkOh1v62ssfm2TQ3Fmu6O9ziWOVkygGzOG3iwPcFVYgyY
         PlwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jAfVW/Ktu2QKoPziUx6oPYo+81bR4uA7dIDWVIcXV5M=;
        b=QzsVvfDcUvvcId6R1hYwVptPJNEDr+LPb2FqcYA7quIjw2/fxjeGjh962xytxmW0Lk
         YB0KkoqB8ZxF0tKU5W9zXN0BdmSaAfv2ceMEAclcnj1We4xg1p/JSw4XtZIAf4ufr4hq
         vVg64Xnf08luOWUX4FmRlDoWiI0c6FvPH1iKGVsr5S7EXs3Zmy6fcWScJiuZBQVmw8p5
         gaA3CGdY1EqoKkEPxb0B/icfL+zM9I141ffbThBj3jhfkUTK0/2o8LWvGbST4pdO4Www
         p2Seo9RpCa1djd11udjfFYDPVPH0deUSpAkO4lXhkxQGqswxzPDbwacDUl4gOw/8mnCm
         WtdA==
X-Gm-Message-State: AOAM53082IPOugl6X9DaoUrAsdzeBmbpwgRTmGf3OsagcNsQM10lG0eF
        IxMdrhDp7bWlCU4gMkYSl3PzVYpLHjypkMr9tyngXA==
X-Google-Smtp-Source: ABdhPJyTgxBZGwxLuNPI/JMKFfvzkoWA/ZbHvmTE12v3q1eO5oAolmulCegwZ2e+/J85HarfVXfbIsP4d8kPVtjKPT8=
X-Received: by 2002:a05:6102:310f:: with SMTP id e15mr728367vsh.39.1600777866703;
 Tue, 22 Sep 2020 05:31:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200921162033.346434578@linuxfoundation.org>
In-Reply-To: <20200921162033.346434578@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 22 Sep 2020 18:00:55 +0530
Message-ID: <CA+G9fYuF1Shea03D2CWb8n4vnS9bZrmk-A7g4rDP9ms=bvUicQ@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/46] 4.4.237-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 21 Sep 2020 at 22:01, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.237 release.
> There are 46 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 23 Sep 2020 16:20:12 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.237-rc1.gz
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

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 4.4.237-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: 546770fa5bddee72c166fb475ba82229a29fbf26
git describe: v4.4.236-47-g546770fa5bdd
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.=
y/build/v4.4.236-47-g546770fa5bdd

No regressions (compared to build v4.4.236)

No fixes (compared to build v4.4.236)

Ran 4796 total tests in the following environments and test suites.

Environments
--------------
- i386
- juno-r2 - arm64
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15 - arm
- x86_64

Test Suites
-----------
* build
* linux-log-parser
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
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
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-tracing-tests
* v4l2-compliance
* ltp-syscalls-tests

Summary
------------------------------------------------------------------------

kernel: 4.4.237-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.237-rc1-hikey-20200921-816
git commit: 2860820c05f32493d650884c2a474a5db5525017
git describe: 4.4.237-rc1-hikey-20200921-816
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.237-rc1-hikey-20200921-816

No regressions (compared to build 4.4.237-rc1-hikey-20200915-814)

No fixes (compared to build 4.4.237-rc1-hikey-20200915-814)

Ran 1834 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* kselftest/drivers
* kselftest/filesystems
* libhugetlbfs
* linux-log-parser
* ltp-commands-tests
* ltp-containers-tests
* ltp-cve-tests
* ltp-dio-tests
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

--=20
Linaro LKFT
https://lkft.linaro.org
