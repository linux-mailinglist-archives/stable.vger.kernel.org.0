Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12F4011F25E
	for <lists+stable@lfdr.de>; Sat, 14 Dec 2019 16:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbfLNPDg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Dec 2019 10:03:36 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:57683 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725975AbfLNPDg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Dec 2019 10:03:36 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 7B13B850;
        Sat, 14 Dec 2019 10:03:35 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sat, 14 Dec 2019 10:03:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=f2dZhC
        siSbCyL+NBYNy7M7zuSRs79yVodFyULJZL8LQ=; b=Wd/Ql4bS7nxru4vTbG+iuU
        jkkDyVR+4EBicKDFWTSS7Ev14Cg+PJjp9ma2afO1FdjoT8rQH76EeatBC+f+y2t4
        eYxK134fMDd6FDkI7GIUXRp7VwMKaCRKwiNtdOsLzI7XLcAV5tdISDTa5KLZqt2Q
        jnJq3KHDcDcu4COBb3cJ97bcW3gO71xtOP2Ej6m8JoLKdK3bkqLhPEFrIWCiivX5
        x6FQ63AD7YZb3w2RXkr8cHFvITkqT+eY7KLMI+uNjXnkwjutTjXZW5V7k360qBvA
        owDN4veVNzM6zYr1hPfexBSrfAEASsBEr1s6RdiqENhqz7iKFPFJzFxvk69Kj18g
        ==
X-ME-Sender: <xms:x_n0XahOQyd71-45bVxP6x8U6ueQLLfy2nes9lWsj09q6DYeohWdGw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtuddgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpeef
X-ME-Proxy: <xmx:x_n0XfJA9_IVNAaVwhqMepR8xqIpYVRBVYr9wAYFu2O1-dLUYYjLdw>
    <xmx:x_n0XdrS6JVxm_9GL4d4OiX9E3ex-Fhgx349BwtA9dAumnsgbAOrSA>
    <xmx:x_n0XVgmkPCUXocRK4fZdYY31yOvVAEIL5EPTePhOc-fGZvs9k7XCg>
    <xmx:x_n0Xf5peMfEnTeBASnDpKn6RtA3UrflGLpbVSpyGJhghcVmUjcOzQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9B9BE8005A;
        Sat, 14 Dec 2019 10:03:34 -0500 (EST)
Subject: FAILED: patch "[PATCH] scsi: zfcp: trace channel log even for FCP command responses" failed to apply to 4.4-stable tree
To:     maier@linux.ibm.com, bblock@linux.ibm.com,
        martin.petersen@oracle.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 14 Dec 2019 16:03:23 +0100
Message-ID: <157633580318913@kroah.com>
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

From 100843f176109af94600e500da0428e21030ca7f Mon Sep 17 00:00:00 2001
From: Steffen Maier <maier@linux.ibm.com>
Date: Fri, 25 Oct 2019 18:12:53 +0200
Subject: [PATCH] scsi: zfcp: trace channel log even for FCP command responses

While v2.6.26 commit b75db73159cc ("[SCSI] zfcp: Add qtcb dump to hba debug
trace") is right that we don't want to flood the (payload) trace ring
buffer, we don't trace successful FCP command responses by default.  So we
can include the channel log for problem determination with failed responses
of any FSF request type.

Fixes: b75db73159cc ("[SCSI] zfcp: Add qtcb dump to hba debug trace")
Fixes: a54ca0f62f95 ("[SCSI] zfcp: Redesign of the debug tracing for HBA records.")
Cc: <stable@vger.kernel.org> #2.6.38+
Link: https://lore.kernel.org/r/e37597b5c4ae123aaa85fd86c23a9f71e994e4a9.1572018132.git.bblock@linux.ibm.com
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Steffen Maier <maier@linux.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/s390/scsi/zfcp_dbf.c b/drivers/s390/scsi/zfcp_dbf.c
index dccdb41bed8c..1234294700c4 100644
--- a/drivers/s390/scsi/zfcp_dbf.c
+++ b/drivers/s390/scsi/zfcp_dbf.c
@@ -95,11 +95,9 @@ void zfcp_dbf_hba_fsf_res(char *tag, int level, struct zfcp_fsf_req *req)
 	memcpy(rec->u.res.fsf_status_qual, &q_head->fsf_status_qual,
 	       FSF_STATUS_QUALIFIER_SIZE);
 
-	if (q_head->fsf_command != FSF_QTCB_FCP_CMND) {
-		rec->pl_len = q_head->log_length;
-		zfcp_dbf_pl_write(dbf, (char *)q_pref + q_head->log_start,
-				  rec->pl_len, "fsf_res", req->req_id);
-	}
+	rec->pl_len = q_head->log_length;
+	zfcp_dbf_pl_write(dbf, (char *)q_pref + q_head->log_start,
+			  rec->pl_len, "fsf_res", req->req_id);
 
 	debug_event(dbf->hba, level, rec, sizeof(*rec));
 	spin_unlock_irqrestore(&dbf->hba_lock, flags);

