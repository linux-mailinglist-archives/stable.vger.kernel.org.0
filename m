Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96D3E118F1B
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 18:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbfLJRe3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 12:34:29 -0500
Received: from mail-lf1-f41.google.com ([209.85.167.41]:34329 "EHLO
        mail-lf1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727211AbfLJRe3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 12:34:29 -0500
Received: by mail-lf1-f41.google.com with SMTP id l18so14415337lfc.1
        for <stable@vger.kernel.org>; Tue, 10 Dec 2019 09:34:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=96oNPyBjykShQi/QRMIBERqA/shYenDoxiahWlqs7YA=;
        b=mgUcaNuOuRSRVuSkljYABnLNszgSw9CzqPse6qrwkTSyvDQyyA1w8RiN1jSmkTJ2lq
         3m0FZM2iNoxlbtswTF6eWmt6i/vr8l+vsEU/5b1lc7z3Q9zO0+4SLpQ4oD9kCWTOfcYH
         EZo/FJp5eip/uCJPsvXr8L2rmflwnGxvCFl5G9RxeeeKtSA7HAnOiV+CvreIVt3HyclM
         At6D+qU2L8Rs5J7MHIGw8AghCSHtlM5x3XNvAScMEJFYSIGkN/N4AN3K3F5HWCmAJdIl
         lLRmQuT/ee3RyiJLHUhZKdjLd+kDyys8zRVTgtRkOVC23L4DU4GXpaAPSL1q9yVKE0PW
         jRHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=96oNPyBjykShQi/QRMIBERqA/shYenDoxiahWlqs7YA=;
        b=dbWAiH0NmW/wRnjKVefUtTNsHuObhsjmq9uOz0Z/6TIpstGMAYSNg3cJ1nals+C3sT
         oW/iGlRBp5q7KCLp87s4ZTN8wz4zY9NKahbEILYAy5eDYLeUBl+tns5uGjrm0i1oqsbE
         N//U4Y5y5Yl9H1ML0IFzzRjQE3VihmAyzomebBT5MRn+9WLmtw65kRhy0XLBSe3P6VZz
         RRPo3nFc34ZOh+2CG9CFGP4KJHE9kn8O0sL4x+oFdv7En20gwbdH2lAJ5U9UT4iO9xrg
         eDJwL9GTGsEI4+ASpHxMtLi8Mq5aZWPYPgX/wRJukc/qpmGTFJ1W/7GdIiXg/coGl0e0
         Rc3A==
X-Gm-Message-State: APjAAAU+PXQ/QDmWRG2QY9fUmFi/fiaTYL42H7JJHxYd707Io3769ZdQ
        jRR3dzeQ+CMXmHWbDEIW5iH3EvyWrEgEaMjt4dvDpulNs0g=
X-Google-Smtp-Source: APXvYqy4GnTAflWgvXWrQjcf8yEWqLJG1uNvDcMAY03Timq2O7gROumGKRgO0WRLW/TvGcviVExV+N25J8D2EmmwTOg=
X-Received: by 2002:a05:6512:41b:: with SMTP id u27mr10190207lfk.164.1575999266888;
 Tue, 10 Dec 2019 09:34:26 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 10 Dec 2019 23:04:15 +0530
Message-ID: <CA+G9fYsHZTpzAwAHJLrSya4uB7wnxXo8h5YX=vbbpNx-dMx_Yg@mail.gmail.com>
Subject: linux-stable-rc-4.4.207-rc1
To:     linux- stable <stable@vger.kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
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

kernel: 4.4.207-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: 9628a01d52e119872be61b54259e482df0f865b3
git describe: v4.4.206-69-g9628a01d52e1
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.4-oe/bui=
ld/v4.4.206-69-g9628a01d52e1

No regressions (compared to build v4.4.206)

No fixes (compared to build v4.4.206)

Ran 19883 total tests in the following environments and test suites.

Environments
--------------
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
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* perf
* prep-tm[
* spectre-meltdown-checker-test
* kvm-unit-tests
* v4l2-compliance
* install-android-platform-tools-r2600
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* prep-tmp-disk
* ssuite

Summary
------------------------------------------------------------------------

kernel: 4.4.207-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.207-rc1-hikey-20191209-626
git commit: b22c91580717750df68f854498a0ca3ece8bf41d
git describe: 4.4.207-rc1-hikey-20191209-626
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.207-rc1-hikey-20191209-626

No regressions (compared to build 4.4.207-rc1-hikey-20191209-624)

No fixes (compared to build 4.4.207-rc1-hikey-20191209-624)

Ran 1538 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
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

--=20
Linaro LKFT
https://lkft.linaro.org
