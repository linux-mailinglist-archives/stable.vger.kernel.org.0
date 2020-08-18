Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 214C4247E46
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 08:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgHRGL3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 02:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726374AbgHRGL1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Aug 2020 02:11:27 -0400
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF636C061342
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 23:11:26 -0700 (PDT)
Received: by mail-vs1-xe41.google.com with SMTP id y8so9527563vsq.8
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 23:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=07CIAwk5ZAShga4EuMYCBLMQcZzdl6+RnOJwmsnH2IU=;
        b=gkndf02aUgbSzRo2saxmLFXDwSD8uNTGq++DCi5hbWqlGCjIS/3V3lLkelJlgl750Q
         7zHUMJmn10N9TRepxD5G5whIbhoA4Zn0KsYzqlb8jcsJjLrb0bIMEiwB7UPAVkL3OZQF
         hGjJcQlsiBb0BaDGXHife7uU6O9U4HlKZ4hHD4dDYRtm902g+8MrrZ3jkbiCw5tQNwmq
         a92j7dHMA2SpLsIImpumN+wemKB532KONkX0nplqFb8xath93Q9HINIj2qVCiYb48gSt
         03Q3dCe4VpaIEtwthMbyi8WWmJudHgVeet5HBxOoz+p5LA7mnk0FBwPFqtJminBKU1EN
         B1gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=07CIAwk5ZAShga4EuMYCBLMQcZzdl6+RnOJwmsnH2IU=;
        b=MFRUwskz7WFegebt5Rb9s+vodXGKfjaJesizT35ghA1sih7O73gqZP64yh1bzJAkjo
         hi9hvnM8HBrFoFvwKmZoyoS7IpCwPzrSf3AIAn0H2s4It87MnE0FXo1m/etWHDb17yE7
         YS5eeTN6TSKN9r11C/Z3QfM6GLGjUfjeOeE6Fw0zQsO5jYFkVE3hIBCyxUjIOf37ZpSj
         aHLHTYA8d3hHrOCdNf9JauIYlwDsyvnP1MSJ0ttH+x23PiStqxKT+1Z9GWV2gExjUbuY
         m/eRG4U6EaXJNxGgWyvRoix2pRuRFk9Cr9I/0H9lsWBpE0CdmhzLNfDZ/bBJz9a4hCAt
         bVGw==
X-Gm-Message-State: AOAM533KVAU9NoUBY7XloQvjxYmRagm9YMPZgSQ6YSJuhVmzKXQjq+hu
        6HNUW0WwFW/eoOr5ystuMNvNSfsxkF5OdnhnfKO2bw==
X-Google-Smtp-Source: ABdhPJy0NaPbpWawVwD+lAAwYzraE8SBFH/fNa1e24SIqisIh25yFMGdEDM1q/mwxhIe5mfH4k8txc+AErITWPD5aM0=
X-Received: by 2002:a67:d84:: with SMTP id 126mr640475vsn.69.1597731086117;
 Mon, 17 Aug 2020 23:11:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200817143733.692105228@linuxfoundation.org>
In-Reply-To: <20200817143733.692105228@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 18 Aug 2020 11:41:14 +0530
Message-ID: <CA+G9fYtuBjTxYQ=MkzWJbOvrKbdW4r3i7N0d+ZAjouqENNMZ_Q@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/168] 4.19.140-rc1 review
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

On Mon, 17 Aug 2020 at 21:44, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.140 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 19 Aug 2020 14:36:49 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.140-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.19.140-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 9950f9b4d350ca9b4f05daa2d16b090000b1d2d7
git describe: v4.19.139-169-g9950f9b4d350
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.139-169-g9950f9b4d350

No regressions (compared to build v4.19.139)

No fixes (compared to build v4.19.139)


Ran 33782 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- nxp-ls2088
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
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
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
* ltp-tracing-tests
* perf
* ltp-controllers-tests
* ltp-cve-tests
* ltp-fs-tests
* network-basic-tests
* v4l2-compliance
* ltp-open-posix-tests
* igt-gpu-tools
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net

--=20
Linaro LKFT
https://lkft.linaro.org
