Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49558118286
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 09:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbfLJIlG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 03:41:06 -0500
Received: from mail-lj1-f169.google.com ([209.85.208.169]:44000 "EHLO
        mail-lj1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726847AbfLJIlG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 03:41:06 -0500
Received: by mail-lj1-f169.google.com with SMTP id a13so18874734ljm.10
        for <stable@vger.kernel.org>; Tue, 10 Dec 2019 00:41:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=QKvsreDFhHWMAzvpA64vXSDhZciHLX4vlgMXV8eEb0M=;
        b=pVikknB1+TkPzc6xunbV4jvw2ERFKcq++OqeSFgPKdB8oT6AxWYEmHDJeKv1lczoWf
         POVImsncUEuhL7immF42gy0m+IPMhaXbOKU+cpALYSG1V2lIYce+QfQO0Fdh9czmIqnN
         5HYhR48EjznwYLCu4WDh/XlYaUXz09YrjdnqygYLpSrzWDDZ4huYJFVhaJ/cEAYhQsVp
         VuPeEpTDq1QGFO0tuaihItY++19h2/aWOAI4id0xCjAp7EMlpoaDpiNktVyDqPapzmxz
         INY8qysPhV9cQOT93+h9sUMMA7lwKNJ7d4t3MK1OVeP7wVskm8wCSXaS0bi3QgTLG1oA
         q/8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=QKvsreDFhHWMAzvpA64vXSDhZciHLX4vlgMXV8eEb0M=;
        b=NdtHqpUbCa4Py2vqqdgtCKWUz23EkvyAWEJOB2c9gZc5TdfSkALpxsvNJLxlhN+6EE
         KxNo+RXXav6Bm7/fkKSB/BsXyAXvT9vvbcvmfyGxF1sFfVY6fCpBj7gfiGV+lhYPaQhk
         6Slux7mai/SF27fg1lz3mM2SWxPEZZ9lKt2R/B3N+0ro7iUix+mmwu18wxPNyJStCRXE
         aYBlbyoi3KtCuTWcpfRhK8rnlnc1S+Gl95gzpsUH1zX6mZF/O261gr4F6RWNYAUDapcr
         g+AnBuyCxo83B3v6ocMBSr+TmWSMVXZAucejeVFJaBo9G7Xcm4iwbYOwgISIe/vtPd4X
         gPsg==
X-Gm-Message-State: APjAAAUumDDDPYDtpt9fxpj7kxFmbf6jrXjqLGifsdiLmQkBGgBJxPwS
        qbP4Mj2M+Uc/af46GYte00kxRPzh7Mn/6nEYR2qHEia4xMA=
X-Google-Smtp-Source: APXvYqyR3q27vKIGIE1J+PF4BpLLsL2ZbVjtAlqCcR07wBWJwYtuDWQMCLiWsoqHdUqvt6pmXDQhqiN7KF+WDqqvXNQ=
X-Received: by 2002:a2e:9b8f:: with SMTP id z15mr19960744lji.20.1575967263776;
 Tue, 10 Dec 2019 00:41:03 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 10 Dec 2019 14:10:52 +0530
Message-ID: <CA+G9fYvbwWaPHTGwvuUKp6q-GJtfKoMMgtqcefa6MZ1Wqt90DA@mail.gmail.com>
Subject: linux-stable-rc-4.19.89-rc1
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

kernel: 4.19.89-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: c0fa90c1d847eb4ef91a4056dced0b10d6291f40
git describe: v4.19.88-242-gc0fa90c1d847
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.88-242-gc0fa90c1d847

No regressions (compared to build v4.19.88)

No fixes (compared to build v4.19.88)

Ran 20172 total tests in the following environments and test suites.

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
