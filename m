Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 751A0611C36
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 23:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbiJ1VJm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 17:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiJ1VJL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 17:09:11 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A771724A54D
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 14:09:07 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id r19so4266359qtx.6
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 14:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b47/pHmpKxfklblGg0tUlaG0Ok0ODGh/Oj8X2pU0K3Q=;
        b=nwE+JOiRPoKU6LlQOdng/rCfbESoXME6E4dkwucMYTsc3WOrz7uu47CX4ZsGfoM8gN
         uPvTKPBPhQuvjyWwxPORTahLUWuwoEWo93YuB1uBFMd3L9X2+ZA4r3WLXwThN+SN6uo8
         VMTN1s/Y/Pf9ZpqcoZIbPBHhVAG6i7Wnq+lUaoWgWPou4E+Uc5oEppPHij6F4gP/iTTw
         Sqv8EvgvINFv1FgLDh8UjLUNdp3cutLRJNsGdcshuHhwvV3526Bpp6GLddRO1gxNicmn
         Qt2FRVDGxaTJZQDotStF4sDXku2S0eaVnmzw4UXNRjBCg0u19Ib1X0dcSukMiprtorPJ
         6OHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b47/pHmpKxfklblGg0tUlaG0Ok0ODGh/Oj8X2pU0K3Q=;
        b=glifcSqr1iO2RlYyfm1wVxt5sMVuCXzNKw4RXXc3jzXNLta5EoOef7/PmRWcDFp5Uw
         OTrDFWueS7wb3jaqWnZF+q3ngpcucZrZN/ApyRTKYnKZONeNyinmc+BkvUPB5Hr2upln
         n3OaK1irT9y7Hk++nspbYYHseb5Fd7b1BeUmNQDpnY3kwf/FJXCdBJ8nJ3Mf8IGcocdg
         ia86mbbSuzNTzhASlUceQ8rTzgz1vQLlJ2W0nagnzUyP3CuIyjtx4vxCB9gOwciD6bTl
         4yWbN1kjlInU69UFqrt4GfgOs5tWD+8HzatC94m1dYJReSqFgpMNhR2YOVBJ+AgcqVKA
         5yzg==
X-Gm-Message-State: ACrzQf20OgiSbFbO3c7JmTtFQP4LImMJQfjKzC8Z8UhP3I5sW8pYN1b3
        DmSGLfi0qiyO4zCZR+Cb7lhnFD+xAU4=
X-Google-Smtp-Source: AMsMyM4hybE1sbsvjDEGJFFmgAy+ujllK4AChFMgs0u/hHV9osbTInPqUfRRV5iM0TD/nb2DdvQBfw==
X-Received: by 2002:ac8:5854:0:b0:39c:dba4:6fa0 with SMTP id h20-20020ac85854000000b0039cdba46fa0mr1310199qth.175.1666991345306;
        Fri, 28 Oct 2022 14:09:05 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id fu36-20020a05622a5da400b0035cf31005e2sm2906808qtb.73.2022.10.28.14.09.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 14:09:04 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     stable@vger.kernel.org
Cc:     jsmart2021@gmail.com, justintee8345@gmail.com,
        martin.petersen@oracle.com, gregkh@linuxfoundation.org
Subject: [PATCH v2 6/6] Revert "scsi: lpfc: SLI path split: Refactor lpfc_iocbq"
Date:   Fri, 28 Oct 2022 14:08:27 -0700
Message-Id: <20221028210827.23149-7-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20221028210827.23149-1-jsmart2021@gmail.com>
References: <20221028210827.23149-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 1c5e670d6a5a8e7e99b51f45e79879f7828bd2ec.

LTS 5.15 pulled in several lpfc "SLI Path split" patches.  The Path
Split mods were a 14-patch set, which refactors the driver from
to split the sli-3 hw (now eol) from the sli-4 hw and use sli4
structures natively. The patches are highly inter-related.

Given only some of the patches were included, it created a situation
where FLOGI's fail, thus SLI Ports can't start communication.

Reverting this patch as its one of the partial Path Split patches
that was included.

Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c       |  50 ++---
 drivers/scsi/lpfc/lpfc_crtn.h      |   2 +-
 drivers/scsi/lpfc/lpfc_ct.c        |   8 +-
 drivers/scsi/lpfc/lpfc_els.c       | 139 ++++++------
 drivers/scsi/lpfc/lpfc_init.c      |  11 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c |   4 +-
 drivers/scsi/lpfc/lpfc_nvme.c      |  34 ++-
 drivers/scsi/lpfc/lpfc_nvme.h      |   6 +-
 drivers/scsi/lpfc/lpfc_nvmet.c     |  83 ++++---
 drivers/scsi/lpfc/lpfc_scsi.c      |  75 ++++---
 drivers/scsi/lpfc/lpfc_sli.c       | 340 +++++++++++++++--------------
 drivers/scsi/lpfc/lpfc_sli.h       |  24 +-
 12 files changed, 391 insertions(+), 385 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 6688a575904f..fdf08cb57207 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -325,7 +325,7 @@ lpfc_bsg_send_mgmt_cmd_cmp(struct lpfc_hba *phba,
 
 	/* Close the timeout handler abort window */
 	spin_lock_irqsave(&phba->hbalock, flags);
-	cmdiocbq->cmd_flag &= ~LPFC_IO_CMD_OUTSTANDING;
+	cmdiocbq->iocb_flag &= ~LPFC_IO_CMD_OUTSTANDING;
 	spin_unlock_irqrestore(&phba->hbalock, flags);
 
 	iocb = &dd_data->context_un.iocb;
@@ -481,11 +481,11 @@ lpfc_bsg_send_mgmt_cmd(struct bsg_job *job)
 	cmd->ulpOwner = OWN_CHIP;
 	cmdiocbq->vport = phba->pport;
 	cmdiocbq->context3 = bmp;
-	cmdiocbq->cmd_flag |= LPFC_IO_LIBDFC;
+	cmdiocbq->iocb_flag |= LPFC_IO_LIBDFC;
 	timeout = phba->fc_ratov * 2;
 	cmd->ulpTimeout = timeout;
 
-	cmdiocbq->cmd_cmpl = lpfc_bsg_send_mgmt_cmd_cmp;
+	cmdiocbq->iocb_cmpl = lpfc_bsg_send_mgmt_cmd_cmp;
 	cmdiocbq->context1 = dd_data;
 	cmdiocbq->context2 = cmp;
 	cmdiocbq->context3 = bmp;
@@ -516,9 +516,9 @@ lpfc_bsg_send_mgmt_cmd(struct bsg_job *job)
 	if (iocb_stat == IOCB_SUCCESS) {
 		spin_lock_irqsave(&phba->hbalock, flags);
 		/* make sure the I/O had not been completed yet */
-		if (cmdiocbq->cmd_flag & LPFC_IO_LIBDFC) {
+		if (cmdiocbq->iocb_flag & LPFC_IO_LIBDFC) {
 			/* open up abort window to timeout handler */
-			cmdiocbq->cmd_flag |= LPFC_IO_CMD_OUTSTANDING;
+			cmdiocbq->iocb_flag |= LPFC_IO_CMD_OUTSTANDING;
 		}
 		spin_unlock_irqrestore(&phba->hbalock, flags);
 		return 0; /* done for now */
@@ -600,7 +600,7 @@ lpfc_bsg_rport_els_cmp(struct lpfc_hba *phba,
 
 	/* Close the timeout handler abort window */
 	spin_lock_irqsave(&phba->hbalock, flags);
-	cmdiocbq->cmd_flag &= ~LPFC_IO_CMD_OUTSTANDING;
+	cmdiocbq->iocb_flag &= ~LPFC_IO_CMD_OUTSTANDING;
 	spin_unlock_irqrestore(&phba->hbalock, flags);
 
 	rsp = &rspiocbq->iocb;
@@ -726,10 +726,10 @@ lpfc_bsg_rport_els(struct bsg_job *job)
 		cmdiocbq->iocb.ulpContext = phba->sli4_hba.rpi_ids[rpi];
 	else
 		cmdiocbq->iocb.ulpContext = rpi;
-	cmdiocbq->cmd_flag |= LPFC_IO_LIBDFC;
+	cmdiocbq->iocb_flag |= LPFC_IO_LIBDFC;
 	cmdiocbq->context1 = dd_data;
 	cmdiocbq->context_un.ndlp = ndlp;
-	cmdiocbq->cmd_cmpl = lpfc_bsg_rport_els_cmp;
+	cmdiocbq->iocb_cmpl = lpfc_bsg_rport_els_cmp;
 	dd_data->type = TYPE_IOCB;
 	dd_data->set_job = job;
 	dd_data->context_un.iocb.cmdiocbq = cmdiocbq;
@@ -757,9 +757,9 @@ lpfc_bsg_rport_els(struct bsg_job *job)
 	if (rc == IOCB_SUCCESS) {
 		spin_lock_irqsave(&phba->hbalock, flags);
 		/* make sure the I/O had not been completed/released */
-		if (cmdiocbq->cmd_flag & LPFC_IO_LIBDFC) {
+		if (cmdiocbq->iocb_flag & LPFC_IO_LIBDFC) {
 			/* open up abort window to timeout handler */
-			cmdiocbq->cmd_flag |= LPFC_IO_CMD_OUTSTANDING;
+			cmdiocbq->iocb_flag |= LPFC_IO_CMD_OUTSTANDING;
 		}
 		spin_unlock_irqrestore(&phba->hbalock, flags);
 		return 0; /* done for now */
@@ -1053,7 +1053,7 @@ lpfc_bsg_ct_unsol_event(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 							lpfc_in_buf_free(phba,
 									dmabuf);
 						} else {
-							lpfc_sli3_post_buffer(phba,
+							lpfc_post_buffer(phba,
 									 pring,
 									 1);
 						}
@@ -1061,7 +1061,7 @@ lpfc_bsg_ct_unsol_event(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 					default:
 						if (!(phba->sli3_options &
 						      LPFC_SLI3_HBQ_ENABLED))
-							lpfc_sli3_post_buffer(phba,
+							lpfc_post_buffer(phba,
 									 pring,
 									 1);
 						break;
@@ -1395,7 +1395,7 @@ lpfc_issue_ct_rsp_cmp(struct lpfc_hba *phba,
 
 	/* Close the timeout handler abort window */
 	spin_lock_irqsave(&phba->hbalock, flags);
-	cmdiocbq->cmd_flag &= ~LPFC_IO_CMD_OUTSTANDING;
+	cmdiocbq->iocb_flag &= ~LPFC_IO_CMD_OUTSTANDING;
 	spin_unlock_irqrestore(&phba->hbalock, flags);
 
 	ndlp = dd_data->context_un.iocb.ndlp;
@@ -1549,13 +1549,13 @@ lpfc_issue_ct_rsp(struct lpfc_hba *phba, struct bsg_job *job, uint32_t tag,
 		"2722 Xmit CT response on exchange x%x Data: x%x x%x x%x\n",
 		icmd->ulpContext, icmd->ulpIoTag, tag, phba->link_state);
 
-	ctiocb->cmd_flag |= LPFC_IO_LIBDFC;
+	ctiocb->iocb_flag |= LPFC_IO_LIBDFC;
 	ctiocb->vport = phba->pport;
 	ctiocb->context1 = dd_data;
 	ctiocb->context2 = cmp;
 	ctiocb->context3 = bmp;
 	ctiocb->context_un.ndlp = ndlp;
-	ctiocb->cmd_cmpl = lpfc_issue_ct_rsp_cmp;
+	ctiocb->iocb_cmpl = lpfc_issue_ct_rsp_cmp;
 
 	dd_data->type = TYPE_IOCB;
 	dd_data->set_job = job;
@@ -1582,9 +1582,9 @@ lpfc_issue_ct_rsp(struct lpfc_hba *phba, struct bsg_job *job, uint32_t tag,
 	if (rc == IOCB_SUCCESS) {
 		spin_lock_irqsave(&phba->hbalock, flags);
 		/* make sure the I/O had not been completed/released */
-		if (ctiocb->cmd_flag & LPFC_IO_LIBDFC) {
+		if (ctiocb->iocb_flag & LPFC_IO_LIBDFC) {
 			/* open up abort window to timeout handler */
-			ctiocb->cmd_flag |= LPFC_IO_CMD_OUTSTANDING;
+			ctiocb->iocb_flag |= LPFC_IO_CMD_OUTSTANDING;
 		}
 		spin_unlock_irqrestore(&phba->hbalock, flags);
 		return 0; /* done for now */
@@ -2713,9 +2713,9 @@ static int lpfcdiag_loop_get_xri(struct lpfc_hba *phba, uint16_t rpi,
 	cmd->ulpClass = CLASS3;
 	cmd->ulpContext = rpi;
 
-	cmdiocbq->cmd_flag |= LPFC_IO_LIBDFC;
+	cmdiocbq->iocb_flag |= LPFC_IO_LIBDFC;
 	cmdiocbq->vport = phba->pport;
-	cmdiocbq->cmd_cmpl = NULL;
+	cmdiocbq->iocb_cmpl = NULL;
 
 	iocb_stat = lpfc_sli_issue_iocb_wait(phba, LPFC_ELS_RING, cmdiocbq,
 				rspiocbq,
@@ -3286,10 +3286,10 @@ lpfc_bsg_diag_loopback_run(struct bsg_job *job)
 		cmdiocbq->sli4_xritag = NO_XRI;
 		cmd->unsli3.rcvsli3.ox_id = 0xffff;
 	}
-	cmdiocbq->cmd_flag |= LPFC_IO_LIBDFC;
-	cmdiocbq->cmd_flag |= LPFC_IO_LOOPBACK;
+	cmdiocbq->iocb_flag |= LPFC_IO_LIBDFC;
+	cmdiocbq->iocb_flag |= LPFC_IO_LOOPBACK;
 	cmdiocbq->vport = phba->pport;
-	cmdiocbq->cmd_cmpl = NULL;
+	cmdiocbq->iocb_cmpl = NULL;
 	iocb_stat = lpfc_sli_issue_iocb_wait(phba, LPFC_ELS_RING, cmdiocbq,
 					     rspiocbq, (phba->fc_ratov * 2) +
 					     LPFC_DRVR_TIMEOUT);
@@ -5273,11 +5273,11 @@ lpfc_menlo_cmd(struct bsg_job *job)
 	cmd->ulpClass = CLASS3;
 	cmd->ulpOwner = OWN_CHIP;
 	cmd->ulpLe = 1; /* Limited Edition */
-	cmdiocbq->cmd_flag |= LPFC_IO_LIBDFC;
+	cmdiocbq->iocb_flag |= LPFC_IO_LIBDFC;
 	cmdiocbq->vport = phba->pport;
 	/* We want the firmware to timeout before we do */
 	cmd->ulpTimeout = MENLO_TIMEOUT - 5;
-	cmdiocbq->cmd_cmpl = lpfc_bsg_menlo_cmd_cmp;
+	cmdiocbq->iocb_cmpl = lpfc_bsg_menlo_cmd_cmp;
 	cmdiocbq->context1 = dd_data;
 	cmdiocbq->context2 = cmp;
 	cmdiocbq->context3 = bmp;
@@ -6001,7 +6001,7 @@ lpfc_bsg_timeout(struct bsg_job *job)
 
 		spin_lock_irqsave(&phba->hbalock, flags);
 		/* make sure the I/O abort window is still open */
-		if (!(cmdiocb->cmd_flag & LPFC_IO_CMD_OUTSTANDING)) {
+		if (!(cmdiocb->iocb_flag & LPFC_IO_CMD_OUTSTANDING)) {
 			spin_unlock_irqrestore(&phba->hbalock, flags);
 			return -EAGAIN;
 		}
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index ed27a0afcb8b..c9770b1d2366 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -210,7 +210,7 @@ int lpfc_config_port_post(struct lpfc_hba *);
 int lpfc_hba_down_prep(struct lpfc_hba *);
 int lpfc_hba_down_post(struct lpfc_hba *);
 void lpfc_hba_init(struct lpfc_hba *, uint32_t *);
-int lpfc_sli3_post_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring, int cnt);
+int lpfc_post_buffer(struct lpfc_hba *, struct lpfc_sli_ring *, int);
 void lpfc_decode_firmware_rev(struct lpfc_hba *, char *, int);
 int lpfc_online(struct lpfc_hba *);
 void lpfc_unblock_mgmt_io(struct lpfc_hba *);
diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 19e2f8086a6d..dfcb7d4bd7fa 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -239,7 +239,7 @@ lpfc_ct_reject_event(struct lpfc_nodelist *ndlp,
 	cmdiocbq->context1 = lpfc_nlp_get(ndlp);
 	cmdiocbq->context2 = (uint8_t *)mp;
 	cmdiocbq->context3 = (uint8_t *)bmp;
-	cmdiocbq->cmd_cmpl = lpfc_ct_unsol_cmpl;
+	cmdiocbq->iocb_cmpl = lpfc_ct_unsol_cmpl;
 	icmd->ulpContext = rx_id;  /* Xri / rx_id */
 	icmd->unsli3.rcvsli3.ox_id = ox_id;
 	icmd->un.ulpWord[3] =
@@ -370,7 +370,7 @@ lpfc_ct_unsol_event(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		/* Not enough posted buffers; Try posting more buffers */
 		phba->fc_stat.NoRcvBuf++;
 		if (!(phba->sli3_options & LPFC_SLI3_HBQ_ENABLED))
-			lpfc_sli3_post_buffer(phba, pring, 2);
+			lpfc_post_buffer(phba, pring, 2);
 		return;
 	}
 
@@ -447,7 +447,7 @@ lpfc_ct_unsol_event(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 				lpfc_ct_unsol_buffer(phba, iocbq, mp, size);
 				lpfc_in_buf_free(phba, mp);
 			}
-			lpfc_sli3_post_buffer(phba, pring, i);
+			lpfc_post_buffer(phba, pring, i);
 		}
 		list_del(&head);
 	}
@@ -652,7 +652,7 @@ lpfc_gen_req(struct lpfc_vport *vport, struct lpfc_dmabuf *bmp,
 			 "Data: x%x x%x\n",
 			 ndlp->nlp_DID, icmd->ulpIoTag,
 			 vport->port_state);
-	geniocb->cmd_cmpl = cmpl;
+	geniocb->iocb_cmpl = cmpl;
 	geniocb->drvrTimeout = icmd->ulpTimeout + LPFC_DRVR_TIMEOUT;
 	geniocb->vport = vport;
 	geniocb->retry = retry;
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 0d34a03164f5..5f44a0763f37 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -192,23 +192,23 @@ lpfc_prep_els_iocb(struct lpfc_vport *vport, uint8_t expectRsp,
 		 (elscmd == ELS_CMD_LOGO)))
 		switch (elscmd) {
 		case ELS_CMD_FLOGI:
-		elsiocb->cmd_flag |=
+		elsiocb->iocb_flag |=
 			((LPFC_ELS_ID_FLOGI << LPFC_FIP_ELS_ID_SHIFT)
 					& LPFC_FIP_ELS_ID_MASK);
 		break;
 		case ELS_CMD_FDISC:
-		elsiocb->cmd_flag |=
+		elsiocb->iocb_flag |=
 			((LPFC_ELS_ID_FDISC << LPFC_FIP_ELS_ID_SHIFT)
 					& LPFC_FIP_ELS_ID_MASK);
 		break;
 		case ELS_CMD_LOGO:
-		elsiocb->cmd_flag |=
+		elsiocb->iocb_flag |=
 			((LPFC_ELS_ID_LOGO << LPFC_FIP_ELS_ID_SHIFT)
 					& LPFC_FIP_ELS_ID_MASK);
 		break;
 		}
 	else
-		elsiocb->cmd_flag &= ~LPFC_FIP_ELS_ID_MASK;
+		elsiocb->iocb_flag &= ~LPFC_FIP_ELS_ID_MASK;
 
 	icmd = &elsiocb->iocb;
 
@@ -1252,10 +1252,10 @@ lpfc_cmpl_els_link_down(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			"6445 ELS completes after LINK_DOWN: "
 			" Status %x/%x cmd x%x flg x%x\n",
 			irsp->ulpStatus, irsp->un.ulpWord[4], cmd,
-			cmdiocb->cmd_flag);
+			cmdiocb->iocb_flag);
 
-	if (cmdiocb->cmd_flag & LPFC_IO_FABRIC) {
-		cmdiocb->cmd_flag &= ~LPFC_IO_FABRIC;
+	if (cmdiocb->iocb_flag & LPFC_IO_FABRIC) {
+		cmdiocb->iocb_flag &= ~LPFC_IO_FABRIC;
 		atomic_dec(&phba->fabric_iocb_count);
 	}
 	lpfc_els_free_iocb(phba, cmdiocb);
@@ -1370,7 +1370,7 @@ lpfc_issue_els_flogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	phba->fc_ratov = tmo;
 
 	phba->fc_stat.elsXmitFLOGI++;
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_flogi;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_flogi;
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 		"Issue FLOGI:     opt:x%x",
@@ -1463,7 +1463,7 @@ lpfc_els_abort_flogi(struct lpfc_hba *phba)
 			if (ndlp && ndlp->nlp_DID == Fabric_DID) {
 				if ((phba->pport->fc_flag & FC_PT2PT) &&
 				    !(phba->pport->fc_flag & FC_PT2PT_PLOGI))
-					iocb->fabric_cmd_cmpl =
+					iocb->fabric_iocb_cmpl =
 						lpfc_ignore_els_cmpl;
 				lpfc_sli_issue_abort_iotag(phba, pring, iocb,
 							   NULL);
@@ -2226,7 +2226,7 @@ lpfc_issue_els_plogi(struct lpfc_vport *vport, uint32_t did, uint8_t retry)
 	}
 
 	phba->fc_stat.elsXmitPLOGI++;
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_plogi;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_plogi;
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 			      "Issue PLOGI:     did:x%x refcnt %d",
@@ -2478,7 +2478,7 @@ lpfc_issue_els_prli(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		/* For FCP support */
 		npr->prliType = PRLI_FCP_TYPE;
 		npr->initiatorFunc = 1;
-		elsiocb->cmd_flag |= LPFC_PRLI_FCP_REQ;
+		elsiocb->iocb_flag |= LPFC_PRLI_FCP_REQ;
 
 		/* Remove FCP type - processed. */
 		local_nlp_type &= ~NLP_FC4_FCP;
@@ -2512,14 +2512,14 @@ lpfc_issue_els_prli(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 
 		npr_nvme->word1 = cpu_to_be32(npr_nvme->word1);
 		npr_nvme->word4 = cpu_to_be32(npr_nvme->word4);
-		elsiocb->cmd_flag |= LPFC_PRLI_NVME_REQ;
+		elsiocb->iocb_flag |= LPFC_PRLI_NVME_REQ;
 
 		/* Remove NVME type - processed. */
 		local_nlp_type &= ~NLP_FC4_NVME;
 	}
 
 	phba->fc_stat.elsXmitPRLI++;
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_prli;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_prli;
 	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag |= NLP_PRLI_SND;
 
@@ -2842,7 +2842,7 @@ lpfc_issue_els_adisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	ap->DID = be32_to_cpu(vport->fc_myDID);
 
 	phba->fc_stat.elsXmitADISC++;
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_adisc;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_adisc;
 	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag |= NLP_ADISC_SND;
 	spin_unlock_irq(&ndlp->lock);
@@ -3065,7 +3065,7 @@ lpfc_issue_els_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	memcpy(pcmd, &vport->fc_portname, sizeof(struct lpfc_name));
 
 	phba->fc_stat.elsXmitLOGO++;
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_logo;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_logo;
 	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag |= NLP_LOGO_SND;
 	ndlp->nlp_flag &= ~NLP_ISSUE_LOGO;
@@ -3417,7 +3417,7 @@ lpfc_issue_els_scr(struct lpfc_vport *vport, uint8_t retry)
 		ndlp->nlp_DID, 0, 0);
 
 	phba->fc_stat.elsXmitSCR++;
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_disc_cmd;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_disc_cmd;
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
 	if (!elsiocb->context1) {
 		lpfc_els_free_iocb(phba, elsiocb);
@@ -3514,7 +3514,7 @@ lpfc_issue_els_rscn(struct lpfc_vport *vport, uint8_t retry)
 	event->portid.rscn_fid[2] = nportid & 0x000000FF;
 
 	phba->fc_stat.elsXmitRSCN++;
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_cmd;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_cmd;
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
 	if (!elsiocb->context1) {
 		lpfc_els_free_iocb(phba, elsiocb);
@@ -3613,7 +3613,7 @@ lpfc_issue_els_farpr(struct lpfc_vport *vport, uint32_t nportid, uint8_t retry)
 		ndlp->nlp_DID, 0, 0);
 
 	phba->fc_stat.elsXmitFARPR++;
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_cmd;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_cmd;
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
 	if (!elsiocb->context1) {
 		lpfc_els_free_iocb(phba, elsiocb);
@@ -3704,7 +3704,7 @@ lpfc_issue_els_rdf(struct lpfc_vport *vport, uint8_t retry)
 			 phba->cgn_reg_fpin);
 
 	phba->cgn_fpin_frequency = LPFC_FPIN_INIT_FREQ;
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_disc_cmd;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_disc_cmd;
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
 	if (!elsiocb->context1) {
 		lpfc_els_free_iocb(phba, elsiocb);
@@ -4154,7 +4154,7 @@ lpfc_issue_els_edc(struct lpfc_vport *vport, uint8_t retry)
 			 ndlp->nlp_DID, phba->cgn_reg_signal,
 			 phba->cgn_reg_fpin);
 
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_disc_cmd;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_disc_cmd;
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
 	if (!elsiocb->context1) {
 		lpfc_els_free_iocb(phba, elsiocb);
@@ -4968,12 +4968,12 @@ lpfc_els_free_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *elsiocb)
 
 	/* context2  = cmd,  context2->next = rsp, context3 = bpl */
 	if (elsiocb->context2) {
-		if (elsiocb->cmd_flag & LPFC_DELAY_MEM_FREE) {
+		if (elsiocb->iocb_flag & LPFC_DELAY_MEM_FREE) {
 			/* Firmware could still be in progress of DMAing
 			 * payload, so don't free data buffer till after
 			 * a hbeat.
 			 */
-			elsiocb->cmd_flag &= ~LPFC_DELAY_MEM_FREE;
+			elsiocb->iocb_flag &= ~LPFC_DELAY_MEM_FREE;
 			buf_ptr = elsiocb->context2;
 			elsiocb->context2 = NULL;
 			if (buf_ptr) {
@@ -5480,9 +5480,9 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 			ndlp->nlp_flag & NLP_REG_LOGIN_SEND))
 			ndlp->nlp_flag &= ~NLP_LOGO_ACC;
 		spin_unlock_irq(&ndlp->lock);
-		elsiocb->cmd_cmpl = lpfc_cmpl_els_logo_acc;
+		elsiocb->iocb_cmpl = lpfc_cmpl_els_logo_acc;
 	} else {
-		elsiocb->cmd_cmpl = lpfc_cmpl_els_rsp;
+		elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
 	}
 
 	phba->fc_stat.elsXmitACC++;
@@ -5577,7 +5577,7 @@ lpfc_els_rsp_reject(struct lpfc_vport *vport, uint32_t rejectError,
 		ndlp->nlp_DID, ndlp->nlp_flag, rejectError);
 
 	phba->fc_stat.elsXmitLSRJT++;
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_rsp;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
 	if (!elsiocb->context1) {
 		lpfc_els_free_iocb(phba, elsiocb);
@@ -5657,7 +5657,7 @@ lpfc_issue_els_edc_rsp(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 			      "Issue EDC ACC:      did:x%x flg:x%x refcnt %d",
 			      ndlp->nlp_DID, ndlp->nlp_flag,
 			      kref_read(&ndlp->kref));
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_rsp;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
 
 	phba->fc_stat.elsXmitACC++;
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
@@ -5750,7 +5750,7 @@ lpfc_els_rsp_adisc_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 		      ndlp->nlp_DID, ndlp->nlp_flag, kref_read(&ndlp->kref));
 
 	phba->fc_stat.elsXmitACC++;
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_rsp;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
 	if (!elsiocb->context1) {
 		lpfc_els_free_iocb(phba, elsiocb);
@@ -5924,7 +5924,7 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 		      ndlp->nlp_DID, ndlp->nlp_flag, kref_read(&ndlp->kref));
 
 	phba->fc_stat.elsXmitACC++;
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_rsp;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
 	elsiocb->context1 =  lpfc_nlp_get(ndlp);
 	if (!elsiocb->context1) {
 		lpfc_els_free_iocb(phba, elsiocb);
@@ -6025,7 +6025,7 @@ lpfc_els_rsp_rnid_acc(struct lpfc_vport *vport, uint8_t format,
 		      ndlp->nlp_DID, ndlp->nlp_flag, kref_read(&ndlp->kref));
 
 	phba->fc_stat.elsXmitACC++;
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_rsp;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
 	if (!elsiocb->context1) {
 		lpfc_els_free_iocb(phba, elsiocb);
@@ -6139,7 +6139,7 @@ lpfc_els_rsp_echo_acc(struct lpfc_vport *vport, uint8_t *data,
 		      ndlp->nlp_DID, ndlp->nlp_flag, kref_read(&ndlp->kref));
 
 	phba->fc_stat.elsXmitACC++;
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_rsp;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
 	elsiocb->context1 =  lpfc_nlp_get(ndlp);
 	if (!elsiocb->context1) {
 		lpfc_els_free_iocb(phba, elsiocb);
@@ -6803,7 +6803,7 @@ lpfc_els_rdp_cmpl(struct lpfc_hba *phba, struct lpfc_rdp_context *rdp_context,
 				     rdp_context->page_a0, vport);
 
 	rdp_res->length = cpu_to_be32(len - 8);
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_rsp;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
 
 	/* Now that we know the true size of the payload, update the BPL */
 	bpl = (struct ulp_bde64 *)
@@ -6844,7 +6844,7 @@ lpfc_els_rdp_cmpl(struct lpfc_hba *phba, struct lpfc_rdp_context *rdp_context,
 	stat->un.b.lsRjtRsnCode = LSRJT_UNABLE_TPC;
 
 	phba->fc_stat.elsXmitLSRJT++;
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_rsp;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
 	if (!elsiocb->context1) {
 		lpfc_els_free_iocb(phba, elsiocb);
@@ -7066,7 +7066,7 @@ lpfc_els_lcb_rsp(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	lcb_res->capability = lcb_context->capability;
 	lcb_res->lcb_frequency = lcb_context->frequency;
 	lcb_res->lcb_duration = lcb_context->duration;
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_rsp;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
 	phba->fc_stat.elsXmitACC++;
 
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
@@ -7105,7 +7105,7 @@ lpfc_els_lcb_rsp(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	if (shdr_add_status == ADD_STATUS_OPERATION_ALREADY_ACTIVE)
 		stat->un.b.lsRjtRsnCodeExp = LSEXP_CMD_IN_PROGRESS;
 
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_rsp;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
 	phba->fc_stat.elsXmitLSRJT++;
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
 	if (!elsiocb->context1) {
@@ -8172,7 +8172,7 @@ lpfc_els_rsp_rls_acc(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 			 elsiocb->iotag, elsiocb->iocb.ulpContext,
 			 ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
 			 ndlp->nlp_rpi);
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_rsp;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
 	phba->fc_stat.elsXmitACC++;
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
 	if (!elsiocb->context1) {
@@ -8324,7 +8324,7 @@ lpfc_els_rcv_rtv(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 			 ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
 			 ndlp->nlp_rpi,
 			rtv_rsp->ratov, rtv_rsp->edtov, rtv_rsp->qtov);
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_rsp;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
 	phba->fc_stat.elsXmitACC++;
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
 	if (!elsiocb->context1) {
@@ -8401,7 +8401,7 @@ lpfc_issue_els_rrq(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		"Issue RRQ:     did:x%x",
 		did, rrq->xritag, rrq->rxid);
 	elsiocb->context_un.rrq = rrq;
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_rrq;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_rrq;
 
 	lpfc_nlp_get(ndlp);
 	elsiocb->context1 = ndlp;
@@ -8507,7 +8507,7 @@ lpfc_els_rsp_rpl_acc(struct lpfc_vport *vport, uint16_t cmdsize,
 			 elsiocb->iotag, elsiocb->iocb.ulpContext,
 			 ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
 			 ndlp->nlp_rpi);
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_rsp;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
 	phba->fc_stat.elsXmitACC++;
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
 	if (!elsiocb->context1) {
@@ -8947,7 +8947,7 @@ lpfc_els_timeout_handler(struct lpfc_vport *vport)
 	list_for_each_entry_safe(piocb, tmp_iocb, &pring->txcmplq, list) {
 		cmd = &piocb->iocb;
 
-		if ((piocb->cmd_flag & LPFC_IO_LIBDFC) != 0 ||
+		if ((piocb->iocb_flag & LPFC_IO_LIBDFC) != 0 ||
 		    piocb->iocb.ulpCommand == CMD_ABORT_XRI_CN ||
 		    piocb->iocb.ulpCommand == CMD_CLOSE_XRI_CN)
 			continue;
@@ -9060,13 +9060,13 @@ lpfc_els_flush_cmd(struct lpfc_vport *vport)
 
 	/* First we need to issue aborts to outstanding cmds on txcmpl */
 	list_for_each_entry_safe(piocb, tmp_iocb, &pring->txcmplq, list) {
-		if (piocb->cmd_flag & LPFC_IO_LIBDFC)
+		if (piocb->iocb_flag & LPFC_IO_LIBDFC)
 			continue;
 
 		if (piocb->vport != vport)
 			continue;
 
-		if (piocb->cmd_flag & LPFC_DRIVER_ABORTED)
+		if (piocb->iocb_flag & LPFC_DRIVER_ABORTED)
 			continue;
 
 		/* On the ELS ring we can have ELS_REQUESTs or
@@ -9084,7 +9084,7 @@ lpfc_els_flush_cmd(struct lpfc_vport *vport)
 			 * and avoid any retry logic.
 			 */
 			if (phba->link_state == LPFC_LINK_DOWN)
-				piocb->cmd_cmpl = lpfc_cmpl_els_link_down;
+				piocb->iocb_cmpl = lpfc_cmpl_els_link_down;
 		}
 		if (cmd->ulpCommand == CMD_GEN_REQUEST64_CR)
 			list_add_tail(&piocb->dlist, &abort_list);
@@ -9119,8 +9119,9 @@ lpfc_els_flush_cmd(struct lpfc_vport *vport)
 	list_for_each_entry_safe(piocb, tmp_iocb, &pring->txq, list) {
 		cmd = &piocb->iocb;
 
-		if (piocb->cmd_flag & LPFC_IO_LIBDFC)
+		if (piocb->iocb_flag & LPFC_IO_LIBDFC) {
 			continue;
+		}
 
 		/* Do not flush out the QUE_RING and ABORT/CLOSE iocbs */
 		if (cmd->ulpCommand == CMD_QUE_RING_BUF_CN ||
@@ -9765,7 +9766,7 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	payload_len = elsiocb->iocb.unsli3.rcvsli3.acc_len;
 	cmd = *payload;
 	if ((phba->sli3_options & LPFC_SLI3_HBQ_ENABLED) == 0)
-		lpfc_sli3_post_buffer(phba, pring, 1);
+		lpfc_post_buffer(phba, pring, 1);
 
 	did = icmd->un.rcvels.remoteID;
 	if (icmd->ulpStatus) {
@@ -10238,7 +10239,7 @@ lpfc_els_unsol_event(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		phba->fc_stat.NoRcvBuf++;
 		/* Not enough posted buffers; Try posting more buffers */
 		if (!(phba->sli3_options & LPFC_SLI3_HBQ_ENABLED))
-			lpfc_sli3_post_buffer(phba, pring, 0);
+			lpfc_post_buffer(phba, pring, 0);
 		return;
 	}
 
@@ -10874,7 +10875,7 @@ lpfc_issue_els_fdisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	lpfc_set_disctmo(vport);
 
 	phba->fc_stat.elsXmitFDISC++;
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_fdisc;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_fdisc;
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 		"Issue FDISC:     did:x%x",
@@ -10998,7 +10999,7 @@ lpfc_issue_els_npiv_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 		"Issue LOGO npiv  did:x%x flg:x%x",
 		ndlp->nlp_DID, ndlp->nlp_flag, 0);
 
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_npiv_logo;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_npiv_logo;
 	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag |= NLP_LOGO_SND;
 	spin_unlock_irq(&ndlp->lock);
@@ -11083,9 +11084,9 @@ lpfc_resume_fabric_iocbs(struct lpfc_hba *phba)
 	}
 	spin_unlock_irqrestore(&phba->hbalock, iflags);
 	if (iocb) {
-		iocb->fabric_cmd_cmpl = iocb->cmd_cmpl;
-		iocb->cmd_cmpl = lpfc_cmpl_fabric_iocb;
-		iocb->cmd_flag |= LPFC_IO_FABRIC;
+		iocb->fabric_iocb_cmpl = iocb->iocb_cmpl;
+		iocb->iocb_cmpl = lpfc_cmpl_fabric_iocb;
+		iocb->iocb_flag |= LPFC_IO_FABRIC;
 
 		lpfc_debugfs_disc_trc(iocb->vport, LPFC_DISC_TRC_ELS_CMD,
 			"Fabric sched1:   ste:x%x",
@@ -11094,13 +11095,13 @@ lpfc_resume_fabric_iocbs(struct lpfc_hba *phba)
 		ret = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, iocb, 0);
 
 		if (ret == IOCB_ERROR) {
-			iocb->cmd_cmpl = iocb->fabric_cmd_cmpl;
-			iocb->fabric_cmd_cmpl = NULL;
-			iocb->cmd_flag &= ~LPFC_IO_FABRIC;
+			iocb->iocb_cmpl = iocb->fabric_iocb_cmpl;
+			iocb->fabric_iocb_cmpl = NULL;
+			iocb->iocb_flag &= ~LPFC_IO_FABRIC;
 			cmd = &iocb->iocb;
 			cmd->ulpStatus = IOSTAT_LOCAL_REJECT;
 			cmd->un.ulpWord[4] = IOERR_SLI_ABORTED;
-			iocb->cmd_cmpl(phba, iocb, iocb);
+			iocb->iocb_cmpl(phba, iocb, iocb);
 
 			atomic_dec(&phba->fabric_iocb_count);
 			goto repeat;
@@ -11156,8 +11157,8 @@ lpfc_block_fabric_iocbs(struct lpfc_hba *phba)
  * @rspiocb: pointer to lpfc response iocb data structure.
  *
  * This routine is the callback function that is put to the fabric iocb's
- * callback function pointer (iocb->cmd_cmpl). The original iocb's callback
- * function pointer has been stored in iocb->fabric_cmd_cmpl. This callback
+ * callback function pointer (iocb->iocb_cmpl). The original iocb's callback
+ * function pointer has been stored in iocb->fabric_iocb_cmpl. This callback
  * function first restores and invokes the original iocb's callback function
  * and then invokes the lpfc_resume_fabric_iocbs() routine to issue the next
  * fabric bound iocb from the driver internal fabric iocb list onto the wire.
@@ -11168,7 +11169,7 @@ lpfc_cmpl_fabric_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 {
 	struct ls_rjt stat;
 
-	WARN_ON((cmdiocb->cmd_flag & LPFC_IO_FABRIC) != LPFC_IO_FABRIC);
+	BUG_ON((cmdiocb->iocb_flag & LPFC_IO_FABRIC) != LPFC_IO_FABRIC);
 
 	switch (rspiocb->iocb.ulpStatus) {
 		case IOSTAT_NPORT_RJT:
@@ -11194,10 +11195,10 @@ lpfc_cmpl_fabric_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 
 	BUG_ON(atomic_read(&phba->fabric_iocb_count) == 0);
 
-	cmdiocb->cmd_cmpl = cmdiocb->fabric_cmd_cmpl;
-	cmdiocb->fabric_cmd_cmpl = NULL;
-	cmdiocb->cmd_flag &= ~LPFC_IO_FABRIC;
-	cmdiocb->cmd_cmpl(phba, cmdiocb, rspiocb);
+	cmdiocb->iocb_cmpl = cmdiocb->fabric_iocb_cmpl;
+	cmdiocb->fabric_iocb_cmpl = NULL;
+	cmdiocb->iocb_flag &= ~LPFC_IO_FABRIC;
+	cmdiocb->iocb_cmpl(phba, cmdiocb, rspiocb);
 
 	atomic_dec(&phba->fabric_iocb_count);
 	if (!test_bit(FABRIC_COMANDS_BLOCKED, &phba->bit_flags)) {
@@ -11248,9 +11249,9 @@ lpfc_issue_fabric_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *iocb)
 		atomic_inc(&phba->fabric_iocb_count);
 	spin_unlock_irqrestore(&phba->hbalock, iflags);
 	if (ready) {
-		iocb->fabric_cmd_cmpl = iocb->cmd_cmpl;
-		iocb->cmd_cmpl = lpfc_cmpl_fabric_iocb;
-		iocb->cmd_flag |= LPFC_IO_FABRIC;
+		iocb->fabric_iocb_cmpl = iocb->iocb_cmpl;
+		iocb->iocb_cmpl = lpfc_cmpl_fabric_iocb;
+		iocb->iocb_flag |= LPFC_IO_FABRIC;
 
 		lpfc_debugfs_disc_trc(iocb->vport, LPFC_DISC_TRC_ELS_CMD,
 			"Fabric sched2:   ste:x%x",
@@ -11259,9 +11260,9 @@ lpfc_issue_fabric_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *iocb)
 		ret = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, iocb, 0);
 
 		if (ret == IOCB_ERROR) {
-			iocb->cmd_cmpl = iocb->fabric_cmd_cmpl;
-			iocb->fabric_cmd_cmpl = NULL;
-			iocb->cmd_flag &= ~LPFC_IO_FABRIC;
+			iocb->iocb_cmpl = iocb->fabric_iocb_cmpl;
+			iocb->fabric_iocb_cmpl = NULL;
+			iocb->iocb_flag &= ~LPFC_IO_FABRIC;
 			atomic_dec(&phba->fabric_iocb_count);
 		}
 	} else {
@@ -11654,7 +11655,7 @@ int lpfc_issue_els_qfpa(struct lpfc_vport *vport)
 	*((u32 *)(pcmd)) = ELS_CMD_QFPA;
 	pcmd += 4;
 
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_qfpa;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_qfpa;
 
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
 	if (!elsiocb->context1) {
@@ -11737,7 +11738,7 @@ lpfc_vmid_uvem(struct lpfc_vport *vport,
 	}
 	inst_desc->word6 = cpu_to_be32(inst_desc->word6);
 
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_uvem;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_uvem;
 
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
 	if (!elsiocb->context1) {
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 4be734b0da0f..6923e0c099e7 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -982,7 +982,7 @@ lpfc_hba_clean_txcmplq(struct lpfc_hba *phba)
 		spin_lock_irq(&pring->ring_lock);
 		list_for_each_entry_safe(piocb, next_iocb,
 					 &pring->txcmplq, list)
-			piocb->cmd_flag &= ~LPFC_IO_ON_TXCMPLQ;
+			piocb->iocb_flag &= ~LPFC_IO_ON_TXCMPLQ;
 		list_splice_init(&pring->txcmplq, &completions);
 		pring->txcmplq_cnt = 0;
 		spin_unlock_irq(&pring->ring_lock);
@@ -2643,7 +2643,7 @@ lpfc_get_hba_model_desc(struct lpfc_hba *phba, uint8_t *mdp, uint8_t *descp)
 }
 
 /**
- * lpfc_sli3_post_buffer - Post IOCB(s) with DMA buffer descriptor(s) to a IOCB ring
+ * lpfc_post_buffer - Post IOCB(s) with DMA buffer descriptor(s) to a IOCB ring
  * @phba: pointer to lpfc hba data structure.
  * @pring: pointer to a IOCB ring.
  * @cnt: the number of IOCBs to be posted to the IOCB ring.
@@ -2655,7 +2655,7 @@ lpfc_get_hba_model_desc(struct lpfc_hba *phba, uint8_t *mdp, uint8_t *descp)
  *   The number of IOCBs NOT able to be posted to the IOCB ring.
  **/
 int
-lpfc_sli3_post_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring, int cnt)
+lpfc_post_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring, int cnt)
 {
 	IOCB_t *icmd;
 	struct lpfc_iocbq *iocb;
@@ -2761,7 +2761,7 @@ lpfc_post_rcv_buf(struct lpfc_hba *phba)
 	struct lpfc_sli *psli = &phba->sli;
 
 	/* Ring 0, ELS / CT buffers */
-	lpfc_sli3_post_buffer(phba, &psli->sli3_ring[LPFC_ELS_RING], LPFC_BUF_RING0);
+	lpfc_post_buffer(phba, &psli->sli3_ring[LPFC_ELS_RING], LPFC_BUF_RING0);
 	/* Ring 2 - FCP no buffers needed */
 
 	return 0;
@@ -4215,7 +4215,8 @@ lpfc_io_buf_replenish(struct lpfc_hba *phba, struct list_head *cbuf)
 			qp = &phba->sli4_hba.hdwq[idx];
 			lpfc_cmd->hdwq_no = idx;
 			lpfc_cmd->hdwq = qp;
-			lpfc_cmd->cur_iocbq.cmd_cmpl = NULL;
+			lpfc_cmd->cur_iocbq.wqe_cmpl = NULL;
+			lpfc_cmd->cur_iocbq.iocb_cmpl = NULL;
 			spin_lock(&qp->io_buf_list_put_lock);
 			list_add_tail(&lpfc_cmd->list,
 				      &qp->lpfc_io_buf_list_put);
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index e788610bc996..2bd35a7424c2 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -2139,9 +2139,9 @@ lpfc_cmpl_prli_prli_issue(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	npr = NULL;
 	nvpr = NULL;
 	temp_ptr = lpfc_check_elscmpl_iocb(phba, cmdiocb, rspiocb);
-	if (cmdiocb->cmd_flag & LPFC_PRLI_FCP_REQ)
+	if (cmdiocb->iocb_flag & LPFC_PRLI_FCP_REQ)
 		npr = (PRLI *) temp_ptr;
-	else if (cmdiocb->cmd_flag & LPFC_PRLI_NVME_REQ)
+	else if (cmdiocb->iocb_flag & LPFC_PRLI_NVME_REQ)
 		nvpr = (struct lpfc_nvme_prli *) temp_ptr;
 
 	irsp = &rspiocb->iocb;
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index c74b2187dbad..4e0c0b273e5f 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -352,12 +352,11 @@ __lpfc_nvme_ls_req_cmp(struct lpfc_hba *phba,  struct lpfc_vport *vport,
 
 static void
 lpfc_nvme_ls_req_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
-		     struct lpfc_iocbq *rspwqe)
+		       struct lpfc_wcqe_complete *wcqe)
 {
 	struct lpfc_vport *vport = cmdwqe->vport;
 	struct lpfc_nvme_lport *lport;
 	uint32_t status;
-	struct lpfc_wcqe_complete *wcqe = &rspwqe->wcqe_cmpl;
 
 	status = bf_get(lpfc_wcqe_c_status, wcqe) & LPFC_IOCB_STATUS_MASK;
 
@@ -381,7 +380,7 @@ lpfc_nvme_gen_req(struct lpfc_vport *vport, struct lpfc_dmabuf *bmp,
 		  struct lpfc_dmabuf *inp,
 		  struct nvmefc_ls_req *pnvme_lsreq,
 		  void (*cmpl)(struct lpfc_hba *, struct lpfc_iocbq *,
-			       struct lpfc_iocbq *),
+			       struct lpfc_wcqe_complete *),
 		  struct lpfc_nodelist *ndlp, uint32_t num_entry,
 		  uint32_t tmo, uint8_t retry)
 {
@@ -402,7 +401,7 @@ lpfc_nvme_gen_req(struct lpfc_vport *vport, struct lpfc_dmabuf *bmp,
 	memset(wqe, 0, sizeof(union lpfc_wqe));
 
 	genwqe->context3 = (uint8_t *)bmp;
-	genwqe->cmd_flag |= LPFC_IO_NVME_LS;
+	genwqe->iocb_flag |= LPFC_IO_NVME_LS;
 
 	/* Save for completion so we can release these resources */
 	genwqe->context1 = lpfc_nlp_get(ndlp);
@@ -433,7 +432,7 @@ lpfc_nvme_gen_req(struct lpfc_vport *vport, struct lpfc_dmabuf *bmp,
 			first_len = xmit_len;
 	}
 
-	genwqe->num_bdes = num_entry;
+	genwqe->rsvd2 = num_entry;
 	genwqe->hba_wqidx = 0;
 
 	/* Words 0 - 2 */
@@ -484,7 +483,8 @@ lpfc_nvme_gen_req(struct lpfc_vport *vport, struct lpfc_dmabuf *bmp,
 
 
 	/* Issue GEN REQ WQE for NPORT <did> */
-	genwqe->cmd_cmpl = cmpl;
+	genwqe->wqe_cmpl = cmpl;
+	genwqe->iocb_cmpl = NULL;
 	genwqe->drvrTimeout = tmo + LPFC_DRVR_TIMEOUT;
 	genwqe->vport = vport;
 	genwqe->retry = retry;
@@ -534,7 +534,7 @@ __lpfc_nvme_ls_req(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		      struct nvmefc_ls_req *pnvme_lsreq,
 		      void (*gen_req_cmp)(struct lpfc_hba *phba,
 				struct lpfc_iocbq *cmdwqe,
-				struct lpfc_iocbq *rspwqe))
+				struct lpfc_wcqe_complete *wcqe))
 {
 	struct lpfc_dmabuf *bmp;
 	struct ulp_bde64 *bpl;
@@ -722,7 +722,7 @@ __lpfc_nvme_ls_abort(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	spin_lock(&pring->ring_lock);
 	list_for_each_entry_safe(wqe, next_wqe, &pring->txcmplq, list) {
 		if (wqe->context2 == pnvme_lsreq) {
-			wqe->cmd_flag |= LPFC_DRIVER_ABORTED;
+			wqe->iocb_flag |= LPFC_DRIVER_ABORTED;
 			foundit = true;
 			break;
 		}
@@ -906,7 +906,7 @@ lpfc_nvme_adj_fcp_sgls(struct lpfc_vport *vport,
 
 
 /*
- * lpfc_nvme_io_cmd_cmpl - Complete an NVME-over-FCP IO
+ * lpfc_nvme_io_cmd_wqe_cmpl - Complete an NVME-over-FCP IO
  *
  * Driver registers this routine as it io request handler.  This
  * routine issues an fcp WQE with data from the @lpfc_nvme_fcpreq
@@ -917,12 +917,11 @@ lpfc_nvme_adj_fcp_sgls(struct lpfc_vport *vport,
  *   TODO: What are the failure codes.
  **/
 static void
-lpfc_nvme_io_cmd_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
-		      struct lpfc_iocbq *pwqeOut)
+lpfc_nvme_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
+			  struct lpfc_wcqe_complete *wcqe)
 {
 	struct lpfc_io_buf *lpfc_ncmd =
 		(struct lpfc_io_buf *)pwqeIn->context1;
-	struct lpfc_wcqe_complete *wcqe = &pwqeOut->wcqe_cmpl;
 	struct lpfc_vport *vport = pwqeIn->vport;
 	struct nvmefc_fcp_req *nCmd;
 	struct nvme_fc_ersp_iu *ep;
@@ -1874,7 +1873,7 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
 	}
 
 	/* Don't abort IOs no longer on the pending queue. */
-	if (!(nvmereq_wqe->cmd_flag & LPFC_IO_ON_TXCMPLQ)) {
+	if (!(nvmereq_wqe->iocb_flag & LPFC_IO_ON_TXCMPLQ)) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 				 "6142 NVME IO req x%px not queued - skipping "
 				 "abort req xri x%x\n",
@@ -1888,7 +1887,7 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
 			 nvmereq_wqe->hba_wqidx, pnvme_rport->port_id);
 
 	/* Outstanding abort is in progress */
-	if (nvmereq_wqe->cmd_flag & LPFC_DRIVER_ABORTED) {
+	if (nvmereq_wqe->iocb_flag & LPFC_DRIVER_ABORTED) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 				 "6144 Outstanding NVME I/O Abort Request "
 				 "still pending on nvme_fcreq x%px, "
@@ -1983,8 +1982,8 @@ lpfc_get_nvme_buf(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
 		/* Setup key fields in buffer that may have been changed
 		 * if other protocols used this buffer.
 		 */
-		pwqeq->cmd_flag = LPFC_IO_NVME;
-		pwqeq->cmd_cmpl = lpfc_nvme_io_cmd_cmpl;
+		pwqeq->iocb_flag = LPFC_IO_NVME;
+		pwqeq->wqe_cmpl = lpfc_nvme_io_cmd_wqe_cmpl;
 		lpfc_ncmd->start_time = jiffies;
 		lpfc_ncmd->flags = 0;
 
@@ -2750,7 +2749,6 @@ lpfc_nvme_cancel_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 	if (phba->sli.sli_flag & LPFC_SLI_ACTIVE)
 		bf_set(lpfc_wcqe_c_xb, wcqep, 1);
 
-	memcpy(&pwqeIn->wcqe_cmpl, wcqep, sizeof(*wcqep));
-	(pwqeIn->cmd_cmpl)(phba, pwqeIn, pwqeIn);
+	(pwqeIn->wqe_cmpl)(phba, pwqeIn, wcqep);
 #endif
 }
diff --git a/drivers/scsi/lpfc/lpfc_nvme.h b/drivers/scsi/lpfc/lpfc_nvme.h
index d7698977725e..cc54ffb5c205 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.h
+++ b/drivers/scsi/lpfc/lpfc_nvme.h
@@ -234,7 +234,7 @@ int __lpfc_nvme_ls_req(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		struct nvmefc_ls_req *pnvme_lsreq,
 		void (*gen_req_cmp)(struct lpfc_hba *phba,
 				struct lpfc_iocbq *cmdwqe,
-				struct lpfc_iocbq *rspwqe));
+				struct lpfc_wcqe_complete *wcqe));
 void __lpfc_nvme_ls_req_cmp(struct lpfc_hba *phba,  struct lpfc_vport *vport,
 		struct lpfc_iocbq *cmdwqe, struct lpfc_wcqe_complete *wcqe);
 int __lpfc_nvme_ls_abort(struct lpfc_vport *vport,
@@ -248,6 +248,6 @@ int __lpfc_nvme_xmt_ls_rsp(struct lpfc_async_xchg_ctx *axchg,
 			struct nvmefc_ls_rsp *ls_rsp,
 			void (*xmt_ls_rsp_cmp)(struct lpfc_hba *phba,
 				struct lpfc_iocbq *cmdwqe,
-				struct lpfc_iocbq *rspwqe));
+				struct lpfc_wcqe_complete *wcqe));
 void __lpfc_nvme_xmt_ls_rsp_cmp(struct lpfc_hba *phba,
-		struct lpfc_iocbq *cmdwqe, struct lpfc_iocbq *rspwqe);
+		struct lpfc_iocbq *cmdwqe, struct lpfc_wcqe_complete *wcqe);
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 5188cc8e2413..6e3dd0b9bcfa 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -285,7 +285,7 @@ lpfc_nvmet_defer_release(struct lpfc_hba *phba,
  *         transmission of an NVME LS response.
  * @phba: Pointer to HBA context object.
  * @cmdwqe: Pointer to driver command WQE object.
- * @rspwqe: Pointer to driver response WQE object.
+ * @wcqe: Pointer to driver response CQE object.
  *
  * The function is called from SLI ring event handler with no
  * lock held. The function frees memory resources used for the command
@@ -293,10 +293,9 @@ lpfc_nvmet_defer_release(struct lpfc_hba *phba,
  **/
 void
 __lpfc_nvme_xmt_ls_rsp_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
-			   struct lpfc_iocbq *rspwqe)
+			   struct lpfc_wcqe_complete *wcqe)
 {
 	struct lpfc_async_xchg_ctx *axchg = cmdwqe->context2;
-	struct lpfc_wcqe_complete *wcqe = &rspwqe->wcqe_cmpl;
 	struct nvmefc_ls_rsp *ls_rsp = &axchg->ls_rsp;
 	uint32_t status, result;
 
@@ -332,7 +331,7 @@ __lpfc_nvme_xmt_ls_rsp_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
  * lpfc_nvmet_xmt_ls_rsp_cmp - Completion handler for LS Response
  * @phba: Pointer to HBA context object.
  * @cmdwqe: Pointer to driver command WQE object.
- * @rspwqe: Pointer to driver response WQE object.
+ * @wcqe: Pointer to driver response CQE object.
  *
  * The function is called from SLI ring event handler with no
  * lock held. This function is the completion handler for NVME LS commands
@@ -341,11 +340,10 @@ __lpfc_nvme_xmt_ls_rsp_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
  **/
 static void
 lpfc_nvmet_xmt_ls_rsp_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
-			  struct lpfc_iocbq *rspwqe)
+			  struct lpfc_wcqe_complete *wcqe)
 {
 	struct lpfc_nvmet_tgtport *tgtp;
 	uint32_t status, result;
-	struct lpfc_wcqe_complete *wcqe = &rspwqe->wcqe_cmpl;
 
 	if (!phba->targetport)
 		goto finish;
@@ -367,7 +365,7 @@ lpfc_nvmet_xmt_ls_rsp_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 	}
 
 finish:
-	__lpfc_nvme_xmt_ls_rsp_cmp(phba, cmdwqe, rspwqe);
+	__lpfc_nvme_xmt_ls_rsp_cmp(phba, cmdwqe, wcqe);
 }
 
 /**
@@ -709,7 +707,7 @@ lpfc_nvmet_ktime(struct lpfc_hba *phba,
  * lpfc_nvmet_xmt_fcp_op_cmp - Completion handler for FCP Response
  * @phba: Pointer to HBA context object.
  * @cmdwqe: Pointer to driver command WQE object.
- * @rspwqe: Pointer to driver response WQE object.
+ * @wcqe: Pointer to driver response CQE object.
  *
  * The function is called from SLI ring event handler with no
  * lock held. This function is the completion handler for NVME FCP commands
@@ -717,13 +715,12 @@ lpfc_nvmet_ktime(struct lpfc_hba *phba,
  **/
 static void
 lpfc_nvmet_xmt_fcp_op_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
-			  struct lpfc_iocbq *rspwqe)
+			  struct lpfc_wcqe_complete *wcqe)
 {
 	struct lpfc_nvmet_tgtport *tgtp;
 	struct nvmefc_tgt_fcp_req *rsp;
 	struct lpfc_async_xchg_ctx *ctxp;
 	uint32_t status, result, op, start_clean, logerr;
-	struct lpfc_wcqe_complete *wcqe = &rspwqe->wcqe_cmpl;
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	int id;
 #endif
@@ -820,7 +817,7 @@ lpfc_nvmet_xmt_fcp_op_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 		/* lpfc_nvmet_xmt_fcp_release() will recycle the context */
 	} else {
 		ctxp->entry_cnt++;
-		start_clean = offsetof(struct lpfc_iocbq, cmd_flag);
+		start_clean = offsetof(struct lpfc_iocbq, iocb_flag);
 		memset(((char *)cmdwqe) + start_clean, 0,
 		       (sizeof(struct lpfc_iocbq) - start_clean));
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
@@ -865,7 +862,7 @@ __lpfc_nvme_xmt_ls_rsp(struct lpfc_async_xchg_ctx *axchg,
 			struct nvmefc_ls_rsp *ls_rsp,
 			void (*xmt_ls_rsp_cmp)(struct lpfc_hba *phba,
 				struct lpfc_iocbq *cmdwqe,
-				struct lpfc_iocbq *rspwqe))
+				struct lpfc_wcqe_complete *wcqe))
 {
 	struct lpfc_hba *phba = axchg->phba;
 	struct hbq_dmabuf *nvmebuf = (struct hbq_dmabuf *)axchg->rqb_buffer;
@@ -901,7 +898,7 @@ __lpfc_nvme_xmt_ls_rsp(struct lpfc_async_xchg_ctx *axchg,
 	}
 
 	/* Save numBdes for bpl2sgl */
-	nvmewqeq->num_bdes = 1;
+	nvmewqeq->rsvd2 = 1;
 	nvmewqeq->hba_wqidx = 0;
 	nvmewqeq->context3 = &dmabuf;
 	dmabuf.virt = &bpl;
@@ -916,7 +913,8 @@ __lpfc_nvme_xmt_ls_rsp(struct lpfc_async_xchg_ctx *axchg,
 	 * be referenced after it returns back to this routine.
 	 */
 
-	nvmewqeq->cmd_cmpl = xmt_ls_rsp_cmp;
+	nvmewqeq->wqe_cmpl = xmt_ls_rsp_cmp;
+	nvmewqeq->iocb_cmpl = NULL;
 	nvmewqeq->context2 = axchg;
 
 	lpfc_nvmeio_data(phba, "NVMEx LS RSP: xri x%x wqidx x%x len x%x\n",
@@ -1074,9 +1072,10 @@ lpfc_nvmet_xmt_fcp_op(struct nvmet_fc_target_port *tgtport,
 		goto aerr;
 	}
 
-	nvmewqeq->cmd_cmpl = lpfc_nvmet_xmt_fcp_op_cmp;
+	nvmewqeq->wqe_cmpl = lpfc_nvmet_xmt_fcp_op_cmp;
+	nvmewqeq->iocb_cmpl = NULL;
 	nvmewqeq->context2 = ctxp;
-	nvmewqeq->cmd_flag |=  LPFC_IO_NVMET;
+	nvmewqeq->iocb_flag |=  LPFC_IO_NVMET;
 	ctxp->wqeq->hba_wqidx = rsp->hwqid;
 
 	lpfc_nvmeio_data(phba, "NVMET FCP CMND: xri x%x op x%x len x%x\n",
@@ -1276,7 +1275,7 @@ lpfc_nvmet_defer_rcv(struct nvmet_fc_target_port *tgtport,
  * lpfc_nvmet_ls_req_cmp - completion handler for a nvme ls request
  * @phba: Pointer to HBA context object
  * @cmdwqe: Pointer to driver command WQE object.
- * @rspwqe: Pointer to driver response WQE object.
+ * @wcqe: Pointer to driver response CQE object.
  *
  * This function is the completion handler for NVME LS requests.
  * The function updates any states and statistics, then calls the
@@ -1284,9 +1283,8 @@ lpfc_nvmet_defer_rcv(struct nvmet_fc_target_port *tgtport,
  **/
 static void
 lpfc_nvmet_ls_req_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
-		      struct lpfc_iocbq *rspwqe)
+		       struct lpfc_wcqe_complete *wcqe)
 {
-	struct lpfc_wcqe_complete *wcqe = &rspwqe->wcqe_cmpl;
 	__lpfc_nvme_ls_req_cmp(phba, cmdwqe->vport, cmdwqe, wcqe);
 }
 
@@ -1583,7 +1581,7 @@ lpfc_nvmet_setup_io_context(struct lpfc_hba *phba)
 					"6406 Ran out of NVMET iocb/WQEs\n");
 			return -ENOMEM;
 		}
-		ctx_buf->iocbq->cmd_flag = LPFC_IO_NVMET;
+		ctx_buf->iocbq->iocb_flag = LPFC_IO_NVMET;
 		nvmewqe = ctx_buf->iocbq;
 		wqe = &nvmewqe->wqe;
 
@@ -2029,10 +2027,8 @@ lpfc_nvmet_wqfull_flush(struct lpfc_hba *phba, struct lpfc_queue *wq,
 				list_del(&nvmewqeq->list);
 				spin_unlock_irqrestore(&pring->ring_lock,
 						       iflags);
-				memcpy(&nvmewqeq->wcqe_cmpl, wcqep,
-				       sizeof(*wcqep));
 				lpfc_nvmet_xmt_fcp_op_cmp(phba, nvmewqeq,
-							  nvmewqeq);
+							  wcqep);
 				return;
 			}
 			continue;
@@ -2040,8 +2036,7 @@ lpfc_nvmet_wqfull_flush(struct lpfc_hba *phba, struct lpfc_queue *wq,
 			/* Flush all IOs */
 			list_del(&nvmewqeq->list);
 			spin_unlock_irqrestore(&pring->ring_lock, iflags);
-			memcpy(&nvmewqeq->wcqe_cmpl, wcqep, sizeof(*wcqep));
-			lpfc_nvmet_xmt_fcp_op_cmp(phba, nvmewqeq, nvmewqeq);
+			lpfc_nvmet_xmt_fcp_op_cmp(phba, nvmewqeq, wcqep);
 			spin_lock_irqsave(&pring->ring_lock, iflags);
 		}
 	}
@@ -2681,7 +2676,7 @@ lpfc_nvmet_prep_ls_wqe(struct lpfc_hba *phba,
 	nvmewqe->retry = 1;
 	nvmewqe->vport = phba->pport;
 	nvmewqe->drvrTimeout = (phba->fc_ratov * 3) + LPFC_DRVR_TIMEOUT;
-	nvmewqe->cmd_flag |= LPFC_IO_NVME_LS;
+	nvmewqe->iocb_flag |= LPFC_IO_NVME_LS;
 
 	/* Xmit NVMET response to remote NPORT <did> */
 	lpfc_printf_log(phba, KERN_INFO, LOG_NVME_DISC,
@@ -3038,7 +3033,7 @@ lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *phba,
  * lpfc_nvmet_sol_fcp_abort_cmp - Completion handler for ABTS
  * @phba: Pointer to HBA context object.
  * @cmdwqe: Pointer to driver command WQE object.
- * @rspwqe: Pointer to driver response WQE object.
+ * @wcqe: Pointer to driver response CQE object.
  *
  * The function is called from SLI ring event handler with no
  * lock held. This function is the completion handler for NVME ABTS for FCP cmds
@@ -3046,14 +3041,13 @@ lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *phba,
  **/
 static void
 lpfc_nvmet_sol_fcp_abort_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
-			     struct lpfc_iocbq *rspwqe)
+			     struct lpfc_wcqe_complete *wcqe)
 {
 	struct lpfc_async_xchg_ctx *ctxp;
 	struct lpfc_nvmet_tgtport *tgtp;
 	uint32_t result;
 	unsigned long flags;
 	bool released = false;
-	struct lpfc_wcqe_complete *wcqe = &rspwqe->wcqe_cmpl;
 
 	ctxp = cmdwqe->context2;
 	result = wcqe->parameter;
@@ -3108,7 +3102,7 @@ lpfc_nvmet_sol_fcp_abort_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
  * lpfc_nvmet_unsol_fcp_abort_cmp - Completion handler for ABTS
  * @phba: Pointer to HBA context object.
  * @cmdwqe: Pointer to driver command WQE object.
- * @rspwqe: Pointer to driver response WQE object.
+ * @wcqe: Pointer to driver response CQE object.
  *
  * The function is called from SLI ring event handler with no
  * lock held. This function is the completion handler for NVME ABTS for FCP cmds
@@ -3116,14 +3110,13 @@ lpfc_nvmet_sol_fcp_abort_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
  **/
 static void
 lpfc_nvmet_unsol_fcp_abort_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
-			       struct lpfc_iocbq *rspwqe)
+			       struct lpfc_wcqe_complete *wcqe)
 {
 	struct lpfc_async_xchg_ctx *ctxp;
 	struct lpfc_nvmet_tgtport *tgtp;
 	unsigned long flags;
 	uint32_t result;
 	bool released = false;
-	struct lpfc_wcqe_complete *wcqe = &rspwqe->wcqe_cmpl;
 
 	ctxp = cmdwqe->context2;
 	result = wcqe->parameter;
@@ -3190,7 +3183,7 @@ lpfc_nvmet_unsol_fcp_abort_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
  * lpfc_nvmet_xmt_ls_abort_cmp - Completion handler for ABTS
  * @phba: Pointer to HBA context object.
  * @cmdwqe: Pointer to driver command WQE object.
- * @rspwqe: Pointer to driver response WQE object.
+ * @wcqe: Pointer to driver response CQE object.
  *
  * The function is called from SLI ring event handler with no
  * lock held. This function is the completion handler for NVME ABTS for LS cmds
@@ -3198,12 +3191,11 @@ lpfc_nvmet_unsol_fcp_abort_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
  **/
 static void
 lpfc_nvmet_xmt_ls_abort_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
-			    struct lpfc_iocbq *rspwqe)
+			    struct lpfc_wcqe_complete *wcqe)
 {
 	struct lpfc_async_xchg_ctx *ctxp;
 	struct lpfc_nvmet_tgtport *tgtp;
 	uint32_t result;
-	struct lpfc_wcqe_complete *wcqe = &rspwqe->wcqe_cmpl;
 
 	ctxp = cmdwqe->context2;
 	result = wcqe->parameter;
@@ -3327,7 +3319,7 @@ lpfc_nvmet_unsol_issue_abort(struct lpfc_hba *phba,
 	abts_wqeq->context1 = ndlp;
 	abts_wqeq->context2 = ctxp;
 	abts_wqeq->context3 = NULL;
-	abts_wqeq->num_bdes = 0;
+	abts_wqeq->rsvd2 = 0;
 	/* hba_wqidx should already be setup from command we are aborting */
 	abts_wqeq->iocb.ulpCommand = CMD_XMIT_SEQUENCE64_CR;
 	abts_wqeq->iocb.ulpLe = 1;
@@ -3456,7 +3448,7 @@ lpfc_nvmet_sol_fcp_issue_abort(struct lpfc_hba *phba,
 	}
 
 	/* Outstanding abort is in progress */
-	if (abts_wqeq->cmd_flag & LPFC_DRIVER_ABORTED) {
+	if (abts_wqeq->iocb_flag & LPFC_DRIVER_ABORTED) {
 		spin_unlock_irqrestore(&phba->hbalock, flags);
 		atomic_inc(&tgtp->xmt_abort_rsp_error);
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
@@ -3471,14 +3463,15 @@ lpfc_nvmet_sol_fcp_issue_abort(struct lpfc_hba *phba,
 	}
 
 	/* Ready - mark outstanding as aborted by driver. */
-	abts_wqeq->cmd_flag |= LPFC_DRIVER_ABORTED;
+	abts_wqeq->iocb_flag |= LPFC_DRIVER_ABORTED;
 
 	lpfc_nvmet_prep_abort_wqe(abts_wqeq, ctxp->wqeq->sli4_xritag, opt);
 
 	/* ABTS WQE must go to the same WQ as the WQE to be aborted */
 	abts_wqeq->hba_wqidx = ctxp->wqeq->hba_wqidx;
-	abts_wqeq->cmd_cmpl = lpfc_nvmet_sol_fcp_abort_cmp;
-	abts_wqeq->cmd_flag |= LPFC_IO_NVME;
+	abts_wqeq->wqe_cmpl = lpfc_nvmet_sol_fcp_abort_cmp;
+	abts_wqeq->iocb_cmpl = NULL;
+	abts_wqeq->iocb_flag |= LPFC_IO_NVME;
 	abts_wqeq->context2 = ctxp;
 	abts_wqeq->vport = phba->pport;
 	if (!ctxp->hdwq)
@@ -3535,8 +3528,9 @@ lpfc_nvmet_unsol_fcp_issue_abort(struct lpfc_hba *phba,
 
 	spin_lock_irqsave(&phba->hbalock, flags);
 	abts_wqeq = ctxp->wqeq;
-	abts_wqeq->cmd_cmpl = lpfc_nvmet_unsol_fcp_abort_cmp;
-	abts_wqeq->cmd_flag |= LPFC_IO_NVMET;
+	abts_wqeq->wqe_cmpl = lpfc_nvmet_unsol_fcp_abort_cmp;
+	abts_wqeq->iocb_cmpl = NULL;
+	abts_wqeq->iocb_flag |= LPFC_IO_NVMET;
 	if (!ctxp->hdwq)
 		ctxp->hdwq = &phba->sli4_hba.hdwq[abts_wqeq->hba_wqidx];
 
@@ -3620,8 +3614,9 @@ lpfc_nvme_unsol_ls_issue_abort(struct lpfc_hba *phba,
 	}
 
 	spin_lock_irqsave(&phba->hbalock, flags);
-	abts_wqeq->cmd_cmpl = lpfc_nvmet_xmt_ls_abort_cmp;
-	abts_wqeq->cmd_flag |=  LPFC_IO_NVME_LS;
+	abts_wqeq->wqe_cmpl = lpfc_nvmet_xmt_ls_abort_cmp;
+	abts_wqeq->iocb_cmpl = NULL;
+	abts_wqeq->iocb_flag |=  LPFC_IO_NVME_LS;
 	rc = lpfc_sli4_issue_wqe(phba, ctxp->hdwq, abts_wqeq);
 	spin_unlock_irqrestore(&phba->hbalock, flags);
 	if (rc == WQE_SUCCESS) {
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 2cfb6d59878b..edae98a35fc3 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -362,7 +362,7 @@ lpfc_new_scsi_buf_s3(struct lpfc_vport *vport, int num_to_alloc)
 			kfree(psb);
 			break;
 		}
-		psb->cur_iocbq.cmd_flag |= LPFC_IO_FCP;
+		psb->cur_iocbq.iocb_flag |= LPFC_IO_FCP;
 
 		psb->fcp_cmnd = psb->data;
 		psb->fcp_rsp = psb->data + sizeof(struct fcp_cmnd);
@@ -468,7 +468,7 @@ lpfc_sli4_vport_delete_fcp_xri_aborted(struct lpfc_vport *vport)
 		spin_lock(&qp->abts_io_buf_list_lock);
 		list_for_each_entry_safe(psb, next_psb,
 					 &qp->lpfc_abts_io_buf_list, list) {
-			if (psb->cur_iocbq.cmd_flag & LPFC_IO_NVME)
+			if (psb->cur_iocbq.iocb_flag & LPFC_IO_NVME)
 				continue;
 
 			if (psb->rdata && psb->rdata->pnode &&
@@ -524,7 +524,7 @@ lpfc_sli4_io_xri_aborted(struct lpfc_hba *phba,
 			list_del_init(&psb->list);
 			psb->flags &= ~LPFC_SBUF_XBUSY;
 			psb->status = IOSTAT_SUCCESS;
-			if (psb->cur_iocbq.cmd_flag & LPFC_IO_NVME) {
+			if (psb->cur_iocbq.iocb_flag & LPFC_IO_NVME) {
 				qp->abts_nvme_io_bufs--;
 				spin_unlock(&qp->abts_io_buf_list_lock);
 				spin_unlock_irqrestore(&phba->hbalock, iflag);
@@ -571,7 +571,7 @@ lpfc_sli4_io_xri_aborted(struct lpfc_hba *phba,
 				 * for command completion wake up the thread.
 				 */
 				spin_lock_irqsave(&psb->buf_lock, iflag);
-				psb->cur_iocbq.cmd_flag &=
+				psb->cur_iocbq.iocb_flag &=
 					~LPFC_DRIVER_ABORTED;
 				if (psb->waitq)
 					wake_up(psb->waitq);
@@ -593,8 +593,8 @@ lpfc_sli4_io_xri_aborted(struct lpfc_hba *phba,
 		for (i = 1; i <= phba->sli.last_iotag; i++) {
 			iocbq = phba->sli.iocbq_lookup[i];
 
-			if (!(iocbq->cmd_flag & LPFC_IO_FCP) ||
-			    (iocbq->cmd_flag & LPFC_IO_LIBDFC))
+			if (!(iocbq->iocb_flag & LPFC_IO_FCP) ||
+			    (iocbq->iocb_flag & LPFC_IO_LIBDFC))
 				continue;
 			if (iocbq->sli4_xritag != xri)
 				continue;
@@ -695,7 +695,7 @@ lpfc_get_scsi_buf_s4(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
 	/* Setup key fields in buffer that may have been changed
 	 * if other protocols used this buffer.
 	 */
-	lpfc_cmd->cur_iocbq.cmd_flag = LPFC_IO_FCP;
+	lpfc_cmd->cur_iocbq.iocb_flag = LPFC_IO_FCP;
 	lpfc_cmd->prot_seg_cnt = 0;
 	lpfc_cmd->seg_cnt = 0;
 	lpfc_cmd->timeout = 0;
@@ -783,7 +783,7 @@ lpfc_release_scsi_buf_s3(struct lpfc_hba *phba, struct lpfc_io_buf *psb)
 
 	spin_lock_irqsave(&phba->scsi_buf_list_put_lock, iflag);
 	psb->pCmd = NULL;
-	psb->cur_iocbq.cmd_flag = LPFC_IO_FCP;
+	psb->cur_iocbq.iocb_flag = LPFC_IO_FCP;
 	list_add_tail(&psb->list, &phba->lpfc_scsi_buf_list_put);
 	spin_unlock_irqrestore(&phba->scsi_buf_list_put_lock, iflag);
 }
@@ -931,7 +931,7 @@ lpfc_scsi_prep_dma_buf_s3(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 			physaddr = sg_dma_address(sgel);
 			if (phba->sli_rev == 3 &&
 			    !(phba->sli3_options & LPFC_SLI3_BG_ENABLED) &&
-			    !(iocbq->cmd_flag & DSS_SECURITY_OP) &&
+			    !(iocbq->iocb_flag & DSS_SECURITY_OP) &&
 			    nseg <= LPFC_EXT_DATA_BDE_COUNT) {
 				data_bde->tus.f.bdeFlags = BUFF_TYPE_BDE_64;
 				data_bde->tus.f.bdeSize = sg_dma_len(sgel);
@@ -959,7 +959,7 @@ lpfc_scsi_prep_dma_buf_s3(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 	 */
 	if (phba->sli_rev == 3 &&
 	    !(phba->sli3_options & LPFC_SLI3_BG_ENABLED) &&
-	    !(iocbq->cmd_flag & DSS_SECURITY_OP)) {
+	    !(iocbq->iocb_flag & DSS_SECURITY_OP)) {
 		if (num_bde > LPFC_EXT_DATA_BDE_COUNT) {
 			/*
 			 * The extended IOCB format can only fit 3 BDE or a BPL.
@@ -3434,7 +3434,7 @@ lpfc_scsi_prep_dma_buf_s4(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 	 */
 	if ((phba->cfg_fof) && ((struct lpfc_device_data *)
 		scsi_cmnd->device->hostdata)->oas_enabled) {
-		lpfc_cmd->cur_iocbq.cmd_flag |= (LPFC_IO_OAS | LPFC_IO_FOF);
+		lpfc_cmd->cur_iocbq.iocb_flag |= (LPFC_IO_OAS | LPFC_IO_FOF);
 		lpfc_cmd->cur_iocbq.priority = ((struct lpfc_device_data *)
 			scsi_cmnd->device->hostdata)->priority;
 
@@ -3591,15 +3591,15 @@ lpfc_bg_scsi_prep_dma_buf_s4(struct lpfc_hba *phba,
 	switch (scsi_get_prot_op(scsi_cmnd)) {
 	case SCSI_PROT_WRITE_STRIP:
 	case SCSI_PROT_READ_STRIP:
-		lpfc_cmd->cur_iocbq.cmd_flag |= LPFC_IO_DIF_STRIP;
+		lpfc_cmd->cur_iocbq.iocb_flag |= LPFC_IO_DIF_STRIP;
 		break;
 	case SCSI_PROT_WRITE_INSERT:
 	case SCSI_PROT_READ_INSERT:
-		lpfc_cmd->cur_iocbq.cmd_flag |= LPFC_IO_DIF_INSERT;
+		lpfc_cmd->cur_iocbq.iocb_flag |= LPFC_IO_DIF_INSERT;
 		break;
 	case SCSI_PROT_WRITE_PASS:
 	case SCSI_PROT_READ_PASS:
-		lpfc_cmd->cur_iocbq.cmd_flag |= LPFC_IO_DIF_PASS;
+		lpfc_cmd->cur_iocbq.iocb_flag |= LPFC_IO_DIF_PASS;
 		break;
 	}
 
@@ -3630,7 +3630,7 @@ lpfc_bg_scsi_prep_dma_buf_s4(struct lpfc_hba *phba,
 	 */
 	if ((phba->cfg_fof) && ((struct lpfc_device_data *)
 		scsi_cmnd->device->hostdata)->oas_enabled) {
-		lpfc_cmd->cur_iocbq.cmd_flag |= (LPFC_IO_OAS | LPFC_IO_FOF);
+		lpfc_cmd->cur_iocbq.iocb_flag |= (LPFC_IO_OAS | LPFC_IO_FOF);
 
 		/* Word 10 */
 		bf_set(wqe_oas, &wqe->generic.wqe_com, 1);
@@ -3640,14 +3640,14 @@ lpfc_bg_scsi_prep_dma_buf_s4(struct lpfc_hba *phba,
 	}
 
 	/* Word 7. DIF Flags */
-	if (lpfc_cmd->cur_iocbq.cmd_flag & LPFC_IO_DIF_PASS)
+	if (lpfc_cmd->cur_iocbq.iocb_flag & LPFC_IO_DIF_PASS)
 		bf_set(wqe_dif, &wqe->generic.wqe_com, LPFC_WQE_DIF_PASSTHRU);
-	else if (lpfc_cmd->cur_iocbq.cmd_flag & LPFC_IO_DIF_STRIP)
+	else if (lpfc_cmd->cur_iocbq.iocb_flag & LPFC_IO_DIF_STRIP)
 		bf_set(wqe_dif, &wqe->generic.wqe_com, LPFC_WQE_DIF_STRIP);
-	else if (lpfc_cmd->cur_iocbq.cmd_flag & LPFC_IO_DIF_INSERT)
+	else if (lpfc_cmd->cur_iocbq.iocb_flag & LPFC_IO_DIF_INSERT)
 		bf_set(wqe_dif, &wqe->generic.wqe_com, LPFC_WQE_DIF_INSERT);
 
-	lpfc_cmd->cur_iocbq.cmd_flag &= ~(LPFC_IO_DIF_PASS |
+	lpfc_cmd->cur_iocbq.iocb_flag &= ~(LPFC_IO_DIF_PASS |
 				 LPFC_IO_DIF_STRIP | LPFC_IO_DIF_INSERT);
 
 	return 0;
@@ -4172,7 +4172,7 @@ lpfc_handle_fcp_err(struct lpfc_vport *vport, struct lpfc_io_buf *lpfc_cmd,
  * lpfc_fcp_io_cmd_wqe_cmpl - Complete a FCP IO
  * @phba: The hba for which this call is being executed.
  * @pwqeIn: The command WQE for the scsi cmnd.
- * @pwqeOut: Pointer to driver response WQE object.
+ * @wcqe: Pointer to driver response CQE object.
  *
  * This routine assigns scsi command result by looking into response WQE
  * status field appropriately. This routine handles QUEUE FULL condition as
@@ -4180,11 +4180,10 @@ lpfc_handle_fcp_err(struct lpfc_vport *vport, struct lpfc_io_buf *lpfc_cmd,
  **/
 static void
 lpfc_fcp_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
-			 struct lpfc_iocbq *pwqeOut)
+			 struct lpfc_wcqe_complete *wcqe)
 {
 	struct lpfc_io_buf *lpfc_cmd =
 		(struct lpfc_io_buf *)pwqeIn->context1;
-	struct lpfc_wcqe_complete *wcqe = &pwqeOut->wcqe_cmpl;
 	struct lpfc_vport *vport = pwqeIn->vport;
 	struct lpfc_rport_data *rdata;
 	struct lpfc_nodelist *ndlp;
@@ -4217,7 +4216,7 @@ lpfc_fcp_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 		 * This needs to be done outside buf_lock
 		 */
 		spin_lock_irqsave(&phba->hbalock, iflags);
-		lpfc_cmd->cur_iocbq.cmd_flag |= LPFC_EXCHANGE_BUSY;
+		lpfc_cmd->cur_iocbq.iocb_flag |= LPFC_EXCHANGE_BUSY;
 		spin_unlock_irqrestore(&phba->hbalock, iflags);
 	}
 
@@ -4508,7 +4507,7 @@ lpfc_fcp_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 	 * wake up the thread.
 	 */
 	spin_lock(&lpfc_cmd->buf_lock);
-	lpfc_cmd->cur_iocbq.cmd_flag &= ~LPFC_DRIVER_ABORTED;
+	lpfc_cmd->cur_iocbq.iocb_flag &= ~LPFC_DRIVER_ABORTED;
 	if (lpfc_cmd->waitq)
 		wake_up(lpfc_cmd->waitq);
 	spin_unlock(&lpfc_cmd->buf_lock);
@@ -4568,7 +4567,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 	lpfc_cmd->status = pIocbOut->iocb.ulpStatus;
 	/* pick up SLI4 exchange busy status from HBA */
 	lpfc_cmd->flags &= ~LPFC_SBUF_XBUSY;
-	if (pIocbOut->cmd_flag & LPFC_EXCHANGE_BUSY)
+	if (pIocbOut->iocb_flag & LPFC_EXCHANGE_BUSY)
 		lpfc_cmd->flags |= LPFC_SBUF_XBUSY;
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
@@ -4777,7 +4776,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 	 * wake up the thread.
 	 */
 	spin_lock(&lpfc_cmd->buf_lock);
-	lpfc_cmd->cur_iocbq.cmd_flag &= ~LPFC_DRIVER_ABORTED;
+	lpfc_cmd->cur_iocbq.iocb_flag &= ~LPFC_DRIVER_ABORTED;
 	if (lpfc_cmd->waitq)
 		wake_up(lpfc_cmd->waitq);
 	spin_unlock(&lpfc_cmd->buf_lock);
@@ -4855,8 +4854,8 @@ static int lpfc_scsi_prep_cmnd_buf_s3(struct lpfc_vport *vport,
 
 	piocbq->iocb.ulpClass = (pnode->nlp_fcp_info & 0x0f);
 	piocbq->context1  = lpfc_cmd;
-	if (!piocbq->cmd_cmpl)
-		piocbq->cmd_cmpl = lpfc_scsi_cmd_iocb_cmpl;
+	if (!piocbq->iocb_cmpl)
+		piocbq->iocb_cmpl = lpfc_scsi_cmd_iocb_cmpl;
 	piocbq->iocb.ulpTimeout = tmo;
 	piocbq->vport = vport;
 	return 0;
@@ -4969,7 +4968,7 @@ static int lpfc_scsi_prep_cmnd_buf_s4(struct lpfc_vport *vport,
 	pwqeq->vport = vport;
 	pwqeq->context1 = lpfc_cmd;
 	pwqeq->hba_wqidx = lpfc_cmd->hdwq_no;
-	pwqeq->cmd_cmpl = lpfc_fcp_io_cmd_wqe_cmpl;
+	pwqeq->wqe_cmpl = lpfc_fcp_io_cmd_wqe_cmpl;
 
 	return 0;
 }
@@ -5691,7 +5690,7 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 	lpfc_cmd->pCmd  = cmnd;
 	lpfc_cmd->rdata = rdata;
 	lpfc_cmd->ndlp = ndlp;
-	lpfc_cmd->cur_iocbq.cmd_cmpl = NULL;
+	lpfc_cmd->cur_iocbq.iocb_cmpl = NULL;
 	cmnd->host_scribble = (unsigned char *)lpfc_cmd;
 
 	err = lpfc_scsi_prep_cmnd(vport, lpfc_cmd, ndlp);
@@ -5748,7 +5747,7 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 				(union lpfc_vmid_io_tag *)
 					&lpfc_cmd->cur_iocbq.vmid_tag);
 			if (!err)
-				lpfc_cmd->cur_iocbq.cmd_flag |= LPFC_IO_VMID;
+				lpfc_cmd->cur_iocbq.iocb_flag |= LPFC_IO_VMID;
 		}
 	}
 
@@ -5935,7 +5934,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 		spin_lock(&pring_s4->ring_lock);
 	}
 	/* the command is in process of being cancelled */
-	if (!(iocb->cmd_flag & LPFC_IO_ON_TXCMPLQ)) {
+	if (!(iocb->iocb_flag & LPFC_IO_ON_TXCMPLQ)) {
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
 			"3169 SCSI Layer abort requested I/O has been "
 			"cancelled by LLD.\n");
@@ -5958,7 +5957,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 	BUG_ON(iocb->context1 != lpfc_cmd);
 
 	/* abort issued in recovery is still in progress */
-	if (iocb->cmd_flag & LPFC_DRIVER_ABORTED) {
+	if (iocb->iocb_flag & LPFC_DRIVER_ABORTED) {
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
 			 "3389 SCSI Layer I/O Abort Request is pending\n");
 		if (phba->sli_rev == LPFC_SLI_REV4)
@@ -5999,7 +5998,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 
 wait_for_cmpl:
 	/*
-	 * cmd_flag is set to LPFC_DRIVER_ABORTED before we wait
+	 * iocb_flag is set to LPFC_DRIVER_ABORTED before we wait
 	 * for abort to complete.
 	 */
 	wait_event_timeout(waitq,
@@ -6187,14 +6186,14 @@ lpfc_send_taskmgmt(struct lpfc_vport *vport, struct scsi_cmnd *cmnd,
 		lpfc_release_scsi_buf(phba, lpfc_cmd);
 		return FAILED;
 	}
-	iocbq->cmd_cmpl = lpfc_tskmgmt_def_cmpl;
+	iocbq->iocb_cmpl = lpfc_tskmgmt_def_cmpl;
 
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
 			 "0702 Issue %s to TGT %d LUN %llu "
 			 "rpi x%x nlp_flag x%x Data: x%x x%x\n",
 			 lpfc_taskmgmt_name(task_mgmt_cmd), tgt_id, lun_id,
 			 pnode->nlp_rpi, pnode->nlp_flag, iocbq->sli4_xritag,
-			 iocbq->cmd_flag);
+			 iocbq->iocb_flag);
 
 	status = lpfc_sli_issue_iocb_wait(phba, LPFC_FCP_RING,
 					  iocbq, iocbqrsp, lpfc_cmd->timeout);
@@ -6204,12 +6203,12 @@ lpfc_send_taskmgmt(struct lpfc_vport *vport, struct scsi_cmnd *cmnd,
 		    iocbqrsp->iocb.ulpStatus != IOSTAT_FCP_RSP_ERROR)
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 					 "0727 TMF %s to TGT %d LUN %llu "
-					 "failed (%d, %d) cmd_flag x%x\n",
+					 "failed (%d, %d) iocb_flag x%x\n",
 					 lpfc_taskmgmt_name(task_mgmt_cmd),
 					 tgt_id, lun_id,
 					 iocbqrsp->iocb.ulpStatus,
 					 iocbqrsp->iocb.un.ulpWord[4],
-					 iocbq->cmd_flag);
+					 iocbq->iocb_flag);
 		/* if ulpStatus != IOCB_SUCCESS, then status == IOCB_SUCCESS */
 		if (status == IOCB_SUCCESS) {
 			if (iocbqrsp->iocb.ulpStatus == IOSTAT_FCP_RSP_ERROR)
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index faca9c68399f..0024c0e0afd3 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1254,21 +1254,21 @@ __lpfc_sli_get_els_sglq(struct lpfc_hba *phba, struct lpfc_iocbq *piocbq)
 	struct lpfc_sli_ring *pring = NULL;
 	int found = 0;
 
-	if (piocbq->cmd_flag & LPFC_IO_NVME_LS)
+	if (piocbq->iocb_flag & LPFC_IO_NVME_LS)
 		pring =  phba->sli4_hba.nvmels_wq->pring;
 	else
 		pring = lpfc_phba_elsring(phba);
 
 	lockdep_assert_held(&pring->ring_lock);
 
-	if (piocbq->cmd_flag &  LPFC_IO_FCP) {
+	if (piocbq->iocb_flag &  LPFC_IO_FCP) {
 		lpfc_cmd = (struct lpfc_io_buf *) piocbq->context1;
 		ndlp = lpfc_cmd->rdata->pnode;
 	} else  if ((piocbq->iocb.ulpCommand == CMD_GEN_REQUEST64_CR) &&
-			!(piocbq->cmd_flag & LPFC_IO_LIBDFC)) {
+			!(piocbq->iocb_flag & LPFC_IO_LIBDFC)) {
 		ndlp = piocbq->context_un.ndlp;
-	} else  if (piocbq->cmd_flag & LPFC_IO_LIBDFC) {
-		if (piocbq->cmd_flag & LPFC_IO_LOOPBACK)
+	} else  if (piocbq->iocb_flag & LPFC_IO_LIBDFC) {
+		if (piocbq->iocb_flag & LPFC_IO_LOOPBACK)
 			ndlp = NULL;
 		else
 			ndlp = piocbq->context_un.ndlp;
@@ -1391,7 +1391,7 @@ __lpfc_sli_release_iocbq_s4(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 
 
 	if (sglq)  {
-		if (iocbq->cmd_flag & LPFC_IO_NVMET) {
+		if (iocbq->iocb_flag & LPFC_IO_NVMET) {
 			spin_lock_irqsave(&phba->sli4_hba.sgl_list_lock,
 					  iflag);
 			sglq->state = SGL_FREED;
@@ -1403,7 +1403,7 @@ __lpfc_sli_release_iocbq_s4(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 			goto out;
 		}
 
-		if ((iocbq->cmd_flag & LPFC_EXCHANGE_BUSY) &&
+		if ((iocbq->iocb_flag & LPFC_EXCHANGE_BUSY) &&
 		    (!(unlikely(pci_channel_offline(phba->pcidev)))) &&
 		    sglq->state != SGL_XRI_ABORTED) {
 			spin_lock_irqsave(&phba->sli4_hba.sgl_list_lock,
@@ -1440,7 +1440,7 @@ __lpfc_sli_release_iocbq_s4(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 	memset((char *)iocbq + start_clean, 0, sizeof(*iocbq) - start_clean);
 	iocbq->sli4_lxritag = NO_XRI;
 	iocbq->sli4_xritag = NO_XRI;
-	iocbq->cmd_flag &= ~(LPFC_IO_NVME | LPFC_IO_NVMET | LPFC_IO_CMF |
+	iocbq->iocb_flag &= ~(LPFC_IO_NVME | LPFC_IO_NVMET | LPFC_IO_CMF |
 			      LPFC_IO_NVME_LS);
 	list_add_tail(&iocbq->list, &phba->lpfc_iocb_list);
 }
@@ -1530,17 +1530,17 @@ lpfc_sli_cancel_iocbs(struct lpfc_hba *phba, struct list_head *iocblist,
 
 	while (!list_empty(iocblist)) {
 		list_remove_head(iocblist, piocb, struct lpfc_iocbq, list);
-		if (piocb->cmd_cmpl) {
-			if (piocb->cmd_flag & LPFC_IO_NVME)
+		if (piocb->wqe_cmpl) {
+			if (piocb->iocb_flag & LPFC_IO_NVME)
 				lpfc_nvme_cancel_iocb(phba, piocb,
 						      ulpstatus, ulpWord4);
 			else
 				lpfc_sli_release_iocbq(phba, piocb);
 
-		} else if (piocb->cmd_cmpl) {
+		} else if (piocb->iocb_cmpl) {
 			piocb->iocb.ulpStatus = ulpstatus;
 			piocb->iocb.un.ulpWord[4] = ulpWord4;
-			(piocb->cmd_cmpl) (phba, piocb, piocb);
+			(piocb->iocb_cmpl) (phba, piocb, piocb);
 		} else {
 			lpfc_sli_release_iocbq(phba, piocb);
 		}
@@ -1732,7 +1732,7 @@ lpfc_sli_ringtxcmpl_put(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	BUG_ON(!piocb);
 
 	list_add_tail(&piocb->list, &pring->txcmplq);
-	piocb->cmd_flag |= LPFC_IO_ON_TXCMPLQ;
+	piocb->iocb_flag |= LPFC_IO_ON_TXCMPLQ;
 	pring->txcmplq_cnt++;
 
 	if ((unlikely(pring->ringno == LPFC_ELS_RING)) &&
@@ -1773,7 +1773,7 @@ lpfc_sli_ringtx_get(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
  * lpfc_cmf_sync_cmpl - Process a CMF_SYNC_WQE cmpl
  * @phba: Pointer to HBA context object.
  * @cmdiocb: Pointer to driver command iocb object.
- * @rspiocb: Pointer to driver response iocb object.
+ * @cmf_cmpl: Pointer to completed WCQE.
  *
  * This routine will inform the driver of any BW adjustments we need
  * to make. These changes will be picked up during the next CMF
@@ -1782,11 +1782,10 @@ lpfc_sli_ringtx_get(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
  **/
 static void
 lpfc_cmf_sync_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
-		   struct lpfc_iocbq *rspiocb)
+		   struct lpfc_wcqe_complete *cmf_cmpl)
 {
 	union lpfc_wqe128 *wqe;
 	uint32_t status, info;
-	struct lpfc_wcqe_complete *wcqe = &rspiocb->wcqe_cmpl;
 	uint64_t bw, bwdif, slop;
 	uint64_t pcent, bwpcent;
 	int asig, afpin, sigcnt, fpincnt;
@@ -1794,22 +1793,22 @@ lpfc_cmf_sync_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	char *s;
 
 	/* First check for error */
-	status = bf_get(lpfc_wcqe_c_status, wcqe);
+	status = bf_get(lpfc_wcqe_c_status, cmf_cmpl);
 	if (status) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_CGN_MGMT,
 				"6211 CMF_SYNC_WQE Error "
 				"req_tag x%x status x%x hwstatus x%x "
 				"tdatap x%x parm x%x\n",
-				bf_get(lpfc_wcqe_c_request_tag, wcqe),
-				bf_get(lpfc_wcqe_c_status, wcqe),
-				bf_get(lpfc_wcqe_c_hw_status, wcqe),
-				wcqe->total_data_placed,
-				wcqe->parameter);
+				bf_get(lpfc_wcqe_c_request_tag, cmf_cmpl),
+				bf_get(lpfc_wcqe_c_status, cmf_cmpl),
+				bf_get(lpfc_wcqe_c_hw_status, cmf_cmpl),
+				cmf_cmpl->total_data_placed,
+				cmf_cmpl->parameter);
 		goto out;
 	}
 
 	/* Gather congestion information on a successful cmpl */
-	info = wcqe->parameter;
+	info = cmf_cmpl->parameter;
 	phba->cmf_active_info = info;
 
 	/* See if firmware info count is valid or has changed */
@@ -1818,15 +1817,15 @@ lpfc_cmf_sync_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	else
 		phba->cmf_info_per_interval = info;
 
-	tdp = bf_get(lpfc_wcqe_c_cmf_bw, wcqe);
-	cg = bf_get(lpfc_wcqe_c_cmf_cg, wcqe);
+	tdp = bf_get(lpfc_wcqe_c_cmf_bw, cmf_cmpl);
+	cg = bf_get(lpfc_wcqe_c_cmf_cg, cmf_cmpl);
 
 	/* Get BW requirement from firmware */
 	bw = (uint64_t)tdp * LPFC_CMF_BLK_SIZE;
 	if (!bw) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_CGN_MGMT,
 				"6212 CMF_SYNC_WQE x%x: NULL bw\n",
-				bf_get(lpfc_wcqe_c_request_tag, wcqe));
+				bf_get(lpfc_wcqe_c_request_tag, cmf_cmpl));
 		goto out;
 	}
 
@@ -2000,13 +1999,14 @@ lpfc_issue_cmf_sync_wqe(struct lpfc_hba *phba, u32 ms, u64 total)
 	bf_set(cmf_sync_cqid, &wqe->cmf_sync, LPFC_WQE_CQ_ID_DEFAULT);
 
 	sync_buf->vport = phba->pport;
-	sync_buf->cmd_cmpl = lpfc_cmf_sync_cmpl;
+	sync_buf->wqe_cmpl = lpfc_cmf_sync_cmpl;
+	sync_buf->iocb_cmpl = NULL;
 	sync_buf->context1 = NULL;
 	sync_buf->context2 = NULL;
 	sync_buf->context3 = NULL;
 	sync_buf->sli4_xritag = NO_XRI;
 
-	sync_buf->cmd_flag |= LPFC_IO_CMF;
+	sync_buf->iocb_flag |= LPFC_IO_CMF;
 	ret_val = lpfc_sli4_issue_wqe(phba, &phba->sli4_hba.hdwq[0], sync_buf);
 	if (ret_val) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_CGN_MGMT,
@@ -2175,7 +2175,7 @@ lpfc_sli_submit_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	/*
 	 * Set up an iotag
 	 */
-	nextiocb->iocb.ulpIoTag = (nextiocb->cmd_cmpl) ? nextiocb->iotag : 0;
+	nextiocb->iocb.ulpIoTag = (nextiocb->iocb_cmpl) ? nextiocb->iotag : 0;
 
 
 	if (pring->ringno == LPFC_ELS_RING) {
@@ -2196,9 +2196,9 @@ lpfc_sli_submit_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	/*
 	 * If there is no completion routine to call, we can release the
 	 * IOCB buffer back right now. For IOCBs, like QUE_RING_BUF,
-	 * that have no rsp ring completion, cmd_cmpl MUST be NULL.
+	 * that have no rsp ring completion, iocb_cmpl MUST be NULL.
 	 */
-	if (nextiocb->cmd_cmpl)
+	if (nextiocb->iocb_cmpl)
 		lpfc_sli_ringtxcmpl_put(phba, pring, nextiocb);
 	else
 		__lpfc_sli_release_iocbq(phba, nextiocb);
@@ -3566,10 +3566,10 @@ lpfc_sli_iocbq_lookup(struct lpfc_hba *phba,
 
 	if (iotag != 0 && iotag <= phba->sli.last_iotag) {
 		cmd_iocb = phba->sli.iocbq_lookup[iotag];
-		if (cmd_iocb->cmd_flag & LPFC_IO_ON_TXCMPLQ) {
+		if (cmd_iocb->iocb_flag & LPFC_IO_ON_TXCMPLQ) {
 			/* remove from txcmpl queue list */
 			list_del_init(&cmd_iocb->list);
-			cmd_iocb->cmd_flag &= ~LPFC_IO_ON_TXCMPLQ;
+			cmd_iocb->iocb_flag &= ~LPFC_IO_ON_TXCMPLQ;
 			pring->txcmplq_cnt--;
 			spin_unlock_irqrestore(temp_lock, iflag);
 			return cmd_iocb;
@@ -3613,10 +3613,10 @@ lpfc_sli_iocbq_lookup_by_tag(struct lpfc_hba *phba,
 	spin_lock_irqsave(temp_lock, iflag);
 	if (iotag != 0 && iotag <= phba->sli.last_iotag) {
 		cmd_iocb = phba->sli.iocbq_lookup[iotag];
-		if (cmd_iocb->cmd_flag & LPFC_IO_ON_TXCMPLQ) {
+		if (cmd_iocb->iocb_flag & LPFC_IO_ON_TXCMPLQ) {
 			/* remove from txcmpl queue list */
 			list_del_init(&cmd_iocb->list);
-			cmd_iocb->cmd_flag &= ~LPFC_IO_ON_TXCMPLQ;
+			cmd_iocb->iocb_flag &= ~LPFC_IO_ON_TXCMPLQ;
 			pring->txcmplq_cnt--;
 			spin_unlock_irqrestore(temp_lock, iflag);
 			return cmd_iocb;
@@ -3626,9 +3626,9 @@ lpfc_sli_iocbq_lookup_by_tag(struct lpfc_hba *phba,
 	spin_unlock_irqrestore(temp_lock, iflag);
 	lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
 			"0372 iotag x%x lookup error: max iotag (x%x) "
-			"cmd_flag x%x\n",
+			"iocb_flag x%x\n",
 			iotag, phba->sli.last_iotag,
-			cmd_iocb ? cmd_iocb->cmd_flag : 0xffff);
+			cmd_iocb ? cmd_iocb->iocb_flag : 0xffff);
 	return NULL;
 }
 
@@ -3659,7 +3659,7 @@ lpfc_sli_process_sol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 
 	cmdiocbp = lpfc_sli_iocbq_lookup(phba, pring, saveq);
 	if (cmdiocbp) {
-		if (cmdiocbp->cmd_cmpl) {
+		if (cmdiocbp->iocb_cmpl) {
 			/*
 			 * If an ELS command failed send an event to mgmt
 			 * application.
@@ -3677,11 +3677,11 @@ lpfc_sli_process_sol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			 */
 			if (pring->ringno == LPFC_ELS_RING) {
 				if ((phba->sli_rev < LPFC_SLI_REV4) &&
-				    (cmdiocbp->cmd_flag &
+				    (cmdiocbp->iocb_flag &
 							LPFC_DRIVER_ABORTED)) {
 					spin_lock_irqsave(&phba->hbalock,
 							  iflag);
-					cmdiocbp->cmd_flag &=
+					cmdiocbp->iocb_flag &=
 						~LPFC_DRIVER_ABORTED;
 					spin_unlock_irqrestore(&phba->hbalock,
 							       iflag);
@@ -3696,12 +3696,12 @@ lpfc_sli_process_sol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 					 */
 					spin_lock_irqsave(&phba->hbalock,
 							  iflag);
-					saveq->cmd_flag |= LPFC_DELAY_MEM_FREE;
+					saveq->iocb_flag |= LPFC_DELAY_MEM_FREE;
 					spin_unlock_irqrestore(&phba->hbalock,
 							       iflag);
 				}
 				if (phba->sli_rev == LPFC_SLI_REV4) {
-					if (saveq->cmd_flag &
+					if (saveq->iocb_flag &
 					    LPFC_EXCHANGE_BUSY) {
 						/* Set cmdiocb flag for the
 						 * exchange busy so sgl (xri)
@@ -3711,12 +3711,12 @@ lpfc_sli_process_sol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 						 */
 						spin_lock_irqsave(
 							&phba->hbalock, iflag);
-						cmdiocbp->cmd_flag |=
+						cmdiocbp->iocb_flag |=
 							LPFC_EXCHANGE_BUSY;
 						spin_unlock_irqrestore(
 							&phba->hbalock, iflag);
 					}
-					if (cmdiocbp->cmd_flag &
+					if (cmdiocbp->iocb_flag &
 					    LPFC_DRIVER_ABORTED) {
 						/*
 						 * Clear LPFC_DRIVER_ABORTED
@@ -3725,7 +3725,7 @@ lpfc_sli_process_sol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 						 */
 						spin_lock_irqsave(
 							&phba->hbalock, iflag);
-						cmdiocbp->cmd_flag &=
+						cmdiocbp->iocb_flag &=
 							~LPFC_DRIVER_ABORTED;
 						spin_unlock_irqrestore(
 							&phba->hbalock, iflag);
@@ -3745,14 +3745,14 @@ lpfc_sli_process_sol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 							IOERR_SLI_ABORTED;
 						spin_lock_irqsave(
 							&phba->hbalock, iflag);
-						saveq->cmd_flag |=
+						saveq->iocb_flag |=
 							LPFC_DELAY_MEM_FREE;
 						spin_unlock_irqrestore(
 							&phba->hbalock, iflag);
 					}
 				}
 			}
-			(cmdiocbp->cmd_cmpl) (phba, cmdiocbp, saveq);
+			(cmdiocbp->iocb_cmpl) (phba, cmdiocbp, saveq);
 		} else
 			lpfc_sli_release_iocbq(phba, cmdiocbp);
 	} else {
@@ -3994,11 +3994,11 @@ lpfc_sli_handle_fast_ring_event(struct lpfc_hba *phba,
 			spin_lock_irqsave(&phba->hbalock, iflag);
 			if (unlikely(!cmdiocbq))
 				break;
-			if (cmdiocbq->cmd_flag & LPFC_DRIVER_ABORTED)
-				cmdiocbq->cmd_flag &= ~LPFC_DRIVER_ABORTED;
-			if (cmdiocbq->cmd_cmpl) {
+			if (cmdiocbq->iocb_flag & LPFC_DRIVER_ABORTED)
+				cmdiocbq->iocb_flag &= ~LPFC_DRIVER_ABORTED;
+			if (cmdiocbq->iocb_cmpl) {
 				spin_unlock_irqrestore(&phba->hbalock, iflag);
-				(cmdiocbq->cmd_cmpl)(phba, cmdiocbq,
+				(cmdiocbq->iocb_cmpl)(phba, cmdiocbq,
 						      &rspiocbq);
 				spin_lock_irqsave(&phba->hbalock, iflag);
 			}
@@ -4193,10 +4193,10 @@ lpfc_sli_sp_handle_rspiocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			}
 			if (cmdiocbp) {
 				/* Call the specified completion routine */
-				if (cmdiocbp->cmd_cmpl) {
+				if (cmdiocbp->iocb_cmpl) {
 					spin_unlock_irqrestore(&phba->hbalock,
 							       iflag);
-					(cmdiocbp->cmd_cmpl)(phba, cmdiocbp,
+					(cmdiocbp->iocb_cmpl)(phba, cmdiocbp,
 							      saveq);
 					spin_lock_irqsave(&phba->hbalock,
 							  iflag);
@@ -4575,7 +4575,7 @@ lpfc_sli_flush_io_rings(struct lpfc_hba *phba)
 			list_splice_init(&pring->txq, &txq);
 			list_for_each_entry_safe(piocb, next_iocb,
 						 &pring->txcmplq, list)
-				piocb->cmd_flag &= ~LPFC_IO_ON_TXCMPLQ;
+				piocb->iocb_flag &= ~LPFC_IO_ON_TXCMPLQ;
 			/* Retrieve everything on the txcmplq */
 			list_splice_init(&pring->txcmplq, &txcmplq);
 			pring->txq_cnt = 0;
@@ -4601,7 +4601,7 @@ lpfc_sli_flush_io_rings(struct lpfc_hba *phba)
 		list_splice_init(&pring->txq, &txq);
 		list_for_each_entry_safe(piocb, next_iocb,
 					 &pring->txcmplq, list)
-			piocb->cmd_flag &= ~LPFC_IO_ON_TXCMPLQ;
+			piocb->iocb_flag &= ~LPFC_IO_ON_TXCMPLQ;
 		/* Retrieve everything on the txcmplq */
 		list_splice_init(&pring->txcmplq, &txcmplq);
 		pring->txq_cnt = 0;
@@ -10117,7 +10117,7 @@ __lpfc_sli_issue_iocb_s3(struct lpfc_hba *phba, uint32_t ring_number,
 
 	lockdep_assert_held(&phba->hbalock);
 
-	if (piocb->cmd_cmpl && (!piocb->vport) &&
+	if (piocb->iocb_cmpl && (!piocb->vport) &&
 	   (piocb->iocb.ulpCommand != CMD_ABORT_XRI_CN) &&
 	   (piocb->iocb.ulpCommand != CMD_CLOSE_XRI_CN)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
@@ -10169,10 +10169,10 @@ __lpfc_sli_issue_iocb_s3(struct lpfc_hba *phba, uint32_t ring_number,
 		case CMD_QUE_RING_BUF64_CN:
 			/*
 			 * For IOCBs, like QUE_RING_BUF, that have no rsp ring
-			 * completion, cmd_cmpl MUST be 0.
+			 * completion, iocb_cmpl MUST be 0.
 			 */
-			if (piocb->cmd_cmpl)
-				piocb->cmd_cmpl = NULL;
+			if (piocb->iocb_cmpl)
+				piocb->iocb_cmpl = NULL;
 			fallthrough;
 		case CMD_CREATE_XRI_CR:
 		case CMD_CLOSE_XRI_CN:
@@ -10363,9 +10363,9 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 
 	fip = phba->hba_flag & HBA_FIP_SUPPORT;
 	/* The fcp commands will set command type */
-	if (iocbq->cmd_flag &  LPFC_IO_FCP)
+	if (iocbq->iocb_flag &  LPFC_IO_FCP)
 		command_type = FCP_COMMAND;
-	else if (fip && (iocbq->cmd_flag & LPFC_FIP_ELS_ID_MASK))
+	else if (fip && (iocbq->iocb_flag & LPFC_FIP_ELS_ID_MASK))
 		command_type = ELS_COMMAND_FIP;
 	else
 		command_type = ELS_COMMAND_NON_FIP;
@@ -10410,7 +10410,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 
 	switch (iocbq->iocb.ulpCommand) {
 	case CMD_ELS_REQUEST64_CR:
-		if (iocbq->cmd_flag & LPFC_IO_LIBDFC)
+		if (iocbq->iocb_flag & LPFC_IO_LIBDFC)
 			ndlp = iocbq->context_un.ndlp;
 		else
 			ndlp = (struct lpfc_nodelist *)iocbq->context1;
@@ -10437,7 +10437,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 		bf_set(wqe_pu, &wqe->els_req.wqe_com, 0);
 		/* CCP CCPE PV PRI in word10 were set in the memcpy */
 		if (command_type == ELS_COMMAND_FIP)
-			els_id = ((iocbq->cmd_flag & LPFC_FIP_ELS_ID_MASK)
+			els_id = ((iocbq->iocb_flag & LPFC_FIP_ELS_ID_MASK)
 					>> LPFC_FIP_ELS_ID_SHIFT);
 		pcmd = (uint32_t *) (((struct lpfc_dmabuf *)
 					iocbq->context2)->virt);
@@ -10539,7 +10539,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 		       LPFC_WQE_LENLOC_WORD4);
 		bf_set(wqe_pu, &wqe->fcp_iwrite.wqe_com, iocbq->iocb.ulpPU);
 		bf_set(wqe_dbde, &wqe->fcp_iwrite.wqe_com, 1);
-		if (iocbq->cmd_flag & LPFC_IO_OAS) {
+		if (iocbq->iocb_flag & LPFC_IO_OAS) {
 			bf_set(wqe_oas, &wqe->fcp_iwrite.wqe_com, 1);
 			bf_set(wqe_ccpe, &wqe->fcp_iwrite.wqe_com, 1);
 			if (iocbq->priority) {
@@ -10603,7 +10603,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 		       LPFC_WQE_LENLOC_WORD4);
 		bf_set(wqe_pu, &wqe->fcp_iread.wqe_com, iocbq->iocb.ulpPU);
 		bf_set(wqe_dbde, &wqe->fcp_iread.wqe_com, 1);
-		if (iocbq->cmd_flag & LPFC_IO_OAS) {
+		if (iocbq->iocb_flag & LPFC_IO_OAS) {
 			bf_set(wqe_oas, &wqe->fcp_iread.wqe_com, 1);
 			bf_set(wqe_ccpe, &wqe->fcp_iread.wqe_com, 1);
 			if (iocbq->priority) {
@@ -10666,7 +10666,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 		       LPFC_WQE_LENLOC_NONE);
 		bf_set(wqe_erp, &wqe->fcp_icmd.wqe_com,
 		       iocbq->iocb.ulpFCP2Rcvy);
-		if (iocbq->cmd_flag & LPFC_IO_OAS) {
+		if (iocbq->iocb_flag & LPFC_IO_OAS) {
 			bf_set(wqe_oas, &wqe->fcp_icmd.wqe_com, 1);
 			bf_set(wqe_ccpe, &wqe->fcp_icmd.wqe_com, 1);
 			if (iocbq->priority) {
@@ -10800,7 +10800,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 		abrt_iotag = iocbq->iocb.un.acxri.abortContextTag;
 		if (abrt_iotag != 0 && abrt_iotag <= phba->sli.last_iotag) {
 			abrtiocbq = phba->sli.iocbq_lookup[abrt_iotag];
-			fip = abrtiocbq->cmd_flag & LPFC_FIP_ELS_ID_MASK;
+			fip = abrtiocbq->iocb_flag & LPFC_FIP_ELS_ID_MASK;
 		} else
 			fip = 0;
 
@@ -10909,13 +10909,13 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 		return IOCB_ERROR;
 	}
 
-	if (iocbq->cmd_flag & LPFC_IO_DIF_PASS)
+	if (iocbq->iocb_flag & LPFC_IO_DIF_PASS)
 		bf_set(wqe_dif, &wqe->generic.wqe_com, LPFC_WQE_DIF_PASSTHRU);
-	else if (iocbq->cmd_flag & LPFC_IO_DIF_STRIP)
+	else if (iocbq->iocb_flag & LPFC_IO_DIF_STRIP)
 		bf_set(wqe_dif, &wqe->generic.wqe_com, LPFC_WQE_DIF_STRIP);
-	else if (iocbq->cmd_flag & LPFC_IO_DIF_INSERT)
+	else if (iocbq->iocb_flag & LPFC_IO_DIF_INSERT)
 		bf_set(wqe_dif, &wqe->generic.wqe_com, LPFC_WQE_DIF_INSERT);
-	iocbq->cmd_flag &= ~(LPFC_IO_DIF_PASS | LPFC_IO_DIF_STRIP |
+	iocbq->iocb_flag &= ~(LPFC_IO_DIF_PASS | LPFC_IO_DIF_STRIP |
 			      LPFC_IO_DIF_INSERT);
 	bf_set(wqe_xri_tag, &wqe->generic.wqe_com, xritag);
 	bf_set(wqe_reqtag, &wqe->generic.wqe_com, iocbq->iotag);
@@ -11014,7 +11014,7 @@ __lpfc_sli_issue_fcp_io_s4(struct lpfc_hba *phba, uint32_t ring_number,
 	}
 
 	/* add the VMID tags as per switch response */
-	if (unlikely(piocb->cmd_flag & LPFC_IO_VMID)) {
+	if (unlikely(piocb->iocb_flag & LPFC_IO_VMID)) {
 		if (phba->pport->vmid_priority_tagging) {
 			bf_set(wqe_ccpe, &wqe->fcp_iwrite.wqe_com, 1);
 			bf_set(wqe_ccp, &wqe->fcp_iwrite.wqe_com,
@@ -11053,8 +11053,8 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba *phba, uint32_t ring_number,
 	struct lpfc_sli_ring *pring;
 
 	/* Get the WQ */
-	if ((piocb->cmd_flag & LPFC_IO_FCP) ||
-	    (piocb->cmd_flag & LPFC_USE_FCPWQIDX)) {
+	if ((piocb->iocb_flag & LPFC_IO_FCP) ||
+	    (piocb->iocb_flag & LPFC_USE_FCPWQIDX)) {
 		wq = phba->sli4_hba.hdwq[piocb->hba_wqidx].io_wq;
 	} else {
 		wq = phba->sli4_hba.els_wq;
@@ -11095,7 +11095,7 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba *phba, uint32_t ring_number,
 				}
 			}
 		}
-	} else if (piocb->cmd_flag &  LPFC_IO_FCP) {
+	} else if (piocb->iocb_flag &  LPFC_IO_FCP) {
 		/* These IO's already have an XRI and a mapped sgl. */
 		sglq = NULL;
 	}
@@ -11212,14 +11212,14 @@ lpfc_sli4_calc_ring(struct lpfc_hba *phba, struct lpfc_iocbq *piocb)
 {
 	struct lpfc_io_buf *lpfc_cmd;
 
-	if (piocb->cmd_flag & (LPFC_IO_FCP | LPFC_USE_FCPWQIDX)) {
+	if (piocb->iocb_flag & (LPFC_IO_FCP | LPFC_USE_FCPWQIDX)) {
 		if (unlikely(!phba->sli4_hba.hdwq))
 			return NULL;
 		/*
 		 * for abort iocb hba_wqidx should already
 		 * be setup based on what work queue we used.
 		 */
-		if (!(piocb->cmd_flag & LPFC_USE_FCPWQIDX)) {
+		if (!(piocb->iocb_flag & LPFC_USE_FCPWQIDX)) {
 			lpfc_cmd = (struct lpfc_io_buf *)piocb->context1;
 			piocb->hba_wqidx = lpfc_cmd->hdwq_no;
 		}
@@ -12361,14 +12361,14 @@ lpfc_sli_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	icmd = &cmdiocb->iocb;
 	if (icmd->ulpCommand == CMD_ABORT_XRI_CN ||
 	    icmd->ulpCommand == CMD_CLOSE_XRI_CN ||
-	    cmdiocb->cmd_flag & LPFC_DRIVER_ABORTED)
+	    cmdiocb->iocb_flag & LPFC_DRIVER_ABORTED)
 		return IOCB_ABORTING;
 
 	if (!pring) {
-		if (cmdiocb->cmd_flag & LPFC_IO_FABRIC)
-			cmdiocb->fabric_cmd_cmpl = lpfc_ignore_els_cmpl;
+		if (cmdiocb->iocb_flag & LPFC_IO_FABRIC)
+			cmdiocb->fabric_iocb_cmpl = lpfc_ignore_els_cmpl;
 		else
-			cmdiocb->cmd_cmpl = lpfc_ignore_els_cmpl;
+			cmdiocb->iocb_cmpl = lpfc_ignore_els_cmpl;
 		return retval;
 	}
 
@@ -12378,10 +12378,10 @@ lpfc_sli_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	 */
 	if ((vport->load_flag & FC_UNLOADING) &&
 	    pring->ringno == LPFC_ELS_RING) {
-		if (cmdiocb->cmd_flag & LPFC_IO_FABRIC)
-			cmdiocb->fabric_cmd_cmpl = lpfc_ignore_els_cmpl;
+		if (cmdiocb->iocb_flag & LPFC_IO_FABRIC)
+			cmdiocb->fabric_iocb_cmpl = lpfc_ignore_els_cmpl;
 		else
-			cmdiocb->cmd_cmpl = lpfc_ignore_els_cmpl;
+			cmdiocb->iocb_cmpl = lpfc_ignore_els_cmpl;
 		return retval;
 	}
 
@@ -12393,7 +12393,7 @@ lpfc_sli_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	/* This signals the response to set the correct status
 	 * before calling the completion handler
 	 */
-	cmdiocb->cmd_flag |= LPFC_DRIVER_ABORTED;
+	cmdiocb->iocb_flag |= LPFC_DRIVER_ABORTED;
 
 	iabt = &abtsiocbp->iocb;
 	iabt->un.acxri.abortType = ABORT_TYPE_ABTS;
@@ -12414,10 +12414,10 @@ lpfc_sli_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 
 	/* ABTS WQE must go to the same WQ as the WQE to be aborted */
 	abtsiocbp->hba_wqidx = cmdiocb->hba_wqidx;
-	if (cmdiocb->cmd_flag & LPFC_IO_FCP)
-		abtsiocbp->cmd_flag |= (LPFC_IO_FCP | LPFC_USE_FCPWQIDX);
-	if (cmdiocb->cmd_flag & LPFC_IO_FOF)
-		abtsiocbp->cmd_flag |= LPFC_IO_FOF;
+	if (cmdiocb->iocb_flag & LPFC_IO_FCP)
+		abtsiocbp->iocb_flag |= (LPFC_IO_FCP | LPFC_USE_FCPWQIDX);
+	if (cmdiocb->iocb_flag & LPFC_IO_FOF)
+		abtsiocbp->iocb_flag |= LPFC_IO_FOF;
 
 	if (phba->link_state < LPFC_LINK_UP ||
 	    (phba->sli_rev == LPFC_SLI_REV4 &&
@@ -12427,9 +12427,9 @@ lpfc_sli_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		iabt->ulpCommand = CMD_ABORT_XRI_CN;
 
 	if (cmpl)
-		abtsiocbp->cmd_cmpl = cmpl;
+		abtsiocbp->iocb_cmpl = cmpl;
 	else
-		abtsiocbp->cmd_cmpl = lpfc_sli_abort_els_cmpl;
+		abtsiocbp->iocb_cmpl = lpfc_sli_abort_els_cmpl;
 	abtsiocbp->vport = vport;
 
 	if (phba->sli_rev == LPFC_SLI_REV4) {
@@ -12456,7 +12456,7 @@ lpfc_sli_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			 abtsiocbp->iotag, retval);
 
 	if (retval) {
-		cmdiocb->cmd_flag &= ~LPFC_DRIVER_ABORTED;
+		cmdiocb->iocb_flag &= ~LPFC_DRIVER_ABORTED;
 		__lpfc_sli_release_iocbq(phba, abtsiocbp);
 	}
 
@@ -12524,9 +12524,9 @@ lpfc_sli_validate_fcp_iocb_for_abort(struct lpfc_iocbq *iocbq,
 	 * can't be premarked as driver aborted, nor be an ABORT iocb itself
 	 */
 	icmd = &iocbq->iocb;
-	if (!(iocbq->cmd_flag & LPFC_IO_FCP) ||
-	    !(iocbq->cmd_flag & LPFC_IO_ON_TXCMPLQ) ||
-	    (iocbq->cmd_flag & LPFC_DRIVER_ABORTED) ||
+	if (!(iocbq->iocb_flag & LPFC_IO_FCP) ||
+	    !(iocbq->iocb_flag & LPFC_IO_ON_TXCMPLQ) ||
+	    (iocbq->iocb_flag & LPFC_DRIVER_ABORTED) ||
 	    (icmd->ulpCommand == CMD_ABORT_XRI_CN ||
 	     icmd->ulpCommand == CMD_CLOSE_XRI_CN))
 		return -EINVAL;
@@ -12630,8 +12630,8 @@ lpfc_sli_sum_iocb(struct lpfc_vport *vport, uint16_t tgt_id, uint64_t lun_id,
 
 		if (!iocbq || iocbq->vport != vport)
 			continue;
-		if (!(iocbq->cmd_flag & LPFC_IO_FCP) ||
-		    !(iocbq->cmd_flag & LPFC_IO_ON_TXCMPLQ))
+		if (!(iocbq->iocb_flag & LPFC_IO_FCP) ||
+		    !(iocbq->iocb_flag & LPFC_IO_ON_TXCMPLQ))
 			continue;
 
 		/* Include counting outstanding aborts */
@@ -12857,8 +12857,8 @@ lpfc_sli_abort_taskmgmt(struct lpfc_vport *vport, struct lpfc_sli_ring *pring,
 		 * If the iocbq is already being aborted, don't take a second
 		 * action, but do count it.
 		 */
-		if ((iocbq->cmd_flag & LPFC_DRIVER_ABORTED) ||
-		    !(iocbq->cmd_flag & LPFC_IO_ON_TXCMPLQ)) {
+		if ((iocbq->iocb_flag & LPFC_DRIVER_ABORTED) ||
+		    !(iocbq->iocb_flag & LPFC_IO_ON_TXCMPLQ)) {
 			if (phba->sli_rev == LPFC_SLI_REV4)
 				spin_unlock(&pring_s4->ring_lock);
 			spin_unlock(&lpfc_cmd->buf_lock);
@@ -12888,10 +12888,10 @@ lpfc_sli_abort_taskmgmt(struct lpfc_vport *vport, struct lpfc_sli_ring *pring,
 
 		/* ABTS WQE must go to the same WQ as the WQE to be aborted */
 		abtsiocbq->hba_wqidx = iocbq->hba_wqidx;
-		if (iocbq->cmd_flag & LPFC_IO_FCP)
-			abtsiocbq->cmd_flag |= LPFC_USE_FCPWQIDX;
-		if (iocbq->cmd_flag & LPFC_IO_FOF)
-			abtsiocbq->cmd_flag |= LPFC_IO_FOF;
+		if (iocbq->iocb_flag & LPFC_IO_FCP)
+			abtsiocbq->iocb_flag |= LPFC_USE_FCPWQIDX;
+		if (iocbq->iocb_flag & LPFC_IO_FOF)
+			abtsiocbq->iocb_flag |= LPFC_IO_FOF;
 
 		ndlp = lpfc_cmd->rdata->pnode;
 
@@ -12902,13 +12902,13 @@ lpfc_sli_abort_taskmgmt(struct lpfc_vport *vport, struct lpfc_sli_ring *pring,
 			abtsiocbq->iocb.ulpCommand = CMD_CLOSE_XRI_CN;
 
 		/* Setup callback routine and issue the command. */
-		abtsiocbq->cmd_cmpl = lpfc_sli_abort_fcp_cmpl;
+		abtsiocbq->iocb_cmpl = lpfc_sli_abort_fcp_cmpl;
 
 		/*
 		 * Indicate the IO is being aborted by the driver and set
 		 * the caller's flag into the aborted IO.
 		 */
-		iocbq->cmd_flag |= LPFC_DRIVER_ABORTED;
+		iocbq->iocb_flag |= LPFC_DRIVER_ABORTED;
 
 		if (phba->sli_rev == LPFC_SLI_REV4) {
 			ret_val = __lpfc_sli_issue_iocb(phba, pring_s4->ringno,
@@ -12957,7 +12957,7 @@ lpfc_sli_wake_iocb_wait(struct lpfc_hba *phba,
 	struct lpfc_io_buf *lpfc_cmd;
 
 	spin_lock_irqsave(&phba->hbalock, iflags);
-	if (cmdiocbq->cmd_flag & LPFC_IO_WAKE_TMO) {
+	if (cmdiocbq->iocb_flag & LPFC_IO_WAKE_TMO) {
 
 		/*
 		 * A time out has occurred for the iocb.  If a time out
@@ -12966,26 +12966,26 @@ lpfc_sli_wake_iocb_wait(struct lpfc_hba *phba,
 		 */
 
 		spin_unlock_irqrestore(&phba->hbalock, iflags);
-		cmdiocbq->cmd_cmpl = cmdiocbq->wait_cmd_cmpl;
-		cmdiocbq->wait_cmd_cmpl = NULL;
-		if (cmdiocbq->cmd_cmpl)
-			(cmdiocbq->cmd_cmpl)(phba, cmdiocbq, NULL);
+		cmdiocbq->iocb_cmpl = cmdiocbq->wait_iocb_cmpl;
+		cmdiocbq->wait_iocb_cmpl = NULL;
+		if (cmdiocbq->iocb_cmpl)
+			(cmdiocbq->iocb_cmpl)(phba, cmdiocbq, NULL);
 		else
 			lpfc_sli_release_iocbq(phba, cmdiocbq);
 		return;
 	}
 
-	cmdiocbq->cmd_flag |= LPFC_IO_WAKE;
+	cmdiocbq->iocb_flag |= LPFC_IO_WAKE;
 	if (cmdiocbq->context2 && rspiocbq)
 		memcpy(&((struct lpfc_iocbq *)cmdiocbq->context2)->iocb,
 		       &rspiocbq->iocb, sizeof(IOCB_t));
 
 	/* Set the exchange busy flag for task management commands */
-	if ((cmdiocbq->cmd_flag & LPFC_IO_FCP) &&
-		!(cmdiocbq->cmd_flag & LPFC_IO_LIBDFC)) {
+	if ((cmdiocbq->iocb_flag & LPFC_IO_FCP) &&
+		!(cmdiocbq->iocb_flag & LPFC_IO_LIBDFC)) {
 		lpfc_cmd = container_of(cmdiocbq, struct lpfc_io_buf,
 			cur_iocbq);
-		if (rspiocbq && (rspiocbq->cmd_flag & LPFC_EXCHANGE_BUSY))
+		if (rspiocbq && (rspiocbq->iocb_flag & LPFC_EXCHANGE_BUSY))
 			lpfc_cmd->flags |= LPFC_SBUF_XBUSY;
 		else
 			lpfc_cmd->flags &= ~LPFC_SBUF_XBUSY;
@@ -13004,7 +13004,7 @@ lpfc_sli_wake_iocb_wait(struct lpfc_hba *phba,
  * @piocbq: Pointer to command iocb.
  * @flag: Flag to test.
  *
- * This routine grabs the hbalock and then test the cmd_flag to
+ * This routine grabs the hbalock and then test the iocb_flag to
  * see if the passed in flag is set.
  * Returns:
  * 1 if flag is set.
@@ -13018,7 +13018,7 @@ lpfc_chk_iocb_flg(struct lpfc_hba *phba,
 	int ret;
 
 	spin_lock_irqsave(&phba->hbalock, iflags);
-	ret = piocbq->cmd_flag & flag;
+	ret = piocbq->iocb_flag & flag;
 	spin_unlock_irqrestore(&phba->hbalock, iflags);
 	return ret;
 
@@ -13033,14 +13033,14 @@ lpfc_chk_iocb_flg(struct lpfc_hba *phba,
  * @timeout: Timeout in number of seconds.
  *
  * This function issues the iocb to firmware and waits for the
- * iocb to complete. The cmd_cmpl field of the shall be used
+ * iocb to complete. The iocb_cmpl field of the shall be used
  * to handle iocbs which time out. If the field is NULL, the
  * function shall free the iocbq structure.  If more clean up is
  * needed, the caller is expected to provide a completion function
  * that will provide the needed clean up.  If the iocb command is
  * not completed within timeout seconds, the function will either
- * free the iocbq structure (if cmd_cmpl == NULL) or execute the
- * completion function set in the cmd_cmpl field and then return
+ * free the iocbq structure (if iocb_cmpl == NULL) or execute the
+ * completion function set in the iocb_cmpl field and then return
  * a status of IOCB_TIMEDOUT.  The caller should not free the iocb
  * resources if this function returns IOCB_TIMEDOUT.
  * The function waits for the iocb completion using an
@@ -13052,7 +13052,7 @@ lpfc_chk_iocb_flg(struct lpfc_hba *phba,
  * This function assumes that the iocb completions occur while
  * this function sleep. So, this function cannot be called from
  * the thread which process iocb completion for this ring.
- * This function clears the cmd_flag of the iocb object before
+ * This function clears the iocb_flag of the iocb object before
  * issuing the iocb and the iocb completion handler sets this
  * flag and wakes this thread when the iocb completes.
  * The contents of the response iocb will be copied to prspiocbq
@@ -13092,10 +13092,10 @@ lpfc_sli_issue_iocb_wait(struct lpfc_hba *phba,
 		piocb->context2 = prspiocbq;
 	}
 
-	piocb->wait_cmd_cmpl = piocb->cmd_cmpl;
-	piocb->cmd_cmpl = lpfc_sli_wake_iocb_wait;
+	piocb->wait_iocb_cmpl = piocb->iocb_cmpl;
+	piocb->iocb_cmpl = lpfc_sli_wake_iocb_wait;
 	piocb->context_un.wait_queue = &done_q;
-	piocb->cmd_flag &= ~(LPFC_IO_WAKE | LPFC_IO_WAKE_TMO);
+	piocb->iocb_flag &= ~(LPFC_IO_WAKE | LPFC_IO_WAKE_TMO);
 
 	if (phba->cfg_poll & DISABLE_FCP_RING_INT) {
 		if (lpfc_readl(phba->HCregaddr, &creg_val))
@@ -13113,7 +13113,7 @@ lpfc_sli_issue_iocb_wait(struct lpfc_hba *phba,
 				lpfc_chk_iocb_flg(phba, piocb, LPFC_IO_WAKE),
 				timeout_req);
 		spin_lock_irqsave(&phba->hbalock, iflags);
-		if (!(piocb->cmd_flag & LPFC_IO_WAKE)) {
+		if (!(piocb->iocb_flag & LPFC_IO_WAKE)) {
 
 			/*
 			 * IOCB timed out.  Inform the wake iocb wait
@@ -13121,7 +13121,7 @@ lpfc_sli_issue_iocb_wait(struct lpfc_hba *phba,
 			 */
 
 			iocb_completed = false;
-			piocb->cmd_flag |= LPFC_IO_WAKE_TMO;
+			piocb->iocb_flag |= LPFC_IO_WAKE_TMO;
 		}
 		spin_unlock_irqrestore(&phba->hbalock, iflags);
 		if (iocb_completed) {
@@ -13176,7 +13176,7 @@ lpfc_sli_issue_iocb_wait(struct lpfc_hba *phba,
 		piocb->context2 = NULL;
 
 	piocb->context_un.wait_queue = NULL;
-	piocb->cmd_cmpl = NULL;
+	piocb->iocb_cmpl = NULL;
 	return retval;
 }
 
@@ -14145,7 +14145,7 @@ lpfc_sli4_iocb_param_transfer(struct lpfc_hba *phba,
 	/* Map WCQE parameters into irspiocb parameters */
 	status = bf_get(lpfc_wcqe_c_status, wcqe);
 	pIocbIn->iocb.ulpStatus = (status & LPFC_IOCB_STATUS_MASK);
-	if (pIocbOut->cmd_flag & LPFC_IO_FCP)
+	if (pIocbOut->iocb_flag & LPFC_IO_FCP)
 		if (pIocbIn->iocb.ulpStatus == IOSTAT_FCP_RSP_ERROR)
 			pIocbIn->iocb.un.fcpi.fcpi_parm =
 					pIocbOut->iocb.un.fcpi.fcpi_parm -
@@ -14227,7 +14227,7 @@ lpfc_sli4_iocb_param_transfer(struct lpfc_hba *phba,
 	/* Pick up HBA exchange busy condition */
 	if (bf_get(lpfc_wcqe_c_xb, wcqe)) {
 		spin_lock_irqsave(&phba->hbalock, iflags);
-		pIocbIn->cmd_flag |= LPFC_EXCHANGE_BUSY;
+		pIocbIn->iocb_flag |= LPFC_EXCHANGE_BUSY;
 		spin_unlock_irqrestore(&phba->hbalock, iflags);
 	}
 }
@@ -15078,6 +15078,7 @@ lpfc_sli4_fp_handle_fcp_wcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 {
 	struct lpfc_sli_ring *pring = cq->pring;
 	struct lpfc_iocbq *cmdiocbq;
+	struct lpfc_iocbq irspiocbq;
 	unsigned long iflags;
 
 	/* Check for response status */
@@ -15116,31 +15117,39 @@ lpfc_sli4_fp_handle_fcp_wcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	cmdiocbq->isr_timestamp = cq->isr_timestamp;
 #endif
-	if (bf_get(lpfc_wcqe_c_xb, wcqe)) {
-		spin_lock_irqsave(&phba->hbalock, iflags);
-		cmdiocbq->cmd_flag |= LPFC_EXCHANGE_BUSY;
-		spin_unlock_irqrestore(&phba->hbalock, iflags);
-	}
+	if (cmdiocbq->iocb_cmpl == NULL) {
+		if (cmdiocbq->wqe_cmpl) {
+			/* For FCP the flag is cleared in wqe_cmpl */
+			if (!(cmdiocbq->iocb_flag & LPFC_IO_FCP) &&
+			    cmdiocbq->iocb_flag & LPFC_DRIVER_ABORTED) {
+				spin_lock_irqsave(&phba->hbalock, iflags);
+				cmdiocbq->iocb_flag &= ~LPFC_DRIVER_ABORTED;
+				spin_unlock_irqrestore(&phba->hbalock, iflags);
+			}
 
-	if (cmdiocbq->cmd_cmpl) {
-		/* For FCP the flag is cleared in cmd_cmpl */
-		if (!(cmdiocbq->cmd_flag & LPFC_IO_FCP) &&
-		    cmdiocbq->cmd_flag & LPFC_DRIVER_ABORTED) {
-			spin_lock_irqsave(&phba->hbalock, iflags);
-			cmdiocbq->cmd_flag &= ~LPFC_DRIVER_ABORTED;
-			spin_unlock_irqrestore(&phba->hbalock, iflags);
+			/* Pass the cmd_iocb and the wcqe to the upper layer */
+			(cmdiocbq->wqe_cmpl)(phba, cmdiocbq, wcqe);
+			return;
 		}
-
-		/* Pass the cmd_iocb and the wcqe to the upper layer */
-		memcpy(&cmdiocbq->wcqe_cmpl, wcqe,
-		       sizeof(struct lpfc_wcqe_complete));
-		(cmdiocbq->cmd_cmpl)(phba, cmdiocbq, cmdiocbq);
-	} else {
 		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
 				"0375 FCP cmdiocb not callback function "
 				"iotag: (%d)\n",
 				bf_get(lpfc_wcqe_c_request_tag, wcqe));
+		return;
+	}
+
+	/* Only SLI4 non-IO commands stil use IOCB */
+	/* Fake the irspiocb and copy necessary response information */
+	lpfc_sli4_iocb_param_transfer(phba, &irspiocbq, cmdiocbq, wcqe);
+
+	if (cmdiocbq->iocb_flag & LPFC_DRIVER_ABORTED) {
+		spin_lock_irqsave(&phba->hbalock, iflags);
+		cmdiocbq->iocb_flag &= ~LPFC_DRIVER_ABORTED;
+		spin_unlock_irqrestore(&phba->hbalock, iflags);
 	}
+
+	/* Pass the cmd_iocb and the rsp state to the upper layer */
+	(cmdiocbq->iocb_cmpl)(phba, cmdiocbq, &irspiocbq);
 }
 
 /**
@@ -18962,7 +18971,7 @@ lpfc_sli4_seq_abort_rsp(struct lpfc_vport *vport,
 	}
 
 	ctiocb->vport = phba->pport;
-	ctiocb->cmd_cmpl = lpfc_sli4_seq_abort_rsp_cmpl;
+	ctiocb->iocb_cmpl = lpfc_sli4_seq_abort_rsp_cmpl;
 	ctiocb->sli4_lxritag = NO_XRI;
 	ctiocb->sli4_xritag = NO_XRI;
 
@@ -19365,8 +19374,8 @@ lpfc_sli4_handle_mds_loopback(struct lpfc_vport *vport,
 
 	iocbq->context2 = pcmd;
 	iocbq->vport = vport;
-	iocbq->cmd_flag &= ~LPFC_FIP_ELS_ID_MASK;
-	iocbq->cmd_flag |= LPFC_USE_FCPWQIDX;
+	iocbq->iocb_flag &= ~LPFC_FIP_ELS_ID_MASK;
+	iocbq->iocb_flag |= LPFC_USE_FCPWQIDX;
 
 	/*
 	 * Setup rest of the iocb as though it were a WQE
@@ -19384,7 +19393,7 @@ lpfc_sli4_handle_mds_loopback(struct lpfc_vport *vport,
 
 	iocbq->iocb.ulpCommand = CMD_SEND_FRAME;
 	iocbq->iocb.ulpLe = 1;
-	iocbq->cmd_cmpl = lpfc_sli4_mds_loopback_cmpl;
+	iocbq->iocb_cmpl = lpfc_sli4_mds_loopback_cmpl;
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, iocbq, 0);
 	if (rc == IOCB_ERROR)
 		goto exit;
@@ -21226,7 +21235,7 @@ lpfc_wqe_bpl2sgl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeq,
 	cmd = bf_get(wqe_cmnd, &wqe->generic.wqe_com);
 	if (cmd == CMD_XMIT_BLS_RSP64_WQE)
 		return sglq->sli4_xritag;
-	numBdes = pwqeq->num_bdes;
+	numBdes = pwqeq->rsvd2;
 	if (numBdes) {
 		/* The addrHigh and addrLow fields within the WQE
 		 * have not been byteswapped yet so there is no
@@ -21327,7 +21336,7 @@ lpfc_sli4_issue_wqe(struct lpfc_hba *phba, struct lpfc_sli4_hdw_queue *qp,
 	uint32_t ret = 0;
 
 	/* NVME_LS and NVME_LS ABTS requests. */
-	if (pwqe->cmd_flag & LPFC_IO_NVME_LS) {
+	if (pwqe->iocb_flag & LPFC_IO_NVME_LS) {
 		pring =  phba->sli4_hba.nvmels_wq->pring;
 		lpfc_qp_spin_lock_irqsave(&pring->ring_lock, iflags,
 					  qp, wq_access);
@@ -21358,7 +21367,7 @@ lpfc_sli4_issue_wqe(struct lpfc_hba *phba, struct lpfc_sli4_hdw_queue *qp,
 	}
 
 	/* NVME_FCREQ and NVME_ABTS requests */
-	if (pwqe->cmd_flag & (LPFC_IO_NVME | LPFC_IO_FCP | LPFC_IO_CMF)) {
+	if (pwqe->iocb_flag & (LPFC_IO_NVME | LPFC_IO_FCP | LPFC_IO_CMF)) {
 		/* Get the IO distribution (hba_wqidx) for WQ assignment. */
 		wq = qp->io_wq;
 		pring = wq->pring;
@@ -21380,7 +21389,7 @@ lpfc_sli4_issue_wqe(struct lpfc_hba *phba, struct lpfc_sli4_hdw_queue *qp,
 	}
 
 	/* NVMET requests */
-	if (pwqe->cmd_flag & LPFC_IO_NVMET) {
+	if (pwqe->iocb_flag & LPFC_IO_NVMET) {
 		/* Get the IO distribution (hba_wqidx) for WQ assignment. */
 		wq = qp->io_wq;
 		pring = wq->pring;
@@ -21446,7 +21455,7 @@ lpfc_sli4_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		return WQE_NORESOURCE;
 
 	/* Indicate the IO is being aborted by the driver. */
-	cmdiocb->cmd_flag |= LPFC_DRIVER_ABORTED;
+	cmdiocb->iocb_flag |= LPFC_DRIVER_ABORTED;
 
 	abtswqe = &abtsiocb->wqe;
 	memset(abtswqe, 0, sizeof(*abtswqe));
@@ -21465,15 +21474,15 @@ lpfc_sli4_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 
 	/* ABTS WQE must go to the same WQ as the WQE to be aborted */
 	abtsiocb->hba_wqidx = cmdiocb->hba_wqidx;
-	abtsiocb->cmd_flag |= LPFC_USE_FCPWQIDX;
-	if (cmdiocb->cmd_flag & LPFC_IO_FCP)
-		abtsiocb->cmd_flag |= LPFC_IO_FCP;
-	if (cmdiocb->cmd_flag & LPFC_IO_NVME)
-		abtsiocb->cmd_flag |= LPFC_IO_NVME;
-	if (cmdiocb->cmd_flag & LPFC_IO_FOF)
-		abtsiocb->cmd_flag |= LPFC_IO_FOF;
+	abtsiocb->iocb_flag |= LPFC_USE_FCPWQIDX;
+	if (cmdiocb->iocb_flag & LPFC_IO_FCP)
+		abtsiocb->iocb_flag |= LPFC_IO_FCP;
+	if (cmdiocb->iocb_flag & LPFC_IO_NVME)
+		abtsiocb->iocb_flag |= LPFC_IO_NVME;
+	if (cmdiocb->iocb_flag & LPFC_IO_FOF)
+		abtsiocb->iocb_flag |= LPFC_IO_FOF;
 	abtsiocb->vport = vport;
-	abtsiocb->cmd_cmpl = cmpl;
+	abtsiocb->wqe_cmpl = cmpl;
 
 	lpfc_cmd = container_of(cmdiocb, struct lpfc_io_buf, cur_iocbq);
 	retval = lpfc_sli4_issue_wqe(phba, lpfc_cmd->hdwq, abtsiocb);
@@ -21484,7 +21493,7 @@ lpfc_sli4_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			 xritag, cmdiocb->iotag, abtsiocb->iotag, retval);
 
 	if (retval) {
-		cmdiocb->cmd_flag &= ~LPFC_DRIVER_ABORTED;
+		cmdiocb->iocb_flag &= ~LPFC_DRIVER_ABORTED;
 		__lpfc_sli_release_iocbq(phba, abtsiocb);
 	}
 
@@ -21846,7 +21855,8 @@ void lpfc_release_io_buf(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_ncmd,
 
 	/* MUST zero fields if buffer is reused by another protocol */
 	lpfc_ncmd->nvmeCmd = NULL;
-	lpfc_ncmd->cur_iocbq.cmd_cmpl = NULL;
+	lpfc_ncmd->cur_iocbq.wqe_cmpl = NULL;
+	lpfc_ncmd->cur_iocbq.iocb_cmpl = NULL;
 
 	if (phba->cfg_xpsgl && !phba->nvmet_support &&
 	    !list_empty(&lpfc_ncmd->dma_sgl_xtra_list))
diff --git a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
index 968c83182643..5161ccacea3e 100644
--- a/drivers/scsi/lpfc/lpfc_sli.h
+++ b/drivers/scsi/lpfc/lpfc_sli.h
@@ -35,7 +35,7 @@ typedef enum _lpfc_ctx_cmd {
 	LPFC_CTX_HOST
 } lpfc_ctx_cmd;
 
-union lpfc_vmid_tag {
+union lpfc_vmid_iocb_tag {
 	uint32_t app_id;
 	uint8_t cs_ctl_vmid;
 	struct lpfc_vmid_context *vmid_context;	/* UVEM context information */
@@ -69,16 +69,16 @@ struct lpfc_iocbq {
 	uint16_t sli4_xritag;   /* pre-assigned XRI, (OXID) tag. */
 	uint16_t hba_wqidx;     /* index to HBA work queue */
 	struct lpfc_cq_event cq_event;
+	struct lpfc_wcqe_complete wcqe_cmpl;	/* WQE cmpl */
 	uint64_t isr_timestamp;
 
 	union lpfc_wqe128 wqe;	/* SLI-4 */
 	IOCB_t iocb;		/* SLI-3 */
-	struct lpfc_wcqe_complete wcqe_cmpl;	/* WQE cmpl */
 
-	uint8_t num_bdes;
+	uint8_t rsvd2;
 	uint8_t priority;	/* OAS priority */
 	uint8_t retry;		/* retry counter for IOCB cmd - if needed */
-	u32 cmd_flag;
+	uint32_t iocb_flag;
 #define LPFC_IO_LIBDFC		1	/* libdfc iocb */
 #define LPFC_IO_WAKE		2	/* Synchronous I/O completed */
 #define LPFC_IO_WAKE_TMO	LPFC_IO_WAKE /* Synchronous I/O timed out */
@@ -123,13 +123,15 @@ struct lpfc_iocbq {
 		struct lpfc_node_rrq *rrq;
 	} context_un;
 
-	union lpfc_vmid_tag vmid_tag;
-	void (*fabric_cmd_cmpl)(struct lpfc_hba *phba, struct lpfc_iocbq *cmd,
-				struct lpfc_iocbq *rsp);
-	void (*wait_cmd_cmpl)(struct lpfc_hba *phba, struct lpfc_iocbq *cmd,
-			      struct lpfc_iocbq *rsp);
-	void (*cmd_cmpl)(struct lpfc_hba *phba, struct lpfc_iocbq *cmd,
-			 struct lpfc_iocbq *rsp);
+	union lpfc_vmid_iocb_tag vmid_tag;
+	void (*fabric_iocb_cmpl)(struct lpfc_hba *, struct lpfc_iocbq *,
+			   struct lpfc_iocbq *);
+	void (*wait_iocb_cmpl)(struct lpfc_hba *, struct lpfc_iocbq *,
+			   struct lpfc_iocbq *);
+	void (*iocb_cmpl)(struct lpfc_hba *, struct lpfc_iocbq *,
+			   struct lpfc_iocbq *);
+	void (*wqe_cmpl)(struct lpfc_hba *, struct lpfc_iocbq *,
+			  struct lpfc_wcqe_complete *);
 };
 
 #define SLI_IOCB_RET_IOCB      1	/* Return IOCB if cmd ring full */
-- 
2.35.3

