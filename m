Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D486220ED91
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 07:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729605AbgF3FaK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 01:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729135AbgF3FaJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 01:30:09 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD93C061755
        for <stable@vger.kernel.org>; Mon, 29 Jun 2020 22:30:09 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id d21so10582671lfb.6
        for <stable@vger.kernel.org>; Mon, 29 Jun 2020 22:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3P8VUSu2WiBr/qurMEzeXbZq0zeTuLHcyP6ucJPYd6E=;
        b=KFBU7HbFRHHS7+jxRqmGKQV+qRgOThL5SH5fGqhFbjKv/9vX9b8eAczZudaVHlYhQ/
         IuC1lYNU4r4JkBgET/q7d69WsICfDi8HttL82neHPwBHfFOmpMkzqI/92aKLTDCz/aaW
         VkC58YgDrT2QGCgatw64M6UTQXQ58gQyvTvcX+bzxNNYfKaHqHe7AEr3G1vs4BopFyd8
         snDxPEf+VESX7jLr8qeZXJd+L8A10ocr7CnLBHaH/9mcwLnZOL5T1qMQbVFCTPWHLR+c
         FY6gcrQuqhnqOKJr2/vinKA7xmFMW0CUl/2awX4dg50NEfTTmVapqj8TbbYTX7LCw2OO
         fqhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3P8VUSu2WiBr/qurMEzeXbZq0zeTuLHcyP6ucJPYd6E=;
        b=ZRWqgXYnXbU1sID29IMuCnp1xUnckUn8bcx3cfr/RgPzER3bzL6Ra221/CYgJzPR1U
         xSXbjCF1iQSY+VMpwirwWcNdD0GqBWRkMFjufUoaAdkDVFtC5QGr7uFGN2mQssmrTrsT
         K+gTBkH7p1MciJ6+9zZypnovRnzmtv3wBfimyZ83B87npcYGJLfpO+n6UPlIO40ortQT
         gtY7lWTAyldQIMjN3Nqxxkb6Ylm49iNcoQAGvvsMuVv5TUCcKhq2BjyHGTvYleiuFIGB
         mVuXh5pLZ51E2bFEfdQ7URJrGr6LMra4V+dQ2uURewEVWBQ0paqy/q3yIbYalpFSiUWQ
         SM6A==
X-Gm-Message-State: AOAM533HiMwR/jps90xeMDSTM2JBQdjRdXh9NTaBe7BYC/Jv1L42kCJ9
        2r24xA+14krIB5vf1y1bNIgz3TnNgZjHx6ytC9CGhg==
X-Google-Smtp-Source: ABdhPJzGQ6CtCkkYa1MWFgqN7pGAUutX3h5uR3FYzqqdqLZSOWFYzGGeCkjuy230N3ijOzjhlvQS8aMU4vzzemsXvYA=
X-Received: by 2002:a05:6512:74f:: with SMTP id c15mr424383lfs.26.1593495007724;
 Mon, 29 Jun 2020 22:30:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200629153502.2494656-1-sashal@kernel.org>
In-Reply-To: <20200629153502.2494656-1-sashal@kernel.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 30 Jun 2020 10:59:56 +0530
Message-ID: <CA+G9fYu21wswh1Db2pqxNT+mE_BVQZtejPHp7pA2+dzAOs5rxQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/131] 4.19.131-rc1 review
To:     Sasha Levin <sashal@kernel.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 29 Jun 2020 at 21:05, Sasha Levin <sashal@kernel.org> wrote:
>
>
> This is the start of the stable review cycle for the 4.19.131 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed 01 Jul 2020 03:34:57 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git/patch/?id=3Dlinux-4.19.y&id2=3Dv4.19.130
>
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> --
> Thanks,
> Sasha

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.19.131-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: d77d34fc48184da0390d7f79bdc17f44c512c458
git describe: v4.19.130-131-gd77d34fc4818
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.130-131-gd77d34fc4818


No regressions (compared to build v4.19.130)

No fixes (compared to build v4.19.130)

Ran 34302 total tests in the following environments and test suites.

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
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* v4l2-compliance
* kvm-unit-tests
* ltp-controllers-tests
* ltp-dio-tests
* ltp-fs-tests
* ltp-io-tests
* network-basic-tests
* perf
* ltp-open-posix-tests
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
