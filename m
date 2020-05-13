Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD2F1D0DF7
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732964AbgEMJ5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388337AbgEMJzz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 05:55:55 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA54C061A0C
        for <stable@vger.kernel.org>; Wed, 13 May 2020 02:55:55 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id z22so13138824lfd.0
        for <stable@vger.kernel.org>; Wed, 13 May 2020 02:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=IDaxDOobVDjFaR+XbUcO1zeYd4szXYR8Tg3ntYn3THQ=;
        b=QQRyzIWka/20HYMrTmQWhFH1DfWtTrXuxGlAQhDOt0cXDTf9KQ0mYF+tHniAsn1xEt
         JU0nMrKnJw93m+JkHft40GDLj6p+igYUHR/i9FoFyONn8YOikPCImYkM+zU0OMF0OR8o
         cFGSuhJiF0w4SymCdyAhPjmo5l/o6XnacAB3qAFGhQuu1G+CEuUiGhcsGvxKqidhM4r9
         6LNDfHQysewD2YWmKOvyRFutNL1MEbEEih9Ew5RjpxULwqvT0oK3x8r+Ep3KlTTw18yb
         61GUf+HP9Qhy87hY4X+oxMu2WQWbKq0/3pE9lI9/42QrWEkVQlEKF2zTaE1KATmyfqpS
         1rzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=IDaxDOobVDjFaR+XbUcO1zeYd4szXYR8Tg3ntYn3THQ=;
        b=VqBXmUljxVuWtSfDZhPZQg2ly3U4B97/EJ9i99Q37eeaSo58OHQWc6kCtZm25QNwIq
         FDSmmfDV13mTahza53oaC+i3Qo9n1lKxX/c7E/2iV5nG2jmgbv8qeO5Z/NEK5wK7wFs8
         FHTHtKtcr+swehNlP17kmGrFyrpvvDYAHe3DeX3kxBSoqt1jhdgqBretHLKBugVdk9hI
         xWFKh/H8SguInKv59e/0YbRbVHRgF2U2ewwXUlF2D/lLI2KSQnhiXViVePJCk2q4ld7w
         EEXRhcLABvvc7x1dSWs8EmKq0J1NK0WOiBgbQiNpTNr21JSGLF5IChjbO4GUebVt6WJ7
         lscQ==
X-Gm-Message-State: AOAM530Yf3Y2ikW5tClY88uytsiI4SAIxN9ZDUNXh5JeePv/tUsXBjf2
        qNJHbPJQQlTw2s0zH9ZoRIdAD6YPM6h49mOqLR63vAQTF0sgFg==
X-Google-Smtp-Source: ABdhPJzoZRV8ZtcQ2AxvMArUx6ZSVUb8mXeMCKC6mBurbB8hvbXEt9uo30BgRFMtXrM9/QTlwsYpgaP2jzDkEwZbBVk=
X-Received: by 2002:a19:4883:: with SMTP id v125mr17261923lfa.95.1589363752383;
 Wed, 13 May 2020 02:55:52 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 13 May 2020 15:25:39 +0530
Message-ID: <CA+G9fYtC68oypqUoPbsnCA3CKL9=Os68fR+K1eKaWpFn=nj-Ng@mail.gmail.com>
Subject: stable-rc 4.19.123-rc1/92ba0b6b33ad: no regressions found in project
 stable v4.19.y
To:     linux- stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     lkft-triage@lists.linaro.org,
        open list <linux-kernel@vger.kernel.org>
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

kernel: 4.19.123-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 92ba0b6b33adce776edd773ce07fbf0b6097f9d5
git describe: v4.19.122-48-g92ba0b6b33ad
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.122-48-g92ba0b6b33ad


No regressions (compared to build v4.19.122)

No fixes (compared to build v4.19.122)

Ran 24159 total tests in the following environments and test suites.

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
- x86-kasan

Test Suites
-----------
* build
* install-android-platform-tools-r2800
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-dio-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* libhugetlbfs
* ltp-containers-tests
* ltp-cve-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-mm-tests
* ltp-sched-tests
* ltp-syscalls-tests
* network-basic-tests
* v4l2-compliance
* ltp-open-posix-tests
* kvm-unit-tests

--=20
Linaro LKFT
https://lkft.linaro.org
