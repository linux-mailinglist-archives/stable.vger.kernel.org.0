Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 839D1282A3A
	for <lists+stable@lfdr.de>; Sun,  4 Oct 2020 12:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725856AbgJDKgx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Oct 2020 06:36:53 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:38233 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725825AbgJDKgx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Oct 2020 06:36:53 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 556ED194161B;
        Sun,  4 Oct 2020 06:36:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 04 Oct 2020 06:36:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=96lrcA
        XH36YcWs4F2ciHuaicSXMnlhhQkZFULuVRkwE=; b=MYrRdcNSiVB+7x1XdTkWez
        3BkiA0tmuDIjoBQLhYXmKNBXnoLqpIInmKwk6HRMCMzOcU0NG9k0wLunf1qnn2qr
        l/6c+k+3YMCk+jLoNLRg53oAoKVw8qhXZuKpTzon3GFmLxkZf6QunmdhJFqZhkgU
        RZ3TdGK7YhVkSn5bWUeBy6phPmmUmSKhn0W94COF33OzOKN7DGt9EkHnompPR4gf
        dBB5cNmI9+A6WoM6pzmEvAxC0l3yRnJUGlchZd5OaEKlcP6u6xGv5jliNMJr6D+e
        HLGYreZZNIyLB7qu9hyD9IuIgEKfiwdHlt9VV91yHvT/HfEHoB+zcI6BDQYBXnxA
        ==
X-ME-Sender: <xms:xKV5X0OBVjdjJsEdkEyX4fNXYzXZfcxpPJBdtk1rcOPfTGeYC5G0gA>
    <xme:xKV5X69XsdP6aOIYXUjN3Hf63gvIxCqbRYAVZf4cL77lWP7gCQQ1xeeiSHAeZWowa
    9CKBrYkjJbJfw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrgedtgdefvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:xKV5X7Tn_QVWY27a_T1tEe0LFcNm3-NUQ1fmcnsWfO0_DxuJmp8OwA>
    <xmx:xKV5X8vLGqKiuZePgTg4ceO41-bGKxSw_Srej5_eRbulioj0VRl6fw>
    <xmx:xKV5X8fr6D3TNdSzqMVe7e75hrbl1zOGGouTgvGJCH3h8MZFNAIDvQ>
    <xmx:xKV5X0nH9OlDX4xcxWKqyw8m-QPKXyBMv1aGpeDFi6Trhka0wnCfDg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id D38CD3280065;
        Sun,  4 Oct 2020 06:36:51 -0400 (EDT)
Subject: FAILED: patch "[PATCH] gpio: amd-fch: correct logic of GPIO_LINE_DIRECTION" failed to apply to 5.4-stable tree
To:     lists@wildgooses.com, bgolaszewski@baylibre.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 04 Oct 2020 12:37:36 +0200
Message-ID: <160180785641213@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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

From d25e8fdebdad84219b498873300b7f11dd915b88 Mon Sep 17 00:00:00 2001
From: Ed Wildgoose <lists@wildgooses.com>
Date: Mon, 28 Sep 2020 10:44:52 +0100
Subject: [PATCH] gpio: amd-fch: correct logic of GPIO_LINE_DIRECTION

The original commit appears to have the logic reversed in
amd_fch_gpio_get_direction. Also confirmed by observing the value of
"direction" in the sys tree.

Signed-off-by: Ed Wildgoose <lists@wildgooses.com>
Fixes: e09d168f13f0 ("gpio: AMD G-Series PCH gpio driver")
Cc: stable@vger.kernel.org
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

diff --git a/drivers/gpio/gpio-amd-fch.c b/drivers/gpio/gpio-amd-fch.c
index 4e44ba4d7423..2a21354ed6a0 100644
--- a/drivers/gpio/gpio-amd-fch.c
+++ b/drivers/gpio/gpio-amd-fch.c
@@ -92,7 +92,7 @@ static int amd_fch_gpio_get_direction(struct gpio_chip *gc, unsigned int gpio)
 	ret = (readl_relaxed(ptr) & AMD_FCH_GPIO_FLAG_DIRECTION);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	return ret ? GPIO_LINE_DIRECTION_IN : GPIO_LINE_DIRECTION_OUT;
+	return ret ? GPIO_LINE_DIRECTION_OUT : GPIO_LINE_DIRECTION_IN;
 }
 
 static void amd_fch_gpio_set(struct gpio_chip *gc,

