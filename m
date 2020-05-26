Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84D261E1D5B
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 10:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728400AbgEZIb7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 04:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbgEZIb6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 May 2020 04:31:58 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 894B3C03E97E
        for <stable@vger.kernel.org>; Tue, 26 May 2020 01:31:58 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id 202so11829266lfe.5
        for <stable@vger.kernel.org>; Tue, 26 May 2020 01:31:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=jRrdtSugmnzVx4eR9mwVtKt5zC7y5MXJnm8/8ZN1LiU=;
        b=g2rwQIfk3lLEr9j72mjLlozvDLTtiidn8hrHV2+Kod1QkyKaXt63y+D9RRukroe2kV
         lH4nsX61rS83AQx9/36FjpTVk+bYEDoC+kKlWQveXJJLWmmGvEsLP+LAMVugKpQzQeAV
         5idacLy/xkmYtgLews2+MGBVfZ9fWUsYIyrmTMxuod+SSciYFSQJSCdyfrnOj0A01FkW
         qQxPF+MjYxg7L2Rh8c/6xVtpbGSW6RBTh2ZCfLqUOr1YEzx8LruqnOk0YDrNNhPXgQ6W
         tV7Ek+7vjEbEjUuaBlzhIlhcIdmZbQDirM+pdivKd+simf2bYt2c2h1EB7XPsES8rf9g
         E0tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=jRrdtSugmnzVx4eR9mwVtKt5zC7y5MXJnm8/8ZN1LiU=;
        b=VCuM1J7GjC+X6j/OsIcRilMrGahEXGHZjcygfP3fth2NEwwHlNikWutcjfpeeudSVX
         31IRfFDdRx2yB0VDP/bwyUwd9pHwNEHvfjdZyUTdu4GSnCRSFhojUccqNrM/HuDnptkY
         h/PLze2PP+BMzE6uxYukuCzcuGo9UL7+JbLxA8vZDmqBQT0bIsuuHKP79Ork5l74p7BN
         mkum738CLQwyIigzUMAa5i6PM6h+nXPGaUrqwzJB6DyQVkVe3jEuQXjTiAcGOEZ0bq92
         4u0Ziak4KEyADCM2uxqWN2Up9NLlFWu10X6DYCv7mFpmQC0n46gWdEklIpozhIRwZkEy
         TgYA==
X-Gm-Message-State: AOAM5319RzBLtzLnMy4oN0zDQn2ZIw1/Nxc+5RnFlF1jSoLVh2sw276C
        412Irh+SBHMAdmfyrrQ7dOQ0KD7QjPEIhFb4Klj0xw==
X-Google-Smtp-Source: ABdhPJwKoDwj61foY9LxTa9rGHc6n7oNrXLamwNVETrEwDipIGgAqsAEqStEvYezZwarWY17I4qjKMp6wPZZBAsuE8E=
X-Received: by 2002:a05:6512:31c5:: with SMTP id j5mr16597087lfe.26.1590481916878;
 Tue, 26 May 2020 01:31:56 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 26 May 2020 14:01:45 +0530
Message-ID: <CA+G9fYvHgrOTmA4SXNGj2PL=c3PUFs+JoNxz8p95px3TT-UP6w@mail.gmail.com>
Subject: stable-rc 4.19.125-rc1/0708fb235b9c: no regressions found in project
 stable v4.19.y on OE
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux- stable <stable@vger.kernel.org>
Cc:     lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.19.125-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 0708fb235b9c82f3d983e90bdc1a11227512055b
git describe: v4.19.124-77-g0708fb235b9c
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.124-77-g0708fb235b9c

No regressions (compared to build v4.19.124)

No fixes (compared to build v4.19.124)

Ran 29574 total tests in the following environments and test suites.

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
* kselftest/networking
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* v4l2-compliance
* ltp-commands-tests
* ltp-math-tests
* ltp-sched-tests
* network-basic-tests
* ltp-containers-tests
* ltp-fs-tests
* ltp-open-posix-tests
* perf
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-native/networking
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net
* kselftest-vsyscall-mode-none/networking

--
Linaro LKFT
https://lkft.linaro.org
