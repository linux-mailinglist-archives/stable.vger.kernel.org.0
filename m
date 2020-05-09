Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD3D1CC0D3
	for <lists+stable@lfdr.de>; Sat,  9 May 2020 13:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgEILTO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 May 2020 07:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725920AbgEILTN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 May 2020 07:19:13 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE6DC05BD09
        for <stable@vger.kernel.org>; Sat,  9 May 2020 04:19:12 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id z22so3506460lfd.0
        for <stable@vger.kernel.org>; Sat, 09 May 2020 04:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EgBmZj0YP5lTWm93pdMnUd2XVLO6BkksVU5qHErJs8Y=;
        b=xcmiKObjaM5wyKpC91Wsx5JQQBvFdiIX2OBBszA7/5tYMi2ItnB0SONo9Ad+IZz6x6
         0uSTjbQp9+jYDyCVFX72QfHOr/gZrt6uzc9HQ2/Op9Q7gWS1a4bjN2vlSdbyia8FA/iW
         7WHeY21k+RCQua0JnhnxJrruXa0Uf1RK310ZTciN2CBbyD4icv8qF+D0/8dsb87wpZp0
         WtMBQkCFAag4jYjtB0CU70GVTal8gM4KsDok/xzk4CiysNpofNjqmycoEPxkLGjFgeZE
         My7zUS3/UAeN2rbTFyCoWA24xlF1V67Zu8sL0KT5QnI5giTPpAMBj7UpOjbbYoAyVs1p
         LgLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EgBmZj0YP5lTWm93pdMnUd2XVLO6BkksVU5qHErJs8Y=;
        b=Syl/V27VBG4O1unZYZeoNH2DAW8a7abVU0runLbG3TcV+YRm53SHeX5c8bJS9ktucN
         uuRKHMcxBe9nXzSu7JwRCiRED6f6PtKnxJLf2NzEoQ6XWtldJvuW8wu6bcep79ul6Ta5
         e0U/o44+pnoj5OPBediMT7xq/g1eIwShCPZ9xQNsrkiyQzvyk35QSrr1UUlypQOLnbO4
         rinYTIKT+C+WwhDUV1clnYgaU8FqXlJQPLLU0wN5ykkH1E2G893UBiF6ZXSKh1d/ZjYU
         aFM35H97Y0Md2p9XadOdbOWhL906bBIDYPcgppEksmNZYDr+LFnxQSFe+KSfkEUvEARz
         t0jQ==
X-Gm-Message-State: AOAM532zNiNJHCRnHwp+xmFJBWVaTZjeszS6lJyDfCbu03h1XtP+WYKb
        JYmexu8uRuuYXoauD5nlmC7PaXN1wvZcii17JQvBRQ==
X-Google-Smtp-Source: ABdhPJx5e/hzmoQSQuLG77jg8aLECA0q/iupm4JGBG2FSQvKZNRkkaWp+xx0z4IRNuVmrVBo9hQEFqNSmWtpaGr2lM4=
X-Received: by 2002:a19:40d2:: with SMTP id n201mr4822268lfa.82.1589023151208;
 Sat, 09 May 2020 04:19:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200509064507.085696379@linuxfoundation.org>
In-Reply-To: <20200509064507.085696379@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 9 May 2020 16:48:58 +0530
Message-ID: <CA+G9fYvMHTSev0Me8z5AmVVhN0OVPiQ7gtx+xoOTEh=+tb31VA@mail.gmail.com>
Subject: Re: [PATCH 4.4 000/306] 4.4.223-rc3 review
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

On Sat, 9 May 2020 at 12:22, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.223 release.
> There are 306 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 11 May 2020 06:44:14 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.223-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.4.223-rc3
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: 211c2a20b085f3c5c4092afea4c10dd2bccaf96d
git describe: v4.4.222-307-g211c2a20b085
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.4-oe/bui=
ld/v4.4.222-307-g211c2a20b085

No regressions (compared to build v4.4.222)

No fixes (compared to build v4.4.222)

Ran 20110 total tests in the following environments and test suites.

Environments
--------------
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
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
* kvm-unit-tests
* install-android-platform-tools-r2600
* install-android-platform-tools-r2800
* kselftest/net
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems

Summary
------------------------------------------------------------------------

kernel: 4.4.223-rc3
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.223-rc3-hikey-20200509-718
git commit: a9b5de1ee99dbfcffcc1d5a7cf13b8774b503461
git describe: 4.4.223-rc3-hikey-20200509-718
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.223-rc3-hikey-20200509-718

No regressions (compared to build 4.4.223-rc2-hikey-20200508-717)

No fixes (compared to build 4.4.223-rc2-hikey-20200508-717)

Ran 1814 total tests in the following environments and test suites.

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

--=20
Linaro LKFT
https://lkft.linaro.org
