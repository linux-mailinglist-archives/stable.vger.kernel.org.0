Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 094341F9BC9
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 17:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730109AbgFOPUl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 11:20:41 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:38723 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730147AbgFOPUi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 11:20:38 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 41CB4734;
        Mon, 15 Jun 2020 11:20:37 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 15 Jun 2020 11:20:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=j2Mzam
        0LSItZThi1aR41XfcJ+8XUavXEsr+mGuFjf/k=; b=TmtaY2hhTqssTf8WVCcZsi
        oVSim3ghzjFcWtk0BDlMuxdZL/OAa0uW6wIi40SrokszHbJZMQTk5X+j7MDhrz7D
        ueqT+INQyBsqD/zc+oA88wXJuX70iJjv+liLpHjmdezYlYvbm8A3xa4umWRpeGtq
        1eTEpXVAXV9sAPtJ2gH+uMTreoW3O/lg/p1i42q7qb/P48e5x7ZzjERQ9VFr7jVo
        UXdak2oDkW608E1EdbO0xNS2Cl/K5qiitaifuXK3YwFWcIMNi/O2nitlWaU4TMyx
        9a4VSiJghfN65JN1t39qJuT66pDB+lCjyx4NO7VhzxowR1VfYsh4RW3ceB9eRdqQ
        ==
X-ME-Sender: <xms:xJHnXhtDI-lEu-ulmUGyWJrNr1mnFqwclimSvOgwt5d8a3ndDEhBYQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeikedgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:xJHnXqfwJ4EY_OXHVSjXuWCMyMl4QTdLuAwWo4I-9AIeAYwTGEYZaw>
    <xmx:xJHnXkzZi4PdUqfeMAejzAuSH7O-BU3VJgqjTQNaVikoBRvJBltCzQ>
    <xmx:xJHnXoM5uSZIRLNAc9orFte94zjvQgb610CawU5sTYko0CqUnihYkw>
    <xmx:xJHnXjnS3tB2ihxVrKG4NyjLtXyaqdnorqFJ25yTOI29i1W4FK9M7yJd0cU>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 901D03280060;
        Mon, 15 Jun 2020 11:20:36 -0400 (EDT)
Subject: FAILED: patch "[PATCH] spi: dw: Fix controller unregister order" failed to apply to 4.4-stable tree
To:     lukas@wunner.de, andriy.shevchenko@linux.intel.com,
        baruch@tkos.co.il, broonie@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Jun 2020 17:20:16 +0200
Message-ID: <159223441661206@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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
 

