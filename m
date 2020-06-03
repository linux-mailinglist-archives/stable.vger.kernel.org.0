Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2A931EC958
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 08:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725859AbgFCGSl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 02:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbgFCGSl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jun 2020 02:18:41 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADEBFC05BD43
        for <stable@vger.kernel.org>; Tue,  2 Jun 2020 23:18:39 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id d7so542906lfi.12
        for <stable@vger.kernel.org>; Tue, 02 Jun 2020 23:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=L1Antw3TmB237X2rD0lLfZbq7G8CDuK+XDIh5Trtg0M=;
        b=KvVZ3zB4XH8c/FeFY9EwaEUUEkumTj4KRjFaC95lAv4KrA46yIdrIoB0/SmrfK1Jna
         i8r/0kD27i+AqTBjag0VSIyf5b9Dpv37lr7CsBlUIlRHztoaMwSXkzK8G9O/kKU5oCC+
         LITfUe2OT9nkRo7lxapHpw1Si7X4cZMTHTmEAR8txWGqjZGfeHAww4nlDc4aZRGtRMiP
         cheAfO18oYjEQ0npLSbiTWKo1U1NtFc7Qtdmkr5tP3oAqAUomckjgtHqyJMe8Jr15I8Q
         sh5/riHw5BsajRHBV83vdio98J4YWXxWPHBMhDq7P9+r/lzZ56g8QTrty71lZF70KgU6
         3r2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=L1Antw3TmB237X2rD0lLfZbq7G8CDuK+XDIh5Trtg0M=;
        b=d68NOJBreJpAM0P//v263pcVj6IZcS2CROidhSNDEj/QFq1H0DtN0NfcxUvZtmgqUv
         kDkk2a9qLRqYWJqkziRyvSoU9P26G7kXSGkU11MqT72QZKXmokVhKnsHerUM7F9bl1H4
         YtVrFUVs6mI2rF6EUhsHeiHGg/HjWIkk6nxXl5FxzwEwmLMAemaDv/7xerbwKSJpTGZJ
         APA9jfTgpDoOGZdgL8/rUdm4g+MkM2j22O/YyFBSbNRKAHtnojW8h9+x84yyDYSSD9QF
         R2uJ74F5y176MFw7V8+LCLQeuQvzGlsowXFE6frAUujeUe1edwxbiTwWv946do4TItUK
         w6pw==
X-Gm-Message-State: AOAM5308DZqhX/+KKr8Ijh4GqXaB4v8JBFYQDeWOi9GNi2guWorNPUoM
        6TgrmRJoEa99yhHHoBkiroAOruHp+MvbtIemO8JLrg==
X-Google-Smtp-Source: ABdhPJz3sRYK+AVpCyJ7p5q3edlvN7JO6YQshMhM13AlHLtzN+RjDRibm+wntiT9STMOoy8U7F+vDqeQUpaGUHXn17M=
X-Received: by 2002:a05:6512:533:: with SMTP id o19mr1548565lfc.6.1591165117824;
 Tue, 02 Jun 2020 23:18:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200602100034.001608787@linuxfoundation.org>
In-Reply-To: <20200602100034.001608787@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 3 Jun 2020 11:48:25 +0530
Message-ID: <CA+G9fYsPCBYpuFO_DBCJGu3+BiwpoBzivm9A5QZrbb2vRPrZeA@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/47] 4.4.226-rc2 review
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

On Tue, 2 Jun 2020 at 15:46, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.226 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 04 Jun 2020 09:57:12 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.226-rc2.gz
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

kernel: 4.4.226-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: d147737ac3bacf4a44c5cfc4a531c308e2fb2027
git describe: v4.4.225-48-gd147737ac3ba
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.4-oe/bui=
ld/v4.4.225-48-gd147737ac3ba

No regressions (compared to build v4.4.225)

No fixes (compared to build v4.4.225)

Ran 19482 total tests in the following environments and test suites.

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

kernel: 4.4.226-rc2
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.226-rc2-hikey-20200602-737
git commit: 3f551997d7233bd0a671cbf0312dd475e02c92ee
git describe: 4.4.226-rc2-hikey-20200602-737
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.226-rc2-hikey-20200602-737


No regressions (compared to build 4.4.226-rc1-hikey-20200601-734)


No fixes (compared to build 4.4.226-rc1-hikey-20200601-734)

Ran 1855 total tests in the following environments and test suites.

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
