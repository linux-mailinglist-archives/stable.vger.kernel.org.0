Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5C1C1D0E77
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387711AbgEMJvv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387708AbgEMJvu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 05:51:50 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C679DC061A0C
        for <stable@vger.kernel.org>; Wed, 13 May 2020 02:51:49 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id u15so17069930ljd.3
        for <stable@vger.kernel.org>; Wed, 13 May 2020 02:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=v/hRPGSq+bxa+Q+TzEJUb+dUDnWb/ydhRiXMT/AcNOI=;
        b=ZPMM/B9P+Bpf5SVLNYqfokquDQ91Z7N0GqGGNtacBG9sboiJf5EK1RcrQE2zjI7jMx
         wAbbBABXF7d/MAcwwu2p5n0O1KFSKu2TdZMhHdlbsFXJhgxtuZQeOk5Ofs3OQqpxwbwp
         Q517krnAmo2upraZVyViwfCCFBfKiZw/7ZE0UEb/KnKzg7dFfF1XD7AfI+YHOIJbgAI7
         kCXZhKxrtcBakCjmL7OX6bfy3vhqtPUrArDdxNMsyQ9+W/6JbZ72/UaulNkVltCsvUWq
         E6jverH4zidhLMbGVvkwXyt17tYVmG8bO4TEaYxfleqjXe8e8FJYAZ/l4giHMpoP1r1L
         ixww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=v/hRPGSq+bxa+Q+TzEJUb+dUDnWb/ydhRiXMT/AcNOI=;
        b=hI0sphEGZ3sJF0DEsh44dmK9DoN/WF7lKPL+Vr5SYHGGWnhVo+UeOKM6Qz2ZLFIwpv
         1cKk8HE6jY703W9MFn5s9vIXeMw4il0HDGHwQi24lhZeJwlNiDeddATJziyGnjN80DKv
         V4FwjtIyQzil47ZioRk/hoYJokRRPmTNjOXS18czAMU02eOooyjYBvVNm95hgX7zdvws
         OT/0mYBgV+FJieFecaOpl+YcvG89FCG0XPKg/u6yH06zxSKG/18c1qvIwt1V/cJN9vBt
         VtXCzJZSvdap1TEL914KVMDyVVNdsOvOxhPDDivErUmH9vJQ1TfE1OShdgtgx1nuxV12
         3yQQ==
X-Gm-Message-State: AOAM5306et1Cec6d64DmGULOxSjwsMdHVYpE6AivFieduWQFr9qnkZpx
        W20Am/qGN/j+YFg82FnlyyGXkmwn/m2v6omY89eadNFLbk4Gmg==
X-Google-Smtp-Source: ABdhPJy2iGPRarsjL/HWpQUuP4ZZnl1ZwwZeQCzlZes0Yw/u3lUrW7PCZlQvehA7Blx4fUiTqNbnTAZsAJ6m62s8rLQ=
X-Received: by 2002:a05:651c:1a5:: with SMTP id c5mr5504337ljn.217.1589363507341;
 Wed, 13 May 2020 02:51:47 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 13 May 2020 15:21:35 +0530
Message-ID: <CA+G9fYuXFdWc_dm1iLvS1zkCQS216xgL7oY7D=9QXwQxVefHNw@mail.gmail.com>
Subject: stable-rc 4.14.181-rc1/ad4fc99d1989: no regressions found in project
 stable v4.14.y
To:     linux- stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     lkft-triage@lists.linaro.org,
        open list <linux-kernel@vger.kernel.org>
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

kernel: 4.14.181-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: ad4fc99d19898b966c3fa74c7adaaee8d12da3a9
git describe: v4.14.180-37-gad4fc99d1989
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.180-37-gad4fc99d1989

No regressions (compared to build v4.14.180)

No fixes (compared to build v4.14.180)

Ran 30937 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
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
* ltp-commands-tests
* ltp-containers-tests
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
* ltp-syscalls-tests
* perf
* v4l2-compliance
* kvm-unit-tests
* network-basic-tests
* ltp-open-posix-tests
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

--=20
Linaro LKFT
https://lkft.linaro.org
