Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A83C337C8C
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 19:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbhCKSZM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 13:25:12 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:53121 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230182AbhCKSYx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 13:24:53 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.west.internal (Postfix) with ESMTP id 0469C1C0A;
        Thu, 11 Mar 2021 13:24:51 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 11 Mar 2021 13:24:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=SGLMx/
        FpVfB4Vry8qwE3scIZtsIdZa1nUkIjOD4JsDk=; b=g0ZjRsIUn6pXDXKjg9SfEg
        q+BMMQerK8+H+OCF3WxMh7JgBjBapj0vjWtHn731oiukZX6xYko63QUhtcilSJlK
        cp+s1I37TIrP0YiKRWCYjBe7wOuv0L8xmweu0Bx6MEr83B43lgBx94mSyY2CAJe8
        PB5eWIN5OFlYbDX/rlgEx57gaHxgE/FGodgmsHLLUbwBiix3Z1xCegf/m0j0SUmi
        j0WWPlgPRIKsMJ9Kkr8iiwConCtZye+e/tyx3t0HEsrZUkXzpZ+4icXoKkC6GrGy
        qUn5OrhOwuSwN+t/GIIQj8zGJXVkkypGqezYrL8z8L6C2LTBF9wh+Wiw2qnXGXZQ
        ==
X-ME-Sender: <xms:cmBKYP87ZqW3TOlCN8S8rrPxSxthkV0JFHsMCPYN5z9KHeGka0rJ5w>
    <xme:cmBKYLom-B8-ncFkL0rz2cGvBc1lntn8aoBesui0-qHy4airVGW68aLHBEBXqGIIV
    6-fnRUs3XdC_A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvtddguddufecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:cmBKYJ6OEDBglKLXDJDX9C9_S8qF7eQ8NeysT6G7x-55YkSdOQL7jA>
    <xmx:cmBKYDOagZbjVEgbrzIMTnG9f1mrp5FV1Nw-AzfRrI_JsL_gQj94Fw>
    <xmx:cmBKYDODu_UTaxowhIxYYKzyWgPelHjGHTbr0aIp6CAlGa2bA1F4ew>
    <xmx:c2BKYE6_gWPohqBtEL0UwATlSRBvBBlAQ4TUA0K4y4XBIdDlsB5qDsbjhDA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id A8F74240057;
        Thu, 11 Mar 2021 13:24:50 -0500 (EST)
Subject: FAILED: patch "[PATCH] net: phy: fix save wrong speed and duplex problem if autoneg" failed to apply to 5.4-stable tree
To:     huangguangbin2@huawei.com, davem@davemloft.net,
        tanhuazhong@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 11 Mar 2021 19:24:48 +0100
Message-ID: <16154870881524@kroah.com>
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
 

