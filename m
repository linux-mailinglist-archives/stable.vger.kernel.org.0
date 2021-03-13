Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 669A2339E2D
	for <lists+stable@lfdr.de>; Sat, 13 Mar 2021 14:25:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233590AbhCMNYu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Mar 2021 08:24:50 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:55457 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230441AbhCMNYZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Mar 2021 08:24:25 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 4ACC31941D31;
        Sat, 13 Mar 2021 08:24:24 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 13 Mar 2021 08:24:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=243q77
        udbfzixhf0RT5lSZ61An6zcCAC2QWDPup1E7k=; b=ddu59u0lnob4n2MEGCBP2D
        gif3U/2rFTf6E47whhP9Uad1k32CvspDqf/tcY7tLEfO41wU8g2i8TmLAuiUyoeb
        q707TNHvb5CzsTRIDNGsz6imokJmRifn2M8GBuaB24pJhnlw4Xz8JYKlotltA8ZH
        sFNHrN6dex/xY6iSEa3mUDZkN/F4WUijRKjvz4wBMa5DP/1hof2Tq+IjW/bBFFbo
        v6usvrrrFz0xlu/K2PKfcxtG/2LTvOgnTCVa6SgZmNt9Of211ZDecRf/vQB0t0hx
        Moq5AmS+CArNXutvqx7WeBqwzai42azqPu3eMBRZ/JUdQJiQfFPq/eigghrDl/Zw
        ==
X-ME-Sender: <xms:B71MYANM6ZlCqz-1sNTjlOSvkLvM3_ySETS-GZruH8_b2CyuQodXIw>
    <xme:B71MYG8rWhfIwjgvueN4bqxefIYaCQAB3-HuNh7WmRILq-cxvCvbozJTz3cPCyqJF
    H9mUmX8ps-9HQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvgedghedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:B71MYHSQHjieniv6kepOCflgXAboBLANbWNk-j2dNM1E7wZIWJThWw>
    <xmx:B71MYIsln2KHcIoelsyR8IugNM5UDgVmxSNyy9UkNSgld_0gbDDjxQ>
    <xmx:B71MYIei5VvicYZvfSjQ0OBfN_PF5RJJWsu-oJUF284BC8Zba_DaZQ>
    <xmx:CL1MYAnIuUyzFALY09QdatUNnS4DgzKq6MUeko9WTyzo7Q2lK6SjRQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 911CD24005A;
        Sat, 13 Mar 2021 08:24:23 -0500 (EST)
Subject: FAILED: patch "[PATCH] regulator: pca9450: Clear PRESET_EN bit to fix BUCK1/2/3" failed to apply to 5.11-stable tree
To:     frieder.schrempf@kontron.de, broonie@kernel.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Mar 2021 14:24:22 +0100
Message-ID: <1615641862226189@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.11-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 98b94b6e38ca0c4eeb29949c656f6a315000c23e Mon Sep 17 00:00:00 2001
From: Frieder Schrempf <frieder.schrempf@kontron.de>
Date: Mon, 22 Feb 2021 12:52:20 +0100
Subject: [PATCH] regulator: pca9450: Clear PRESET_EN bit to fix BUCK1/2/3
 voltage setting

The driver uses the DVS registers PCA9450_REG_BUCKxOUT_DVS0 to set the
voltage for the buck regulators 1, 2 and 3. This has no effect as the
PRESET_EN bit is set by default and therefore the preset values are used
instead, which are set to 850 mV.

To fix this we clear the PRESET_EN bit at time of initialization.

Fixes: 0935ff5f1f0a ("regulator: pca9450: add pca9450 pmic driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Link: https://lore.kernel.org/r/20210222115229.166620-1-frieder.schrempf@kontron.de
Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/drivers/regulator/pca9450-regulator.c b/drivers/regulator/pca9450-regulator.c
index 89b806be399f..2f7ee212cb8c 100644
--- a/drivers/regulator/pca9450-regulator.c
+++ b/drivers/regulator/pca9450-regulator.c
@@ -797,6 +797,14 @@ static int pca9450_i2c_probe(struct i2c_client *i2c,
 		return ret;
 	}
 
+	/* Clear PRESET_EN bit in BUCK123_DVS to use DVS registers */
+	ret = regmap_clear_bits(pca9450->regmap, PCA9450_REG_BUCK123_DVS,
+				BUCK123_PRESET_EN);
+	if (ret) {
+		dev_err(&i2c->dev, "Failed to clear PRESET_EN bit: %d\n", ret);
+		return ret;
+	}
+
 	/* Set reset behavior on assertion of WDOG_B signal */
 	ret = regmap_update_bits(pca9450->regmap, PCA9450_REG_RESET_CTRL,
 				WDOG_B_CFG_MASK, WDOG_B_CFG_COLD_LDO12);
diff --git a/include/linux/regulator/pca9450.h b/include/linux/regulator/pca9450.h
index ccdb5320a240..71902f41c919 100644
--- a/include/linux/regulator/pca9450.h
+++ b/include/linux/regulator/pca9450.h
@@ -147,6 +147,9 @@ enum {
 #define BUCK6_FPWM			0x04
 #define BUCK6_ENMODE_MASK		0x03
 
+/* PCA9450_REG_BUCK123_PRESET_EN bit */
+#define BUCK123_PRESET_EN		0x80
+
 /* PCA9450_BUCK1OUT_DVS0 bits */
 #define BUCK1OUT_DVS0_MASK		0x7F
 #define BUCK1OUT_DVS0_DEFAULT		0x14

