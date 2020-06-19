Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17717200A52
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 15:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732035AbgFSNiJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 09:38:09 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:51261 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732195AbgFSNiG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 09:38:06 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id B3B5C19432A8;
        Fri, 19 Jun 2020 09:38:04 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 19 Jun 2020 09:38:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Tk2PBY
        tASZhi5hPK1yVhFtjrgAMeD5Go5vYEmmW2Pr8=; b=HpB0LoksUzOOqAgby09eGI
        ZdERh5dsavqN7e8x+8djKgJdUsfJ3B3SASloGL+xaEFAJY9CTh5IwmjhUwlmAfIb
        SbKp/Mi2tOD7JF1C4qUBn2o2Z5UG2RvFeQt236oshO1BvL/ybAZwdrkU6S8gGnvH
        PKPEWvzCOqQvc9jgjpGTwuhB/UhLEK6k3Z+17yqhsrNXalzk6ZNqxVmhR7TDJ4Ln
        h3sZzV8aWqGDopGds/+367i+/2k0F7PWlDzHqi4F17Jeaev1C/s8LB6K/1tbZykm
        +Oe8SfQFJvbLzi3KmKdJAJ7LrbPRC2fQHsqANvaFwQ2cT5c56TblkRiy0FnwECxA
        ==
X-ME-Sender: <xms:vL_sXhs9lS3HCqsJW7B6z60pUIuLOb8mKBfQPo7ykUTye4srQtJNiw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejiedgieekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:vL_sXqdiS4TQ5RD-T8syB2vpy3kn-Uh9AkQamPj2rYNK5wPD_WAAag>
    <xmx:vL_sXkxjD8o0am-PsUbxVbifsPWXSi1qo2JTlyvx93HkCdrx097n7A>
    <xmx:vL_sXoP7tpKBY6mMDvCqc8PgM2VHVwxnYOw0kPalJx1BmctTC5dnPA>
    <xmx:vL_sXuEd8VCLTy6z0199fmk5vWY0vKNbzi_OIxAKwkfjpjvxKNxVEw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 396B6328005A;
        Fri, 19 Jun 2020 09:38:04 -0400 (EDT)
Subject: FAILED: patch "[PATCH] jbd2: avoid leaking transaction credits when unreserving" failed to apply to 4.4-stable tree
To:     jack@suse.cz, adilger@dilger.ca, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 19 Jun 2020 15:37:55 +0200
Message-ID: <159257387522194@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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
 

