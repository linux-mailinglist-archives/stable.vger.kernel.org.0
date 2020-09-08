Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE396260B82
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 09:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728479AbgIHHFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 03:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728115AbgIHHFd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 03:05:33 -0400
Received: from mail-vk1-xa41.google.com (mail-vk1-xa41.google.com [IPv6:2607:f8b0:4864:20::a41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A104EC061573
        for <stable@vger.kernel.org>; Tue,  8 Sep 2020 00:05:32 -0700 (PDT)
Received: by mail-vk1-xa41.google.com with SMTP id x142so3839125vke.0
        for <stable@vger.kernel.org>; Tue, 08 Sep 2020 00:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=+WPNqeHY0NGCVNzt8Jhpa6FnZGn/lQTEKi4/2wgZX/o=;
        b=BOhjJqYzY841tlD9WpxJ6Nx2+7xs4TfalygQ8biTzo2aPEwd1nHticS5fx6hLArdjc
         +oMDv0EZIbUHhSwBeruqt39PKm2ANaE/u/SZkqIJXc39d6RRDm2A7+oLC57cdvGXYFfd
         rA3rSElFH0yk1YY9PhT4HK2vdo/EISvn3KVA8X2NTHuS70er01A9xdl0kVOS8NAzJmYZ
         YJy0vs8toJSaTM7YDYufkTNdZcR+WJtszhZk1aRC0FFQXCLw1qQKwjs2DyTu4cjy9Xbr
         qlEoGgJZXyFwB63eQD17WLZAAhIxzlmYwRflPEhCjbJ8+JysfaYjeFczxEj+80KlgIbB
         wXUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=+WPNqeHY0NGCVNzt8Jhpa6FnZGn/lQTEKi4/2wgZX/o=;
        b=aZkGqt4Issvd5fE3fynkhSk+QiwThXaw+FhnHsFnTrxHWXCyHOtQqEF6jPnwYRFMc4
         YTZ0ZTFO4Mx2IPtsjF0wFtIvQjrvbQwtRcqchAFVZrd40Ja/MUVhzLaBn/I4tOVP5VxB
         FE+FtEwLE23QMvKAjbNm8RZd6nRjDfWd+FI/CSFvLHGvuHtCm5Mi5LiIUSPKpH2kjtuK
         jKIlQZtTbTzsQ6cgv5hAIuZ4SWmpyLA8frvrX6IaFOMIZwNfMESIzssr5+CoihLo4FtV
         IX/ntrdHvTskwnh2ya3ObnoTukyNH7NMc8j+t2I6c3J1qCKOBIgSJVI540O9DTS2OTRn
         VxzQ==
X-Gm-Message-State: AOAM530+RGEifoDf37OyDmqNbvEqHKk8WNoxH4qZF43lI0o8/RQaADsm
        wzKK1kQbXDxPGEhAngpDbLt3ETLdVp90sx+Vr9j2SCArbY2SxQSL
X-Google-Smtp-Source: ABdhPJyT1MyHoqHUXf5XVE9rvDoDPYL0cXcTsRzssYZlh6r2z9O+ZDj1e0ttK6+AYrPeBoSOpXj/YSlZrFnns2DkssM=
X-Received: by 2002:a1f:4902:: with SMTP id w2mr13068937vka.37.1599548731058;
 Tue, 08 Sep 2020 00:05:31 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 8 Sep 2020 12:35:20 +0530
Message-ID: <CA+G9fYvU_b5Rbp_82LGdRXN1tcEjzivkSTAnuJ1m=Viq7egN7w@mail.gmail.com>
Subject: stable-rc 5.4.64-rc1/4b88d27c6307: no regressions found in project
 stable v5.4.y
To:     linux- stable <stable@vger.kernel.org>
Cc:     lkft-triage@lists.linaro.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 5.4.64-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 4b88d27c630791d5b413513c00cf59abe98a0faa
git describe: v5.4.63-86-g4b88d27c6307
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/bui=
ld/v5.4.63-86-g4b88d27c6307

No regressions (compared to build v5.4.63)

No fixes (compared to build v5.4.63)

Ran 32688 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- nxp-ls2088
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15
- x86
- x86-kasan

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
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
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-tracing-tests
* perf
* kselftest
* kselftest/drivers
* kselftest/filesystems
* ltp-sched-tests
* ltp-syscalls-tests
* network-basic-tests
* v4l2-compliance
* kselftest/net
* libhugetlbfs
* ltp-cve-tests
* ltp-fs-tests
* ltp-open-posix-tests
* igt-gpu-tools
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
