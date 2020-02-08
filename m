Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B524B1565A2
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 18:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbgBHRBl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 12:01:41 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:38669 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727377AbgBHRBl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 12:01:41 -0500
Received: by mail-lj1-f195.google.com with SMTP id w1so2571441ljh.5
        for <stable@vger.kernel.org>; Sat, 08 Feb 2020 09:01:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=cR1tnT7Tdm3bttd4BktkV2f7kuls86nVU0Jxp4bk19s=;
        b=gepQ3q1OJ2vwuMoURteFMvw9Cm7iQJLGbUkaJ5CY1oQmzMjuGSZTHUG6gZuoXO+gZK
         GPh2w5sYRLuY4Wovdkxmjmi2qhIPrGEZt+5BCQhaoZUvHVWlVUcO0mHFD5GKrgCglF74
         1KEzGxMlkmrdjnVxv5OFcCN+9o08Kk9lTWxWHFHTebe0nHN7lPvQAyeBO5RcRX+7wzC7
         F8X+R4cJCsdyF9D8NldsL4QX/coR+tuFkrQjwj9T4oPdjZh6/z8Jz9HSPqFtd1tukfrv
         oM3AtHtUEk8gpxCqmi+wIeSDvFsSLQzmD6aAgNyqCZXEihYx83YxJiKfE6Wq6P3pojvy
         o8Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=cR1tnT7Tdm3bttd4BktkV2f7kuls86nVU0Jxp4bk19s=;
        b=J4E4oK8L+CU9giSHb4kylYqv0TOe6GtqthrbhmOwmDAYKBzHzN3s9Z1iwPBaOKxfnz
         hLeChspYatp+eHowjf7jYtZNfVmNvFrmH+Ei/lhVY3aJqCvAZWXWoG1yCz34M1unw8Lq
         E0Rp6yeevFVUCSPGPesM67T2sWWbtWjSllZJxgO++aoB6fuChiUShRMzKDZb/NlwjADH
         Z724MPVmRpENHUYy4S3FU3lVn5h4o3Wrp6x03fav5zI4+Ffb3xBcNtNaYKz42ELbf/6Y
         D26ywbhYy4cQj4zoAjjhRhwLj2IFV7PeeHnZnJuM/C+rVGbnWC7p7QpVgPa6Jofp52ZN
         cw1A==
X-Gm-Message-State: APjAAAXPyTeoGaicZhYXoFD7YxxxEtWKFkjGv+7WXEwpJJ6WT4pdS8gR
        zFkbAYcgltUNTS0lMaRXHSd2bBPY5yDIOCwhnXso5w==
X-Google-Smtp-Source: APXvYqyr+8XS6ilaIvn6GwTv4D1BmgWtg9kzrLqcdUsZPvnsP2y21hRG5mmA8R9TGLdvI+KgU4qANHIoC/HcrWCY99U=
X-Received: by 2002:a05:651c:1072:: with SMTP id y18mr3163114ljm.243.1581181299303;
 Sat, 08 Feb 2020 09:01:39 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 8 Feb 2020 22:31:28 +0530
Message-ID: <CA+G9fYtAn=MKfHUjMkR_W+Qzzb8_JSWwp_fjKJyQBrb4A8DSdQ@mail.gmail.com>
Subject: stable-rc 5.5.3-rc1/829d9cd3098f: no regressions found in project
 stable v5.5.y on OE
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux- stable <stable@vger.kernel.org>,
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

kernel: 5.5.3-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.5.y
git commit: 829d9cd3098f3f7237d3a6a417c29903d3208315
git describe: v5.5.2-154-g829d9cd3098f
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.5-oe/bui=
ld/v5.5.2-154-g829d9cd3098f

No regressions (compared to build v5.5.2)

No fixes (compared to build v5.5.2)

Ran 15358 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- nxp-ls2088
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
* linux-log-parser
* ltp-containers-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-io-tests
* ltp-sched-tests
* ltp-syscalls-tests
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* kselftest
* kvm-unit-tests
* libgpiod
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-cpuhotplug-tests
* ltp-fcntl-locktests-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-open-posix-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
