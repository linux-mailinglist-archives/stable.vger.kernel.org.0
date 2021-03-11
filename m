Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BAEB337C8E
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 19:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbhCKSZN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 13:25:13 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:58307 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230266AbhCKSYy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 13:24:54 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id F0BFB1C0F;
        Thu, 11 Mar 2021 13:24:53 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 11 Mar 2021 13:24:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=7AdSOi
        fu3gy01TMF1w8+/5765oFwzAe/ZXP5LZIiMN0=; b=Vtc4U31p5Brxk564cGnPeO
        1CoXMAQ7D5DOuaF5ARGEeYiE2EyrMP7QLSyYPsHHUi+qa4oTQTwguGjpToEUVVNW
        ASA8PceVhbyAr4lpgxcxtavnEMU2zqDSc9ArVXjp1FCad0nUrG+xxAmzlId8miRq
        81pZoiPEd6uoaPrg4lkSBPLRI/jbBYoXyIg2tz7DGToP0KGHAicotm/3o9zBriZg
        RlkE4hAje7HVKRgprmuLGAi5YdhYRqSSZGI2uMXjVRRwnD4jslZ/apomHdjfRXi6
        B9s+eVGsDcGlrINCOlpnWypaHginMBjSw4dVi+rDMOYwQJllPnfjLwBxKT+GaZAg
        ==
X-ME-Sender: <xms:dWBKYPLf8e72vwedY0t-QhQiiV833EW4fYhmMbt1F1M7EJot-y1CKQ>
    <xme:dWBKYMx43DbGB0tN44HudgGqUBjiWlld8tM_YgIIi6qmVCiq-lt_n3nWWV9nRXVjS
    S-EODQWNfE_Vg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvtddguddufecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:dWBKYHuuSGY12ecNfbLux9j19zvshYSlK5uR5P-J9WriqAQLgkaIiA>
    <xmx:dWBKYLvUlpEeo-qZVM0uZrP0pkZgSnoPummGPDOkViu2Zqt-lD5kdQ>
    <xmx:dWBKYEMZh6-S8bMxH1Lp6pEe5szQGXfa0i8ut0tiBRpX-i9-3TGu2g>
    <xmx:dWBKYH5i8WUfgsSiRqaZQBWpMc0LIsY2NBAtyhNow8iERaFQi2yKMAaNirc>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 24DF6108006B;
        Thu, 11 Mar 2021 13:24:53 -0500 (EST)
Subject: FAILED: patch "[PATCH] net: phy: fix save wrong speed and duplex problem if autoneg" failed to apply to 4.19-stable tree
To:     huangguangbin2@huawei.com, davem@davemloft.net,
        tanhuazhong@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 11 Mar 2021 19:24:49 +0100
Message-ID: <1615487089212217@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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

From d9032dba5a2b2bbf0fdce67c8795300ec9923b43 Mon Sep 17 00:00:00 2001
From: Guangbin Huang <huangguangbin2@huawei.com>
Date: Sat, 27 Feb 2021 11:05:58 +0800
Subject: [PATCH] net: phy: fix save wrong speed and duplex problem if autoneg
 is on

If phy uses generic driver and autoneg is on, enter command
"ethtool -s eth0 speed 50" will not change phy speed actually, but
command "ethtool eth0" shows speed is 50Mb/s because phydev->speed
has been set to 50 and no update later.

And duplex setting has same problem too.

However, if autoneg is on, phy only changes speed and duplex according to
phydev->advertising, but not phydev->speed and phydev->duplex. So in this
case, phydev->speed and phydev->duplex don't need to be set in function
phy_ethtool_ksettings_set() if autoneg is on.

Fixes: 51e2a3846eab ("PHY: Avoid unnecessary aneg restarts")
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 1be07e45d314..fc2e7cb5b2e5 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -276,14 +276,16 @@ int phy_ethtool_ksettings_set(struct phy_device *phydev,
 
 	phydev->autoneg = autoneg;
 
-	phydev->speed = speed;
+	if (autoneg == AUTONEG_DISABLE) {
+		phydev->speed = speed;
+		phydev->duplex = duplex;
+	}
 
 	linkmode_copy(phydev->advertising, advertising);
 
 	linkmode_mod_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
 			 phydev->advertising, autoneg == AUTONEG_ENABLE);
 
-	phydev->duplex = duplex;
 	phydev->master_slave_set = cmd->base.master_slave_cfg;
 	phydev->mdix_ctrl = cmd->base.eth_tp_mdix_ctrl;
 

