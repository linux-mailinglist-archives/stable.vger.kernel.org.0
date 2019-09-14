Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62F8DB29D8
	for <lists+stable@lfdr.de>; Sat, 14 Sep 2019 06:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731410AbfINE0z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Sep 2019 00:26:55 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:34889 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730038AbfINE0z (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Sep 2019 00:26:55 -0400
Received: by mail-lj1-f195.google.com with SMTP id q22so24345949ljj.2
        for <stable@vger.kernel.org>; Fri, 13 Sep 2019 21:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9lFWd6kiv6sw8TbtzdkKfO9t28tEt3gScaTf/lER1/4=;
        b=A23EhGsL77XuMEusQdxWaLsvAqiFLa2FfVO+ZoBflT1SWirALLHVu6FlDmUwNaGzZL
         by4ddd1os29OgZRGOdtwDPl8ZG6KbhSxCNo5aY4xvu29GSDdPJRPDNdFVZ7dSW+4jogp
         jseACnsxE/rbCZbpZ9oQ9dSZzzJ5YZvppB5m1norIbbbo4QqtEaJC3hhXUs6yxTFTWWs
         ahqJZx3mDS4glA7mFE5OKfRqmWrmYzPDENv+rykYYVU4InpK7g03byM+zSCdJ75AdS9E
         M1ra0GX5dy1e/T02j5HE+67+gcYHR7AcDLBTxXue9qeXC1cJIO5EZPejg8DjlzJfzsvL
         UhHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9lFWd6kiv6sw8TbtzdkKfO9t28tEt3gScaTf/lER1/4=;
        b=gzBdcTzDNZHVhxxyvzZJKn9lmbgtb4qZBQfxEpRwmCVQQM4JNLvPx+z1kFEWvaUzwi
         KSinmNwXJkl/c3tE/J5QMtyJ94gtxSNlLbZtIijQejdsRNSPDF6NVDAkNIGWwe5/zRCL
         rdkTptq0vQk/78o/DiWhIV81Ijg/ipkFbKrLzPFCJqE8oWgIop9Ha+Uu779joZGd1tZ9
         U+dFgemF+AI3jz4o73zmLSbel9Pc23h//yC7L9bhTGW8XsX0ZSSWg9CtYcMFzfVtU+o4
         W3QtgnKNOCxMJy0ndwU+uvjpRMRT6wDc1uufFoTng1yJYWaWv88+euvlDXGsHA4u+u6r
         kZiA==
X-Gm-Message-State: APjAAAVgNtJWck7Pu+KgRpxAV7CSOtiDZ7u8l9dVnXu8qXfmtrvNqlwv
        UnTKFirKERvTE4CiJSpoCsCZ7z/RAm9gjXZmvu9af0c5+AM=
X-Google-Smtp-Source: APXvYqz1pNxiOHlxg/ggI888pEPSBtjHEluFu7B2Bdq3qQa7/Eh0htOj24JHmmCqW/JjgX/VabNPDCaKzBHImveHSyo=
X-Received: by 2002:a2e:3004:: with SMTP id w4mr33035505ljw.21.1568435211665;
 Fri, 13 Sep 2019 21:26:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190913130510.727515099@linuxfoundation.org>
In-Reply-To: <20190913130510.727515099@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 14 Sep 2019 00:26:40 -0400
Message-ID: <CA+G9fYtx=GQDwCSNmyQcg+yQqJDPVgTyxXUjyb-4x7_pNn-Meg@mail.gmail.com>
Subject: Re: [PATCH 5.2 00/37] 5.2.15-stable review
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

On Fri, 13 Sep 2019 at 09:21, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.2.15 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun 15 Sep 2019 01:03:32 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.2.15-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.2.y
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

kernel: 5.2.15-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.2.y
git commit: da2614d2744ab16514a2288de2039732935749d9
git describe: v5.2.14-38-gda2614d2744a
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.2-oe/bui=
ld/v5.2.14-38-gda2614d2744a


No regressions (compared to build v5.2.14)

No fixes (compared to build v5.2.14)

Ran 24151 total tests in the following environments and test suites.

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
* ltp-commands-tests
* ltp-containers-tests
* ltp-cve-tests
* ltp-dio-tests
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
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-fcntl-locktests-tests
* network-basic-tests
* perf
* ltp-fs-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
