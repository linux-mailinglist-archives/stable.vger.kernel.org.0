Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D596E1E1BFD
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 09:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgEZHSv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 03:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbgEZHSu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 May 2020 03:18:50 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78417C061A0E
        for <stable@vger.kernel.org>; Tue, 26 May 2020 00:18:49 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id a25so11569295ljp.3
        for <stable@vger.kernel.org>; Tue, 26 May 2020 00:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=pNUvfoVpmOryrryg0nDeKSldBJ4ZhcXrVMayFySjZcw=;
        b=N2tdRMCtsqCkZYyvLSIid2TOd5sj1YBrPudfQ33SHC4tIQsE/1IJi61FA1WeCoxKHP
         qVw52ydxxFmPOwuKUg8bT1FHRwngq1IH3SQLWBcf5rd5KWDwtjRFLnrYlGEgV2VmPsms
         ynZeC+pJ+IGHyQQ6yd83qR/TclpypkVhBKMsgaxD/jZ2kbXVTYP6khLyUsiE7iK2dRIY
         JNjUA8HnEfq6ZnkfLbjFV/8HsHz61qceMrTXSuXPqqeiIFPMCNE1m82fY1tX7336d6sn
         e+qGv/5D0WnGzSU3/IFWydhDPy2knHjen+YAy1GzQBSRY012wGoevquQ8wZnjIsnuPTM
         snqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=pNUvfoVpmOryrryg0nDeKSldBJ4ZhcXrVMayFySjZcw=;
        b=miyQNXbscowH+iL00ZSB8DE9q29K8D/AZWlhahXPoLW5QKyWNX2+s+kCbsYtplvko0
         g8RNW/g9q7HlBqn26mdn74XV01tBOxxhnsRUARSG8+8qwqw6HZW7Blbo5RusVSBv798T
         PPJOJGAEibH+GqPc2zgEUd2w3sIlg62I5RuLEfPbJiJnEt2vu0svwy2sESDtkS6yjKAG
         141zPkIj6EvguEeIwTpKu3j97wZ4jff1Zv/5siF+icu7zMKzYRWsEgF5FBnOkIJMej97
         PIvyAaS4BP16H8eWq3i6dtl7oVFkLwymqqjoVqx3eUV5WT++EQEMDuuUwk0pIH+eh2wZ
         Kghg==
X-Gm-Message-State: AOAM531PI0hcguNcul/bQpYUk57Ug1dHAXHIftH/A6Ns0D8RkyljybNJ
        Xf8WCOCv5ib6wqARPxaWKno0nPR56K9F3gXQS7jOE+y/wCmEhQ==
X-Google-Smtp-Source: ABdhPJzeZ/k3ipCAzIVzyIa0dmhzUnGl4aVMgqompaLz+dnk9NDMFhYn81zhcr+Qqvz+pmfA6zCgdizWTVD9kNWtMso=
X-Received: by 2002:a2e:574e:: with SMTP id r14mr14184242ljd.411.1590477527710;
 Tue, 26 May 2020 00:18:47 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 26 May 2020 12:48:35 +0530
Message-ID: <CA+G9fYutnMLkJLcAT2Y_=Fqg31kc4eGBgzhH4Xi2YD1j=H+JkA@mail.gmail.com>
Subject: stable-rc 5.4.42/1cdaf895c99d: no regressions found in project stable
 v5.4.y on OE
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

kernel: 5.4.43-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 3cb79944b65a695eeefe570faadb81f64ecad390
git describe: v5.4.42-105-g3cb79944b65a
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/bui=
ld/v5.4.42-105-g3cb79944b65a

No regressions (compared to build v5.4.42)

No fixes (compared to build v5.4.42)

Ran 33015 total tests in the following environments and test suites.

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
* kselftest/net
* kselftest/networking
* libgpiod
* libhugetlbfs
* linux-log-parser
* ltp-commands-tests
* ltp-containers-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fs-tests
* ltp-io-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* perf
* v4l2-compliance
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-mm-tests
* ltp-syscalls-tests
* network-basic-tests
* ltp-open-posix-tests
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
