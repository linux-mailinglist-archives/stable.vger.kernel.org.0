Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88EEB6ADE8D
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 13:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbjCGMUP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 07:20:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231579AbjCGMUG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 07:20:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5540A2CFF4
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 04:20:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A671FB816D5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 12:20:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D872CC433D2;
        Tue,  7 Mar 2023 12:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678191602;
        bh=0ZzZ0p9aIKyY78e72qAxnkzm6tSKcKaFUQwLcKLvOBQ=;
        h=Subject:To:Cc:From:Date:From;
        b=kYC4NDIe0kaQxn7K9OhOuDkoakbg1O1RMpygTakyqQyzxYrG9plGYf4Jeml+r8oA7
         pgpXN6tQjHf24hCTgSvy30/Pih79nshUkbOh+5iyFL+OKqkyjrnmnh/DtpCIn47F50
         SVnmdkfbv1EcLtcZpbN7a72zv0GarBNoAkhrN5kc=
Subject: FAILED: patch "[PATCH] scsi: qla2xxx: Check if port is online before sending ELS" failed to apply to 5.4-stable tree
To:     sdeodhar@marvell.com, himanshu.madhani@oracle.com,
        martin.petersen@oracle.com, njavali@marvell.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Mar 2023 13:19:50 +0100
Message-ID: <167819159023047@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.4.y
git checkout FETCH_HEAD
git cherry-pick -x 0c227dc22ca18856055983f27594feb2e0149965
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167819159023047@kroah.com' --subject-prefix 'PATCH 5.4.y' HEAD^..

Possible dependencies:

0c227dc22ca1 ("scsi: qla2xxx: Check if port is online before sending ELS")
7fb223d0ad80 ("scsi: qla2xxx: Fix a memory leak in an error path of qla2x00_process_els()")
84318a9f01ce ("scsi: qla2xxx: edif: Add send, receive, and accept for auth_els")
7ebb336e45ef ("scsi: qla2xxx: edif: Add start + stop bsgs")
d94d8158e184 ("scsi: qla2xxx: Add heartbeat check")
f7a0ed479e66 ("scsi: qla2xxx: Fix crash in PCIe error handling")
2ce35c0821af ("scsi: qla2xxx: Fix use after free in bsg")
5777fef788a5 ("scsi: qla2xxx: Consolidate zio threshold setting for both FCP & NVMe")
dbf1f53cfd23 ("scsi: qla2xxx: Implementation to get and manage host, target stats and initiator port")
707531bc2626 ("scsi: qla2xxx: If fcport is undergoing deletion complete I/O with retry")
3e6efab865ac ("scsi: qla2xxx: Fix reset of MPI firmware")
44f5a37d1e3e ("scsi: qla2xxx: Fix buffer-buffer credit extraction error")
89c72f4245a8 ("scsi: qla2xxx: Add IOCB resource tracking")
49db4d4e02aa ("scsi: qla2xxx: Performance tweak")
1e98fb0f9208 ("scsi: qla2xxx: Setup debugfs entries for remote ports")
897d68eb816b ("scsi: qla2xxx: Fix WARN_ON in qla_nvme_register_hba")
81b9d1e19d62 ("scsi: qla2xxx: Reduce noisy debug message")
9f2475fe7406 ("scsi: qla2xxx: SAN congestion management implementation")
62e9dd177732 ("scsi: qla2xxx: Change in PUREX to handle FPIN ELS requests")
818dbde78e0f ("Merge tag 'scsi-misc' of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0c227dc22ca18856055983f27594feb2e0149965 Mon Sep 17 00:00:00 2001
From: Shreyas Deodhar <sdeodhar@marvell.com>
Date: Mon, 19 Dec 2022 03:07:38 -0800
Subject: [PATCH] scsi: qla2xxx: Check if port is online before sending ELS

CT Ping and ELS cmds fail for NVMe targets.  Check if port is online before
sending ELS instead of sending login.

Cc: stable@vger.kernel.org
Signed-off-by: Shreyas Deodhar <sdeodhar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index cd75b179410d..dba7bba788d7 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -278,8 +278,8 @@ qla2x00_process_els(struct bsg_job *bsg_job)
 	const char *type;
 	int req_sg_cnt, rsp_sg_cnt;
 	int rval =  (DID_ERROR << 16);
-	uint16_t nextlid = 0;
 	uint32_t els_cmd = 0;
+	int qla_port_allocated = 0;
 
 	if (bsg_request->msgcode == FC_BSG_RPT_ELS) {
 		rport = fc_bsg_to_rport(bsg_job);
@@ -329,9 +329,9 @@ qla2x00_process_els(struct bsg_job *bsg_job)
 		/* make sure the rport is logged in,
 		 * if not perform fabric login
 		 */
-		if (qla2x00_fabric_login(vha, fcport, &nextlid)) {
+		if (atomic_read(&fcport->state) != FCS_ONLINE) {
 			ql_dbg(ql_dbg_user, vha, 0x7003,
-			    "Failed to login port %06X for ELS passthru.\n",
+			    "Port %06X is not online for ELS passthru.\n",
 			    fcport->d_id.b24);
 			rval = -EIO;
 			goto done;
@@ -348,6 +348,7 @@ qla2x00_process_els(struct bsg_job *bsg_job)
 			goto done;
 		}
 
+		qla_port_allocated = 1;
 		/* Initialize all required  fields of fcport */
 		fcport->vha = vha;
 		fcport->d_id.b.al_pa =
@@ -432,7 +433,7 @@ qla2x00_process_els(struct bsg_job *bsg_job)
 	goto done_free_fcport;
 
 done_free_fcport:
-	if (bsg_request->msgcode != FC_BSG_RPT_ELS)
+	if (qla_port_allocated)
 		qla2x00_free_fcport(fcport);
 done:
 	return rval;

