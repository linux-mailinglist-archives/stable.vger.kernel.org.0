Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 464D352DCFC
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 20:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242753AbiESSpt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 14:45:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233931AbiESSps (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 14:45:48 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA5A8E03;
        Thu, 19 May 2022 11:45:45 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id u15so5838164pfi.3;
        Thu, 19 May 2022 11:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tqc9CjYXSuy6AdiCkGL4DWkq+ghQRYbszthnl1/c6ug=;
        b=DLosP//U/yqmP4buDsONCNH/Ob1xACs5t9tAIStn+sl0+Vi/cQtkNdAw+x3WcmXQ+2
         yPhSI9nOBaHVCutLBYmoQ/irIakkaWj8hA8+MINvPLi5cv0PvCcyMqLyHiMjxmrVyZmy
         d0QkWDkvXFb/iR22eStlHemj/L4Aka2U0cawm5mQbighGlwLrRvdfOqVt4ombvVowyIq
         8zTocD9IXxqfEqb3HyrP7e7Me8pd3u7ISA0TFmayH1NWrGol0qSqKEk54CdbRWhaV/5i
         kja38E9QmGuwpSTKFMm/cKRzeP7h/8USyS4BZjVeT9Tr0TbLdriqjJ9/z1/1BrSmXhH5
         4wRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tqc9CjYXSuy6AdiCkGL4DWkq+ghQRYbszthnl1/c6ug=;
        b=QhaC9/exJezP1OArtkO9ara+xngOa/PMq7Zie1Z8Wmu60mgf4OsZ5k32cjOq9Dze9n
         ConruTyQMZOXmWPEzaLj8IM+zu7RhAn1oQRj07j27KdlpHWKwP6jtEu3cZxWwvItKNFa
         rGgd98oI85ZQDx/Q5Eovl21I8FRo0mwQTza2P8QdewjBWUfE5HAqeh7KrYvHbNZAVaLR
         fCKR62tDEBbKAbSJYrtoFlzvpotAHyWzSh5WOna2YwRs2b8tO8QxVpBTOkTolHb9GSmI
         HjO3zpRabwk3SpFGNgE3VYePWjaGVTOlQK8WA3WBMnXu4d4tVnmLd45sKMHh49iCY/5V
         dojw==
X-Gm-Message-State: AOAM531aRLFaD73av5Q/Vnn0Z/liVmTUV5/jzD4WPzlJ2eqAajhNncDq
        9gmcJDyZ1EvEV4pkdJzNvthCN+TaRAY=
X-Google-Smtp-Source: ABdhPJynkSnH8pHBmbNKiNxYCNpc7fxmj6jYs7F2C5z8LeHEfuohaVMAWE27vylvVZpTfsJz6XpUTw==
X-Received: by 2002:a63:2057:0:b0:3f5:fd47:754f with SMTP id r23-20020a632057000000b003f5fd47754fmr5088566pgm.440.1652985944926;
        Thu, 19 May 2022 11:45:44 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5-20020aa79245000000b0050dc76281c2sm2965pfp.156.2022.05.19.11.45.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 11:45:44 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Nishad Kamdar <nishadkamdar@gmail.com>,
        =?UTF-8?q?Christian=20L=C3=B6hle?= <CLoehle@hyperstone.com>,
        linux-mmc@vger.kernel.org (open list:MULTIMEDIA CARD (MMC), SECURE
        DIGITAL (SD) AND...), linux-kernel@vger.kernel.org (open list),
        alcooperx@gmail.com, kdasu.kdev@gmail.com
Subject: [PATCH stable 4.19 v2 1/4] mmc: core: Cleanup BKOPS support
Date:   Thu, 19 May 2022 11:45:33 -0700
Message-Id: <20220519184536.370540-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220519184536.370540-1-f.fainelli@gmail.com>
References: <20220519184536.370540-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

commit 0c204979c691f05666ecfb74501e7adfdde8fbf9 upstream

It's been ~6 years ago since we introduced the BKOPS support for eMMC
cards. The current code is a bit messy and primarily that's because it
prepares to support running BKOPS in an asynchronous mode. However, that
mode has never been fully implemented/enabled. Instead BKOPS is always
executed in synchronously, when the card has reported an urgent BKOPS
level.

For these reasons, let's make the code more readable by dropping the unused
parts. Let's also rename mmc_start_bkops() to mmc_run_bkops(), as to make
it more descriptive.

Cc: Jaehoon Chung <jh80.chung@samsung.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/mmc/core/block.c   |  2 +-
 drivers/mmc/core/card.h    |  6 +--
 drivers/mmc/core/mmc.c     |  6 ---
 drivers/mmc/core/mmc_ops.c | 87 ++++++++------------------------------
 drivers/mmc/core/mmc_ops.h |  3 +-
 5 files changed, 21 insertions(+), 83 deletions(-)

diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index 630f3bcba56d..d8bcf1e0b337 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -1944,7 +1944,7 @@ static void mmc_blk_urgent_bkops(struct mmc_queue *mq,
 				 struct mmc_queue_req *mqrq)
 {
 	if (mmc_blk_urgent_bkops_needed(mq, mqrq))
-		mmc_start_bkops(mq->card, true);
+		mmc_run_bkops(mq->card);
 }
 
 void mmc_blk_mq_complete(struct request *req)
diff --git a/drivers/mmc/core/card.h b/drivers/mmc/core/card.h
index 1170feb8f969..eef301452406 100644
--- a/drivers/mmc/core/card.h
+++ b/drivers/mmc/core/card.h
@@ -23,15 +23,13 @@
 #define MMC_STATE_BLOCKADDR	(1<<2)		/* card uses block-addressing */
 #define MMC_CARD_SDXC		(1<<3)		/* card is SDXC */
 #define MMC_CARD_REMOVED	(1<<4)		/* card has been removed */
-#define MMC_STATE_DOING_BKOPS	(1<<5)		/* card is doing BKOPS */
-#define MMC_STATE_SUSPENDED	(1<<6)		/* card is suspended */
+#define MMC_STATE_SUSPENDED	(1<<5)		/* card is suspended */
 
 #define mmc_card_present(c)	((c)->state & MMC_STATE_PRESENT)
 #define mmc_card_readonly(c)	((c)->state & MMC_STATE_READONLY)
 #define mmc_card_blockaddr(c)	((c)->state & MMC_STATE_BLOCKADDR)
 #define mmc_card_ext_capacity(c) ((c)->state & MMC_CARD_SDXC)
 #define mmc_card_removed(c)	((c) && ((c)->state & MMC_CARD_REMOVED))
-#define mmc_card_doing_bkops(c)	((c)->state & MMC_STATE_DOING_BKOPS)
 #define mmc_card_suspended(c)	((c)->state & MMC_STATE_SUSPENDED)
 
 #define mmc_card_set_present(c)	((c)->state |= MMC_STATE_PRESENT)
@@ -39,8 +37,6 @@
 #define mmc_card_set_blockaddr(c) ((c)->state |= MMC_STATE_BLOCKADDR)
 #define mmc_card_set_ext_capacity(c) ((c)->state |= MMC_CARD_SDXC)
 #define mmc_card_set_removed(c) ((c)->state |= MMC_CARD_REMOVED)
-#define mmc_card_set_doing_bkops(c)	((c)->state |= MMC_STATE_DOING_BKOPS)
-#define mmc_card_clr_doing_bkops(c)	((c)->state &= ~MMC_STATE_DOING_BKOPS)
 #define mmc_card_set_suspended(c) ((c)->state |= MMC_STATE_SUSPENDED)
 #define mmc_card_clr_suspended(c) ((c)->state &= ~MMC_STATE_SUSPENDED)
 
diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index d9202f2726d1..745a4b07faff 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -2026,12 +2026,6 @@ static int _mmc_suspend(struct mmc_host *host, bool is_suspend)
 	if (mmc_card_suspended(host->card))
 		goto out;
 
-	if (mmc_card_doing_bkops(host->card)) {
-		err = mmc_stop_bkops(host->card);
-		if (err)
-			goto out;
-	}
-
 	err = mmc_flush_cache(host->card);
 	if (err)
 		goto out;
diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
index 334678707deb..6d759fc6165d 100644
--- a/drivers/mmc/core/mmc_ops.c
+++ b/drivers/mmc/core/mmc_ops.c
@@ -899,34 +899,6 @@ int mmc_can_ext_csd(struct mmc_card *card)
 	return (card && card->csd.mmca_vsn > CSD_SPEC_VER_3);
 }
 
-/**
- *	mmc_stop_bkops - stop ongoing BKOPS
- *	@card: MMC card to check BKOPS
- *
- *	Send HPI command to stop ongoing background operations to
- *	allow rapid servicing of foreground operations, e.g. read/
- *	writes. Wait until the card comes out of the programming state
- *	to avoid errors in servicing read/write requests.
- */
-int mmc_stop_bkops(struct mmc_card *card)
-{
-	int err = 0;
-
-	err = mmc_interrupt_hpi(card);
-
-	/*
-	 * If err is EINVAL, we can't issue an HPI.
-	 * It should complete the BKOPS.
-	 */
-	if (!err || (err == -EINVAL)) {
-		mmc_card_clr_doing_bkops(card);
-		mmc_retune_release(card->host);
-		err = 0;
-	}
-
-	return err;
-}
-
 static int mmc_read_bkops_status(struct mmc_card *card)
 {
 	int err;
@@ -943,22 +915,17 @@ static int mmc_read_bkops_status(struct mmc_card *card)
 }
 
 /**
- *	mmc_start_bkops - start BKOPS for supported cards
- *	@card: MMC card to start BKOPS
- *	@from_exception: A flag to indicate if this function was
- *			 called due to an exception raised by the card
+ *	mmc_run_bkops - Run BKOPS for supported cards
+ *	@card: MMC card to run BKOPS for
  *
- *	Start background operations whenever requested.
- *	When the urgent BKOPS bit is set in a R1 command response
- *	then background operations should be started immediately.
+ *	Run background operations synchronously for cards having manual BKOPS
+ *	enabled and in case it reports urgent BKOPS level.
 */
-void mmc_start_bkops(struct mmc_card *card, bool from_exception)
+void mmc_run_bkops(struct mmc_card *card)
 {
 	int err;
-	int timeout;
-	bool use_busy_signal;
 
-	if (!card->ext_csd.man_bkops_en || mmc_card_doing_bkops(card))
+	if (!card->ext_csd.man_bkops_en)
 		return;
 
 	err = mmc_read_bkops_status(card);
@@ -968,44 +935,26 @@ void mmc_start_bkops(struct mmc_card *card, bool from_exception)
 		return;
 	}
 
-	if (!card->ext_csd.raw_bkops_status)
+	if (!card->ext_csd.raw_bkops_status ||
+	    card->ext_csd.raw_bkops_status < EXT_CSD_BKOPS_LEVEL_2)
 		return;
 
-	if (card->ext_csd.raw_bkops_status < EXT_CSD_BKOPS_LEVEL_2 &&
-	    from_exception)
-		return;
-
-	if (card->ext_csd.raw_bkops_status >= EXT_CSD_BKOPS_LEVEL_2) {
-		timeout = MMC_OPS_TIMEOUT_MS;
-		use_busy_signal = true;
-	} else {
-		timeout = 0;
-		use_busy_signal = false;
-	}
-
 	mmc_retune_hold(card->host);
 
-	err = __mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
-			EXT_CSD_BKOPS_START, 1, timeout, 0,
-			use_busy_signal, true, false);
-	if (err) {
+	/*
+	 * For urgent BKOPS status, LEVEL_2 and higher, let's execute
+	 * synchronously. Future wise, we may consider to start BKOPS, for less
+	 * urgent levels by using an asynchronous background task, when idle.
+	 */
+	err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
+			EXT_CSD_BKOPS_START, 1, MMC_OPS_TIMEOUT_MS);
+	if (err)
 		pr_warn("%s: Error %d starting bkops\n",
 			mmc_hostname(card->host), err);
-		mmc_retune_release(card->host);
-		return;
-	}
 
-	/*
-	 * For urgent bkops status (LEVEL_2 and more)
-	 * bkops executed synchronously, otherwise
-	 * the operation is in progress
-	 */
-	if (!use_busy_signal)
-		mmc_card_set_doing_bkops(card);
-	else
-		mmc_retune_release(card->host);
+	mmc_retune_release(card->host);
 }
-EXPORT_SYMBOL(mmc_start_bkops);
+EXPORT_SYMBOL(mmc_run_bkops);
 
 /*
  * Flush the cache to the non-volatile storage.
diff --git a/drivers/mmc/core/mmc_ops.h b/drivers/mmc/core/mmc_ops.h
index a1390d486381..018a5e3f66d6 100644
--- a/drivers/mmc/core/mmc_ops.h
+++ b/drivers/mmc/core/mmc_ops.h
@@ -40,8 +40,7 @@ int __mmc_switch(struct mmc_card *card, u8 set, u8 index, u8 value,
 		bool use_busy_signal, bool send_status,	bool retry_crc_err);
 int mmc_switch(struct mmc_card *card, u8 set, u8 index, u8 value,
 		unsigned int timeout_ms);
-int mmc_stop_bkops(struct mmc_card *card);
-void mmc_start_bkops(struct mmc_card *card, bool from_exception);
+void mmc_run_bkops(struct mmc_card *card);
 int mmc_flush_cache(struct mmc_card *card);
 int mmc_cmdq_enable(struct mmc_card *card);
 int mmc_cmdq_disable(struct mmc_card *card);
-- 
2.25.1

