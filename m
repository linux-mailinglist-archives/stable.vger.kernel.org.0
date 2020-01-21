Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5171435C7
	for <lists+stable@lfdr.de>; Tue, 21 Jan 2020 03:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbgAUCwA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 21:52:00 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:39271 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726890AbgAUCwA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jan 2020 21:52:00 -0500
Received: by mail-lj1-f194.google.com with SMTP id o11so814276ljc.6
        for <stable@vger.kernel.org>; Mon, 20 Jan 2020 18:51:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=nFOvk76Cw+NIv+8TXVWZvBTpJ4GDUI4Pt9l+/aGsTXE=;
        b=ybmNkcJ6WP6IYTqcz/Gun2OuZVOy+InfXfGPYyVGdvg+1ZqKJZm+rOHgyPCdTjCmqe
         fl9fPjqfGjiLlkXCIxE6AR5kQjpMUr4Gavz8WS1/RRYkYNtrHVhwJQIQhgjZMxz9WSq/
         kPnIjCH3GULPLgg+tDiiPzjlaKFkbRWVrTtZE6QtTmeQ+58WqewYEYYcKkJeEjvlbtRp
         CUjJncJoP1IYeAvAj7o5eKitKzh5FPULs8pgwKvkoqN5cIwh9uTtqV6bQrlYnyP0gAdr
         fm8KgH48PzhWzG54WKujMDXxJuFlbMwUpke2kty706yQ3y4r+JVxwSvJAOjSHZO2FapZ
         KZoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=nFOvk76Cw+NIv+8TXVWZvBTpJ4GDUI4Pt9l+/aGsTXE=;
        b=CJSsdoz0QwBivSRjjavTABXUzdSGXiHfwBHsOwqy5g8KF50yRfrtkhH74XUojR5Yq6
         TQkCNOT2+yoJfdojimPCx+zt92vqbSCvA/eXoHWjwV3UfX3mMWn6/5hQ9agxc1M04qaA
         kICAV/0CuHLWn/0CTrmxawjb5ibwxRw2KCTx3jzBXeQJudElhGVxMJ3dn8luJCxZAlvP
         j6ZBsN6U8q3rmxT3/Pq7oDwhmAB000xFLKZo2FtKe87cDej4aWJDz17wGb5G3hZqAug/
         nV4egpcR12SbQ7gSA2zYtr7HIxLChDj2qWhLZG/ht1pyVtk46UYDD09hRQP9pevo2jmH
         lqew==
X-Gm-Message-State: APjAAAWLlrbm8XHQdM5qO4iPzfTm12nN+9el9Ewy4lPPq0kNsOdbe5ln
        TkA4jiVwNPr9IObVFLhgBMndJ4sDPdyvxYgN5EP5zg==
X-Google-Smtp-Source: APXvYqzVShI1pfKmzeWo5oSnxb5plZ7R8D+uB3ZGvqgOKe/U42IlPPXLRL/VFVLyPQxATys7D3g5jilkZR1PkaqREB0=
X-Received: by 2002:a2e:3504:: with SMTP id z4mr15371024ljz.273.1579575118150;
 Mon, 20 Jan 2020 18:51:58 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 21 Jan 2020 08:21:47 +0530
Message-ID: <CA+G9fYvdPeR9__o6FfexSyoyAw0Yycbh_tZjhxnKSW2nEvm41Q@mail.gmail.com>
Subject: stable-rc 4.4.211-rc1/97203d960bdb: no regressions found in project
 stable v4.4.y
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

kernel: 4.4.211-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: 97203d960bdb2102d5358b0d18b25fb1f2f74345
git describe: v4.4.210-63-g97203d960bdb
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.4-oe/bui=
ld/v4.4.210-63-g97203d960bdb

No regressions (compared to build v4.4.210)

No fixes (compared to build v4.4.210)

Ran 19786 total tests in the following environments and test suites.

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
* prep-tmp-disk
* spectre-meltdown-checker-test
* kvm-unit-tests
* v4l2-compliance
* install-android-platform-tools-r2600
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

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
