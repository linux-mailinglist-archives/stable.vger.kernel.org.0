Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81A1C260B80
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 09:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728562AbgIHHE3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 03:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728479AbgIHHE1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 03:04:27 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAFFFC061573
        for <stable@vger.kernel.org>; Tue,  8 Sep 2020 00:04:26 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id c127so2714990vsc.1
        for <stable@vger.kernel.org>; Tue, 08 Sep 2020 00:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=eGfOQ476I9p+L3Ixrk23Gm8Y+HF4DM6ETKqooAthVJo=;
        b=BnLRR/Pz+EwRXT1gcI7C8D0zHAKuwz566xMDH5JajmYWtbFBg6WY6IukygSqcGrcyF
         L4ZlEaI6cR9EBp+vG880J2flXud+tPvHYIFevdA/cSHHceESxcEX0tw3FSvA0i9927Kh
         QLOsNUU+AxfU7WxXpeby8IYBKaxn3AyL7i77qTlegL+fMS44bXza+bU6Mcz+0WwCEIXJ
         GpjicXM0DmTzsXtHNGQr9U+Bp6oQ7f3E6E6zTTA/6wLPVbtNCP35qsPdi5o87RVX6Lz6
         JbXCXAooHrm7SkGoyEpCZ0FPXVpGGGjElkJf6lcqeYJ4MHqri0R2ZiBUAvh4kXWx4qJF
         X9FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=eGfOQ476I9p+L3Ixrk23Gm8Y+HF4DM6ETKqooAthVJo=;
        b=VHL/rGpifKCt2PGMK0JZm9KoRIUMklA+RduOFrERQ4ipsRb09KXr6MU9lgYTzJgu4Y
         oLr0R4OXae5p+oEIqZgM0LZZlKwaGSnHnWdIEegsxBw54e4rOSddLKRUc54W9OKEVYGL
         yD0AI4wF/GYFiAaWvT85T2S3ylRsJWGInZxkRegPlNO7OjlZ4XnahuZzCrp+YsOOcVUA
         FC/4JgDhwKuf6yH23QBH3QBPOVysdyVHmB3ET7OKzvfZSz+gFhU0g0bDu7wxJiPWq21q
         hpZs2k91tiPw0T7XMP4WhaKriBkGikNp1F7e3o5PCuYsdTtD/jdM/juv2FGwIHHiVEK1
         FQEw==
X-Gm-Message-State: AOAM530M0taeTKUcxSYAUMbAs2hSbEGE/bCWfdGmMU+CCCYIWMLDIIJm
        OJxkD0HS+WRragnRB5VoS/kXveKV7uW7luQgcT0Y+/IOV4BLXnY+
X-Google-Smtp-Source: ABdhPJz6/1Oq8RY/RK/hEzLPDLHlCEhft69z65hSJUv1OXH+iYJ6qhJwu67Ay77/Fb09n/CYxuRURLV0KBgF6ijCxPQ=
X-Received: by 2002:a67:7c17:: with SMTP id x23mr15193355vsc.166.1599548663795;
 Tue, 08 Sep 2020 00:04:23 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 8 Sep 2020 12:34:12 +0530
Message-ID: <CA+G9fYtTGyp=1-1xHeW+b0FnbnvXBRfeYdFx2PWB19RS4MBKnw@mail.gmail.com>
Subject: stable-rc 5.8.8-rc1/445a0c3807cd: no regressions found in project
 stable v5.8.y
To:     linux- stable <stable@vger.kernel.org>
Cc:     lkft-triage@lists.linaro.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 5.8.8-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.8.y
git commit: 445a0c3807cd9a25d19c547f1ccf33bac210adf9
git describe: v5.8.7-133-g445a0c3807cd
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.8-oe/bui=
ld/v5.8.7-133-g445a0c3807cd

No regressions (compared to build v5.8.7)


No fixes (compared to build v5.8.7)


Ran 39133 total tests in the following environments and test suites.

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
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* linux-log-parser
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* perf
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-fs-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* v4l2-compliance
* ltp-open-posix-tests
* ltp-sched-tests
* ltp-tracing-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
