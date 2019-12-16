Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 017D311F25A
	for <lists+stable@lfdr.de>; Sat, 14 Dec 2019 16:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbfLNPCt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Dec 2019 10:02:49 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:33639 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726333AbfLNPCs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Dec 2019 10:02:48 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 8D35C84C;
        Sat, 14 Dec 2019 10:02:47 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sat, 14 Dec 2019 10:02:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=FepVRZ
        jWSbn0CRGDaBXyEg8KkuZ3FKkY1qTHVaRq6xU=; b=E5V5wygtixznY9KLmHIQGu
        LLwhfD0ZOFhq4KbcPcR9AAssgBdMcgXEeLVKnvR+nwOwE8UQTiJMQ+WvjX88SZZH
        lfQC+FyEZSJWX0QxLT1xRTBFcoKQ0TKJr1WhsI5PDUU/OECmaZ9IEYPwq86MSzWO
        llfCakGFbjxPuQoYRAAJQh0TaaKOypRY3BOSC11n1QA2xXXcI78ezLyVwXZ4nrwg
        SMszhCBoGRvZcpvsThb0BCb6poo+efBku/v3nGAjD0k+FAww8dN8WZIYXXJL3ZK8
        3sbLSAbDcWQu1ZjlVoKaPVyLlengB24q1VRcUfKg+NSTr71bC3mK3vsb1f1c+0fw
        ==
X-ME-Sender: <xms:lvn0XU_rYxowr-I4c5oQbaNWXoq0IS5Tgp8UYa5o_yACf4bYGdNfJg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtuddgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:lvn0XR80x3-zbkUkXRdxjZa-nYiBkhA421OKgP9QCDgDZuHClvCVCQ>
    <xmx:lvn0XbuqzCdHfvOAkB-AkOzPJ4Z2TohCJlo96OpVf2JqtjSbdFXGHw>
    <xmx:lvn0XcqpNZbmLdz6xbJELBYE1QUpoo9vAUF2Wl-CC-XQJfVL9x1C9g>
    <xmx:l_n0XcotXoisZ6Jq9bDxa8kMnU3hPB_5pHcSHcYlMIkzVa0Sk-V3Gw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 44DBE306012F;
        Sat, 14 Dec 2019 10:02:46 -0500 (EST)
Subject: FAILED: patch "[PATCH] scsi: lpfc: Fix bad ndlp ptr in xri aborted handling" failed to apply to 5.3-stable tree
To:     jsmart2021@gmail.com, dick.kennedy@broadcom.com,
        martin.petersen@oracle.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 14 Dec 2019 16:02:44 +0100
Message-ID: <157633576465127@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.3-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 324e1c402069e8d277d2a2b18ce40bde1265b96a Mon Sep 17 00:00:00 2001
From: James Smart <jsmart2021@gmail.com>
Date: Fri, 18 Oct 2019 14:18:21 -0700
Subject: [PATCH] scsi: lpfc: Fix bad ndlp ptr in xri aborted handling

In cases where I/O may be aborted, such as driver unload or link bounces,
the system will crash based on a bad ndlp pointer.

Example:
  RIP: 0010:lpfc_sli4_abts_err_handler+0x15/0x140 [lpfc]
  ...
  lpfc_sli4_io_xri_aborted+0x20d/0x270 [lpfc]
  lpfc_sli4_sp_handle_abort_xri_wcqe.isra.54+0x84/0x170 [lpfc]
  lpfc_sli4_fp_handle_cqe+0xc2/0x480 [lpfc]
  __lpfc_sli4_process_cq+0xc6/0x230 [lpfc]
  __lpfc_sli4_hba_process_cq+0x29/0xc0 [lpfc]
  process_one_work+0x14c/0x390

Crash was caused by a bad ndlp address passed to I/O indicated by the XRI
aborted CQE.  The address was not NULL so the routine deferenced the ndlp
ptr. The bad ndlp also caused the lpfc_sli4_io_xri_aborted to call an
erroneous io handler.  Root cause for the bad ndlp was an lpfc_ncmd that
was aborted, put on the abort_io list, completed, taken off the abort_io
list, sent to lpfc_release_nvme_buf where it was put back on the abort_io
list because the lpfc_ncmd->flags setting LPFC_SBUF_XBUSY was not cleared
on the final completion.

Rework the exchange busy handling to ensure the flags are properly set for
both scsi and nvme.

Fixes: c490850a0947 ("scsi: lpfc: Adapt partitioned XRI lists to efficient sharing")
Cc: <stable@vger.kernel.org> # v5.1+
Link: https://lore.kernel.org/r/20191018211832.7917-6-jsmart2021@gmail.com
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index f06f63e58596..13e3e14b43f9 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -526,7 +526,7 @@ lpfc_sli4_io_xri_aborted(struct lpfc_hba *phba,
 		&qp->lpfc_abts_io_buf_list, list) {
 		if (psb->cur_iocbq.sli4_xritag == xri) {
 			list_del_init(&psb->list);
-			psb->exch_busy = 0;
+			psb->flags &= ~LPFC_SBUF_XBUSY;
 			psb->status = IOSTAT_SUCCESS;
 #ifdef BUILD_NVME
 			if (psb->cur_iocbq.iocb_flag == LPFC_IO_NVME) {
@@ -568,7 +568,7 @@ lpfc_sli4_io_xri_aborted(struct lpfc_hba *phba,
 		if (iocbq->sli4_xritag != xri)
 			continue;
 		psb = container_of(iocbq, struct lpfc_io_buf, cur_iocbq);
-		psb->exch_busy = 0;
+		psb->flags &= ~LPFC_SBUF_XBUSY;
 		spin_unlock_irqrestore(&phba->hbalock, iflag);
 		if (!list_empty(&pring->txq))
 			lpfc_worker_wake_up(phba);
@@ -788,7 +788,7 @@ lpfc_release_scsi_buf_s4(struct lpfc_hba *phba, struct lpfc_io_buf *psb)
 	psb->prot_seg_cnt = 0;
 
 	qp = psb->hdwq;
-	if (psb->exch_busy) {
+	if (psb->flags & LPFC_SBUF_XBUSY) {
 		spin_lock_irqsave(&qp->abts_io_buf_list_lock, iflag);
 		psb->pCmd = NULL;
 		list_add_tail(&psb->list, &qp->lpfc_abts_io_buf_list);
@@ -3837,7 +3837,10 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 	lpfc_cmd->result = (pIocbOut->iocb.un.ulpWord[4] & IOERR_PARAM_MASK);
 	lpfc_cmd->status = pIocbOut->iocb.ulpStatus;
 	/* pick up SLI4 exhange busy status from HBA */
-	lpfc_cmd->exch_busy = pIocbOut->iocb_flag & LPFC_EXCHANGE_BUSY;
+	if (pIocbOut->iocb_flag & LPFC_EXCHANGE_BUSY)
+		lpfc_cmd->flags |= LPFC_SBUF_XBUSY;
+	else
+		lpfc_cmd->flags &= ~LPFC_SBUF_XBUSY;
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	if (lpfc_cmd->prot_data_type) {
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 3a6520187ee5..bb0e155eb32c 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -11777,7 +11777,10 @@ lpfc_sli_wake_iocb_wait(struct lpfc_hba *phba,
 		!(cmdiocbq->iocb_flag & LPFC_IO_LIBDFC)) {
 		lpfc_cmd = container_of(cmdiocbq, struct lpfc_io_buf,
 			cur_iocbq);
-		lpfc_cmd->exch_busy = rspiocbq->iocb_flag & LPFC_EXCHANGE_BUSY;
+		if (rspiocbq && (rspiocbq->iocb_flag & LPFC_EXCHANGE_BUSY))
+			lpfc_cmd->flags |= LPFC_SBUF_XBUSY;
+		else
+			lpfc_cmd->flags &= ~LPFC_SBUF_XBUSY;
 	}
 
 	pdone_q = cmdiocbq->context_un.wait_queue;
diff --git a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
index 37fbcb46387e..7bcf922a8be2 100644
--- a/drivers/scsi/lpfc/lpfc_sli.h
+++ b/drivers/scsi/lpfc/lpfc_sli.h
@@ -384,14 +384,13 @@ struct lpfc_io_buf {
 
 	struct lpfc_nodelist *ndlp;
 	uint32_t timeout;
-	uint16_t flags;  /* TBD convert exch_busy to flags */
+	uint16_t flags;
 #define LPFC_SBUF_XBUSY		0x1	/* SLI4 hba reported XB on WCQE cmpl */
 #define LPFC_SBUF_BUMP_QDEPTH	0x2	/* bumped queue depth counter */
 					/* External DIF device IO conversions */
 #define LPFC_SBUF_NORMAL_DIF	0x4	/* normal mode to insert/strip */
 #define LPFC_SBUF_PASS_DIF	0x8	/* insert/strip mode to passthru */
 #define LPFC_SBUF_NOT_POSTED    0x10    /* SGL failed post to FW. */
-	uint16_t exch_busy;     /* SLI4 hba reported XB on complete WCQE */
 	uint16_t status;	/* From IOCB Word 7- ulpStatus */
 	uint32_t result;	/* From IOCB Word 4. */
 

