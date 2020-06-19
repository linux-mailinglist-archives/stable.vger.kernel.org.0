Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6486C200A4E
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 15:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbgFSNh7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 09:37:59 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:40425 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729509AbgFSNhz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 09:37:55 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 8B59119436A0;
        Fri, 19 Jun 2020 09:37:54 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 19 Jun 2020 09:37:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=6OgJnw
        6tHGYpgTLWjjIoDDoK2NfKDH2wDoVDn1a1vHY=; b=bVLGyp5MJyAbnkIcvHCewf
        9vdXkmbxJ5HNbE8JCjL2X+K08mht73qRQvzrL3wezlclmf1kpt1c1LjLJ3ztfPrw
        YuyeCKRjEvHptfijU1LUF3OF+XGrPlpSw1q2hAV/dNgxocU1CQ0gqU1IE0EcUmso
        svztbj3zulm2SDz6Gjr1JVYZR5ScCeZG9K3uRh7vMUNPHDhxlBX9w3awCmCU/5LY
        cS8oqunpjWU4D4gcj+vehQXfIPSccKwU3yOAclpKDKBl9pOOVO/4H5FO/KzxtLx7
        BkELSC6DxGUpK8tSrNzwW0n6gq4j+CGhhc3y90kGSsj6M4QO3bnF9y+QcnTjekRQ
        ==
X-ME-Sender: <xms:sr_sXvg3ZmdJOLTz6wTRRRwvWDlzR5rSi2JDlrQDhKmTCRiRLVrBNw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejiedgieekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:sr_sXsDAZM0dYA9QBgcWvn5dJZu9hCnKK6X4rYbUK6IZLi7O06hNjg>
    <xmx:sr_sXvHpciEFXEoZeTkpZMx2B0f48beo1GzWIzAlJ1oYLHxrr-YooA>
    <xmx:sr_sXsSNK2lUUmwOhV-xlrU__Qwi8erSQsERI89MguRXZjwbQwMOCw>
    <xmx:sr_sXib0PlYyxy6o2QAOPiSIepDa6GpgGcKQVx0dLL5nFqDzSrSTdQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id DA254328005A;
        Fri, 19 Jun 2020 09:37:53 -0400 (EDT)
Subject: FAILED: patch "[PATCH] jbd2: avoid leaking transaction credits when unreserving" failed to apply to 5.4-stable tree
To:     jack@suse.cz, adilger@dilger.ca, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 19 Jun 2020 15:37:52 +0200
Message-ID: <15925738721463@kroah.com>
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
 

