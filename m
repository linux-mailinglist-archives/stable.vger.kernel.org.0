Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 384E62F7416
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 09:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732361AbhAOIM5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 03:12:57 -0500
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:56817 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727380AbhAOIM5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 03:12:57 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 6E68F19C3D58;
        Fri, 15 Jan 2021 03:11:45 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 15 Jan 2021 03:11:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=0ODrkh
        KZjwTvMH9ggNTJ7kz122CdWeLyNXPsIMQfWKo=; b=BjBRJOpggb6gQn8w/uBXxR
        YIBwZatfp5rUadNbTUFJ+WVFZvABd4k5VUF7XuL3vQ4ZAX5vGC5b6BcX3uG/2Pd4
        uFBYX3ERylS1vX5Okgwx81XI3A/vnCdp3L0NNhjP0Pq6pQZ1uDSjafh2GNBDvG2I
        eE0tsOjVO3On0qKm9rV8gCtAWBapsz0MA97xNVgqxTxC08UKMq4qrhE+sykIEtHR
        q1NbL4lxX/EK6zV6fQrIPQQHj0R5GPzBNvdcmsanJFTtpsAgf1pG2yQh3zIwWqH2
        LJ3ogaRrOv+CNl5yH5q2jadf9kpqZoiepsaYJeCbCcdsc1eoTPlnVUuWrA8gPTIg
        ==
X-ME-Sender: <xms:QU4BYO9bS5sVav-OOIDpo4WS6Hd6eAbmkkksTEZ8sMgdGyzDq68_5g>
    <xme:QU4BYOv6-B2Z14gOQy2XKBj-SlzaFvoGLV_XAMrYqIktl3zLLgVJh9DkcMRWXluqt
    3CcYZn0JhfVYw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtddugdduudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:QU4BYEBQdoYnqEPWAYjpYsNh1hmhxEABTpcbdhKSorK4w1lEMBTRPA>
    <xmx:QU4BYGcXXUwVi1QyOnX9sgbArSIAfBj8Xnz0vB_KYjDyUjWELUTZOw>
    <xmx:QU4BYDNF4UdGR4xipCdkv3nNEl-RlhLbKqj3e76eeekmNhXmy2_8cQ>
    <xmx:QU4BYJ0Iwx8PHZm62EDNrUOJkxEFPlkvtyG0tM3D_QydF9Xbo_vpZQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1D2F9240064;
        Fri, 15 Jan 2021 03:11:45 -0500 (EST)
Subject: FAILED: patch "[PATCH] s390/qeth: fix locking for discipline setup / removal" failed to apply to 4.19-stable tree
To:     jwi@linux.ibm.com, kuba@kernel.org, wintera@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 15 Jan 2021 09:11:43 +0100
Message-ID: <1610698303251242@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

