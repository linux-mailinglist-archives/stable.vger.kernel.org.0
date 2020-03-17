Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2567187969
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 06:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725769AbgCQF7f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 01:59:35 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:45949 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgCQF7f (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 01:59:35 -0400
Received: by mail-lf1-f67.google.com with SMTP id b13so16096665lfb.12
        for <stable@vger.kernel.org>; Mon, 16 Mar 2020 22:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=TlqpLTYdNI8Dj8G25cVMT4SK582VJgPyZT+jwMttx4s=;
        b=rYRD8PAdIY5aP7VdrMfdNrCTlNoc7HPa6JOaEcQYj7zqzbCVH5QfKvxemizHlN7QiN
         wyGtygD+jWAEq8SxjLhETn4vbWeQXno80BEveTAFR1iNAWNJJuuizsEWz5eLGtbAxjUC
         MX5xnA0Qx2zCvXioeau3PUJNYSuiGSy/xfat5q8tPi/qZyuKbXUG6kD70oNMu+NqDqQu
         2S+xUPdcqEiZ8AIOdbq8t0pRhbMKBuj0zikiuEE7ZoqkxmmvtnsHQL/mCfg9gMr2NeYC
         1oU6PYGC4kWpr99abD71w8gyGj1hkzWsaksy+mWiTVVLw2mO6XN4iTNMPf9zGP8pdI6V
         6LIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=TlqpLTYdNI8Dj8G25cVMT4SK582VJgPyZT+jwMttx4s=;
        b=YYNV2ZSu87VTE6u6LhFI5F2bmO8JQrGhfdSozJFWkRJNu6koEcZ0dD9f6zzLbMIZMr
         AhVCMG6mqBg2zz0W+HUkOyt/1jaqiu6rW2YJWSDxliCCeAF0als+Nith2VAUC5KM8Vg8
         QlZBNgA2dwOXgOqmXU6SuW8HNh3GU8P2I1QgF9G5N31AuBudz99ow2x4JUesrLWLyo3o
         pLOoExE5ae5vCHE9jI2ZO4nU4W/g8MsMB5+zgwdY1XkTxGbdrdoSMC9g9aGB00x4fn+B
         XUSXbqK7GmboYU2qleoOfYpkS0JDO6opeoOgTdQBiFptme570VS6o59DmmZ73BcHYbyP
         FboA==
X-Gm-Message-State: ANhLgQ3j4eDiukO7vDJpvSvr5aDn1ZF9DHcuvqlJuQVC/gJoReTqro0m
        B9PsFt9ZPEEAihzhDMUY3PeHM01SvSy+Xm53nEx7qg==
X-Google-Smtp-Source: ADFU+vtvYtJTS7S867tfqXzYlQjdw8TqzjJxyireOYsB4hUXp4jktVH3sf3T4/V8p04aqgQjJqpQRxfclWaYKbeuLh0=
X-Received: by 2002:a05:6512:308d:: with SMTP id z13mr1764994lfd.74.1584424772282;
 Mon, 16 Mar 2020 22:59:32 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 17 Mar 2020 11:29:21 +0530
Message-ID: <CA+G9fYtdNLUb-gy61GcV=L9yu0fXV0HctG_irXuf0bsbRz6z0g@mail.gmail.com>
Subject: stable-rc 4.14.174-rc1/d37b117e1ccf: no regressions found in project
 stable v4.14.y
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

kernel: 4.14.174-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: d37b117e1ccfcc2bf0ed4224f8f6d3ac6dd4ad65
git describe: v4.14.173-67-gd37b117e1ccf
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.173-67-gd37b117e1ccf

No regressions (compared to build v4.14.173)

No fixes (compared to build v4.14.173)

Ran 25828 total tests in the following environments and test suites.

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
* install-android-platform-tools-r2800
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
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
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* perf
* v4l2-compliance
* kselftest
* ltp-commands-tests
* ltp-containers-tests
* ltp-math-tests
* network-basic-tests
* spectre-meltdown-checker-test
* kvm-unit-tests
* ltp-cap_bounds-64k-page_size-tests
* ltp-cap_bounds-kasan-tests
* ltp-commands-64k-page_size-tests
* ltp-commands-kasan-tests
* ltp-containers-64k-page_size-tests
* ltp-containers-kasan-tests
* ltp-cpuhotplug-64k-page_size-tests
* ltp-cpuhotplug-kasan-tests
* ltp-crypto-64k-page_size-tests
* ltp-crypto-kasan-tests
* ltp-cve-64k-page_size-tests
* ltp-cve-kasan-tests
* ltp-dio-64k-page_size-tests
* ltp-dio-kasan-tests
* ltp-fcntl-locktests-64k-page_size-tests
* ltp-fcntl-locktests-kasan-tests
* ltp-filecaps-64k-page_size-tests
* ltp-filecaps-kasan-tests
* ltp-fs-64k-page_size-tests
* ltp-fs-kasan-tests
* ltp-fs_bind-64k-page_size-tests
* ltp-fs_bind-kasan-tests
* ltp-fs_perms_simple-64k-page_size-tests
* ltp-fs_perms_simple-kasan-tests
* ltp-fsx-64k-page_size-tests
* ltp-fsx-kasan-tests
* ltp-hugetlb-64k-page_size-tests
* ltp-hugetlb-kasan-tests
* ltp-io-64k-page_size-tests
* ltp-io-kasan-tests
* ltp-ipc-64k-page_size-tests
* ltp-ipc-kasan-tests
* ltp-math-64k-page_size-tests
* ltp-math-kasan-tests
* ltp-mm-64k-page_size-tests
* ltp-mm-kasan-tests
* ltp-nptl-64k-page_size-tests
* ltp-nptl-kasan-tests
* ltp-pty-64k-page_size-tests
* ltp-pty-kasan-tests
* ltp-sched-64k-page_size-tests
* ltp-sched-kasan-tests
* ltp-securebits-64k-page_size-tests
* ltp-securebits-kasan-tests
* ltp-syscalls-64k-page_size-tests
* ltp-syscalls-compat-tests
* ltp-syscalls-kasan-tests
* ltp-open-posix-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
