Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F863337C93
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 19:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbhCKSZP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 13:25:15 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:55107 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230280AbhCKSY5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 13:24:57 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 405401C05;
        Thu, 11 Mar 2021 13:24:56 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 11 Mar 2021 13:24:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=rGzTsY
        zijReXvDJCNkpl50AI/ltYxDBOVwmW8JglPbQ=; b=CKTJfUyNS/KEx/cPwklsxf
        UdQVW8EwXwtn+RBeQjQGQFpWXNZ7awYswwkdf/UoSnmDsu6xJIFvcc3I3P7DvWQV
        HuWqETE7TIpMCyY7vNLMY6dcc6cuV/blM+ePiSUkjWsBiHJ+dhc9ojVtHAsOeqeN
        Mx5K0cn3H+t+Y5t3h4BY6TW7uqPOq/ccnPnCI4x85VMTfSlWIyaqozm52cRy49ix
        8hoyLYLnqCctChP7gYzjjB3LYWYvT0JVVPkT/7qEZwLmQj3wz/q2wKnW8psP1UWb
        uwQT/2WhWmyLB07fpxj97wPDzrSkYYK6yN/RNOS5THBV419KXseX1geIRtvHz5/Q
        ==
X-ME-Sender: <xms:d2BKYAWJ3QWL2Lktw3W4IrK32ZX0tdaQuFFGvJN_g1YJUnPBNcXIJg>
    <xme:d2BKYEnx_3ZNunSMasAt-u6I76yKfeUV7TQcXecrLpdOpCKhIj7gYBApzWH5XPQ_1
    Tyv6Rl1iqyncA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvtddgudduvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:d2BKYEaqbVL_43Gsklomgc2wrq2dwpJwigN5ZDVpIHWWKPxkUTrgkg>
    <xmx:d2BKYPXPF5EuwJzNwSc4d3w8YlXBV5YUH4gamEJcoyIl-kCE7N0VVw>
    <xmx:d2BKYKltGZQnmLYtJXpqvPC19JCLMkvhkVAUNIHbsrTEthmeVJaPdA>
    <xmx:d2BKYOsE-9IyxIy8-r0pUduYVMa4Bi0D7IkBseQbCvClAxHkC4xXzT8-EOc>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id F1D0C24005A;
        Thu, 11 Mar 2021 13:24:54 -0500 (EST)
Subject: FAILED: patch "[PATCH] net: phy: fix save wrong speed and duplex problem if autoneg" failed to apply to 4.9-stable tree
To:     huangguangbin2@huawei.com, davem@davemloft.net,
        tanhuazhong@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 11 Mar 2021 19:24:50 +0100
Message-ID: <16154870902160@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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
 

