Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83EB628727D
	for <lists+stable@lfdr.de>; Thu,  8 Oct 2020 12:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729428AbgJHKY2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Oct 2020 06:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729221AbgJHKY2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Oct 2020 06:24:28 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB94AC061755
        for <stable@vger.kernel.org>; Thu,  8 Oct 2020 03:24:27 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id b1so842755iot.4
        for <stable@vger.kernel.org>; Thu, 08 Oct 2020 03:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=eqK74vjptn8PacdOVe86XCpCpAD9MnFomwEp68EZCLs=;
        b=bGhjacv6vocpivA37chEnLSUG1vUpHvijocrr5yS3OrIcwC8ZUkpspWxoYBSIC7zsJ
         TuXnwOfjsr1AJd8jvZXAVBJa94AjRuy0NxLHBKq/trtH+FSAbRYzXm310nsZjdiSUyjo
         gxCbvSh5n6iYe0aSXW/NEi6llDW87141JfYmNsJ261ziSZcJbzKrSECa9mdkhwsxA13E
         vVQo3CqW8Bjql4NTYxsOA+ZU0PSxgJf61FYvdnyapWnAMTSpkAnI2JylYNapCtynNvv/
         Evtk7jrD5KhPoF/LuJ5PNhSpWqomOULuOzwfNH82CHT4vwLg80mMZVyaJEFGtksazGQI
         nMtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=eqK74vjptn8PacdOVe86XCpCpAD9MnFomwEp68EZCLs=;
        b=ECyyxmVVwTQLWB01pliHHOflK87U0BVRIEiAGdCjDblTOY4QKTrqQKkcqkMjYZ5JD7
         XNBP8JypyPl8pccFAJrhqJpoyTwfkGANGRS78z4sXUEXmVo6qWaGOEsOQWGutW7mFfj+
         9nfVglDN6o/FlBqdRIoCssnP+3EDyGLle7hnwZapOekjGj8rhMRFDDi5ImhOjDOlGUft
         hdee0U3/TbWtRw//BnRcPFhb059rjguq1/cgdCqEIIN5epkLQqibGPKmZeglEr7tbs/F
         q5pLCBg17YpcRMODAF2sMQ5LgxYhAiDlN7BdDLFeDhk3/yu9hPU/x0G7Qqa7TFTwKXSQ
         JgBQ==
X-Gm-Message-State: AOAM530BdDtMvkmc7i8M6PlVWyqlh0E9X6jupSkCcTN+wj937rtU3Db0
        sPI6KEmRXOMS8IWTG21eFd2JTIPY6FlVaQJ+vOeGybVM17tBhwLf
X-Google-Smtp-Source: ABdhPJyy95qNtD8PZXDhAeFud1aCBYuYZoWBiKMUiWIoUzmh63WJphEFH5RpT5S5gvawxSL6O2H8S9aPbZD44pxKz5E=
X-Received: by 2002:a02:a317:: with SMTP id q23mr6116622jai.35.1602152666291;
 Thu, 08 Oct 2020 03:24:26 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 8 Oct 2020 15:54:15 +0530
Message-ID: <CA+G9fYv=W0z95hqvJrh9Y9+5evRq4yuQJre8YQ4E85Mf6Tjykw@mail.gmail.com>
Subject: stable-rc 4.14.201-rc1/2ae705c76879: no regressions found in project
 linux-stable-rc linux-4.14.y
To:     linux- stable <stable@vger.kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 4.14.201-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: 2ae705c76879ed326adc4116bfaa8cdc8da5affb
git describe: v4.14.200-36-g2ae705c76879
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14=
.y/build/v4.14.200-36-g2ae705c76879

No regressions (compared to build v4.14.200)

No fixes (compared to build v4.14.200)


Ran 33547 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
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
* install-android-platform-tools-r2600
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-sched-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* perf
* v4l2-compliance
* ltp-controllers-tests
* ltp-cve-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* network-basic-tests
* ltp-dio-tests
* ltp-io-tests
* ltp-open-posix-tests
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
