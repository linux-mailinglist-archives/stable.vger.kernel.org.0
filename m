Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2A44158A60
	for <lists+stable@lfdr.de>; Tue, 11 Feb 2020 08:29:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727602AbgBKH3E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Feb 2020 02:29:04 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:42621 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727598AbgBKH3D (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Feb 2020 02:29:03 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 86D025CD;
        Tue, 11 Feb 2020 02:29:01 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Tue, 11 Feb 2020 02:29:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=inRBZpzpbTD6f
        jfknPVk10JEJf4UDm5Ly/qGqhXtJW4=; b=ScYCF6HT+v9qfHS5L1G+j82YxZ0WR
        EHGs9RkdFL5wR7sweYm6CrTlmb2cyZxC212HLwEh5S/MoxLAyKOw/1lwJ65oYfkc
        hCJ2QkuoHpWkzQ4W9J96QGWJusTsAFRR7/gurIzuC36k+J180bP8GBQy0EKNWnEe
        z8ePPj8v55a+iHk3uQoTEIip/woHMp3KwM204dG+cW0SG11+dbOH4QFhRRJGb6Qe
        cn5BPrwP2xNk7SLaIbJvUe3OcGjmu2Fg3L/o+M864xxwbjZ5CRXzyNxjcoAs33Fm
        2ADJTMABp3Jt54P11J7H/4tS2HN1MyezuSNumPpkJzvyPFaNoyFuj6eQA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=inRBZpzpbTD6fjfknPVk10JEJf4UDm5Ly/qGqhXtJW4=; b=XwouBwJm
        ZPLYCkvq4yGSUXxPluRlazQe69Wr106V8BrSr2yi+/T1R1lXHFuJKOKdZNLskHAB
        +NrqzHkOxWdFBcFVWHApdLoV8hD0ypFYSQOW68Bkk17LAPzRG0ZRQ48Kg9AnDRs2
        VA0v+XwYjEtrcdZpZRmnkuHNbx0CrkizcYqJUwQ/4p688tT2YJCL16t6tvfiJ8av
        N+SI/AizK8RW5PpeSPcxeoKq0dYhFHgKHfiD+lBZ9fR4nyCaieftH2LPox4mQp4B
        J7DBK37u9d6OU7hDnqxwUTNn8vSQsQ+t1AICQ0YUPQtxA127KweHjogkLb93zFw1
        THpwEloemXqY4w==
X-ME-Sender: <xms:vFdCXq4QDqaEACUIoNMuKp6ZK-JSVT6MrE_ie4kIE94gjZW5zmkXhw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedriedvgddutdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefurghmuhgv
    lhcujfholhhlrghnugcuoehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhgqeenucfkph
    epjedtrddufeehrddugeekrdduhedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghr
    rghmpehmrghilhhfrhhomhepshgrmhhuvghlsehshhholhhlrghnugdrohhrgh
X-ME-Proxy: <xmx:vFdCXoJjhjw_bcpRun4rxiXd9mDPpSaZoosneXu5KUx82btSGtIXTA>
    <xmx:vFdCXkcXIrxioWT86XI4ZpdtS3Jrmqp7BonFTXVjjdoABv_05C3C1Q>
    <xmx:vFdCXre84NH8qoiQ1dUG_pSXkK3mncPiu7_SveX--rPDTRXScRwD5w>
    <xmx:vVdCXij-QXB6zYnxqRRD83C6psx18L4h45NbmzYT5XpVhkW4lPQhlQ>
Received: from titanium.stl.sholland.net (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6063D30600DC;
        Tue, 11 Feb 2020 02:29:00 -0500 (EST)
From:   Samuel Holland <samuel@sholland.org>
To:     Maxime Ripard <mripard@kernel.org>, Chen-Yu Tsai <wens@csie.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Samuel Holland <samuel@sholland.org>
Subject: [PATCH 4/4] drm/sun4i: dsi: Remove incorrect use of runtime PM
Date:   Tue, 11 Feb 2020 01:28:58 -0600
Message-Id: <20200211072858.30784-4-samuel@sholland.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200211072858.30784-1-samuel@sholland.org>
References: <20200211072858.30784-1-samuel@sholland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The driver currently uses runtime PM to perform some of the module
initialization and cleanup. This has three problems:

1) There is no Kconfig dependency on CONFIG_PM, so if runtime PM is
   disabled, the driver will not work at all, since the module will
   never be initialized.

2) The driver does not ensure that the device is suspended when
   sun6i_dsi_probe() fails or when sun6i_dsi_remove() is called. It
   simply disables runtime PM. From the docs of pm_runtime_disable():

      The device can be either active or suspended after its runtime PM
      has been disabled.

   And indeed, the device will likely still be active if sun6i_dsi_probe
   fails. For example, if the panel driver is not yet loaded, we have
   the following sequence:

   sun6i_dsi_probe()
      pm_runtime_enable()
      mipi_dsi_host_register()
         of_mipi_dsi_device_add(child)
            ...device_add()...
               __device_attach()
                 pm_runtime_get_sync(dev->parent) -> Causes resume
                 bus_for_each_drv()
                    __device_attach_driver() -> No match for panel
                 pm_runtime_put(dev->parent) -> Async idle request
      component_add()
         __component_add()
            try_to_bring_up_masters()
               try_to_bring_up_master()
                  sun4i_drv_bind()
                     component_bind_all()
                        component_bind()
                           sun6i_dsi_bind() -> Fails with -EPROBE_DEFER
      mipi_dsi_host_unregister()
      pm_runtime_disable()
         __pm_runtime_disable()
            __pm_runtime_barrier() -> Idle request is still pending
               cancel_work_sync()  -> DSI host is *not* suspended!

   Since the device is not suspended, the clock and regulator are never
   disabled. The imbalance causes a WARN at devres free time.

3) The driver relies on being suspended when sun6i_dsi_encoder_enable()
   is called. The resume callback has a comment that says:

      Some part of it can only be done once we get a number of
      lanes, see sun6i_dsi_inst_init

   And then part of the resume callback only runs if dsi->device is not
   NULL (that is, if sun6i_dsi_attach() has been called). However, as
   the above call graph shows, the resume callback is guaranteed to be
   called before sun6i_dsi_attach(); it is called before child devices
   get their drivers attached.

   Therefore, part of the controller initialization will only run if the
   device is suspended between the calls to mipi_dsi_host_register() and
   component_add() (which ends up calling sun6i_dsi_encoder_enable()).
   Again, as shown by the above call graph, this is not the case. It
   appears that the controller happens to work because it is still
   initialized by the bootloader.

   Because the connector is hardcoded to always be connected, the
   device's runtime PM reference is not dropped until system suspend,
   when sun4i_drv_drm_sys_suspend() ends up calling
   sun6i_dsi_encoder_disable(). However, that is done as a system sleep
   PM hook, and at that point the system PM core has already taken
   another runtime PM reference, so sun6i_dsi_runtime_suspend() is
   not called. Likewise, by the time the PM core releases its reference,
   sun4i_drv_drm_sys_resume() has already re-enabled the encoder.

   So after system suspend and resume, we have *still never called*
   sun6i_dsi_inst_init(), and now that the rest of the display pipeline
   has been reset, the DSI host is unable to communicate with the panel,
   causing VBLANK timeouts.

Fix all of these issues by inlining the runtime PM hooks into the
encoder enable/disable functions, which are guaranteed to run after a
panel is attached. This allows sun6i_dsi_inst_init() to be called
unconditionally. Furthermore, this causes the hardware to be turned off
during system suspend and reinitialized on resume, which was not
happening before.

Fixes: 133add5b5ad4 ("drm/sun4i: Add Allwinner A31 MIPI-DSI controller support")
Signed-off-by: Samuel Holland <samuel@sholland.org>
---
 drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c | 89 ++++++++------------------
 1 file changed, 26 insertions(+), 63 deletions(-)

diff --git a/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c b/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c
index ef35ce5a9bb0..8c2e326d8e16 100644
--- a/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c
+++ b/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c
@@ -14,7 +14,6 @@
 #include <linux/phy/phy-mipi-dphy.h>
 #include <linux/phy/phy.h>
 #include <linux/platform_device.h>
-#include <linux/pm_runtime.h>
 #include <linux/regmap.h>
 #include <linux/regulator/consumer.h>
 #include <linux/reset.h>
@@ -721,10 +720,31 @@ static void sun6i_dsi_encoder_enable(struct drm_encoder *encoder)
 	union phy_configure_opts opts = { 0 };
 	struct phy_configure_opts_mipi_dphy *cfg = &opts.mipi_dphy;
 	u16 delay;
+	int err;
 
 	DRM_DEBUG_DRIVER("Enabling DSI output\n");
 
-	pm_runtime_get_sync(dsi->dev);
+	err = regulator_enable(dsi->regulator);
+	if (err)
+		dev_warn(dsi->dev, "failed to enable VCC-DSI supply: %d\n", err);
+
+	reset_control_deassert(dsi->reset);
+	clk_prepare_enable(dsi->mod_clk);
+
+	/*
+	 * Enable the DSI block.
+	 */
+	regmap_write(dsi->regs, SUN6I_DSI_CTL_REG, SUN6I_DSI_CTL_EN);
+
+	regmap_write(dsi->regs, SUN6I_DSI_BASIC_CTL0_REG,
+		     SUN6I_DSI_BASIC_CTL0_ECC_EN | SUN6I_DSI_BASIC_CTL0_CRC_EN);
+
+	regmap_write(dsi->regs, SUN6I_DSI_TRANS_START_REG, 10);
+	regmap_write(dsi->regs, SUN6I_DSI_TRANS_ZERO_REG, 0);
+
+	sun6i_dsi_inst_init(dsi, dsi->device);
+
+	regmap_write(dsi->regs, SUN6I_DSI_DEBUG_DATA_REG, 0xff);
 
 	delay = sun6i_dsi_get_video_start_delay(dsi, mode);
 	regmap_write(dsi->regs, SUN6I_DSI_BASIC_CTL1_REG,
@@ -787,7 +807,9 @@ static void sun6i_dsi_encoder_disable(struct drm_encoder *encoder)
 	phy_power_off(dsi->dphy);
 	phy_exit(dsi->dphy);
 
-	pm_runtime_put(dsi->dev);
+	clk_disable_unprepare(dsi->mod_clk);
+	reset_control_assert(dsi->reset);
+	regulator_disable(dsi->regulator);
 }
 
 static int sun6i_dsi_get_modes(struct drm_connector *connector)
@@ -1147,12 +1169,10 @@ static int sun6i_dsi_probe(struct platform_device *pdev)
 		goto err_unprotect_clk;
 	}
 
-	pm_runtime_enable(dev);
-
 	ret = mipi_dsi_host_register(&dsi->host);
 	if (ret) {
 		dev_err(dev, "Couldn't register MIPI-DSI host\n");
-		goto err_pm_disable;
+		goto err_unprotect_clk;
 	}
 
 	ret = component_add(&pdev->dev, &sun6i_dsi_ops);
@@ -1165,8 +1185,6 @@ static int sun6i_dsi_probe(struct platform_device *pdev)
 
 err_remove_dsi_host:
 	mipi_dsi_host_unregister(&dsi->host);
-err_pm_disable:
-	pm_runtime_disable(dev);
 err_unprotect_clk:
 	clk_rate_exclusive_put(dsi->mod_clk);
 	return ret;
@@ -1179,65 +1197,11 @@ static int sun6i_dsi_remove(struct platform_device *pdev)
 
 	component_del(&pdev->dev, &sun6i_dsi_ops);
 	mipi_dsi_host_unregister(&dsi->host);
-	pm_runtime_disable(dev);
 	clk_rate_exclusive_put(dsi->mod_clk);
 
 	return 0;
 }
 
-static int __maybe_unused sun6i_dsi_runtime_resume(struct device *dev)
-{
-	struct sun6i_dsi *dsi = dev_get_drvdata(dev);
-	int err;
-
-	err = regulator_enable(dsi->regulator);
-	if (err) {
-		dev_err(dsi->dev, "failed to enable VCC-DSI supply: %d\n", err);
-		return err;
-	}
-
-	reset_control_deassert(dsi->reset);
-	clk_prepare_enable(dsi->mod_clk);
-
-	/*
-	 * Enable the DSI block.
-	 *
-	 * Some part of it can only be done once we get a number of
-	 * lanes, see sun6i_dsi_inst_init
-	 */
-	regmap_write(dsi->regs, SUN6I_DSI_CTL_REG, SUN6I_DSI_CTL_EN);
-
-	regmap_write(dsi->regs, SUN6I_DSI_BASIC_CTL0_REG,
-		     SUN6I_DSI_BASIC_CTL0_ECC_EN | SUN6I_DSI_BASIC_CTL0_CRC_EN);
-
-	regmap_write(dsi->regs, SUN6I_DSI_TRANS_START_REG, 10);
-	regmap_write(dsi->regs, SUN6I_DSI_TRANS_ZERO_REG, 0);
-
-	if (dsi->device)
-		sun6i_dsi_inst_init(dsi, dsi->device);
-
-	regmap_write(dsi->regs, SUN6I_DSI_DEBUG_DATA_REG, 0xff);
-
-	return 0;
-}
-
-static int __maybe_unused sun6i_dsi_runtime_suspend(struct device *dev)
-{
-	struct sun6i_dsi *dsi = dev_get_drvdata(dev);
-
-	clk_disable_unprepare(dsi->mod_clk);
-	reset_control_assert(dsi->reset);
-	regulator_disable(dsi->regulator);
-
-	return 0;
-}
-
-static const struct dev_pm_ops sun6i_dsi_pm_ops = {
-	SET_RUNTIME_PM_OPS(sun6i_dsi_runtime_suspend,
-			   sun6i_dsi_runtime_resume,
-			   NULL)
-};
-
 static const struct of_device_id sun6i_dsi_of_table[] = {
 	{ .compatible = "allwinner,sun6i-a31-mipi-dsi" },
 	{ }
@@ -1250,7 +1214,6 @@ static struct platform_driver sun6i_dsi_platform_driver = {
 	.driver		= {
 		.name		= "sun6i-mipi-dsi",
 		.of_match_table	= sun6i_dsi_of_table,
-		.pm		= &sun6i_dsi_pm_ops,
 	},
 };
 module_platform_driver(sun6i_dsi_platform_driver);
-- 
2.24.1

