Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4448011F260
	for <lists+stable@lfdr.de>; Sat, 14 Dec 2019 16:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbfLNPES (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Dec 2019 10:04:18 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:54983 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725975AbfLNPES (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Dec 2019 10:04:18 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 1A8C084E;
        Sat, 14 Dec 2019 10:04:17 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sat, 14 Dec 2019 10:04:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=kNKFRW
        bLAbEJpB/pwEYrHGE5NRSW/gnfrfkRoR20rcQ=; b=bw3OOQ/LIzFcRsv+JeyQhF
        NRQS9GIWi2yzgGsYjGL9WBgrmObTXKJJ/vC2+RXk2u5yP7vhMtfLZac7KhmeRa6a
        TrVP6I+K0npr0/b5guYC5oQvAm/9HzRkV71LJg0iJOlkQA8OXEgHTwMGxszdaX5u
        eIq1zDY5w2Hpdv7OrWMrdkNvb/zwfFUG8eaO7SV0xig+YbfK2JFWhMuxDIJuTrgE
        U0vae6tIgWCDRgdhDk5/sWGbs3sCIVIIoeDQMEFHwwaohXqOq8YZotjp6C8xiHlJ
        a6h5Cg+tVMc2odeACRqkbcwU3q7LhC/gw3BQkzDQLsFVRQhDQk5ldgR4CrclNKOg
        ==
X-ME-Sender: <xms:8Pn0XaJp7kcc5NbXUqiH3xu8EOimzBMy8Mh2n7AwEo5d-rW_smCTfA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtuddgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpeei
X-ME-Proxy: <xmx:8Pn0XbSz-hKC0QNeE8T3ATOMBHvzJflaYcphw7GG-B-mZWEmzzfpEA>
    <xmx:8Pn0XTmuRqi-NwkIbWa9XXppO4qML7icyRj2Tt75-Tb5Ou0BNAii-w>
    <xmx:8Pn0XSBYRsEjERbai5W2V95xkintvEAe9gRGMkYc0GZaBBGOCzh6BQ>
    <xmx:8Pn0XXtwD3TsllEdCAa3W3M2sIhDTc6ln__u0lmqg_NefnQ3x8JsNg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3CFC38005A;
        Sat, 14 Dec 2019 10:04:16 -0500 (EST)
Subject: FAILED: patch "[PATCH] scsi: qla2xxx: Do command completion on abort timeout" failed to apply to 5.3-stable tree
To:     qutran@marvell.com, emilne@redhat.com, hmadhani@marvell.com,
        martin.petersen@oracle.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 14 Dec 2019 16:04:15 +0100
Message-ID: <1576335855212105@kroah.com>
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

From 71c80b75ce8f08c0978ce9a9816b81b5c3ce5e12 Mon Sep 17 00:00:00 2001
From: Quinn Tran <qutran@marvell.com>
Date: Tue, 5 Nov 2019 07:06:51 -0800
Subject: [PATCH] scsi: qla2xxx: Do command completion on abort timeout

On switch, fabric and mgt command timeout, driver send Abort to tell FW to
return the original command.  If abort is timeout, then return both Abort
and original command for cleanup.

Fixes: 219d27d7147e0 ("scsi: qla2xxx: Fix race conditions in the code for aborting SCSI commands")
Cc: stable@vger.kernel.org # 5.2
Link: https://lore.kernel.org/r/20191105150657.8092-3-hmadhani@marvell.com
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 721ee7f09b39..ef9bb3c7ad6f 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -604,6 +604,7 @@ typedef struct srb {
 	const char *name;
 	int iocbs;
 	struct qla_qpair *qpair;
+	struct srb *cmd_sp;
 	struct list_head elem;
 	u32 gen1;	/* scratch */
 	u32 gen2;	/* scratch */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 5db8ad832893..7fdbe041cc19 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -101,8 +101,22 @@ static void qla24xx_abort_iocb_timeout(void *data)
 	u32 handle;
 	unsigned long flags;
 
+	if (sp->cmd_sp)
+		ql_dbg(ql_dbg_async, sp->vha, 0x507c,
+		    "Abort timeout - cmd hdl=%x, cmd type=%x hdl=%x, type=%x\n",
+		    sp->cmd_sp->handle, sp->cmd_sp->type,
+		    sp->handle, sp->type);
+	else
+		ql_dbg(ql_dbg_async, sp->vha, 0x507c,
+		    "Abort timeout 2 - hdl=%x, type=%x\n",
+		    sp->handle, sp->type);
+
 	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
 	for (handle = 1; handle < qpair->req->num_outstanding_cmds; handle++) {
+		if (sp->cmd_sp && (qpair->req->outstanding_cmds[handle] ==
+		    sp->cmd_sp))
+			qpair->req->outstanding_cmds[handle] = NULL;
+
 		/* removing the abort */
 		if (qpair->req->outstanding_cmds[handle] == sp) {
 			qpair->req->outstanding_cmds[handle] = NULL;
@@ -111,6 +125,9 @@ static void qla24xx_abort_iocb_timeout(void *data)
 	}
 	spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
 
+	if (sp->cmd_sp)
+		sp->cmd_sp->done(sp->cmd_sp, QLA_OS_TIMER_EXPIRED);
+
 	abt->u.abt.comp_status = CS_TIMEOUT;
 	sp->done(sp, QLA_OS_TIMER_EXPIRED);
 }
@@ -142,6 +159,7 @@ static int qla24xx_async_abort_cmd(srb_t *cmd_sp, bool wait)
 	sp->type = SRB_ABT_CMD;
 	sp->name = "abort";
 	sp->qpair = cmd_sp->qpair;
+	sp->cmd_sp = cmd_sp;
 	if (wait)
 		sp->flags = SRB_WAKEUP_ON_COMP;
 

