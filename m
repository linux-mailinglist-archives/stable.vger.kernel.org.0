Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF581F9BC7
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 17:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730135AbgFOPUd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 11:20:33 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:39253 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730109AbgFOPUc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 11:20:32 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id AC9AB7B5;
        Mon, 15 Jun 2020 11:20:31 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 15 Jun 2020 11:20:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=lJ8SYC
        JbqUEAkoBSl2+ZYIOA9zv4174onQUnpkiMs5o=; b=IFtZvk2BzPKWcpl3qfv/GD
        aVKVdI3D9OA9Cu+dnuMWpvjcYEsvTPcUjgkkCWVniXhI66mz0gIw0b2H9E2NHHMI
        kNbNnBNGHlwhiLP5w/Ej/WPWd7njuQasmxOueo9CHLekokEOZbUI7unGDTqz34ld
        7QT6xEwpo1F5/Z64O68pf0E3xYFq0PiRrDWzRQMORR+p5LzUr+AeupeNxQIxvJ8a
        jFii0waeI4rxh0oNZTapTWRzYges4sW5pt0MXQfEyBSdwbpMEapEX0KEVa5hJxOD
        NNOT/5PqKblxVZKyBPBAgKSo2htkdKoJPdhaSwAqybzRG4yGajXPM+mTgIf/n7DA
        ==
X-ME-Sender: <xms:vpHnXh_0v20rXPUshD86GUi2xRMRB1eWI1Vigwc9cxTOVgsmh_eL-A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeikedgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:vpHnXlvnmGbLm3Bk10x1VSF8Zwn1L6h7JjT7tcUNpI20JnLGzRxLig>
    <xmx:vpHnXvCbOjhohDdRm1XwtYN8fNhIbcd2mCLo3vaPsq_itqG0J4exIQ>
    <xmx:vpHnXldxMb-Al-8xVogF3KQwCQUrw8GOU9sHrJ7PHerebXtS8eF3UA>
    <xmx:v5HnXo2wruCHOV78qoL_DyMeRgaTXwO0tahJuJ5VL3PQ8Db_ED-pAIRJzSI>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C83B33280064;
        Mon, 15 Jun 2020 11:20:29 -0400 (EDT)
Subject: FAILED: patch "[PATCH] spi: dw: Fix controller unregister order" failed to apply to 4.14-stable tree
To:     lukas@wunner.de, andriy.shevchenko@linux.intel.com,
        baruch@tkos.co.il, broonie@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Jun 2020 17:20:14 +0200
Message-ID: <159223441416477@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From ca8b19d61e3fce5d2d7790cde27a0b57bcb3f341 Mon Sep 17 00:00:00 2001
From: Lukas Wunner <lukas@wunner.de>
Date: Mon, 25 May 2020 14:25:01 +0200
Subject: [PATCH] spi: dw: Fix controller unregister order

The Designware SPI driver uses devm_spi_register_controller() on bind.
As a consequence, on unbind, __device_release_driver() first invokes
dw_spi_remove_host() before unregistering the SPI controller via
devres_release_all().

This order is incorrect:  dw_spi_remove_host() shuts down the chip,
rendering the SPI bus inaccessible even though the SPI controller is
still registered.  When the SPI controller is subsequently unregistered,
it unbinds all its slave devices.  Because their drivers cannot access
the SPI bus, e.g. to quiesce interrupts, the slave devices may be left
in an improper state.

As a rule, devm_spi_register_controller() must not be used if the
->remove() hook performs teardown steps which shall be performed after
unregistering the controller and specifically after unbinding of slaves.

Fix by reverting to the non-devm variant of spi_register_controller().

An alternative approach would be to use device-managed functions for all
steps in dw_spi_remove_host(), e.g. by calling devm_add_action_or_reset()
on probe.  However that approach would add more LoC to the driver and
it wouldn't lend itself as well to backporting to stable.

Fixes: 04f421e7b0b1 ("spi: dw: use managed resources")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable@vger.kernel.org # v3.14+
Cc: Baruch Siach <baruch@tkos.co.il>
Link: https://lore.kernel.org/r/3fff8cb8ae44a9893840d0688be15bb88c090a14.1590408496.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/drivers/spi/spi-dw.c b/drivers/spi/spi-dw.c
index 31e3f866d11a..780ffad64a91 100644
--- a/drivers/spi/spi-dw.c
+++ b/drivers/spi/spi-dw.c
@@ -526,7 +526,7 @@ int dw_spi_add_host(struct device *dev, struct dw_spi *dws)
 		}
 	}
 
-	ret = devm_spi_register_controller(dev, master);
+	ret = spi_register_controller(master);
 	if (ret) {
 		dev_err(&master->dev, "problem registering spi master\n");
 		goto err_dma_exit;
@@ -550,6 +550,8 @@ void dw_spi_remove_host(struct dw_spi *dws)
 {
 	dw_spi_debugfs_remove(dws);
 
+	spi_unregister_controller(dws->master);
+
 	if (dws->dma_ops && dws->dma_ops->dma_exit)
 		dws->dma_ops->dma_exit(dws);
 

