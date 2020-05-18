Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0D101D7ACF
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 16:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbgEROOJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 10:14:09 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:41643 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726997AbgEROOJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 10:14:09 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 930D91940F13;
        Mon, 18 May 2020 10:14:08 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 18 May 2020 10:14:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=KBC5Ma
        qnGhILThCWqbWS7em45AH/qOFC4gyOKGpGgvw=; b=bkMUJrIR0Bhxu7imUt2bAw
        oLRAlZP1ZFx52H3wKYVzzqw0YkxkEtU3QrIXLj8w7g5ACMQSHl7Oz62S4ugdCGp9
        Jf5+MBS4dFV2kICYsFoh6/NWKynNI2UUoMhH2oqm3XNrriGs+8aHDBM2ZkQbIs6u
        m04gKyNa5E/DJIsLvTFYez5fMX05TBJk7dMXKAN2iLuHoFm2XwCJy2aK3jgvGx+f
        0CUpDS3TS/LqwesOfnReuQ9H+JuodpDl158ynTnzz3yVg+oyLOrpcIe4xGVbfsxr
        VFGWsVu/GcLdB0kgXYunPsG5wNq45dLTidjFzhsscdzIJbqeqdcWzgqPpflQf9yA
        ==
X-ME-Sender: <xms:MJjCXkF2--oRpN4h27jHQwCEdYqZG9jHuR02u9_5tmkPbThrAR15Lw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddthedgjeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:MJjCXtXbMaNyCaIlU97W66mW0NuTL17jKbZ14nF_E6ktTki6Y1LPFw>
    <xmx:MJjCXuJPeJ0aeKJDRryDb5duUSZGtZdhST7KjwFzFv-GKsj3BeUO-w>
    <xmx:MJjCXmF7OglhHQ9dXpa0d4CrM3XGF_vJnoeBxkgfqoEdBtvC6BlA2w>
    <xmx:MJjCXlDUg4Ha1HSvS-DDBRtKn9mLgwwdViA0BFhczR4JjL8j00V7qA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C7CF630663F8;
        Mon, 18 May 2020 10:14:07 -0400 (EDT)
Subject: FAILED: patch "[PATCH] fanotify: fix merging marks masks with FAN_ONDIR" failed to apply to 4.19-stable tree
To:     amir73il@gmail.com, jack@suse.cz
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 May 2020 16:14:06 +0200
Message-ID: <1589811246113140@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 55bf882c7f13dda8bbe624040c6d5b4fbb812d16 Mon Sep 17 00:00:00 2001
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 19 Mar 2020 17:10:17 +0200
Subject: [PATCH] fanotify: fix merging marks masks with FAN_ONDIR

Change the logic of FAN_ONDIR in two ways that are similar to the logic
of FAN_EVENT_ON_CHILD, that was fixed in commit 54a307ba8d3c ("fanotify:
fix logic of events on child"):

1. The flag is meaningless in ignore mask
2. The flag refers only to events in the mask of the mark where it is set

This is what the fanotify_mark.2 man page says about FAN_ONDIR:
"Without this flag, only events for files are created."  It doesn't
say anything about setting this flag in ignore mask to stop getting
events on directories nor can I think of any setup where this capability
would be useful.

Currently, when marks masks are merged, the FAN_ONDIR flag set in one
mark affects the events that are set in another mark's mask and this
behavior causes unexpected results.  For example, a user adds a mark on a
directory with mask FAN_ATTRIB | FAN_ONDIR and a mount mark with mask
FAN_OPEN (without FAN_ONDIR).  An opendir() of that directory (which is
inside that mount) generates a FAN_OPEN event even though neither of the
marks requested to get open events on directories.

Link: https://lore.kernel.org/r/20200319151022.31456-10-amir73il@gmail.com
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index 97d34b958761..960f4f4d9e8f 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -171,6 +171,13 @@ static u32 fanotify_group_event_mask(struct fsnotify_group *group,
 		if (!fsnotify_iter_should_report_type(iter_info, type))
 			continue;
 		mark = iter_info->marks[type];
+		/*
+		 * If the event is on dir and this mark doesn't care about
+		 * events on dir, don't send it!
+		 */
+		if (event_mask & FS_ISDIR && !(mark->mask & FS_ISDIR))
+			continue;
+
 		/*
 		 * If the event is for a child and this mark doesn't care about
 		 * events on a child, don't send it!
@@ -203,10 +210,6 @@ static u32 fanotify_group_event_mask(struct fsnotify_group *group,
 		user_mask &= ~FAN_ONDIR;
 	}
 
-	if (event_mask & FS_ISDIR &&
-	    !(marks_mask & FS_ISDIR & ~marks_ignored_mask))
-		return 0;
-
 	return test_mask & user_mask;
 }
 

