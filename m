Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B551D156563
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 17:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727379AbgBHQOM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 11:14:12 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:42247 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727341AbgBHQOM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 11:14:12 -0500
Received: by mail-lj1-f196.google.com with SMTP id d10so2476177ljl.9
        for <stable@vger.kernel.org>; Sat, 08 Feb 2020 08:14:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=tkNKsPzI2ApTa2N89zYJjK2iy9hlvkF4mGPJ4V+Jodg=;
        b=BT/NluUsQx948GFWV7ppAYqFIeoDYQNZF2faV8ZPHKCXipDILwNDrVq9bNjIjeJwfJ
         Wmc+ihURdNWhF+qQ6IYqs3Iff+93lc+c/oKqJ7HSrt8MtBITyabsdAExYze6Zqx4wfJ3
         lbdbYaoLTG3d7aklQObG+i6RlDrcXusbZBHj9GvRzmPF9N3UshnxOu/7mNegKhD8JhWU
         g8ENZ1yc2KgpAoYm8DQIaSFdAZsyNaes+snufUjrjaOdy2KjLvdgN5yBUIr3WyGZcD3y
         +3KTlnHJZP/E0M9ROKp+82y5hM06F18DQZQiRX/7Sbl7bfXP44XiyX9CcLwqr557unnP
         9qgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=tkNKsPzI2ApTa2N89zYJjK2iy9hlvkF4mGPJ4V+Jodg=;
        b=pUjMF5b104n2Zw6yWkpEKOca16JQfNxQzwdPYHYK+UNLKe7DwyJcg2fuDC9WAfS+3e
         INjxKPRMmbo2NpoAUKlQEIizxLu0Le7pj3k7Zwl6yGDLdxCJhowGADY3QleH6MqXdcPO
         nCFGJPDkuKH46fK3DR7w/gAIueAs+pTKKkMvh0Lk1tAT6Rb/ISLxLCHDrN8vEEIvHGAf
         QTbhhESgj+q+tBt8/wCxmE8V4wrWcmB432/2A4v3WtKqIldbaQI6NfxaOZIgSMHSAFNy
         O3Q+sz5PEdJ/GiMJGL8THscM43zMs0/K6SSLKQbpuziTIvoH7DbELlP6qpG/n5s28tmb
         R5Dg==
X-Gm-Message-State: APjAAAXmiKs1Rvi6Sgg/FxPBfd3RbzvSh4h0i7zotNf0hkDLOeNTjGgv
        +m2EJerXq0BkaVFcjpnGcyw/JUojsTnqGhWP3ZfmZw==
X-Google-Smtp-Source: APXvYqzJcrEl0sqzIO3TPRgP5uLRAlkN0tkZEuDPSaSGnvA+gUxCkqam5w1kWa6ok1eMTwmFa5/BKLdp6eZMczuPeVg=
X-Received: by 2002:a2e:9e55:: with SMTP id g21mr3057874ljk.245.1581178449777;
 Sat, 08 Feb 2020 08:14:09 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 8 Feb 2020 21:43:58 +0530
Message-ID: <CA+G9fYtgj7pXar1=k1gFAABq1n1Vwqc99VMh8F192mjPwr_xTg@mail.gmail.com>
Subject: stable-rc 4.14.171-rc1/d6856e4a2c23: no regressions found in project
 stable v4.14.y on OE
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

kernel: 4.14.171-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: d6856e4a2c23a709eb0143be5096d095b814c594
git describe: v4.14.170-62-gd6856e4a2c23
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.170-62-gd6856e4a2c23

No regressions (compared to build v4.14.170)

No fixes (compared to build v4.14.170)

Ran 22503 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- nxp-ls2088
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
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
