Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A25AD6132F4
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 10:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiJaJnj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 31 Oct 2022 05:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbiJaJnh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 05:43:37 -0400
X-Greylist: delayed 217 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 31 Oct 2022 02:43:35 PDT
Received: from mail3.swissbit.com (mail3.swissbit.com [176.95.1.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7578B310;
        Mon, 31 Oct 2022 02:43:33 -0700 (PDT)
Received: from mail3.swissbit.com (localhost [127.0.0.1])
        by DDEI (Postfix) with ESMTP id 962AE462A31;
        Mon, 31 Oct 2022 10:39:54 +0100 (CET)
Received: from mail3.swissbit.com (localhost [127.0.0.1])
        by DDEI (Postfix) with ESMTP id 84AD546239D;
        Mon, 31 Oct 2022 10:39:54 +0100 (CET)
X-TM-AS-ERS: 10.149.2.42-127.5.254.253
X-TM-AS-SMTP: 1.0 ZXguc3dpc3NiaXQuY29t Y2xvZWhsZUBoeXBlcnN0b25lLmNvbQ==
X-DDEI-TLS-USAGE: Used
Received: from ex.swissbit.com (unknown [10.149.2.42])
        by mail3.swissbit.com (Postfix) with ESMTPS;
        Mon, 31 Oct 2022 10:39:54 +0100 (CET)
Received: from sbdeex04.sbitdom.lan (10.149.2.42) by sbdeex04.sbitdom.lan
 (10.149.2.42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.9; Mon, 31 Oct
 2022 10:39:54 +0100
Received: from sbdeex04.sbitdom.lan ([fe80::2047:4968:b5a0:1818]) by
 sbdeex04.sbitdom.lan ([fe80::2047:4968:b5a0:1818%9]) with mapi id
 15.02.1118.009; Mon, 31 Oct 2022 10:39:54 +0100
From:   =?iso-8859-1?Q?Christian_L=F6hle?= <CLoehle@hyperstone.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "ulf.hansson@linaro.org" <ulf.hansson@linaro.org>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Subject: [PATCH] mmc: block: Remove error check of hw_reset on reset
Thread-Topic: [PATCH] mmc: block: Remove error check of hw_reset on reset
Thread-Index: AdjtB5N3RFLjsOgLSduWNeZm5LNyqQ==
Date:   Mon, 31 Oct 2022 09:39:53 +0000
Message-ID: <0b965373ab0a4d35b0d98071a71fc304@hyperstone.com>
Accept-Language: en-US, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.242.2.56]
Content-Type: text/plain;
        charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-TMASE-Version: DDEI-5.1-9.0.1002-27234.006
X-TMASE-Result: 10-1.968300-10.000000
X-TMASE-MatchedRID: gIwa0kWWszJaLxCKnrw2Bx1qGr6sYOf/homn0bwgVmniKUaoIhea7Z7V
        Ny7+UW/97bSs17jHoll0Zb2MwG5IRayuICfJU1RUTuctSpiuWyUUi4Ehat05499RlPzeVuQQ1rP
        f5y//KwbXerHp2eyhCZlPyeZmj2J3GwMQULTXmK4gaafg6U60I8nlJe2gk8vIhzldYl+vKikNCN
        PJxA/UTwol8XYt5k6P6rDhzwOXTei/IFSslWntgQXtykVcrvpNN7FjQ+zMUh4RQQ4kFqjjJAZNL
        EcrBa0wVhkjuzbJwW5/JgN7Aw6tALVQu1GNZ+si4kYXbobxJbLyU/oX+tpNmPoLEnltozQnFxhm
        KBen8c2LkNbgO0LInr0EoIC23jYr9BbYEMZZ/LQ2RRIMOrvjaQ==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0
X-TMASE-INERTIA: 0-0;;;;
X-TMASE-XGENCLOUD: 8aa3821f-e3c3-45da-bca6-acf872f12220-0-0-200-0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 406e14808ee6 upstream

Before switching back to the right partition in mmc_blk_reset there used
to be a check if hw_reset was even supported. This return value
was removed, so there is no reason to check. Furthermore ensure
part_curr is not falsely set to a valid value on reset or
partition switch error.

As part of this change the code paths of mmc_blk_reset calls were checked
to ensure no commands are issued after a failed mmc_blk_reset directly
without going through the block layer.

Fixes: fefdd3c91e0a ("mmc: core: Drop superfluous validations in mmc_hw|sw_reset()")

Signed-off-by: Christian Loehle <cloehle@hyperstone.com>
---
 drivers/mmc/core/block.c | 44 ++++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 18 deletions(-)

diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index b2533be3a453..ed034b93cb25 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -133,6 +133,7 @@ struct mmc_blk_data {
 	 * track of the current selected device partition.
 	 */
 	unsigned int	part_curr;
+#define MMC_BLK_PART_INVALID	UINT_MAX	/* Unknown partition active */
 	int	area_type;
 
 	/* debugfs files (only in main mmc_blk_data) */
@@ -984,9 +985,16 @@ static unsigned int mmc_blk_data_timeout_ms(struct mmc_host *host,
 	return ms;
 }
 
+/*
+ * Attempts to reset the card and get back to the requested partition.
+ * Therefore any error here must result in cancelling the block layer
+ * request, it must not be reattempted without going through the mmc_blk
+ * partition sanity checks.
+ */
 static int mmc_blk_reset(struct mmc_blk_data *md, struct mmc_host *host,
 			 int type)
 {
+	struct mmc_blk_data *main_md = dev_get_drvdata(&host->card->dev);
 	int err;
 
 	if (md->reset_done & type)
@@ -994,23 +1002,22 @@ static int mmc_blk_reset(struct mmc_blk_data *md, struct mmc_host *host,
 
 	md->reset_done |= type;
 	err = mmc_hw_reset(host);
+	/*
+	 * A successful reset will leave the card in the main partition, but
+	 * upon failure it might not be, so set it to MMC_BLK_PART_INVALID
+	 * in that case.
+	 */
+	main_md->part_curr = err ? MMC_BLK_PART_INVALID : main_md->part_type;
+	if (err)
+		return err;
 	/* Ensure we switch back to the correct partition */
-	if (err) {
-		struct mmc_blk_data *main_md =
-			dev_get_drvdata(&host->card->dev);
-		int part_err;
-
-		main_md->part_curr = main_md->part_type;
-		part_err = mmc_blk_part_switch(host->card, md->part_type);
-		if (part_err) {
-			/*
-			 * We have failed to get back into the correct
-			 * partition, so we need to abort the whole request.
-			 */
-			return -ENODEV;
-		}
-	}
-	return err;
+	if (mmc_blk_part_switch(host->card, md->part_type))
+		/*
+		 * We have failed to get back into the correct
+		 * partition, so we need to abort the whole request.
+		 */
+		return -ENODEV;
+	return 0;
 }
 
 static inline void mmc_blk_reset_success(struct mmc_blk_data *md, int type)
@@ -1855,8 +1862,9 @@ static void mmc_blk_mq_rw_recovery(struct mmc_queue *mq, struct request *req)
 		return;
 
 	/* Reset before last retry */
-	if (mqrq->retries + 1 == MMC_MAX_RETRIES)
-		mmc_blk_reset(md, card->host, type);
+	if (mqrq->retries + 1 == MMC_MAX_RETRIES &&
+	    mmc_blk_reset(md, card->host, type))
+		return;
 
 	/* Command errors fail fast, so use all MMC_MAX_RETRIES */
 	if (brq->sbc.error || brq->cmd.error)
-- 
2.37.3

Hyperstone GmbH | Reichenaustr. 39a  | 78467 Konstanz
Managing Director: Dr. Jan Peter Berns.
Commercial register of local courts: Freiburg HRB381782

