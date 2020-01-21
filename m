Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4EC01435BB
	for <lists+stable@lfdr.de>; Tue, 21 Jan 2020 03:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729043AbgAUCkl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 21:40:41 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:44251 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727829AbgAUCkl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jan 2020 21:40:41 -0500
Received: by mail-lf1-f65.google.com with SMTP id v201so880168lfa.11
        for <stable@vger.kernel.org>; Mon, 20 Jan 2020 18:40:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=mEYxaeaD/ni9fI5N0R8AkjO6yBJXlHCq9B1gsIiALFs=;
        b=XMrKjoj6wlzusgFAHvx7zB+LhLueiEpHbL7Df0EOuzIYYj/9lV+mfjhd5D3yFL2UTn
         BIcG0i7dYUxa8oCwvbiAsJPCQVYzbMCc7KrtOKZ+V+uQvTJhkspz74Izex8v5WRTfa3U
         D5ZtXemt26wiq3IuG+I6i/mnEZx3QsUYcUBPJq8aR/nyYpqRmg206uGrJ9AdyE1Puz7q
         XlAP/KK7lxkQusKSl4LlE3nL4D5i2QUIkTwU7N9EaeT06gn3gkHAXPVUyR6iZqcDmgEQ
         y+rpln27TPW0LRs8gPsnCD8HyuUvCAETDDzTeOd2l/6M9Im5c/xF0dlr7803U1JazzBU
         62Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=mEYxaeaD/ni9fI5N0R8AkjO6yBJXlHCq9B1gsIiALFs=;
        b=jA9ssqFW3XlnUIxWKg4E94FHVmvEwEzHRZn45919VgzsGYdWQ/g4z8OEj/fa7mbb4y
         gQmrmJdR7RPmc9r8hVe8YZIZq9dLTtt2ZFt7GLkrXN/sULX5cP/oFBPZoIVRcpjsZJGL
         94e0GACGYLdW22dH4OVWkkODMrxiaMyyeJRoGBTBFHhCfoxU6+GywNvjOqR52QHYsZvR
         3PkhjajmcbLU8amABFOMEsL/qqa2e++qY8qJcCikTXc0Arl5cMR1bRDj0DlkL0ZwtOrZ
         mcbDjoVYvvG2KFq99Hu6yEGhuinztkVusfw/zq+BA4BQqNIJBKficH5rQ2kKitAJ5Pbr
         ZQ6g==
X-Gm-Message-State: APjAAAVKujVgsuoyBaf/rqV6p6MyeNd7zIMgNhDmDR7voWYlnVNgRHCH
        v3gtHklrWf4wzHG2HUymgidZjZITiY0iqqUe8hhxkA==
X-Google-Smtp-Source: APXvYqxiskfAroezW3io0p9c0SYnzwXWTzizSYNYmMO2vm+NQ394P/gwHgYwr9FqFkO5+P4H5figLAGdUJ2GF2lfZgQ=
X-Received: by 2002:a05:6512:64:: with SMTP id i4mr1277262lfo.55.1579574438974;
 Mon, 20 Jan 2020 18:40:38 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 21 Jan 2020 08:10:27 +0530
Message-ID: <CA+G9fYttVF2DPnd3S=H7uGp7HP7dPEgMG_cXxd0sv-8bRK6Oqg@mail.gmail.com>
Subject: stable-rc 4.14.167-rc1/9accc54d9689: no regressions found in project
 stable v.4.14.y
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

kernel: 4.14.167-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: 9accc54d96898b2e3dd6c27ffcb36db40e2dff13
git describe: v4.14.166-41-g9accc54d9689
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.166-41-g9accc54d9689

No regressions (compared to build v4.14.166)

No fixes (compared to build v4.14.166)

Ran 24209 total tests in the following environments and test suites.

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
* kvm-unit-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* prep-tmp-disk

--=20
Linaro LKFT
https://lkft.linaro.org
