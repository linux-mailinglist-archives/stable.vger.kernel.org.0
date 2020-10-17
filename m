Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D35CE29109C
	for <lists+stable@lfdr.de>; Sat, 17 Oct 2020 09:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437550AbgJQH4R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Oct 2020 03:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437539AbgJQH4Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Oct 2020 03:56:16 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D11DC061755
        for <stable@vger.kernel.org>; Sat, 17 Oct 2020 00:56:15 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id 67so6793961iob.8
        for <stable@vger.kernel.org>; Sat, 17 Oct 2020 00:56:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eeJRitbwnPEjMGDAswjdWZJQPMXqea0MWxUvLCrKIe8=;
        b=fQTsui2nq+dEQbjtVAi+6auWqLFzWYsJGNhS+sSBVVe9TDbCyasl31EytKoeEMB/TV
         bsTKuyMwufHkTge/xOII5YnG/q+HNLmhLMBCQZzW3COgMsKSLkKBvZfVMod+5LfpDY8I
         2OkvKDnZShKflX/rXSOL69NbsdmLJ9m7a4dvqO37ZqO6XbvNz5yWJ7L3e2ljmag0VAwh
         9uOks2CoWsuT3PnGdFXpSoD1MGSIEtsNuQ0XOlMyATM1Ky/k7QmF1OiwaAEK75UIiQIZ
         Oh0A3vnnNo4NAU+ei7wga7i6o0hhi8pQfBPXsvJS3MT3Jr7M5BeJcifkQO50ku0koWme
         g9gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eeJRitbwnPEjMGDAswjdWZJQPMXqea0MWxUvLCrKIe8=;
        b=owsg/gdRAWspagLCyYkR3yRsZiwSM9Ri7TiRk8dRimkOceAVY4IctH/r/bZmhKUloD
         fFgiLte9k0WvYC3nwNaAT+6c/pe9OsyP0Z4f75hJVCBgj4m3JIPGkySRmY7AKsFDhYCo
         tho9OIsBcDv7HYQEZxzmKXWJHdBhgsVziXyq7t2LBATkH+NlIMJ5OKQOGLm6QRGoKdQ1
         KbrVVVCZ/6wT0S6CQ3frIETU4E8TY+tceGaOxsrEaUoVZ+QykiXUm2ICAWd1StcXXkcA
         meRPpHKsLRNUwynGWlbqnto3Jc2ZSkwi7Np84btt2VZgDEJRhzLJlvXmPzAybJog081C
         HAlQ==
X-Gm-Message-State: AOAM533zPb/1L7qoztO/ENHjpIrvei7BbxTbntA4J+/8k+Wc7RWvVeqI
        qw9poszuCwwD2kcAARutaW/zqpi6UWwp8wiw3VxyQw==
X-Google-Smtp-Source: ABdhPJzL3bAQA0diWHzlJsviIewq/7uIeD6vEKRBQLicAE6d9cDxd8xKWzSzERbY3iPVM86yC4BirP9GkI85BkQLisY=
X-Received: by 2002:a5e:9307:: with SMTP id k7mr5212937iom.129.1602921374727;
 Sat, 17 Oct 2020 00:56:14 -0700 (PDT)
MIME-Version: 1.0
References: <20201016090437.205626543@linuxfoundation.org>
In-Reply-To: <20201016090437.205626543@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 17 Oct 2020 13:26:02 +0530
Message-ID: <CA+G9fYsWa2=LcL2xsS-kTVgdi9-c=X3V13dzbMvpuXurbjWL7w@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/16] 4.9.240-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 16 Oct 2020 at 14:38, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.240 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 18 Oct 2020 09:04:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.240-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 4.9.240-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: eb0fbe0c6b1c2863b26464de441a406275c47b6d
git describe: v4.9.239-17-geb0fbe0c6b1c
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.=
y/build/v4.9.239-17-geb0fbe0c6b1c

No regressions (compared to build v4.9.239)

No fixes (compared to build v4.9.239)

Ran 17816 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
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
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-tracing-tests
* perf
* v4l2-compliance
* network-basic-tests
* ltp-syscalls-tests
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
