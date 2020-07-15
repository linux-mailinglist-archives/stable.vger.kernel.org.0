Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1870A2204E3
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 08:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728542AbgGOGVs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 02:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbgGOGVr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jul 2020 02:21:47 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D73FC061755
        for <stable@vger.kernel.org>; Tue, 14 Jul 2020 23:21:47 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id k15so431813lfc.4
        for <stable@vger.kernel.org>; Tue, 14 Jul 2020 23:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=v2wuTVz9P4mwdq6L6Z7DCEAHLkfBGhYGvO53+VjpkQE=;
        b=dLWJ2TcdhQb13BOA9YB3K/O3wCXuCzdnqeAazsW8c2lUxAAPBSKVl+MgtLXLXOsow/
         9LnDts/FiAKkGASjhyd/P49VHgfalkxfc9aCbSdI2VudyqRN5YKHsAX6000fHLOVk0Gg
         x66lDfttzCx/cTmgg1JLz2MaS0XHWmSFbfmDpbcDTUr6xwXYFRk3res+LMF3Uj81oNHW
         lkiDVnjXK85ZlyzppgxdVFrNwqQYFD6IGVhrJT9PFxc4eWFpypJ0tDKj0Y2aJzEUq0ij
         z7EUET3CqkYl8KMwXkUAt6OdOaq/qjL5SfQT4AF0Xv1HWT/ZxmI9QgGcWsHJHuJESrBe
         tgKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=v2wuTVz9P4mwdq6L6Z7DCEAHLkfBGhYGvO53+VjpkQE=;
        b=NMgda9HJSwRmF49oeUhK40JUgmvc63nPpKADHRXZ2EiW+s7gz+lomgIMemPo5sFu4t
         HOKMeOWLBYfCrCMB4yQ4apRx9MQrX/cKAHoc4Xc4TjzobmVodGhQaakXw/TgMe11uCSw
         QMm9wn3Ya6QrkjWO6SKCwDofDDea0lbGLgJJgu7JSCG2BUKxsRJBqCLfJ3u8L+DBW0ON
         ghR2InCTn8go3TrMD0amFu8yT0u4Kao05zGe7rhLYDDiZaLj08eObwsuXgJ0pAA+PxyM
         UYIuUWj5XvkTHrT66a5a7MeyALFYL0W3JR9oNxd091PXmRZNVuAgRj8F59gcVKVT4IC0
         +DdA==
X-Gm-Message-State: AOAM5330ANa1Px96JWoLWZ5wIHTKLZ+WzilD91iPHq5INCiw11lXT4IE
        I5y9wOOntIaZBYiKwGSPBb1XblLPPgCqaOPXwbYbeQ==
X-Google-Smtp-Source: ABdhPJxjFHflG0oTbQ/TMqZOlczkYPmMoYYULz8cGpvA/ShKMsc/7O6zHiaDIDi0o/62Vq6Qt31ijhEBheQLhufYxHA=
X-Received: by 2002:a19:2292:: with SMTP id i140mr3860109lfi.95.1594794105528;
 Tue, 14 Jul 2020 23:21:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200714184105.507384017@linuxfoundation.org>
In-Reply-To: <20200714184105.507384017@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 15 Jul 2020 11:51:33 +0530
Message-ID: <CA+G9fYvcgHOAU9X0VSiC-jSw=9YR4JYSxPqR4PF33N8qfHaO7w@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/109] 5.4.52-rc1 review
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

On Wed, 15 Jul 2020 at 00:18, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.52 release.
> There are 109 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 16 Jul 2020 18:40:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.52-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.4.52-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: e41ac96492edd546629b9fefe57c4f3c9415643c
git describe: v5.4.51-110-ge41ac96492ed
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/bui=
ld/v5.4.51-110-ge41ac96492ed


No regressions (compared to build v5.4.51)


No fixes (compared to build v5.4.51)

Ran 34148 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- nxp-ls2088
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15
- x86
- x86-kasan

Test Suites
-----------
* build
* install-android-platform-tools-r2800
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* v4l2-compliance
* kvm-unit-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-math-tests
* ltp-syscalls-tests
* network-basic-tests
* ltp-open-posix-tests

--=20
Linaro LKFT
https://lkft.linaro.org
