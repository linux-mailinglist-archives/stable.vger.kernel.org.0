Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65A3B11F25F
	for <lists+stable@lfdr.de>; Sat, 14 Dec 2019 16:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbfLNPD5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Dec 2019 10:03:57 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:48235 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725975AbfLNPD5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Dec 2019 10:03:57 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 3333683C;
        Sat, 14 Dec 2019 10:03:56 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sat, 14 Dec 2019 10:03:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=nN4cyZ
        OJs/TuWOC2679i/8rmtdWJGGSp7qYfX+BMsxY=; b=fOXY7EChmpil+VfBe4xHNF
        RLj9vIW3XRAlXtay2QYryCpUheHRVST9GSBKo9p5XrriQbJJ9NmwaM8ONj5VWT5E
        VviWK7Idv4pSxYl3RHmIHP5izH9R1NwVuX1rmE+z2HL85a1QjftsdYzSay1ipHKG
        kBQQm5hRyImPwbgyO6jx/iLCckO5hT3XlPARKlAltSkugjhgguK+cr4yXlg5iJ/8
        6f7F4iAt8piZRih6vG4AMxIYXbmsSXfP2s9Ho3Prnc6NLF7PpjlCEwzNaZBVlIsR
        dClatZwYCC53sG7VqSFrleO7AMj+FE2sZpoYgntxY2jTEuXNSeGyXi7XzWPsEqzA
        ==
X-ME-Sender: <xms:2_n0XXi5MLBsk1UDEQTknbDP4fPT1oH7UBcBfqp0u15Rg8qh8ATVHg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtuddgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpeeh
X-ME-Proxy: <xmx:2_n0XT3lOHpGYH3EgCahxtMCtchusogMHBdMz6dVfW1kXVVQUlzpuA>
    <xmx:2_n0XZrwnO-DOOjKQILIBTskPotHhqW5m--M_8_jHfb_mis81y5DyA>
    <xmx:2_n0XQ0m_cZTEr3Zse3kWDr6Oikk55fKXo0L5n1AX-_kUREceNh3vw>
    <xmx:2_n0Xf_bpKunjUGBJMz3RYsN6KoqI4QNgusvG7gkuFMsFJ56j7-5hw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 506A0306010D;
        Sat, 14 Dec 2019 10:03:55 -0500 (EST)
Subject: FAILED: patch "[PATCH] scsi: qla2xxx: Retry PLOGI on FC-NVMe PRLI failure" failed to apply to 5.4-stable tree
To:     qutran@marvell.com, emilne@redhat.com, hmadhani@marvell.com,
        martin.petersen@oracle.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 14 Dec 2019 16:03:54 +0100
Message-ID: <15763358341182@kroah.com>
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

From 983f127603fac650fa34ee69db363e4615eaf9e7 Mon Sep 17 00:00:00 2001
From: Quinn Tran <qutran@marvell.com>
Date: Tue, 5 Nov 2019 07:06:50 -0800
Subject: [PATCH] scsi: qla2xxx: Retry PLOGI on FC-NVMe PRLI failure

Current code will send PRLI with FC-NVMe bit set for the targets which
support only FCP. This may result into issue with targets which do not
understand NVMe and will go into a strange state. This patch would restart
the login process by going back to PLOGI state. The PLOGI state will force
the target to respond to correct PRLI request.

Fixes: c76ae845ea836 ("scsi: qla2xxx: Add error handling for PLOGI ELS passthrough")
Cc: stable@vger.kernel.org # 5.4
Link: https://lore.kernel.org/r/20191105150657.8092-2-hmadhani@marvell.com
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 7cb7545de962..5db8ad832893 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1864,42 +1864,21 @@ qla24xx_handle_prli_done_event(struct scsi_qla_host *vha, struct event_arg *ea)
 		 * FCP/NVMe port
 		 */
 		if (NVME_FCP_TARGET(ea->fcport)) {
-			if (vha->hw->fc4_type_priority == FC4_PRIORITY_NVME)
-				ea->fcport->fc4_type &= ~FS_FC4TYPE_NVME;
-			else
-				ea->fcport->fc4_type &= ~FS_FC4TYPE_FCP;
 			ql_dbg(ql_dbg_disc, vha, 0x2118,
 				"%s %d %8phC post %s prli\n",
 				__func__, __LINE__, ea->fcport->port_name,
 				(ea->fcport->fc4_type & FS_FC4TYPE_NVME) ?
 				"NVMe" : "FCP");
-			qla24xx_post_prli_work(vha, ea->fcport);
-			break;
+			if (vha->hw->fc4_type_priority == FC4_PRIORITY_NVME)
+				ea->fcport->fc4_type &= ~FS_FC4TYPE_NVME;
+			else
+				ea->fcport->fc4_type &= ~FS_FC4TYPE_FCP;
 		}
 
-		/* at this point both PRLI NVME & PRLI FCP failed */
-		if (N2N_TOPO(vha->hw)) {
-			if (ea->fcport->n2n_link_reset_cnt < 3) {
-				ea->fcport->n2n_link_reset_cnt++;
-				/*
-				 * remote port is not sending Plogi. Reset
-				 * link to kick start his state machine
-				 */
-				set_bit(N2N_LINK_RESET, &vha->dpc_flags);
-			} else {
-				ql_log(ql_log_warn, vha, 0x2119,
-				    "%s %d %8phC Unable to reconnect\n",
-				    __func__, __LINE__, ea->fcport->port_name);
-			}
-		} else {
-			/*
-			 * switch connect. login failed. Take connection
-			 * down and allow relogin to retrigger
-			 */
-			ea->fcport->flags &= ~FCF_ASYNC_SENT;
-			ea->fcport->keep_nport_handle = 0;
-			qlt_schedule_sess_for_deletion(ea->fcport);
-		}
+		ea->fcport->flags &= ~FCF_ASYNC_SENT;
+		ea->fcport->keep_nport_handle = 0;
+		ea->fcport->logout_on_delete = 1;
+		qlt_schedule_sess_for_deletion(ea->fcport);
 		break;
 	}
 }
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index eeb526411536..2b675da34bda 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2764,6 +2764,7 @@ static void qla2x00_els_dcmd2_sp_done(srb_t *sp, int res)
 			ea.sp = sp;
 			qla24xx_handle_plogi_done_event(vha, &ea);
 			break;
+
 		case CS_IOCB_ERROR:
 			switch (fw_status[1]) {
 			case LSC_SCODE_PORTID_USED:
@@ -2834,6 +2835,7 @@ static void qla2x00_els_dcmd2_sp_done(srb_t *sp, int res)
 				    fw_status[0], fw_status[1], fw_status[2]);
 
 				fcport->flags &= ~FCF_ASYNC_SENT;
+				fcport->disc_state = DSC_LOGIN_FAILED;
 				set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 				break;
 			}
@@ -2846,6 +2848,7 @@ static void qla2x00_els_dcmd2_sp_done(srb_t *sp, int res)
 			    fw_status[0], fw_status[1], fw_status[2]);
 
 			sp->fcport->flags &= ~FCF_ASYNC_SENT;
+			sp->fcport->disc_state = DSC_LOGIN_FAILED;
 			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 			break;
 		}
@@ -2881,11 +2884,12 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
 		return -ENOMEM;
 	}
 
+	fcport->flags |= FCF_ASYNC_SENT;
+	fcport->disc_state = DSC_LOGIN_PEND;
 	elsio = &sp->u.iocb_cmd;
 	ql_dbg(ql_dbg_io, vha, 0x3073,
 	    "Enter: PLOGI portid=%06x\n", fcport->d_id.b24);
 
-	fcport->flags |= FCF_ASYNC_SENT;
 	sp->type = SRB_ELS_DCMD;
 	sp->name = "ELS_DCMD";
 	sp->fcport = fcport;

