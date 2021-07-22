Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3943D203D
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 10:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbhGVIRh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 04:17:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbhGVIRh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Jul 2021 04:17:37 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71489C061575;
        Thu, 22 Jul 2021 01:58:11 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id h2so5866327edt.3;
        Thu, 22 Jul 2021 01:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZFYgzw7H3GZVDZlIR2S2VqAuDrq74nERuCE+XLBNyMk=;
        b=EC5dmAzgbk40RY3HB34S46UzvmH8VNNAzsOt5kOolxD8Z0TItizWXdJHZz/vZLVam8
         HEIN2I9TmOozxZ9uzMVGpVoh2HegY90RVyrAAbTTUF+oGiVff63rWzU1+uEVi10z8kgp
         v5PSUbqZLdYm8zavgI1/A6V0Owoi+BLZMmwQsvSVD/QLRLP4k2YhrnASHVEPs2ILW7/n
         z1+F0WMH9kIMAAumpCbVY9MWNyKXfOpXU4ZEuWgweElLXDHQrOg/P4YaAm6k6B94b+8W
         77JhnAAG50X2a+ci3rAQGNlPGM7mr8ytDy+LPfDYVILPNMCJCwXDr/6AHdKos7HKk5DD
         EAtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZFYgzw7H3GZVDZlIR2S2VqAuDrq74nERuCE+XLBNyMk=;
        b=WvI8Jfn17QmW8PjmeQDDLtt5VHEtJwRFGCsTGJHMxTXsmcmbGG1v3VhCgjsPzHGPSH
         5qdvT1ZRP6XoKXgHmdEb0sQBje9/+TT4OfuqmO0/zxaKpWCPJMCnmrDBkzCmbJBBGkWm
         hpnX3/FQnh0BGBUCU3MOHoqxqZQYp/MczLTBgmD8KB+ML+JNKS8Ege9QmbIngeinio6c
         0fWsHjuLU+bRzM5pNrnq1Hmy2Y0SpPB9gM7+dr2/7MPPeNtgCdVj9msEEovUaszdPrZD
         +4L3vyrjAAWX+dKwZN0Qj4fzBPj59pOsSt4NXllq0JxYsoZ0N2I0ccQGZp28OHm67u25
         uMHQ==
X-Gm-Message-State: AOAM533VXS9gmR3VnRJZqb81imkRfdvc1CqXQ5xb1WPwDacNfvEJqdVN
        t0bR1t9xD6nG4DWLskpWrwPIVMNrGKlD8xY0Ym0=
X-Google-Smtp-Source: ABdhPJwtV+jVjRjYyMKarxfwrT9E4k8v+p2AwowJNt2q1LUNFrM4P+AHGBhx4IRPW+FAIZBAfkeRvDyV5P7V7uafd/Q=
X-Received: by 2002:a05:6402:221c:: with SMTP id cq28mr46965200edb.115.1626944289967;
 Thu, 22 Jul 2021 01:58:09 -0700 (PDT)
MIME-Version: 1.0
References: <c9fd1311-662c-f993-c8ef-54af036f2f78@googlemail.com>
 <5812280.fcLxn8YiTP@natalenko.name> <YPVtBBumSTMKGuld@casper.infradead.org>
 <2237123.PRLUojbHBq@natalenko.name> <CAABZP2w4VKRPjNz+TW1_n=NhGw=CBNccMp-WGVRy32XxAVobRg@mail.gmail.com>
 <CAABZP2yh3J8+P=3PLZVaC47ymKC7PcfQCBBxjXJ9Ybn+HREbdg@mail.gmail.com> <fb8b8639-bf2d-161e-dc9a-6a63bf9db46e@googlemail.com>
In-Reply-To: <fb8b8639-bf2d-161e-dc9a-6a63bf9db46e@googlemail.com>
From:   Zhouyi Zhou <zhouzhouyi@gmail.com>
Date:   Thu, 22 Jul 2021 16:57:57 +0800
Message-ID: <CAABZP2xST9787xNujWeKODEW79KpjL7vHtqYjjGxOwoqXSWXDQ@mail.gmail.com>
Subject: Re: linux-5.13.2: warning from kernel/rcu/tree_plugin.h:359
To:     Chris Clayton <chris2553@googlemail.com>
Cc:     Oleksandr Natalenko <oleksandr@natalenko.name>,
        Matthew Wilcox <willy@infradead.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Boqun Feng <boqun.feng@gmail.com>, paulmck@kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Chris Rankin <rankincj@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        rcu <rcu@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks for reviewing,

What I have deduced from the dmesg  is:
In function do_swap_page,
after invoking
3385        si =3D get_swap_device(entry); /* rcu_read_lock */
and before
3561    out:
3562        if (si)
3563            put_swap_device(si);
The thread got scheduled out in
3454        locked =3D lock_page_or_retry(page, vma->vm_mm, vmf->flags);

I am only familiar with Linux RCU subsystem, hope mm people can solve our
confusions.

On Thu, Jul 22, 2021 at 3:30 PM Chris Clayton <chris2553@googlemail.com> wr=
ote:
>
>
>
> On 19/07/2021 17:56, Zhouyi Zhou wrote:
> > Attached is my kernel configuration file (config-5.13.2), dmesg (dmesg.=
txt)
> > My qemu box's memory layout is:
> >                     total        used        free      shared
> > buff/cache   available
> > Mem:           3915          92        3764           0          58    =
    3676
> > Swap:          2044          39        2005
> > The memory exhausting program:
> > #include <stdlib.h>
> > int main()
> > {
> >         while(1)
> >         {
> >         void *ptr =3D
> >                 malloc(1024*1024);
> >          memset(ptr, 0, 1024*1024);
> >         }
> >         return 0;
> > }
> >
The warning and the BUG report is very each to trigger.

>
> I'm not sure what I'm supposed to make of this. Is it that my laptop simp=
ly ran out of memory? That would be odd
> because, as I said earlier, I was simply doing a weekly archive of my sys=
tem. That involved using the dar backup utility
> to create the incremental backup (which in this instance resulted in a si=
ngle archive file), compressing that archive
> with xz and copying (again one at a time) it and a directory containing a=
bout 7000 source and binary rpm files from an
> internal HDD to and external HDD connected via USB
>
> My laptop, which I've had for a little over 3 months, has 32GB of memory.=
 I have been using dar for a few years now (and
> the version currently installed since May) and have had no trouble with i=
t. Similarly, I've used xz to compress the
> backup archives for year and the version currently installed since Decemb=
er 2020. The (incremental) archive file is
> about 7GB and 1.2GB when compressed. If copying files, the largest of whi=
ch is 1.2GB, serially can cause 32GB fn RAM to
> be exhausted , then we are all up the creek. So I don't see where in my n=
ormal archiving process, the memory exhaustion
> would arise from (but I'm happy to be educated on this).
>
> Or is the memory exhaustion likely to be a side effect of the fact that t=
wo patches applied in 5.13.2 are missing a
> pre-requisite? If that's the case there, seems to no disagreement on whet=
her the two patches (which had not been tagged
> for stable) should be reverted or the missing prerequisite should be appl=
ied (along with another, related patch that was
> in the patch set). Perhaps the stable and mm teams are resolving this iss=
ue behind the scenes, but in the meantime I
> have backported the missing patches to 5.13.4 and 5.10.52 and am currentl=
y running the former as my default kernel.
>
> I also have a patch that reverts the two patches that were applied to sta=
ble, so could run with that applied if it would
> be more helpful. It would, of course, leave open the races that the patch=
es are designed to close., but if I've manually
> run swapoff more than once or twice in the twenty years I've been using L=
inux-based systems, I'd be very surprised.
>
> > On Tue, Jul 20, 2021 at 12:47 AM Zhouyi Zhou <zhouzhouyi@gmail.com> wro=
te:
> >>
> >> I downloaded linux-5.13.2, configure and compile the kernel with
> >> CONFIG_LOCKDEP=3Dy
> >> CONFIG_LOCK_DEBUGGING_SUPPORT=3Dy
> >> CONFIG_PROVE_LOCKING=3Dy
> >> CONFIG_DEBUG_SPINLOCK=3Dy
> >> CONFIG_DEBUG_LOCK_ALLOC=3Dy
> >> install the kernel on a qemu box, then run following C Program
> >> #include <stdlib.h>
> >> int main()
> >> {
> >>         while(1)
> >>         {
> >>                 malloc(1024*1024);
+memset(ptr, 0, 1024*1024); /*touch the allocated virtual memory*/
> >>         }
> >>         return 0;
> >> }
> >> And following is the dmesg:
> >> [   96.155017] ------------[ cut here ]------------
> >> [   96.155030] WARNING: CPU: 10 PID: 770 at
> >> kernel/rcu/tree_plugin.h:359 rcu_note_context_switch+0x91/0x610
> >> [   96.155074] Modules linked in: ppdev intel_rapl_msr
> >> intel_rapl_common crct10dif_pclmul crc32_pclmul ghash_clmulni_intel
> >> bochs_drm aesni_intel drm_vram_helper evdev crypto_simd drm_ttm_helper
> >> snd_pcm cryptd ttm snd_timer parport_pc serio_raw drm_kms_helper sg
> >> snd parport soundcore drm pcspkr button ip_tables autofs4 psmouse
> >> sr_mod i2c_piix4 sd_mod crc32c_intel t10_pi cdrom i2c_core e1000
> >> ata_generic floppy
> >> [   96.155180] CPU: 10 PID: 770 Comm: containerd Not tainted 5.13.2 #1
> >> [   96.155185] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> >> BIOS rel-1.11.0-0-g63451fca13-prebuilt.qemu-project.org 04/01/2014
> >> [   96.155189] RIP: 0010:rcu_note_context_switch+0x91/0x610
> >> [   96.155195] Code: ff 74 0f 65 8b 05 a7 10 e5 7e 85 c0 0f 84 22 01
> >> 00 00 45 84 ed 75 15 65 48 8b 04 25 80 7f 01 00 8b b0 44 03 00 00 85
> >> f6 7e 02 <0f> 0b 65 48 8b 04 25 80 7f 01 00 8b 88 44 03 00 00 85 c9 7e
> >> 0f 41
> >> [   96.155200] RSP: 0000:ffffc90000a8bc50 EFLAGS: 00010002
> >> [   96.155204] RAX: ffff88810830c300 RBX: ffff88813bcae680 RCX: 000000=
0000000000
> >> [   96.155208] RDX: 0000000000000002 RSI: 0000000000000001 RDI: 000000=
0000000001
> >> [   96.155210] RBP: ffffc90000a8bcd0 R08: 0000000000000001 R09: 000000=
0000000001
> >> [   96.155213] R10: 0000000000000000 R11: ffffffff81319b93 R12: ffff88=
810830c300
> >> [   96.155216] R13: 0000000000000000 R14: ffff88813bcad958 R15: 000000=
0000004970
> >> [   96.155220] FS:  00007fc09cff9700(0000) GS:ffff88813bc80000(0000)
> >> knlGS:0000000000000000
> >> [   96.155223] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >> [   96.155226] CR2: 00005594d2ff0530 CR3: 0000000103be4001 CR4: 000000=
0000060ee0
> >> [   96.155233] Call Trace:
> >> [   96.155243]  __schedule+0xda/0xa30
> >> [   96.155283]  schedule+0x46/0xf0
> >> [   96.155289]  io_schedule+0x12/0x40
> >> [   96.155295]  __lock_page_or_retry+0x1f9/0x510
> >> [   96.155319]  ? __page_cache_alloc+0x140/0x140
> >> [   96.155345]  do_swap_page+0x33f/0x930
> >> [   96.155364]  __handle_mm_fault+0xa54/0x1550
> >> [   96.155390]  handle_mm_fault+0x17f/0x420
> >> [   96.155400]  do_user_addr_fault+0x1be/0x770
> >> [   96.155422]  exc_page_fault+0x69/0x280
> >> [   96.155435]  ? asm_exc_page_fault+0x8/0x30
> >> [   96.155443]  asm_exc_page_fault+0x1e/0x30
> >> [   96.155448] RIP: 0033:0x5594d15ec98f
> >> [   96.155454] Code: 44 24 58 48 85 c0 48 b9 00 e4 0b 54 02 00 00 00
> >> 48 0f 44 c1 48 89 44 24 58 eb 05 48 8b 44 24 58 48 89 04 24 e8 e2 c9
> >> 9c ff 90 <48> 8b 05 9a 3b a0 01 48 8b 4c 24 50 48 89 0c 24 48 8d 15 9a
> >> c4 ec
> >> [   96.155457] RSP: 002b:000000c0001f7f80 EFLAGS: 00010206
> >> [   96.155462] RAX: 0000000000000000 RBX: 00005594d0f9cf55 RCX: ffffff=
fffffffff8
> >> [   96.155465] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 000055=
94d0fa2d01
> >> [   96.155467] RBP: 000000c0001f7fc0 R08: 0000000000000000 R09: 000000=
0000000000
> >> [   96.155470] R10: 0000000000000000 R11: 0000000000000202 R12: 000000=
0000000004
> >> [   96.155472] R13: 0000000000000013 R14: 00005594d1ee96e6 R15: 000000=
0000000039
> >> [   96.155495] irq event stamp: 10464
> >> [   96.155497] hardirqs last  enabled at (10463): [<ffffffff81c0a574>]
> >> _raw_spin_unlock_irq+0x24/0x50
> >> [   96.155508] hardirqs last disabled at (10464): [<ffffffff81c01882>]
> >> __schedule+0x412/0xa30
> >> [   96.155512] softirqs last  enabled at (8668): [<ffffffff82000401>]
> >> __do_softirq+0x401/0x51b
> >> [   96.155517] softirqs last disabled at (8657): [<ffffffff81129c22>]
> >> irq_exit_rcu+0x142/0x150
> >> [   96.155531] ---[ end trace 165ff31fd86ffc12 ]---
> >>
> >> [   96.177669] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> [   96.177693] [ BUG: Invalid wait context ]
> >> [   96.177717] 5.13.2 #1 Tainted: G        W
> >> [   96.177743] -----------------------------
> >> [   96.177765] containerd/770 is trying to lock:
> >> [   96.177790] ffff88813ba69b30 (&cache->alloc_lock){+.+.}-{3:3}, at:
> >> get_swap_page+0x126/0x200
> >> [   96.177867] other info that might help us debug this:
> >> [   96.177894] context-{4:4}
> >> [   96.177910] 3 locks held by containerd/770:
> >> [   96.177934]  #0: ffff88810815ea28 (&mm->mmap_lock#2){++++}-{3:3},
> >> at: do_user_addr_fault+0x115/0x770
> >> [   96.177999]  #1: ffffffff82915020 (rcu_read_lock){....}-{1:2}, at:
> >> get_swap_device+0x33/0x140
> >> [   96.178057]  #2: ffffffff82955ba0 (fs_reclaim){+.+.}-{0:0}, at:
> >> __fs_reclaim_acquire+0x5/0x30
When lock related bug occurs, above three locks are held by the task.

> >> [   96.178115] stack backtrace:
> >> [   96.178133] CPU: 1 PID: 770 Comm: containerd Tainted: G        W
> >>      5.13.2 #1
> >> [   96.178183] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> >> BIOS rel-1.11.0-0-g63451fca13-prebuilt.qemu-project.org 04/01/2014
> >> [   96.178254] Call Trace:
> >> [   96.178274]  dump_stack+0x82/0xa4
> >> [   96.178314]  __lock_acquire+0x9a5/0x20a0
> >> [   96.178347]  ? find_held_lock+0x3a/0xb0
> >> [   96.178381]  lock_acquire+0xe9/0x320
> >> [   96.178405]  ? get_swap_page+0x126/0x200
> >> [   96.178433]  ? _raw_spin_unlock+0x29/0x40
> >> [   96.178461]  ? page_vma_mapped_walk+0x3a3/0x960
> >> [   96.178491]  __mutex_lock+0x99/0x980
> >> [   96.178515]  ? get_swap_page+0x126/0x200
> >> [   96.178541]  ? find_held_lock+0x3a/0xb0
> >> [   96.178577]  ? get_swap_page+0x126/0x200
> >> [   96.178603]  ? page_referenced+0xd5/0x170
> >> [   96.178637]  ? lock_release+0x1b4/0x300
> >> [   96.178663]  ? get_swap_page+0x126/0x200
> >> [   96.178698]  get_swap_page+0x126/0x200
> >> [   96.178725]  add_to_swap+0x14/0x60
> >> [   96.178749]  shrink_page_list+0xb13/0xe70
> >> [   96.178787]  shrink_inactive_list+0x243/0x550
> >> [   96.178819]  shrink_lruvec+0x4fd/0x780
> >> [   96.178849]  ? shrink_node+0x257/0x7c0
> >> [   96.178873]  shrink_node+0x257/0x7c0
> >> [   96.178900]  do_try_to_free_pages+0xdd/0x410
> >> [   96.178929]  try_to_free_pages+0x110/0x300
> >> [   96.178966]  __alloc_pages_slowpath.constprop.126+0x2ae/0xfa0
> >> [   96.179002]  ? lock_release+0x1b4/0x300
> >> [   96.179028]  __alloc_pages+0x37d/0x400
> >> [   96.179054]  alloc_pages_vma+0x73/0x1d0
> >> [   96.179878]  __read_swap_cache_async+0xb8/0x280
> >> [   96.180684]  swap_cluster_readahead+0x194/0x270
> >> [   96.181459]  ? swapin_readahead+0x62/0x530
> >> [   96.182008]  swapin_readahead+0x62/0x530
> >> [   96.182558]  ? find_held_lock+0x3a/0xb0
> >> [   96.183109]  ? lookup_swap_cache+0x5c/0x1c0
> >> [   96.183657]  ? lock_release+0x1b4/0x300
> >> [   96.184207]  ? do_swap_page+0x232/0x930
> >> [   96.184753]  do_swap_page+0x232/0x930
do_swap_page is the function that cause the problem.

> >> [   96.185326]  __handle_mm_fault+0xa54/0x1550
> >> [   96.185850]  handle_mm_fault+0x17f/0x420
> >> [   96.186361]  do_user_addr_fault+0x1be/0x770
> >> [   96.186880]  exc_page_fault+0x69/0x280
> >> [   96.187382]  ? asm_exc_page_fault+0x8/0x30
> >> [   96.187879]  asm_exc_page_fault+0x1e/0x30
> >> [   96.188363] RIP: 0033:0x5594d0f78da4
> >> [   96.188829] Code: cc cc cc cc cc cc 48 8b 0d 39 d2 01 02 64 48 8b
> >> 09 48 3b 61 10 76 3d 48 83 ec 28 48 89 6c 24 20 48 8d 6c 24 20 48 8b
> >> 44 24 30 <48> 8b 08 48 89 0c 24 48 89 44 24 08 c6 44 24 10 01 e8 76 f4
> >> ff ff
> >> [   96.189894] RSP: 002b:000000c0001f7de8 EFLAGS: 00010216
> >> [   96.190406] RAX: 00005594d2308160 RBX: 0000000000000000 RCX: 000000=
c0004ea480
> >> [   96.190902] RDX: 000000c0002a4270 RSI: 0000000000000010 RDI: 000000=
0000000011
> >> [   96.191394] RBP: 000000c0001f7e08 R08: 0000000000000002 R09: 000000=
0000000011
> >> [   96.191891] R10: 00005594d22f6ce0 R11: 00005594d1ee96e4 R12: ffffff=
ffffffffff
> >> [   96.192396] R13: 0000000000000028 R14: 0000000000000027 R15: 000000=
0000000200
> >> [  115.344546] exaust invoked oom-killer:
> >> gfp_mask=3D0x100dca(GFP_HIGHUSER_MOVABLE|__GFP_ZERO), order=3D0,
> >> oom_score_adj=3D0
> >> [  115.346019] CPU: 1 PID: 969 Comm: exaust Tainted: G        W
> >>  5.13.2 #1
> >> [  115.346569] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> >> BIOS rel-1.11.0-0-g63451fca13-prebuilt.qemu-project.org 04/01/2014
> >> [  115.347712] Call Trace:
> >> [  115.348287]  dump_stack+0x82/0xa4
> >> [  115.348867]  dump_header+0x55/0x3f0
> >> [  115.349491]  oom_kill_process+0x160/0x210
> >> [  115.350068]  out_of_memory+0x10b/0x630
> >> [  115.350646]  __alloc_pages_slowpath.constprop.126+0xec7/0xfa0
> >> [  115.351255]  __alloc_pages+0x37d/0x400
> >> [  115.351861]  alloc_pages_vma+0x73/0x1d0
> >> [  115.352449]  __handle_mm_fault+0xe1b/0x1550
> >> [  115.353042]  handle_mm_fault+0x17f/0x420
> >> [  115.353646]  do_user_addr_fault+0x1be/0x770
> >> [  115.354239]  exc_page_fault+0x69/0x280
> >> [  115.354833]  ? asm_exc_page_fault+0x8/0x30
> >> [  115.355428]  asm_exc_page_fault+0x1e/0x30
> >> [  115.356021] RIP: 0033:0x7fe8ee633543
> >> [  115.356617] Code: Unable to access opcode bytes at RIP 0x7fe8ee6335=
19.
> >> [  115.357245] RSP: 002b:00007fff742c68c8 EFLAGS: 00010206
> >> [  115.357857] RAX: 00007fe798041010 RBX: 0000000000000000 RCX: 00007f=
e7980fd000
> >> [  115.358469] RDX: 00007fe798141000 RSI: 0000000000000000 RDI: 00007f=
e798041010
> >> [  115.359077] RBP: 00007fff742c68e0 R08: 00000000ffffffff R09: 000000=
0000000000
> >> [  115.359686] R10: 0000000000000022 R11: 0000000000000246 R12: 000056=
1abe3fa060
> >> [  115.360300] R13: 00007fff742c69c0 R14: 0000000000000000 R15: 000000=
0000000000
> >> [  115.361313] Mem-Info:
> >> [  115.362285] active_anon:188386 inactive_anon:764572 isolated_anon:6=
4
> >>                 active_file:61 inactive_file:0 isolated_file:0
> >>                 unevictable:0 dirty:0 writeback:2
> >>                 slab_reclaimable:6676 slab_unreclaimable:6200
> >>                 mapped:155 shmem:180 pagetables:3124 bounce:0
> >>                 free:25647 free_pcp:0 free_cma:0
> >> [  115.366889] Node 0 active_anon:782092kB inactive_anon:3029744kB
> >> active_file:244kB inactive_file:0kB unevictable:0kB
> >> isolated(anon):256kB isolated(file):0kB mapped:620kB dirty:0kB
> >> writeback:8kB shmem:720kB shmem_thp: 0kB shmem_pmdmapped: 0kB
> >> anon_thp: 0kB writeback_tmp:0kB kernel_stack:3904kB pagetables:12496kB
> >> all_unreclaimable? no
> >> [  115.369378] Node 0 DMA free:15296kB min:260kB low:324kB high:388kB
> >> reserved_highatomic:0KB active_anon:0kB inactive_anon:0kB
> >> active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB
> >> present:15992kB managed:15360kB mlocked:0kB bounce:0kB free_pcp:0kB
> >> local_pcp:0kB free_cma:0kB
> >> [  115.372121] lowmem_reserve[]: 0 2925 3874 3874
> >> [  115.373195] Node 0 DMA32 free:54436kB min:50824kB low:63528kB
> >> high:76232kB reserved_highatomic:0KB active_anon:819596kB
> >> inactive_anon:2135980kB active_file:48kB inactive_file:24kB
> >> unevictable:0kB writepending:8kB present:3129212kB managed:3021488kB
> >> mlocked:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
> >> [  115.375958] lowmem_reserve[]: 0 0 949 949
> >> [  115.377064] Node 0 Normal free:32856kB min:32880kB low:37004kB
> >> high:41128kB reserved_highatomic:0KB active_anon:2232kB
> >> inactive_anon:853384kB active_file:80kB inactive_file:76kB
> >> unevictable:0kB writepending:0kB present:1048576kB managed:972400kB
> >> mlocked:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
> >> [  115.380050] lowmem_reserve[]: 0 0 0 0
> >> [  115.380908] Node 0 DMA: 0*4kB 0*8kB 0*16kB 0*32kB 1*64kB (U)
> >> 1*128kB (U) 1*256kB (U) 1*512kB (U) 0*1024kB 1*2048kB (M) 3*4096kB (M)
> >> =3D 15296kB
> >> [  115.382728] Node 0 DMA32: 86*4kB (UM) 52*8kB (UME) 33*16kB (UM)
> >> 28*32kB (UME) 11*64kB (U) 2*128kB (UE) 0*256kB 1*512kB (U) 2*1024kB
> >> (UM) 2*2048kB (ME) 11*4096kB (M) =3D 54856kB
> >> [  115.384560] Node 0 Normal: 597*4kB (UME) 904*8kB (UME) 414*16kB
> >> (UME) 187*32kB (UME) 64*64kB (UME) 19*128kB (UME) 3*256kB (U) 3*512kB
> >> (UE) 2*1024kB (M) 0*2048kB 0*4096kB =3D 33108kB
> >> [  115.386558] Node 0 hugepages_total=3D0 hugepages_free=3D0
> >> hugepages_surp=3D0 hugepages_size=3D1048576kB
> >> [  115.387543] Node 0 hugepages_total=3D0 hugepages_free=3D0
> >> hugepages_surp=3D0 hugepages_size=3D2048kB
> >> [  115.388503] 61467 total pagecache pages
> >> [  115.389532] 61242 pages in swap cache
> >> [  115.390450] Swap cache stats: add 523756, delete 462538, find 69/17=
1
> >> [  115.391383] Free swap  =3D 0kB
> >> [  115.392312] Total swap =3D 2094076kB
> >> [  115.393506] 1048445 pages RAM
> >> [  115.394538] 0 pages HighMem/MovableOnly
> >> [  115.395514] 46133 pages reserved
> >> [  115.396525] 0 pages hwpoisoned
> >> [  115.397824] Tasks state (memory values in pages):
> >> [  115.398778] [  pid  ]   uid  tgid total_vm      rss pgtables_bytes
> >> swapents oom_score_adj name
> >> [  115.399792] [    312]     0   312     6603      217    98304
> >> 181             0 systemd-journal
> >> [  115.400749] [    339]     0   339     5562        1    69632
> >> 395         -1000 systemd-udevd
> >> [  115.401869] [    379]   101   379    23271       17    81920
> >> 197             0 systemd-timesyn
> >> [  115.402873] [    388]   107   388     1707        7    53248
> >> 101             0 rpcbind
> >> [  115.403869] [    479]     0   479     2373       39    53248
> >> 284             0 dhclient
> >> [  115.404849] [    485]     0   485     2120        8    53248
> >> 43             0 cron
> >> [  115.406291] [    487]     0   487     4869       44    77824
> >> 197             0 systemd-logind
> >> [  115.407536] [    494]   104   494     2247       58    57344
> >> 80          -900 dbus-daemon
> >> [  115.408772] [    501]     0   501    56457        0    86016
> >> 226             0 rsyslogd
> >> [  115.410041] [    503]     0   503   315093      769   311296
> >> 3943             0 containerd
> >> [  115.411289] [    507]     0   507     1404        2    45056
> >> 26             0 agetty
> >> [  115.412563] [    521]     0   521    27588      235   110592
> >> 1678             0 unattended-upgr
> >> [  115.413834] [    860]     0   860     3964       28    73728
> >> 187         -1000 sshd
> >> [  115.415062] [    866]   106   866     5015       19    81920
> >> 187             0 exim4
> >> [  115.416286] [    901]     0   901     4233        1    73728
> >> 281             0 sshd
> >> [  115.417534] [    928]     0   928     5287       57    73728
> >> 280             0 systemd
> >> [  115.418755] [    929]     0   929     5710       77    90112
> >> 488             0 (sd-pam)
> >> [  115.419921] [    943]     0   943     2013        1    53248
> >> 407             0 bash
> >> [  115.421061] [    969]     0   969  1402762   888995 11276288
> >> 513120             0 exaust
> >> [  115.421973] [    970]     0   970     4233      272    77824
> >> 5             0 sshd
> >> [  115.422840] [    976]     0   976     1980      297    53248
> >> 64             0 bash
> >> [  115.423664] oom-kill:constraint=3DCONSTRAINT_NONE,nodemask=3D(null)=
,cpuset=3D/,mems_allowed=3D0,global_oom,task_memcg=3D/user.slice/user-0.sli=
ce/session-1.scope,task=3Dexaust,pid=3D969,uid=3D0
> >> [  115.425344] Out of memory: Killed process 969 (exaust)
> >> total-vm:5611048kB, anon-rss:3555976kB, file-rss:4kB, shmem-rss:0kB,
> >> UID:0 pgtables:11012kB oom_score_adj:0
> >> [  115.912696] oom_reaper: reaped process 969 (exaust), now
> >> anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
> >>
> >>
> >> I can tell from above that:  [   96.177999]  #1: ffffffff82915020
> >> (rcu_read_lock){....}-{1:2}, at: get_swap_device+0x33/0x140
> >>  get_swap_device did help the rcu_read_lock
> >>
> >> Thanks
> >> Zhouyi
> >>
> >> On Mon, Jul 19, 2021 at 8:23 PM Oleksandr Natalenko
> >> <oleksandr@natalenko.name> wrote:
> >>>
> >>> On pond=C4=9Bl=C3=AD 19. =C4=8Dervence 2021 14:16:04 CEST Matthew Wil=
cox wrote:
> >>>> On Mon, Jul 19, 2021 at 02:12:15PM +0200, Oleksandr Natalenko wrote:
> >>>>> On pond=C4=9Bl=C3=AD 19. =C4=8Dervence 2021 14:08:37 CEST Miaohe Li=
n wrote:
> >>>>>> On 2021/7/19 19:59, Oleksandr Natalenko wrote:
> >>>>>>> On pond=C4=9Bl=C3=AD 19. =C4=8Dervence 2021 13:50:07 CEST Miaohe =
Lin wrote:
> >>>>>>>> On 2021/7/19 19:22, Matthew Wilcox wrote:
> >>>>>>>>> On Mon, Jul 19, 2021 at 07:12:58PM +0800, Miaohe Lin wrote:
> >>>>>>>>>> When in the commit 2799e77529c2a, we're using the percpu_ref t=
o
> >>>>>>>>>> serialize
> >>>>>>>>>> against concurrent swapoff, i.e. there's percpu_ref inside
> >>>>>>>>>> get_swap_device() instead of rcu_read_lock(). Please see commi=
t
> >>>>>>>>>> 63d8620ecf93 ("mm/swapfile: use percpu_ref to serialize agains=
t
> >>>>>>>>>> concurrent swapoff") for detail.
> >>>>>>>>>
> >>>>>>>>> Oh, so this is a backport problem.  2799e77529c2 was backported
> >>>>>>>>> without
> >>>>>>>>> its prerequisite 63d8620ecf93.  Greg, probably best to just dro=
p
> >>>>>>>>
> >>>>>>>> Yes, they're posted as a patch set:
> >>>>>>>>
> >>>>>>>> https://lkml.kernel.org/r/20210426123316.806267-1-linmiaohe@huaw=
ei.co
> >>>>>>>> m
> >>>>>>>>
> >>>>>>>>> 2799e77529c2 from all stable trees; the race described is not v=
ery
> >>>>>>>>> important (swapoff vs reading a page back from that swap device=
).
> >>>>>>>>> .
> >>>>>>>>
> >>>>>>>> The swapoff races with reading a page back from that swap device
> >>>>>>>> should
> >>>>>>>> be
> >>>>>>>> really uncommon as most users only do swapoff when the system is
> >>>>>>>> going to
> >>>>>>>> shutdown.
> >>>>>>>>
> >>>>>>>> Sorry for the trouble!
> >>>>>>>
> >>>>>>> git log --oneline v5.13..v5.13.3 --author=3D"Miaohe Lin"
> >>>>>>> 11ebc09e50dc mm/zswap.c: fix two bugs in zswap_writeback_entry()
> >>>>>>> 95d192da198d mm/z3fold: use release_z3fold_page_locked() to relea=
se
> >>>>>>> locked
> >>>>>>> z3fold page
> >>>>>>> ccb7848e2344 mm/z3fold: fix potential memory leak in
> >>>>>>> z3fold_destroy_pool()
> >>>>>>> 9f7229c901c1 mm/huge_memory.c: don't discard hugepage if other
> >>>>>>> processes
> >>>>>>> are mapping it
> >>>>>>> f13259175e4f mm/huge_memory.c: add missing read-only THP checking=
 in
> >>>>>>> transparent_hugepage_enabled()
> >>>>>>> afafd371e7de mm/huge_memory.c: remove dedicated macro
> >>>>>>> HPAGE_CACHE_INDEX_MASK a533a21b692f mm/shmem: fix shmem_swapin() =
race
> >>>>>>> with swapoff
> >>>>>>> c3b39134bbd0 swap: fix do_swap_page() race with swapoff
> >>>>>>>
> >>>>>>> Do you suggest reverting "mm/shmem: fix shmem_swapin() race with
> >>>>>>> swapoff"
> >>>>>>> as well?
> >>>>>>
> >>>>>> This patch also rely on its prerequisite 63d8620ecf93. I think we =
should
> >>>>>> either revert any commit in this series or just backport the entir=
e
> >>>>>> series.
> >>>>>
> >>>>> Then why not just pick up 2 more patches instead of dropping 2 patc=
hes.
> >>>>> Greg, could you please make sure the whole series from [1] gets pul=
led?
> >>>>
> >>>> Because none of these patches should have been backported in the fir=
st
> >>>> place.  It's just not worth the destabilisation.
> >>>
> >>> What about the rest then?
> >>>
> >>> git log --oneline v5.13..v5.13.3 -- mm/ | wc -l
> >>> 18
> >>>
> >>> Those look to be fixes, these ones too.
> >>>
> >>> --
> >>> Oleksandr Natalenko (post-factum)
> >>>
> >>>

Best Wishes
Zhouyi
