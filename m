Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCD01435B8
	for <lists+stable@lfdr.de>; Tue, 21 Jan 2020 03:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgAUCgc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 21:36:32 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:37475 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726890AbgAUCgc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jan 2020 21:36:32 -0500
Received: by mail-lf1-f65.google.com with SMTP id b15so915683lfc.4
        for <stable@vger.kernel.org>; Mon, 20 Jan 2020 18:36:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=b60dkj/rL5SXirIPU8PUvzqJ6kZipXx0K/BtQImcJUQ=;
        b=YNAH/f0bhDuHg60vApXLsTyRWKQiCGP2/vehet6SzcaPU5Fye8rhXEOxM+pTkIy0bo
         +l7wOjoNzGfMYCIwBAycT1Aaz0G9437XhnT1ogCUI/snrUb8DcvTgw03GBoSRASep+vc
         Op+mVELx58RrMFq7ttOG4usZWxeoz2UmuBFtfTEXIH5NJZ0Y6XFmC3CncebXxQ4EObj9
         Zj0wXzzU7XbmFArZhlO8cYyNLU/VuzmYJfokmGXb6gnP0gPLcaOwhCi9MTJBBXUOxXvl
         29tykDaB9+LwlFSywE1DcFVKAAkuUSHdd69lzdIp+dB3ZazPEusiW1tJJeVqH3P9xg3/
         lymw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=b60dkj/rL5SXirIPU8PUvzqJ6kZipXx0K/BtQImcJUQ=;
        b=sjorfry1AVz9ZICPGkg6TCU1SV2ESZ59AP3H3ITwWZEju526SYFtjE2Buematde5Hi
         540xf54gBvRIc+a7tVPeti5ES6spZ3EPqq7SMl7N5Ymruqio2xj03PlGxiESTwpg33BV
         ad29/t6dQETq6SNBFXEBvDfBA7Pz3VbohsqXxEbfB4wCh5LWGVdh/CJlwMrqp/+3RWrq
         zafNqmHej4zHAN3VV0LXEiRoQBJmmJeALgQy2qX1666lMLVb7ClDkTXR89yCb6LW1skH
         V+ZcJvsPMUHjVqNSLWALp5YHoDpLAkKXViQODk2vNfJdz6tlHMNOsCdkRrfsTo7xrt7q
         qFQw==
X-Gm-Message-State: APjAAAVaLJuXFoNSorHWp7zLsdVE6BNbSfFPo7ysgpTKS+WhiyCNBZNf
        LIZPzV6eSXXwDeqX7rkhYA56heSu7ouRk/ZSGcdhgw==
X-Google-Smtp-Source: APXvYqxdJib7V1FO2hn6Kv8fvlwIeZUyCKwcuzrUKriCgWTNZSxG8c+NaJLUgzHknP9SIzwV5UVUPTm3YjcOV74QRdI=
X-Received: by 2002:ac2:5467:: with SMTP id e7mr1188928lfn.74.1579574189870;
 Mon, 20 Jan 2020 18:36:29 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 21 Jan 2020 08:06:18 +0530
Message-ID: <CA+G9fYsnCO6p41f1ub45-o2RdKW4HwnN5XK-bhfBLUS--tt=xQ@mail.gmail.com>
Subject: stable-rc 4.9.211-rc1/0f7725a1298b: no regressions found in project
 stable v4.9.y
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

kernel: 4.9.211-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: 0f7725a1298bdfb6612898c01a4e7abb01f7e1a7
git describe: v4.9.210-81-g0f7725a1298b
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/bui=
ld/v4.9.210-81-g0f7725a1298b

No regressions (compared to build v4.9.210)

No fixes (compared to build v4.9.210)


Ran 23572 total tests in the following environments and test suites.

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
* prep-tmp-disk
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
