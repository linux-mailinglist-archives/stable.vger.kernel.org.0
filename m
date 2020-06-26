Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4106920B302
	for <lists+stable@lfdr.de>; Fri, 26 Jun 2020 15:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728856AbgFZN7H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 09:59:07 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:55377 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728751AbgFZN7H (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jun 2020 09:59:07 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 06D9A19405BD;
        Fri, 26 Jun 2020 09:59:06 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 26 Jun 2020 09:59:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=7xDoGJ
        JgdOX3WhCfp2vkkAsqViv1ERawN8aDxxrbTnU=; b=lTqfCc2INm3DXClaAKTocl
        BXHY2isfEoAVXybKhKXB1taRTKHn6uztu0zBiJsJ07nXdaaXl0y+2yJodxavdzL/
        2t80xh578RBc3lMA7Jw2NatYFRPuFPAQ068diIR2vlH7FXuaQtllRfSvaXShzleJ
        wFqNAdVoFTdxGLSg0oHA1lvka52lKGe9hdR9HWtchl7Xt9Zd3Fv9DUBMDPmh2vML
        bLxldt1Jwq2c7LC5d8HBuaZ4iVm3OMKSeRh7bRysragmJiV374T96iZYnsET5Q0Q
        N7YKI6TpCBfHIhdxnBRt2rO7JwO4u3WRXAovZnUWH261Qfj335DYMFy1juSWnd5g
        ==
X-ME-Sender: <xms:Kf_1XqMUeSuizoTiF_WqITuuQrvI2m9ox1GNXa3g4G0SyzQUWZXBJw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeluddgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:Kf_1Xo9XUvMv4seTkTpqahGX38qAAOhudEN-VdMDsVtVjIsF05AVCA>
    <xmx:Kf_1XhQa7kVE4DSuVVwK5EIrwQA1My7wEDCDIYp_AnnsNiqcoQEzVQ>
    <xmx:Kf_1Xqt-IlnAhCGX_ZSya00RTIKU0wcYYvPS13ZhAFKXgzIqGRIi0Q>
    <xmx:Kv_1XqnlFD8Vp5p_XznJAmHQA-116SXjGeCyWTa91vgJqX90R99FRA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6CB2C3067927;
        Fri, 26 Jun 2020 09:59:05 -0400 (EDT)
Subject: FAILED: patch "[PATCH] spi: spi-fsl-dspi: Free DMA memory with matching function" failed to apply to 4.14-stable tree
To:     krzk@kernel.org, broonie@kernel.org, stable@vger.kernel.org,
        vladimir.oltean@nxp.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 26 Jun 2020 15:58:59 +0200
Message-ID: <15931799390140@kroah.com>
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

From 03fe7aaf0c3d40ef7feff2bdc7180c146989586a Mon Sep 17 00:00:00 2001
From: Krzysztof Kozlowski <krzk@kernel.org>
Date: Wed, 10 Jun 2020 17:41:57 +0200
Subject: [PATCH] spi: spi-fsl-dspi: Free DMA memory with matching function

Driver allocates DMA memory with dma_alloc_coherent() but frees it with
dma_unmap_single().

This causes DMA warning during system shutdown (with DMA debugging) on
Toradex Colibri VF50 module:

    WARNING: CPU: 0 PID: 1 at ../kernel/dma/debug.c:1036 check_unmap+0x3fc/0xb04
    DMA-API: fsl-edma 40098000.dma-controller: device driver frees DMA memory with wrong function
      [device address=0x0000000087040000] [size=8 bytes] [mapped as coherent] [unmapped as single]
    Hardware name: Freescale Vybrid VF5xx/VF6xx (Device Tree)
      (unwind_backtrace) from [<8010bb34>] (show_stack+0x10/0x14)
      (show_stack) from [<8011ced8>] (__warn+0xf0/0x108)
      (__warn) from [<8011cf64>] (warn_slowpath_fmt+0x74/0xb8)
      (warn_slowpath_fmt) from [<8017d170>] (check_unmap+0x3fc/0xb04)
      (check_unmap) from [<8017d900>] (debug_dma_unmap_page+0x88/0x90)
      (debug_dma_unmap_page) from [<80601d68>] (dspi_release_dma+0x88/0x110)
      (dspi_release_dma) from [<80601e4c>] (dspi_shutdown+0x5c/0x80)
      (dspi_shutdown) from [<805845f8>] (device_shutdown+0x17c/0x220)
      (device_shutdown) from [<80143ef8>] (kernel_restart+0xc/0x50)
      (kernel_restart) from [<801441cc>] (__do_sys_reboot+0x18c/0x210)
      (__do_sys_reboot) from [<80100060>] (ret_fast_syscall+0x0/0x28)
    DMA-API: Mapped at:
     dma_alloc_attrs+0xa4/0x130
     dspi_probe+0x568/0x7b4
     platform_drv_probe+0x6c/0xa4
     really_probe+0x208/0x348
     driver_probe_device+0x5c/0xb4

Fixes: 90ba37033cb9 ("spi: spi-fsl-dspi: Add DMA support for Vybrid")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Acked-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1591803717-11218-1-git-send-email-krzk@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index a35faced0456..58190c94561f 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -588,14 +588,14 @@ static void dspi_release_dma(struct fsl_dspi *dspi)
 		return;
 
 	if (dma->chan_tx) {
-		dma_unmap_single(dma->chan_tx->device->dev, dma->tx_dma_phys,
-				 dma_bufsize, DMA_TO_DEVICE);
+		dma_free_coherent(dma->chan_tx->device->dev, dma_bufsize,
+				  dma->tx_dma_buf, dma->tx_dma_phys);
 		dma_release_channel(dma->chan_tx);
 	}
 
 	if (dma->chan_rx) {
-		dma_unmap_single(dma->chan_rx->device->dev, dma->rx_dma_phys,
-				 dma_bufsize, DMA_FROM_DEVICE);
+		dma_free_coherent(dma->chan_rx->device->dev, dma_bufsize,
+				  dma->rx_dma_buf, dma->rx_dma_phys);
 		dma_release_channel(dma->chan_rx);
 	}
 }

