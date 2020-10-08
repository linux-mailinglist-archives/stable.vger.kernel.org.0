Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 390D1287182
	for <lists+stable@lfdr.de>; Thu,  8 Oct 2020 11:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727155AbgJHJam (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Oct 2020 05:30:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbgJHJal (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Oct 2020 05:30:41 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836E7C061755
        for <stable@vger.kernel.org>; Thu,  8 Oct 2020 02:30:41 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id d197so5535783iof.0
        for <stable@vger.kernel.org>; Thu, 08 Oct 2020 02:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=suZfdMqoJnj2WuABCb8SO97Zo5cpvSxtB/2dGxr4rY8=;
        b=eE9ykE208WseMXBb3ZuvlMkTG7nk0TtpGZPHQk+fDiXH9kBNHiOegwipMUw6gnC6gs
         yMo79jpGnU/kxoPIeesJbmZc0KEtc3g0vSXGa3Tjar8KzauYq9j1S3XSMgpEgRr/FBaA
         u+8VMDlOacQEz2qvVdvdbpdgnt3kzMyzGde2eiJpEdTLEDbjyoU5Qut76a8i53mwx58C
         RpfvGeBaCck6UKyQh3t9kCICzIWJn4MVJgsQxSiDjbjUNAdz0OdEm2DFufNI8nEz9Iro
         GYmHAqyym2kNXo5gKpW5mphjtcnetX04bTzPVoy7YYuusTgTL1F5iYL4lS1D+wJOzSiB
         2NtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=suZfdMqoJnj2WuABCb8SO97Zo5cpvSxtB/2dGxr4rY8=;
        b=aZXQbplA+8e4lTr2eM4GXkzGDCd53El6MCaOVqwvU+ztZ6atrCnrSjw6EmCgzAT/Z8
         f3sHo97MTS+kwam1bfa7MUfjPnxJrvEwcYJWjnhaTuo9M/8yp9+MuTpV/KJciA1Z3CU3
         NWuYPOlsUPUaUi0bNo72ep1lhE9VRneF1juH/EoiLmdL+Kbgsb5aOWzN4fBTbh2RrzKr
         +8a0Q7PVYESnC1WQ6826f2g497mVTufI+W4mlhtVMgsc0VmC1K/JBDkl2gWjiBU7wZkY
         ZGV2oZcQgB2QwJnLo0W8Ip3rtM9eJxheTjyxk80DNbmh715Z1P/sH/odT23MgMaStF6Y
         QcGg==
X-Gm-Message-State: AOAM531XILTxeTLSu3ks97Nmq+lIUu+l8yKrZfIp5rZryRfANc5IQBDp
        BPlfS78LdKgIcBDe0gDD6grqz7AcgANStwgT78Ew8WzTO2RfIGS3
X-Google-Smtp-Source: ABdhPJza6GbP9r266UVyA8e8+UqBQ9A7FQld1G3cu4kaznR0cQ358RFv+DGDN2zg4W7BVHtgCrc3526uGpaODGZzVgA=
X-Received: by 2002:a6b:5c06:: with SMTP id z6mr5409317ioh.49.1602149440077;
 Thu, 08 Oct 2020 02:30:40 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 8 Oct 2020 15:00:29 +0530
Message-ID: <CA+G9fYs3Ldt9BmELg7BH0iBEBjWbEnX2obkCiB+f0AaE-6k9TQ@mail.gmail.com>
Subject: stable-rc 4.19.151-rc1/11bdb6b2eb73: no regressions found in project
 linux-stable-rc linux-4.19.y
To:     linux- stable <stable@vger.kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 4.19.151-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 11bdb6b2eb736558e5a82e1fc665bf434e2304ae
git describe: v4.19.150-5-g11bdb6b2eb73
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19=
.y/build/v4.19.150-5-g11bdb6b2eb73

No regressions (compared to build v4.19.149-39-g204463e611dc)

No fixes (compared to build v4.19.149-39-g204463e611dc)

Ran 34762 total tests in the following environments and test suites.

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
* kselftest
* libhugetlbfs
* linux-log-parser
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cve-tests
* ltp-dio-tests
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
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* network-basic-tests
* v4l2-compliance
* ltp-fs-tests
* ltp-open-posix-tests
* ltp-tracing-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
