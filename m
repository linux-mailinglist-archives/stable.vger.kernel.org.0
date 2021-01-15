Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A42962F7417
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 09:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727380AbhAOIM6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 03:12:58 -0500
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:53673 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730858AbhAOIM5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 03:12:57 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 21E2D19C3DBC;
        Fri, 15 Jan 2021 03:11:44 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 15 Jan 2021 03:11:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=J1pYc5
        pYpLdAi7NTHH05gARe69sBil8VCxBT362UbvI=; b=m7WIeNTi0lWOzoOoEf5mc6
        o+O57hkzqJe1IpW6+t35u0YffjrzEG0br/fwzGmyHG0F61muNBROAP3MB1L5m9iV
        KSetW3UzK9k6j0OO2nzr4jXv9JmJH6cu9TDtPZO1uwEJRtcVa2XmVhaYAY8J/WTD
        QzWSTVkEgNofCScLHbeirKqhQ8poS0XUvcrjOfsHbEXh9gd0mIQF33sNAXdmEarK
        Gwb55xheohY0xQ0yJgYCJ41FlTaf0cahogVfqmjiRwGC9VZ9i0Hzh36qYQGkUoZY
        u6ePJIhAqPXaGIu09/+rMoEXOo1FMwDToNORt2/jcPTpdMP5XlnNYaVk6Fx5su8g
        ==
X-ME-Sender: <xms:P04BYMexSEMsTMx2R4DDhFRJ85lvQsoQACtEa6uXW-wke-VhBciT5w>
    <xme:P04BYOL8ldP9TvQ3HCEpt9ev-J__SLMxk9zwvIS7AwNLbPmdYKbEVlPjoyaCxztWp
    ItFczEV5JtYvA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtddugdduudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:P04BYKatjJW2mkP3mKE-IrSkxqdpJJIz9rFKhasivoueNkxbQLHprg>
    <xmx:P04BYJsAnNsc3ZljCZIeZlbn89bDr2-5r1dnfUWY0Ba4uoB0mUNdiw>
    <xmx:P04BYHuN2rGAmtVR_R2cAyJlPlhcvDLjWTFaPks5AavDLCtjwvwgTw>
    <xmx:QE4BYLaKixYoT4vt0OScs1ZInstBNGXwnSnwPaTpYhWhmLvk4qAF7A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 948401080059;
        Fri, 15 Jan 2021 03:11:43 -0500 (EST)
Subject: FAILED: patch "[PATCH] s390/qeth: fix locking for discipline setup / removal" failed to apply to 5.4-stable tree
To:     jwi@linux.ibm.com, kuba@kernel.org, wintera@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 15 Jan 2021 09:11:42 +0100
Message-ID: <1610698302206234@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

