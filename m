Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 046902E363A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 12:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727231AbgL1LMq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 06:12:46 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:56381 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727224AbgL1LMq (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 28 Dec 2020 06:12:46 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 9C6937F4;
        Mon, 28 Dec 2020 06:11:40 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 06:11:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=XL1pU9
        Ny+XnUc4D6yj05nIDhuXsxrUtQ0RWV/vqTnjY=; b=mV8Jzcf1FLgiX4QH3LkmDr
        3wfRXlJgbMha/29AeXYzDEUHiWj3xVO2MhW3tOVEndvXnbDQxiN0E7t6YSjYNtfl
        5doQeBqImTHuUL6Ss8y79N+5xC8074I4Pp2s/66ZjL1VTUBdVT1aCaJMmbZmDZ2P
        Nu9Z6qv3TpjIheBNeRiZOeFmilPaF2f7A6LYJmMu16Cg+Jr17RLm2fGLnza5GMwn
        fWrn/3KFz4Qqi1lB1NGVoFki9pQhcUoW3Hs5hCcq1rPcopSJqwSFqTT6rpcpw/B5
        /hDZGo53ihsGJ6YFY9Ax9Wh2jnaKfnSeIaSo4LlNDWseg90OYkY2ACANaChDe7ug
        ==
X-ME-Sender: <xms:bL3pX4gbA05LZs0gjl4PTlVejzH7-3ImnU8u2R2UDlMi2OGtKR2gOA>
    <xme:bL3pXxAFZZux3fra_m_fgGUKOnnY6qVdTy8XpNFn8dC2dxSO-8VrC7QoTRM4f8hQM
    pquQpmBOzwvtQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgvdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeegnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:bL3pXwHgr25wDnDcbOjXM1_jI0-bF50Q1OfVYl7y1E-IgDBnUxOQdg>
    <xmx:bL3pX5Sy8sde3wKJR-Q213x4qhulrX8M775_g_SfLc3umGHZ6iME6A>
    <xmx:bL3pX1zFemPqoI72tIhHu8C7Zd1YmXJDz41QdsGJWkzOUYTvd_swgw>
    <xmx:bL3pXzacPqind6hrLEe0BqZy_omTjtDMqn75IiRrlIFAifkWT1vzMGA31dk>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id A51851080067;
        Mon, 28 Dec 2020 06:11:39 -0500 (EST)
Subject: FAILED: patch "[PATCH] iio: imu: st_lsm6dsx: fix edge-trigger interrupts" failed to apply to 5.4-stable tree
To:     lorenzo@kernel.org, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 12:12:55 +0100
Message-ID: <1609153975178175@kroah.com>
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

From 3f9bce7a22a3f8ac9d885c9d75bc45569f24ac8b Mon Sep 17 00:00:00 2001
From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Sat, 14 Nov 2020 19:39:05 +0100
Subject: [PATCH] iio: imu: st_lsm6dsx: fix edge-trigger interrupts

If we are using edge IRQs, new samples can arrive while processing
current interrupt since there are no hw guarantees the irq line
stays "low" long enough to properly detect the new interrupt.
In this case the new sample will be missed.
Polling FIFO status register in st_lsm6dsx_handler_thread routine
allow us to read new samples even if the interrupt arrives while
processing previous data and the timeslot where the line is "low"
is too short to be properly detected.

Fixes: 89ca88a7cdf2 ("iio: imu: st_lsm6dsx: support active-low interrupts")
Fixes: 290a6ce11d93 ("iio: imu: add support to lsm6dsx driver")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://lore.kernel.org/r/5e93cda7dc1e665f5685c53ad8e9ea71dbae782d.1605378871.git.lorenzo@kernel.org
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
index 467214e2e77c..7cedaab096a7 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
@@ -2069,19 +2069,35 @@ st_lsm6dsx_report_motion_event(struct st_lsm6dsx_hw *hw)
 static irqreturn_t st_lsm6dsx_handler_thread(int irq, void *private)
 {
 	struct st_lsm6dsx_hw *hw = private;
+	int fifo_len = 0, len;
 	bool event;
-	int count;
 
 	event = st_lsm6dsx_report_motion_event(hw);
 
 	if (!hw->settings->fifo_ops.read_fifo)
 		return event ? IRQ_HANDLED : IRQ_NONE;
 
-	mutex_lock(&hw->fifo_lock);
-	count = hw->settings->fifo_ops.read_fifo(hw);
-	mutex_unlock(&hw->fifo_lock);
+	/*
+	 * If we are using edge IRQs, new samples can arrive while
+	 * processing current interrupt since there are no hw
+	 * guarantees the irq line stays "low" long enough to properly
+	 * detect the new interrupt. In this case the new sample will
+	 * be missed.
+	 * Polling FIFO status register allow us to read new
+	 * samples even if the interrupt arrives while processing
+	 * previous data and the timeslot where the line is "low" is
+	 * too short to be properly detected.
+	 */
+	do {
+		mutex_lock(&hw->fifo_lock);
+		len = hw->settings->fifo_ops.read_fifo(hw);
+		mutex_unlock(&hw->fifo_lock);
+
+		if (len > 0)
+			fifo_len += len;
+	} while (len > 0);
 
-	return count || event ? IRQ_HANDLED : IRQ_NONE;
+	return fifo_len || event ? IRQ_HANDLED : IRQ_NONE;
 }
 
 static int st_lsm6dsx_irq_setup(struct st_lsm6dsx_hw *hw)

