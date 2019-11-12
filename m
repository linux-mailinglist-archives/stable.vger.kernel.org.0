Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CADDF8835
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 06:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725783AbfKLFtq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 00:49:46 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:45697 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbfKLFtp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 00:49:45 -0500
Received: by mail-lf1-f68.google.com with SMTP id v8so11730882lfa.12
        for <stable@vger.kernel.org>; Mon, 11 Nov 2019 21:49:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CMSkF3qF4fD/iGxqQwLixgivqCiU2ng8PohKJBqAxGw=;
        b=abZDZgs7QSzieW7JY9X/OsbOXf6acYJWkThWqQYRaXIZ3w2v9mlcfxkBCz6ku2hf31
         Chmwsz/u6cOZCWfjzAdx69213pgYrdWCY0os1z4FyaR8QGdDY7ZhLnt3M+yrk0sKwDAi
         WxcbEkFgxFUkFIUDbzv7i/iHjfEhKnpWJVLsgHPd9TyAmGKoqM39DBWKs9FRS/8vzuOQ
         4X1/zpIp+ql6HUcC5kOUsYCt4+6vtQvOx1n3MK0GoSHEcO8lWqPrizw5wWOKgO7hf8Oi
         LOQpl3msKDWxZLsLzEvovGZKzsVnZ/nNw35YB6lEl4CD/XKNlKNYlfQn3aPoIPcCgRUw
         yG/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CMSkF3qF4fD/iGxqQwLixgivqCiU2ng8PohKJBqAxGw=;
        b=gJcQSOqvZ9WnvaBeKTaZRJ2+6RpyuasIi/hmoXuJultsENsZugTfY2Pr1pESaGDUqU
         JeQ8NNfg10tXIgSCBIFx5ZZNtcWAvPxEwHn4Bxt06ExEur3reWnjkOj+RBfZGbktykLL
         x1GENbXVUiyMC7m1UGevmMvdjd6n93gZADTclo799Sc1gp3QDHTxopOAgplJsUKERjAZ
         roo/LjDHzRGTVB09kijzDgqyFwDiMFlMC1ANhYvhcJcIRfMMrx1VHkmjvO8DavIrAeUn
         CXi4S6nUxSnyR7+98RBaUTJ0I5YJ1c0VMA3QjU3FzhF6bTQs/YbB8gWKrKFnPFPFg/LQ
         Colw==
X-Gm-Message-State: APjAAAWF7ECVe4PkqQiVyAil5UdNRkhc7+5dCnWtTmAYN4siphbnCe21
        gIZ04zS/Bd+SsAPSEAwVuK2iJfANQpnAPjGBzmCcgw==
X-Google-Smtp-Source: APXvYqzjKlKY1Kja66lW8RGTPHtfs/6T8SpVnYloLlSDSVMUhBfSkrWEbnvE5In47DX8Zno0ncBSBnblmUb145samAs=
X-Received: by 2002:a19:4349:: with SMTP id m9mr8763066lfj.67.1573537782172;
 Mon, 11 Nov 2019 21:49:42 -0800 (PST)
MIME-Version: 1.0
References: <20191111181438.945353076@linuxfoundation.org>
In-Reply-To: <20191111181438.945353076@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 12 Nov 2019 11:19:31 +0530
Message-ID: <CA+G9fYuGD_Wabfe0Ao3-j8TD9kejT1ixh6mYDTMtHD8DcAkboQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/125] 4.19.84-stable review
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

On Tue, 12 Nov 2019 at 00:12, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.84 release.
> There are 125 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 13 Nov 2019 18:08:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.84-rc1.gz
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

kernel: 4.19.84-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 0f8b6b0b5b946b33f5b60e9de252afb809a17e6a
git describe: v4.19.83-126-g0f8b6b0b5b94
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.83-126-g0f8b6b0b5b94


No regressions (compared to build v4.19.83-124-gb8764c8bac2d)

No fixes (compared to build v4.19.83-124-gb8764c8bac2d)

Ran 23945 total tests in the following environments and test suites.

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
* network-basic-tests
* v4l2-compliance
* ltp-open-posix-tests
* kvm-unit-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
