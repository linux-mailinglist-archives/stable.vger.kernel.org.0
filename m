Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0646418BF74
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 19:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727318AbgCSSfO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 14:35:14 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:37954 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727317AbgCSSfN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Mar 2020 14:35:13 -0400
Received: by mail-lf1-f65.google.com with SMTP id n13so2503007lfh.5
        for <stable@vger.kernel.org>; Thu, 19 Mar 2020 11:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Kd0d7/UfgwdvzHgvQenbYu5RHBauEJYzFS+JlGbid/Y=;
        b=gv9AZwIsp1SJvB8Uk8IYTA1I48DAvESbD2oisd+5qNE88yL+mOAz0lj+jetszcOq9l
         1QY6yjLxg3Is4w1ijCI9nkI1KL98X/6cZlkdtbJas14J63ElMysDPGDMZ/TfguU3K3OS
         +gfPIFY1uMS2dsPrRGKW753q6III1KbEUTB7wLZshby8ciA1zlbERhdJDVyteK81wTBe
         R/+U5IFcRFNyj7BsfqpcSCJ7e/5ygsrBaEmTOkySWr19Tr0uj2aB03xQQPKlhKeeQNFM
         mqeJIM2YWT9FJ5bP6/6Ff0PDYTm6o1KOfH5sqn7B8mhhIFgDYgjAzl++3BL16lTnnoBg
         Gdbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Kd0d7/UfgwdvzHgvQenbYu5RHBauEJYzFS+JlGbid/Y=;
        b=KRUyZZZYbCJsmWcH3z9E3kvw+0QJvH4OwQqx++B0YawCZ7QpQUrf1PkEWPxFzplbuj
         9TjIF4NCQ8yl7JXL59aP+5kXcDcrrEyLjjBd9fOsPPyYU2cofkTM1TEyuy9ZwwWgzc25
         BmRD1ZO86uUvFd5hmAaeG+Ux6p01SeqwJ17SdKVpQR2RtSrxcbAAuFjpvfAPR8BS17Gb
         BFwdvfDhYyN/F0ZLsDYf8MN+vUg7cmLfv/kEgGMOj3xfYuL6N0QmVT+OHnAdNBy+06kM
         /92HcC7xjw2PIm5W69ieS461YgNSjqxR77Zqq9I2ui5YwvaJnw5MmnYEn9tkg6Y6Xasn
         qCZA==
X-Gm-Message-State: ANhLgQ0NCoTfW04t+mZZCZJYlDAaUqlsLQSiwkeZct8nnkT8pUuhI6Zd
        Xvd0ac4mTRijceh4TXXcwo3WZPLRSEKD1w089iCDpn787SDBRw==
X-Google-Smtp-Source: ADFU+vsbYsLejxTqmEHzkijtasIdRdQgtLiOSPjEqw+aZF2q8n0i4zqspGp0HuHbBHSB+MhrtBk0e+HZEyPsGRoIbMA=
X-Received: by 2002:a05:6512:3188:: with SMTP id i8mr3048513lfe.26.1584642911614;
 Thu, 19 Mar 2020 11:35:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200319123941.630731708@linuxfoundation.org>
In-Reply-To: <20200319123941.630731708@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 20 Mar 2020 00:05:00 +0530
Message-ID: <CA+G9fYvGcBzFuGFT=NsRb_uWZ_Sn04-MxKgLU9NGmrMSUNegFA@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/99] 4.14.174-rc1 review
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

On Thu, 19 Mar 2020 at 18:45, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.174 release.
> There are 99 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 21 Mar 2020 12:37:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.174-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.14.174-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: 5510299b1b08a51cf5805bd223de3e9453900d9b
git describe: v4.14.173-100-g5510299b1b08
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.173-100-g5510299b1b08


No regressions (compared to build v4.14.173)

No fixes (compared to build v4.14.173)

Ran 22239 total tests in the following environments and test suites.

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
* install-android-platform-tools-r2800
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
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* perf
* v4l2-compliance
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-mm-tests
* ltp-sched-tests
* network-basic-tests
* spectre-meltdown-checker-test
* kvm-unit-tests
* kselftest
* ltp-open-posix-tests

--=20
Linaro LKFT
https://lkft.linaro.org
