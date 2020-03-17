Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76537187B17
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 09:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725794AbgCQIXH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 04:23:07 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:46290 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbgCQIXH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 04:23:07 -0400
Received: by mail-lf1-f66.google.com with SMTP id a28so4560620lfr.13
        for <stable@vger.kernel.org>; Tue, 17 Mar 2020 01:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=VaaF78arm3WcDKCUJSoxXmti4ld2pkWrc+/vr2CYOro=;
        b=qXvisLXmjjCpope5B/bz/bfQ6lDHWN+80tQYSb8XI4MziX+VENI8TFcMTyI0usszLe
         VGbSVsVOBvAB2MRDG7+BRM8x7m2wxQ2HQT6Qx8ziHuSjKaSfEW+FIwqRaV1sc16CPOYF
         pIy2mcKiO4pUlaBzXQCnW4HT/Cz7QXOEDZYMvYFan2iPGl2YhgL9ka1WNNlVVSKfSwF6
         kc+rZH9pBar1/Fpgoxl91FwdynCIqAIQGMirFZDYyU9Meq0Vr9ajjhWt04CP2aB8MWrO
         WABp+r0fhhgauhaFrULhUDf/ClI7prqQ7FUH409wyrN8RPrUarrlA6WDfKS9Dp3G1S+P
         Dmbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=VaaF78arm3WcDKCUJSoxXmti4ld2pkWrc+/vr2CYOro=;
        b=fR21SgJbEcmEaSVEUMyM7UDvN1OMe9yVh/f/GawUwejnWQRzLElkcn916wfKjHbsh8
         MD8plBRBEvNw1zmNg764Eo0SaGkJcC2E/SnOIheDTMj+JJ99xlPiwEKdphKB6vR2wnUN
         F30GHXPb6V0mXZZmXCEDIXe/y0iuZGFKILvYNpu4VBxcDEuVlRE4dOsiFkBO6ZZhNApi
         Sqlx0jOEhNQNcN5HhZ+5pHazxEoBeIXMtvPz4iUhBTj0bCA3Fq68RxzWy7jeopoYMlsw
         NZmTlOqCebSDhZwwL7RH0Hh3IDGAjyL6YASU8EGCaRb6TbLlDI9/7KBMjQhoaNF5Uaba
         ICMg==
X-Gm-Message-State: ANhLgQ0bMToFWRQ49dQi657WK3DsTWRZOsqByUYcIKOmQvYzxr4/Rj5j
        Mwmo468kc3wZ0of6hEMKxYQkk8s7AQ/0WdpUa1i1Bw==
X-Google-Smtp-Source: ADFU+vsiHgojeYxk1cy8kWFtcIpjydGsGaegtWraoxLKjH757gnYBjW8mWZ9pJDrWbIJRyLMGxYO6rhDjRhA2sXk82E=
X-Received: by 2002:a05:6512:1042:: with SMTP id c2mr2101135lfb.6.1584433382815;
 Tue, 17 Mar 2020 01:23:02 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 17 Mar 2020 13:52:51 +0530
Message-ID: <CA+G9fYvNqjE5JgdNQBj6KcrQJTgVLXwLMT8cgfekpgp-1zx7LQ@mail.gmail.com>
Subject: stable-rc 4.19.111-rc1/a807140ca617: no regressions found in project
 stable v4.19.y
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

kernel: 4.19.111-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: a807140ca617b44592aec2a4a33472692df1ca86
git describe: v4.19.110-89-ga807140ca617
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.110-89-ga807140ca617

No regressions (compared to build v4.19.109-91-ga807140ca617)

No fixes (compared to build v4.19.109-91-ga807140ca617)

Ran 22461 total tests in the following environments and test suites.

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
* linux-log-parser
* perf
* libhugetlbfs
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
* network-basic-tests
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-open-posix-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
