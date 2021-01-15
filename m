Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0AFE2F7415
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 09:13:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732436AbhAOIMh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 03:12:37 -0500
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:55949 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732440AbhAOIMg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 03:12:36 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id ED2ED19C3D91;
        Fri, 15 Jan 2021 03:11:29 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 15 Jan 2021 03:11:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=zIfw25
        NQm9S4n8oOCzTU5gY8QPSRmpQaYoAloax4eIY=; b=efHdWxWKzwN9DSfyqEehbE
        P6ukqASdHayx0GtHUYBHVL+NCAUC3l2BxI2oyr6u6LUU/8/jKpgJnFPiq8+td/q2
        o246TNNLh4F9h8wteTPKWBTcckLyAhlVMkSiTngAm5zA7A4TJY7HiD/7eSOTe0Ai
        cwKl0OkVqLtpS44jeF4Kysrj3AkNNx0Na26siEF3/iBKl8K/lIDNIbWGR6g3YcZI
        9Vn2Fi2q+k2DKEkKEq0AGSnptsbZBi+NCFhj5R+nNjazfK55sbu15Bwhf/Ax6UOE
        A8HLJyKuRb2F9NkMWcFFoEvQq6mescTrzLZMcAQsy76dCqZfACPhYU+5Y03pCFLA
        ==
X-ME-Sender: <xms:MU4BYDwELqxlqyzd8_UBjPfrmxp3VgQ7hQLUjBTeKDWXJPViTbFL9w>
    <xme:MU4BYLTRq94Ah6R2GmzjVGykj467X5j8pPuIJVS8y1if04mX-P2BvjCzUZhRhKbT2
    p78JJBjHsyJ7Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtddugdduudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:MU4BYNVZ4I5fPqmJhjX-I3qgmkfJXZVyuIUvYQqt275ikQ1Lv-kgvQ>
    <xmx:MU4BYNgJezGo8_6KBcQcbsfK2K1jqr6wVxH1vctDM-tLMWxi_-Kmog>
    <xmx:MU4BYFAFnzt2-bsocTYcZeB0WL4dFfja9fmJ2SbenezqNdEcMqDCRA>
    <xmx:MU4BYC54iHsaitK1j8urU8AykSb90qxjt32Jv6WA9K_DUJ6kmZT8TQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9D71724005C;
        Fri, 15 Jan 2021 03:11:29 -0500 (EST)
Subject: FAILED: patch "[PATCH] s390/qeth: fix deadlock during recovery" failed to apply to 4.9-stable tree
To:     jwi@linux.ibm.com, kuba@kernel.org, wintera@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 15 Jan 2021 09:11:23 +0100
Message-ID: <1610698283175178@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 0b9902c1fcc59ba75268386c0420a554f8844168 Mon Sep 17 00:00:00 2001
From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Thu, 7 Jan 2021 18:24:40 +0100
Subject: [PATCH] s390/qeth: fix deadlock during recovery

When qeth_dev_layer2_store() - holding the discipline_mutex - waits
inside qeth_l*_remove_device() for a qeth_do_reset() thread to complete,
we can hit a deadlock if qeth_do_reset() concurrently calls
qeth_set_online() and thus tries to aquire the discipline_mutex.

Move the discipline_mutex locking outside of qeth_set_online() and
qeth_set_offline(), and turn the discipline into a parameter so that
callers understand the dependency.

To fix the deadlock, we can now relax the locking:
As already established, qeth_l*_remove_device() waits for
qeth_do_reset() to complete. So qeth_do_reset() itself is under no risk
of having card->discipline ripped out while it's running, and thus
doesn't need to take the discipline_mutex.

Fixes: 9dc48ccc68b9 ("qeth: serialize sysfs-triggered device configurations")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 6f5ddc3eab8c..28f637042d44 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -1079,7 +1079,8 @@ struct qeth_card *qeth_get_card_by_busid(char *bus_id);
 void qeth_set_allowed_threads(struct qeth_card *card, unsigned long threads,
 			      int clear_start_mask);
 int qeth_threads_running(struct qeth_card *, unsigned long);
-int qeth_set_offline(struct qeth_card *card, bool resetting);
+int qeth_set_offline(struct qeth_card *card, const struct qeth_discipline *disc,
+		     bool resetting);
 
 int qeth_send_ipa_cmd(struct qeth_card *, struct qeth_cmd_buffer *,
 		  int (*reply_cb)
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index f4b60294a969..d45e223fc521 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -5507,12 +5507,12 @@ static int qeth_hardsetup_card(struct qeth_card *card, bool *carrier_ok)
 	return rc;
 }
 
-static int qeth_set_online(struct qeth_card *card)
+static int qeth_set_online(struct qeth_card *card,
+			   const struct qeth_discipline *disc)
 {
 	bool carrier_ok;
 	int rc;
 
-	mutex_lock(&card->discipline_mutex);
 	mutex_lock(&card->conf_mutex);
 	QETH_CARD_TEXT(card, 2, "setonlin");
 
@@ -5529,7 +5529,7 @@ static int qeth_set_online(struct qeth_card *card)
 		/* no need for locking / error handling at this early stage: */
 		qeth_set_real_num_tx_queues(card, qeth_tx_actual_queues(card));
 
-	rc = card->discipline->set_online(card, carrier_ok);
+	rc = disc->set_online(card, carrier_ok);
 	if (rc)
 		goto err_online;
 
@@ -5537,7 +5537,6 @@ static int qeth_set_online(struct qeth_card *card)
 	kobject_uevent(&card->gdev->dev.kobj, KOBJ_CHANGE);
 
 	mutex_unlock(&card->conf_mutex);
-	mutex_unlock(&card->discipline_mutex);
 	return 0;
 
 err_online:
@@ -5552,15 +5551,14 @@ static int qeth_set_online(struct qeth_card *card)
 	qdio_free(CARD_DDEV(card));
 
 	mutex_unlock(&card->conf_mutex);
-	mutex_unlock(&card->discipline_mutex);
 	return rc;
 }
 
-int qeth_set_offline(struct qeth_card *card, bool resetting)
+int qeth_set_offline(struct qeth_card *card, const struct qeth_discipline *disc,
+		     bool resetting)
 {
 	int rc, rc2, rc3;
 
-	mutex_lock(&card->discipline_mutex);
 	mutex_lock(&card->conf_mutex);
 	QETH_CARD_TEXT(card, 3, "setoffl");
 
@@ -5581,7 +5579,7 @@ int qeth_set_offline(struct qeth_card *card, bool resetting)
 
 	cancel_work_sync(&card->rx_mode_work);
 
-	card->discipline->set_offline(card);
+	disc->set_offline(card);
 
 	qeth_qdio_clear_card(card, 0);
 	qeth_drain_output_queues(card);
@@ -5602,16 +5600,19 @@ int qeth_set_offline(struct qeth_card *card, bool resetting)
 	kobject_uevent(&card->gdev->dev.kobj, KOBJ_CHANGE);
 
 	mutex_unlock(&card->conf_mutex);
-	mutex_unlock(&card->discipline_mutex);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(qeth_set_offline);
 
 static int qeth_do_reset(void *data)
 {
+	const struct qeth_discipline *disc;
 	struct qeth_card *card = data;
 	int rc;
 
+	/* Lock-free, other users will block until we are done. */
+	disc = card->discipline;
+
 	QETH_CARD_TEXT(card, 2, "recover1");
 	if (!qeth_do_run_thread(card, QETH_RECOVER_THREAD))
 		return 0;
@@ -5619,8 +5620,8 @@ static int qeth_do_reset(void *data)
 	dev_warn(&card->gdev->dev,
 		 "A recovery process has been started for the device\n");
 
-	qeth_set_offline(card, true);
-	rc = qeth_set_online(card);
+	qeth_set_offline(card, disc, true);
+	rc = qeth_set_online(card, disc);
 	if (!rc) {
 		dev_info(&card->gdev->dev,
 			 "Device successfully recovered!\n");
@@ -6647,7 +6648,10 @@ static int qeth_core_set_online(struct ccwgroup_device *gdev)
 		}
 	}
 
-	rc = qeth_set_online(card);
+	mutex_lock(&card->discipline_mutex);
+	rc = qeth_set_online(card, card->discipline);
+	mutex_unlock(&card->discipline_mutex);
+
 err:
 	return rc;
 }
@@ -6655,8 +6659,13 @@ static int qeth_core_set_online(struct ccwgroup_device *gdev)
 static int qeth_core_set_offline(struct ccwgroup_device *gdev)
 {
 	struct qeth_card *card = dev_get_drvdata(&gdev->dev);
+	int rc;
 
-	return qeth_set_offline(card, false);
+	mutex_lock(&card->discipline_mutex);
+	rc = qeth_set_offline(card, card->discipline, false);
+	mutex_unlock(&card->discipline_mutex);
+
+	return rc;
 }
 
 static void qeth_core_shutdown(struct ccwgroup_device *gdev)
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 4ed0fb0705a5..37279b1e29f6 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -2207,8 +2207,11 @@ static void qeth_l2_remove_device(struct ccwgroup_device *gdev)
 	qeth_set_allowed_threads(card, 0, 1);
 	wait_event(card->wait_q, qeth_threads_running(card, 0xffffffff) == 0);
 
-	if (gdev->state == CCWGROUP_ONLINE)
-		qeth_set_offline(card, false);
+	if (gdev->state == CCWGROUP_ONLINE) {
+		mutex_lock(&card->discipline_mutex);
+		qeth_set_offline(card, card->discipline, false);
+		mutex_unlock(&card->discipline_mutex);
+	}
 
 	cancel_work_sync(&card->close_dev_work);
 	if (card->dev->reg_state == NETREG_REGISTERED)
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index d138ac432d01..8d474179ce98 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1970,8 +1970,11 @@ static void qeth_l3_remove_device(struct ccwgroup_device *cgdev)
 	qeth_set_allowed_threads(card, 0, 1);
 	wait_event(card->wait_q, qeth_threads_running(card, 0xffffffff) == 0);
 
-	if (cgdev->state == CCWGROUP_ONLINE)
-		qeth_set_offline(card, false);
+	if (cgdev->state == CCWGROUP_ONLINE) {
+		mutex_lock(&card->discipline_mutex);
+		qeth_set_offline(card, card->discipline, false);
+		mutex_unlock(&card->discipline_mutex);
+	}
 
 	cancel_work_sync(&card->close_dev_work);
 	if (card->dev->reg_state == NETREG_REGISTERED)

