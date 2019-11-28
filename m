Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BCCA10C3DA
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 07:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfK1GVx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 01:21:53 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:39938 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726565AbfK1GVx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Nov 2019 01:21:53 -0500
Received: by mail-lj1-f196.google.com with SMTP id s22so8128756ljs.7
        for <stable@vger.kernel.org>; Wed, 27 Nov 2019 22:21:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jGpGxpC/wXWKh1C0/wBKFzSJF3Qe61l1DK5ccrhGvrI=;
        b=lIw46c8sEh+S5n6n9HdGJrBBIpXd62YZNYBvqi/xV0hgqMHG2ExA4L1LozZoBPLa5y
         dK8FNwPTwQS+PHs5WDKS3GZqDr5gNrtZg5G5kGBXbM9HdpFKq8OSx5VePntx4OBLqvCX
         4NTtN1ApKyuFqki2PDWnrdTjjuZlzkiDUd7eWWSPfeBTJlye6er3Oac3o/fyNSgn5KF7
         YAZEENqdcAcSEv6dzSWrH3qWRN1P6LGoMXLYbf4iNnpQe8itknFJX6yu3qVzew4Kll3i
         J8qwqAdRGHEiF3qYrfS3pG7NDpoSVJgzsrSA1nF9AaFAl0gWcpRNnwiFW9e0cFTV1rT5
         Dnvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jGpGxpC/wXWKh1C0/wBKFzSJF3Qe61l1DK5ccrhGvrI=;
        b=nRxZ7jUrqf5DZPMum1c+hESja2cv6BJHcylX1VJvwRBPx55ZIykoQI8ojEyxbMR5yc
         tJ+xy0cfoI4srwvXQCTMFiLqioN9GLhXmTyrgOee0kqI4+iMimlzO54RPdNbOpnkHLGS
         9EvtMaWDB+5XKJjWDH9YkLiljlGxwyhmciQk9z+R0jZPa16xIVEKlgeDViZR4c7k9wxs
         Ey1mjGCuwToW7QEzfJ8vwQdFQ9ubr+/wKFOGUehxO5jyPRsmvj34ZmSwc2k7sNWeaJLE
         VTTyuOvMob9q5g1IHNXS7hsUt3Mismx8AVTBBDkuevaWG6WycHnQwksgblImJfWALBev
         yWWw==
X-Gm-Message-State: APjAAAUJVtM5tc82A/3/xM9Q4Zmc6ePZrubJVh2+6aoI/ccxhMTMtfPM
        ztopN/ziJBOMrchM8cpcXnLLFqavvfp3NCHi9drxmg==
X-Google-Smtp-Source: APXvYqwkoBIjjv7fpkao3bfuld82KnBgOsLVb6dusFS/gVBJO4fpnHDQPkBAT7sgWsM/Xvw4Z8BfHvWbRuT42v6C1JM=
X-Received: by 2002:a2e:7202:: with SMTP id n2mr29985958ljc.194.1574922108978;
 Wed, 27 Nov 2019 22:21:48 -0800 (PST)
MIME-Version: 1.0
References: <20191127203049.431810767@linuxfoundation.org> <CA+G9fYtFNKTYiqm0Bvk_nqBTjsRMKTtNxr6PhE8YaDXFjqwhYQ@mail.gmail.com>
In-Reply-To: <CA+G9fYtFNKTYiqm0Bvk_nqBTjsRMKTtNxr6PhE8YaDXFjqwhYQ@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 28 Nov 2019 11:51:37 +0530
Message-ID: <CA+G9fYsuM-ALP_EtoFEzJiia26QnUvuKWsH0b-vi43Sp++es6A@mail.gmail.com>
Subject: Re: [PATCH 4.14 000/211] 4.14.157-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        jouni.hogander@unikie.com, "David S. Miller" <davem@davemloft.net>,
        lukas.bulwahn@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

> Kernel BUG noticed on x86_64 device while booting 4.14.157-rc1 kernel.


The problematic patch is,
>> Jouni Hogander <jouni.hogander@unikie.com>
>>    net-sysfs: Fix reference count leak in rx|netdev_queue_add_kobject

And this kernel panic is been fixed by below patch,

commit 48a322b6f9965b2f1e4ce81af972f0e287b07ed0
Author: Eric Dumazet <edumazet@google.com>
Date:   Wed Nov 20 19:19:07 2019 -0800

    net-sysfs: fix netdev_queue_add_kobject() breakage

    kobject_put() should only be called in error path.

    Fixes: b8eb718348b8 ("net-sysfs: Fix reference count leak in
rx|netdev_queue_add_kobject")
    Signed-off-by: Eric Dumazet <edumazet@google.com>
    Cc: Jouni Hogander <jouni.hogander@unikie.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>



> Regressions (compared to build v4.14.156)
>
> [    2.777657] BUG: unable to handle kernel NULL pointer dereference
> at 0000000000000090
> [    2.785487] IP: kernfs_find_ns+0x18/0xf0
> [    2.789408] PGD 0 P4D 0
> [    2.791941] Oops: 0000 [#1] SMP PTI
> [    2.795424] Modules linked in:
> [    2.798474] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 4.14.157-rc1 #1
> [    2.804906] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
> 2.2 05/23/2018
> [    2.812288] task: ffff8e09ee250000 task.stack: ffffa0f900028000
> [    2.818200] RIP: 0010:kernfs_find_ns+0x18/0xf0

<trim>

> [    3.108995] Kernel panic - not syncing: Attempted to kill init!
> exitcode=0x00000009
> [    3.108995]
> [    3.118161] Kernel Offset: 0x1c400000 from 0xffffffff81000000
> (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
>
> Full test log,
> https://lkft.validation.linaro.org/scheduler/job/1026224#L793
>

--
Linaro LKFT
https://lkft.linaro.org
