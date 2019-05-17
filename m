Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29731218BE
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 15:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728434AbfEQNBN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 09:01:13 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:40009 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728407AbfEQNBN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 09:01:13 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 7A6482490E;
        Fri, 17 May 2019 09:01:12 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 17 May 2019 09:01:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ZCcr1A
        IXK5KPZCjM1fej2LGZhGAsiVnYOzOsXcxRu4Q=; b=klDNcQW7Ypf7Os8iF70kPd
        E/GZ2DM5tkDIOSdeItC696Gb/C5u2TblyOxEQL2fRGPgv5ojzV31TzzDhd0L2Bf4
        0/C1Qtk0e+xA8HKfhhKkTD4X+E0LuDt3afADF58Pu3kRnRjNwxsoz7spnbl/8GQS
        5g5CTvesD0FJzzuvOCaw1RxjdTqLOZv/0MdI/CbAWdkYmZcph90EHlYAjdWMGLgB
        pGQa5OF40G299vM43qZOefYp+JRFYVtfD7ATXlqK8ZoAi1avfxAewA2efamMj/S1
        4VgJ3fwWW+tQbwrsoL5T2hLxWiX4ABHWCko1Q87m4niMOlRAfj3EA5GEbJzYeJDg
        ==
X-ME-Sender: <xms:l7DeXL7bLv9Pc6fkqsp5ld-RWKZVD19BCfKogDmfWKCxSaWhQY_LpA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddtvddgiedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:mLDeXDiDfauhczFQ0jbN4lSRKaOivjtjJM3uZ82vMrtl7hiACuQSFQ>
    <xmx:mLDeXB_dDqrP5HMMPzFAhMl7fU-XFkDcau8a8HPlvV7VN3NMjRXN5w>
    <xmx:mLDeXNfzFy2YXrNtMscX_7pFmR8EQntp3aIE9ym40_vEYxgnOWtNQw>
    <xmx:mLDeXPeoPoBlLSZ0JWhQ6aJMFtbUx_eP-ESfhEPNg9egf-joilnmag>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9C5D480061;
        Fri, 17 May 2019 09:01:11 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ASoC: fsl_esai: Fix missing break in switch statement" failed to apply to 4.14-stable tree
To:     shengjiu.wang@nxp.com, broonie@kernel.org, nicoleotsuka@gmail.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 17 May 2019 15:00:42 +0200
Message-ID: <155809804222219@kroah.com>
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

From 903c220b1ece12f17c868e43f2243b8f81ff2d4c Mon Sep 17 00:00:00 2001
From: "S.j. Wang" <shengjiu.wang@nxp.com>
Date: Sun, 28 Apr 2019 02:24:27 +0000
Subject: [PATCH] ASoC: fsl_esai: Fix missing break in switch statement

case ESAI_HCKT_EXTAL and case ESAI_HCKR_EXTAL should be
independent of each other, so replace fall-through with break.

Fixes: 43d24e76b698 ("ASoC: fsl_esai: Add ESAI CPU DAI driver")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Acked-by: Nicolin Chen <nicoleotsuka@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/sound/soc/fsl/fsl_esai.c b/sound/soc/fsl/fsl_esai.c
index c7410bbfd2af..bad0dfed6b68 100644
--- a/sound/soc/fsl/fsl_esai.c
+++ b/sound/soc/fsl/fsl_esai.c
@@ -251,7 +251,7 @@ static int fsl_esai_set_dai_sysclk(struct snd_soc_dai *dai, int clk_id,
 		break;
 	case ESAI_HCKT_EXTAL:
 		ecr |= ESAI_ECR_ETI;
-		/* fall through */
+		break;
 	case ESAI_HCKR_EXTAL:
 		ecr |= esai_priv->synchronous ? ESAI_ECR_ETI : ESAI_ECR_ERI;
 		break;

