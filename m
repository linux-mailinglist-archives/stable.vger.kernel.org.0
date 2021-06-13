Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91F103A581E
	for <lists+stable@lfdr.de>; Sun, 13 Jun 2021 13:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231753AbhFML7a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Jun 2021 07:59:30 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:42635 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231658AbhFML73 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Jun 2021 07:59:29 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 33F8019409BD;
        Sun, 13 Jun 2021 07:57:28 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 13 Jun 2021 07:57:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Fc3Szu
        jXOrZHikqeCM8Hk+Aa+NHT4ftF1PJN3RCpL9c=; b=SLuEfppe02M6oqZqGDPvXq
        dCc4Uqhz+0R/I5B8K521wKy69bePeA4VEr0G5NmJ0rBFZ2uzi1KBqh1/K3WH8QOP
        d9Okx90rC90jXqTV6gk/d5h9QUyDUt21YNnHolFKB6mZK33n6rAnhXMAKNJfC9Rv
        7Ma+R3WnGYrqTxvOhOuZrf+83kAUAir0XrkzDk4XcdxAkYtzTFdzHcgv0Q1AY5t1
        bz1L4YHUxvI9Js1ncJycEkwE2RdIWKvM5NjBeeaJat+n9J4maD5/SQ7RHkcvXNwB
        QauyB3N9I7CwX7XhZHGiVnBQTk5mMZuqjpEke6yzI3/unLOd4B8gJfxsf8Rqs9sw
        ==
X-ME-Sender: <xms:qPLFYMYD6rBT6EEippeultt_69hQwVyJRj4YZQidwbfVf_K158-Jhg>
    <xme:qPLFYHabhQnkIsa9pxCuTQlPJh-ld_afoEHV4gQPl7v0UFWoL0ZaaeooOFvbrsyBo
    mcLdO0CtnVhLQ>
X-ME-Received: <xmr:qPLFYG-Nt7NdEci8p6CeSn7qmI_os4YFaBWe1PODD8cNuAP9SWLd-uoijQpYHmlFZ4U23oaCgLiFSeAPSmff6NumA_MnGyLl>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvfedggeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkeejgffftefgveeggeehudfgleehkedthedtiefhie
    elieetveejvdfgvdeljeelnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:qPLFYGpecFdwfXHmJTtgiB_DwcNkODMSiaxIla5vvXd8N_McMSyo3Q>
    <xmx:qPLFYHozp2Fwk24QDjHrsk_Qu5zgSCbPH5Ffy_iMpwnpc5INd6l7Ag>
    <xmx:qPLFYEQjz408KollohjPcEP8xzPTqKkHDPfPjRW8JLTYM7v6PCMqJQ>
    <xmx:qPLFYGUtFynl3mOoCf3DSdTeOXRu-PvIkZ2wBSsuvTa4fwhfG7_RKg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 13 Jun 2021 07:57:27 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mmc: renesas_sdhi: abort tuning when timeout detected" failed to apply to 4.19-stable tree
To:     wsa+renesas@sang-engineering.com,
        niklas.soderlund+renesas@ragnatech.se, ulf.hansson@linaro.org,
        yoshihiro.shimoda.uh@renesas.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 13 Jun 2021 13:57:17 +0200
Message-ID: <16235854378147@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

