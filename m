Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1B9342C68
	for <lists+stable@lfdr.de>; Sat, 20 Mar 2021 12:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbhCTLmj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Mar 2021 07:42:39 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:34967 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229985AbhCTLmQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Mar 2021 07:42:16 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 766291940658;
        Sat, 20 Mar 2021 07:42:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 20 Mar 2021 07:42:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=TSdV5j
        qbt5TPMIMUIzc/MFEILHAd/gB5Y2AgGYfMwJc=; b=NBLOGEEFtEOIAR0wfl0AvD
        UJiykzU+Wcd1uv5ZyNo0+b6/HIk/u+EwT6L4VCGGmmcGNsTEJ3TMJ+hvIZr8bwBc
        NzgmqXuuxUSyFi0haPQAaHvd/wn5l7q4SjXGy15EBoOnJbr3j+q/msmDotEEtEiR
        bhnjI8r2l6De1Ll9iHvScYCb6RW11WXuPzzySkrAMev9va+exnxQazOL8sUfCskH
        xjFmpBjS2mNjMx5Sq4Sxl2ePUT4NEgXE+eKmgzrdrnlrdi4UVRYRmnO9kGI9qcDP
        MDW5Uyx88eYHSbh5CWTCBfvKr7xkUqgNOKW9z+AwRl5xF8Go/JBxq+MHYFjS8KzQ
        ==
X-ME-Sender: <xms:l99VYDljfz_hCVd01z1rW2ayKdEX7F10GbkrkekAW2m1B3_QeNrjnQ>
    <xme:l99VYG2R5KqYqJ7-pUnoVCGEXN8kNmj_bz9HoCGf1OPQrE6OYP37LXJ9mvV1nfphW
    hvkq4BHheKEfA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudegtddgvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:l99VYJox1qsOvQ3LUzMgb1s5DEwwWmjNyfEUgfhihLbDQEeZX6wZ1w>
    <xmx:l99VYLnmniUs4IibxRdP4EFoxvUECrfdZ1Rhtah1phqP_vJ1E9IgWA>
    <xmx:l99VYB03wiRTgq-cPHhVwGGqIp7FgayVlYh2fanA785w1vhYuSYSSQ>
    <xmx:l99VYC-w3OXCODhqxHw8wKob8eEIPf92ofIEZFkrA0By1tbxfHJpsw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1508D240113;
        Sat, 20 Mar 2021 07:42:14 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ASoC: fsl_ssi: Fix TDM slot setup for I2S mode" failed to apply to 4.9-stable tree
To:     shc_work@mail.ru, broonie@kernel.org, nicoleotsuka@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 20 Mar 2021 12:42:13 +0100
Message-ID: <161624053312181@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 87263968516fb9507d6215d53f44052627fae8d8 Mon Sep 17 00:00:00 2001
From: Alexander Shiyan <shc_work@mail.ru>
Date: Tue, 16 Feb 2021 14:42:21 +0300
Subject: [PATCH] ASoC: fsl_ssi: Fix TDM slot setup for I2S mode

When using the driver in I2S TDM mode, the _fsl_ssi_set_dai_fmt()
function rewrites the number of slots previously set by the
fsl_ssi_set_dai_tdm_slot() function to 2 by default.
To fix this, let's use the saved slot count value or, if TDM
is not used and the slot count is not set, proceed as before.

Fixes: 4f14f5c11db1 ("ASoC: fsl_ssi: Fix number of words per frame for I2S-slave mode")
Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
Acked-by: Nicolin Chen <nicoleotsuka@gmail.com>
Link: https://lore.kernel.org/r/20210216114221.26635-1-shc_work@mail.ru
Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/sound/soc/fsl/fsl_ssi.c b/sound/soc/fsl/fsl_ssi.c
index 57811743c294..ad8af3f450e2 100644
--- a/sound/soc/fsl/fsl_ssi.c
+++ b/sound/soc/fsl/fsl_ssi.c
@@ -878,6 +878,7 @@ static int fsl_ssi_hw_free(struct snd_pcm_substream *substream,
 static int _fsl_ssi_set_dai_fmt(struct fsl_ssi *ssi, unsigned int fmt)
 {
 	u32 strcr = 0, scr = 0, stcr, srcr, mask;
+	unsigned int slots;
 
 	ssi->dai_fmt = fmt;
 
@@ -909,10 +910,11 @@ static int _fsl_ssi_set_dai_fmt(struct fsl_ssi *ssi, unsigned int fmt)
 			return -EINVAL;
 		}
 
+		slots = ssi->slots ? : 2;
 		regmap_update_bits(ssi->regs, REG_SSI_STCCR,
-				   SSI_SxCCR_DC_MASK, SSI_SxCCR_DC(2));
+				   SSI_SxCCR_DC_MASK, SSI_SxCCR_DC(slots));
 		regmap_update_bits(ssi->regs, REG_SSI_SRCCR,
-				   SSI_SxCCR_DC_MASK, SSI_SxCCR_DC(2));
+				   SSI_SxCCR_DC_MASK, SSI_SxCCR_DC(slots));
 
 		/* Data on rising edge of bclk, frame low, 1clk before data */
 		strcr |= SSI_STCR_TFSI | SSI_STCR_TSCKP | SSI_STCR_TEFS;

