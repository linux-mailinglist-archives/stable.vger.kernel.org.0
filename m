Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E989B3766B6
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 16:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237418AbhEGOGa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 10:06:30 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:49295 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237438AbhEGOGZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 10:06:25 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id C05DE1941BFA;
        Fri,  7 May 2021 10:05:24 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 07 May 2021 10:05:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=VmQk8Z
        avnQnUKKoR6Cw5hDcbQMd1XIG8XEPMVelmAw8=; b=iPSO5W8iMKMPf8G5cbtLAx
        4O2X4lwgKh4/Jeox2PUlVApivxf3iwQYYHAWexjjrnQREGsS7AHQVMOJtHBDt1Fy
        PNZJFRExrY/EELg57bAzTb1tdb2fIy5zXk72ohVHivq+OraMIrkQNuV7HMkCqq2S
        /jfo5FSJcVgNAXjvPtSvOA4ig47QG34y3+nw4y4WVtVjG9riOaWbzCfMDZTCzBhf
        97WIkaILj08F2af/i+zIMNt69xgmR90D5afKtylvpS/suPOhH1fITdpf07rL2e3w
        cIgOkbs04muc5b4ZQ4bDunrRo79CBuV63JcFFdGSdyLw5YElvz1HwrLkmaGk2OXQ
        ==
X-ME-Sender: <xms:JEmVYIZ2EWxKLd84-LNb7YDLDaJdLMsaZIgwaiugKmCQsPgyMxmQqA>
    <xme:JEmVYDb3aXOjZlkXbrFC-8b4G85p5w5z9Wwap9luLmgRVmh2jROFJM8g5qw6vw0D0
    nbOr_cwLJTihg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegvddgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:JEmVYC8eYQnYwim7u-ylpnPcC3urxe6ULEQK_KUm5oIaG3CsRN4QiA>
    <xmx:JEmVYCqArxn_pewj-zZgTDIgRTB93gFNj7rBXFY-4sm8Cyu3_0Z9_A>
    <xmx:JEmVYDoS22sH_YTEFNueoUnX2xa5pl3Nt21yxwJXMpK9m-ozjmNRCA>
    <xmx:JEmVYMCmogegudk_XiujDpIv4JVhqK8gwkO7jdwFFmUB_ao2l92aag>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Fri,  7 May 2021 10:05:23 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mmc: core: Fix hanging on I/O during system suspend for" failed to apply to 4.14-stable tree
To:     ulf.hansson@linaro.org, kwmad.kim@samsung.com,
        linus.walleij@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 07 May 2021 16:05:21 +0200
Message-ID: <1620396321137176@kroah.com>
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

From 17a17bf50612e6048a9975450cf1bd30f93815b5 Mon Sep 17 00:00:00 2001
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Wed, 10 Mar 2021 16:29:00 +0100
Subject: [PATCH] mmc: core: Fix hanging on I/O during system suspend for
 removable cards

The mmc core uses a PM notifier to temporarily during system suspend, turn
off the card detection mechanism for removal/insertion of (e)MMC/SD/SDIO
cards. Additionally, the notifier may be used to remove an SDIO card
entirely, if a corresponding SDIO functional driver don't have the system
suspend/resume callbacks assigned. This behaviour has been around for a
very long time.

However, a recent bug report tells us there are problems with this
approach. More precisely, when receiving the PM_SUSPEND_PREPARE
notification, we may end up hanging on I/O to be completed, thus also
preventing the system from getting suspended.

In the end what happens, is that the cancel_delayed_work_sync() in
mmc_pm_notify() ends up waiting for mmc_rescan() to complete - and since
mmc_rescan() wants to claim the host, it needs to wait for the I/O to be
completed first.

Typically, this problem is triggered in Android, if there is ongoing I/O
while the user decides to suspend, resume and then suspend the system
again. This due to that after the resume, an mmc_rescan() work gets punted
to the workqueue, which job is to verify that the card remains inserted
after the system has resumed.

To fix this problem, userspace needs to become frozen to suspend the I/O,
prior to turning off the card detection mechanism. Therefore, let's drop
the PM notifiers for mmc subsystem altogether and rely on the card
detection to be turned off/on as a part of the system_freezable_wq, that we
are already using.

Moreover, to allow and SDIO card to be removed during system suspend, let's
manage this from a ->prepare() callback, assigned at the mmc_host_class
level. In this way, we can use the parent device (the mmc_host_class
device), to remove the card device that is the child, in the
device_prepare() phase.

Reported-by: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: stable@vger.kernel.org # v4.5+
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20210310152900.149380-1-ulf.hansson@linaro.org
Reviewed-by: Kiwoong Kim <kwmad.kim@samsung.com>

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 9c13f7a52699..f194940c5974 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -2269,80 +2269,6 @@ void mmc_stop_host(struct mmc_host *host)
 	mmc_release_host(host);
 }
 
-#ifdef CONFIG_PM_SLEEP
-/* Do the card removal on suspend if card is assumed removeable
- * Do that in pm notifier while userspace isn't yet frozen, so we will be able
-   to sync the card.
-*/
-static int mmc_pm_notify(struct notifier_block *notify_block,
-			unsigned long mode, void *unused)
-{
-	struct mmc_host *host = container_of(
-		notify_block, struct mmc_host, pm_notify);
-	unsigned long flags;
-	int err = 0;
-
-	switch (mode) {
-	case PM_HIBERNATION_PREPARE:
-	case PM_SUSPEND_PREPARE:
-	case PM_RESTORE_PREPARE:
-		spin_lock_irqsave(&host->lock, flags);
-		host->rescan_disable = 1;
-		spin_unlock_irqrestore(&host->lock, flags);
-		cancel_delayed_work_sync(&host->detect);
-
-		if (!host->bus_ops)
-			break;
-
-		/* Validate prerequisites for suspend */
-		if (host->bus_ops->pre_suspend)
-			err = host->bus_ops->pre_suspend(host);
-		if (!err)
-			break;
-
-		if (!mmc_card_is_removable(host)) {
-			dev_warn(mmc_dev(host),
-				 "pre_suspend failed for non-removable host: "
-				 "%d\n", err);
-			/* Avoid removing non-removable hosts */
-			break;
-		}
-
-		/* Calling bus_ops->remove() with a claimed host can deadlock */
-		host->bus_ops->remove(host);
-		mmc_claim_host(host);
-		mmc_detach_bus(host);
-		mmc_power_off(host);
-		mmc_release_host(host);
-		host->pm_flags = 0;
-		break;
-
-	case PM_POST_SUSPEND:
-	case PM_POST_HIBERNATION:
-	case PM_POST_RESTORE:
-
-		spin_lock_irqsave(&host->lock, flags);
-		host->rescan_disable = 0;
-		spin_unlock_irqrestore(&host->lock, flags);
-		_mmc_detect_change(host, 0, false);
-
-	}
-
-	return 0;
-}
-
-void mmc_register_pm_notifier(struct mmc_host *host)
-{
-	host->pm_notify.notifier_call = mmc_pm_notify;
-	register_pm_notifier(&host->pm_notify);
-}
-
-void mmc_unregister_pm_notifier(struct mmc_host *host)
-{
-	unregister_pm_notifier(&host->pm_notify);
-}
-#endif
-
 static int __init mmc_init(void)
 {
 	int ret;
diff --git a/drivers/mmc/core/core.h b/drivers/mmc/core/core.h
index 575ac0257af2..8032451abaea 100644
--- a/drivers/mmc/core/core.h
+++ b/drivers/mmc/core/core.h
@@ -93,14 +93,6 @@ int mmc_execute_tuning(struct mmc_card *card);
 int mmc_hs200_to_hs400(struct mmc_card *card);
 int mmc_hs400_to_hs200(struct mmc_card *card);
 
-#ifdef CONFIG_PM_SLEEP
-void mmc_register_pm_notifier(struct mmc_host *host);
-void mmc_unregister_pm_notifier(struct mmc_host *host);
-#else
-static inline void mmc_register_pm_notifier(struct mmc_host *host) { }
-static inline void mmc_unregister_pm_notifier(struct mmc_host *host) { }
-#endif
-
 void mmc_wait_for_req_done(struct mmc_host *host, struct mmc_request *mrq);
 bool mmc_is_req_done(struct mmc_host *host, struct mmc_request *mrq);
 
diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index 9b89a91b6b47..fe05b3645fe9 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -35,6 +35,42 @@
 
 static DEFINE_IDA(mmc_host_ida);
 
+#ifdef CONFIG_PM_SLEEP
+static int mmc_host_class_prepare(struct device *dev)
+{
+	struct mmc_host *host = cls_dev_to_mmc_host(dev);
+
+	/*
+	 * It's safe to access the bus_ops pointer, as both userspace and the
+	 * workqueue for detecting cards are frozen at this point.
+	 */
+	if (!host->bus_ops)
+		return 0;
+
+	/* Validate conditions for system suspend. */
+	if (host->bus_ops->pre_suspend)
+		return host->bus_ops->pre_suspend(host);
+
+	return 0;
+}
+
+static void mmc_host_class_complete(struct device *dev)
+{
+	struct mmc_host *host = cls_dev_to_mmc_host(dev);
+
+	_mmc_detect_change(host, 0, false);
+}
+
+static const struct dev_pm_ops mmc_host_class_dev_pm_ops = {
+	.prepare = mmc_host_class_prepare,
+	.complete = mmc_host_class_complete,
+};
+
+#define MMC_HOST_CLASS_DEV_PM_OPS (&mmc_host_class_dev_pm_ops)
+#else
+#define MMC_HOST_CLASS_DEV_PM_OPS NULL
+#endif
+
 static void mmc_host_classdev_release(struct device *dev)
 {
 	struct mmc_host *host = cls_dev_to_mmc_host(dev);
@@ -46,6 +82,7 @@ static void mmc_host_classdev_release(struct device *dev)
 static struct class mmc_host_class = {
 	.name		= "mmc_host",
 	.dev_release	= mmc_host_classdev_release,
+	.pm		= MMC_HOST_CLASS_DEV_PM_OPS,
 };
 
 int mmc_register_host_class(void)
@@ -538,8 +575,6 @@ int mmc_add_host(struct mmc_host *host)
 #endif
 
 	mmc_start_host(host);
-	mmc_register_pm_notifier(host);
-
 	return 0;
 }
 
@@ -555,7 +590,6 @@ EXPORT_SYMBOL(mmc_add_host);
  */
 void mmc_remove_host(struct mmc_host *host)
 {
-	mmc_unregister_pm_notifier(host);
 	mmc_stop_host(host);
 
 #ifdef CONFIG_DEBUG_FS
diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index 0fda7784cab2..3eb94ac2712e 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -985,21 +985,37 @@ static void mmc_sdio_detect(struct mmc_host *host)
  */
 static int mmc_sdio_pre_suspend(struct mmc_host *host)
 {
-	int i, err = 0;
+	int i;
 
 	for (i = 0; i < host->card->sdio_funcs; i++) {
 		struct sdio_func *func = host->card->sdio_func[i];
 		if (func && sdio_func_present(func) && func->dev.driver) {
 			const struct dev_pm_ops *pmops = func->dev.driver->pm;
-			if (!pmops || !pmops->suspend || !pmops->resume) {
+			if (!pmops || !pmops->suspend || !pmops->resume)
 				/* force removal of entire card in that case */
-				err = -ENOSYS;
-				break;
-			}
+				goto remove;
 		}
 	}
 
-	return err;
+	return 0;
+
+remove:
+	if (!mmc_card_is_removable(host)) {
+		dev_warn(mmc_dev(host),
+			 "missing suspend/resume ops for non-removable SDIO card\n");
+		/* Don't remove a non-removable card - we can't re-detect it. */
+		return 0;
+	}
+
+	/* Remove the SDIO card and let it be re-detected later on. */
+	mmc_sdio_remove(host);
+	mmc_claim_host(host);
+	mmc_detach_bus(host);
+	mmc_power_off(host);
+	mmc_release_host(host);
+	host->pm_flags = 0;
+
+	return 0;
 }
 
 /*
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index a001ad2f5f23..17d7b326af29 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -302,9 +302,6 @@ struct mmc_host {
 	u32			ocr_avail_sdio;	/* SDIO-specific OCR */
 	u32			ocr_avail_sd;	/* SD-specific OCR */
 	u32			ocr_avail_mmc;	/* MMC-specific OCR */
-#ifdef CONFIG_PM_SLEEP
-	struct notifier_block	pm_notify;
-#endif
 	struct wakeup_source	*ws;		/* Enable consume of uevents */
 	u32			max_current_330;
 	u32			max_current_300;

