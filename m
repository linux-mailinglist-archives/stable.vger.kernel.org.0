Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5F135821F3
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 10:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiG0IUx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 04:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiG0IUv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 04:20:51 -0400
X-Greylist: delayed 529 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 27 Jul 2022 01:20:51 PDT
Received: from wnew3-smtp.messagingengine.com (wnew3-smtp.messagingengine.com [64.147.123.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13D563C16C;
        Wed, 27 Jul 2022 01:20:50 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.west.internal (Postfix) with ESMTP id 777522B05A15;
        Wed, 27 Jul 2022 04:11:57 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 27 Jul 2022 04:11:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1658909516; x=1658916716; bh=Ujzoa7+jS8
        fYmceJHmeFpMQR3KXUNY5FvTEHQqyR5LA=; b=dShcvtJbMiAa/sWG9PWNR0OApg
        TpLcNilzPqQpkfuZSb/81vFuDInCf8BtqJceCIEfUa7XwE9GKoI0pjJjLe+GTTuE
        jcYylFUpwwvRDHCAf1b/wqbQezuJy6DitsrfkAuHNw6QYEXIw9lXpgEQMdNHaYzY
        0G4M+aAyVlT5n0WkWLnPV7ueGXnhV+UO9Oio9dEUcmkfwDcQSjSqrwBmMHM2qCKS
        AFXm29HcOXAuuU322Ayy6mk319CsysJwIp3fJzypa69551CeWt+1elQR1x5wLY+f
        VNSPq36+IMoKzYDSBitWi+ouxCHdrWn/0G0H6A5XA4JSUqujwHWrsZyAvuDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1658909516; x=1658916716; bh=Ujzoa7+jS8fYmceJHmeFpMQR3KXU
        NY5FvTEHQqyR5LA=; b=bbNjEDBGaZ3eYhYSuh4TkgaXzlzMxSsV2LJP1cpRmk3y
        U6St2BVN4edJlkhzHfUIKp9PJVaGyZql44Vz8z+2dpxiPeTq9rYa6tNJUBlWZ8cc
        1SVtumVOHzw8G2WTnAk5j4XKKwzu58O5x3HySJdNAPGZM2Olh1P3hP0m9BChS7SK
        GW4g89IhaQNJB6rLL5HSVd04reHBTEmL1zLsaUWJeeusDJGJjrk4XtpLGup1z/R6
        G5SKmq23h+9yj9kcvI8uAue8HWLGJnjjFg7K5SZaOBfhhxpyI+qzRmvK3J4oYj4Y
        LLQ+wLRh36t9SkFQzZy4MNzfJDOzfkjmLHxueEUdLg==
X-ME-Sender: <xms:TPPgYieolKFn6F3EyXwB0m0NXzlQLQR3-HCvZUjbsOpMAvah5bGqFA>
    <xme:TPPgYsO-SHloPHsbkim72Pa4mhksLjr1ttpUFMPX0VqLQHzmcXjwtf-LX4HH-hgFX
    FieU2wlH6rjzQ>
X-ME-Received: <xmr:TPPgYjjDgOxD9hH-fdaHJJrVIawEOczrePbw3TckFHx0cgRt3ruS3nhu-dTi2uEyjCrpPC-usOSPMFPgTo_v4u9XTnAm9yIe>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdduvdcutefuodetggdotefrodftvfcurf
    hrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcumffj
    uceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeegheeuhefgtd
    eluddtleekfeegjeetgeeikeehfeduieffvddufeefleevtddtvdenucffohhmrghinhep
    khgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:TPPgYv_aui7llQbtInQMN-hRgl3ecjvyJdivxgPuAidPYfvFlEHNlQ>
    <xmx:TPPgYuscqAfDhAkUmX67YKm9AxpISPuZePYNgvs5UGIu2XlMu-94Rw>
    <xmx:TPPgYmEOGkDvf0lKeCCwuBzcwzEQIua7gQMpdtD4MgjZs04SEUfgLw>
    <xmx:TPPgYvOxUA4gRVcWSqLtQPRcYTKSTM8lAvMeyD3Q7w0Q6YwlocvmcYL7P7E>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 27 Jul 2022 04:11:56 -0400 (EDT)
Date:   Wed, 27 Jul 2022 10:11:33 +0200
From:   Greg KH <greg@kroah.com>
To:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc:     stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>, johan.hedberg@gmail.com,
        harshit.m.mogalapalli@gmail.com,
        Ramanan Govindarajan <ramanan.govindarajan@oracle.com>,
        linux-bluetooth@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        George Kennedy <george.kennedy@oracle.com>,
        John Donnelly <john.p.donnelly@oracle.com>
Subject: Re: Backport request to fix a WARNING in sco_sock_sendmsg on LTS
Message-ID: <YuDzNUkeEv37sR2S@kroah.com>
References: <fd01f110-05ce-569c-4910-722a5fab9f1c@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd01f110-05ce-569c-4910-722a5fab9f1c@oracle.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 27, 2022 at 01:26:49PM +0530, Harshit Mogalapalli wrote:
> Hi,
> 
> We have seen a WARNING message while fuzzing with syzkaller.
> 
> 
> Kernel 5.15.54 on an x86_64
> 
> localhost login: [  104.557712] ------------[ cut here ]------------
> [  104.558404] WARNING: CPU: 1 PID: 15544 at mm/page_alloc.c:5358
> __alloc_pages+0x38a/0x410
> [  104.559584] Modules linked in:
> [  104.560030] CPU: 1 PID: 15544 Comm: repro Not tainted 5.15.54 #1
> [  104.560896] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> 1.11.0-2.el7 04/01/2014
> [  104.562190] RIP: 0010:__alloc_pages+0x38a/0x410
> [  104.562864] Code: ff 4c 89 fa 44 89 f6 89 ef 89 6c 24 48 c6 44 24 78 00
> 4c 89 6c 24 60 e8 c4 e5 ff ff 49 89 c4 e9 43 fe ff ff 40 80 e5 3f eb c5 <0f>
> 0b eb a5 4c 89 e7 44 89 f6 45 31 e4 e8 c4 9f ff ff e9 4a fe ff
> [  104.565421] RSP: 0018:ffff88801b4577f0 EFLAGS: 00010246
> [  104.566182] RAX: 0000000000000000 RBX: 1ffff1100368aeff RCX:
> dffffc0000000000
> [  104.567177] RDX: 0000000000000000 RSI: 0000000000000012 RDI:
> 0000000000040cc0
> [  104.568185] RBP: 0000000000000000 R08: 0000000000000000 R09:
> 0000000000000000
> [  104.569196] R10: fffffff900000000 R11: 0000000000000001 R12:
> 0000000000000001
> [  104.570194] R13: 0000000000000000 R14: 0000000000000000 R15:
> 0000000000000000
> [  104.571201] FS:  00007fda701c7740(0000) GS:ffff888107080000(0000)
> knlGS:0000000000000000
> [  104.572330] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  104.573146] CR2: 0000000020004640 CR3: 0000000020c34000 CR4:
> 00000000000006e0
> [  104.574149] Call Trace:
> [  104.574503]  <TASK>
> [  104.574838]  ? __sanitizer_cov_trace_cmp4+0x25/0x90
> [  104.575535]  ? __alloc_pages_slowpath.constprop.0+0x16c0/0x16c0
> [  104.576391]  ? bpf_ksym_find+0x171/0x1c0
> [  104.576985]  ? selinux_socket_sendmsg+0x207/0x2d0
> [  104.577938]  ? __sanitizer_cov_trace_const_cmp8+0x27/0x90
> [  104.578739]  alloc_pages+0x191/0x3f0
> [  104.579258]  kmalloc_order+0x34/0xb0
> [  104.579794]  kmalloc_order_trace+0x19/0xa0
> [  104.580375]  sco_sock_sendmsg+0x10f/0x300
> [  104.581228]  ? security_socket_sendmsg+0x8e/0xc0
> 
> 
> I have attached the report and the reproducer. A similar warning is seen
> on some testing previously.
> 
> Ref: https://lore.kernel.org/linux-mm/812dab5c-845d-df58-2752-abea7c07890@google.com/
> 
> Commit: 99c23da0eed4 ("Bluetooth: sco: Fix lock_sock() blockage by
> memcpy_from_msg()") is backported to LTS. So we have this bug on LTS
> branches.
> 
> The Fix commit is not backported to LTS.
> Commit: 0771cbb3b97d ("Bluetooth: SCO: Replace use of memcpy_from_msg
> with bt_skb_sendmsg")
> 
> I have tried backporting onto LTS locally.
> 
> Can you please backport the following commits to these branches.
> 4.14.y, 4.19.y, 5.4.y, 5.10.y, 5.15.y LTS. (applying from 1 to 7)
> 
> 1. commit 38f64f650dc0e44c146ff88d15a7339efa325918 upstream
> 	("Bluetooth: Add bt_skb_sendmsg helper")
> 2. commit 97e4e80299844bb5f6ce5a7540742ffbffae3d97 upstream
> 	("Bluetooth: Add bt_skb_sendmmsg helper")
> 3. commit 0771cbb3b97d3c1d68eecd7f00055f599954c34e upstream
> 	("Bluetooth: SCO: Replace use of memcpy_from_msg with bt_skb_sendmsg")
> 4. commit 81be03e026dc0c16dc1c64e088b2a53b73caa895 upstream
> 	("Bluetooth: RFCOMM: Replace use of memcpy_from_msg with bt_skb_sendmmsg")
> 5. commit 266191aa8d14b84958aaeb5e96ee4e97839e3d87 upstream
> 	("Bluetooth: Fix passing NULL to PTR_ERR")
> 6. commit 037ce005af6b8a3e40ee07c6e9266c8997e6a4d6 upstream
> 	("Bluetooth: SCO: Fix sco_send_frame returning
> skb->len")
> 7. commit 29fb608396d6a62c1b85acc421ad7a4399085b9f upstream
> 	("Bluetooth: Fix bt_skb_sendmmsg not allocating partial chunks")
> 
> 
> Notes:
> 3 is the fix for the WARNING.
> 1,2 are prerequisites for applying 3. At this stage the WARNING is fixed.
> 4,5,6,7 are necessary as they are fixing newly introduced commits by us.
> 
> This is a clean cherry-pick series(7 commits) on all mentioned branches(LTS
> 4.14->5.15)
> 
> I have tested all mentioned LTS branches with the reproducer(only) and the
> WARNING is fixed after applying these 7 patches.

All now queued up, thanks.

greg k-h
