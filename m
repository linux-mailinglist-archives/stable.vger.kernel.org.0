Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4412F7674
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 11:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbhAOKRg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 05:17:36 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:43151 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726210AbhAOKRf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 05:17:35 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 918DB19C3D22;
        Fri, 15 Jan 2021 05:16:49 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 15 Jan 2021 05:16:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=INkkVM
        db3XwB2YU7z1XrrM6uE1Ew/XjGhkqFg027D88=; b=lNr1ugC/K2TB4bn8WSFGLZ
        JI65Ns2XWapBIQ0cxaTYQSEYuSSh9ymf9bra130U7HCaYmY/SyZBrtueTFgR5h9K
        wWI5L51gV13FrmPHfixg4fbDegBKHjiyq65PURCb9N500FU/sDB+r35pLVWudU1j
        MEySuiTK8gmtnyjJ6BfeFlJdya/UFc4Wmpw5KGwmL7Dzr2mIC0x0VLIP1LfivNv3
        f16aXf10nkaVsZRVdr91M0BrSb19GUOrdnFJMsYXZ7WPLENRgvCdrrxJSTXFTD5q
        0UksahYwKdhMo6ToMaoJKFKJpPhmYy0FYZ5SCMTA41domWNYx9Ie4j476ry1MmMQ
        ==
X-ME-Sender: <xms:kWsBYKROnWF5F7nyis-nutnr-VQ6EZHhe-Vf2icHKjFQIiaZtByYwg>
    <xme:kWsBYPzvx-Me7EorQELbTRhof2J8NKHAjMaH0JmDhG0XShl1YggQYV9OB9-pwwGHw
    84uWJsMXXTibg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtddugddugeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:kWsBYH3ubVlxY2x_HHsk_BrNSPyqWH1r6BU_HWNZAF1QK_ymxhALgA>
    <xmx:kWsBYGBFMl5mpVGryrgapf2vf3uyTOnR2RBXoaE_DNsXASvMvw3FDQ>
    <xmx:kWsBYDiOf7bPejBGbx-ZO3blFLGMdSoIpjg8GEKjU0C1emVje6vtoA>
    <xmx:kWsBYLacyB_avOo6IOBqvKLyiZF_iC76bx7AEHcwzy4rrJcPRVJN0g>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 248F8240057;
        Fri, 15 Jan 2021 05:16:49 -0500 (EST)
Subject: FAILED: patch "[PATCH] spi: spi-geni-qcom: Fail new xfers if xfer/cancel/abort" failed to apply to 5.4-stable tree
To:     dianders@chromium.org, broonie@kernel.org, swboyd@chromium.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 15 Jan 2021 11:16:47 +0100
Message-ID: <1610705807154191@kroah.com>
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

From 690d8b917bbe64772cb0b652311bcd50908aea6b Mon Sep 17 00:00:00 2001
From: Douglas Anderson <dianders@chromium.org>
Date: Thu, 17 Dec 2020 14:29:12 -0800
Subject: [PATCH] spi: spi-geni-qcom: Fail new xfers if xfer/cancel/abort
 pending

If we got a timeout when trying to send an abort command then it means
that we just got 3 timeouts in a row:

1. The original timeout that caused handle_fifo_timeout() to be
   called.
2. A one second timeout waiting for the cancel command to finish.
3. A one second timeout waiting for the abort command to finish.

SPI is clocked by the controller, so nothing (aside from a hardware
fault or a totally broken sequencer) should be causing the actual
commands to fail in hardware.  However, even though the hardware
itself is not expected to fail (and it'd be hard to predict how we
should handle things if it did), it's easy to hit the timeout case by
simply blocking our interrupt handler from running for a long period
of time.  Obviously the system is in pretty bad shape if a interrupt
handler is blocked for > 2 seconds, but there are certainly bugs (even
bugs in other unrelated drivers) that can make this happen.

Let's make things a bit more robust against this case.  If we fail to
abort we'll set a flag and then we'll block all future transfers until
we have no more interrupts pending.

Fixes: 561de45f72bd ("spi: spi-geni-qcom: Add SPI driver support for GENI based QUP")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20201217142842.v3.2.Ibade998ed587e070388b4bf58801f1107a40eb53@changeid
Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/drivers/spi/spi-geni-qcom.c b/drivers/spi/spi-geni-qcom.c
index 096edfbde451..32c053705dec 100644
--- a/drivers/spi/spi-geni-qcom.c
+++ b/drivers/spi/spi-geni-qcom.c
@@ -83,6 +83,7 @@ struct spi_geni_master {
 	spinlock_t lock;
 	int irq;
 	bool cs_flag;
+	bool abort_failed;
 };
 
 static int get_spi_clk_cfg(unsigned int speed_hz,
@@ -141,8 +142,49 @@ static void handle_fifo_timeout(struct spi_master *spi,
 	spin_unlock_irq(&mas->lock);
 
 	time_left = wait_for_completion_timeout(&mas->abort_done, HZ);
-	if (!time_left)
+	if (!time_left) {
 		dev_err(mas->dev, "Failed to cancel/abort m_cmd\n");
+
+		/*
+		 * No need for a lock since SPI core has a lock and we never
+		 * access this from an interrupt.
+		 */
+		mas->abort_failed = true;
+	}
+}
+
+static bool spi_geni_is_abort_still_pending(struct spi_geni_master *mas)
+{
+	struct geni_se *se = &mas->se;
+	u32 m_irq, m_irq_en;
+
+	if (!mas->abort_failed)
+		return false;
+
+	/*
+	 * The only known case where a transfer times out and then a cancel
+	 * times out then an abort times out is if something is blocking our
+	 * interrupt handler from running.  Avoid starting any new transfers
+	 * until that sorts itself out.
+	 */
+	spin_lock_irq(&mas->lock);
+	m_irq = readl(se->base + SE_GENI_M_IRQ_STATUS);
+	m_irq_en = readl(se->base + SE_GENI_M_IRQ_EN);
+	spin_unlock_irq(&mas->lock);
+
+	if (m_irq & m_irq_en) {
+		dev_err(mas->dev, "Interrupts pending after abort: %#010x\n",
+			m_irq & m_irq_en);
+		return true;
+	}
+
+	/*
+	 * If we're here the problem resolved itself so no need to check more
+	 * on future transfers.
+	 */
+	mas->abort_failed = false;
+
+	return false;
 }
 
 static void spi_geni_set_cs(struct spi_device *slv, bool set_flag)
@@ -158,9 +200,15 @@ static void spi_geni_set_cs(struct spi_device *slv, bool set_flag)
 	if (set_flag == mas->cs_flag)
 		return;
 
+	pm_runtime_get_sync(mas->dev);
+
+	if (spi_geni_is_abort_still_pending(mas)) {
+		dev_err(mas->dev, "Can't set chip select\n");
+		goto exit;
+	}
+
 	mas->cs_flag = set_flag;
 
-	pm_runtime_get_sync(mas->dev);
 	spin_lock_irq(&mas->lock);
 	reinit_completion(&mas->cs_done);
 	if (set_flag)
@@ -173,6 +221,7 @@ static void spi_geni_set_cs(struct spi_device *slv, bool set_flag)
 	if (!time_left)
 		handle_fifo_timeout(spi, NULL);
 
+exit:
 	pm_runtime_put(mas->dev);
 }
 
@@ -280,6 +329,9 @@ static int spi_geni_prepare_message(struct spi_master *spi,
 	int ret;
 	struct spi_geni_master *mas = spi_master_get_devdata(spi);
 
+	if (spi_geni_is_abort_still_pending(mas))
+		return -EBUSY;
+
 	ret = setup_fifo_params(spi_msg->spi, spi);
 	if (ret)
 		dev_err(mas->dev, "Couldn't select mode %d\n", ret);
@@ -509,6 +561,9 @@ static int spi_geni_transfer_one(struct spi_master *spi,
 {
 	struct spi_geni_master *mas = spi_master_get_devdata(spi);
 
+	if (spi_geni_is_abort_still_pending(mas))
+		return -EBUSY;
+
 	/* Terminate and return success for 0 byte length transfer */
 	if (!xfer->len)
 		return 0;

