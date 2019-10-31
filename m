Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B23D4EAC6C
	for <lists+stable@lfdr.de>; Thu, 31 Oct 2019 10:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbfJaJOE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Oct 2019 05:14:04 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38655 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726776AbfJaJOE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Oct 2019 05:14:04 -0400
Received: by mail-wr1-f66.google.com with SMTP id v9so5351163wrq.5;
        Thu, 31 Oct 2019 02:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DwGRG3/zucfy6TYRbn+kLcFz9oFEfIbTg62MDuhmTvw=;
        b=RxFlxK/AAf/AV/xFCW+o3VzXwY9++S8LJxI8XWv3DsA130Tq9UCM6NCETf/Ah4XQcq
         Z7Gb92BzN2mEWenbTKbsA/jUA1+7g0q4v6VyaWrGZqA0DHZQb7EIFJdxk5hhMrjgxKjT
         dPA1QOFzq9rODYSBhCCeOFXXwEWBUTHvcSxxboPPbdBtOSZeCNOJGVEPAcFs+0vvvAgr
         tQ05fnkgCrBwiXNOpEXBsvhGOaujGQPBVFW3vY7ZS7p58jT4TIRF7l6whDBEjdv2tswb
         Zyy3yckc2h/skp1W+ygxazD5uB1vlDzxVYcoyTXgbsOCOTEqh4mjM/A+j987FaB7TCzD
         3lAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DwGRG3/zucfy6TYRbn+kLcFz9oFEfIbTg62MDuhmTvw=;
        b=WB8wwIOhv7rddSa3ETLCiVv/w9u2r4+wLMlrXGLYlUeT98Fyk+297q+GWgR/Bfrs7P
         AdCZWEndNALCYJJYl+oln+jjdDGVNfbXbTw7prR01ZBgq0GY3VY/ec19UKMFAhx1OrYI
         7QMi3R119tMVx/z3qO53ub0iXzHhev0jjvvFxsbrZmXe7aQM7vNBLXsnxsDpEiBet8rY
         KD1OOdbEX7uevW6EPg8PXK7oPIJ3kzsO72eedBuLnA44Zu6iQQaK15RNuWwL4DiJCvmj
         dJplO/fcmnwXFDZ9KLiAdLkVHiSjz/ec3BUYU0l7MFqdJylbqRs7qwDgLbdqQ6Wkll+r
         ApRQ==
X-Gm-Message-State: APjAAAWX3LR5tR3rKtutFW9MTvTJdELCrYTPNPoX//lH3V+a84/QRQAu
        H9gTrOW1t/H+sy2u2Nbn4eEbHA20i43trY+fr4o=
X-Google-Smtp-Source: APXvYqzZlyy0ojCdisc5mKiP7KI3KB8ScsjkNt2woKbQi+qwZtspMo5DxjNMK8nd/6Z9nQeoGERizX+B/EOjYztFaOk=
X-Received: by 2002:adf:f78f:: with SMTP id q15mr4335498wrp.282.1572513241149;
 Thu, 31 Oct 2019 02:14:01 -0700 (PDT)
MIME-Version: 1.0
References: <20191027203259.948006506@linuxfoundation.org> <20191027203307.303661015@linuxfoundation.org>
 <3e9de35dda19c0ac207d49d24c2735655b1d8d64.camel@nokia.com>
In-Reply-To: <3e9de35dda19c0ac207d49d24c2735655b1d8d64.camel@nokia.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 31 Oct 2019 17:14:15 +0800
Message-ID: <CADvbK_dx=dT6j-XMA=p9QgJJp5YgA2zRCLuY08u4pz0v=vXorw@mail.gmail.com>
Subject: Re: [PATCH 4.14 024/119] sctp: change sctp_prot .no_autobind with true
To:     "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
Cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "syzbot+d44f7bbebdea49dbc84a@syzkaller.appspotmail.com" 
        <syzbot+d44f7bbebdea49dbc84a@syzkaller.appspotmail.com>,
        "marcelo.leitner@gmail.com" <marcelo.leitner@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 31, 2019 at 3:54 PM Rantala, Tommi T. (Nokia - FI/Espoo)
<tommi.t.rantala@nokia.com> wrote:
>
> On Sun, 2019-10-27 at 22:00 +0100, Greg Kroah-Hartman wrote:
> > From: Xin Long <lucien.xin@gmail.com>
> >
> > [ Upstream commit 63dfb7938b13fa2c2fbcb45f34d065769eb09414 ]
> >
> > syzbot reported a memory leak:
> >
> >   BUG: memory leak, unreferenced object 0xffff888120b3d380 (size 64):
> >   backtrace:
> >
> >     [...] slab_alloc mm/slab.c:3319 [inline]
> >     [...] kmem_cache_alloc+0x13f/0x2c0 mm/slab.c:3483
> >     [...] sctp_bucket_create net/sctp/socket.c:8523 [inline]
> >     [...] sctp_get_port_local+0x189/0x5a0 net/sctp/socket.c:8270
> >     [...] sctp_do_bind+0xcc/0x200 net/sctp/socket.c:402
> >     [...] sctp_bindx_add+0x4b/0xd0 net/sctp/socket.c:497
> >     [...] sctp_setsockopt_bindx+0x156/0x1b0 net/sctp/socket.c:1022
> >     [...] sctp_setsockopt net/sctp/socket.c:4641 [inline]
> >     [...] sctp_setsockopt+0xaea/0x2dc0 net/sctp/socket.c:4611
> >     [...] sock_common_setsockopt+0x38/0x50 net/core/sock.c:3147
> >     [...] __sys_setsockopt+0x10f/0x220 net/socket.c:2084
> >     [...] __do_sys_setsockopt net/socket.c:2100 [inline]
> >
> > It was caused by when sending msgs without binding a port, in the path:
> > inet_sendmsg() -> inet_send_prepare() -> inet_autobind() ->
> > .get_port/sctp_get_port(), sp->bind_hash will be set while bp->port is
> > not. Later when binding another port by sctp_setsockopt_bindx(), a new
> > bucket will be created as bp->port is not set.
> >
> > sctp's autobind is supposed to call sctp_autobind() where it does all
> > things including setting bp->port. Since sctp_autobind() is called in
> > sctp_sendmsg() if the sk is not yet bound, it should have skipped the
> > auto bind.
> >
> > THis patch is to avoid calling inet_autobind() in inet_send_prepare()
> > by changing sctp_prot .no_autobind with true, also remove the unused
> > .get_port.
>
> Hi,
>
> I'm seeing SCTP oops in 4.14.151, reproducible easily with iperf:
>
> # iperf3 -s -1 &
> # iperf3 -c localhost --sctp
>
> This patch was also included in 4.19.81, but there it seems to be working
> fine.
>
> Any ideas if this patch is valid for 4.14, or what's missing in 4.14 to
> make this work?
pls get this commit into 4.14, which has been in 4.19:

commit 644fbdeacf1d3edd366e44b8ba214de9d1dd66a9
Author: Xin Long <lucien.xin@gmail.com>
Date:   Sun May 20 16:39:10 2018 +0800

    sctp: fix the issue that flags are ignored when using kernel_connect

>
>
> [   29.179116] sctp: Hash tables configured (bind 256/256)
> [   29.188846] BUG: unable to handle kernel NULL pointer dereference
> at           (null)
> [   29.190189] IP:           (null)
> [   29.190758] PGD 0 P4D 0
> [   29.191224] Oops: 0010 [#1] SMP PTI
> [   29.191786] Modules linked in: hmac sctp libcrc32c isofs kvm_intel kvm
> irqbypass sch_fq_codel pcbc aesni_intel aes_x86_64 crypto_simd cryptd
> glue_helper ata_piix dm_mirror dm_region_hash dm_log dm_mod dax autofs4
> [   29.194585] CPU: 5 PID: 733 Comm: iperf3 Not tainted 4.14.151-1.x86_64
> #1
> [   29.195689] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> 1.12.0-2.fc30 04/01/2014
> [   29.197009] task: ffff93edb0e65bc0 task.stack: ffff9fcdc11b8000
> [   29.197916] RIP: 0010:          (null)
> [   29.198532] RSP: 0018:ffff9fcdc11bbe50 EFLAGS: 00010246
> [   29.199349] RAX: 0000000000000000 RBX: ffff93edb02d0680 RCX:
> 0000000000000002
> [   29.200426] RDX: 0000000000000001 RSI: 0000000000000000 RDI:
> ffff93edb02d0680
> [   29.201497] RBP: 000000000000001c R08: 0100000000000000 R09:
> 0000564277abb4e8
> [   29.202577] R10: 0000000000000000 R11: 0000000000000000 R12:
> ffff9fcdc11bbe90
> [   29.203656] R13: 0000564277abb4e0 R14: 0000000000000000 R15:
> 0000000000000000
> [   29.204737] FS:  00007f0f6242cb80(0000) GS:ffff93edbfd40000(0000)
> knlGS:0000000000000000
> [   29.205967] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   29.206863] CR2: 0000000000000000 CR3: 000000023037c002 CR4:
> 00000000003606e0
> [   29.207958] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [   29.209079] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> 0000000000000400
> [   29.210162] Call Trace:
> [   29.210577]  inet_autobind+0x2c/0x60
> [   29.211172]  inet_dgram_connect+0x45/0x80
> [   29.211808]  SYSC_connect+0x89/0xb0
> [   29.212384]  ? sock_map_fd+0x3d/0x60
> [   29.212960]  do_syscall_64+0x74/0x190
> [   29.213517]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> [   29.214212] RIP: 0033:0x7f0f626b5758
> [   29.214710] RSP: 002b:00007ffc7ca624f8 EFLAGS: 00000246 ORIG_RAX:
> 000000000000002a
> [   29.215727] RAX: ffffffffffffffda RBX: 0000564277aba260 RCX:
> 00007f0f626b5758
> [   29.216660] RDX: 000000000000001c RSI: 0000564277abb4e0 RDI:
> 0000000000000005
> [   29.217613] RBP: 0000000000000005 R08: 0000564277abc9d0 R09:
> 0000564277abb4e8
> [   29.218604] R10: 0000000000000000 R11: 0000000000000246 R12:
> 00007f0f627a7170
> [   29.219606] R13: 00007ffc7ca62520 R14: 0000564277aba260 R15:
> 0000000000000001
> [   29.220596] Code:  Bad RIP value.
> [   29.221075] RIP:           (null) RSP: ffff9fcdc11bbe50
> [   29.221772] CR2: 0000000000000000
> [   29.222260] ---[ end trace 831c4c1f11109ca0 ]---
>
>
> > Reported-by: syzbot+d44f7bbebdea49dbc84a@syzkaller.appspotmail.com
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  net/sctp/socket.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > --- a/net/sctp/socket.c
> > +++ b/net/sctp/socket.c
> > @@ -8313,7 +8313,7 @@ struct proto sctp_prot = {
> >       .backlog_rcv =  sctp_backlog_rcv,
> >       .hash        =  sctp_hash,
> >       .unhash      =  sctp_unhash,
> > -     .get_port    =  sctp_get_port,
> > +     .no_autobind =  true,
> >       .obj_size    =  sizeof(struct sctp_sock),
> >       .sysctl_mem  =  sysctl_sctp_mem,
> >       .sysctl_rmem =  sysctl_sctp_rmem,
> > @@ -8352,7 +8352,7 @@ struct proto sctpv6_prot = {
> >       .backlog_rcv    = sctp_backlog_rcv,
> >       .hash           = sctp_hash,
> >       .unhash         = sctp_unhash,
> > -     .get_port       = sctp_get_port,
> > +     .no_autobind    = true,
> >       .obj_size       = sizeof(struct sctp6_sock),
> >       .sysctl_mem     = sysctl_sctp_mem,
> >       .sysctl_rmem    = sysctl_sctp_rmem,
> >
> >
>
