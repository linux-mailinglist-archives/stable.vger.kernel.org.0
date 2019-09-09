Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D870AAD2E1
	for <lists+stable@lfdr.de>; Mon,  9 Sep 2019 07:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727256AbfIIFyd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Sep 2019 01:54:33 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:43011 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727254AbfIIFyd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Sep 2019 01:54:33 -0400
Received: by mail-lf1-f66.google.com with SMTP id q27so9437560lfo.10
        for <stable@vger.kernel.org>; Sun, 08 Sep 2019 22:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7qYxqgJDwIoCELxjYRQsJBCV5/VRMnMAsms3cMrB440=;
        b=WLadTME2icLq4x8Mxgvv0S3og5kAQKr9f+wvtZNLXhWgqVF1qqSOak5XWzKJ5Mowud
         vDGH+5iqnQsLv/u6iiFjk8/q4JSIFGUyp2N0GzPIxUU3CcRHoAnJQbzJM5DzvJPTxC9S
         QRu7bTGI642LLaftytBWtZTDXrI770rLFoaTmiYYWu4p5FgRnA++5ZANxt1JBy+ogAfS
         HO5bh9g3yHv5TpnjPfANNem1slkJnUTx+ynR4zZ9xRFhtTm8E2SkRhYx39pX8lX1TwOs
         Hau0XufatQEuboKuL8lQQ4Qm40mWMj3JsInPuhZPPnLxETWd0ZGNalxbmlIm8F2j9k+/
         t84w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7qYxqgJDwIoCELxjYRQsJBCV5/VRMnMAsms3cMrB440=;
        b=nrak0pCiuT4bL6EMeWyO/S+PeZSIUf3OSagpuxGMVygRjh75e5Kme6/Lwk6KPubyYt
         nC4kFNU8Giok4T2ysm0810TFNtallwrt6nJ4fE7Qd2NPQRf8Pg97WfNXTHgabW40xA4E
         y0pSG6QJfxN9ceBTMRBc6j0yqZtGeaEpKObej2VuXrA5foZaHZKBgbC+4Zr2bN9HHLy6
         0AKrOfpb3jLja6MIrMgg9eRDX7+AT/oQAx+F0GcXSfAuwWdVMHRiOtX8bMY7CimJS4vi
         ItDmGzKibnlSsw0ypDJmPkkwL5OaphUabKvdnndrav9RQBvw6Rzrcf2ySfZaFKpfumIc
         fIjA==
X-Gm-Message-State: APjAAAUmKuqJ2Gq3R0YwDd7xSNC7MHgeKZhw3G64xgqVbT2+pWzBCIYE
        fd+Ydig4ayzA8rNnMqMf6abgfd+yvKo6D5tkOtFh9g==
X-Google-Smtp-Source: APXvYqylIHiXo3LR2aw6zlnrmWjTeSA14mfLZkAcdu7LK/oEkJNa9niulKgGv2lfcGzPQMpcm2ieCMVWoXxIjwn0F44=
X-Received: by 2002:ac2:4352:: with SMTP id o18mr15415365lfl.164.1568008471345;
 Sun, 08 Sep 2019 22:54:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190908121150.420989666@linuxfoundation.org>
In-Reply-To: <20190908121150.420989666@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 9 Sep 2019 11:24:19 +0530
Message-ID: <CA+G9fYuQzkppyLeS0zhoaZxnT8A4d9jyErN_ehFBQRwKLA8nXA@mail.gmail.com>
Subject: Re: [PATCH 5.2 00/94] 5.2.14-stable review
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

On Sun, 8 Sep 2019 at 18:19, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.2.14 release.
> There are 94 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue 10 Sep 2019 12:09:36 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.2.14-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.2.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.2.14-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.2.y
git commit: 562387856c86ea4a3aa5ba333cb9806f8065b6ab
git describe: v5.2.12-97-g562387856c86
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.2-oe/bui=
ld/v5.2.12-97-g562387856c86

No regressions (compared to build v5.2.12)

No fixes (compared to build v5.2.12)

Ran 22530 total tests in the following environments and test suites.

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
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-fs-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
