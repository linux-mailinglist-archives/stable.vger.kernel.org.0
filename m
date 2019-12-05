Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4755113B21
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 06:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbfLEFR4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 00:17:56 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:41755 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbfLEFR4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Dec 2019 00:17:56 -0500
Received: by mail-lj1-f194.google.com with SMTP id h23so1966387ljc.8
        for <stable@vger.kernel.org>; Wed, 04 Dec 2019 21:17:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NZoGtGNraQjc6dXpO63gnHnybL5cQ5VU6VDjK1ICWQc=;
        b=VvgqPCA5a+ncw5lN4K5wCoAXVP82RQDe7aIYPCX2P3s0aglm9imMn5f1exi3Uu2SnO
         q3FauUIX9r1w93aBhn4O8jetIcMWfQMy0uxAJFDv0di9gK5FyDX/J08pQx5p569vQ+5u
         X+Kridh3N3ckknEVglo733nKcojDWvoZRo7HdNdzMQ05cmjsQp88Qy6AnmesEjl5EX/w
         qmbtSKd9E3MWSf49cn/VfQw/RcOI/WbQd8RwcIW3RJQfqibRtJPYg8q6jcj2elUO8+ei
         gY2wWqQZSrnIG0qppBOi6n4nYenaDFq7SnCT2OMZO/+kbmfeiKp04u6eEj20jhgKWBlc
         Df5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NZoGtGNraQjc6dXpO63gnHnybL5cQ5VU6VDjK1ICWQc=;
        b=l7ZtUy7ELN4vZE+puuyoPg1jMjvGjiRSk1I0QHfKV+zoLZmdo7aSIG3R8rA5Y+Yyhp
         Y7yPCjnb0/RHXWiJmbW90jM2FMiVND/T5C4CpY/8gyedxGXTyv1pjYl2Vy02eLnTmSt4
         N/mCXudYryUsCuH65LjSk5DGYzWc8n1dup2LOl0inNPM93XR7VPNWEDbp4QEguifpBIu
         oT2ckNTM/VP30nxwk9e6OSa9bm73xevKaqFcjjlf8BnsYXNfUEAY42Ap/AOUiAMIxplG
         5PXfdN9H7wm2Rjo1TJegtUu/KqY5veLZxKl5UBQ5QLowh9jXUAaueRHSJvn0ncdynJAp
         rbQQ==
X-Gm-Message-State: APjAAAUS6h8PUbUMmqM0CIdJHE5WS902zReghpE6H0RD8kR0t2UoMxhG
        h0jpKN9KBcZ6bjTNWkrVKt+6CuAyZ6RZ/Dw67agj0A==
X-Google-Smtp-Source: APXvYqzcmmEJ9J8SmZa/0V3/vBFSLXxIu2GgQsEu2IA7tDLo8TcQ/Wgyismvoxl0/qGsGaDYNBtAjXy8HAIMFzm7uLI=
X-Received: by 2002:a2e:585e:: with SMTP id x30mr4373672ljd.141.1575523074671;
 Wed, 04 Dec 2019 21:17:54 -0800 (PST)
MIME-Version: 1.0
References: <20191204175321.609072813@linuxfoundation.org>
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 5 Dec 2019 10:47:43 +0530
Message-ID: <CA+G9fYuMt0GJ87r7xkME4xz6rD2wx-Sn=mFph_7k2Dr_DXCKOQ@mail.gmail.com>
Subject: Re: [PATCH 4.14 000/209] 4.14.158-stable review
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

On Wed, 4 Dec 2019 at 23:33, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.158 release.
> There are 209 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 06 Dec 2019 17:50:10 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.158-rc1.gz
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

kernel: 4.14.158-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: ce267d7b1d71f10d722fd3c8a729ccca53830262
git describe: v4.14.157-210-gce267d7b1d71
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.157-210-gce267d7b1d71


No regressions (compared to build v4.14.157)


No fixes (compared to build v4.14.157)

Ran 24134 total tests in the following environments and test suites.

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
* linux-log-parser
* ltp-containers-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fs-tests
* ltp-io-tests
* spectre-meltdown-checker-test
* ltp-commands-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
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
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
