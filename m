Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAA2B395140
	for <lists+stable@lfdr.de>; Sun, 30 May 2021 16:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbhE3OGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 May 2021 10:06:13 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:41045 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229500AbhE3OGM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 May 2021 10:06:12 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 8C24719402CF;
        Sun, 30 May 2021 10:04:33 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 30 May 2021 10:04:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=vjSyKs
        SO9meIgeP79F9Ec1r4tpJKw4MGVNsGNr9jprE=; b=ARJqfV4I3IY4353RrhtMqC
        J4gxW40MiNHecfs+HYHxBiG1Cgx8Ift/jg8oVsgXGOunSnFtMS0CQbtMUjKAI1MJ
        lVlZogNj5PNgPaLwKGA6xQ+yaoHlJTTTSbIg4a9uAroC/rrHgjzLs4/OmIsbixGg
        +ZAWzQe48RUxl+nEuxLzeMlJ/MGZ9qhecAnQ4CKhRMurjnCL493KtV3MJDAMNA8d
        CZvGs1PvJxl34NWdzHgLuvu0/j2tE0DPrKPWqw8kk47w5TgwSLmkTc0EXmhJTu4W
        sUzpCGMXgDfPXgZ3SCz8fYwmGYnTs1id7eG4ikYhAE2/QvX9WUuW7thFDXmwXd/w
        ==
X-ME-Sender: <xms:cZuzYA_TaZgcvE8Hq-tOuPTyE6Gx4csxzEiP-tIkQhPARyE9jij4eg>
    <xme:cZuzYItzeNQM1F6rh-0tvsMyYThEveh-8fr-2SjLkq2_2yzq8EfnZ8q_5BCoVQYFy
    Yzr4ciI8WmCtg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeluddgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:cZuzYGBsnLT6V-zcgbmgqATfnODerybTFfWbrFoKkEswA_o7NJZaPA>
    <xmx:cZuzYAfRW93c5H0gf2EwNxywfQ2NiCEwKuE02kDoDzAj9uzcXdqWKQ>
    <xmx:cZuzYFMOnL77aLD5ZKlOpZVl7Jv3iAY15W4jQrMq_uvnnt429rL_1Q>
    <xmx:cZuzYD1WAzrI09WSntEgX6gZUHi0HVC0S_iuLTE2ZBkxmGpffK5EJw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun, 30 May 2021 10:04:32 -0400 (EDT)
Subject: FAILED: patch "[PATCH] spi: spi-fsl-dspi: Fix a resource leak in an error handling" failed to apply to 4.14-stable tree
To:     christophe.jaillet@wanadoo.fr, broonie@kernel.org,
        olteanv@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 30 May 2021 16:04:23 +0200
Message-ID: <16223834632225@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 680ec0549a055eb464dce6ffb4bfb736ef87236e Mon Sep 17 00:00:00 2001
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Sun, 9 May 2021 21:12:27 +0200
Subject: [PATCH] spi: spi-fsl-dspi: Fix a resource leak in an error handling
 path

'dspi_request_dma()' should be undone by a 'dspi_release_dma()' call in the
error handling path of the probe function, as already done in the remove
function

Fixes: 90ba37033cb9 ("spi: spi-fsl-dspi: Add DMA support for Vybrid")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://lore.kernel.org/r/d51caaac747277a1099ba8dea07acd85435b857e.1620587472.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index 028736687488..fb45e6af6638 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -1375,11 +1375,13 @@ static int dspi_probe(struct platform_device *pdev)
 	ret = spi_register_controller(ctlr);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Problem registering DSPI ctlr\n");
-		goto out_free_irq;
+		goto out_release_dma;
 	}
 
 	return ret;
 
+out_release_dma:
+	dspi_release_dma(dspi);
 out_free_irq:
 	if (dspi->irq)
 		free_irq(dspi->irq, dspi);

