Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14054363511
	for <lists+stable@lfdr.de>; Sun, 18 Apr 2021 14:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbhDRMRz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Apr 2021 08:17:55 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:36699 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230096AbhDRMRz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Apr 2021 08:17:55 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 210851AFB;
        Sun, 18 Apr 2021 08:17:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 18 Apr 2021 08:17:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=oh8ndC
        Rmhi1P299tvlTVtKZSVfM1GIGWg2mfXH7ADtU=; b=t8xR16ELWPvzCY8QCw/kMK
        dXuL4fqR6lfp2QYDF6wXeCh+fbCXntgqPl1yeb/47oWvq2GpB0FNG/rspvZlfeHg
        uXU8v4DvgITrlh6QyazQ9jaV2agASmzGOTXayq222dl+CfG21isd29yAadt51kgd
        Pya5QiviNocyWYFZepjPKf2fy9pN7XUYBR8V8ttsz4Z4NJRP0IvTH84Cr7JsnW/A
        s7VslND7nhj/2Gbmgd9zqUgUNbYMBhTQqlfNq1rg811mXoiLPsac/W/v/PGcZwdm
        CNSTTbEtiKoAPlIOUPi0aLiXik1zK5cI1kqVsoIhTLTEgHCM+Vlz/ob5cSHW+KDg
        ==
X-ME-Sender: <xms:VCN8YOQUGKYK7JeEF5BuN8c672mtsPuBj6KGLHlJ1z1ilZySPSmq6A>
    <xme:VCN8YDzZK50pC-JR4pypHBxU9cxmXtD-iVO5Q5XwVkPbuqz_KmDXnQ9FMb5ALziI4
    KdHKBTbe7zDEg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudelkedgkeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepudelhfdvueehvdeftedvffeitedvhfehffdvgfegge
    fhtdetgedvgeeugfehfffgnecuffhomhgrihhnpehgihhthhhusgdrtghomhenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:VCN8YL2-h5MqO59sZlw25YQnpInXlN_8tZuixjc0-foy03j-f9NBQw>
    <xmx:VCN8YKBwScewE_eTMFPOJRwy2Y2tDV2Q-hjOyWBGu0UQJ2sP-x8SSQ>
    <xmx:VCN8YHh4OKXrCxswKA7kLF5dBxoPFBWtWzxLmZbBfeyla5D_RZeLCw>
    <xmx:VCN8YKscPQ2aWpkSbjFWNdnESj1fxAQp0qXPpJMfAHDEPSZowiQuJgsiB5Y>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id C91AE24005A;
        Sun, 18 Apr 2021 08:17:23 -0400 (EDT)
Subject: FAILED: patch "[PATCH] net: phy: marvell: fix detection of PHY on Topaz switches" failed to apply to 4.19-stable tree
To:     pali@kernel.org, andrew@lunn.ch, davem@davemloft.net,
        kabel@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 18 Apr 2021 14:17:22 +0200
Message-ID: <161874824218780@kroah.com>
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

From 1fe976d308acb6374c899a4ee8025a0a016e453e Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Date: Mon, 12 Apr 2021 18:57:39 +0200
Subject: [PATCH] net: phy: marvell: fix detection of PHY on Topaz switches
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Since commit fee2d546414d ("net: phy: marvell: mv88e6390 temperature
sensor reading"), Linux reports the temperature of Topaz hwmon as
constant -75°C.

This is because switches from the Topaz family (88E6141 / 88E6341) have
the address of the temperature sensor register different from Peridot.

This address is instead compatible with 88E1510 PHYs, as was used for
Topaz before the above mentioned commit.

Create a new mapping table between switch family and PHY ID for families
which don't have a model number. And define PHY IDs for Topaz and Peridot
families.

Create a new PHY ID and a new PHY driver for Topaz's internal PHY.
The only difference from Peridot's PHY driver is the HWMON probing
method.

Prior this change Topaz's internal PHY is detected by kernel as:

  PHY [...] driver [Marvell 88E6390] (irq=63)

And afterwards as:

  PHY [...] driver [Marvell 88E6341 Family] (irq=63)

Signed-off-by: Pali Rohár <pali@kernel.org>
BugLink: https://github.com/globalscaletechnologies/linux/issues/1
Fixes: fee2d546414d ("net: phy: marvell: mv88e6390 temperature sensor reading")
Reviewed-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 903d619e08ed..e08bf9377140 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3026,10 +3026,17 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
 	return err;
 }
 
+/* prod_id for switch families which do not have a PHY model number */
+static const u16 family_prod_id_table[] = {
+	[MV88E6XXX_FAMILY_6341] = MV88E6XXX_PORT_SWITCH_ID_PROD_6341,
+	[MV88E6XXX_FAMILY_6390] = MV88E6XXX_PORT_SWITCH_ID_PROD_6390,
+};
+
 static int mv88e6xxx_mdio_read(struct mii_bus *bus, int phy, int reg)
 {
 	struct mv88e6xxx_mdio_bus *mdio_bus = bus->priv;
 	struct mv88e6xxx_chip *chip = mdio_bus->chip;
+	u16 prod_id;
 	u16 val;
 	int err;
 
@@ -3040,23 +3047,12 @@ static int mv88e6xxx_mdio_read(struct mii_bus *bus, int phy, int reg)
 	err = chip->info->ops->phy_read(chip, bus, phy, reg, &val);
 	mv88e6xxx_reg_unlock(chip);
 
-	if (reg == MII_PHYSID2) {
-		/* Some internal PHYs don't have a model number. */
-		if (chip->info->family != MV88E6XXX_FAMILY_6165)
-			/* Then there is the 6165 family. It gets is
-			 * PHYs correct. But it can also have two
-			 * SERDES interfaces in the PHY address
-			 * space. And these don't have a model
-			 * number. But they are not PHYs, so we don't
-			 * want to give them something a PHY driver
-			 * will recognise.
-			 *
-			 * Use the mv88e6390 family model number
-			 * instead, for anything which really could be
-			 * a PHY,
-			 */
-			if (!(val & 0x3f0))
-				val |= MV88E6XXX_PORT_SWITCH_ID_PROD_6390 >> 4;
+	/* Some internal PHYs don't have a model number. */
+	if (reg == MII_PHYSID2 && !(val & 0x3f0) &&
+	    chip->info->family < ARRAY_SIZE(family_prod_id_table)) {
+		prod_id = family_prod_id_table[chip->info->family];
+		if (prod_id)
+			val |= prod_id >> 4;
 	}
 
 	return err ? err : val;
diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index e26a5d663f8a..8018ddf7f316 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -3021,9 +3021,34 @@ static struct phy_driver marvell_drivers[] = {
 		.get_stats = marvell_get_stats,
 	},
 	{
-		.phy_id = MARVELL_PHY_ID_88E6390,
+		.phy_id = MARVELL_PHY_ID_88E6341_FAMILY,
 		.phy_id_mask = MARVELL_PHY_ID_MASK,
-		.name = "Marvell 88E6390",
+		.name = "Marvell 88E6341 Family",
+		/* PHY_GBIT_FEATURES */
+		.flags = PHY_POLL_CABLE_TEST,
+		.probe = m88e1510_probe,
+		.config_init = marvell_config_init,
+		.config_aneg = m88e6390_config_aneg,
+		.read_status = marvell_read_status,
+		.config_intr = marvell_config_intr,
+		.handle_interrupt = marvell_handle_interrupt,
+		.resume = genphy_resume,
+		.suspend = genphy_suspend,
+		.read_page = marvell_read_page,
+		.write_page = marvell_write_page,
+		.get_sset_count = marvell_get_sset_count,
+		.get_strings = marvell_get_strings,
+		.get_stats = marvell_get_stats,
+		.get_tunable = m88e1540_get_tunable,
+		.set_tunable = m88e1540_set_tunable,
+		.cable_test_start = marvell_vct7_cable_test_start,
+		.cable_test_tdr_start = marvell_vct5_cable_test_tdr_start,
+		.cable_test_get_status = marvell_vct7_cable_test_get_status,
+	},
+	{
+		.phy_id = MARVELL_PHY_ID_88E6390_FAMILY,
+		.phy_id_mask = MARVELL_PHY_ID_MASK,
+		.name = "Marvell 88E6390 Family",
 		/* PHY_GBIT_FEATURES */
 		.flags = PHY_POLL_CABLE_TEST,
 		.probe = m88e6390_probe,
@@ -3107,7 +3132,8 @@ static struct mdio_device_id __maybe_unused marvell_tbl[] = {
 	{ MARVELL_PHY_ID_88E1540, MARVELL_PHY_ID_MASK },
 	{ MARVELL_PHY_ID_88E1545, MARVELL_PHY_ID_MASK },
 	{ MARVELL_PHY_ID_88E3016, MARVELL_PHY_ID_MASK },
-	{ MARVELL_PHY_ID_88E6390, MARVELL_PHY_ID_MASK },
+	{ MARVELL_PHY_ID_88E6341_FAMILY, MARVELL_PHY_ID_MASK },
+	{ MARVELL_PHY_ID_88E6390_FAMILY, MARVELL_PHY_ID_MASK },
 	{ MARVELL_PHY_ID_88E1340S, MARVELL_PHY_ID_MASK },
 	{ MARVELL_PHY_ID_88E1548P, MARVELL_PHY_ID_MASK },
 	{ }
diff --git a/include/linux/marvell_phy.h b/include/linux/marvell_phy.h
index 52b1610eae68..c544b70dfbd2 100644
--- a/include/linux/marvell_phy.h
+++ b/include/linux/marvell_phy.h
@@ -28,11 +28,12 @@
 /* Marvel 88E1111 in Finisar SFP module with modified PHY ID */
 #define MARVELL_PHY_ID_88E1111_FINISAR	0x01ff0cc0
 
-/* The MV88e6390 Ethernet switch contains embedded PHYs. These PHYs do
+/* These Ethernet switch families contain embedded PHYs, but they do
  * not have a model ID. So the switch driver traps reads to the ID2
  * register and returns the switch family ID
  */
-#define MARVELL_PHY_ID_88E6390		0x01410f90
+#define MARVELL_PHY_ID_88E6341_FAMILY	0x01410f41
+#define MARVELL_PHY_ID_88E6390_FAMILY	0x01410f90
 
 #define MARVELL_PHY_FAMILY_ID(id)	((id) >> 4)
 

