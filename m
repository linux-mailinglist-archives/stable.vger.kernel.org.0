Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30CE4DAEC3
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 15:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436795AbfJQNuy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Oct 2019 09:50:54 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:44100 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436854AbfJQNuw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Oct 2019 09:50:52 -0400
Received: by mail-lj1-f193.google.com with SMTP id m13so2624818ljj.11
        for <stable@vger.kernel.org>; Thu, 17 Oct 2019 06:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=p6nZR/9Zua3DBUg48vEj5YlDbRJuasAgse2qjxSDyG0=;
        b=aTsjheutNHe5MwDJvJZW4RNku/5SRLLaXe5w4XHpTIunmwpx0T1oQxsgApN7PjaE55
         P+2kTxXDA3TzYOCqyv1TcPQ9kmJ4oSZFTB/5+wzforLM4VJcoLH0o5jLyzqISi/atUWx
         y+DIw60egJgWRN/TCadXJ2covwHR2iyzOUKnqgqzt7t7hEK7LpS2rDxhz+WWaPJFMAOz
         sFv3MUCzbwuhXfseGJlwasKHDA+tnMsuYsHGl2rCCkn4GaI4nVMqQs/4zihAFp4VBYrZ
         dCGpkMS5y4CIMWBK8SuE55wpK1teF5WTE/f/DW2gMzZBSPE6uFX89wUjM0IORfVAOvxv
         Pwgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=p6nZR/9Zua3DBUg48vEj5YlDbRJuasAgse2qjxSDyG0=;
        b=JUKNBYR5obtsQ8Gopb+uEzeIttaDKNieEY/+36ViZEJGLVE3+5mVqYTWqDswXkyKe8
         NwVyxRGaKbU23w7zlmU81SFoSxqOdOm35VvN3jB5xBuXpcRyUE/13RKgHZXImPcYNZp7
         IR4YHO5bwRqRwbS5AjBclHb4Er7ShBhfL1UZZuE6hNIKAs1ebeqrj9jn2Mf+3FZ9Q115
         Hg99cmNatQ9F7qfh7LubzZYzzLI608Wgl9dj648wxEDAZ7vecn2pHmYxSQQLhrf9oXrs
         CXxJ/1Ky2tYA/rjY+iE6V/lxG8WAE6jUR4pE1kQXYGmkLZBpjUaUODAcWaHNbWOfJvqD
         nZMg==
X-Gm-Message-State: APjAAAUi/27zgQnZBKuQum9ElRFS5X1XyjZ37vg3yTooQJ3LqRZD3j6z
        fe6LTWLf0xn/HwD+ZV8sMA0FE6D8ckFUBBKth1AR08tpu28=
X-Google-Smtp-Source: APXvYqxsLEekNjXlvonl6W01f55s+jm+722adMbT3F4aVqSq4V3+hFuNs1+zd8cN0Wu8IFzcPvF/owb36ZacegEECbk=
X-Received: by 2002:a2e:85cf:: with SMTP id h15mr2712280ljj.141.1571320249772;
 Thu, 17 Oct 2019 06:50:49 -0700 (PDT)
MIME-Version: 1.0
References: <20191016214805.727399379@linuxfoundation.org>
In-Reply-To: <20191016214805.727399379@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 17 Oct 2019 19:20:38 +0530
Message-ID: <CA+G9fYvnW2RGuz0nkkfQdxpFc=8ftSEXmiS7Vz_B2H9RsParXQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/81] 4.19.80-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 17 Oct 2019 at 03:27, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.80 release.
> There are 81 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri 18 Oct 2019 09:43:41 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.80-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
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

kernel: 4.19.80-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 99661e9ccf9206876ca8f509555b7b0d3e45cc13
git describe: v4.19.79-82-g99661e9ccf92
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.79-82-g99661e9ccf92


No regressions (compared to build v4.19.79)

No fixes (compared to build v4.19.79)

Ran 23644 total tests in the following environments and test suites.

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
* ltp-fs-tests
* ltp-ipc-tests
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
