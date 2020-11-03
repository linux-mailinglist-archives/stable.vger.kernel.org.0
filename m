Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5E02A46CC
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 14:48:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729424AbgKCNsa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 08:48:30 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:39003 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729422AbgKCNsY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 08:48:24 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id CC116C85;
        Tue,  3 Nov 2020 08:48:23 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 08:48:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=+d5PYT
        7mJHW3qNBqmPg+4zWjC8Dt6noJnJVTlz+kYac=; b=qyhXEjKZ7rfULMW4pjOkIv
        D7WXs7+CPWSrJy41UvbD7LIR/CNbf3UztwIm6qKBQFkgtDWnilwZ+nmSdV6dZsHf
        p6d4vUMuJmgMavj8hoOXYFJZrDUscDmATrTCi+kLJ/MfzKH4tU+3Uf3iEWSVkrU2
        slRBDXafUIU6H84Ab5GT/qVchmMxU2r4n6Ucs3DoLokrp1Zeog96nhTH2Pd73iBD
        WL2SX1Wj30UhtiTAg9MY9+lzqIi/aGHuppcmkEIJ0nSaakuMYuUwRoVz+mVyCONK
        5xFx1EIXTFkOQ/+P5egDCk+QOviJeCPnKZmy8+P2XDShLVkyyd1HBnNuoHJmh3gw
        ==
X-ME-Sender: <xms:p1-hXx9zW-ZVHV3Fp4Y302rilskPio0pyqLMVVP9ND97meszto0fhA>
    <xme:p1-hX1v654gq0wpmoscxwjlsKOSCpNO4gTCf6j3CXFvkhdLXjX-EtsBSuKLwV6Vz7
    GYSs6EQGu_GuA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgheegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:p1-hX_Cy92Is0fadckjTPzLGtCD7vpF7W_QwU987VJkesAvuMedLRw>
    <xmx:p1-hX1c8Xgj6T3p8n4fDf3Qm6sjCM8hQ5tQOldHIDoOFok5TRN54WA>
    <xmx:p1-hX2OfzYhcqrOLHo_TFt3LTamGQWyEPBmfxfzjXZ8myY_PGsuLnA>
    <xmx:p1-hX_YVmpvorbDGa4zuhI6ehEY1Hond7ApDOUuxTyyXFOrFNC9cyzAY9YU>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id BD9EC3280066;
        Tue,  3 Nov 2020 08:48:22 -0500 (EST)
Subject: FAILED: patch "[PATCH] scsi: qla2xxx: Fix crash on session cleanup with unload" failed to apply to 4.14-stable tree
To:     qutran@marvell.com, himanshu.madhani@oracle.com,
        martin.petersen@oracle.com, njavali@marvell.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 14:49:17 +0100
Message-ID: <160441135710188@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 50457dab670f396557e60c07f086358460876353 Mon Sep 17 00:00:00 2001
From: Quinn Tran <qutran@marvell.com>
Date: Tue, 29 Sep 2020 03:21:50 -0700
Subject: [PATCH] scsi: qla2xxx: Fix crash on session cleanup with unload

On unload, session cleanup prematurely gave the signal for driver unload
path to advance.

Link: https://lore.kernel.org/r/20200929102152.32278-6-njavali@marvell.com
Fixes: 726b85487067 ("qla2xxx: Add framework for async fabric discovery")
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 1ef39a96c4c2..eb4aa97bc71f 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1231,14 +1231,15 @@ void qlt_schedule_sess_for_deletion(struct fc_port *sess)
 	case DSC_DELETE_PEND:
 		return;
 	case DSC_DELETED:
-		if (tgt && tgt->tgt_stop && (tgt->sess_count == 0))
-			wake_up_all(&tgt->waitQ);
-		if (sess->vha->fcport_count == 0)
-			wake_up_all(&sess->vha->fcport_waitQ);
-
 		if (!sess->plogi_link[QLT_PLOGI_LINK_SAME_WWN] &&
-			!sess->plogi_link[QLT_PLOGI_LINK_CONFLICT])
+			!sess->plogi_link[QLT_PLOGI_LINK_CONFLICT]) {
+			if (tgt && tgt->tgt_stop && tgt->sess_count == 0)
+				wake_up_all(&tgt->waitQ);
+
+			if (sess->vha->fcport_count == 0)
+				wake_up_all(&sess->vha->fcport_waitQ);
 			return;
+		}
 		break;
 	case DSC_UPD_FCPORT:
 		/*

