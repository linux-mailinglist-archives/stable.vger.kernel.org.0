Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B645639513F
	for <lists+stable@lfdr.de>; Sun, 30 May 2021 16:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbhE3OGF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 May 2021 10:06:05 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:51387 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229500AbhE3OGF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 May 2021 10:06:05 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 4713C1940388;
        Sun, 30 May 2021 10:04:27 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 30 May 2021 10:04:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=BxHT28
        wZKjeU32PmcL8ufwJpymEvV0WfJCT9qZ4xB30=; b=hpANhAZj5ijc9nC3+oNgzZ
        c/+YvxWypNB3VfITpNHF/v/eOAOnEeSeo4kWMZ2TyjFVFULXeaSsXV8V24dtQqm8
        9IVAuS1gNRzQG1VYtXPVaXOJ4qB3PPtzrJE9Ejv2EqFQm7IldQy5P5F3VOSKBAGC
        hR08U9bz0rkn+uV3HTBpAsHO73N01iuCiOnKhhUZJ/AkoTR+jwRZzp0l24t3DVb8
        mZFIAvbbpnU/W7rk+b3jykOAHdUsmmt1ODxpl+9oWWnezMzPmVcC7/xmDwYp15w9
        ZaUx6MlFUc22+OkE43j18Fd6SZ0GfGe798MaQRiPlOqU/GTotHUgxKzI49eiqWQw
        ==
X-ME-Sender: <xms:a5uzYPFtUH0VKtDpBd8ZntUnCcvGGJk2tlbB0X7FQn-Acr31Ax9EVQ>
    <xme:a5uzYMVxJz73I6OyI0XOA4Wv_L5X56OcfVpOg9SoKdbWXRhw5KjRXQc0XFpNlYRV_
    l07MwVInGnJyg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeluddgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:a5uzYBLH_pVV3VnyL4Wx9tkwnZLlPv6t5zAFffy_tqmcadfHuKMJTA>
    <xmx:a5uzYNFa0ClWI_OTLMv_c8m_vAxjLjG1XvmLdG5GGToskxLnOpbl0w>
    <xmx:a5uzYFU1PjJ-Q4-Jz2ETRJbvNeSyAIA6-FjbTswR6NXyCIoUqy3EKQ>
    <xmx:a5uzYEePz9bB82krUU2iufCW1D0-o7Ze-dYKHkmkBW-UGcBvLB7Yww>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun, 30 May 2021 10:04:26 -0400 (EDT)
Subject: FAILED: patch "[PATCH] spi: spi-fsl-dspi: Fix a resource leak in an error handling" failed to apply to 4.19-stable tree
To:     christophe.jaillet@wanadoo.fr, broonie@kernel.org,
        olteanv@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 30 May 2021 16:04:23 +0200
Message-ID: <162238346339174@kroah.com>
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

