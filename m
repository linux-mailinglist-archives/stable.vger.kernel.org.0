Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 929131CC472
	for <lists+stable@lfdr.de>; Sat,  9 May 2020 22:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728635AbgEIUMS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 May 2020 16:12:18 -0400
Received: from wnew1-smtp.messagingengine.com ([64.147.123.26]:39383 "EHLO
        wnew1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728244AbgEIUMR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 May 2020 16:12:17 -0400
X-Greylist: delayed 494 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 May 2020 16:12:16 EDT
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.west.internal (Postfix) with ESMTP id 6DA555B1;
        Sat,  9 May 2020 16:05:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 09 May 2020 16:05:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-type:content-transfer-encoding; s=fm2; bh=
        ITst3Zesw15C9r4bhKYzEsQqTWU1MwXxemh1A21dekg=; b=FhXQug0cmxzeHDZG
        EQ2mv8DgCtcG73fUcrH5WY2iDa3CdQZtRdTIDemxCtjYgtshZrVDR2q4UAM2+fi1
        WwswZjb39P3c0clsOrfj4NItGdgo6cBzSTIJY3e1Yr4mQRinWQ5kky9sDb/yID7h
        d3EqoJFaRTelbygJDV/1NMadGlcfvWG+xHG8XMyC1nhUe8Vsq+DnhoiLIqVERFf6
        ahYpV7nferlComy0q9xu+WidBvJa3leXWUZtZgd9EcE1FHxt2FkoB7XmfbDjlT7q
        m5a/mJTWniaaEjB8PNvjfPEhkGf4IVSMsTUN/gyISyXkbqYdUTVqExm7FLtckE/9
        iCrKAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=ITst3Zesw15C9r4bhKYzEsQqTWU1MwXxemh1A21de
        kg=; b=blkiEVYghsOujEpuE1Xe9EwUIM8omR1Cymx1dWzPd0wdQfeUPWOHJ8Iq9
        O/jE1gse3CWJ7Qw0eqUdioOD3yF/Z3SEmcUpzzXzS/MSvD9ErwjfiAm7pPQOj2wa
        l1esSmjSww5yUjmXi9NhsQeY2bNC8BWZ91f4shrfAZJtEnRvVwIHeNbI9LAcr3SA
        +Tk8u9j48NnElL7GzPzAOBVoicXcOHskFDc+AohuSMNbsJmlBuwzVIR46vqFju6B
        ZL8QuoEgB3r4kGli8V3ddo+TZeQy6qYyBGBWhNFluWBbhNGJMfKrSwSMHTfJ7U3l
        qYtedBo5LQfcGo6mLdY+G/UveSrOw==
X-ME-Sender: <xms:GA23Xj9qm-OEDWL2ER9M4J8-Jej0logJtUBnYw12oH2TgkjRMQOLQg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrkeehgddugeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfgggtgfesthekredtredtjeenucfhrhhomhepufgrmhhu
    vghlucfjohhllhgrnhguuceoshgrmhhuvghlsehshhholhhlrghnugdrohhrgheqnecugg
    ftrfgrthhtvghrnhepfedvffetgeduiedtfffgleelvdfhheekkeduffetuddvgeeffedu
    fefhgeehueejnecukfhppeejtddrudefhedrudegkedrudehudenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehsrghmuhgvlhesshhhohhllhgr
    nhgurdhorhhg
X-ME-Proxy: <xmx:GA23Xj_M2b8_QAspkCsny2tU4Qd59ox6BN1DWtA3aCns17QiwC1fdA>
    <xmx:GA23XsB9-wpmokXfGQbKn-Lveu4BzHf80RDzSFZfm6oYAhT3OLDbEQ>
    <xmx:GA23XjwUDhzHE3il8jJqulD127JxsUgKGhsSuKyK6WKJ1gFLaB7eVA>
    <xmx:Gg23Xn4HgSVOAcFUIjqMV-pO7YHVRbF3vxugcy6yPI13-qeIpa8Xw8nrzSA>
Received: from titanium.stl.sholland.net (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id A73253066245;
        Sat,  9 May 2020 16:05:43 -0400 (EDT)
From:   Samuel Holland <samuel@sholland.org>
To:     Maxime Ripard <mripard@kernel.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-sunxi@googlegroups.com,
        Samuel Holland <samuel@sholland.org>, stable@vger.kernel.org,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v3 2/2] media: cedrus: Implement runtime PM
Date:   Sat,  9 May 2020 15:06:43 -0500
Message-Id: <20200509200643.30597-2-samuel@sholland.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200509200643.30597-1-samuel@sholland.org>
References: <20200509200643.30597-1-samuel@sholland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jernej Skrabec <jernej.skrabec@siol.net>

This allows the VE clocks and PLL_VE to be disabled most of the time.
A runtime PM reference is held while streaming.

Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
Signed-off-by: Samuel Holland <samuel@sholland.org>
Tested-by: Jernej Skrabec <jernej.skrabec@siol.net>
Reviewed-by: Ezequiel Garcia <ezequiel@collabora.com>
---

v2: moved PM reference to cedrus_{start,stop}_streaming, based on an
    earlier patch by Jernej Skrabec. Removes the need for autosuspend.
    I tested this with running 2x v4l2-request-test in parallel.
v3: changed authorship to Jernej, collected tags

---
 drivers/staging/media/sunxi/cedrus/cedrus.c   |   7 ++
 .../staging/media/sunxi/cedrus/cedrus_hw.c    | 106 ++++++++++++------
 .../staging/media/sunxi/cedrus/cedrus_hw.h    |   3 +
 .../staging/media/sunxi/cedrus/cedrus_video.c |  33 ++++--
 4 files changed, 104 insertions(+), 45 deletions(-)

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus.c b/drivers/staging/media/sunxi/cedrus/cedrus.c
index 05a85517ff60..bc27f9430eeb 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus.c
@@ -16,6 +16,7 @@
 #include <linux/platform_device.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/pm.h>
 
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
@@ -551,12 +552,18 @@ static const struct of_device_id cedrus_dt_match[] = {
 };
 MODULE_DEVICE_TABLE(of, cedrus_dt_match);
 
+static const struct dev_pm_ops cedrus_dev_pm_ops = {
+	SET_RUNTIME_PM_OPS(cedrus_hw_suspend,
+			   cedrus_hw_resume, NULL)
+};
+
 static struct platform_driver cedrus_driver = {
 	.probe		= cedrus_probe,
 	.remove		= cedrus_remove,
 	.driver		= {
 		.name		= CEDRUS_NAME,
 		.of_match_table	= of_match_ptr(cedrus_dt_match),
+		.pm		= &cedrus_dev_pm_ops,
 	},
 };
 module_platform_driver(cedrus_driver);
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_hw.c b/drivers/staging/media/sunxi/cedrus/cedrus_hw.c
index daf5f244f93b..1744e6fcc999 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_hw.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_hw.c
@@ -19,6 +19,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/interrupt.h>
 #include <linux/clk.h>
+#include <linux/pm_runtime.h>
 #include <linux/regmap.h>
 #include <linux/reset.h>
 #include <linux/soc/sunxi/sunxi_sram.h>
@@ -140,6 +141,64 @@ static irqreturn_t cedrus_irq(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
+int cedrus_hw_suspend(struct device *device)
+{
+	struct cedrus_dev *dev = dev_get_drvdata(device);
+
+	reset_control_assert(dev->rstc);
+
+	clk_disable_unprepare(dev->ram_clk);
+	clk_disable_unprepare(dev->mod_clk);
+	clk_disable_unprepare(dev->ahb_clk);
+
+	return 0;
+}
+
+int cedrus_hw_resume(struct device *device)
+{
+	struct cedrus_dev *dev = dev_get_drvdata(device);
+	int ret;
+
+	ret = clk_prepare_enable(dev->ahb_clk);
+	if (ret) {
+		dev_err(dev->dev, "Failed to enable AHB clock\n");
+
+		return ret;
+	}
+
+	ret = clk_prepare_enable(dev->mod_clk);
+	if (ret) {
+		dev_err(dev->dev, "Failed to enable MOD clock\n");
+
+		goto err_ahb_clk;
+	}
+
+	ret = clk_prepare_enable(dev->ram_clk);
+	if (ret) {
+		dev_err(dev->dev, "Failed to enable RAM clock\n");
+
+		goto err_mod_clk;
+	}
+
+	ret = reset_control_reset(dev->rstc);
+	if (ret) {
+		dev_err(dev->dev, "Failed to apply reset\n");
+
+		goto err_ram_clk;
+	}
+
+	return 0;
+
+err_ram_clk:
+	clk_disable_unprepare(dev->ram_clk);
+err_mod_clk:
+	clk_disable_unprepare(dev->mod_clk);
+err_ahb_clk:
+	clk_disable_unprepare(dev->ahb_clk);
+
+	return ret;
+}
+
 int cedrus_hw_probe(struct cedrus_dev *dev)
 {
 	const struct cedrus_variant *variant;
@@ -236,42 +295,17 @@ int cedrus_hw_probe(struct cedrus_dev *dev)
 		goto err_sram;
 	}
 
-	ret = clk_prepare_enable(dev->ahb_clk);
-	if (ret) {
-		dev_err(dev->dev, "Failed to enable AHB clock\n");
-
-		goto err_sram;
-	}
-
-	ret = clk_prepare_enable(dev->mod_clk);
-	if (ret) {
-		dev_err(dev->dev, "Failed to enable MOD clock\n");
-
-		goto err_ahb_clk;
-	}
-
-	ret = clk_prepare_enable(dev->ram_clk);
-	if (ret) {
-		dev_err(dev->dev, "Failed to enable RAM clock\n");
-
-		goto err_mod_clk;
-	}
-
-	ret = reset_control_reset(dev->rstc);
-	if (ret) {
-		dev_err(dev->dev, "Failed to apply reset\n");
-
-		goto err_ram_clk;
+	pm_runtime_enable(dev->dev);
+	if (!pm_runtime_enabled(dev->dev)) {
+		ret = cedrus_hw_resume(dev->dev);
+		if (ret)
+			goto err_pm;
 	}
 
 	return 0;
 
-err_ram_clk:
-	clk_disable_unprepare(dev->ram_clk);
-err_mod_clk:
-	clk_disable_unprepare(dev->mod_clk);
-err_ahb_clk:
-	clk_disable_unprepare(dev->ahb_clk);
+err_pm:
+	pm_runtime_disable(dev->dev);
 err_sram:
 	sunxi_sram_release(dev->dev);
 err_mem:
@@ -282,11 +316,9 @@ int cedrus_hw_probe(struct cedrus_dev *dev)
 
 void cedrus_hw_remove(struct cedrus_dev *dev)
 {
-	reset_control_assert(dev->rstc);
-
-	clk_disable_unprepare(dev->ram_clk);
-	clk_disable_unprepare(dev->mod_clk);
-	clk_disable_unprepare(dev->ahb_clk);
+	pm_runtime_disable(dev->dev);
+	if (!pm_runtime_status_suspended(dev->dev))
+		cedrus_hw_suspend(dev->dev);
 
 	sunxi_sram_release(dev->dev);
 
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_hw.h b/drivers/staging/media/sunxi/cedrus/cedrus_hw.h
index 604ff932fbf5..45f641f0bfa2 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_hw.h
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_hw.h
@@ -22,6 +22,9 @@ void cedrus_engine_disable(struct cedrus_dev *dev);
 void cedrus_dst_format_set(struct cedrus_dev *dev,
 			   struct v4l2_pix_format *fmt);
 
+int cedrus_hw_suspend(struct device *device);
+int cedrus_hw_resume(struct device *device);
+
 int cedrus_hw_probe(struct cedrus_dev *dev);
 void cedrus_hw_remove(struct cedrus_dev *dev);
 
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_video.c b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
index ed3f511f066f..16d82309e7b6 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_video.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
@@ -13,6 +13,8 @@
  * Marek Szyprowski, <m.szyprowski@samsung.com>
  */
 
+#include <linux/pm_runtime.h>
+
 #include <media/videobuf2-dma-contig.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
@@ -450,12 +452,24 @@ static int cedrus_start_streaming(struct vb2_queue *vq, unsigned int count)
 		return -EINVAL;
 	}
 
-	if (V4L2_TYPE_IS_OUTPUT(vq->type) &&
-	    dev->dec_ops[ctx->current_codec]->start)
-		ret = dev->dec_ops[ctx->current_codec]->start(ctx);
+	if (V4L2_TYPE_IS_OUTPUT(vq->type)) {
+		ret = pm_runtime_get_sync(dev->dev);
+		if (ret < 0)
+			goto err_cleanup;
 
-	if (ret)
-		cedrus_queue_cleanup(vq, VB2_BUF_STATE_QUEUED);
+		if (dev->dec_ops[ctx->current_codec]->start) {
+			ret = dev->dec_ops[ctx->current_codec]->start(ctx);
+			if (ret)
+				goto err_pm;
+		}
+	}
+
+	return 0;
+
+err_pm:
+	pm_runtime_put(dev->dev);
+err_cleanup:
+	cedrus_queue_cleanup(vq, VB2_BUF_STATE_QUEUED);
 
 	return ret;
 }
@@ -465,9 +479,12 @@ static void cedrus_stop_streaming(struct vb2_queue *vq)
 	struct cedrus_ctx *ctx = vb2_get_drv_priv(vq);
 	struct cedrus_dev *dev = ctx->dev;
 
-	if (V4L2_TYPE_IS_OUTPUT(vq->type) &&
-	    dev->dec_ops[ctx->current_codec]->stop)
-		dev->dec_ops[ctx->current_codec]->stop(ctx);
+	if (V4L2_TYPE_IS_OUTPUT(vq->type)) {
+		if (dev->dec_ops[ctx->current_codec]->stop)
+			dev->dec_ops[ctx->current_codec]->stop(ctx);
+
+		pm_runtime_put(dev->dev);
+	}
 
 	cedrus_queue_cleanup(vq, VB2_BUF_STATE_ERROR);
 }
-- 
2.24.1

