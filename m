Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2FC455146
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 00:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241690AbhKQXxj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 18:53:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240190AbhKQXxi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 18:53:38 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF74C061570
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 15:50:37 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id e3so18535333edu.4
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 15:50:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZOhaj4IaVle24KZ1D6HjmFcDfAElnP2IpcyyjDUqOxc=;
        b=KoLQhfMJKuyTrkR6oc0NIsRPp1xD/xkmkAtjO011JxVoZ9hnSE8GaAT3Ob17fwxABa
         Ok5u8QgrZeq5nFckKEPvBbVq2p7FDfovuAzpI10HSWeCkrnGl5ttL881/jSKcNAhaq28
         8SONbYaoXIcCgrEJTGw9jOVxrXwHThBSuBVnM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZOhaj4IaVle24KZ1D6HjmFcDfAElnP2IpcyyjDUqOxc=;
        b=ILC6y8vWZoqkXICHas5/u6Fm4AOQ+4aP8ktAC19We3GY/JryElFAPjX7gn/tLyEwHn
         xm6dmMglivfIGuM/6DgamQhaTK+llL7TEXns6RXcCtw70pUn6DbTYdJUGI5ibGQenpEx
         nJ4F3iUFWfUdaHayuR66xfv7JtLiEMr1RpPjdJQDdZ1GaAptlScZjCXWnMSawH8NwX6l
         k46G7O3UuCm1lX2HjXvMPDc57tl+P/uo5DC/EBLb0bfvrKQVs3vrNg+v55d6MKIK6iXX
         wbnWyLqZm/PSR0KFMACkvJP6pE8uj3ExFLNjxCP1g0MM35mGZsOWAWGFkcV6HdmGqOkG
         AWWA==
X-Gm-Message-State: AOAM532TDzFM7KcgJrsMuN0UD+wa1i3wBKw1VFH2n/6Wg7bUHlcch17M
        kET35Si/vMO6+X/Jg3jtdiI8amOWTtCbtAfE
X-Google-Smtp-Source: ABdhPJxyxOTamKnW/yBVCXhNNsXuM/3MLAbRWvhtt3PV/bJWcRL1bfDHuJdvo5d1zkLKb7QCOBSzYg==
X-Received: by 2002:a05:6402:2756:: with SMTP id z22mr4342629edd.200.1637193035357;
        Wed, 17 Nov 2021 15:50:35 -0800 (PST)
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com. [209.85.128.42])
        by smtp.gmail.com with ESMTPSA id a15sm656788edr.76.2021.11.17.15.50.34
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Nov 2021 15:50:34 -0800 (PST)
Received: by mail-wm1-f42.google.com with SMTP id p18so3677453wmq.5
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 15:50:34 -0800 (PST)
X-Received: by 2002:a05:600c:1d97:: with SMTP id p23mr4494067wms.144.1637193033749;
 Wed, 17 Nov 2021 15:50:33 -0800 (PST)
MIME-Version: 1.0
References: <20211117101657.463560063@linuxfoundation.org> <YZV02RCRVHIa144u@fedora64.linuxtx.org>
 <55c7b316-e03d-9e91-d74c-fea63c469b3b@applied-asynchrony.com>
In-Reply-To: <55c7b316-e03d-9e91-d74c-fea63c469b3b@applied-asynchrony.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 17 Nov 2021 15:50:17 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjHbKfck1Ws4Y0pUZ7bxdjU9eh2WK0EFsv65utfeVkT9Q@mail.gmail.com>
Message-ID: <CAHk-=wjHbKfck1Ws4Y0pUZ7bxdjU9eh2WK0EFsv65utfeVkT9Q@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/923] 5.15.3-rc3 review
To:     =?UTF-8?Q?Holger_Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Kees Cook <keescook@chromium.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Justin Forbes <jmforbes@linuxtx.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sorry for top-posting and quoting this all, but the actual people
involved with the wchan changes don't seem to be on the participant
list.

And if people see this in stable kernels, I suspect it happens in my
kernel too, but there are more users of stable backports.

I already complained about the locking for the get_wchan() patch for
other reasons, but it looks like this is an actual unwinder problem
that triggers this issue.

Which I'm not AT ALL surprised about. In my locking complaint, I
explicitly mentioned that we've had unwinder issues before, and that
it's probably a really bad idea to call some random unwinder inside a
critical lock.

I really don't think the WCHAN code should use unwinders at all. It's
too damn fragile, and it's too easily triggered from user space.

So I think we need to revert all the wchan changes. Not just in
stable, but in mainline too.

And I hope people start taking the whole "unwinding is so fraught with
problems that you shouldn't do it in any normal circumstances"
seriously.

We've had toolchain issues with unwinding markers being wrong or incomplete=
.

We've had our own asm files not have all the proper annotations.

And most importantly, we've had unwinding code that is written by
people who don't take these issues seriously enough, and just blindly
follow possibly corrupted or wrong pointers.

Ironically, in the scheduler pull request for this all, the claim was
"Make wchan() more robust".

Which was very much the opposite of what it actually did.

              Linus

On Wed, Nov 17, 2021 at 3:32 PM Holger Hoffst=C3=A4tte
<holger@applied-asynchrony.com> wrote:
>
> On 2021-11-17 22:32, Justin Forbes wrote:
> > On Wed, Nov 17, 2021 at 11:19:15AM +0100, Greg Kroah-Hartman wrote:
> >> This is the start of the stable review cycle for the 5.15.3 release.
> >> There are 923 patches in this series, all will be posted as a response
> >> to this one.  If anyone has any issues with these being applied, pleas=
e
> >> let me know.
> >>
> >> Responses should be made by Fri, 19 Nov 2021 10:14:52 +0000.
> >> Anything received after that time might be too late.
> >>
> >> The whole patch series can be found in one patch at:
> >>      https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.3-rc3.gz
> >> or in the git tree and branch at:
> >>      git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> >> and the diffstat can be found below.
> >>
> >
> > I replied to Bruno's original message to lkml which has CKI artifacts
> > for the issue, but I am still seeing it with rc3 on x86:
> >
> > [    4.435551] BUG: unable to handle page fault for address: ffffb38140=
2d7de0
> > [    4.437498] #PF: supervisor read access in kernel mode
> > [    4.438937] #PF: error_code(0x0000) - not-present page
> > [    4.440373] PGD 100000067 P4D 100000067 PUD 1001d7067 PMD 100a1f067 =
PTE 0
> > [    4.442269] Oops: 0000 [#1] SMP PTI
> > [    4.443256] CPU: 1 PID: 1 Comm: systemd Not tainted 5.15.3-0.rc3.1.f=
c35.x86_64 #1
> > [    4.445230] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS=
 1.14.0-3.fc34 04/01/2014
> > [    4.447514] RIP: 0010:__unwind_start+0x10b/0x1e0
> > [    4.448749] Code: af fb ff 85 c0 75 d2 eb c0 65 48 8b 04 25 c0 fb 01=
 00 48 39 c6 0f 84 86 00 00 00 48 8b 86 98 23 00 00 48 8d 78 38 48 89 7d 38=
 <48> 8b 50 28 48 89 55 40 48 8b 40 30 48 89 45 48 48 3d 80 43 00 a1
> > [    4.453406] RSP: 0018:ffffb38140017c18 EFLAGS: 00010006
> > [    4.454672] RAX: ffffb381402d7db8 RBX: ffffb381402d7db8 RCX: 0000000=
000000000
> > [    4.456370] RDX: 0000000000000000 RSI: ffff9b5080c08000 RDI: ffffb38=
1402d7df0
> > [    4.458065] RBP: ffffb38140017c38 R08: 0000000000000040 R09: 0000000=
000005000
> > [    4.459689] R10: 8000000000000000 R11: 0000000000000000 R12: 0000000=
000000000
> > [    4.461306] R13: ffff9b5080c08c74 R14: 000000000000024b R15: 0000000=
000000001
> > [    4.462857] FS:  00007f8d7729c340(0000) GS:ffff9b51f7d00000(0000) kn=
lGS:0000000000000000
> > [    4.464613] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [    4.465825] CR2: ffffb381402d7de0 CR3: 0000000100244004 CR4: 0000000=
000770ee0
> > [    4.467301] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
> > [    4.468789] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000=
000000400
> > [    4.470217] PKRU: 55555554
> > [    4.470777] Call Trace:
> > [    4.471280]  <TASK>
> > [    4.471718]  __get_wchan+0x35/0x80
> > [    4.472415]  get_wchan+0x65/0x80
> > [    4.473085]  do_task_stat+0xcd9/0xde0
> > [    4.473821]  proc_single_show+0x4d/0xb0
> > [    4.474583]  seq_read_iter+0x120/0x4b0
> > [    4.475327]  seq_read+0xed/0x120
> > [    4.475973]  ? cap_convert_nscap+0x160/0x1b0
> > [    4.476832]  vfs_read+0x95/0x190
> > [    4.477472]  ksys_read+0x4f/0xc0
> > [    4.478115]  do_syscall_64+0x3b/0x90
> > [    4.478830]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > [    4.479823] RIP: 0033:0x7f8d77e2c31c
> > [    4.480537] Code: ec 28 48 89 54 24 18 48 89 74 24 10 89 7c 24 08 e8=
 f9 49 f9 ff 48 8b 54 24 18 48 8b 74 24 10 41 89 c0 8b 7c 24 08 31 c0 0f 05=
 <48> 3d 00 f0 ff ff 77 34 44 89 c7 48 89 44 24 08 e8 4f 4a f9 ff 48
> > [    4.484140] RSP: 002b:00007ffc2434e8c0 EFLAGS: 00000246 ORIG_RAX: 00=
00000000000000
> > [    4.485608] RAX: ffffffffffffffda RBX: 000055aa6dc4f650 RCX: 00007f8=
d77e2c31c
> > [    4.486991] RDX: 0000000000000400 RSI: 000055aa6dcaf960 RDI: 0000000=
000000005
> > [    4.488376] RBP: 00007f8d77f00300 R08: 0000000000000000 R09: 0000000=
000000001
> > [    4.489761] R10: 0000000000001000 R11: 0000000000000246 R12: 00007f8=
d7729c0f8
> > [    4.491159] R13: 0000000000000d68 R14: 00007f8d77eff700 R15: 0000000=
000000d68
> > [    4.492545]  </TASK>
> > [    4.492982] Modules linked in: xfs crct10dif_pclmul crc32_pclmul crc=
32c_intel ghash_clmulni_intel serio_raw virtio_console virtio_blk virtio_ne=
t net_failover failover qemu_fw_cfg pkcs8_key_parser
> > [    4.496354] CR2: ffffb381402d7de0
> > [    4.497010] ---[ end trace dc5691b47f8ba15b ]---
> > [    4.497913] RIP: 0010:__unwind_start+0x10b/0x1e0
> > [    4.498822] Code: af fb ff 85 c0 75 d2 eb c0 65 48 8b 04 25 c0 fb 01=
 00 48 39 c6 0f 84 86 00 00 00 48 8b 86 98 23 00 00 48 8d 78 38 48 89 7d 38=
 <48> 8b 50 28 48 89 55 40 48 8b 40 30 48 89 45 48 48 3d 80 43 00 a1
> > [    4.502401] RSP: 0018:ffffb38140017c18 EFLAGS: 00010006
> > [    4.503418] RAX: ffffb381402d7db8 RBX: ffffb381402d7db8 RCX: 0000000=
000000000
> > [    4.504803] RDX: 0000000000000000 RSI: ffff9b5080c08000 RDI: ffffb38=
1402d7df0
> > [    4.506185] RBP: ffffb38140017c38 R08: 0000000000000040 R09: 0000000=
000005000
> > [    4.507582] R10: 8000000000000000 R11: 0000000000000000 R12: 0000000=
000000000
> > [    4.508956] R13: ffff9b5080c08c74 R14: 000000000000024b R15: 0000000=
000000001
> > [    4.510339] FS:  00007f8d7729c340(0000) GS:ffff9b51f7d00000(0000) kn=
lGS:0000000000000000
> > [    4.511914] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [    4.513032] CR2: ffffb381402d7de0 CR3: 0000000100244004 CR4: 0000000=
000770ee0
> > [    4.514420] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
> > [    4.515803] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000=
000000400
> > [    4.517182] PKRU: 55555554
> > [    4.517724] Kernel panic - not syncing: Attempted to kill init! exit=
code=3D0x00000009
> > [    4.519317] Kernel Offset: 0x20000000 from 0xffffffff81000000 (reloc=
ation range: 0xffffffff80000000-0xffffffffbfffffff)
> > [    4.521398] ---[ end Kernel panic - not syncing: Attempted to kill i=
nit! exitcode=3D0x00000009 ]---
> >
>
> This is great! Several people (incl. me) have seen the _exact same_ trace=
, but with
> BMQ/PDS (custom CPU schedulers) so we suspected a locking issue/incompati=
bility in
> get_wchan()'s spinlocking & task diddling compared to CFS. The fact that =
this happens
> with vanilla means it's a generic problem with either: "sched: Add wrappe=
r for get_wchan()
> to keep task blocked" or "x86: Fix get_wchan() to support the ORC unwinde=
r" or both.
> I have been running with a dummy implementation of get_wchan that just re=
turns 0
> (effectively disabling wchan) and 5.15.3-rc3 has been rock-solid again.
>
> Maybe just revert all the wchan stuff and let it stew in mainline a bit l=
onger?
>
> -h
