Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 448191E217B
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 13:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389011AbgEZL5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 07:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389012AbgEZL5e (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 May 2020 07:57:34 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 495ABC03E96D
        for <stable@vger.kernel.org>; Tue, 26 May 2020 04:57:34 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id z13so14443013ljn.7
        for <stable@vger.kernel.org>; Tue, 26 May 2020 04:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=OSZHdSt66oSQmH8unaaMgPJyNnVNEVs0ugrr6f8AmsI=;
        b=S5vktkPBRUNgqMaTo/+fFITFzx9b1FdOz9qGxndUDqHygXaKvy+zSqdnjks21jmiOD
         xkSxoSA2AJwXESiyz5NU5OuMb4JcoRmluWbdeRo3b+Y39B/1mOkR2aHB7VOXrNyp15ja
         XohfdVw4FnxqjvRtLFE8BwXVYJOE5+CVqMxLnIMG0i8oHav4DM7GQ5ozWSnMmKVClCtz
         CyUxD47kxobTiZ5NBW5gKlMrLLy+AV8NzKqQrjKcOWT3isz1pL7OSZopXMiMX3kFsoH5
         nM9uAKqmJN/7TUh2TMRtlQacYeMp6a6Ex/yiwtd0l89A4LeLd6SZfo5dv8wQ5TPekcJ4
         ACGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=OSZHdSt66oSQmH8unaaMgPJyNnVNEVs0ugrr6f8AmsI=;
        b=LFyqWukd2vwgK2HhurznTVp8oYSbzRzyzt0udxZHP7XBM18/wjUfg+8IJtmp4xTsUC
         lCs+22PoYI8GlLCs9G17tqRhWU/utp9/pcvL0vB3nW+jozU4E6q611u23lpsa81w+fDK
         YYB1tJ2UQ7AeFxRhyK4N/RXzJipg3Zi9CfNGL5pexKmXn3lc7Ukvw8sl4JC9kKYDyfrf
         cHA50wh9bmBWUtIiDDLPJ984IyIv1Bi7d7x8v70xSgae91EJEQR2dl6H6Io7idVZscA+
         ZYJKKltny+J/5k2iusBoVR2/B2+02zEOnuXhIWyM9PQrKYg4izNXUjO2Q2Z6qpYQuqeF
         Cvwg==
X-Gm-Message-State: AOAM533Rwd6eoIe/atyErN0hLg1Qb7N2Lmc93xMOD5gDxvhSgiJzwTln
        QsmQAXUQfZZqDiFlTzsJGJsSz8rU9y5jdbQOAVFc2w==
X-Google-Smtp-Source: ABdhPJwJ4ALqEk7woTnAR/MLUARH2U7gjA7cckRUDxtG+KA9M5Jrqs8NLlrb34reqQkNvYOcmDVDxe7Lb0vRJyZrOmM=
X-Received: by 2002:a2e:150f:: with SMTP id s15mr441736ljd.102.1590494252129;
 Tue, 26 May 2020 04:57:32 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 26 May 2020 17:27:20 +0530
Message-ID: <CA+G9fYu5rTjZPh720A0+_ZJm8wyNOAJo0rSMGu45TR6Qjkah5A@mail.gmail.com>
Subject: stable-rc 4.4.225-rc1/1f47601a4296: no regressions found in project
 stable v4.4.y on OE
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux- stable <stable@vger.kernel.org>
Cc:     lkft-triage@lists.linaro.org
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

kernel: 4.4.225-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: 1f47601a4296940bac6cba8c55ab73ca2453f284
git describe: v4.4.224-38-g1f47601a4296
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.4-oe/bui=
ld/v4.4.224-38-g1f47601a4296

No regressions (compared to build v4.4.224)

No fixes (compared to build v4.4.224)

Ran 12744 total tests in the following environments and test suites.

Environments
--------------
- i386
- juno-r2 - arm64
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* kselftest
* kselftest/drivers
* kselftest/filesystems
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
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
* v4l2-compliance
* install-android-platform-tools-r2600
* install-android-platform-tools-r2800
* kselftest/net
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kvm-unit-tests

Summary
------------------------------------------------------------------------

kernel: 4.4.225-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.225-rc1-hikey-20200525-730
git commit: 8fc41df5985180bb48f135eddf9543fda636b21e
git describe: 4.4.225-rc1-hikey-20200525-730
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.225-rc1-hikey-20200525-730


No regressions (compared to build 4.4.225-rc1-hikey-20200525-729)


No fixes (compared to build 4.4.225-rc1-hikey-20200525-729)

Ran 1775 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* kselftest/drivers
* kselftest/filesystems
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

--
Linaro LKFT
https://lkft.linaro.org
