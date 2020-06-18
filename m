Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5161FF842
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 17:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728480AbgFRP4C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 11:56:02 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:48451 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728414AbgFRP4C (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jun 2020 11:56:02 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 3056F1940257;
        Thu, 18 Jun 2020 11:56:01 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 18 Jun 2020 11:56:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=9eYpLL
        hMYHpIc0pyoS2fPbB4bfjtvNEmEpjYtDu589w=; b=LE1u5gkG1K6fW/Ywuy0tIV
        7R2K31HaM+xTL1BQFJ6k2vZW/gIH6dk32rYFpB6qut/d1YOQXkIdFGxUoJagKR6D
        RQWOgI+0iwMKSflT1XgObk1eRSbTneciVqicQuqE4LOQY4mgYQcHFAMFltR8OKvI
        KMQpQacfF5/WewyFHAn5hgv9xySwocqf3ql9BDpFS6V2fY6uZgU1qxV1SyE3SrTC
        M4szObzHiQ/Wir7BIrtLnCticigtjtXaunl6xcTc6Kqi1lorrBNGkMV1OtdIoVYh
        wm7GZD7PLo8d2Buohz/fpws/ihNL3e0Vh0DH3Fu5rtAizUNZGDnhbTgtBvKMYjdw
        ==
X-ME-Sender: <xms:kY7rXjERWmmHbK3HfvxXxI29op8M96ZqcNsKDzJ2ToWBoX4Z6BhbBQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejgedgleeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:kY7rXgV07WXQiszWS-wKuHPn_gVAaBC_Vqh6TLy8lSnkea-7D_6UkA>
    <xmx:kY7rXlI8U_6fDmEsAznNzo7nuy0qPgMEqR4TMWbciNlwk8_fd6e3sw>
    <xmx:kY7rXhHHHQ6Y1ZeJuihhSTn6zmUS7fAvcBC_SS2BBENbXO2x3mQy-Q>
    <xmx:kY7rXkOfKFs1OG3hwGmGk7dRwl_t2Pl_WL6gt2GL4lfy2yWEbwUTgggIYBg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9D515328005A;
        Thu, 18 Jun 2020 11:56:00 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mm: call cond_resched() from deferred_init_memmap()" failed to apply to 5.4-stable tree
To:     pasha.tatashin@soleen.com, akpm@linux-foundation.org,
        dan.j.williams@intel.com, daniel.m.jordan@oracle.com,
        david@redhat.com, jmorris@namei.org, ktkhai@virtuozzo.com,
        mhocko@suse.com, pankaj.gupta.linux@gmail.com, sashal@kernel.org,
        shile.zhang@linux.alibaba.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz, yiwei@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 18 Jun 2020 17:55:45 +0200
Message-ID: <15924957459342@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From da97f2d56bbd880b4138916a7ef96f9881a551b2 Mon Sep 17 00:00:00 2001
From: Pavel Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 3 Jun 2020 15:59:27 -0700
Subject: [PATCH] mm: call cond_resched() from deferred_init_memmap()

Now that deferred pages are initialized with interrupts enabled we can
replace touch_nmi_watchdog() with cond_resched(), as it was before
3a2d7fa8a3d5.

For now, we cannot do the same in deferred_grow_zone() as it is still
initializes pages with interrupts disabled.

This change fixes RCU problem described in
https://lkml.kernel.org/r/20200401104156.11564-2-david@redhat.com

[   60.474005] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
[   60.475000] rcu:  1-...0: (0 ticks this GP) idle=02a/1/0x4000000000000000 softirq=1/1 fqs=15000
[   60.475000] rcu:  (detected by 0, t=60002 jiffies, g=-1199, q=1)
[   60.475000] Sending NMI from CPU 0 to CPUs 1:
[    1.760091] NMI backtrace for cpu 1
[    1.760091] CPU: 1 PID: 20 Comm: pgdatinit0 Not tainted 4.18.0-147.9.1.el8_1.x86_64 #1
[    1.760091] Hardware name: Red Hat KVM, BIOS 1.13.0-1.module+el8.2.0+5520+4e5817f3 04/01/2014
[    1.760091] RIP: 0010:__init_single_page.isra.65+0x10/0x4f
[    1.760091] Code: 48 83 cf 63 48 89 f8 0f 1f 40 00 48 89 c6 48 89 d7 e8 6b 18 80 ff 66 90 5b c3 31 c0 b9 10 00 00 00 49 89 f8 48 c1 e6 33 f3 ab <b8> 07 00 00 00 48 c1 e2 36 41 c7 40 34 01 00 00 00 48 c1 e0 33 41
[    1.760091] RSP: 0000:ffffba783123be40 EFLAGS: 00000006
[    1.760091] RAX: 0000000000000000 RBX: fffffad34405e300 RCX: 0000000000000000
[    1.760091] RDX: 0000000000000000 RSI: 0010000000000000 RDI: fffffad34405e340
[    1.760091] RBP: 0000000033f3177e R08: fffffad34405e300 R09: 0000000000000002
[    1.760091] R10: 000000000000002b R11: ffff98afb691a500 R12: 0000000000000002
[    1.760091] R13: 0000000000000000 R14: 000000003f03ea00 R15: 000000003e10178c
[    1.760091] FS:  0000000000000000(0000) GS:ffff9c9ebeb00000(0000) knlGS:0000000000000000
[    1.760091] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    1.760091] CR2: 00000000ffffffff CR3: 000000a1cf20a001 CR4: 00000000003606e0
[    1.760091] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    1.760091] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    1.760091] Call Trace:
[    1.760091]  deferred_init_pages+0x8f/0xbf
[    1.760091]  deferred_init_memmap+0x184/0x29d
[    1.760091]  ? deferred_free_pages.isra.97+0xba/0xba
[    1.760091]  kthread+0x112/0x130
[    1.760091]  ? kthread_flush_work_fn+0x10/0x10
[    1.760091]  ret_from_fork+0x35/0x40
[   89.123011] node 0 initialised, 1055935372 pages in 88650ms

Fixes: 3a2d7fa8a3d5 ("mm: disable interrupts while initializing deferred pages")
Reported-by: Yiqian Wei <yiwei@redhat.com>
Signed-off-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: James Morris <jmorris@namei.org>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Shile Zhang <shile.zhang@linux.alibaba.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>	[4.17+]
Link: http://lkml.kernel.org/r/20200403140952.17177-4-pasha.tatashin@soleen.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c75561a3f144..2dbc571f68de 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1870,7 +1870,7 @@ static int __init deferred_init_memmap(void *data)
 	 */
 	while (spfn < epfn) {
 		nr_pages += deferred_init_maxorder(&i, zone, &spfn, &epfn);
-		touch_nmi_watchdog();
+		cond_resched();
 	}
 zone_empty:
 	/* Sanity check that the next zone really is unpopulated */

