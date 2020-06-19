Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6C1200A51
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 15:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730512AbgFSNiJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 09:38:09 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:35955 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732349AbgFSNiF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 09:38:05 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id F18CF1945626;
        Fri, 19 Jun 2020 09:38:02 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 19 Jun 2020 09:38:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=cbi5dW
        r8tjjKHcQwWzLRdA+OQu8Zv/ErOMhSGgZlFaE=; b=j/TpX0hxYaoLXn6IyphNcj
        SKt6vCBGwlYaYoiSKmi/sEmU4bE4HPXmTmkHpfZvzHb9lRH/ifTcNv0yrOzhLzid
        3aFPqpOd7l2vRwr9GkU+YWck6c+69nm7sVX88nQr6H35Gh4htP/XLVpxBMEIfELa
        /DXw7pCXAbvWljAKkqvRfepfaU44ED5eaUke0YIta0ZuD4naJRjxb8zXEd/VvDs4
        b/KqlglOkQdUX5EuhBRiDI8VxFCP49SjMj6hVBvUSAlsGLXu1cvMlln7UO+La7V4
        RFmNJX7PnZ0uFSHG+0DvTrcPHUU250ELTRkcjom+SIUqzKHY6PSoqxZ2ENrMpcPQ
        ==
X-ME-Sender: <xms:ur_sXhHiVMkvADehcxKqk_z97wJ1PVlKnjdoxtwN40aEadAjm483HA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejiedgieekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:ur_sXmWj4Wmw2-dUIWHOfNRTZU-9-Nfn6g1S6FdkriHtjpnYjq6ERw>
    <xmx:ur_sXjKoW_x9K3s97114M7SBFoCiiUIF9SHErh9ZCQ0HWeSc-Reysw>
    <xmx:ur_sXnH1HnutHlG6Z4b2h7JxMIfNoDrjaMoxmS67-O7b-QgawsyJXg>
    <xmx:ur_sXofZzvoX1dHykUeTFwkXgLALCNXTBJVhXUtP7f8jpLtdIX91yQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8C6D93061856;
        Fri, 19 Jun 2020 09:38:02 -0400 (EDT)
Subject: FAILED: patch "[PATCH] jbd2: avoid leaking transaction credits when unreserving" failed to apply to 4.9-stable tree
To:     jack@suse.cz, adilger@dilger.ca, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 19 Jun 2020 15:37:54 +0200
Message-ID: <15925738747536@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 14ff6286309e2853aed50083c9a83328423fdd8c Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 20 May 2020 15:31:19 +0200
Subject: [PATCH] jbd2: avoid leaking transaction credits when unreserving
 handle

When reserved transaction handle is unused, we subtract its reserved
credits in __jbd2_journal_unreserve_handle() called from
jbd2_journal_stop(). However this function forgets to remove reserved
credits from transaction->t_outstanding_credits and thus the transaction
space that was reserved remains effectively leaked. The leaked
transaction space can be quite significant in some cases and leads to
unnecessarily small transactions and thus reducing throughput of the
journalling machinery. E.g. fsmark workload creating lots of 4k files
was observed to have about 20% lower throughput due to this when ext4 is
mounted with dioread_nolock mount option.

Subtract reserved credits from t_outstanding_credits as well.

CC: stable@vger.kernel.org
Fixes: 8f7d89f36829 ("jbd2: transaction reservation support")
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20200520133119.1383-3-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 3dccc23cf010..e91aad3637a2 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -541,17 +541,24 @@ handle_t *jbd2_journal_start(journal_t *journal, int nblocks)
 }
 EXPORT_SYMBOL(jbd2_journal_start);
 
-static void __jbd2_journal_unreserve_handle(handle_t *handle)
+static void __jbd2_journal_unreserve_handle(handle_t *handle, transaction_t *t)
 {
 	journal_t *journal = handle->h_journal;
 
 	WARN_ON(!handle->h_reserved);
 	sub_reserved_credits(journal, handle->h_total_credits);
+	if (t)
+		atomic_sub(handle->h_total_credits, &t->t_outstanding_credits);
 }
 
 void jbd2_journal_free_reserved(handle_t *handle)
 {
-	__jbd2_journal_unreserve_handle(handle);
+	journal_t *journal = handle->h_journal;
+
+	/* Get j_state_lock to pin running transaction if it exists */
+	read_lock(&journal->j_state_lock);
+	__jbd2_journal_unreserve_handle(handle, journal->j_running_transaction);
+	read_unlock(&journal->j_state_lock);
 	jbd2_free_handle(handle);
 }
 EXPORT_SYMBOL(jbd2_journal_free_reserved);
@@ -722,7 +729,8 @@ static void stop_this_handle(handle_t *handle)
 	atomic_sub(handle->h_total_credits,
 		   &transaction->t_outstanding_credits);
 	if (handle->h_rsv_handle)
-		__jbd2_journal_unreserve_handle(handle->h_rsv_handle);
+		__jbd2_journal_unreserve_handle(handle->h_rsv_handle,
+						transaction);
 	if (atomic_dec_and_test(&transaction->t_updates))
 		wake_up(&journal->j_wait_updates);
 

