Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6765E20D184
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 20:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728087AbgF2SmF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 14:42:05 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:51147 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729057AbgF2SmB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jun 2020 14:42:01 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 873C3601;
        Mon, 29 Jun 2020 07:07:49 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 29 Jun 2020 07:07:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=+AnODi
        qI/+XXwnxF9MrlpJpC7wAwN5p31BuWUT+NMVM=; b=cvtgpLlgNB6elDVKaxxDLK
        6Vn00gUOExMwvsB55pgImGMGN9OcGEy7b77ErI2RmpjC50wRLLlrDSOtnDf+vHko
        gMZoeEeXnvktK0cH94f/s5CYi1D2j+0edt81XW2LzvwBmVIzpubic0zmKkgWY8bw
        NqtqVeYyZdmdE44sDgfPZ9+zOFQ1ufthtKYEu1MevLMQnrqovoLi6AlTBP7p1dVl
        yb7T3iq21oWmPlR8Wysi+Tb09p2VlxxmceqRLLzPvW4L39PkS6WbiTkSvDPQNzD9
        lUg/WLmHcXln2SofjhB4WKI2pn9UO2lBKi1NNlSZhGcRIxtN8Bhcf7G/6qh9IFQQ
        ==
X-ME-Sender: <xms:hMv5XlgZJUADY_YDfwchf7L2ZToE_L3iUOLXznhdU4NWoH4Z4rvHgA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudelkedgfeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:hMv5XqD2pplBvvjPff6wXC6ugQRZCjOY8m2KElzo4cgczC8TWxz_Tg>
    <xmx:hMv5XlEai4BTiYBp35c9QJyiZfStAifAGItf9HvCwm4208Q0oYH0JQ>
    <xmx:hMv5XqRmbnoJzCI2onTZ_Hzwmv02zb-XTwgulKwwH8lay3PGyBy0IA>
    <xmx:hcv5XstIvPEoDF9QV4uhB2Y_u5akxVG8R4-EY1todxl7XSUP_DHwHFxP3h8>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 560B93067C80;
        Mon, 29 Jun 2020 07:07:48 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mm, compaction: make capture control handling safe wrt" failed to apply to 5.4-stable tree
To:     vbabka@suse.cz, akpm@linux-foundation.org,
        alex.shi@linux.alibaba.com, hughd@google.com, liwang@redhat.com,
        mgorman@techsingularity.net, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Jun 2020 13:07:39 +0200
Message-ID: <15934288599599@kroah.com>
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

From b9e20f0da1f5c9c68689450a8cb436c9486434c8 Mon Sep 17 00:00:00 2001
From: Vlastimil Babka <vbabka@suse.cz>
Date: Thu, 25 Jun 2020 20:29:24 -0700
Subject: [PATCH] mm, compaction: make capture control handling safe wrt
 interrupts

Hugh reports:

 "While stressing compaction, one run oopsed on NULL capc->cc in
  __free_one_page()'s task_capc(zone): compact_zone_order() had been
  interrupted, and a page was being freed in the return from interrupt.

  Though you would not expect it from the source, both gccs I was using
  (4.8.1 and 7.5.0) had chosen to compile compact_zone_order() with the
  ".cc = &cc" implemented by mov %rbx,-0xb0(%rbp) immediately before
  callq compact_zone - long after the "current->capture_control =
  &capc". An interrupt in between those finds capc->cc NULL (zeroed by
  an earlier rep stos).

  This could presumably be fixed by a barrier() before setting
  current->capture_control in compact_zone_order(); but would also need
  more care on return from compact_zone(), in order not to risk leaking
  a page captured by interrupt just before capture_control is reset.

  Maybe that is the preferable fix, but I felt safer for task_capc() to
  exclude the rather surprising possibility of capture at interrupt
  time"

I have checked that gcc10 also behaves the same.

The advantage of fix in compact_zone_order() is that we don't add
another test in the page freeing hot path, and that it might prevent
future problems if we stop exposing pointers to uninitialized structures
in current task.

So this patch implements the suggestion for compact_zone_order() with
barrier() (and WRITE_ONCE() to prevent store tearing) for setting
current->capture_control, and prevents page leaking with
WRITE_ONCE/READ_ONCE in the proper order.

Link: http://lkml.kernel.org/r/20200616082649.27173-1-vbabka@suse.cz
Fixes: 5e1f0f098b46 ("mm, compaction: capture a page under direct compaction")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Hugh Dickins <hughd@google.com>
Suggested-by: Hugh Dickins <hughd@google.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Li Wang <liwang@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: <stable@vger.kernel.org>	[5.1+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/compaction.c b/mm/compaction.c
index fd988b7e5f2b..86375605faa9 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -2316,15 +2316,26 @@ static enum compact_result compact_zone_order(struct zone *zone, int order,
 		.page = NULL,
 	};
 
-	current->capture_control = &capc;
+	/*
+	 * Make sure the structs are really initialized before we expose the
+	 * capture control, in case we are interrupted and the interrupt handler
+	 * frees a page.
+	 */
+	barrier();
+	WRITE_ONCE(current->capture_control, &capc);
 
 	ret = compact_zone(&cc, &capc);
 
 	VM_BUG_ON(!list_empty(&cc.freepages));
 	VM_BUG_ON(!list_empty(&cc.migratepages));
 
-	*capture = capc.page;
-	current->capture_control = NULL;
+	/*
+	 * Make sure we hide capture control first before we read the captured
+	 * page pointer, otherwise an interrupt could free and capture a page
+	 * and we would leak it.
+	 */
+	WRITE_ONCE(current->capture_control, NULL);
+	*capture = READ_ONCE(capc.page);
 
 	return ret;
 }

