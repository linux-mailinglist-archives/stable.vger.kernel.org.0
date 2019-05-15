Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5811FB47
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 21:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727251AbfEOTzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 15:55:11 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:42131 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726170AbfEOTzL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 May 2019 15:55:11 -0400
Received: by mail-lf1-f67.google.com with SMTP id y13so745652lfh.9
        for <stable@vger.kernel.org>; Wed, 15 May 2019 12:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NtfqLj3FhKROou9UKTE3EFKT9RcYcoszb1MLPx30lFQ=;
        b=G+u5IIniRj4n2jVDbLdo30jx9xK/uF8MHnlPtEbAAan4ENjhFhfJSZkxYgiTdMHjKX
         MjTZGVljpan9IvVvqOPYytWZTydGoWAOzy5eUooVl3qlNRLhTPnP0Qk89KgNVFNMETpP
         cd90m0N1xkE7oJDbyENL7HEG46X9l7JtzuGabd+d8fGCAY10lizqIQ3gEZgb7QV5+GTn
         ehF4Gal3GiHk8oNfQAWv5L6Fyt0DDzFC4SxTQqhkWHXqbvLKITBIjWgUHFrBNSnibIE3
         BK5oG5McUhfA4dkc9lm5FFqiNKUZ+/e9ygrDIuoyL7V7g3R8i1kb21kyUJ3l7vyRYolV
         YHOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NtfqLj3FhKROou9UKTE3EFKT9RcYcoszb1MLPx30lFQ=;
        b=FM/PrESCp0eKlAWsBmqgnK2cqqMxZsACvOOEww39Rmu5yIj9TGl9pckz58C9M4Q4Et
         xtCxaxFlN5AobeVd3iDAcesunqIzJIXvNScVCp6DJKgWqu374juBDwLa7o/yT3GmUT92
         9Xj6aStNy/Mrbw26VBZ7DZMNTW/UKhb8gWpBPxRV1IP153eNuIzBUAHuEEBiTn70anPT
         lTGkd6d3blulkQabQiniHvdP96orsR0uQDkWaZdFpPZ8uTo7Nh1KWfSpwmR5F3HeC+ho
         krS9Z7DqmtrOmrekBDlDO1pVG8BUb9Yb4gviY8e+/yUlQffSFVvEMFI4Kc1r4FwEIXoS
         UEyA==
X-Gm-Message-State: APjAAAV68XiTFdNAilbbDqoaVVcDhzVHlbHdSnbRUtfcIEyz3IHZX0td
        mc2+NVTc9cRI/T3EQgECgihx6Z0QbYytkjvIe6hWnw==
X-Google-Smtp-Source: APXvYqygxC8I60Gii3BAVOi7/kv8DkejMYTrPGUZcafSABk+fFUr2otdv9FE4d620oBRzmmj0rYX0soirAwobnuJkvg=
X-Received: by 2002:ac2:4d07:: with SMTP id r7mr6019438lfi.142.1557950108945;
 Wed, 15 May 2019 12:55:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190515090616.669619870@linuxfoundation.org>
In-Reply-To: <20190515090616.669619870@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 16 May 2019 01:24:56 +0530
Message-ID: <CA+G9fYvH+ywdrsbZ9R8=UG5CeuqLvjs4kCjm3rRQ31=gfsa_Bg@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/51] 4.9.177-stable review
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

On Wed, 15 May 2019 at 16:45, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.177 release.
> There are 51 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri 17 May 2019 09:04:42 AM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.177-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
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

kernel: 4.9.177-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: 2647f24152a78a686e9e2c8382f5b292cc31b99a
git describe: v4.9.176-52-g2647f24152a7
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/bui=
ld/v4.9.176-52-g2647f24152a7


No regressions (compared to build v4.9.176)

No fixes (compared to build v4.9.176)


Ran 21640 total tests in the following environments and test suites.

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
* ltp-timers-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-open-posix-tests
* prep-tmp-disk
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
