Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93F76130556
	for <lists+stable@lfdr.de>; Sun,  5 Jan 2020 02:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbgAEBYS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jan 2020 20:24:18 -0500
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:39455 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726264AbgAEBYS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Jan 2020 20:24:18 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id 4AF99680A;
        Sat,  4 Jan 2020 20:24:17 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Sat, 04 Jan 2020 20:24:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=Dy/48p0+s/ET+
        odKrtmc7mwr7XKM2LA6Yht3eu1MaYw=; b=QpxIgctnPZ3mHAnssfna7Js1Rr7DD
        UaQ8O6wSZcj840SbVEGu2CyHLfvnmpPqgJva4qDcrcFbCEG84NeOCLSCCuhmufo6
        rujogvd3Ln/JDbe8tHo+cSBi5lf/jQXVBI+G0dTTo5cHNCab/V/TSmy/bIhg1lUC
        LrPeJIlKLGn7iHz+razqXb+AEq52XC29CLKMO/6gNSDqrG5PJNDceUA+IvIwDxJr
        OFTZXnllTcwjSmFxb6QNmIn+IcJ2bBSf9lkK/kzDjIpcnzolq1OhCgfNPQ8OHQpX
        t+osBJlBj3TphvJlPJUmnW7eb9RQxYXSHlb/vdpqdswdkhRplxnoH3ptQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=Dy/48p0+s/ET+odKrtmc7mwr7XKM2LA6Yht3eu1MaYw=; b=We0UrstP
        9RSLZMwzNQ3GPWwdRcK+ZsyRJn7TH4hmnMsY2IfLjA0yh+ydXqse/zC+UGWcRTaA
        vYyPcla2157BdGD5+8sYhGM5gIE4SpHZrIa8W1287KtlJ4bqHtRN8fzrBUathnNy
        gGBcAmas+tx0oLAL6GqKljCd1gdht04cJtHtpdmcXT6nJ7sp8aWBT3tqYOhNuqu2
        BBqAKKUjRNxPlTxBN45Gp2cFNagXW53gjBoeGrL3mM2zxBX65see6yjWiP4p5A79
        UIDAxQqQOnBjvozfH6TYpIAHy37GJNBdo+ewtfhd+GjSFMf0i7WaWyKOZEF3tmVD
        in55fiszPhJ/Gw==
X-ME-Sender: <xms:wToRXuVB0CQQ7RKmAH6IQSR3LWraGPU9GbCYPBtLRi_xK21kwKL1ow>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdegiedgfeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefurghmuhgv
    lhcujfholhhlrghnugcuoehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhgqeenucfkph
    epjedtrddufeehrddugeekrdduhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehsrghm
    uhgvlhesshhhohhllhgrnhgurdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:wToRXlwK--yvya4Ajp_ACqEm5d8aO_uV-Z2hS6K-TU4rhrS0DNALOA>
    <xmx:wToRXmOPOgMaZCfszGAPsmn5xfG7nemDZISJcSq01lmT8tPoBk0qlA>
    <xmx:wToRXvoEs-TBCmVYue37oRYkrtKIyBgqs5j8FRMQq72qd5ghDeIC1g>
    <xmx:wToRXvrzSl-CIxZlW76y3_CyZU3LO6OEXttpY0eK5wvedo8Q_LTQ8w>
Received: from titanium.stl.sholland.net (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6D58A80059;
        Sat,  4 Jan 2020 20:24:16 -0500 (EST)
From:   Samuel Holland <samuel@sholland.org>
To:     Chen-Yu Tsai <wens@csie.org>, Sebastian Reichel <sre@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Oskari Lemmela <oskari@lemmela.net>,
        Quentin Schulz <quentin.schulz@bootlin.com>
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, Samuel Holland <samuel@sholland.org>,
        stable@vger.kernel.org
Subject: [PATCH v2 1/9] mfd: axp20x: Mark AXP20X_VBUS_IPSOUT_MGMT as volatile
Date:   Sat,  4 Jan 2020 19:24:08 -0600
Message-Id: <20200105012416.23296-2-samuel@sholland.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200105012416.23296-1-samuel@sholland.org>
References: <20200105012416.23296-1-samuel@sholland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On AXP288 and newer PMICs, bit 7 of AXP20X_VBUS_IPSOUT_MGMT can be set
to prevent using the VBUS input. However, when the VBUS unplugged and
plugged back in, the bit automatically resets to zero.

We need to set the register as volatile to prevent regmap from caching
that bit. Otherwise, regcache will think the bit is already set and not
write the register.

Fixes: cd53216625a0 ("mfd: axp20x: Fix axp288 volatile ranges")
Cc: stable@vger.kernel.org
Signed-off-by: Samuel Holland <samuel@sholland.org>
---
 drivers/mfd/axp20x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/axp20x.c b/drivers/mfd/axp20x.c
index a4aaadaa0cb0..aa59496e4376 100644
--- a/drivers/mfd/axp20x.c
+++ b/drivers/mfd/axp20x.c
@@ -126,7 +126,7 @@ static const struct regmap_range axp288_writeable_ranges[] = {
 static const struct regmap_range axp288_volatile_ranges[] = {
 	regmap_reg_range(AXP20X_PWR_INPUT_STATUS, AXP288_POWER_REASON),
 	regmap_reg_range(AXP288_BC_GLOBAL, AXP288_BC_GLOBAL),
-	regmap_reg_range(AXP288_BC_DET_STAT, AXP288_BC_DET_STAT),
+	regmap_reg_range(AXP288_BC_DET_STAT, AXP20X_VBUS_IPSOUT_MGMT),
 	regmap_reg_range(AXP20X_CHRG_BAK_CTRL, AXP20X_CHRG_BAK_CTRL),
 	regmap_reg_range(AXP20X_IRQ1_EN, AXP20X_IPSOUT_V_HIGH_L),
 	regmap_reg_range(AXP20X_TIMER_CTRL, AXP20X_TIMER_CTRL),
-- 
2.23.0

