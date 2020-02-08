Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3C9156591
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 17:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727377AbgBHQyJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 11:54:09 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:34144 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727341AbgBHQyJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 11:54:09 -0500
Received: by mail-lf1-f66.google.com with SMTP id l18so1391219lfc.1
        for <stable@vger.kernel.org>; Sat, 08 Feb 2020 08:54:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=eQ7oKb6TpvjgFiqtTY7WHz6x2fb9C5WlZvZdO7sZkfs=;
        b=Howf4nrToxlrtC36k6DglIfaD7B3dBzKSJgUTAVf/uNl7uBvW7Dz+5gzB7jAcZxaxH
         ojJY3RO2bzwhMKVQYRZCYUUhb5kJacvtXeiEV3aI6uRTg94yZEct1daywfKU0hZaAiJ4
         DtP2qN23Sws4QUp4O4EUdXZzHLFGko+jhM84C3bfhZeStwoV5ag31da07aXaRwKO8YuL
         TdaDL3ENiUZslxJoBguqsBN3sQYl0xJG9EXyVaudMhdSIiu9VfWEoOfbfZRTfCEXDp3k
         8HLVxkSCibDj1HNEDk5EBWSnFGmkqLH+y4E7X2aCGNHg9HIizj93ROR2fyc2QtmlolRp
         eycA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=eQ7oKb6TpvjgFiqtTY7WHz6x2fb9C5WlZvZdO7sZkfs=;
        b=LHNIxkpjoPwnQZE1Gzx1R5+y0rmak1t2wFfqloRKZYP2znnbPZVE1UgL6pRzDqOxUc
         Seb0BUSa4GgpXd54/jv2Yt/YAFkm8u1uCMNsF1Q992Xq6JHlb9QC2s2dyF0qtZ16pDfa
         pcEVunp+KZHQ1slvyTuOV9e4WWmmM/s7WVFRvEr9xoBZsTGWvvrby4UfP6j3eYbqpYK5
         HDox3ZMSkRe+koRc3jJ3kMI2CZ1roYDGdY2NfR8GYYsR5QHkGlzwsjfTnTAFpD7Hy1/J
         FZ+QgJv44ECiyqAZpXtRQZfNxvdVVkqAh+atz49IvDdvJPcqnz61bJ5m+SYKB9KbamZ3
         ygjA==
X-Gm-Message-State: APjAAAV7fpLu2ildRzBRfnQKq+UPOFuOt68sSBnaktUC5wHnm7Ekr3mO
        FdDYt5L9DnzWbiphMkFc5828XX4q1CpTHmPn14o0lQ==
X-Google-Smtp-Source: APXvYqw1Su7bAwXoAX4awf6cnClHkBbO1iackq5hAbRng7NNazHDMD08uheEzb/xFS7tzswYMa5vO2ztZ7l2MB0/UBY=
X-Received: by 2002:a19:6d13:: with SMTP id i19mr2232133lfc.6.1581180848020;
 Sat, 08 Feb 2020 08:54:08 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 8 Feb 2020 22:23:56 +0530
Message-ID: <CA+G9fYvPke-mkuYhy7EZfqcNs5VXoAOW3VVjDt3DXpH0Eh=NeQ@mail.gmail.com>
Subject: stable-rc 4.4.214-rc1/a3b43e6eae91: no regressions found in project
 stable v4.4.y on OE
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

kernel: 4.4.214-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: a3b43e6eae916827423cc6389b593b3532e1f372
git describe: v4.4.213-28-ga3b43e6eae91
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.4-oe/bui=
ld/v4.4.213-28-ga3b43e6eae91

No regressions (compared to build v4.4.213)

No fixes (compared to build v4.4.213)

Ran 10202 total tests in the following environments and test suites.

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
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* network-basic-tests
* kvm-unit-tests
* ltp-cve-tests
* ltp-fs-tests
* ltp-nptl-tests
* ltp-open-posix-tests
* ltp-syscalls-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* install-android-platform-tools-r2600

Summary
------------------------------------------------------------------------

kernel: 4.4.208-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.208-rc1-hikey-20200101-645
git commit: 45aaddb4efb9c8a83ada6caeb9594f7fc5130ec3
git describe: 4.4.208-rc1-hikey-20200101-645
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.208-rc1-hikey-20200101-645


No regressions (compared to build 4.4.208-rc1-hikey-20200101-644)


No fixes (compared to build 4.4.208-rc1-hikey-20200101-644)

Ran 1568 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64

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

--=20
Linaro LKFT
https://lkft.linaro.org
