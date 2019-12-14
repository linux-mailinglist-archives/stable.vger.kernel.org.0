Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF5FC11F25C
	for <lists+stable@lfdr.de>; Sat, 14 Dec 2019 16:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbfLNPDd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Dec 2019 10:03:33 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:48861 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725975AbfLNPDd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Dec 2019 10:03:33 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 6485F82E;
        Sat, 14 Dec 2019 10:03:32 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sat, 14 Dec 2019 10:03:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=X40XLz
        HBNE1KHKoTdL5VOsX98+akeg3xydfYuU4YOus=; b=UuVAmYVTW/kayLbqqo9ExA
        wR8Ou7NyntCcQKc1bR5A3q9ZD8iwzjIglQKzvcTToxcrja/VLo0AqxPv9drZWiDY
        rFp28vAQCdWZXhPOzTITYXUXu8IZxn5YGLx6AUy76IZ1F/XB7I1fmmzrkrgP8ORY
        TECcTXVXXOTEwAEi48PqrOEfB8wmVoeBUrAcTYK2/IMk3kmtNewPv0uM4beReE1o
        xI+8ha+rW/XQl6ctjObqFjSAYIf9H7ZjoXXIbAP0SVCWGLVbvd5hKPeOCFOQLEw/
        KwmGaoFWgE8xVzaeumKkVFpZ+bw/aCggB3qcoVbs+CJcf6kK28KBrGUe3c3w5oZg
        ==
X-ME-Sender: <xms:w_n0XWJS4a50kipqWsrtOf4MmMYFLs-qkHxpKkZ43F0r_2r3nXn-RA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtuddgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedv
X-ME-Proxy: <xmx:w_n0XTVnzAS4NN4yaFhIV8WGRQ45DvHixnfzs6ImcMfPymDZ_qJwOg>
    <xmx:w_n0XaEXCOpO9z8uOfrH7PFbeHn1FlnCowmJ95MTUC7v_GPlN6Mnlg>
    <xmx:w_n0Xa70Nu_fIPEHq46X4f_e76XDtMR_0r5D9wNznsgE2NG5DbSb0Q>
    <xmx:xPn0XaxrfM0NvOQDFakLhjmiWXxHqn_DAhCX-r0B-rL6WRE-bdDSAw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6FCF68005B;
        Sat, 14 Dec 2019 10:03:31 -0500 (EST)
Subject: FAILED: patch "[PATCH] scsi: zfcp: trace channel log even for FCP command responses" failed to apply to 4.9-stable tree
To:     maier@linux.ibm.com, bblock@linux.ibm.com,
        martin.petersen@oracle.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 14 Dec 2019 16:03:22 +0100
Message-ID: <15763358022360@kroah.com>
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

