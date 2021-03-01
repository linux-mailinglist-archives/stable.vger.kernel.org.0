Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECE95327FC6
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 14:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235859AbhCANnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 08:43:52 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:52555 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235719AbhCANnr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 08:43:47 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id CA7CA1941FB2;
        Mon,  1 Mar 2021 08:42:39 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 01 Mar 2021 08:42:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=U6vM1Z
        5cGhafdK+y6zrN8nwNF84KRxf2a+N+rcmWiCU=; b=u9pjCdbDct2qXUuoA5b2Yx
        4GbA4v40+TQvaPR8WF+U9SFgkEF0PiHPjybHdMxYlo5hEeFYjgL2MPQweG8Oah0c
        M/7svNh4ynN0y4LqT7lv33JoSFGJvqNW2iEaIhC8K/r+SoYv33bI4r31l2a3JDUg
        gk+QzJWyn+NGeicja/+Tp/hsOUSla7PGBojv05o1R7NdLKQ/h7ZisId244Z8r/nF
        fJQoQjp3yBXVHNJGfDUa6rRvkpeab7VZwpGpLVwO1sk93EsXRGCWzRfyhMFyZGUb
        HJHsLj0RhPMKTjQB+9/n1Dc5kWixX8YsyrY0FW+wDp6opavGkyuErO40O1KiUONw
        ==
X-ME-Sender: <xms:T-88YC38c_S1GJ_E3QEdl5u_TimnG9p3sv3NaIsQ1Vkq_wJctZRanw>
    <xme:T-88YMUa5pAG1sWXxqCNu8PAJUOvSCccsG7slmjg50LlUFdEG05gcRmQV3aTiVYPt
    AsCu973alrn1w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdehgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:T-88YFyrIiJnC5S3JZywZkhpsSFG46nC6rPZ2PLob8A7OZUpXBWgCA>
    <xmx:T-88YDwm8o6AYA_VL5wf79XJzsBr5nI-7auimF5vF7mYkRa_MSMBjQ>
    <xmx:T-88YK1u4lBr-7w2RXs6f8KLVwULCRukUCy8CqypkyQStfTRFqJFog>
    <xmx:T-88YNVB37BUA73QV7iVXr8tYrwNm5RgH_FdjGwbLTtpOpvBtva0UA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5F8601080054;
        Mon,  1 Mar 2021 08:42:39 -0500 (EST)
Subject: FAILED: patch "[PATCH] gfs2: Recursive gfs2_quota_hold in gfs2_iomap_end" failed to apply to 4.19-stable tree
To:     agruenba@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 14:42:37 +0100
Message-ID: <1614606157144198@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 7009fa9cd9a5262944b30eb7efb1f0561d074b68 Mon Sep 17 00:00:00 2001
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Tue, 9 Feb 2021 18:32:32 +0100
Subject: [PATCH] gfs2: Recursive gfs2_quota_hold in gfs2_iomap_end

When starting an iomap write, gfs2_quota_lock_check -> gfs2_quota_lock
-> gfs2_quota_hold is called from gfs2_iomap_begin.  At the end of the
write, before unlocking the quotas, punch_hole -> gfs2_quota_hold can be
called again in gfs2_iomap_end, which is incorrect and leads to a failed
assertion.  Instead, move the call to gfs2_quota_unlock before the call
to punch_hole to fix that.

Fixes: 64bc06bb32ee ("gfs2: iomap buffered write support")
Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 62d9081d1e26..a1f9dde33058 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1230,6 +1230,9 @@ static int gfs2_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 
 	gfs2_inplace_release(ip);
 
+	if (ip->i_qadata && ip->i_qadata->qa_qd_num)
+		gfs2_quota_unlock(ip);
+
 	if (length != written && (iomap->flags & IOMAP_F_NEW)) {
 		/* Deallocate blocks that were just allocated. */
 		loff_t blockmask = i_blocksize(inode) - 1;
@@ -1242,9 +1245,6 @@ static int gfs2_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 		}
 	}
 
-	if (ip->i_qadata && ip->i_qadata->qa_qd_num)
-		gfs2_quota_unlock(ip);
-
 	if (unlikely(!written))
 		goto out_unlock;
 

