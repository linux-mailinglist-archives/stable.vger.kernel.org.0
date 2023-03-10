Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15DA56B4842
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233670AbjCJPBJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:01:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233676AbjCJPAh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:00:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D2810BA55
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:54:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 446F9B82313
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:53:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ADEEC4339E;
        Fri, 10 Mar 2023 14:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460012;
        bh=+yEQro6507FlOq4dk459ISWZ2yhKUXyviZur1AlHFgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aSuxVOEnEIJfiiXtT2hyVKEd6TAuNMk4LdbMgY+KF7LT/Mo/WhPK/jVEH6/Z/7VpE
         MtcPvrGOqv/4Uw8abiylvzBaXlpHB8tJldTRGR83UNirAOLn5zT+s7tITvKUk4Ashq
         J7kaxM17+GcViviLfU4vKgJJWoD93nS2kwhL11d4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gu Shengxian <gushengxian@yulong.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 194/529] ASoC: atmel: fix spelling mistakes
Date:   Fri, 10 Mar 2023 14:35:37 +0100
Message-Id: <20230310133813.981618506@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Gu Shengxian <gushengxian@yulong.com>

[ Upstream commit 55233b22502151e0b2d9cc599e1ddf1f5584c87a ]

Fix some spelling mistakes as follows:
regaedles ==> regardless
prezent ==> present
underrrun ==> underrun
controlls ==> controls

Signed-off-by: Gu Shengxian <gushengxian@yulong.com>
Link: https://lore.kernel.org/r/20210706100230.32633-1-gushengxian507419@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: a4c4161d6eae ("ASoC: mchp-spdifrx: fix return value in case completion times out")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/atmel/mchp-spdifrx.c   | 6 +++---
 sound/soc/atmel/mchp-spdiftx.c   | 2 +-
 sound/soc/atmel/tse850-pcm5142.c | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/sound/soc/atmel/mchp-spdifrx.c b/sound/soc/atmel/mchp-spdifrx.c
index c83f32a462f63..3962ce00ad34a 100644
--- a/sound/soc/atmel/mchp-spdifrx.c
+++ b/sound/soc/atmel/mchp-spdifrx.c
@@ -56,7 +56,7 @@
 /* Validity Bit Mode */
 #define SPDIFRX_MR_VBMODE_MASK		GENAMSK(1, 1)
 #define SPDIFRX_MR_VBMODE_ALWAYS_LOAD \
-	(0 << 1)	/* Load sample regardles of validity bit value */
+	(0 << 1)	/* Load sample regardless of validity bit value */
 #define SPDIFRX_MR_VBMODE_DISCARD_IF_VB1 \
 	(1 << 1)	/* Load sample only if validity bit is 0 */
 
@@ -523,7 +523,7 @@ static int mchp_spdifrx_cs_get(struct mchp_spdifrx_dev *dev,
 	/* check for new data available */
 	ret = wait_for_completion_interruptible_timeout(&ch_stat->done,
 							msecs_to_jiffies(100));
-	/* IP might not be started or valid stream might not be prezent */
+	/* IP might not be started or valid stream might not be present */
 	if (ret < 0) {
 		dev_dbg(dev->dev, "channel status for channel %d timeout\n",
 			channel);
@@ -575,7 +575,7 @@ static int mchp_spdifrx_subcode_ch_get(struct mchp_spdifrx_dev *dev,
 	mchp_spdifrx_isr_blockend_en(dev);
 	ret = wait_for_completion_interruptible_timeout(&user_data->done,
 							msecs_to_jiffies(100));
-	/* IP might not be started or valid stream might not be prezent */
+	/* IP might not be started or valid stream might not be present */
 	if (ret <= 0) {
 		dev_dbg(dev->dev, "user data for channel %d timeout\n",
 			channel);
diff --git a/sound/soc/atmel/mchp-spdiftx.c b/sound/soc/atmel/mchp-spdiftx.c
index 0d2e3fa21519c..bcca1cf3cd7b6 100644
--- a/sound/soc/atmel/mchp-spdiftx.c
+++ b/sound/soc/atmel/mchp-spdiftx.c
@@ -80,7 +80,7 @@
 #define SPDIFTX_MR_VALID1			BIT(24)
 #define SPDIFTX_MR_VALID2			BIT(25)
 
-/* Disable Null Frame on underrrun */
+/* Disable Null Frame on underrun */
 #define SPDIFTX_MR_DNFR_MASK		GENMASK(27, 27)
 #define SPDIFTX_MR_DNFR_INVALID		(0 << 27)
 #define SPDIFTX_MR_DNFR_VALID		(1 << 27)
diff --git a/sound/soc/atmel/tse850-pcm5142.c b/sound/soc/atmel/tse850-pcm5142.c
index 59e2edb22b3ad..50c3dc6936f90 100644
--- a/sound/soc/atmel/tse850-pcm5142.c
+++ b/sound/soc/atmel/tse850-pcm5142.c
@@ -23,7 +23,7 @@
 //   IN2 +---o--+------------+--o---+ OUT2
 //               loop2 relays
 //
-// The 'loop1' gpio pin controlls two relays, which are either in loop
+// The 'loop1' gpio pin controls two relays, which are either in loop
 // position, meaning that input and output are directly connected, or
 // they are in mixer position, meaning that the signal is passed through
 // the 'Sum' mixer. Similarly for 'loop2'.
-- 
2.39.2



