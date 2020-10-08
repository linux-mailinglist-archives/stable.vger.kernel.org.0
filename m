Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15BA2287165
	for <lists+stable@lfdr.de>; Thu,  8 Oct 2020 11:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726041AbgJHJZ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Oct 2020 05:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgJHJZ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Oct 2020 05:25:28 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE195C061755
        for <stable@vger.kernel.org>; Thu,  8 Oct 2020 02:25:27 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id l8so5430852ioh.11
        for <stable@vger.kernel.org>; Thu, 08 Oct 2020 02:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=8+sMhC3ZQCNGKSTFfgFM2/9gBJtOpKrD/OLfQ4E+nrM=;
        b=GtMqFM9ACBsKWmeRT1aaAAsIoavhR7XVWceMjj0R8V7NA3g3++XcHSUH11abMMt9es
         0xBXupcNdM8iMmydkpAHFj5eLjWO4J9O9oB7a8JkTht7aaizao5WmCWhGGzCASiWDlSh
         gFDx4pJHIohABUvn4FINNQUNz+5pfcOweIYeeVztydNygvEpb4RZQU2VHISru5nIyBPu
         rU7KaRQvqeRcODZO9WNOrKSdoIpUJrZrNYmtaRu6edf4/zBBlpgbsU61xOCU3kgq1rQD
         ALK09NGtx1ydflWfDB5tliQ88APZhzIZPGHx4Isf1Xjp2GYSwHeQOC9xUtjbYjzCxOc+
         1nuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=8+sMhC3ZQCNGKSTFfgFM2/9gBJtOpKrD/OLfQ4E+nrM=;
        b=A6QxpGmrkbnKE4GvxEA/IuW7ph0iLl6M8fjpdiXOJHwMf0dwcrPYCjg7nCNE3ZT039
         s7gXx2uzH0thCBkL5Jde+rr+Ixzk7k5CbkCH8lVlOyon+HF7e2VjdOhIBafFZvoOw5MT
         iZ+azWlswmuo8YXZEUMMtr7xVpul/5lXVFZBBfERmNWBLcVA2ce4+NSe81E1Q/v9x4nD
         MG2S+JAMJw/GfG4bcm/NLB3HLj7NjpOhklCuHzcCqee9K81McszIrAflg0uOj+a20DM9
         P4NQrvSHivXLHgndBpcmQDRBH+WV+zdNVzvNraJWg7NVoJcUW5ogSvB+jYv1A73ikUp0
         onIQ==
X-Gm-Message-State: AOAM531Qcngm2ufJcNf2JmX8SpwJXj9VlTxhu11U7RdSjX/gHIwkDOQt
        NxUL4MSQNdmvsBprxL6S8WYb1NhxiPWIN/nGC3XW4w1l+ShnIgEB
X-Google-Smtp-Source: ABdhPJxNgAKQUjZgb3b6ZTHNNEvgMMfOE8oY1IPdVfOXYD5UVSWhViIBxzXodqKFoq4sKkU7KnVjV+LggspSUwAp0dY=
X-Received: by 2002:a6b:b208:: with SMTP id b8mr5393531iof.36.1602149126186;
 Thu, 08 Oct 2020 02:25:26 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 8 Oct 2020 14:55:14 +0530
Message-ID: <CA+G9fYv8RcQTBWLOhYxx0Y=epzZ49umoEFCwzQ17J3wZs8dO_A@mail.gmail.com>
Subject: stable-rc 5.4.71-rc1/08ae63af42e6: no regressions found in project
 linux-stable-rc linux-5.4.y
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

kernel: 5.4.71-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 08ae63af42e6024dd9c216d0588895ff37b4afbf
git describe: v5.4.70-9-g08ae63af42e6
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.=
y/build/v5.4.70-9-g08ae63af42e6

No regressions (compared to build v5.4.69-58-g7b199c4db17f)

No fixes (compared to build v5.4.69-58-g7b199c4db17f)

Ran 36323 total tests in the following environments and test suites.

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
* kselftest
* libhugetlbfs
* linux-log-parser
* ltp-commands-tests
* ltp-dio-tests
* ltp-fs-tests
* ltp-io-tests
* ltp-math-tests
* ltp-sched-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* perf
* v4l2-compliance
* ltp-controllers-tests
* ltp-cve-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* network-basic-tests
* ltp-cap_bounds-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-open-posix-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
