Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75B77187964
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 06:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725536AbgCQF4M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 01:56:12 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:43161 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbgCQF4M (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 01:56:12 -0400
Received: by mail-lj1-f193.google.com with SMTP id r7so21374614ljp.10
        for <stable@vger.kernel.org>; Mon, 16 Mar 2020 22:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=z7KdungG25b6cEFb1hEFcLQQgC63iFdHfT/PzP4DBrM=;
        b=Dq/sq2/TqohR0bzUxI+b5I68LvpJhrUZC4JbQ7R9yJ7OOUukMjuhxEXPQPRRo1Jj57
         z9HBHH+jMnElSHrzmZQuSjWm7xXEjWV9y/CsCJdQkJDr+UVmoXJspd6WYJVZ/0RaAwGe
         2lwZYM6iAV+lym7V6mBxIeo76ToUMSBhyxtsJWz3y830mFzlSMMl1NfoxSRGIuV4mkTH
         ASZR5OThExiGKKopZRTVqaAfbT3Tn3CO3IwqC24u+1VV5iRJmqsAOMCmyycaZMLWqz9o
         T1khMjDsPwXs67b7fOqNJRs6Lq1xIGbbwOhirX7WThOQNfg9qI9DxC5Lay1rh66r7BO3
         GWYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=z7KdungG25b6cEFb1hEFcLQQgC63iFdHfT/PzP4DBrM=;
        b=UPGNKEglwSz02TMcwLTsIWaiwE1SFRwLZcXE57pC20N6B2Smow8iINYa5YHyW+XaT4
         6pFLxfqRxfSL3xg3i5vuIlXpXGKH1cABnVIAF4KiZTR1XyQ4thzt3rklgQ30Bo2MjxsL
         Md4Zb0eQgqdeZykuKlriKQl0ikNBwuobG2jFHbbuHMbHuLOE692dtucXMTf64chGst0l
         /zAH9ilzZZ4dNDfj9V9idpjB34OnJA8ybYasT7xcW5VRkoqQ/nm6r6TQXbBZL8uVvGiB
         eMNnn74exvr9keK/fkVDg4Ij4TdnCFSu4yUNkfcR9qyxgRpmYUC8+Xm7JgCSXfcBO0yw
         Myag==
X-Gm-Message-State: ANhLgQ1LYSAsXHh51Qv7ihgVkWwczfy9EdwYufApIiwjI1r1U9gpdnZ9
        +s9Z4YOj9wzz1uoCkosTqEqiR1SZzDhZhdRjQCFrcg==
X-Google-Smtp-Source: ADFU+vufCMNdLMYZjEPL5DHufPCl7k7CETiODEL3JDpqQBzTuqjijPGdDILShiu2we8I7bDfnOmHiC4AYdz90yY6Do4=
X-Received: by 2002:a2e:9256:: with SMTP id v22mr1715145ljg.38.1584424569146;
 Mon, 16 Mar 2020 22:56:09 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 17 Mar 2020 11:25:58 +0530
Message-ID: <CA+G9fYuW_2tVWTT9USAJMWOG5G3P_V74jJLkBULHBVNE-SmxBg@mail.gmail.com>
Subject: stable-rc 4.9.217-rc1/ced4535e0b35: no regressions found in project
 stable v4.9.y
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

kernel: 4.9.217-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: ced4535e0b35358ff068ca01ca95d68f8966ad0b
git describe: v4.9.216-51-gced4535e0b35
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/bui=
ld/v4.9.216-51-gced4535e0b35

No regressions (compared to build v4.9.216)

No fixes (compared to build v4.9.216)

Ran 23908 total tests in the following environments and test suites.

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
* kselftest
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
