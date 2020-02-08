Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD52156587
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 17:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727379AbgBHQkM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 11:40:12 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:45961 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727350AbgBHQkM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 11:40:12 -0500
Received: by mail-lj1-f196.google.com with SMTP id f25so2495790ljg.12
        for <stable@vger.kernel.org>; Sat, 08 Feb 2020 08:40:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=/1dbIafJ9xXcyxwwFqHYVmT0Qahcfc7VqBJxo1b/E8A=;
        b=i4mnc5QEkabHLfZUTyDDI+ENI48wgMUgIDolfvOx/BEXLkBKePl/AwFsUNuJz3Do1m
         Sp2Ee7tq97Lj3e9hBS+FJ0vGB8nf2sc6eTCq+3UYTYlbQuqxcJwHUeFHX1gbGPQNC+Hx
         Mmp3N/MsAYIbujKI+8sCEGudZfPdi/Bh5l9lYaS5KOP5KL/3VwYd8X3EbuCpKv0CLACS
         kcSXpyfDaEnLsjoNPEzj1iYLPKNU+eu1TxsVtbNBSw7f+X/w/ZeESGBNGR5z6ybjh3gZ
         bGkcYvdUme2XLN4bAjqj9vQsIusU1fXsFgePZu9JDFCzZ4rEPOtW7f0gm2oGMV8jm30y
         M++Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=/1dbIafJ9xXcyxwwFqHYVmT0Qahcfc7VqBJxo1b/E8A=;
        b=WJwGSf3B85+XpyDYP+L0fSKzlPup4caFdszZ+9dJk0Xg3G9NkwM2FRo0xQWbf/6Iau
         Dtz6SQbtULSQFiANjQGnC0l7I90hs2z3lp1oA92xm9qncNxaDwUIixCbmeimsXwQle/U
         5QhAi30k8WLT6mMjrE3MVhyM0mSjA0vxvdMxobCzP1uJFys3e5V1d24g1cki+PvL/1EY
         OcxvFONEbbmMsuB41UdvW/Dg4X0SnVz6azSc6MhZiF1o9pf7M24aH2zK+Uh+es29Nkd2
         Q4mVME4nO7/OivH7cSc5u0LsxfEvhFHPIOLsnoTqrcPbjWURPkpwMhaW0ChM2kXEf5g5
         yAoA==
X-Gm-Message-State: APjAAAXs0dxDUyuQQCW8JAltbXA8iVTYyQufmeUwy6fQMLwI3etmrreG
        Mjq8011rT8u4B7BXF5ix+TMCqMQBEIrkxEWtlRrTwx35ywU=
X-Google-Smtp-Source: APXvYqzTkvlFnIGZTOdkF+yWfsV2zbZlvB2xr4HW7nznpBjK27bJRz4uoB8DpxlbPibbbYuQD4EsgqV0w7fG2yruqSs=
X-Received: by 2002:a05:651c:414:: with SMTP id 20mr2913701lja.165.1581180010094;
 Sat, 08 Feb 2020 08:40:10 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 8 Feb 2020 22:09:57 +0530
Message-ID: <CA+G9fYvug2B-rQxWYxmU0R+0=Hu+fy93=gyK249AbQTzvCkZkQ@mail.gmail.com>
Subject: stable-rc 4.9.214-rc1/860ec95da9ad: no regressions found in project
 stable v4.9.y on OE
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     linux- stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org
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

kernel: 4.9.214-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: 860ec95da9ada58204579ee8bba33b5f317476e3
git describe: v4.9.213-37-g860ec95da9ad
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/bui=
ld/v4.9.213-37-g860ec95da9ad

No regressions (compared to build v4.9.213)

No fixes (compared to build v4.9.213)

Ran 23593 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15 - arm
- x86_64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
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
* spectre-meltdown-checker-test
* v4l2-compliance
* network-basic-tests
* ltp-open-posix-tests
* prep-tm[
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
