Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5C896ADE92
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 13:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbjCGMUi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 07:20:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231267AbjCGMUf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 07:20:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B0AA5507E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 04:20:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16D0AB816D9
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 12:20:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A27C433EF;
        Tue,  7 Mar 2023 12:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678191631;
        bh=1jgHTFC9Hjdi0xBe3aJKyXTA17lTMfV1/6kX7XEvUk8=;
        h=Subject:To:Cc:From:Date:From;
        b=z55ToDTasNMbRoDClsB+EV8MsQsyFit9SBvXsd7tK3aGtCZnW2W3ylNHJMPVdjaWW
         X6RoIy5Cw1lv3XRnQ2rPYVdr9mObKPU091bxM1nwxIWgBio3kRxY4cEuOqMcImqSSp
         mqAk8jmSEShp2oL7FhWVVNdSqouDR6xQ7QAget+8=
Subject: FAILED: patch "[PATCH] scsi: qla2xxx: Remove unintended flag clearing" failed to apply to 5.10-stable tree
To:     qutran@marvell.com, himanshu.madhani@oracle.com,
        martin.petersen@oracle.com, njavali@marvell.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Mar 2023 13:20:28 +0100
Message-ID: <1678191628234164@kroah.com>
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.10.y
git checkout FETCH_HEAD
git cherry-pick -x 7e8a936a2d0f98dd6e5d05d4838affabe606cabc
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1678191628234164@kroah.com' --subject-prefix 'PATCH 5.10.y' HEAD^..

Possible dependencies:

7e8a936a2d0f ("scsi: qla2xxx: Remove unintended flag clearing")
31e6cdbe0eae ("scsi: qla2xxx: Implement ref count for SRB")
d4523bd6fd5d ("scsi: qla2xxx: Refactor asynchronous command initialization")
2cabf10dbbe3 ("scsi: qla2xxx: Fix hang on NVMe command timeouts")
e3d2612f583b ("scsi: qla2xxx: Fix use after free in debug code")
9efea843a906 ("scsi: qla2xxx: edif: Add detection of secure device")
dd30706e73b7 ("scsi: qla2xxx: edif: Add key update")
fac2807946c1 ("scsi: qla2xxx: edif: Add extraction of auth_els from the wire")
84318a9f01ce ("scsi: qla2xxx: edif: Add send, receive, and accept for auth_els")
7878f22a2e03 ("scsi: qla2xxx: edif: Add getfcinfo and statistic bsgs")
7ebb336e45ef ("scsi: qla2xxx: edif: Add start + stop bsgs")
d94d8158e184 ("scsi: qla2xxx: Add heartbeat check")
f7a0ed479e66 ("scsi: qla2xxx: Fix crash in PCIe error handling")
2ce35c0821af ("scsi: qla2xxx: Fix use after free in bsg")
5777fef788a5 ("scsi: qla2xxx: Consolidate zio threshold setting for both FCP & NVMe")
960204ecca5e ("scsi: qla2xxx: Simplify if statement")
a04658594399 ("scsi: qla2xxx: Wait for ABTS response on I/O timeouts for NVMe")
dbf1f53cfd23 ("scsi: qla2xxx: Implementation to get and manage host, target stats and initiator port")
707531bc2626 ("scsi: qla2xxx: If fcport is undergoing deletion complete I/O with retry")
605e74025f95 ("scsi: qla2xxx: Move sess cmd list/lock to driver")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7e8a936a2d0f98dd6e5d05d4838affabe606cabc Mon Sep 17 00:00:00 2001
From: Quinn Tran <qutran@marvell.com>
Date: Mon, 19 Dec 2022 03:07:44 -0800
Subject: [PATCH] scsi: qla2xxx: Remove unintended flag clearing

FCF_ASYNC_SENT flag is used in session management. This flag is cleared in
task management path by accident.  Remove unintended flag clearing.

Fixes: 388a49959ee4 ("scsi: qla2xxx: Fix panic from use after free in qla2x00_async_tm_cmd")
Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 745fee298d56..6968e8d08968 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2082,7 +2082,6 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t flags, uint32_t lun,
 done_free_sp:
 	/* ref: INIT */
 	kref_put(&sp->cmd_kref, qla2x00_sp_release);
-	fcport->flags &= ~FCF_ASYNC_SENT;
 done:
 	return rval;
 }

