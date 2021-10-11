Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E50AF4296F6
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 20:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbhJKShO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 14:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbhJKShO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 14:37:14 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0A41C06161C
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 11:35:13 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id d3so43763536edp.3
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 11:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fBcgVKoGRggT3Uy1yoJR3Sgr+q930ZEpVWr84lINymY=;
        b=U2w5rme7IKP7knj8dJyakaJAh2JZn2YZ2n0fH16SWLN7eopx2blwSw0vPRU3ju4YFb
         5RYfQkSEndKzGS2GrJoEt5sFMGE960e/itzKJFvE05uJg4RiznUVi4cYVS16c2wR/suD
         ImjzKeSbDv1w9QelJ2920OHt5O0i7CAF/88oPbv0QMXAxgpPrxZEJEMnwQGf4cD4Ewiw
         svLgDg0rnG87dpYjh/lujnuanQE5prQNgTXd5vIJt04dx48pCFOo2wf4EBjf48hxG9Cy
         xhukoor/EZi2y00sov/JNxxhejoND+1Q9w9HpotN3k0vWdTv0s3NTgPoxhSrliJgUGqz
         VU6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fBcgVKoGRggT3Uy1yoJR3Sgr+q930ZEpVWr84lINymY=;
        b=rb0NjigHOtqe22LBHysaK3PTAr9xHEAeM0gQjGu0exFRWivBEM46E2zZuB6zgsK8qk
         w7ghdykIbLzJ9P7Rn5kSDsBfSJPU8gJlB32dg/IIrY72+obmlDFI4w+txe5GHD7qno3V
         tDuS6IWFh0bg7zJ88yuiT2hYn5i7fkSH+D1316AfyGxQZWafOJLSZkpQOXXexWXQZebm
         3lxS/LDLJNt/Dhh+JKqZueO5HesJHxWk6v4tOina8Eyd7ZvCF35nJKpqbtpS4kA8f9iW
         lH+juvoLoUbINquNa3gZXNfpVivpc7gPtAa7nDmFP+FDt2X6gdjvAmSYKaxVdPvXf/+Y
         OpZw==
X-Gm-Message-State: AOAM532YXiZg3Hm3UO6r6RBYkjV2IH3s1jktTnwxYCZGoaEhM0sOxXCF
        eEgyAoqXHObWAxe3SSGPNDYVgUWIOnGU7jFxbBvjqg==
X-Google-Smtp-Source: ABdhPJw7VmFf1Z/3+QbHozFM+RW3lJThpIu4lsHhi1z00/AWTWEYk/2ZJ/33dznHy7oECvbIsnZNx4RXVoQFg1e3zdg=
X-Received: by 2002:a17:906:c7c1:: with SMTP id dc1mr28372064ejb.6.1633977311975;
 Mon, 11 Oct 2021 11:35:11 -0700 (PDT)
MIME-Version: 1.0
References: <20211011134517.833565002@linuxfoundation.org>
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 12 Oct 2021 00:05:00 +0530
Message-ID: <CA+G9fYutz0ZgJ=rrg8=Fd7vh9c7G-SJfF2YoH5wZyGzUHu4Dqw@mail.gmail.com>
Subject: Re: [PATCH 5.14 000/151] 5.14.12-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 11 Oct 2021 at 19:28, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.14.12 release.
> There are 151 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 13 Oct 2021 13:44:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.14.12-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
Regression found on arm x15 device.

metadata:
  git branch: linux-5.14.y
  git repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
  git commit: d98305d056b808dd938d2ae6bfd0e3ccac00a106
  git describe: v5.14.11-152-gd98305d056b8
  make_kernelversion: 5.14.12-rc1
  kernel-config: https://builds.tuxbuild.com/1zMbwi83MvhJdKpC0LTvxvIh1Fb/co=
nfig

Crash log,
[    0.000000] Linux version 5.14.12-rc1 (tuxmake@tuxmake)
(arm-linux-gnueabihf-gcc (Debian 11.1.0-1) 11.1.0, GNU ld (GNU
Binutils for Debian) 2.36.90.20210705) #1 SMP @1633961260
[    0.000000] CPU: ARMv7 Processor [412fc0f2] revision 2 (ARMv7), cr=3D10c=
5387d
<trim>
[    5.403076] Kernel panic - not syncing: stack-protector: Kernel
stack is corrupted in: __lock_acquire+0x2520/0x326c
[    5.413574] CPU: 0 PID: 6 Comm: kworker/0:0H Not tainted 5.14.12-rc1 #1
[    5.420227] Hardware name: Generic DRA74X (Flattened Device Tree)
[    5.426361] Backtrace:
[    5.428863] [<c153b5e8>] (dump_backtrace) from [<c153b9a8>]
(show_stack+0x20/0x24)
[    5.436492]  r7:c2109acc r6:00000080 r5:c1c3c52c r4:60000193
[    5.442169] [<c153b988>] (show_stack) from [<c1542cf8>]
(dump_stack_lvl+0x60/0x78)
[    5.449798] [<c1542c98>] (dump_stack_lvl) from [<c1542d28>]
(dump_stack+0x18/0x1c)
[    5.457427]  r7:c2109acc r6:c1c1d4ac r5:00000000 r4:c23a1aa8
[    5.463104] [<c1542d10>] (dump_stack) from [<c153c800>] (panic+0x13c/0x3=
70)
[    5.470123] [<c153c6c4>] (panic) from [<c1555854>]
(lockdep_hardirqs_on+0x0/0x1d0)
[    5.477752]  r3:c28033d0 r2:a519091a r1:c03dc7ec r0:c1c1d4ac
[    5.483428]  r7:c2109acc
[    5.485992] [<c1555838>] (__stack_chk_fail) from [<c03dc7ec>]
(__lock_acquire+0x2520/0x326c)
[    5.494476] [<c03da2cc>] (__lock_acquire) from [<c03ddfe0>]
(lock_acquire+0x140/0x414)
[    5.502471]  r10:60000193 r9:00000080 r8:2ca87000 r7:c31c4128
r6:c20935e0 r5:c20935e0
[    5.510345]  r4:c31c4000
[    5.512878] [<c03ddea0>] (lock_acquire) from [<c03a2e1c>]
(account_system_index_time+0xf0/0x284)
[    5.521728]  r10:c31c4000 r9:eeb1fa40 r8:eeb1a4f0 r7:00000002
r6:c321db80 r5:00000000

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Full test log link,
https://lkft.validation.linaro.org/scheduler/job/3719571#L2392

zImage:
https://builds.tuxbuild.com/1zMbwi83MvhJdKpC0LTvxvIh1Fb/zImage

Build link,
https://builds.tuxbuild.com/1zMbwi83MvhJdKpC0LTvxvIh1Fb/

--=20
Linaro LKFT
https://lkft.linaro.org
