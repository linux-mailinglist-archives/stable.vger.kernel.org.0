Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1BFE3391F
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 21:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbfFCTdf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 15:33:35 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:33240 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbfFCTdf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 15:33:35 -0400
Received: by mail-lj1-f195.google.com with SMTP id v29so6089104ljv.0
        for <stable@vger.kernel.org>; Mon, 03 Jun 2019 12:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wUI9gVW/nhS4vRXB9vYqoY7kmuY4RLTiR4+fvOgFm+s=;
        b=N/BIVHvdFRvgSUtBS3ONW+AOMV95IreRw4yLbu2K5LEQCd5lKtjoSCDfIU0X++Z/12
         HEjxGdIfZJ/EhnyURl8FxKStzLIhlOoP2yuRy3mWV2WGxE2jdQNCtt4eP3f6JdhVnZMT
         zWaSwbYzHHbzdlaLaV9SNzsEYOD6YhPzNB/23hm54TkjnFUIYz1ia6uf5dCyMCNnwttr
         cHh6+mcVc3Xl495VVfJ/NLcRBoaqh3gg2N69oyfqS9a05OrX1Thm8DUtXzqlEOuA5Q5z
         KlhqA53Q+CgNVdQA9AQUx5XjZZxsKz8kY7lLwkanzeqvPRiInEvHdjFV9/ve4NBDINln
         yuMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wUI9gVW/nhS4vRXB9vYqoY7kmuY4RLTiR4+fvOgFm+s=;
        b=YTPNBn/h18sZvoxmxxyemdZ/p+ytGm1dtw/gcMLW6bn+cy0L0oDyGRLcsNpgqNjsMa
         Sey0x/fOfnl4t6GOPncPgVL40k8PHXUlKUnz+CEavHuIdtA7RN/2t2OzmP9Tu8tkgrep
         P+ES8IxF6f7zt5zHM+cNBDaiADbWwb+/DBu/4xrtbeal2zxy2X+nuErV5W4eODkv0BE8
         lOt/RfygO/dINr/QyBx3ExR9I6UP/3L2rdLkQ18mZjrbyAF6iBemqd2VSERYQlPybd8h
         IuzIe1uZ+xd7i2wd1m3fMSsrRYuTtDU7FqGkICclJfnPpjfIrjz4Ykn0xSejt2PWqLZY
         7Z9g==
X-Gm-Message-State: APjAAAU0qvC62SYAtTgDnflyKJuopWPi7HnBzA0iLV09mH2xNJNho6lp
        4l7lnHWF9brdhK0qcW7354r6WEHT/6ZY+t2ks+LUgQ==
X-Google-Smtp-Source: APXvYqxT7g0rbBTauSgvhQL3bVoe+CkOBjODQONbh8Zv39m/18ueK374i+T0hrk7cZSf2hURjOzZLZ7i2Cdpm2DJafI=
X-Received: by 2002:a2e:90d1:: with SMTP id o17mr14959183ljg.187.1559590413365;
 Mon, 03 Jun 2019 12:33:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190603090522.617635820@linuxfoundation.org>
In-Reply-To: <20190603090522.617635820@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 4 Jun 2019 01:03:21 +0530
Message-ID: <CA+G9fYtDyv34JNgrT0gw7NbJXWC2p8F3_zHJUjYGiSE4kefK6A@mail.gmail.com>
Subject: Re: [PATCH 5.1 00/40] 5.1.7-stable review
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

On Mon, 3 Jun 2019 at 14:44, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.1.7 release.
> There are 40 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed 05 Jun 2019 09:04:46 AM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.1.7-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.1.7-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.1.y
git commit: e674455b924207b06e6527d961a4b617cf13e7a9
git describe: v5.1.6-41-ge674455b9242
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.1-oe/bui=
ld/v5.1.6-41-ge674455b9242

No regressions (compared to build v5.1.6)

No fixes (compared to build v5.1.6)


Ran 21177 total tests in the following environments and test suites.

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
* libgpiod
* libhugetlbfs
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
* ltp-timers-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* kselftest
* network-basic-tests
* ltp-fs-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
