Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59A8F339E30
	for <lists+stable@lfdr.de>; Sat, 13 Mar 2021 14:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbhCMNYu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Mar 2021 08:24:50 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:54513 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233529AbhCMNYc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Mar 2021 08:24:32 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 4E8321941D2B;
        Sat, 13 Mar 2021 08:24:32 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 13 Mar 2021 08:24:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=fgloRI
        /jeSq8kqU37O5vi94vRs031YBBL2eIz6igB/s=; b=cJlkALR8KkAut4miAthqTK
        /7KoUCDDLenrrPWHivR7KfHcfIz6n3pbYrd0qdsp2UxRYZu222buu8YwNhGpznh9
        fq9hC70SIeqWLZ+MGxUBceRe7f/9D7ixxdQ8LakhOo88fOGGLzU2ZDzDWGBvDWR0
        9O8b+WmI8GPsSHwP6nmRbRLvdP/lp+oLR0wxTYWaj3P1QFVe9f8kAv9N39wects6
        CM9/wN/NicCE0aqZ3ZlFu9v8XoCFFknbHmQenSL5cp+RIOF6SVlailuMWl7nnC1H
        7eH+lOnTcGdk2vZkWgGln1+KIfCUlLp7S82M61/5iBfihaKNFq42haQJ9t7dUD1g
        ==
X-ME-Sender: <xms:EL1MYKZDCpT_B08fIRUhNpcr87zbiTVTdQpb4Q-XP1vfzSonYRlqJw>
    <xme:EL1MYNYNJNq4vFvDUtfGvJNCltT5xhxxzQUM9KJ7Z-zhuFse9xreYr_RsvaCEDsxh
    IZ6dO9m3i8bHw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvgedghedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:EL1MYE-AcJIszcofVx7oYkQTaKzD5vK39bhJWTQgzANZ72QWol0TbA>
    <xmx:EL1MYMoH5XxoI_XMbt0cQFhGA_SRZBLbZSiFDu-7l1L9Qd_xwy3jNg>
    <xmx:EL1MYFqR_4iVncML6a3ZJ40n56dlTIln5fmXN1JJIHzSOag6xz_vXA>
    <xmx:EL1MYES46YQxkidHhbWgwAse6SUKrRIAx5GgQiuUgIgwg5EgYq-maA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id F0BF51080054;
        Sat, 13 Mar 2021 08:24:31 -0500 (EST)
Subject: FAILED: patch "[PATCH] regulator: pca9450: Clear PRESET_EN bit to fix BUCK1/2/3" failed to apply to 5.10-stable tree
To:     frieder.schrempf@kontron.de, broonie@kernel.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Mar 2021 14:24:22 +0100
Message-ID: <1615641862252127@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
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

