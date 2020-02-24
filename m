Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B15BB169D28
	for <lists+stable@lfdr.de>; Mon, 24 Feb 2020 05:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbgBXErB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Feb 2020 23:47:01 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:43597 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727189AbgBXErB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Feb 2020 23:47:01 -0500
Received: by mail-lf1-f65.google.com with SMTP id s23so5805657lfs.10
        for <stable@vger.kernel.org>; Sun, 23 Feb 2020 20:47:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EaOedTAhSGj97ZLFcQ+8SGq3qeS+x1XBKNdclV9bMFg=;
        b=ZxPLyB+RbkZEl94OpzlEFkmmh2nWlMdlFUkuOVSYeyPBPu2tUDcPn0lhwTgvz7CR8v
         Qb6rmkEWXeCwwqIviGF/vYoYZ8c9Dp9a8YjehfD2gArfrBDYy4b29TgTzI2M3iFuyg8y
         AMHe2fmNdrC8FzFEKY4gg8jZaFXWWhVdkZg8vsnSHXbEQH4fAb+gQ1rYcRBJq74WT/QO
         r7XzvdMHBF5YxOgGRj9TPidAqQg7/3IV3zMeSx7WILsTKr3+00LhAnGXJ59I+nMxPon9
         3j/noxEZLjFy6my73lCN6NhrqW5eVe8VFqyylWRKtO4NXAhDyOv8mgIFs82yVM0Hyjh5
         /wEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EaOedTAhSGj97ZLFcQ+8SGq3qeS+x1XBKNdclV9bMFg=;
        b=jjjaksP+t+qUGT47OltdzLIpP2u1zi3ol2bKB517FO1wgxiT50yRBvz68XJLTjzUP7
         TwBECNt0kqAjwe25q2tQxTHSZBpHRned/Q16i/NYRyNYD3cbfHL5aAMf4HQ1Rbnhf++3
         fVPX2R5gwziO1UGYqy/CGC/g4iX72GlXysi3dSyuZgPTtm/e/A77obcgH9g3i+8MYjvH
         dJpH8pb277NpRlUqk7Ut41xOgHkLW2ozc7Vr8lEVK0pRTYCNx/ELoN0nsBQxi0/aggU8
         Wu0pIT1++Jx8unFb0CQxkvyoLL/vboTQuMjeLMKmyzJ+7WiMkkDrl9qyukGJg1sWXuVZ
         6KiA==
X-Gm-Message-State: APjAAAXVcejI7Wy4/qe0RYe8IDSIHuCDYy1pIBrCG+nIik60pGBOnL3B
        WvFuHPuF5waM6o2diDUFTwIEy5wJ5IWVTQ4AUe6wLg==
X-Google-Smtp-Source: APXvYqyoFbi/L+o957yyE4IdSJSof+8WXHg5DIdFhwDADvJuDbtYCGLkOwlXmnCcLIPQXAgsAaZc433F21iVx/scbc0=
X-Received: by 2002:ac2:4d16:: with SMTP id r22mr1362407lfi.74.1582519619533;
 Sun, 23 Feb 2020 20:46:59 -0800 (PST)
MIME-Version: 1.0
References: <20200221072402.315346745@linuxfoundation.org> <20200223154024.GA131562@kroah.com>
 <20200223173204.GC485503@kroah.com>
In-Reply-To: <20200223173204.GC485503@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 24 Feb 2020 10:16:48 +0530
Message-ID: <CA+G9fYuK+qmpofdLThcTW6w2YCCM0byfoy7vvy2FGvgZoes5Pg@mail.gmail.com>
Subject: Re: [PATCH 5.5 000/399] 5.5.6-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 23 Feb 2020 at 23:02, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> -rc3 is out:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.5.6-rc3.gz

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.5.6-rc3
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.5.y
git commit: 8ba99698af46e415241a1582e8fe2b5472440a8a
git describe: v5.5.5-393-g8ba99698af46
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.5-oe/bui=
ld/v5.5.5-393-g8ba99698af46

No regressions (compared to build v5.5.5)

No fixes (compared to build v5.5.5)

Ran 26321 total tests in the following environments and test suites.

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
* install-android-platform-tools-r2600
* kselftest
* libgpiod
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
* ltp-open-posix-tests
* network-basic-tests
* kvm-unit-tests
* ltp-cap_bounds-64k-page_size-tests
* ltp-cap_bounds-kasan-tests
* ltp-commands-64k-page_size-tests
* ltp-containers-64k-page_size-tests
* ltp-containers-kasan-tests
* ltp-cpuhotplug-64k-page_size-tests
* ltp-cpuhotplug-kasan-tests
* ltp-cve-64k-page_size-tests
* ltp-cve-kasan-tests
* ltp-dio-64k-page_size-tests
* ltp-dio-kasan-tests
* ltp-fcntl-locktests-64k-page_size-tests
* ltp-fcntl-locktests-kasan-tests
* ltp-filecaps-64k-page_size-tests
* ltp-filecaps-kasan-tests
* ltp-fs-64k-page_size-tests
* ltp-fs-kasan-tests
* ltp-fs_bind-64k-page_size-tests
* ltp-fs_bind-kasan-tests
* ltp-fs_perms_simple-64k-page_size-tests
* ltp-fs_perms_simple-kasan-tests
* ltp-fsx-64k-page_size-tests
* ltp-fsx-kasan-tests
* ltp-hugetlb-64k-page_size-tests
* ltp-hugetlb-kasan-tests
* ltp-io-64k-page_size-tests
* ltp-io-kasan-tests
* ltp-ipc-64k-page_size-tests
* ltp-ipc-kasan-tests
* ltp-math-64k-page_size-tests
* ltp-math-kasan-tests
* ltp-mm-kasan-tests
* ltp-nptl-64k-page_size-tests
* ltp-nptl-kasan-tests
* ltp-pty-64k-page_size-tests
* ltp-pty-kasan-tests
* ltp-sched-64k-page_size-tests
* ltp-sched-kasan-tests
* ltp-securebits-64k-page_size-tests
* ltp-securebits-kasan-tests
* ltp-syscalls-64k-page_size-tests
* ltp-syscalls-compat-tests
* ltp-syscalls-kasan-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
