Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56E4D32D5EA
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 16:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233238AbhCDPEx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 10:04:53 -0500
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:43813 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233183AbhCDPEf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 10:04:35 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 5C8843CD;
        Thu,  4 Mar 2021 10:03:29 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 04 Mar 2021 10:03:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=AurJ8+
        sHd4+9Xbs5L6i6ZfvumFsdslG0WRTGrCbwWWM=; b=ULGu7cbenBYd2kl/LZ9hzy
        gRzHeQpuwVWOXrWL0eQg9Dse5it0qbT9R5kHwbx3/QNjVIuanZNl47a1Jaq/G+ng
        lnhO2/eWNn0Wv8hoFXpBnpFt0wKma/VeMlwWYK8vc8r4Fcq9BGSn23KVWR+3L6Sg
        oQRP57qlZQOTcCzp3bVcX4KLsESEorlWAYe+E0i3OLy9Rz6zNfannecsNHENjT2G
        QCoIgI4BDD3JTsWQOzXERKG0lFXJzGG+KBtSf1EK8UojbZtQ7fSC9lvX7TG3GDtQ
        33awTrffjvYmzeFi1xTKltAVGp03u78lnv2f2+STG3gp8yXQreab9v8VB2Qs8+HQ
        ==
X-ME-Sender: <xms:wPZAYISR9tDtXlL0Vwi_BswVmZTc--I91Nd6aUyRbPZf2aePQljBxA>
    <xme:wPZAYC5KflKKUW9oVr1_pffeYsRBCLASQd2sUOlfM84a1vVY99JmXr-qJ3KSOrIqT
    na14aFYxFTxCw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddtgedgieejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:wPZAYE1Dz-ATHNgs_8Nlc_vy2WS_yoxO4Oj1HEAmjrnj3tJyWEDImA>
    <xmx:wPZAYNAd7BXyFuKuRlxHZoEtwnntdwW90NxbD2AJCbK_STRBxtxjRQ>
    <xmx:wPZAYPPSgktKWXAREAXOJZKL8CY8hv9712RdZ3skecmyKE8gpBBH1g>
    <xmx:wPZAYKEgvWlQgtoa7N86du98YQ47u10E7Tv77Kuk-WO-mjD8vGIqAdxtO0M>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 30348240057;
        Thu,  4 Mar 2021 10:03:28 -0500 (EST)
Subject: FAILED: patch "[PATCH] i2c: i2c-qcom-geni: Add shutdown callback for i2c" failed to apply to 4.19-stable tree
To:     rojay@codeaurora.org, akashast@codeaurora.org, wsa@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 04 Mar 2021 16:03:26 +0100
Message-ID: <1614870206786@kroah.com>
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

From e0371298ddc51761be257698554ea507ac8bf831 Mon Sep 17 00:00:00 2001
From: Roja Rani Yarubandi <rojay@codeaurora.org>
Date: Fri, 8 Jan 2021 20:35:45 +0530
Subject: [PATCH] i2c: i2c-qcom-geni: Add shutdown callback for i2c

If the hardware is still accessing memory after SMMU translation
is disabled (as part of smmu shutdown callback), then the
IOVAs (I/O virtual address) which it was using will go on the bus
as the physical addresses which will result in unknown crashes
like NoC/interconnect errors.

So, implement shutdown callback to i2c driver to stop on-going transfer
and unmap DMA mappings during system "reboot" or "shutdown".

Fixes: 37692de5d523 ("i2c: i2c-qcom-geni: Add bus driver for the Qualcomm GENI I2C controller")
Signed-off-by: Roja Rani Yarubandi <rojay@codeaurora.org>
Reviewed-by: Akash Asthana <akashast@codeaurora.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>

diff --git a/drivers/i2c/busses/i2c-qcom-geni.c b/drivers/i2c/busses/i2c-qcom-geni.c
index 214b4c913a13..c3f584795911 100644
--- a/drivers/i2c/busses/i2c-qcom-geni.c
+++ b/drivers/i2c/busses/i2c-qcom-geni.c
@@ -375,6 +375,32 @@ static void geni_i2c_tx_msg_cleanup(struct geni_i2c_dev *gi2c,
 	}
 }
 
+static void geni_i2c_stop_xfer(struct geni_i2c_dev *gi2c)
+{
+	int ret;
+	u32 geni_status;
+	struct i2c_msg *cur;
+
+	/* Resume device, as runtime suspend can happen anytime during transfer */
+	ret = pm_runtime_get_sync(gi2c->se.dev);
+	if (ret < 0) {
+		dev_err(gi2c->se.dev, "Failed to resume device: %d\n", ret);
+		return;
+	}
+
+	geni_status = readl_relaxed(gi2c->se.base + SE_GENI_STATUS);
+	if (geni_status & M_GENI_CMD_ACTIVE) {
+		cur = gi2c->cur;
+		geni_i2c_abort_xfer(gi2c);
+		if (cur->flags & I2C_M_RD)
+			geni_i2c_rx_msg_cleanup(gi2c, cur);
+		else
+			geni_i2c_tx_msg_cleanup(gi2c, cur);
+	}
+
+	pm_runtime_put_sync_suspend(gi2c->se.dev);
+}
+
 static int geni_i2c_rx_one_msg(struct geni_i2c_dev *gi2c, struct i2c_msg *msg,
 				u32 m_param)
 {
@@ -650,6 +676,13 @@ static int geni_i2c_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static void  geni_i2c_shutdown(struct platform_device *pdev)
+{
+	struct geni_i2c_dev *gi2c = platform_get_drvdata(pdev);
+
+	geni_i2c_stop_xfer(gi2c);
+}
+
 static int __maybe_unused geni_i2c_runtime_suspend(struct device *dev)
 {
 	int ret;
@@ -714,6 +747,7 @@ MODULE_DEVICE_TABLE(of, geni_i2c_dt_match);
 static struct platform_driver geni_i2c_driver = {
 	.probe  = geni_i2c_probe,
 	.remove = geni_i2c_remove,
+	.shutdown = geni_i2c_shutdown,
 	.driver = {
 		.name = "geni_i2c",
 		.pm = &geni_i2c_pm_ops,

