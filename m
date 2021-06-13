Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 604BD3A581D
	for <lists+stable@lfdr.de>; Sun, 13 Jun 2021 13:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbhFML7W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Jun 2021 07:59:22 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:53657 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231658AbhFML7V (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Jun 2021 07:59:21 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id 67EC319409BD;
        Sun, 13 Jun 2021 07:57:20 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sun, 13 Jun 2021 07:57:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Sx1X3N
        s41oEV0EuSJXVLit1oEoBwkHtu/Ew5YTWdx/o=; b=RsISfEtgB92bvwlMxp1mRZ
        Q2y3gqjodogrrUEujCs/fhCmWIqWcFVLt7ZRFDwGPICCB4qj/txzbryaQDEpBohq
        dhqgNv/W83WAdeDw3B+da5WQqHo+5zl+aARX2OJwNnfjvemSng3Ho3S0DdjbhfpP
        UCMyR4MGJzHIOZFnqaKxJBcyV8tw8sV5f6j4M9Lu8EUbMS4LXLm3HYUL730hodS6
        9DVnq7YnVK9gCNPIuxAZeyf/620jZC158tcVDqpJUd48VIcf9Ge2OmDtGAZwrVvA
        gHhONfgfGY8xtU3m6fGoHc0ljxh3+maSp0wY1GupJkSnZs+5BoPa2oryUL3n6W+g
        ==
X-ME-Sender: <xms:n_LFYNTcGos5_O04vh2yHE2ZFNh5ghDqae7wHvVM0yYXc0hGkJqEOQ>
    <xme:n_LFYGyaPBCyFOj9xMdLsXSuZgHVOixFDxMkc1yv8GIpUTXZzLpTHYE_-uGNSSP9N
    lJmIt0Yr0stEw>
X-ME-Received: <xmr:n_LFYC0ge1eIm80hn5BAUvLfLIQXprSN95lSzkkbw3P5R3grBgPTa2PLqEOiedMKX7G5b_BDsmTaAbJHNYSzxXQ3YQGbaEmK>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvfedggeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkeejgffftefgveeggeehudfgleehkedthedtiefhie
    elieetveejvdfgvdeljeelnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:n_LFYFCNtNJ0nZaNrLunS6N6J5ZSlVIiehDJjtXhVZZJUAjUXQQTCg>
    <xmx:n_LFYGjP2c9Bk91TODXejJsyvU2mEln15DDr9zyKqpqQoTIvwW9O_g>
    <xmx:n_LFYJpb2xQ5qsayar_L9QGf65Blrj-nOl46u5r1S2xYf2qDNqH-UA>
    <xmx:oPLFYHvaFbf5jRXnpnbDk7nn-4Q95aMJ9V-xQgRu8Gq83h0QD0U9mg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 13 Jun 2021 07:57:18 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mmc: renesas_sdhi: abort tuning when timeout detected" failed to apply to 4.14-stable tree
To:     wsa+renesas@sang-engineering.com,
        niklas.soderlund+renesas@ragnatech.se, ulf.hansson@linaro.org,
        yoshihiro.shimoda.uh@renesas.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 13 Jun 2021 13:57:17 +0200
Message-ID: <162358543720629@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From 2c9017d0b5d3fbf17e69577a42d9e610ca122810 Mon Sep 17 00:00:00 2001
From: Wolfram Sang <wsa+renesas@sang-engineering.com>
Date: Wed, 2 Jun 2021 09:34:35 +0200
Subject: [PATCH] mmc: renesas_sdhi: abort tuning when timeout detected
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

We have to bring the eMMC from sending-data state back to transfer state
once we detected a CRC error (timeout) during tuning. So, send a stop
command via mmc_abort_tuning().

Fixes: 4f11997773b6 ("mmc: tmio: Add tuning support")
Reported-by Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/20210602073435.5955-1-wsa+renesas@sang-engineering.com
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/host/renesas_sdhi_core.c b/drivers/mmc/host/renesas_sdhi_core.c
index 635bf31a6735..9029308c4a0f 100644
--- a/drivers/mmc/host/renesas_sdhi_core.c
+++ b/drivers/mmc/host/renesas_sdhi_core.c
@@ -692,14 +692,19 @@ static int renesas_sdhi_execute_tuning(struct mmc_host *mmc, u32 opcode)
 
 	/* Issue CMD19 twice for each tap */
 	for (i = 0; i < 2 * priv->tap_num; i++) {
+		int cmd_error;
+
 		/* Set sampling clock position */
 		sd_scc_write32(host, priv, SH_MOBILE_SDHI_SCC_TAPSET, i % priv->tap_num);
 
-		if (mmc_send_tuning(mmc, opcode, NULL) == 0)
+		if (mmc_send_tuning(mmc, opcode, &cmd_error) == 0)
 			set_bit(i, priv->taps);
 
 		if (sd_scc_read32(host, priv, SH_MOBILE_SDHI_SCC_SMPCMP) == 0)
 			set_bit(i, priv->smpcmp);
+
+		if (cmd_error)
+			mmc_abort_tuning(mmc, opcode);
 	}
 
 	ret = renesas_sdhi_select_tuning(host);

