Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB36ADB32E
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 19:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440669AbfJQRV2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Oct 2019 13:21:28 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:39938 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2440656AbfJQRV2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Oct 2019 13:21:28 -0400
Received: by mail-ot1-f67.google.com with SMTP id y39so2565598ota.7
        for <stable@vger.kernel.org>; Thu, 17 Oct 2019 10:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MQNN2yMLNBIm9RPEEL9cuuBeXjUf8pcc28LNjdy0QRw=;
        b=xGvDlfZJ2ehTmMhNLXJXBi7VbCD6SJ3hZMbyVEReDaYlq8K3L/XX5+lQympaTk1UGA
         e9mVQNeSjht5/S/zEKXc0Ru8RHP7O08D/5CdyezQW7RvucdfJRSIu4V3yKNIbqo7MfvZ
         kXd7+AWWKQQYhjGMmMSbOgstc5Ovj/wkRbzWPiiTHNEUCD/J0rzHXhX+k7oDyupThX8w
         q70O5DGuDds1PUekBkW1zr6bz10WNtfAwAjqj10C2J50hrb0YyhpX0wUbFYkvF13iZqk
         UfVeoVPbI6RX0/JBLzL6HGLJVPA6lQmlnY4AFirOLI4CwDeB388OaEfdPsjPyRPqFab+
         1Whg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MQNN2yMLNBIm9RPEEL9cuuBeXjUf8pcc28LNjdy0QRw=;
        b=shHlfwll/1f+Epr/T4haxGtmfw0mKyHNt6dq+IYYXGe32jBAF07fuIJKinC6wdpgBJ
         rqa8AJXoH8lWATuQg5O9kCtWIu/RrXGaO15mYaAzAv3W6IboD9FFtSUd4Tf4W+zpYy0a
         8yRIuIRyyJ2PKR48zRcFDRA6BW46gsMfCTYbyHhDwKYjvz0rFTLQklgrgNdlUyKNRxh3
         4sqtmG6xPi4u6Th5r3zuMBTLSdoBd4s4nZW4FHD7HCEou1kkTeGFJnZOzoz+pu6PI3yU
         WZTgIF2XHYG4di67yVejmr79LP3WCovqMb35lW22FK1WVrGfCFfmJZyuCmsrteD9DKD/
         Iwng==
X-Gm-Message-State: APjAAAXQxItJipoyeCMNRJ2e0Br40egyQQC3ZQqOjaXylktPVXwV0SfA
        WDbo5sZXJynDXHannu8egoUgG3zszO+qZgeN5snsvQ==
X-Google-Smtp-Source: APXvYqyjmzXAdREaZpT2IoCB7l4Ga5bm0XN1bx6BFmFRxS4Gf9gk87Xc0ZYY8vwBTdxssA/qYhix2Ora0xTEaDFUO2g=
X-Received: by 2002:a05:6830:457:: with SMTP id d23mr4121621otc.267.1571332887349;
 Thu, 17 Oct 2019 10:21:27 -0700 (PDT)
MIME-Version: 1.0
References: <20191016214844.038848564@linuxfoundation.org>
In-Reply-To: <20191016214844.038848564@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 17 Oct 2019 22:51:15 +0530
Message-ID: <CA+G9fYsV=wVPaF4Uwbtddb1753Bfqz5EDhTzV2A8CX576JNqYA@mail.gmail.com>
Subject: Re: [PATCH 5.3 000/112] 5.3.7-stable review
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

On Thu, 17 Oct 2019 at 03:29, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.3.7 release.
> There are 112 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri 18 Oct 2019 09:43:41 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.3.7-rc1.gz
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

kernel: 5.3.7-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.3.y
git commit: cbb18cd3e47885e336b42ce05d553b44e1e3a7a0
git describe: v5.3.6-112-gcbb18cd3e478
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.3-oe/bui=
ld/v5.3.6-112-gcbb18cd3e478

No regressions (compared to build v5.3.6)

No fixes (compared to build v5.3.6)

Ran 24228 total tests in the following environments and test suites.

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
* libgpiod
* libhugetlbfs
* ltp-containers-tests
* kselftest
* ltp-cap_bounds-tests
* ltp-commands-tests
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
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
