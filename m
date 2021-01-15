Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3C502F741A
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 09:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729905AbhAOINT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 03:13:19 -0500
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:57061 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730858AbhAOINT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 03:13:19 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 0884519C0063;
        Fri, 15 Jan 2021 03:11:54 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 15 Jan 2021 03:11:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ZLBDyM
        wAfFi3QrYjwpd5d9gjY8khx80WxyhAFMGI0i4=; b=fbarBM3K0NVx80cJAJT1YZ
        7/36pJozXu5KD5muIkFPEPuyRl9SX0fRkXVPI/Q5jmcUloAQKQo7ccG8bndOLn/p
        OCWRU2gbxNpPB3pSb722DUxbmPqQ0GrOhpgaxFr1MvtzRWPpKFlXa9xxtf2x2vVa
        i4rTnjWZHvKH37PZ4PADpsxOtjqxYSs5GzLKR5zK7dxVLA9zOTCGZqjEoSAfFrqC
        88dPMbKroIxbcq8Mxctgq6BIbiVamgOpxIZBRTdigOKgq57YDAC4qB4f00sWIMob
        txujsccFyy6X2SPznsdPtxi2dMhhkaPKAT1F/PHqu3shL0z/wRPMc0BjLKZugdOQ
        ==
X-ME-Sender: <xms:SU4BYDFWGTEP3e2VQoCQtNL5P6vPXYkqXvjz6fPdoUnMPpNacg1flw>
    <xme:SU4BYAQ62wbjm62mdnVxUOQ9msf9rK-cEo5OJBXQ1nbgYUDLcfGobeQRMK2a3vn89
    8ZLd62Efw9syQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtddugdduudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:SU4BYCBBTHaNafBgh_43FfxLoF062Ww4p4zEZkPo0DtWkPN4bmMyDA>
    <xmx:SU4BYI1nJWxe8LnKoC2m3eJOn8uNLzbrmR5hErncJ8BSbkQBsrE6lw>
    <xmx:SU4BYIXO8HHOmJm_i6zN2-chPYmRtDJ0FsgmgR5SEJshfaiF7uluiw>
    <xmx:Sk4BYOgdLD7BEsp4hGAOCK41FLRtZ35NPoD3MBIBIR1oQPyFxPHYZg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id A88E71080057;
        Fri, 15 Jan 2021 03:11:53 -0500 (EST)
Subject: FAILED: patch "[PATCH] s390/qeth: fix locking for discipline setup / removal" failed to apply to 4.4-stable tree
To:     jwi@linux.ibm.com, kuba@kernel.org, wintera@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 15 Jan 2021 09:11:45 +0100
Message-ID: <1610698305116232@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From b41b554c1ee75070a14c02a88496b1f231c7eacc Mon Sep 17 00:00:00 2001
From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Thu, 7 Jan 2021 18:24:41 +0100
Subject: [PATCH] s390/qeth: fix locking for discipline setup / removal

Due to insufficient locking, qeth_core_set_online() and
qeth_dev_layer2_store() can run in parallel, both attempting to load &
setup the discipline (and stepping on each other toes along the way).
A similar race can also occur between qeth_core_remove_device() and
qeth_dev_layer2_store().

Access to .discipline is meant to be protected by the discipline_mutex,
so add/expand the locking in qeth_core_remove_device() and
qeth_core_set_online().
Adjust the locking in qeth_l*_remove_device() accordingly, as it's now
handled by the callers in a consistent manner.

Based on an initial patch by Ursula Braun.

Fixes: 9dc48ccc68b9 ("qeth: serialize sysfs-triggered device configurations")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index d45e223fc521..cf18d87da41e 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -6585,6 +6585,7 @@ static int qeth_core_probe_device(struct ccwgroup_device *gdev)
 		break;
 	default:
 		card->info.layer_enforced = true;
+		/* It's so early that we don't need the discipline_mutex yet. */
 		rc = qeth_core_load_discipline(card, enforced_disc);
 		if (rc)
 			goto err_load;
@@ -6617,10 +6618,12 @@ static void qeth_core_remove_device(struct ccwgroup_device *gdev)
 
 	QETH_CARD_TEXT(card, 2, "removedv");
 
+	mutex_lock(&card->discipline_mutex);
 	if (card->discipline) {
 		card->discipline->remove(gdev);
 		qeth_core_free_discipline(card);
 	}
+	mutex_unlock(&card->discipline_mutex);
 
 	qeth_free_qdio_queues(card);
 
@@ -6635,6 +6638,7 @@ static int qeth_core_set_online(struct ccwgroup_device *gdev)
 	int rc = 0;
 	enum qeth_discipline_id def_discipline;
 
+	mutex_lock(&card->discipline_mutex);
 	if (!card->discipline) {
 		def_discipline = IS_IQD(card) ? QETH_DISCIPLINE_LAYER3 :
 						QETH_DISCIPLINE_LAYER2;
@@ -6648,11 +6652,10 @@ static int qeth_core_set_online(struct ccwgroup_device *gdev)
 		}
 	}
 
-	mutex_lock(&card->discipline_mutex);
 	rc = qeth_set_online(card, card->discipline);
-	mutex_unlock(&card->discipline_mutex);
 
 err:
+	mutex_unlock(&card->discipline_mutex);
 	return rc;
 }
 
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 37279b1e29f6..4254caf1d9b6 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -2207,11 +2207,8 @@ static void qeth_l2_remove_device(struct ccwgroup_device *gdev)
 	qeth_set_allowed_threads(card, 0, 1);
 	wait_event(card->wait_q, qeth_threads_running(card, 0xffffffff) == 0);
 
-	if (gdev->state == CCWGROUP_ONLINE) {
-		mutex_lock(&card->discipline_mutex);
+	if (gdev->state == CCWGROUP_ONLINE)
 		qeth_set_offline(card, card->discipline, false);
-		mutex_unlock(&card->discipline_mutex);
-	}
 
 	cancel_work_sync(&card->close_dev_work);
 	if (card->dev->reg_state == NETREG_REGISTERED)
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 8d474179ce98..6970597bc885 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1970,11 +1970,8 @@ static void qeth_l3_remove_device(struct ccwgroup_device *cgdev)
 	qeth_set_allowed_threads(card, 0, 1);
 	wait_event(card->wait_q, qeth_threads_running(card, 0xffffffff) == 0);
 
-	if (cgdev->state == CCWGROUP_ONLINE) {
-		mutex_lock(&card->discipline_mutex);
+	if (cgdev->state == CCWGROUP_ONLINE)
 		qeth_set_offline(card, card->discipline, false);
-		mutex_unlock(&card->discipline_mutex);
-	}
 
 	cancel_work_sync(&card->close_dev_work);
 	if (card->dev->reg_state == NETREG_REGISTERED)

