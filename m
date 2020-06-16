Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4304A1FAD9F
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 12:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgFPKNC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 06:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726052AbgFPKNB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jun 2020 06:13:01 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F47C08C5C2
        for <stable@vger.kernel.org>; Tue, 16 Jun 2020 03:12:58 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id c11so1030298lfh.8
        for <stable@vger.kernel.org>; Tue, 16 Jun 2020 03:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=N2UU6mSIUtwUF7l3xZ1ma+9RrZHeiJ1HsiEUEqskAbw=;
        b=h4KbNy8l70mf3oJSns6TIrA1FXAK1pZcHFpLDP/6tecXP50W3C5udkRFRoUPCic5rc
         T4cvGAE7SKrpdShhWeu7BlyHJYgSj9NrwuLTCSYLIcX/Rxdaxtn5SZPefDT/fxmZlMi7
         cP3I4Latf1PlMkAHTcpWyLyiUe8iLzyJzOvBrtQ6+8csaH/LFA9A/hBXGAc4qHkBuKDa
         R1T7VV2F9FK8et8Z3jtCHy7j9SrHKbaARqf1AyVk3vt2VqomAw36YEII5UsRVrBsvI8f
         EhApMU/Vn67zSq0JMq8/yZ2DiVAm68UKOSXtp5Bh0swoc45cVXsfTPe1WPEoLhalux+P
         Z+MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=N2UU6mSIUtwUF7l3xZ1ma+9RrZHeiJ1HsiEUEqskAbw=;
        b=J8pYbajEb5z9J9dzWu2BT/QTrG8nFCSVVdfrW2SOMMwH0SDks6JIpfQH+XvxT5C0Fq
         KRQcTjrvOQW5JKRmKa8G2DHLpoHc0/NkCWe1KtxgiAlLbd5hNIjfSZ+F/Da3hWhU5GOD
         5KBuPaXjx/chqF4DtlWsLFVWLxnlpBPBtRdO41T8QEptg32U4E6fkyDK0DZ65mWId7jx
         qSsYrAW0yyazBgyPe5dF4JvW8UrFAiLjKl5/vPgxaNPBG3mA9/eA++WfVOqP0QsZszud
         VdRf6dQmSOMcVwlokq68NV2Uo4BHUPRUFyh6pSmGhKIX+LYebv0MHAgaNvUquG+ZD0DG
         UCmw==
X-Gm-Message-State: AOAM533qZDaf+PeAwLxqR1WPqIP1R32jKq9ww1b89Fi5lkmK2g71JYCd
        Qio5M33FX5cEGwQV9mJuTkmPQ2sLzIwQ1/0kBeUzEKK4ekbKrA==
X-Google-Smtp-Source: ABdhPJwbgdLNO1ugQED8tvj0senGWJinPV9FR6swA3dE2YoDbACfqsYeANgl+m3WpWGgOjxPktqdoyV5q6buxDaPafQ=
X-Received: by 2002:a19:2292:: with SMTP id i140mr1303810lfi.95.1592302376561;
 Tue, 16 Jun 2020 03:12:56 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 16 Jun 2020 15:42:45 +0530
Message-ID: <CA+G9fYs7xZBV5JdibqXPvc6+ynuUA4Lo4WLtsSDKF2PJjth+ng@mail.gmail.com>
Subject: stable-rc 4.19.129-rc1/d694d4388e88: no regressions found in project
 stable v4.19.y
To:     linux- stable <stable@vger.kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, lkft-triage@lists.linaro.org
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

kernel: 4.19.129-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: d694d4388e889e15298d8de938fb4e61e4df75bf
git describe: v4.19.128-58-gd694d4388e88
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.128-58-gd694d4388e88

No regressions (compared to build v4.19.127-26-gf6c346f2d42d)

No fixes (compared to build v4.19.127-26-gf6c346f2d42d)

Ran 33239 total tests in the following environments and test suites.

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
* install-android-platform-tools-r2800
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fs-tests
* ltp-io-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* v4l2-compliance
* install-android-platform-tools-r2600
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kvm-unit-tests
* libhugetlbfs
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-mm-tests
* network-basic-tests
* perf
* kselftest/net
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
