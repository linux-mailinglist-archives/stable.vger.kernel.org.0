Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F08D23A581F
	for <lists+stable@lfdr.de>; Sun, 13 Jun 2021 13:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbhFML7h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Jun 2021 07:59:37 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:47439 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231755AbhFML7f (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Jun 2021 07:59:35 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.nyi.internal (Postfix) with ESMTP id 07FB119409B3;
        Sun, 13 Jun 2021 07:57:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 13 Jun 2021 07:57:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=VKzIdb
        6QozblXwZLN9rx84O8CedOWMN/FESHH2XYzpQ=; b=j1JK9hmMslDh9CScq/QqKk
        DN2MsnwidWk5SFu43w185rsD4uQZhi2kzMA13QYWflp7mePQzujFLKnP3TK9x7yE
        V2fQrPjxpQiOp5A9UFKBOIH/bNbmUJoY7MY3mKGYgKjYa4ndnhgGM8lGKAlQ7i4W
        XkNYS25XZfEO5mBb5xjY4CuQGPuAU5hpbHO2wM3RtxDxwokapcuk74PlQrFcnx4Q
        F0Xz2CJ+6/b3kCXB46pHNTfGWi79hKlRQCKAdcA83SKuSZF/pn1OiIJk0mA6bIRH
        D0fzbwu/Y3Mhe4+oCgnsShhQJrmraqR2ooJ+63gduEUSQULvCzf8H9t4S4xp+9Jw
        ==
X-ME-Sender: <xms:q_LFYAuxEUsxsjG4WgJtBVbrKy7Wu_Ru7j430fHv3IWi9a2hvZlpUw>
    <xme:q_LFYNdfsuOMt94l2asb-OI9UtZfGEkN9VTd7ksULFZoV-Uzk9U27GaTbqFDxCa8Z
    FgOUZI9nhyF6w>
X-ME-Received: <xmr:q_LFYLxQoviPXeBZDy9oI57VxN3mKr-sS7tsYGHiBlWlnE-pKaJ6iNbi1ywNJVsreBHse50eV48t9QCa3jPJPNPG8rlmdMfn>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvfedggeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkeejgffftefgveeggeehudfgleehkedthedtiefhie
    elieetveejvdfgvdeljeelnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:q_LFYDO02GudUsWqJ8Ca1BbgPzk1TnrNSqBpfVx15APkoU8ami_7QQ>
    <xmx:q_LFYA9QcjKus3QHNVzGK1rGzQRl6byUAIQqdHcHzETEsLqucbPwPA>
    <xmx:q_LFYLUsVH_V3JJ5JzhSc2SipfXYhPvbonGBxT1XfjRU3QX3H6BKgA>
    <xmx:rPLFYPaTb3hw6I9I5nqcVsZ5VbCkWYDO_-uFL3erQd5rWsREpkCYWA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 13 Jun 2021 07:57:30 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mmc: renesas_sdhi: abort tuning when timeout detected" failed to apply to 5.4-stable tree
To:     wsa+renesas@sang-engineering.com,
        niklas.soderlund+renesas@ragnatech.se, ulf.hansson@linaro.org,
        yoshihiro.shimoda.uh@renesas.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 13 Jun 2021 13:57:18 +0200
Message-ID: <1623585438100234@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
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

