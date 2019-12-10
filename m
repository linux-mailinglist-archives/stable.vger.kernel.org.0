Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81D231180FE
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 08:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727143AbfLJHBB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 02:01:01 -0500
Received: from mail-lj1-f181.google.com ([209.85.208.181]:38950 "EHLO
        mail-lj1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727004AbfLJHBB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 02:01:01 -0500
Received: by mail-lj1-f181.google.com with SMTP id e10so18569388ljj.6
        for <stable@vger.kernel.org>; Mon, 09 Dec 2019 23:01:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=5InT4DhtZdEyUvVWgwSzsu4pGmp9LP2YgKGUlNHM1/A=;
        b=VZjGw0k/vmzqtlQhuo6GguQBDaua3ijPAyTxv+7+Ep5Wv3valXOi7FDIxDqgZUlizu
         +50FAJGGiFfLoKvdpoJh72sXqgHG3oZj94eriUUQzGeVUuPF11Tcc/U4DO7lXHdHcLAQ
         7HR1fo+4Dg/7CFCUN1rR1VZLh3tD25tGtlNrA+IoZTkabZ2DsvgTQ6LXp1cxatsDoNe9
         vKeeUWJ2YrAeB/3j6Tfsp0wiwSwOVyv3bMxxUPGnU5DjPzEXfL3lzoQFzNKEZe6Iv91I
         niG1obLEG7/o8s1ti/brbulOcezeJ9OUIk45TlWpPfbbZnUR4TkRZP1g7V2DZpRcl8en
         WKAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=5InT4DhtZdEyUvVWgwSzsu4pGmp9LP2YgKGUlNHM1/A=;
        b=WHM5H/NlYyz0R/tIZY5u8hqjkdOIhVPBoTccsgmGTHuLiD6ZC5ANc6EZPh46q/S9U6
         lUAVOo1NwgZ0bXNRMv9KrPfEs5h5OAKSPxzA/38ST1jODFd2VHiCziDGLOL41sZ6B35H
         iS+gNb57pbAfM+lnpV/rCh6i7eSv8RwjJWgRhTvEukvPW2yrvjcykgtjXZCkKH90bBw3
         5ZTb9c6Oy22rbSmtk1B0+kyZa2JAi4rebpesk2dLnkEkoYaQCiJW7CBj+bu7lfmzrD/b
         /5YyPPwvU3TjbllgmNSMlXq9A/IiZnGShO351jhC5jX0vUipjfieAooipzdf1unYlQ2d
         uXww==
X-Gm-Message-State: APjAAAUR8yaqD/kkn7jUcJ7GJrVUa7TuMxf9HBVHhjgioB/lfNO22PZa
        TX3w8s/eiNO/POd7o2bGFea7qRMnqtkzyRpC7CElsiAxc0Y=
X-Google-Smtp-Source: APXvYqzV/U7leQsSJx6VxI8OHbV888AWENVsjm+wtUJEmpjfsviPSGMKq/1q6+bTd7lQSU/WFN83YXIpeRnAynai34k=
X-Received: by 2002:a2e:7818:: with SMTP id t24mr19955179ljc.195.1575961258691;
 Mon, 09 Dec 2019 23:00:58 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 10 Dec 2019 12:30:47 +0530
Message-ID: <CA+G9fYtXy0vMwNcOcXdwJL+0KPnhXUoWospjY0xCzMLhpddUGQ@mail.gmail.com>
Subject: linux-stable-rc-4.14.159-rc1
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

kernel: 4.14.159-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: 68c5d5aca755b65e2468f09bfb07750e5c3f3d0c
git describe: v4.14.158-151-g68c5d5aca755
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.158-151-g68c5d5aca755

No regressions (compared to build v4.14.158)

No fixes (compared to build v4.14.158)

Ran 20461 total tests in the following environments and test suites.

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
* libhugetlbfs
* linux-log-parser
* kselftest
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
* ltp-open-posix-tests
* network-basic-tests
* kvm-unit-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
