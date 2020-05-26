Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE2A71E1AFF
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 08:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbgEZGKb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 02:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726207AbgEZGKa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 May 2020 02:10:30 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFF01C061A0E
        for <stable@vger.kernel.org>; Mon, 25 May 2020 23:10:28 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id z6so22983144ljm.13
        for <stable@vger.kernel.org>; Mon, 25 May 2020 23:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=dUWhZBX3NM/G2CTzj9zjRqoBWSUnCMjAZucQocwyWzk=;
        b=FsyNWIKtz0hmCYfI1UG6uUlofKqp6XbGaOeKeEILVpwvxfYW1KGlhqCfaUErpH8pnV
         x3kG9SwjygHgRnM+hXv0f3Od0sItmNcqJtgIjltjXfQ8XItRGM74UAnSieH48xMHUiwN
         zdSPwNK388S0AsL6ZKDGtQIYXAENTeXxE3CHzWc6Vt5fiohyc6sJQ2QwQtl+5vsGpPB4
         aG9Ntwy+pi4IxGFNtdJSKbITFpU0OedLpqxai/5sbzr5KzebDXIaAIa55B338tyba33E
         ttvD7TN3Wxg6doPz/+yjiBL/pbXtCunKgxRx+346rEIrJE+Ujs4Y7lYNm8hfWryGkj19
         2XXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=dUWhZBX3NM/G2CTzj9zjRqoBWSUnCMjAZucQocwyWzk=;
        b=EkpCflogekdHCPrB1vhxtTYx3fwzNu6hynbLO7vgSqbxHQZRuOSj0Ryk3by5C9g136
         y9evXN3RuWhS3v0S/THEvfzdDszff9zUyl8aIOjpsaz29T7DK/bzUnSQS6jSL128WCob
         hQEg3uMeoW9zaJ2hpwpU5YMJAWnUN3atteE2CgMjdTuRu2MegI9pdMnxWTgzVW/CsEp8
         3OSooD/kQH8pNRSvHLPPS697dhx6/pIOejT5gxWwpNASQLDKj4awIMG6G8yP9ctoFrpQ
         +kQPDj0mPI+8+IURJKlHppXcAv+NHNAilueNiyrDdqTNtPN/uq406/GN0rKhjOdaic9q
         WTjg==
X-Gm-Message-State: AOAM533g7vBpgjC1VtLd7799mvsn/1EVnEfVumkNH62twikisavMyVmu
        0NhYX9btJP50pFoIMkpJnZRiESY5dXKnELaue/TxiQ==
X-Google-Smtp-Source: ABdhPJzygaYb2+VzR9dVEYiEZvDQoqhnByEjoeWByatwmP11LA6AEkok2MWbe7yvmxkDJ3dkGCVNVuWE6iw7zl59oZQ=
X-Received: by 2002:a2e:9684:: with SMTP id q4mr13580229lji.431.1590473426985;
 Mon, 25 May 2020 23:10:26 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 26 May 2020 11:40:14 +0530
Message-ID: <CA+G9fYuPpgtmUwY4jVtVu=8BEZh5L=Pam7S3ELByA99_nW06aw@mail.gmail.com>
Subject: stable-rc 5.6.15-rc1/8f40203f4915: no regressions found in project
 stable v5.6.y on OE
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

kernel: 5.6.15-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.6.y
git commit: 8f40203f49158f3292f524ed280268758f8c9f30
git describe: v5.6.14-121-g8f40203f4915
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.6-oe/bui=
ld/v5.6.14-121-g8f40203f4915

No regressions (compared to build v5.6.14)

No fixes (compared to build v5.6.14)

Ran 34934 total tests in the following environments and test suites.

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
* install-android-platform-tools-r2800
* kselftest
* kselftest/drivers
* kselftest/filesystems
* libgpiod
* libhugetlbfs
* linux-log-parser
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-mm-tests
* ltp-syscalls-tests
* perf
* v4l2-compliance
* kselftest/net
* kselftest/networking
* ltp-dio-tests
* ltp-io-tests
* network-basic-tests
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-native/networking
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net
* kselftest-vsyscall-mode-none/networking

--=20
Linaro LKFT
https://lkft.linaro.org
