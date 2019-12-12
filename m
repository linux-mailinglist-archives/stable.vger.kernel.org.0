Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBEC11C538
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 06:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbfLLFWm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 00:22:42 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:44101 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbfLLFWm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Dec 2019 00:22:42 -0500
Received: by mail-lf1-f68.google.com with SMTP id v201so646622lfa.11
        for <stable@vger.kernel.org>; Wed, 11 Dec 2019 21:22:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wzhcMDq4+TCxRYN/nt+ZoSoZoc+6SpTKTgdCOUbXhBI=;
        b=r2exCgFhcs3GuOJzCOzFsa+yWWqlRMVHdxuUug7eTDnJJtn4BsliQXGypPnjY6Xoer
         oJbQvbDFjran7thIUTLwNm3DBrNjuSrEe1tsV5XlbyTJiAvlscrrFE/xJrBeWpp7P72M
         6iF50A9ZCTsO86S1nFmhFITnLVlbNBUYSK+gUHQBwRSWrwhDG8fgUHZ7rnOiqrjhNlnn
         Qbj9mE8mbOy0E7Rqb0fdZNCOeCl0FKyq63kOteS/kx3SwWPIO+Myxb9CuL21sMDuW3t+
         aTnSZO0lIfdjUYIUXax2GOLRGlp2gEpZoKRLUn1i0p/RfSBEphgdSeGeua0sUarf8dMo
         lBmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wzhcMDq4+TCxRYN/nt+ZoSoZoc+6SpTKTgdCOUbXhBI=;
        b=POM4AGQbqJJy6IJjHv1A082KAJ5k7dqRIxrKdG4jshNVqcLML5WTYbNdxlIiU2HV2s
         MIVjYVPmYhmITD+6h9ETfeFUoLssD/4uU8zVAesv2rYJv4kyk1DvGE8B73InU78M2ncb
         ro5mO919dL0/CJWAI88BopzAeTsRIt5i1FLaTBXzuR/2cyLugL912zM+F5TpU/1H76x/
         U8pgiBxuE1eR9b3347yofl4vI7+ykN8EranidVdFACk74cdFFKRW+eaPs5nNZJjDQ4w6
         A89aZ9ABhJuji+htncGOttf6eliyCzvASYATRlZRYxXyjhGldwCaquswjseYlNfu5Fus
         8XGQ==
X-Gm-Message-State: APjAAAWP+I2df7R/b3o5a56reH85WRPy0l5Vg3dn325tFMfi6pTy/nmI
        d8RiBHLtjz7R7mt2+Gd2MsyxqbgiaUiOc+oRxaHr+9vDd1k=
X-Google-Smtp-Source: APXvYqxEJlMtIVLswjPVSFssfuHRMnfmeBgBC7La44UThpIb3UuHWrinb6WpWHYo3Gjd5C5DZWeAxi2wDAYMZM7lw/c=
X-Received: by 2002:a19:5057:: with SMTP id z23mr4394079lfj.132.1576128159902;
 Wed, 11 Dec 2019 21:22:39 -0800 (PST)
MIME-Version: 1.0
References: <20191211150221.153659747@linuxfoundation.org>
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 12 Dec 2019 10:52:28 +0530
Message-ID: <CA+G9fYuqkq5PLy5Ai8cYBdc+fE+MtUJHZ4J-KOok9Gszv49AOw@mail.gmail.com>
Subject: Re: [PATCH 5.3 000/105] 5.3.16-stable review
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

On Wed, 11 Dec 2019 at 20:41, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.3.16 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 13 Dec 2019 14:56:06 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.3.16-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.3.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.3.16-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.3.y
git commit: 0b6bd9e917380a84aa7cc28de11f897e121cd092
git describe: v5.3.15-106-g0b6bd9e91738
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.3-oe/bui=
ld/v5.3.15-106-g0b6bd9e91738

No regressions (compared to build v5.3.15)

No fixes (compared to build v5.3.15)

Ran 20777 total tests in the following environments and test suites.

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
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
