Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFE70EF5E5
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 08:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387499AbfKEHF7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 02:05:59 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:39268 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387517AbfKEHF6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Nov 2019 02:05:58 -0500
Received: by mail-lf1-f67.google.com with SMTP id 195so14214198lfj.6
        for <stable@vger.kernel.org>; Mon, 04 Nov 2019 23:05:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GIrprW1y0qd6DHcWgNZe4YGetGU2O9nSygDm9m3KcNY=;
        b=fqaqXJC2EY0H4UW683zTh+oZauSq+H2bUiqit1GjGpUEkFj2MsaTDwDRsWJj7CUnjA
         ge8bUfXf4RuntZc1/S055AjybL55dzSYsbpRrHENDCabiTiog9XGEmcRAgLA+gzzkbub
         wSibvXDaSAZbOZwgQ9aPQTrMDg+OlzsPIv5HjVuURiMS+lS40cfAA6zmg8amK3+e6oPs
         C9fMtj/1MR7cA/+Om9wN5aHIEU8OPmQMetpe3l1J/M5LBSxsKz+gLKD83uvHwOjH20i+
         Rt65i0VBvz6RCFOyibpMeHbdOCMlrNZzu5yUCodEWYu85On9fAA0SkPW1E/IC2LSihVK
         Wgtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GIrprW1y0qd6DHcWgNZe4YGetGU2O9nSygDm9m3KcNY=;
        b=cxngbpI+BY99PgEvWEiNuDD9mYrRSpzMA6aUZ52MXH6PeX36ztI8m9UpMtT+6B/nnH
         qIImUkgMdn4myJLG+66+mXN41Yxl4pZCXn46Co0dUe6cAReS8tsb+jFpsPtB+UWBF9Ss
         7xai2QUWVRALM/DF4GtFVDpQx9MzxMHDkNm0VTXoQNZiwEVMkvZ/5fbezzP5QD82+HmQ
         9ULrhe37yl76GFM6gGWuf0Hfs9RDtnO8bZmQ1OjoxCu4vltyERNQx7pieO4mKxQf7FXQ
         TPB/yTInn3HS6I8MPN+4aFF9nNpGyd7q9h/kRhQFzs+qxtJHfcGFRlX8clyBnVzn/WgR
         zp4g==
X-Gm-Message-State: APjAAAVScGwluo3CvaZNP8Hyovd4qpB47VPRYplJgLhMqopFgPAqaQ9N
        ZjVaSDCQmEussppWSl0VaAn8kwwNLBpxl3BVZ+mggQ==
X-Google-Smtp-Source: APXvYqzQWeI8PVGEmJUXw3Vq3vMvLm/Ci0aI5voCCnbpz7glQokamUg6scHv//dMHLvGen+y6oBcJEj412qy13nbE94=
X-Received: by 2002:a19:f811:: with SMTP id a17mr19027925lff.132.1572937554336;
 Mon, 04 Nov 2019 23:05:54 -0800 (PST)
MIME-Version: 1.0
References: <20191104211901.387893698@linuxfoundation.org>
In-Reply-To: <20191104211901.387893698@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 5 Nov 2019 12:35:43 +0530
Message-ID: <CA+G9fYtGfv8PF4q+fo8QfNc72XrqswcFvHE2XD3=M4EyJRT7hQ@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/62] 4.9.199-stable review
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

On Tue, 5 Nov 2019 at 03:20, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.199 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed 06 Nov 2019 09:14:04 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.199-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.9.199-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: 1787d5fb47ee9c16fabc1473a713bfe3f3af7df7
git describe: v4.9.198-63-g1787d5fb47ee
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/bui=
ld/v4.9.198-63-g1787d5fb47ee

No regressions (compared to build v4.9.198)

No fixes (compared to build v4.9.198)

Ran 23491 total tests in the following environments and test suites.

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
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* prep-tmp-disk
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
