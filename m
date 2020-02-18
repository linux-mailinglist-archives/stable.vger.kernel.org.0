Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11642162A08
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 17:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbgBRQFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 11:05:34 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:40973 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbgBRQFe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Feb 2020 11:05:34 -0500
Received: by mail-lj1-f195.google.com with SMTP id h23so23601961ljc.8
        for <stable@vger.kernel.org>; Tue, 18 Feb 2020 08:05:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=MhoDrY1xksyweUpmgeFnGHrfMEpuPB+Te9aFe6JEUlE=;
        b=dBcao0ELwlJ062yEpsyZc9dBWFXDP3FAWLSM4oz1jwwZ0BYqNNN0YnGITrhAdcztsQ
         u1H98ZYGo0lg5t54k00dplymhRD7X3Phz7ZWw4HGEImIyEbUqyHiPWovwHAb/zASL+At
         hqvlAf+0kyEhkVEC7BmjzM02LltgQ4ZJxK12VWRywN881Cj+abTx4IHnERGsjMhs8hsD
         z9Lx9aYYEtT3e+U5e9yd6VvyT4gm8dxZG8V4StsUywaFqMIlGhoB1KY3ksuoG8MZ7fEX
         eC1Vaf9JmJ1fZNwMCKI9oH4Rcaf8TqVGwJkzRVOZv/nlO3p3j6tXCusymaQvr/tpgnXq
         sktg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=MhoDrY1xksyweUpmgeFnGHrfMEpuPB+Te9aFe6JEUlE=;
        b=KbRQfm3vn/A/cZbmpsu1v8xQGCsFn3Em61uvgZ7x2mOvm1xrq778SdFB/VinKuV6nI
         V39YeookVDSiTMgovDxPrzlsIUkWDZr6S57Zkzi8rq11mU5bvoVtevhet3OpLkoAenmG
         XTDEfyGl009xvzFuOCM7Vm7bJUtbcoicDApzh1BBTzqHxJWKIDrik2s9quJpBIrsD50J
         oti/8kPhlUrKLo04b+q0DkXURI2Ico+N2fokbtVKr0L+LNMDP66MbELH6wrEQ5D6h7FP
         xDGesU1AxYRYH8m8V8sVUtldF9ixesX9LuA2pIY8APp6oh6GDtOQqc8q7ge8FoWwr945
         p2aw==
X-Gm-Message-State: APjAAAWHNx8gX7WfkSvxPA9Q/cbLrGA9B8cW/Xa9NfG2O56LeFb0ybw6
        sdA/yWdBSvULG4rYONUmanI2bUyGrsYAdpjasji6yg==
X-Google-Smtp-Source: APXvYqwqKt1Be6NvzbWd/Riorqxg8GAiv6vKILX6E9+gGentcGI/XkfwCZp3U2ujA07O5n6LtNNz1sd35Z3LukUPz2I=
X-Received: by 2002:a2e:9e55:: with SMTP id g21mr13632769ljk.245.1582041931334;
 Tue, 18 Feb 2020 08:05:31 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 18 Feb 2020 21:35:20 +0530
Message-ID: <CA+G9fYsqZQ_Ag0NgwLfw4dGoj5EURSOWG8W1NBC65ZjyzM75Jg@mail.gmail.com>
Subject: stable-rc 4.9.215-rc1/3abbf084b7bf: no regressions found in project
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

kernel: 4.9.215-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: 3abbf084b7bf6c692bf1bf152bc18e0f0e54da4b
git describe: v4.9.214-12-g3abbf084b7bf
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/bui=
ld/v4.9.214-12-g3abbf084b7bf

No regressions (compared to build v4.9.214)

No fixes (compared to build v4.9.214)

Ran 23289 total tests in the following environments and test suites.

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
* ltp-cpuhotplug-tests
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
* v4l2-compliance
* ltp-containers-tests
* network-basic-tests
* ltp-cve-tests
* ltp-open-posix-tests
* spectre-meltdown-checker-test
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* prep-tmp-disk
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
