Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B68F2118C37
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 16:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727178AbfLJPNS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 10:13:18 -0500
Received: from mail-lj1-f176.google.com ([209.85.208.176]:44134 "EHLO
        mail-lj1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727211AbfLJPNS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 10:13:18 -0500
Received: by mail-lj1-f176.google.com with SMTP id c19so20245609lji.11
        for <stable@vger.kernel.org>; Tue, 10 Dec 2019 07:13:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=dgDPz4Uhp428I98FdMt/iZ9HoTY9zu91nHV/KtS+FeY=;
        b=Fdx/QKIKTnwLhsrS+UD2owcJuPnc/Tsn1kSk70A4kDZOVvytpIlUhDvm7jFaRJ9ZhP
         NHPbqAW54cAFCutee5R8dK+ijOXDQMJuLtXFaSjOCZl42f3QnFwsBDJE3XqdHeGmBHYZ
         uP5/5zU9j4nzysqgDbGZ7dbY7Puv9h8IJNJGQBFQWEUO0oLouUQchJl7hxgnt7Y2wMrl
         YBsTkHcJjpd32NuZm6ZUcleKb0B2jEHlWhB1EZzJMM8uZQJzH/Q35DkEGrV58dTswTBn
         Y0ZzHRs0frNEPsg24Ld/VuaKxCrS8NtHVoCzLHlyr8s/6kBYjEKz9ie0v1Wiub2VYJ6U
         Nw4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=dgDPz4Uhp428I98FdMt/iZ9HoTY9zu91nHV/KtS+FeY=;
        b=bp6srQSjNEI7iIYXV82tm2j/GuLC95EkaXJFQhzjQGsP9hqXroXQMl0+OVAaufw8Cp
         pRikOVfhozhpPClvE0rL6r45GpSxCLFoVI8TM2MjQJxsHWKfSsbfwFClDzjEAqT8QKHT
         YR8m0Kk65mqTr1pD68yQS9gqDCfucXOwuS+20amQc1RE6LyZuGR27eib4isfONUrN0iO
         QpZBRR0/91LtAfLVp9mOBsGVYrf2c+QQsVJ5iMJs2NodgBJ95iYKExARA43wKkWEpTMm
         cb6W/be1krM/C8tSH43CI/ZnrEUGnou2C3yeCFEgHogkizT1ZnpAcvssBmwhn4CSaW8l
         h10g==
X-Gm-Message-State: APjAAAVdhciks2h3h6MYLWJLRXKPgKln8nIR9t4dgIj0J9H7vVCb3hlH
        AX4PwHVwmTbn3vScisZsMQLZcKkV7EwpDrHca5OyizwJZOs=
X-Google-Smtp-Source: APXvYqypYfZdvYtyzFw/nqz4k54b+zAkk0R1+0IodjoNvfrgA5ZLgW/X95pqnKBOJ1KComsEiBzoSgp/0PLU1S97Aew=
X-Received: by 2002:a2e:5357:: with SMTP id t23mr21151616ljd.227.1575990794645;
 Tue, 10 Dec 2019 07:13:14 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 10 Dec 2019 20:43:02 +0530
Message-ID: <CA+G9fYvhLRuLkyyuw=XKizwaSF21OEMP1Hp1KdWczY+ys7Ri4A@mail.gmail.com>
Subject: linux-stable-rc-5.3.16-rc1
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

kernel: 5.3.16-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.3.y
git commit: 0464d9defd012aa5bd0e126aaba3694d2e30cd7a
git describe: v5.3.15-98-g0464d9defd01
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.3-oe/bui=
ld/v5.3.15-98-g0464d9defd01

No regressions (compared to build v5.3.15)

No fixes (compared to build v5.3.15)

Ran 22580 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15
- x86

Test Suites
-----------
* build
* libgpiod
* libhugetlbfs
* linux-log-parser
* ltp-containers-tests
* ltp-dio-tests
* ltp-io-tests
* kselftest
* kvm-unit-tests
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-cpuhotplug-tests
* ltp-cve-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
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
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-fcntl-locktests-tests
* perf
* install-android-platform-tools-r2600

--=20
Linaro LKFT
https://lkft.linaro.org
