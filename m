Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88CA1342C66
	for <lists+stable@lfdr.de>; Sat, 20 Mar 2021 12:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbhCTLmj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Mar 2021 07:42:39 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:33615 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229445AbhCTLmY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Mar 2021 07:42:24 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id E895B194065B;
        Sat, 20 Mar 2021 07:42:23 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 20 Mar 2021 07:42:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=C3Uqb7
        opw15cL3V8Dbh43cZt4t75g7r46W856oAg/9o=; b=kHat5HQUb7T/LgU1PzT+oA
        QShhwgbhje3MDHCtdzl5d9832Lg47VP0xBOWJSgG4U2VE5MxPv8q+Iax2iU+P5AM
        dEaLGpgno70Ria1jGE91Yh1ki9Nw+3ekO1fW/9DkfzeFQ95jdFsM/R/etnIKwXWX
        kPceg30wD3fgg2dmxV1jcYx4V8dtChWdrADb/xHTU2hw0EpB5zkwO3fALcUw5H48
        sj1hc++NXlCYBpjW/SLIjMXfRmw8jsCojt5cxzYvAdAirt965eDW9K73MJIP73sW
        yFZiRDdhoatJQSUyCaJWZDoCJziNhFdiozy7XSefQD/Q6qHwM903MaViEaTuTuNw
        ==
X-ME-Sender: <xms:n99VYL_DdhjpjK1-fzW3pRDu6ufr2FsUQKbiYDArzCAIYR6ANX7NAQ>
    <xme:n99VYHsOeXz5BkzcvPFmxTyn-bwir5zvKb1uX2cJXOytcPk7V678O1NKZi_Is2Bin
    d5hnSOKyymlGg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudegtddgvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:n99VYJAEUr3j0XHUqw_gI3kCMi05n-_RG329R8Qfqh5KVQQB4TUrxw>
    <xmx:n99VYHe9qKWXwltzg-_94CK2KsPP2M5F_umhoe8G7jziDkCGfd5bSA>
    <xmx:n99VYANaCTui7Yv9yVbCREFSRDFr93xNLffHWNC4nBSvDtLP7zM7Mg>
    <xmx:n99VYK1g944cm8_9xjtKpB9ogPpij-_ifaOVyhw_ZPm_It96OEeX1Q>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6E590108005C;
        Sat, 20 Mar 2021 07:42:23 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ASoC: fsl_ssi: Fix TDM slot setup for I2S mode" failed to apply to 4.14-stable tree
To:     shc_work@mail.ru, broonie@kernel.org, nicoleotsuka@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 20 Mar 2021 12:42:13 +0100
Message-ID: <16162405334974@kroah.com>
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

