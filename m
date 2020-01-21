Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D44C81435BD
	for <lists+stable@lfdr.de>; Tue, 21 Jan 2020 03:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbgAUCmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 21:42:06 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:40159 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727144AbgAUCmG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jan 2020 21:42:06 -0500
Received: by mail-lj1-f195.google.com with SMTP id u1so1093196ljk.7
        for <stable@vger.kernel.org>; Mon, 20 Jan 2020 18:42:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=WWBGxlqEKtByYrZxTN7wVLL/yCc9rJJ05Z3wLmqXFP4=;
        b=nlFKhCZdCDDadI0BIJ1/LdpsCDKyjYwh4pC45X+u2rJjMXjg0hftjiikDf/idmoM1m
         rEsjgj8PN77qEjvTsmb5Yeorsk6GRXnCJjgLNo60ZNHa56okDOtiuJvGWuBts5Aq+fBv
         N94DkfsGWqpnU/lrxjBbjzaNJYYHlDJuxoXao+LXEl+CQoepN9S1rD54KNxOHbf9bt2z
         hq/JX0c76+P6C0EUsYncH996/05LVG4Slzk6fo4DF9yJcYSKYxSMy0o0HnVnjv5KJh7N
         lbJ+kJcrKHfA06iS97wab3pofqcFrdZMyzCEjGddLse7Qx+CuqXjcIt4mggt5ikprSYC
         qthA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=WWBGxlqEKtByYrZxTN7wVLL/yCc9rJJ05Z3wLmqXFP4=;
        b=i8ccCnXRKAAcucfhJ2XpxuQslkSyT+g1Wd0ZbDzFhOyDZR0kTdFjroYD/sRbF8jVBh
         1T+ECYF7wyi82BkPr2OFjap8LcICp+7KitDbJsZdAqSu/H5lPyxbNVRLRI+co0cUElLS
         v5anoLgcUOEmdYl6IvdJQK96Vt/Qew5/PAlc2ceRUhGqk1p2JPOXWBCbO9yxAt8gsPfr
         5tdaYupYsl8OzU5cXygPmc3ajNIbJd9AQZfkcpOpvARp+fxI/I/1wBtPAwzs0Q7rEUH5
         iF+7cHPio8VpcWl/4dzNcPj8uJFa2up1CEgdazTyog3/1OJ9BlU0nIslZRTm1lv/uDST
         3I2Q==
X-Gm-Message-State: APjAAAXWFSekzKIKJTHSEoAKVxJ5L1SQ4ujIfBx8TcZDqIhv3NCrcZDI
        gMFidDR6Lkp/7hVZo2oaERPgN1m7M3DxUH3jAcmw7A==
X-Google-Smtp-Source: APXvYqyA1CtW6sxp6Yqf9gnWOT78OElI3V2nVRo7ZHxlJdU6/SbDEUZWxqHaUF815xf67a6alIK/v+mSwRDK50g+YGQ=
X-Received: by 2002:a2e:9692:: with SMTP id q18mr1207743lji.177.1579574523968;
 Mon, 20 Jan 2020 18:42:03 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 21 Jan 2020 08:11:52 +0530
Message-ID: <CA+G9fYskCNTZO4uXBX77CqHvFQ5tBe7OKfmXfGUBzMKvPeLRcg@mail.gmail.com>
Subject: stable-rc 4.19.98-rc1/6e319a78bc27: no regressions found in project
 stable v.4.19.y
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

kernel: 4.19.98-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 6e319a78bc278fb8f9173acec4733804333d8416
git describe: v4.19.97-66-g6e319a78bc27
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.97-66-g6e319a78bc27

No regressions (compared to build v4.19.97)

No fixes (compared to build v4.19.97)

Ran 24378 total tests in the following environments and test suites.

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
* ltp-fs-tests
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
